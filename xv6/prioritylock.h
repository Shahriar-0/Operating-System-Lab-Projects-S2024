// priority lock

struct prioritylock {
    uint locked;        // Is the lock held?
    struct spinlock lk; // spinlock protecting this priority lock
    int lockreq[NPROC]; // pid of processes which requested priority lock

    // For debugging:
    char* name; // Name of lock.
    int pid;    // Process holding lock
};
