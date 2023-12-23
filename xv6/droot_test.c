#include "types.h"
#include "fcntl.h"
#include "user.h"

int main(int argc, char* argv[]) {
    if(argc != 2) {
        printf(2, "the command should be: droot <n>\n");
        exit();
    }

    int n = atoi(argv[1]), prev_ebx;
    asm volatile (
        "movl %%ebx, %0;"
        "movl %1, %%ebx;"
        : "=r" (prev_ebx)
        : "r"(n)
    );
    int result = droot();
    asm volatile (
        "movl %0, %%ebx;"
        : : "r"(prev_ebx)
    );
    printf(1, "digital root of %d is %d\n", n, result);
    exit();
}