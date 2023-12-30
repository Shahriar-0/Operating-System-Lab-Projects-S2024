#include "fcntl.h"
#include "types.h"
#include "user.h"

int main() {
    for (int i = 0; i < 10; i++) {
        if (!fork()) {
       
            int fd = open("./nsyscalltest.txt", O_CREATE | O_WRONLY);
            write(fd, "G17\0", 4);
            close(fd);
            exit();
        }
        else 
            continue;
    }
    while (wait() != -1)
        ;  
    nsyscalls();
    exit();
}