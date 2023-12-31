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

#define NPROCESS 10
#define NUMBUF   7

int main() {
    char numstr[NUMBUF];
    unlink("plock.txt");
    int fd = open("plock.txt", O_CREATE | O_WRONLY);
    for (int i = 0; i < NPROCESS; i++) {
        if (!fork()) {
            int pid = pacquire();
            sleep(100);
            pqueue();

            memset(numstr, 0, NUMBUF);
            intToChar(pid, numstr);
            numstr[strlen(numstr)] = '-';
            write(fd, numstr, strlen(numstr));
            printf(1, "process %d done!\n", pid);

            prelease();
            exit();
        }
        else
            continue;
    }
    while (wait() != -1)
        ;

    write(fd, "\n", 1);
    close(fd);
    exit();
}