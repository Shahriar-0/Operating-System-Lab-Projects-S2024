# Operating System Lab Projects

- [Operating System Lab Projects](#operating-system-lab-projects)
  - [Intro](#intro)
  - [Experiment 1: Introduction to xv6](#experiment-1-introduction-to-xv6)
    - [Task 1: Boot Message](#task-1-boot-message)
    - [Task 2: Console Features](#task-2-console-features)
    - [Task 3: User Program](#task-3-user-program)
  - [Experiment 2: System Calls](#experiment-2-system-calls)
    - [Task 1: System Call Using Registers](#task-1-system-call-using-registers)
    - [Task 2: System Call Using Stack](#task-2-system-call-using-stack)
  - [Experiment 3: Process Scheduling](#experiment-3-process-scheduling)
    - [Task 1: Multi-Level Feedback Queue](#task-1-multi-level-feedback-queue)
    - [Task 2: Aging](#task-2-aging)
    - [Task 3: System Calls](#task-3-system-calls)
  - [Experiment 4: Synchronization](#experiment-4-synchronization)
    - [Task 1: Semaphore](#task-1-semaphore)
    - [Task 2: Dining Philosophers](#task-2-dining-philosophers)

## Intro

In this project, some features are added to the [**xv6**](https://github.com/mit-pdos/xv6-public) operating system (x86 architecture).

## Experiment 1: Introduction to xv6

### Task 1: Boot Message

The following message is displayed when the system boots up:

```text
Group 1:
- Saman Eslami Nazari : 810199375
- Pasha Barahimi      : 810199385
- Misagh Mohaghegh    : 810199484
```

### Task 2: Console Features

The following keyboard shortcuts are added to the console:

- `Ctrl+N` : Removes all the digits from the console
- `Ctrl+R` : Reverses the current line
- `Tab`    : Substitutes the current line with a command from the history (if exists)

Also, the following features are added to the console though they were not required in the task:

- `Arrow Up`   : Shows the previous command in the history
- `Arrow Down` : Shows the next command in the history

### Task 3: User Program

A `prime_numbers` program is added to the system.  
This program finds the prime numbers in the range $[a, b]$.  
The program is called as follows:

```text
prime_numbers a b
```

The result is then printed in the `prime_numbers.txt` file.

## Experiment 2: System Calls

### Task 1: System Call Using Registers

The `find_largest_prime_factor` system call is added to the system.  
This system call finds the largest prime factor of a given number.  
The system call is called as follows:

```c++
int find_largest_prime_factor(void);
```

The parameter (an integer) should be passed in the `ebx` register.

### Task 2: System Call Using Stack

- The `change_file_size` system call is added to the system.  
  This system call changes the size of a file.  
  It will add zeros to the end of the file if the new size is larger than the current size. Otherwise, it will remove the last bytes of the file.  

```c++
int change_file_size(char *path, int size);
```

- The `get_callers` system call is added to the system.  
  This system call returns a history of the callers of each system call.  

```c++
void get_callers(void);
```

- The `get_parent_pid` system call is added to the system.  
  This system call returns the parent process id of the current process.  

```c++
int get_parent_pid(void);
```

## Experiment 3: Process Scheduling

### Task 1: Multi-Level Feedback Queue

An **MLFQ** scheduler is added to the system.  
The scheduler has 3 queues with the first one having the highest priority.  
The following queueing policies are used:

- The first queue is a round-robin queue with a time quantum of 1 tick.
- The second queue is lottery queue in which the tickets shows the chance of the process to be executed.
- The third queue is a BJF (Best-Job-First) queue in which the process with the lowest rank is executed.

### Task 2: Aging

All processes are started in the second queue (except the `init` and `sh` processes).  
If a **runnable** process has not been executed for *8000* ticks, it is moved to the first queue.

### Task 3: System Calls

The following system calls are added to the system:

- `change_scheduling_queue` : Changes the scheduling queue of a process.

```c++
int change_scheduling_queue(int pid, int queue);
```

- `set_lottery_tickets` : Sets the lottery tickets of a process.

```c++
int set_lottery_tickets(int pid, int tickets);
```

- `set_bjf_params_process` : Sets the parameters of the BJF algorithm for a process.

```c++
int set_bjf_params_process(int pid, float priority_ratio, float arrival_time_ratio, float executed_cycles_ratio);
```

- `set_bjf_params_system` : Sets the parameters of the BJF algorithm for the system.

```c++
int set_bjf_params_system(float priority_ratio, float arrival_time_ratio, float executed_cycles_ratio);
```

- `print_process_info` : Prints the information of processes in a table.

```c++
void print_process_info(void);
```

All of the aforementioned system calls are accessible using the `schedule` user program:

```text
usage: schedule command [arg...]
Commands and Arguments:
  info
  set_queue <pid> <new_queue>
  set_tickets <pid> <tickets>
  set_process_bjf <pid> <priority_ratio> <arrival_time_ratio> <executed_cycle_ratio>
  set_system_bjf <priority_ratio> <arrival_time_ratio> <executed_cycle_ratio>
  set_priority_bjf <pid> <priority>
```

## Experiment 4: Synchronization

### Task 1: Semaphore

As xv6 does not support threads, semaphores can only be used among processes.  
As a result, an array of 5 semaphores is implemented in the system.  
The following system calls are added to the system:

- `sem_init` : Initializes a semaphore.

```c++
int sem_init(int index, int value);
```

- `sem_acquire` : Acquires a semaphore.

```c++
int sem_acquire(int index);
```

- `sem_release` : Releases a semaphore.

```c++
int sem_release(int index);
```

### Task 2: Dining Philosophers

The `dining_philosophers` simulation is implemented using the array of semaphores.  
To prevent deadlock, all the philosophers with even IDs pick up the left fork first and then the right fork. The philosophers with odd IDs pick up the right fork first and then the left fork.  
The simulation is started as follows:

```text
dining_philosophers
```
