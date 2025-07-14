#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#include <fcntl.h>
#include <sys/stat.h>

typedef struct {
    int *values;
    int *flags;
    int total;
    int *index_ptr;
    pthread_mutex_t *lock;
} JobInfo;

int is_power(int n) {
    if (n <= 1) return 0;

    for (int base = 2; base * base <= n; base++) {
        int result = base * base;
        while (result <= n && result > 0) {
            if (result == n) return 1;
            result *= base;
        }
    }
    return 0;
}

void* thread_task(void *arg) {
    JobInfo *info = (JobInfo *)arg;
    while (1) {
        pthread_mutex_lock(info->lock);
        if (*(info->index_ptr) >= info->total) {
            pthread_mutex_unlock(info->lock);
            break;
        }
        int idx = (*(info->index_ptr))++;
        pthread_mutex_unlock(info->lock);

        int value = info->values[idx];
        info->flags[idx] = is_power(value);
    }
    return NULL;
}

void handle_process(int pid_num, int *nums, int count, int threads_num, int write_pipe) {
    printf("Proc %d: analizuję %d wartości\n", pid_num, count);
    int *results = malloc(count * sizeof(int));
    pthread_t *threads = malloc(threads_num * sizeof(pthread_t));
    int index = 0;
    pthread_mutex_t mutex;
    pthread_mutex_init(&mutex, NULL);

    JobInfo task = {nums, results, count, &index, &mutex};

    for (int i = 0; i < threads_num; i++) {
        pthread_create(&threads[i], NULL, thread_task, &task);
    }
    for (int i = 0; i < threads_num; i++) {
        pthread_join(threads[i], NULL);
    }

    int power_count = 0;
    for (int i = 0; i < count; i++) {
        printf("Proc %d: %d -> %s\n", pid_num, nums[i], results[i] ? "POWER" : "NOPE");
        if (results[i]) power_count++;
    }

    write(write_pipe, &power_count, sizeof(int));

    pthread_mutex_destroy(&mutex);
    free(results);
    free(threads);
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Użycie: %s liczba_procesów liczba_wątków\n", argv[0]);
        return 1;
    }

    int proc_count = atoi(argv[1]);
    int thread_count = atoi(argv[2]);

    mkfifo("zadania.in", 0666);

    while (1) {
        int fd = open("zadania.in", O_RDONLY);
        if (fd == -1) {
            perror("open fifo");
            exit(1);
        }

        FILE *fifo_file = fdopen(fd, "r");
        if (!fifo_file) {
            perror("fdopen");
            close(fd);
            exit(1);
        }

        printf("Czekam na zadanie...\n");

        char input[256];
        while (fgets(input, sizeof(input), fifo_file)) {
            input[strcspn(input, "\n")] = 0;
            printf("Odebrano: %s\n", input);

            if (strcmp(input, "EXIT") == 0) {
                printf("Zamykam program.\n");
                fclose(fifo_file);
                unlink("zadania.in");
                return 0;
            }

            int from, to;
            char filename[128];
            if (sscanf(input, "%d %d %127s", &from, &to, filename) != 3) {
                fprintf(stderr, "Zła składnia: %s\n", input);
                continue;
            }

            int range = to - from + 1;
            if (range <= 0) {
                fprintf(stderr, "Nieprawidłowy zakres: %d-%d\n", from, to);
                continue;
            }

            int pipe_fd[2];
            if (pipe(pipe_fd) == -1) {
                perror("pipe");
                exit(1);
            }

            int base_count = range / proc_count;
            int rest = range % proc_count;
            int current = from;
            int total_powers = 0;

            for (int i = 0; i < proc_count; i++) {
                int part = base_count + (i < rest ? 1 : 0);
                int *segment = malloc(part * sizeof(int));
                for (int j = 0; j < part; j++) {
                    segment[j] = current++;
                }

                pid_t pid = fork();
                if (pid == 0) {
                    close(pipe_fd[0]);
                    handle_process(i, segment, part, thread_count, pipe_fd[1]);
                    free(segment);
                    close(pipe_fd[1]);
                    exit(0);
                } else {
                    free(segment);
                }
            }

            close(pipe_fd[1]);
            for (int i = 0; i < proc_count; i++) {
                int part_sum;
                if (read(pipe_fd[0], &part_sum, sizeof(int)) > 0) {
                    total_powers += part_sum;
                } else {
                    perror("read");
                }
            }
            close(pipe_fd[0]);

            for (int i = 0; i < proc_count; i++) {
                wait(NULL);
            }

            FILE *out = fopen(filename, "w");
            if (out) {
                fprintf(out, "Liczb będących potęgą całkowitą w [%d, %d]: %d\n", from, to, total_powers);
                fclose(out);
                printf("Zapisano do: %s\n", filename);
            } else {
                perror("zapis do pliku");
            }
        }

        fclose(fifo_file);
    }

    return 0;
}
