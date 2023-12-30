#include "fcntl.h"
#include "types.h"
#include "user.h"

void intToChar(int num, char* str) {
    if (num == 0) {
        str[0] = '0';
        return;
    }

    int temp = num;
    uint len = 0;

    while (temp != 0) {
        temp /= 10;
        len++;
    }

    if (num < 0) {
        str[0] = '-';
        num = -num;
    }

    uint i = len - 1;

    while (num != 0) {
        str[i] = '0' + (num % 10);
        num /= 10;
        i--;
    }
}

int main() {
    char buffer[6];

    for (int i = 0; i < 10; i++) {
        if (!fork()) {
            int pid = pacquire();
            long long int j;
            j = 0;
            for (j = 0; j <= 1e7; j++) {
                if (j < 1e7)
                    continue;
                pqueue();
                memset(buffer, 0, 6);
                intToChar(pid, buffer);
                printf(1, "process %d done!\n", pid);
                int fd = open("./plock.txt", O_CREATE | O_WRONLY);
                write(fd, buffer, strlen(buffer));
                close(fd);
                prelease();
            }
            exit();
        }
        else
            continue;
    }
    while (wait() != -1)
        ;

    exit();
}