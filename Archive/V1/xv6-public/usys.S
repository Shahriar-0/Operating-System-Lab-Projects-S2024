#include "syscall.h"
#include "traps.h"

#define SYSCALL(name) \
  .globl name; \
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
SYSCALL(exit)
SYSCALL(wait)
SYSCALL(pipe)
SYSCALL(read)
SYSCALL(write)
SYSCALL(close)
SYSCALL(kill)
SYSCALL(exec)
SYSCALL(open)
SYSCALL(mknod)
SYSCALL(unlink)
SYSCALL(fstat)
SYSCALL(link)
SYSCALL(mkdir)
SYSCALL(chdir)
SYSCALL(dup)
SYSCALL(getpid)
SYSCALL(sbrk)
SYSCALL(sleep)
SYSCALL(uptime)
SYSCALL(find_largest_prime_factor)
SYSCALL(change_file_size)
SYSCALL(get_callers)
SYSCALL(get_parent_pid)
SYSCALL(change_scheduling_queue)
SYSCALL(set_lottery_ticket)
SYSCALL(set_bjf_params_process)
SYSCALL(set_bjf_params_system)
SYSCALL(set_bjf_priority)
SYSCALL(print_process_info)
SYSCALL(sem_init)
SYSCALL(sem_acquire)
SYSCALL(sem_release)
