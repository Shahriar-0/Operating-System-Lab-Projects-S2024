#include "types.h"
#include "user.h"

void help()
{
    printf(1, "usage: schedule command [arg...]\n");
    printf(1, "Commands and Arguments:\n");
    printf(1, "  info\n");
    printf(1, "  set_queue <pid> <new_queue>\n");
    printf(1, "  set_tickets <pid> <tickets>\n");
    printf(1, "  set_process_bjf <pid> <priority_ratio> <arrival_time_ratio> <executed_cycle_ratio>\n");
    printf(1, "  set_system_bjf <priority_ratio> <arrival_time_ratio> <executed_cycle_ratio>\n");
    printf(1, "  set_priority_bjf <pid> <priority>\n");
}

void info()
{
    print_process_info();
}

void set_queue(int pid, int new_queue)
{
    if (pid < 1)
    {
        printf(1, "Invalid pid\n");
        return;
    }
    if (new_queue < 1 || new_queue > 3)
    {
        printf(1, "Invalid queue\n");
        return;
    }
    int res = change_scheduling_queue(pid, new_queue);
    if (res < 0)
        printf(1, "Error changing queue\n");
    else
        printf(1, "Queue changed successfully\n");
}

void set_tickets(int pid, int tickets)
{
    if (pid < 1)
    {
        printf(1, "Invalid pid\n");
        return;
    }
    if (tickets < 0)
    {
        printf(1, "Invalid tickets\n");
        return;
    }
    int res = set_lottery_ticket(pid, tickets);
    if (res < 0)
        printf(1, "Error setting tickets\n");
    else
        printf(1, "Tickets set successfully\n");
}

void set_process_bjf(int pid, int priority_ratio, int arrival_time_ratio, int executed_cycle_ratio)
{
    if (pid < 1)
    {
        printf(1, "Invalid pid\n");
        return;
    }
    if (priority_ratio < 0 || arrival_time_ratio < 0 || executed_cycle_ratio < 0)
    {
        printf(1, "Invalid ratios\n");
        return;
    }
    int res = set_bjf_params_process(pid, priority_ratio, arrival_time_ratio, executed_cycle_ratio);
    if (res < 0)
        printf(1, "Error setting BJF params\n");
    else
        printf(1, "BJF params set successfully\n");
}

void set_system_bjf(int priority_ratio, int arrival_time_ratio, int executed_cycle_ratio)
{
    if (priority_ratio < 0 || arrival_time_ratio < 0 || executed_cycle_ratio < 0)
    {
        printf(1, "Invalid ratios\n");
        return;
    }
    set_bjf_params_system(priority_ratio, arrival_time_ratio, executed_cycle_ratio);
    printf(1, "BJF params set successfully\n");
}

void set_priority_bjf(int pid, int priority)
{
    if (pid < 1)
    {
        printf(1, "Invalid pid\n");
        return;
    }
    if (priority < 0)
    {
        printf(1, "Invalid priority\n");
        return;
    }
    int res = set_bjf_priority(pid, priority);
    if (res < 0)
        printf(1, "Error setting priority\n");
    else
        printf(1, "BJF priority set successfully\n");
}

int main(int argc, char* argv[])
{
    if (argc < 2)
    {
        help();
        exit();
    }
    if (!strcmp(argv[1], "info"))
        info();
    else if (!strcmp(argv[1], "set_queue"))
    {
        if (argc < 4)
        {
            help();
            exit();
        }
        set_queue(atoi(argv[2]), atoi(argv[3]));
    }
    else if (!strcmp(argv[1], "set_tickets"))
    {
        if (argc < 4)
        {
            help();
            exit();
        }
        set_tickets(atoi(argv[2]), atoi(argv[3]));
    }
    else if (!strcmp(argv[1], "set_process_bjf"))
    {
        if (argc < 6)
        {
            help();
            exit();
        }
        set_process_bjf(atoi(argv[2]), atoi(argv[3]), atoi(argv[4]), atoi(argv[5]));
    }
    else if (!strcmp(argv[1], "set_system_bjf"))
    {
        if (argc < 5)
        {
            help();
            exit();
        }
        set_system_bjf(atoi(argv[2]), atoi(argv[3]), atoi(argv[4]));
    }
    else if (!strcmp(argv[1], "set_priority_bjf"))
    {
        if (argc < 4)
        {
            help();
            exit();
        }
        set_priority_bjf(atoi(argv[2]), atoi(argv[3]));
    }
    else
        help();
    exit();
}
