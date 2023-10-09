// Console input and output.
// Input is from the keyboard or serial port.
// Output is written to the screen and serial port.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"

static void consputc(int);

static int panicked = 0;

static struct {
  struct spinlock lock;
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
    consputc(buf[i]);
}
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
      break;
    }
  }

  if(locking)
    release(&cons.lock);
}

void
panic(char *s)
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  for(;;)
    ;
}

//PAGEBREAK: 50
#define BACKSPACE 0x100
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

#define INPUT_BUF 128
struct {
  char buf[INPUT_BUF];
  uint r;   // Read index
  uint w;   // Write index
  uint e;   // Edit index
  uint len; // Buffer length
} input;

static int
get_cursor_position()
{
  // Cursor position: col + 80*row. 
  outb(CRTPORT, 14);
  int pos = inb(CRTPORT + 1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT + 1);
  return pos;
}

static void
change_cursor_position(int pos)
{
  outb(CRTPORT, 14);
  outb(CRTPORT + 1, pos >> 8);
  outb(CRTPORT, 15);
  outb(CRTPORT + 1, pos);
}

static void
cgaputc(int c)
{
  int pos = get_cursor_position();

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    for(uint i = pos - 1; i < pos + input.len; i++){
      crt[i] = crt[i + 1];
    }
    if(pos > 0) --pos;
  }
  else {
    for(uint i = pos + input.len; i > pos; i--){
      crt[i] = crt[i - 1];
    }
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  }
  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  }

  change_cursor_position(pos);
  // crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
  if(panicked){
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}

#define CURSOR_RIGHT_MODE 0
#define CURSOR_LEFT_MODE  1
static ushort cursor_mode = CURSOR_RIGHT_MODE;

static void
switch_begin()
{
  int pos = get_cursor_position();
  if(crt[pos - 2] == ('$' | 0x0700)) // is cursor at first of line?
    return;
  int change = pos % 80 - 2;
  input.e -= change;
  change_cursor_position(pos - change);
}

static void
switch_end()
{
  int pos = get_cursor_position();
  int change = pos % 80 - 2 - input.len;
  change_cursor_position(pos - change);
}

static void
set_cursor(ushort mode)
{
  if(mode == CURSOR_RIGHT_MODE){
    switch_end();
    cursor_mode = CURSOR_RIGHT_MODE;
    input.e = input.len;
  }
  else if(mode == CURSOR_LEFT_MODE){
    switch_begin();
    cursor_mode = CURSOR_LEFT_MODE;
    input.e = input.w;
  }
}

static void
shift_right_buffer()
{
  for(uint i = input.len; i > input.e; i--)
    input.buf[i % INPUT_BUF] = input.buf[(i - 1) % INPUT_BUF];
}

static void
shift_left_buffer(uint start_index)
{
  for(uint i = start_index; i < input.len; i++)
    input.buf[(i - 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
}

static void
backspace()
{
  int pos = get_cursor_position();
  if(crt[pos - 2] != ('$' | 0x0700) && 
     input.buf[(input.e - 1) % INPUT_BUF] != '\n'){
    if(cursor_mode == CURSOR_LEFT_MODE)
      shift_left_buffer(input.e);
    input.e--;
    input.len--;
    consputc(BACKSPACE);
  }
}

static void
kill_line()
{
  set_cursor(CURSOR_RIGHT_MODE);
  while(1){
    int pos = get_cursor_position();
    if(crt[pos - 2] == ('$' | 0x0700) || 
       input.buf[(input.e - 1) % INPUT_BUF] == '\n'){
      break;
    }
    backspace();
  }
}

static void
delete_last_word()
{
  int pos = get_cursor_position();
  if(crt[pos - 2] == ('$' | 0x0700) || // is cursor at first of line?
      input.buf[(input.e - 1) % INPUT_BUF] == '\n'){
    return;
  }
  
  // remove spaces after last word
  while(input.buf[(input.e - 1) % INPUT_BUF] == ' ')
    backspace();
  
  // remove last word
  while(1){
    int pos = get_cursor_position();
    if(crt[pos - 2] == ('$' | 0x0700) ||
        input.buf[(input.e - 1) % INPUT_BUF] == ' '){
      break;
    }
    backspace();
  }
}

#define C(x)  ((x) - '@')  // Control-x
#define S(x)  ((x) + ' ')  // Shift-x

void
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;

    case C('U'):  // Kill line.
      kill_line();
      break;

    case C('H'): case '\x7f':  // Backspace
      backspace();
      break;

    case S('['):  // Shift + [
      set_cursor(CURSOR_LEFT_MODE);
      break;

    case S(']'):  // Shift + ]
      set_cursor(CURSOR_RIGHT_MODE);
      break;

    case C('W'):  // Ctrl + w
      delete_last_word();
      break;

    case '*':  // Print buffer (just for testing)
      for(uint i = 0; i < input.len; i++)
        consputc(input.buf[i] % INPUT_BUF);
      break;

    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.len++;
        if(cursor_mode == CURSOR_LEFT_MODE)
          shift_right_buffer();
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
          wakeup(&input.r);
        }
      }
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
  uint target;
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
    consputc(buf[i] & 0xff);
  release(&cons.lock);
  ilock(ip);

  return n;
}

void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
}
