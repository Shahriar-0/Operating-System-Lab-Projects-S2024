#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>

#define PROCS_NUM 10

void perform_computation(int i) {
    int x = 1;
    for (int j = 0; j < 2 * i; ++j) {
        for (long k = 0; k < 1000000000; ++k)
            x++;
    }
}

int main() {
    srand(time(NULL));
    for (int i = 0; i < PROCS_NUM; ++i) {
        int pid = fork();
        if (pid > 0)
            continue;
        if (pid == 0) {
            int sleep_time = rand() % 10000; 
            usleep(sleep_time * 1000);       
            perform_computation(i);
            exit(EXIT_SUCCESS);
        }
    }
    while (wait(NULL) != 0)
        ;

    exit(EXIT_SUCCESS);
}