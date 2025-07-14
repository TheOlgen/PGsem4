#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <sys/wait.h>
#include <semaphore.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define ODCZYT 0    // define indeksu semafora do odczytu (pomocniczo)
#define ZAPIS 1     // define indeksu semafora do zapisu (pomocniczo)

typedef struct {
    int *numbers;               // jakie liczby do sprawdzenia
    int *results;               // tablica wyników (0, 1)
    int size;                   // ile liczb do sprawdzenia
    int *current_index;         // obecny index :)))
    pthread_mutex_t *mutex;     // semafor do blokowania sekcji krytycznej - każdy wątek jest podpięty do tego samego
} ThreadData;                   // potrzebny tutaj, bo void *worker musi mieć do niego dostęp


int is_prime(int n) {           // funkcja sprawdzająca, czy n jest pierwsza - simple as that
    if (n <= 1) return 0;
    if (n == 2) return 1;
    if (n % 2 == 0) return 0;
    for (int i = 3; i * i <= n; i += 2)
        if (n % i == 0) return 0;
    return 1;
}

void *worker(void *arg) {
    ThreadData *data = (ThreadData *)arg;
    while (1) {
        pthread_mutex_lock(data->mutex);                // BLOKADA SEKCJI KRYTYCZNEJ
        if (*(data->current_index) >= data->size) {
            pthread_mutex_unlock(data->mutex);          // zwalniamy szybciej, bo już wszystko zrobiliśmy :))
            break;
        }
        int idx = (*(data->current_index))++;           // musieliśmy zablokować, aby inny dziad proces nie zrobił tego w tym samym czasie :)))
        pthread_mutex_unlock(data->mutex);              // UNBLOKADA - skończyliśmy 

        int number = data->numbers[idx];                // wyciągamy nasz numerek do sprawdzenia - jest tylko nasz, więc sprawdzamy to poza sekcją krytyczną :))
        data->results[idx] = is_prime(number);          // liczymy
    }
    return NULL;
}

// process_id - do ładnego wyświetlania, numbers - tablica liczb do sprawdzenia
// size - ile liczb sprawdzamy (pomocniczo), num_threads - ile wątków ma proces stworzyć
// potok - do komunikacji z procesem rodzica, który zbiera wyniki (ile liczb pierwszych) u siebie
void process_task(int process_id, int *numbers, int size, int num_threads, int potok) {
    printf("Process %d: starting with %d numbers\n", process_id, size);     // ładne wypisanie
    int *results = malloc(size * sizeof(int));                              // riki-tiki, tablica-wyniki
    pthread_t *threads = malloc(num_threads * sizeof(pthread_t));           // miejsce na wątki
    int current_index = 0;
    pthread_mutex_t mutex;                                                  // TU TWORZYMY SEMAFOOOR
    pthread_mutex_init(&mutex, NULL);

    ThreadData data = {numbers, results, size, &current_index, &mutex};     // KAŻDY WĄTEK PRACUJE NA TYCH SAMYCH DANYCH
                                                                            // TO CO ROBI JEST ZALEŻNE OD CURRENT_INDEX!!!
    for (int i = 0; i < num_threads; i++) {
        pthread_create(&threads[i], NULL, worker, &data);                   // tworzymy wątki
    }

    for (int i = 0; i < num_threads; i++) {
        pthread_join(threads[i], NULL);                                     // czekamy, aż wątki wszystko zrobią :))
    }

    // ŁADNE WYPISANIE <3
    for (int i = 0; i < size; i++) {
        printf("Process %d: %d is %s\n", process_id, numbers[i], results[i] ? "prime" : "not prime");
    }

    // ZLICZANIE LICZB PIERWSZYCH
    int count = 0;
    for (int i = 0; i < size; i++) {
        if (results[i]) {
            count++;
        }
    }

    if (write(potok, &count, sizeof(int)) == -1) {      // tutaj wysyłamy to pipem (potokiem anonimowym) do procesu macierzystego
        perror("write to pipe");
    }

    // czyszczenie :))
    pthread_mutex_destroy(&mutex);
    free(results);
    free(threads);
}

int main(int argc, char *argv[]) {
    if (argc != 3) {                                    // sprawdzenie liczby argumentów (tutaj: liczba procesów, liczba wątkó na proces)
        fprintf(stderr, "Usage: %s P W\n", argv[0]);
        exit(1);
    }

    int P = atoi(argv[1]);      // ile procesów
    int W = atoi(argv[2]);      // ile wątków w procesie

    mkfifo("zadania.in", 0666); // tworzymy fifo - potok nazwany (tutaj: zadania.in), 0666 - rw- dla wszystkich użytkowników (110 binarnie)

    while (1) {
        int read_fd = open("zadania.in", O_RDONLY);     // otworzenie zadania.in tylko do odczytu - proces macierzysty tylko pobiera zadania :)
        if (read_fd == -1) {                            // zwraca "deskryptor pliku, czyli niskopoziomowy uchwyt"
            perror("open read");
            exit(1);
        }

        FILE *fifo = fdopen(read_fd, "r");              // zamieniamy fd na obiekt FILE*, na którym możemy używać np. fgets
        if (!fifo) {
            perror("fdopen");
            close(read_fd);
            exit(1);
        }

        printf("Oczekiwanie na polecenie...\n");

        char line[256];                                 // bufor, gdzie trzymamy polecenie
        while (fgets(line, sizeof(line), fifo)) {       // czytanie
            line[strcspn(line, "\n")] = 0;              // usuwanie znaku nowej linii (enter)
            printf("Received command: %s\n", line);

            if (strcmp(line, "EXIT") == 0) {            // EXIT - wyjście z programu
                printf("Exiting program.\n");
                fclose(fifo);                           // zamknięcie potoku nazwanego
                unlink("zadania.in");
                exit(0);
            }

            int start_range, end_range;     // zmienne przechowujące dane dla programu
            char output_filename[128];
            if (sscanf(line, "%d %d %127s", &start_range, &end_range, output_filename) != 3) {      // pobieranie do tych zmiennych
                fprintf(stderr, "Invalid task format: %s\n", line);
                continue;
            }

            int Z = end_range - start_range + 1;    // ile faktycznie będziemy sprawdzać liczb (zakładam, że z końcami zakresów włącznie)
            if (Z <= 0) {
                fprintf(stderr, "Invalid range: %d to %d\n", start_range, end_range);
                continue;
            }

            int potok[2];               // TO JEST TEN NASZ POTOK NIENAZWANY DO PRZESYŁANIA WYNIKÓW 
            if (pipe(potok) == -1) {
                perror("pipe");
                exit(1);
            }

            int numbers_per_process = Z / P;    // minimalna liczba liczb do sprawdzenia
            int remaining = Z % P;              // reszta (do rozdzielenia między pierwsze procesy)
            int current = start_range;          // obecna cyfra (do wypełniania tablicy)

            int num_of_primes = 0;              // DO TEJ LICZBY DODAJEMY TO, CO PRZYJDZIE Z PIPE'A

            // pętla procesowa
            for (int i = 0; i < P; i++) {       
                int count = numbers_per_process + (i < remaining ? 1 : 0);  // ostateczna liczba liczb do sprawdzenia
                int *numbers = malloc(count * sizeof(int));                 // alokacja pamięci dla liczb do sprawdzenia
                for (int j = 0; j < count; j++) {
                    numbers[j] = current++;             // wypełnianie tablicy
                }

                pid_t pid = fork();     // tworzymy dziecko - proces, który ma count liczb do sprawdzenia
                if (pid == 0) {         // co robi dziecko:
                    close(potok[ODCZYT]);                               // zamykamy odczyt (dziecko pisze)
                    process_task(i, numbers, count, W, potok[ZAPIS]);   // dziecko robi robotę - tam ZAPISUJE DO POTOKU
                    free(numbers);                                      // zwalniamy tablicę - wszystko policzone :))
                    close(potok[ZAPIS]);                                // zamykamy potok - wszystko już napisane :)
                    exit(0);
                } else {                // co robi rodzic:
                    free(numbers);      // zwalnia tablicę numerów, bo nie jest mu potrzebna :))
                }
            }

            close(potok[ZAPIS]);    // już nie zapisujemy

            // TUTAJ POBIERAMY Z PIPE'A WYNIKI I DODAJEMY DO SUMY
            for (int i = 0; i < P; i++) {
                int partial_sum;
                if (read(potok[ODCZYT], &partial_sum, sizeof(int)) > 0) {
                    num_of_primes += partial_sum;
                } else {
                    perror("read from pipe");
                }
            }

            close(potok[ODCZYT]);   // już nie czytamy (wszystko mamy)

            for (int i = 0; i < P; i++) {
                wait(NULL);
            }

            // ZAPISANIE DO PLIKU .OUT WYNIKÓW (liczba liczb pierwszych)
            FILE *out = fopen(output_filename, "w");
            if (out) {
                fprintf(out, "Liczba liczb pierwszych w zakresie [%d, %d]: %d\n", start_range, end_range, num_of_primes);
                fclose(out);
                printf("Wynik zapisany do %s\n", output_filename);
            } else {
                perror("Błąd zapisu do pliku");
            }

            // czyszczenie potoku po zakończeniu zadania - bez tego robiło śmieci
            printf("Czyszczenie potoku...\n");
            while (fgets(line, sizeof(line), fifo)) {
                printf("Wyczyszczono dodatkowe polecenie: %s\n", line);
            }
        }

        fclose(fifo);
        printf("Oczekiwanie na nowe dane...\n");
    }

    return 0;
}
