#include <winsock2.h>
#include <ws2tcpip.h>
#include <stdio.h>
#include <string.h>
#include <windows.h>

#define ST_PORT 54321
#define MAX_URL_LENGTH 2048
#define IDT_TIMER1 1
#define TIMER_INTERVAL 1000

LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);
int hamster_hunt = 0;
SOCKET actual_client_socket = INVALID_SOCKET;

void send_hamster_message()
{
    if (actual_client_socket != INVALID_SOCKET)
    {
        const char* message = "hamster";
        int sent = send(actual_client_socket, message, strlen(message), 0);
        if (sent == SOCKET_ERROR)
        {
            printf("send error: %d\n", WSAGetLastError());
        }
        else
        {
            printf("Sent hamster message to client\n");
        }
    }
    else
    {
        hamster_hunt = 0;
        printf("No client connected!\n");
    }
}

void send_session_ended_message()
{
    if (actual_client_socket != INVALID_SOCKET)
    {
        const char* message = "end";
        printf("Server closed\n");
        send(actual_client_socket, message, strlen(message), 0);
    }
}

DWORD WINAPI handle_connections(LPVOID param)
{
    SOCKET s = (SOCKET)param;
    SOCKET si;
    struct sockaddr_in sc;
    int lenc;

    printf("Server waiting for connection...\n");
    for (;;)
    {
        lenc = sizeof(sc);
        si = accept(s, (struct sockaddr FAR*)&sc, &lenc);

        actual_client_socket = si;
        printf("\nClient connected!\n");
        char buf[MAX_URL_LENGTH];
        int bytes_received;

        while ((bytes_received = recv(si, buf, MAX_URL_LENGTH - 1, 0)) > 0)
        {
            buf[bytes_received - 1] = '\0';
            if (strcmp(buf, "bye") == 0)
            {
                printf("Closing the connection...\n");
                break;
            }

            printf("\nReceived: %s\n", buf);
        }

        closesocket(si);
        actual_client_socket = INVALID_SOCKET;
    }

    closesocket(s);
    return 0;
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, PSTR lpCmdLine, int nCmdShow)
{
    WNDCLASS wc = { 0 };
    wc.lpfnWndProc = WndProc;
    wc.hInstance = hInstance;
    wc.lpszClassName = "SimpleWindowClass";

    if (!RegisterClass(&wc))
    {
        MessageBox(NULL, "Nie udało się zarejestrować klasy okna", "Błąd", MB_OK);
        return 0;
    }

    HWND hwnd = CreateWindowEx(
        0,
        wc.lpszClassName,
        "Hamster Hunt Server",
        WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT,
        500, 300,
        NULL, NULL, hInstance, NULL);

    if (hwnd == NULL)
    {
        MessageBox(NULL, "Nie udało się utworzyć okna", "Błąd", MB_OK);
        return 0;
    }

    ShowWindow(hwnd, nCmdShow);
    UpdateWindow(hwnd);

    WSADATA wsas;
    int result;
    WORD wersja = MAKEWORD(2, 2);

    result = WSAStartup(wersja, &wsas);
    if (result != 0)
    {
        MessageBox(NULL, "Nie udało się zainicjalizować WinSock", "Błąd", MB_OK);
        return 0;
    }

    SOCKET s = socket(AF_INET, SOCK_STREAM, 0);
    if (s == INVALID_SOCKET)
    {
        MessageBox(NULL, "Nie udało się stworzyć gniazda", "Błąd", MB_OK);
        WSACleanup();
        return 0;
    }

    struct sockaddr_in sa;
    memset((void*)(&sa), 0, sizeof(sa));
    sa.sin_family = AF_INET;
    sa.sin_port = htons(ST_PORT);
    sa.sin_addr.s_addr = htonl(INADDR_ANY);

    result = bind(s, (struct sockaddr FAR*)&sa, sizeof(sa));
    if (result == SOCKET_ERROR)
    {
        MessageBox(NULL, "Nie udało się związać gniazda z adresem", "Błąd", MB_OK);
        closesocket(s);
        WSACleanup();
        return 0;
    }

    result = listen(s, 5);
    if (result == SOCKET_ERROR)
    {
        MessageBox(NULL, "Nie udało się rozpocząć nasłuchiwania", "Błąd", MB_OK);
        closesocket(s);
        WSACleanup();
        return 0;
    }

    CreateThread(NULL, 0, handle_connections, (LPVOID)s, 0, NULL);

    SetTimer(hwnd, IDT_TIMER1, TIMER_INTERVAL, NULL);

    MSG msg;
    while (GetMessage(&msg, NULL, 0, 0))
    {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    closesocket(s);
    WSACleanup();
    return msg.wParam;
}

LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
    switch (msg)
    {
        case WM_DESTROY:
            send_session_ended_message();
            PostQuitMessage(0);
            break;

        case WM_COMMAND:
            if (LOWORD(wParam) == 1 && actual_client_socket != INVALID_SOCKET && !hamster_hunt)
            {
                hamster_hunt = 1;
                send_hamster_message();
                printf("\nHamster Hunt started...\n");
                CreateWindow(
                    "BUTTON",
                    "Stop Hamster Hunt!",
                    WS_TABSTOP | WS_VISIBLE | WS_CHILD | BS_DEFPUSHBUTTON,
                    150, 100, 200, 40,
                    hwnd, (HMENU)1, GetModuleHandle(NULL), NULL);
            }
            else if (LOWORD(wParam) == 1 && actual_client_socket != INVALID_SOCKET && hamster_hunt)
            {
                hamster_hunt = 0;
                printf("\nHamster Hunt stopped...\n");
                CreateWindow(
                    "BUTTON",
                    "Start Hamster Hunt!",
                    WS_TABSTOP | WS_VISIBLE | WS_CHILD | BS_DEFPUSHBUTTON,
                    150, 100, 200, 40,
                    hwnd, (HMENU)1, GetModuleHandle(NULL), NULL);
            }
            break;

        case WM_TIMER:
            if (wParam == IDT_TIMER1 && hamster_hunt)
            {
                send_hamster_message();
            }
            break;

        case WM_CREATE:
            CreateWindow(
                "BUTTON",
                "Start Hamster Hunt!",
                WS_TABSTOP | WS_VISIBLE | WS_CHILD | BS_DEFPUSHBUTTON,
                150, 100, 200, 40,
                hwnd, (HMENU)1, GetModuleHandle(NULL), NULL);
            break;

        default:
            return DefWindowProc(hwnd, msg, wParam, lParam);
    }
    return 0;
}
