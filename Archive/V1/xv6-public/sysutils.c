#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"
#include "mmu.h"
#include "proc.h"

static int largest_prime_factor(int n) {
    if (n <= 1) return -1;

    int largest;

    if (n % 2 == 0) {
        largest = 2;
        do { n /= 2; } while (n % 2 == 0);
    }

    if (n % 3 == 0) {
        largest = 3;
        do { n /= 3; } while (n % 3 == 0);
    }

    for (int i = 5; i * i <= n; i += 6) {
        if (n % i == 0) {
            largest = i;
            do { n /= i; } while (n % i == 0);
        }
        if (n % (i + 2) == 0) {
            largest = i + 2;
            do { n /= i + 2; } while (n % (i + 2) == 0);
        }
    }

    if (n > 4) return n;
    return largest;
}

int sys_find_largest_prime_factor(void) {
    return largest_prime_factor(myproc()->tf->ebx);
}
