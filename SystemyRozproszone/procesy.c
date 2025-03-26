#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include "list.c"


int main() {

    int tab[] = {10, 7, 9};
    struct list *lista = makeList(tab, 3);

    for (int i = 0; i < 4; i++) {
        pid_t pid = fork();
        if (pid == 0) { // Kod dla procesów potomnych
            if (i == 0) {
                printf("Proces %d: dodaje 17\n", getpid());
                insert(lista, 17);
            } else if (i == 1) {
                printf("Proces %d: dodaje 19 na pozycję 3\n", getpid());
                insertAt(lista, 19, 3);
            } else if (i == 2) {
                printf("Proces %d: dodaje 5 pierwszych cyfr\n", getpid());
                for(int i = 0; i<5; i++){
                    insert(lista, i);
                }
                printList(lista);
            } else if (i == 3) {
                printf("Proces %d: dodaje 21\n", getpid());
                insert(lista, 21);
            }
            printList(lista);

            exit(0);
        }
    }

    printf("Lista końcowa:\n");
    printList(lista);

    
    return 0;
}
