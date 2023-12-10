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

void set_proc_bjs_params(int pid, float priority_ratio, float arrival_time_ratio,
                 float executed_cycle_ratio, float process_size_ratio) {

    int res = bjsproc(pid, priority_ratio, arrival_time_ratio, executed_cycle_ratio, process_size_ratio);

    if (res < 0)
        printf(1, "Error setting proc params\n");
    else
        printf(1, "done!\n");
}

void set_sys_bjs_params(float priority_ratio, float arrival_time_ratio,
                 float executed_cycle_ratio, float process_size_ratio) {

    int res = bjssys(priority_ratio, arrival_time_ratio, executed_cycle_ratio, process_size_ratio);

    if (res < 0)
        printf(1, "Error setting sys params\n");
    else
        printf(1, "done!\n");
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf(1, "invalid command\n");
        exit();
    }
    else if (!strcmp(argv[1], "chq")) {
        if (argc < 4) {
            printf(1, "invalid command\n");
            exit();
        }
        set_queue(atoi(argv[2]), atoi(argv[3]));
    }
    else if (!strcmp(argv[1], "bjsp")) {
        if (argc < 7) {
            printf(1, "invalid command\n");
            exit();
        }
        set_proc_bjs_params(atoi(argv[2]), atoi(argv[3]), atoi(argv[4]), atoi(argv[5]), atoi(argv[6]));
    }
    else if (!strcmp(argv[1], "bjss")) {
        if (argc < 6) {
            printf(1, "invalid command\n");
            exit();
        }
        set_sys_bjs_params(atoi(argv[2]), atoi(argv[3]), atoi(argv[4]), atoi(argv[5]));
    }
    else if (!strcmp(argv[1], "info")) {
        print_info();
    }
    else {
        printf(1, "%d\n", atoi(argv[1]));
    
    }
    exit();
}