// #include "sleeplock.c"
#include "types.h"
#include "stat.h"
#include "user.h"

int main() {

    for(int i = 0; i < 10; i++) {
        if(fork()){
            continue;    
        }
        else {
            printf(1, "%d\n", chcritical());
            exit();
        }
        
            
    }
    while(wait() != -1)
        ;
    
    exit();
}