#include "types.h"
#include "user.h"

int flpf_syscall(int num) {
    int prev_ebx;

    // Save ebx in prev_ebx to restore later.
    // Move num to ebx.
    asm volatile(
        "movl %%ebx, %0\n\t"
        "movl %1, %%ebx"
        : "=r"(prev_ebx)
        : "r"(num)
    );

    int result = find_largest_prime_factor();

    // Restore ebx.
    asm volatile(
        "movl %0, %%ebx"
        :: "r"(prev_ebx)
    );

    return result;
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        printf(2, "usage: find_largest_prime_factor <number>\n");
        exit();
    }

    int num = atoi(argv[1]);

    int result = flpf_syscall(num);
    if (result == -1) {
        printf(2, "Number should be greater than 1.\n");
    }
    else {
        printf(1, "%d\n", result);
    }

    exit();
}
