#include "fcntl.h"
#include "types.h"
#include "user.h"

#define BUFSIZE 512

#define NPROCESS 10

int main() {
    unlink("ns.txt");
    int fd = open("ns.txt", O_CREATE | O_WRONLY);

    for (int i = 0; i < NPROCESS; i++) {
        if (!fork()) {
            write(fd, "G#17", 4);
            exit();
        }
        else
            continue;
    }
    for (int i = 0; i < NPROCESS; i++)
        wait();

    write(fd, "\n", 1);
    close(fd);
    nsyscalls();
    exit();
}