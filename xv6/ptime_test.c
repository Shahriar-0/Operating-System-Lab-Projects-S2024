#include "types.h"
#include "stat.h"
#include "user.h"

void test_ptime(void) {
    int t;

    t = ptime();
    printf(1, "this process is created: %d milliseconds ago\n", 10 * t);

    sleep(100);
    t = ptime() - t;
    printf(1, "now it passed %d milliseconds again!\n", 10 * t);

    int pid = fork();
    if (pid == 0) {
        sleep(100);
        int t_child = ptime();
        printf(1, "the child process lasts: %d milliseconds\n", 10 * t_child);
        exit();
    }
    else {
        wait();
        sleep(100);
        t = ptime();
        printf(1, "the father process lasts: %d milliseconds\n", 10 * t);
    }
}

int main(int argc, char* argv[]) {
    test_ptime();
    exit();
}