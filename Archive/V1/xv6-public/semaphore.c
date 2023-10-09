// Counting semaphores.

#include "types.h"
#include "defs.h"
#include "spinlock.h"
#include "param.h"
#include "semaphore.h"

struct semaphore sems[NSEMS];

void
semaphore_init(struct semaphore* sem, int value, char* name)
{
  sem->value = value;
  initlock(&sem->lk, "semaphore");
  memset(sem->waiting, 0, sizeof(sem->waiting));
  memset(sem->holding, 0, sizeof(sem->holding));
  sem->wfirst = 0;
  sem->wlast = 0;
  sem->name = name;
}

void
semaphore_acquire(struct semaphore* sem)
{
  acquire(&sem->lk);
  --sem->value;
  if(sem->value < 0){
    sem->waiting[sem->wlast] = myproc();
    sem->wlast = (sem->wlast + 1) % NELEM(sem->waiting);
    sleep(sem, &sem->lk);
  }
  struct proc* p = myproc();
  for(int i = 0; i < NELEM(sem->holding); ++i){
    if(sem->holding[i] == 0){
      sem->holding[i] = p;
      break;
    }
  }
  release(&sem->lk);
}

void
semaphore_release(struct semaphore* sem)
{
  acquire(&sem->lk);
  ++sem->value;
  if(sem->value <= 0){
    wakeupproc(sem->waiting[sem->wfirst]);
    sem->waiting[sem->wfirst] = 0;
    sem->wfirst = (sem->wfirst + 1) % NELEM(sem->waiting);
  }
  struct proc* p = myproc();
  for(int i = 0; i < NELEM(sem->holding); ++i){
    if(sem->holding[i] == p){
      sem->holding[i] = 0;
      break;
    }
  }
  release(&sem->lk);
}

int
semaphore_holding(struct semaphore* sem)
{
  struct proc* p = myproc();
  for(int i = 0; i < NELEM(sem->waiting); ++i){
    if(sem->holding[i] == p){
      return 1;
    }
  }
  return 0;
}

void
sem_init(int id, int value)
{
  semaphore_init(&sems[id], value, "semaphore");
}

void
sem_acquire(int id)
{
  semaphore_acquire(&sems[id]);
}

void
sem_release(int id)
{
  semaphore_release(&sems[id]);
}
