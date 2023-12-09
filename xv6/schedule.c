#include "types.h"
#include "user.h"

void print_info() {
    procinfo();
}

void set_queue(int pid, int new_queue) {
    if (pid < 1) {
        printf(1, "Invalid pid\n");
        return;
    }
    if (new_queue < 1 || new_queue > 3) {
        printf(1, "Invalid queue\n");
        return;
    }
    int res = chqueue(pid, new_queue);
    if (res < 0)
        printf(1, "Error changing queue\n");
    else
        printf(1, "Queue changed successfully\n");
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf(1, "KHOSSHS\n");
        exit();
    }
    else if (!strcmp(argv[1], "c")) {
        if (argc < 4) {
            printf(1, "KHOSSHS\n");
            exit();
        }
        set_queue(atoi(argv[2]), atoi(argv[3]));
    }
    else if (!strcmp(argv[1], "p")) {
        print_info();
    }
    else{
        printf(1, "KHOSSHS\n");
    }
    exit();
}