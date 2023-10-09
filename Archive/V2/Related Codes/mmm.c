#include "fcntl.h"
#include "types.h"
#include "user.h"

int custom_atoi(const char* str) {
    int sign = 1;
    int unsigned_num = 0;

    if (*str == '-') {
        sign = -1;
        ++str;
    }
    else if (*str == '+')
        ++str;

    for (int i = 0; str[i] != '\0'; i++) {
        if (str[i] >= '0' && str[i] <= '9')
            unsigned_num = unsigned_num * 10 + (str[i] - '0');
        else {
            printf(2, "Error: Wrong number format.\n");
            exit();
        }
    }
    return sign * unsigned_num;
}

void sort(int* numbers, int len) {
    int i;
    int j;
    int key = 0;

    for (i = 1; i < len; i++) {
        key = numbers[i];
        j = i - 1;

        while (j >= 0 && numbers[j] > key) {
            numbers[j + 1] = numbers[j];
            j = j - 1;
        }
        numbers[j + 1] = key;
    }
}

int mean(int* numbers, int len) {
    int sum = 0;
    for (int i = 0; i < len; i++)
        sum += numbers[i];
    return (int)(sum / len);
}

int median(int* numbers, int len) {
    int median;
    int idx;

    if (len % 2 == 0) {
        idx = len / 2;
        median = (int)((numbers[idx - 1] + numbers[idx]) / 2);
    }
    else {
        idx = (int)(len / 2);
        median = numbers[idx];
    }
    return median;
}

int mode(int* numbers, int len) {
    int mode = numbers[0];
    int max_occurence = 0;

    for (int i = 0; i < len; i++) {
        int occurrence_count = 0;

        for (int j = 0; j < len; j++)
            if (numbers[j] == numbers[i])
                occurrence_count++;

        if (occurrence_count > max_occurence) {
            max_occurence = occurrence_count;
            mode = numbers[i];
        }
    }
    return mode;
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf(2, "usage: mmm <array_of_numbers>\n");
        exit();
    }
    else if (argc > 8) {
        printf(2, "Error: Please ensure that you enter no more than 7 numbers.\n");
        exit();
    }

    int numbers[7];
    int len = argc - 1;
    for (int i = 0; i < len; i++)
        numbers[i] = custom_atoi(argv[i + 1]);
    sort(numbers, len);

    unlink("mmm_result.txt");
    int fd = open("mmm_result.txt", O_CREATE | O_WRONLY);
    if (fd < 0) {
        printf(2, "mmm: cannot create mmm_result.txt\n");
        exit();
    }
    printf(fd, "%d %d %d\n", mean(numbers, len), median(numbers, len), mode(numbers, len));
    close(fd);
    exit();
}