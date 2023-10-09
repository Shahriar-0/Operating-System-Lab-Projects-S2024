#include "syscall.h"
#include "types.h"
#include "user.h"

int main(int argc, char* argv[]) {
    printf(1, "Testing SYS_write:\n");
    get_callers(SYS_write);

    printf(1, "Testing SYS_fork:\n");
    get_callers(SYS_fork);

    printf(1, "Testing SYS_wait:\n");
    get_callers(SYS_wait);

    exit();
}
