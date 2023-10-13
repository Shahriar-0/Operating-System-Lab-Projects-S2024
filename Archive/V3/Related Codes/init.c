// init: The initial user-level program

#include "fcntl.h"
#include "stat.h"
#include "types.h"
#include "user.h"

char* argv[] = {"sh", 0};

int main(void) {
    int pid, wpid;

    if (open("console", O_RDWR) < 0) {
        mknod("console", 1, 1);
        open("console", O_RDWR);
    }
    dup(0); // stdout
    dup(0); // stderr

    for (;;) {
        printf(1, "init: starting sh\n");

        printf(1, "\n");
        printf(1, " /-----------------------------\\\n");
        printf(1, " | Group Members:              |\n");
        printf(1, " |  - Ali Ghanbari %% 810199473 |\n");
        printf(1, " |  - Behrad Elmi  %% 810199557 |\n");
        printf(1, " |  - Bita Nasiri  %% 810199504 |\n");
        printf(1, " \\-----------------------------/\n");
        printf(1, "\n");

        pid = fork();
        if (pid < 0) {
            printf(1, "init: fork failed\n");
            exit();
        }
        if (pid == 0) {
            exec("sh", argv);
            printf(1, "init: exec sh failed\n");
            exit();
        }
        while ((wpid = wait()) >= 0 && wpid != pid)
            printf(1, "zombie!\n");
    }
}