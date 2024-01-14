#include "types.h"
#include "stat.h"
#include "user.h"

#define NPROCESS 2

void test_shm(void) {
    int* adr = openshmem(10);
    *adr = 10;

    for (int i = 0; i < NPROCESS; i++) {
        if (!fork()) {
            sleep(100);
            int* adr = openshmem(10);
            *adr += 1;
            exit();
        }
    }
    for (int i = 0; i < NPROCESS; i++)
        wait();
}

int main(int argc, char* argv[]) {
    test_shm();
    exit();
}