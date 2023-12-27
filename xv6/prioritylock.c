// Priority locks

#include "types.h"
#include "defs.h"
#include "param.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "prioritylock.h"

void enqueue(struct prioritylock* lk, int pid) {
    acquire(&ptable.lock);
    for (int i = 0; i < NPROC; i++) {
        if (lk->lockreq[i] == 0) {
            lk->lockreq[i] = pid;
            break;
        }
    }
    release(&ptable.lock);
}

int isprior(struct prioritylock* lk) {
    acquire(&ptable.lock);
    int prior_pid = 0;
    for (int i = 0; i < NPROC; i++) {
        if (lk->lockreq[i] != 0 && (lk->lockreq[i] < prior_pid || prior_pid == 0)) {
            prior_pid = lk->lockreq[i];
        }
    }

    if(prior_pid != myproc()->pid){
        release(&ptable.lock);
        return 0;
    }
    
    for (int i = 0; i < NPROC; i++) {
        if (lk->lockreq[i] == prior_pid) {
            lk->lockreq[i] = 0;
            release(&ptable.lock);
            return 1;
        }
    }
}

void initprioritylock(struct prioritylock* lk, char* name) {
    initlock(&lk->lk, "priority lock");
    lk->name = name;
    lk->locked = 0;
    lk->pid = 0;
    memset(lk->lockreq, 0, NPROC);
}

void acquirepriority(struct prioritylock* lk) {
    enqueue(lk, myproc()->pid);
    acquire(&lk->lk);
    while (lk->locked || !isprior(lk)) 
        ;
    lk->locked = 1;
    lk->pid = myproc()->pid;
    release(&lk->lk);
}

void releasepriority(struct prioritylock* lk) {
    acquire(&lk->lk);
    lk->locked = 0;
    lk->pid = 0;
    wakeup(lk);
    release(&lk->lk);
}

int holdingpriority(struct prioritylock* lk) {
    int r;

    acquire(&lk->lk);
    r = lk->locked && (lk->pid == myproc()->pid);
    release(&lk->lk);
    return r;
}
