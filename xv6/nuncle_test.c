#include "types.h"
#include "stat.h"
#include "user.h"

void test_nuncle(void) {
    int pid_c1 = fork();
    if (pid_c1 == 0) {
        sleep(10);
        exit();
    }

    int pid_c2 = fork();
    if (pid_c2 == 0) {
        sleep(10);
        exit();
    }

    int pid_c3 = fork();
    if (pid_c3 == 0) {
        int pid_gc = fork();
        if (pid_gc == 0) {
            int n_uncle = nuncle();
            printf(1, "number of uncles: %d\n", n_uncle);
            exit();
        }
        wait();
        exit();
    }
    // wait for three children to exit
    wait();
    wait();
    wait();
}

int main(int argc, char* argv[]) {
    test_nuncle();
    exit();
}