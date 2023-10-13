#include "types.h"
#include "user.h"

void third() {
    printf(1, "3rd Process:\n  PID: %d\n  Parent: %d\n", getpid(), get_parent_pid());
    exit();
}

void second() {
    printf(1, "2nd Process:\n  PID: %d\n  Parent: %d\n", getpid(), get_parent_pid());
    int forkpid = fork();
    if (forkpid > 0) {
        wait();
    }
    else if (forkpid == 0) {
        third();
    }
    else {
        printf(2, "Failed to create 3rd process.\n");
    }
    exit();
}

int main(int argc, char* argv[]) {
    int forkpid = fork();
    if (forkpid > 0) {
        wait();
    }
    else if (forkpid == 0) {
        second();
    }
    else {
        printf(2, "Failed to create 2nd process.\n");
    }
    exit();
}
