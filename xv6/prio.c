#include "types.h"
#include "stat.h"
#include "user.h"

int main() {
    for (int i = 0; i < 10; i++) {
        if (!fork()) {
            printf(1, "process with pid %d done!\n\n", chcritical());
            exit();
        }
        else {
            continue;
        }
    }
    while (wait() != -1)
        ;

    exit();
}