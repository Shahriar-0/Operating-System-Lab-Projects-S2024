#include "fcntl.h"
#include "types.h"
#include "user.h"

#define MAX_LEN 15
char diff[MAX_LEN + 2];

// Converts a string to lower-case, returns 0 if there is non-alphabetical charachter.
char* to_lower(char* word) {
    int length = strlen(word);

    char* lower_word = (char*)malloc((length + 1) * sizeof(char));

    for (int i = 0; i < length; i++) {
        if (word[i] >= 'a' && word[i] <= 'z')
            lower_word[i] = word[i];
        else if (word[i] >= 'A' && word[i] <= 'Z')
            lower_word[i] = word[i] + 32;
        else
            return 0;
    }
    lower_word[length] = 0;

    return lower_word;
}

// getting difference of two strings (0 for each character in first being greater than or equal to 
// the corresponding character in second, 1 otherwise)
int strdiff(char* str1, char* str2) {
    str1 = to_lower(str1);
    str2 = to_lower(str2);

    if (str1 == 0 || str2 == 0)
        return 0;

    int min_len, max_len, max_str = 0;
    if (strlen(str1) >= strlen(str2)) {
        max_str = 1;
        max_len = strlen(str1);
        min_len = strlen(str2);
    }
    else {
        max_len = strlen(str2);
        min_len = strlen(str1);
    }

    int i;
    for (i = 0; i < min_len; i++) {
        if (str1[i] >= str2[i])
            diff[i] = '0';
        else
            diff[i] = '1';
    }
    for (; i < max_len; i++) {
        if (max_str == 0)
            diff[i] = '1';
        else
            diff[i] = '0';
    }

    diff[i++] = '\n';
    diff[i] = '\0';
    return 1;
}

int main(int argc, char* argv[]) {
    if (argc != 3) {
        printf(2, "Please enter exactly two strings!\n");
        exit();
    }
    if ((strlen(argv[1]) > 15) || (strlen(argv[2]) > 15)) {
        printf(2, "Length of strings must be equal or less than 15!\n");
        exit();
    }

    unlink("strdiff_result.txt"); // remove links of any file to strdiff_result.txt

    int fd = open("strdiff_result.txt", O_CREATE | O_WRONLY); // create or open file
    if (fd < 0) {
        printf(2, "Error happens when trying making file!\n");
        exit();
    }

    if (strdiff(argv[1], argv[2]) == 0) {
        printf(2, "String must only include alphabetical characters!\n");
        exit();
    }

    write(fd, diff, strlen(diff));
    close(fd);

    exit();
}