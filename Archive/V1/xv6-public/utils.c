#include "types.h"
#include "defs.h"

static uint seed = 1;

void
srand(uint s)
{
  seed = s;
}

uint
rand(void)
{
  seed = seed
    * 1103515245
    + 12345
    % (1 << 31);
  return seed;
}

int
digitcount(int num)
{
  if(num == 0) return 1;
  int count = 0;
  while(num){
    num /= 10;
    ++count;
  }
  return count;
}

void
printspaces(int count)
{
  for(int i = 0; i < count; ++i)
    cprintf(" ");
}
