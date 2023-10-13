#include "types.h"
#include "user.h"
#include "fcntl.h"

int atoi_neg(const char* str) {
    int sign = 1;

    if (*str == '-') {
        sign = -1;
        ++str;
    }
    else if (*str == '+') {
        ++str;
    }

    return sign * atoi(str);
}

void swap(int* a, int* b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

void writePrimes(int fd, int first, int last) {
    if (first <= 2) {
        first = 3;
        if (last >= 2) {
            write(fd, "2 ", 2);
        }
    }
    if (!(first & 1)) ++first;

    for (int i = first; i <= last; i += 2) {
        int isPrime = 1;

        for (int j = 2; j * j <= i; ++j) {
            if (i % j == 0) {
                isPrime = 0;
                break;
            }
        }

        if (isPrime) {
            printf(fd, "%d ", i);
        }
    }
}

int main(int argc, char* argv[]) {
    if (argc < 3) {
        printf(1, "prime_numbers: 2 args required\n");
        exit();
    }

    int first = atoi_neg(argv[1]);
    int last = atoi_neg(argv[2]);

    if (first > last) {
        swap(&first, &last);
    }

    unlink("prime_numbers.txt");
    int fd = open("prime_numbers.txt", O_CREATE | O_WRONLY);
    if (fd < 0) {
        printf(1, "prime_numbers: cannot create prime_numbers.txt\n");
        exit();
    }
    writePrimes(fd, first, last);
    write(fd, "\n", 1);
    close(fd);

    exit();
}
