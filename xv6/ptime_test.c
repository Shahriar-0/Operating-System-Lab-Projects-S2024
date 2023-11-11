
#include "types.h"
#include "stat.h"
#include "user.h"

void test_ptime(void) {
    int processing_time;

    sleep(5);
    processing_time = ptime();
    printf(1 ,"this process is created: %d ago\n", processing_time);
    sleep(5);
    processing_time = ptime();
    printf(1 ,"this process is created: %d ago\n", processing_time);
}

int main(int argc, char* argv[]) {
    
    test_ptime();
    
    exit();
}