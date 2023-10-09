#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_get_callers(void) {
  int sys_call_number;
  if(argint(0, &sys_call_number) < 0)
    return -1;

  get_callers(sys_call_number);
  return 0;
}

int
sys_get_parent_pid(void)
{
  return myproc()->parent->pid;
}

int
sys_change_scheduling_queue(void)
{
  int queue_number, pid;
  if(argint(0, &pid) < 0 || argint(1, &queue_number) < 0)
    return -1;

  if(queue_number < ROUND_ROBIN || queue_number > BJF)
    return -1;

  return change_queue(pid, queue_number);
}

int
sys_set_lottery_ticket(void) {
  int pid, tickets;
  if(argint(0, &pid) < 0 || argint(1, &tickets) < 0)
    return -1;

  if (tickets < 0)
    return -1;

  return set_lottery_ticket(pid, tickets);
}

int
sys_set_bjf_params_process(void)
{
  int pid;
  float priority_ratio, arrival_time_ratio, executed_cycle_ratio;
  if(argint(0, &pid) < 0 ||
     argfloat(1, &priority_ratio) < 0 ||
     argfloat(2, &arrival_time_ratio) < 0 ||
     argfloat(3, &executed_cycle_ratio) < 0){
    return -1;
  }

  return set_bjf_params_process(pid, priority_ratio, arrival_time_ratio, executed_cycle_ratio);
}

int
sys_set_bjf_params_system(void)
{
  int pid;
  float priority_ratio, arrival_time_ratio, executed_cycle_ratio;
  if(argint(0, &pid) < 0 ||
     argfloat(1, &priority_ratio) < 0 ||
     argfloat(2, &arrival_time_ratio) < 0 ||
     argfloat(3, &executed_cycle_ratio) < 0){
    return -1;
  }

  set_bjf_params_system(priority_ratio, arrival_time_ratio, executed_cycle_ratio);
  return 0;
}

int
sys_set_bjf_priority(void)
{
  int pid, priority;
  if(argint(0, &pid) < 0 || argint(1, &priority) < 0)
    return -1;

  if(priority < BJF_PRIORITY_MIN || priority > BJF_PRIORITY_MAX)
    return -1;

  return set_bjf_priority(pid, priority);
}

int
sys_print_process_info(void)
{
  print_process_info();
  return 0;
}

int
sys_sem_init(void)
{
  int sem_id, value;
  if(argint(0, &sem_id) < 0 || argint(1, &value) < 0)
    return -1;

  if(sem_id < 0 || sem_id >= NSEMS)
    return -1;

  sem_init(sem_id, value);
  return 0;
}

int
sys_sem_acquire(void)
{
  int sem_id;
  if(argint(0, &sem_id) < 0)
    return -1;

  if(sem_id < 0 || sem_id >= NSEMS)
    return -1;

  sem_acquire(sem_id);
  return 0;
}

int
sys_sem_release(void)
{
  int sem_id;
  if(argint(0, &sem_id) < 0)
    return -1;

  if(sem_id < 0 || sem_id >= NSEMS)
    return -1;

  sem_release(sem_id);
  return 0;
}
