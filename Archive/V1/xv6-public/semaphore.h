// Counting semaphore.
struct semaphore {
  int value;                   // The current value of the semaphore.
  struct spinlock lk;          // Spinlock protecting the semaphore.

  struct proc* waiting[NPROC]; // Queue of processes waiting on the semaphore.
  struct proc* holding[NPROC]; // List of processes holding the semaphore.
  int wfirst;                  // The head of the waiting queue.
  int wlast;                   // The tail of the waiting queue.

  char* name;                  // Name of the semaphore.
};
