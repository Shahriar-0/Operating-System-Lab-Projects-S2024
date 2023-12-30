#include "types.h"
#include "defs.h"
#include "param.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "prioritylock.h"

void showlockqueue(struct prioritylock* lk) {
    acquire(&lk->lk);
    cprintf("[");
    for (int i = 0; i < lk->inqueue; i++) {
        cprintf("%d", lk->lockreq[i]);
        if (i != lk->inqueue - 1)
            cprintf(", ");
    }
    cprintf("]\n");
    release(&lk->lk);
}

void enqueue(struct prioritylock* lk, int pid) {
    if (lk->inqueue == NPROC)
        return;

    int pos = 0;
    while (lk->lockreq[pos] > pid)
        pos++;

    for (int i = lk->inqueue; i > pos; i--) {
        lk->lockreq[i] = lk->lockreq[i - 1];
    }

    lk->lockreq[pos] = pid;
    lk->inqueue++;
}

int isprior(struct prioritylock* lk) {
    if (lk->inqueue == 0 || lk->lockreq[0] != myproc()->pid) {
        return 0;
    }

    for (int i = 0; i < lk->inqueue - 1; i++) {
        lk->lockreq[i] = lk->lockreq[i + 1];
    }
    lk->lockreq[lk->inqueue - 1] = 0;
    lk->inqueue--;

    return 1;
}

void initprioritylock(struct prioritylock* lk, char* name) {
    initlock(&lk->lk, "p_s_lock");
    lk->name = name;
    lk->locked = 0;
    lk->pid = 0;
    memset(lk->lockreq, 0, NPROC);
}

void acquirepriority(struct prioritylock* lk) {
    enqueue(lk, myproc()->pid);
    while (1) {
        acquire(&lk->lk);
        if (lk->locked == 1 || !isprior(lk)) {
            release(&lk->lk);
            continue;
        }
        else
            break;
    }
    lk->locked = 1;
    lk->pid = myproc()->pid;
    release(&lk->lk);
}
void releasepriority(struct prioritylock* lk) {
    acquire(&lk->lk);
    lk->locked = 0;
    lk->pid = 0;
    release(&lk->lk);
}

int isprioritylocked(struct prioritylock* lk) {
    int r;

    acquire(&lk->lk);
    r = lk->locked;
    release(&lk->lk);
    return r;
}

int holdingpriority(struct prioritylock* lk) {
    int r;

    acquire(&lk->lk);
    r = lk->locked && (lk->pid == myproc()->pid);
    release(&lk->lk);
    return r;
}
