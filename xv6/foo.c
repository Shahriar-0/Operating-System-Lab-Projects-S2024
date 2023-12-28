#include "user.h"
#include "types.h"

#define PROCS_NUM 10

int randstate = 1;
int rand() {
    int a = 1664525;
    int b = 1013904223;
    int c = 1234567890;
    randstate = (randstate ^ a) * b + c;
    return randstate;
}

void perform_computation(int i) {
    int x = 1;
    for (int j = 0; j < i; j++)
        for (long k = 0; k < 1000000000; k++)
            x++;
}

int main() {
    for (int i = 0; i < PROCS_NUM; i++) {
        int pid = fork();
        if (pid > 0)
            continue;
        if (pid == 0) {
            int sleep_time = rand() % 10000;
            sleep(sleep_time);
            perform_computation(i);
            exit();
        }
    }
    while (wait() != -1)
        ;

    exit();
}