
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char* argv[]) {
    if(argc != 3) {
        printf(2, "the command should be: fcopy_test <src> <dest>\n");
        exit();
    }
    fcopy(argv[1], argv[2]);
    
    exit();
}