#include "types.h"
#include "user.h"

#define LEFT(i) i
#define RIGHT(i) (i + 1) % 5

// mutex is used to make printf atomic
#define MUTEX 5

#define ATOMIC(x) sem_acquire(MUTEX); x; sem_release(MUTEX);

void waitUntilHungry(int i)
{
    int time = random() % 1000;
    ATOMIC(printf(1, "Philosopher %d will be thinking for %d ticks\n", i, time));
    sleep(time);
}

void eatUntilFull(int i)
{
    int time = random() % 1000;
    ATOMIC(printf(1, "Philosopher %d will be eating for %d ticks\n", i, time));
    sleep(time);
}

void init()
{
    for (int i = 0; i < 5; i++)
        sem_init(i, 1);
    sem_init(MUTEX, 1);
}

void pickup(int i)
{
    if (i % 2 == 0)
    {
        ATOMIC(printf(1, "Philosopher %d is going to pick up the left fork first\n", i));
        sem_acquire(LEFT(i));
        ATOMIC(printf(1, "Philosopher %d is going to pick up the right fork\n", i));
        sem_acquire(RIGHT(i));
    }
    else
    {
        ATOMIC(printf(1, "Philosopher %d is going to pick up the right fork first\n", i));
        sem_acquire(RIGHT(i));
        ATOMIC(printf(1, "Philosopher %d is going to pick up the left fork\n", i));
        sem_acquire(LEFT(i));
    }
    ATOMIC(printf(1, "Philosopher %d has picked up both forks\n", i));
}

void putdown(int i)
{
    sem_release(LEFT(i));
    sem_release(RIGHT(i));
    ATOMIC(printf(1, "Philosopher %d has put down both forks\n", i));
}

void philosopher(int i)
{
    while (1)
    {
        pickup(i);
        eatUntilFull(i);
        putdown(i);
        waitUntilHungry(i);
    }
}

void start()
{
    for (int i = 0; i < 5; i++)
        if (fork() == 0)
        {
            srand(getpid());
            philosopher(i);
            exit();
        }

    for (int i = 0; i < 5; i++)
        wait();
}

int main()
{
    init();
    start();
    exit();
}
