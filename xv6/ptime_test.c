
#include "types.h"
#include "stat.h"
#include "user.h"

void test_ptime(void) {
    int processing_time;

    sleep(5);
    processing_time = ptime();
    printf(1 ,"this process is created: %d miliseconds ago\n", processing_time);
    sleep(5);
    int second_timer = ptime() - processing_time;
    printf(1 ,"now it passed %d miliseconds again!\n",second_timer);
}

int main(int argc, char* argv[]) {
    
    test_ptime();
    
    exit();
}