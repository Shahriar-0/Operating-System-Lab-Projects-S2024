
#include "types.h"
#include "stat.h"
#include "user.h"

void test_ptime(void) {
    int processing_time;

    sleep(5);
    processing_time = ptime();
    printf(1 ,"this process is created: %d milliseconds ago\n", 10 * processing_time);
    sleep(100);
    int second_timer = ptime() - processing_time;
    printf(1 ,"now it passed %d milliseconds again!\n",10 * second_timer);
}

int main(int argc, char* argv[]) {
    test_ptime();
    exit();
}