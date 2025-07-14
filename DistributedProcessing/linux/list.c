#include <stdio.h>
#include <stdlib.h>

struct node {
    struct node* prev;
    struct node* next;
    int number;
};

struct list {
    struct node* first;
    struct node* last;
    int size;
};

int At(struct list* lista, int position)
{
    if (position < 0 || position >= lista->size) {
        printf("Nieprawidłowa pozycja!\n");
        return 0;
    }
    struct node* node = lista->first;
    // Przejście do węzła na danej pozycji
    for (int i = 0; i < position; i++) 
    {
        node = node->next;
    }
    printf("Liczba na pozycji %d to: %d \n", position, node->number);
    return node->number;
}

void insert(struct list* lista, int num)
{
    struct node* node = (struct node*)malloc(sizeof(struct node));
    if (node == NULL) 
    {
        printf("Błąd alokacji pamięci\n");
        return;
    }
    node->number = num;
    node->next = NULL;
    node->prev = lista->last;
    if (lista->last) 
    {
        lista->last->next = node;
    }
    lista->last = node;
    lista->size += 1;
    printf("Dodano %d do listy\n", num);
}

void insertAt(struct list* lista, int num, int insertHere)
{
    struct node* newNode = (struct node*)malloc(sizeof(struct node));
    if (newNode == NULL) {
        printf("Błąd alokacji pamięci\n");
        return;
    }
    newNode->number = num;
    if (insertHere == 0) {
        newNode->prev = NULL;
        newNode->next = lista->first;
        if (lista->first) {
            lista->first->prev = newNode;
        }
        lista->first = newNode;
        if (lista->size == 0) {
            lista->last = newNode;
        }
    }
    else {
        struct node* node = lista->first;
        for (int i = 1; i < insertHere && node->next != NULL; i++) {
            node = node->next;
        }
        newNode->prev = node;
        newNode->next = node->next;
        if (node->next) {
            node->next->prev = newNode;
        }
        else {
            lista->last = newNode;
        }
        node->next = newNode;
    }
    lista->size += 1;
    printf("Dodano %d do listy, na pozycji %d \n", num, insertHere);
}

struct list* makeList(int* data, int len)
{
    struct node* first = (struct node*)malloc(sizeof(struct node));
    if (first == NULL) {
        printf("Błąd alokacji pamięci\n");
        return NULL;
    }

    first->next = NULL;
    first->prev = NULL;
    first->number = *data;

    struct list* lista = (struct list*)malloc(sizeof(struct list));
    if (lista == NULL) {
        printf("Błąd alokacji pamięci\n");
        free(first);
        return NULL;
    }

    lista->size = 1;
    lista->first = first;
    lista->last = first;

    for (int i = 1; i < len; i++) {
        insert(lista, data[i]);
    }
    printf("Stworzono liste: \n");
    return lista;
}

void printList(struct list* lista)
{
    struct node* node = lista->first;
    while (node != NULL) {
        printf("%d ", node->number);
        node = node->next;
    }
    printf("\n \n");
}

void deleteNode(struct list* lista, int position)
{
    if (position < 0 || position >= lista->size) {
        printf("Nieprawidłowa pozycja!\n");
        return;
    }
    struct node* node = lista->first;
    // Przejście do węzła na danej pozycji
    for (int i = 0; i < position; i++) 
    {
        node = node->next;
    }
    if (node->prev) {    // Jeśli usuwamy pierwszy element
        node->prev->next = node->next;
    }
    else {
        lista->first = node->next;
    }

    if (node->next) {    // Jeśli usuwamy ostatni element
        node->next->prev = node->prev;
    }
    else {
        lista->last = node->prev;
    }
    free(node);
    lista->size -= 1;
    printf("usunięto dane z pozycji: %d \n", position);
}


void freeList(struct list* lista)
{
    struct node* current = lista->first;
    while (current != NULL) {
        struct node* next = current->next;
        free(current);
        current = next;
    }
    free(lista);
    printf("Usunięto liste\n");
}


double tab2[100000000] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};
