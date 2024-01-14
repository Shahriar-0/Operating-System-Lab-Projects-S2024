#include "types.h"
#include "stat.h"
#include "user.h"

#define NPROCESS 10
#define ID       25

void test_shmem(void) {
    char* adr = openshmem(ID);
    adr[0] = 10;
    printf(1, "%d\n", adr[0]);

    for (int i = 0; i < NPROCESS; i++) {
        if (fork() == 0) {
            sleep(100 * i);
            char* adrs = openshmem(ID);
            adrs[0] += 1;
            printf(1, "%d\n", adrs[0]);
            closeshmem(ID);
            exit();
        }
    }
    for (int i = 0; i < NPROCESS; i++)
        wait();
    closeshmem(ID);
}

int main(int argc, char* argv[]) {
    test_shmem();
    exit();
}