#include "types.h"
#include "user.h"
#include "fcntl.h"
#include "stat.h"

int fileSize(char *path) {
    int fd = open(path, O_RDWR | O_CREATE);
    if (fd < 0) {
        printf(1, "change_file_size: cannot open file %s\n", path);
        exit();
    }
    struct stat st;
    if (fstat(fd, &st) < 0) {
        printf(1, "change_file_size: cannot stat file %s\n", path);
        exit();
    }
    if (st.type != T_FILE) {
        printf(1, "change_file_size: %s is not a file\n", path);
        exit();
    }
    close(fd);
    return st.size;
}

int main(int argc, char* argv[]) {
    if (argc < 3) {
        printf(1, "change_file_size: 2 args required\n");
        exit();
    }
    char *path = argv[1];
    int size = atoi(argv[2]);
    if (size < 0) {
        printf(1, "change_file_size: invalid size %d\n", size);
        exit();
    }

    int prevSize = fileSize(path);
    if (change_file_size(path, size) < 0) {
        printf(1, "change_file_size: cannot change file size\n");
        exit();
    }
    int newSize = fileSize(path);

    printf(1, "File size changed from %d to %d\n", prevSize, newSize);
    exit();
}
