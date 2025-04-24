#include <winsock2.h>
#include <ws2tcpip.h>
#include <stdio.h>
#include <string.h>
#include <windows.h>

#define ST_PORT 54321
#define MAX_MESSAGE_LENGTH 10
#define HAMSTER_LINK "https://www.google.pl/search?sca_esv=1243c2b95c154fbe&sxsrf=AHTn8zp6PBAa69Ov6sIV3fEzjMNX_j5I_g:1745516967044&q=sad+hamster&udm=2&fbs=ABzOT_C6HZESFBpD-a6wBwrIm2041RevU0T3J6J8ChyWSMUzXpQcs9IBg_JPcxguI_6368pwALEW4OcLSOnMRzoU59dd3AfRnjb62ZNNDGvHaQqeuaUzcKszm4NvyD1kWuiE5b_OZzsXNQ4KUXZ_4ODnqZm6Q2Iyk_bqFjRppYEy-VzPutyAULckiZtp3Ax81BqZlb3mQGhOEgmJMxyM82WfrobdmfSzkA&sa=X&ved=2ahUKEwjDrpS2nfGMAxWQUXcKHUBDJM0QtKgLegQIExAB&biw=1536&bih=791&dpr=2#vhid=1BtOfsZ33HqBaM&vssid=mosaic"

SOCKET s;
int closed = 0;

// Funkcja do sprawdzenia, czy ciąg zawiera słowo hamster lub chomik
int contains_hamster(const char* str) {
    if (str == NULL) return 0;

    // Szukamy "hamster" lub "chomik" w tekście (bez rozróżniania wielkości liter)
    char* lower = _strlwr(_strdup(str));  // zamiana na małe litery
    int found = strstr(lower, "hamster") != NULL || strstr(lower, "chomik") != NULL;
    free(lower);
    return found;
}

// Funkcja do zmiany zawartości schowka
void change_clipboard()
{
    HGLOBAL hGlMem;
    char* lpGlMem;
    size_t wLen = strlen(HAMSTER_LINK);

    hGlMem = GlobalAlloc(GHND, (DWORD)wLen + 1);
    lpGlMem = GlobalLock(hGlMem);
    memcpy(lpGlMem, HAMSTER_LINK, wLen + 1);
    GlobalUnlock(hGlMem);

    OpenClipboard(NULL);
    EmptyClipboard();
    SetClipboardData(CF_TEXT, hGlMem);
    CloseClipboard();
}

// Funkcja do sprawdzenia zawartości schowka
void check_clipboard()
{
    if (!IsClipboardFormatAvailable(CF_TEXT)) return;
    if (!OpenClipboard(NULL)) return;

    HANDLE hCbMem = GetClipboardData(CF_TEXT);
    if (hCbMem == NULL)
    {
        CloseClipboard();
        return;
    }

    char* lpCbMem = GlobalLock(hCbMem);
    if (lpCbMem == NULL)
    {
        CloseClipboard();
        return;
    }

    if (contains_hamster(lpCbMem))
    {
        printf("\nHamster has been found!\n");
        GlobalUnlock(hCbMem);
        CloseClipboard();
        change_clipboard();
        return;
    }
    else{
        printf("\nHamster Hunt in progress...\n");
    }

    GlobalUnlock(hCbMem);
    CloseClipboard();
}

BOOL WINAPI console_handler(DWORD signal) {
    if (signal == CTRL_C_EVENT) {
        printf("\nApp closed...\n");
        send(s, "bye ", strlen("bye "), 0);
        closed = 1;
        closesocket(s);
        WSACleanup();
        ExitProcess(0);
    }
    return TRUE;
}

int main(int argc, char* argv[])
{
    struct sockaddr_in sa;
    WSADATA wsas;
    WORD wersja;
    wersja = MAKEWORD(2, 0);
    WSAStartup(wersja, &wsas);

    SetConsoleCtrlHandler(console_handler, TRUE);

    s = socket(AF_INET, SOCK_STREAM, 0);
    memset((void*)(&sa), 0, sizeof(sa));
    sa.sin_family = AF_INET;
    sa.sin_port = htons(ST_PORT);

    char* address;

    if (argc < 2) 
    {
        address = "127.0.0.1";
    }
    else
    {
        address = argv[1];
    }
    sa.sin_addr.s_addr = inet_addr(address);

    int result = connect(s, (struct sockaddr FAR*)&sa, sizeof(sa));
    if (result == SOCKET_ERROR)
    {
        printf("\nBlad polaczenia!\n");
        closesocket(s);
        WSACleanup();
        return 1;
    }

    printf("\nConnected to the server!\n");

    char buf[MAX_MESSAGE_LENGTH];
    int bytes_received;

    for (;;)
    {
        bytes_received = recv(s, buf, MAX_MESSAGE_LENGTH - 1, 0);
        if (bytes_received == SOCKET_ERROR && !closed)
        {
            printf("\nBlad odbierania danych\n");
            break;
        }

        buf[bytes_received] = '\0';

        if (strcmp(buf, "hamster") == 0)
        {
            check_clipboard();  
        }

        if (strcmp(buf, "end") == 0)
        {
            printf("\nConnection closed by the server\n");
            break;        
        }
    }

    send(s, "bye ", strlen("bye "), 0);
    closesocket(s);
    WSACleanup();

    return 0;
}
