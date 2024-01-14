#include "types.h"
#include "stat.h"
#include "user.h"

#define NPROCESS 3

void test_shm(void) {
    char* adr = openshmem(25);
    *adr = 10;
    // printf(1, "%p\n", adr);
    printf(1, "%d\n", *adr);

    for (int i = 0; i < NPROCESS; i++) {
        if (!fork()) {
            sleep(100);
            char* adr = openshmem(25);
            *adr += 1;
            printf(1, "%d\n", *adr);
            // printf(1, "%p\n", adr);

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