#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <sys/wait.h>
#include <time.h>


#define VALUE_LIMIT 50000000000

typedef struct {
    int start_idx;
    int end_idx;
    int count;
} ThreadData;

long long fibonacci(int n) {
    if (n <= 1) return n;
    long long a = 0, b = 1, c;
    for (int i = 2; i <= n; i++) {
        c = a + b;
        a = b;
        b = c;
    }
    return b;
}

void* thread_work(void* arg) {
    ThreadData* data = (ThreadData*)arg;
    data->count = 0;

    for (int n = data->start_idx; n <= data->end_idx; n++) {
        long long fib_num = fibonacci(n);
        //printf("liczba %d ciągu fibbonaciego: %lld \n", n, fib_num);
        if (fib_num <= VALUE_LIMIT) {
            data->count++;
        } else {
            break;
        }
    }

    pthread_exit(NULL);
}

int process_work(int start_idx, int end_idx, int threads_per_process) {
    pthread_t threads[threads_per_process];
    ThreadData thread_data[threads_per_process];

    int chunk = (end_idx - start_idx + 1) / threads_per_process;
    for (int i = 0; i < threads_per_process; i++) {
        thread_data[i].start_idx = start_idx + i * chunk;
        thread_data[i].end_idx = (i == threads_per_process - 1) ? end_idx : start_idx + (i + 1) * chunk - 1;
        pthread_create(&threads[i], NULL, thread_work, &thread_data[i]);
    }

    int total = 0;
    for (int i = 0; i < threads_per_process; i++) {
        pthread_join(threads[i], NULL);
        total += thread_data[i].count;
    }
    exit(total);
    return(total);
}

long long compute(int num_processes, int threads_per_process) {
    pid_t pids[num_processes];
    int initial_range = 50;
    int chunk = initial_range / num_processes;
    int op[num_processes];

    for (int i = 0; i < num_processes; i++) {
        int start = i * chunk;
        int end = (i == num_processes - 1) ? initial_range : (i + 1) * chunk - 1;

        pids[i] = fork();
        if (pids[i] == 0) {
            op[i] = process_work(start, end, threads_per_process);
        }
    }

    int global_count = 0;
    for (int i = 0; i < num_processes; i++) {
        int status;
        waitpid(pids[i], &status, 0);
        //global_count += &op[i];
        printf("%ls \n", &op[i]);
    }

    return global_count;
}

void computeAndCount(int num_processes, int threads_per_process) {
    clock_t start = clock();

    unsigned long long result = compute(num_processes, threads_per_process);
    printf("operacje: %llu\n", result);
    double time_taken = (double)(clock() - start) / CLOCKS_PER_SEC * 1000 ;
    //double time_taken = clock() - start;
    printf("Total time: %.4f s\n", time_taken);
}

int main() {
    // int processes[] = {1, 2, 3, 4};
    // int threads[] = {1, 2, 3, 4, 5, 6};
    int proces = 1;
    int thread;
    while(1)
    {
        printf("ile chcesz mieć procesow?\n");
        scanf("%d", &proces);
        if(proces == 0){
            break;
        }
        printf("ile chcesz mieć wątków?\n");
        scanf("%d", &thread); 
        printf("\n- %d processses %d threads \n", proces, thread);    
        computeAndCount(proces, thread);  
    }
    printf("\nkoniec\n");


    // for (int i = 0; i < sizeof(processes) / sizeof(processes[0]); i++) {
    //     printf("\n-----------------%d processes ------------------\n", processes[i]);
    //     for (int j = 0; j < sizeof(threads) / sizeof(threads[0]); j++) {
    //         printf("\n- %d threads \n", threads[j]);           
    //         computeAndCount(processes[i], threads[j]);
    //     }
    // }

    return 0;
}

