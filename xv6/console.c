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
printint(int xx, int base, int sign) {
    static char digits[] = "0123456789abcdef";
    char buf[16];
    int i;
    uint x;

    if (sign && (sign = xx < 0))
        x = -xx;
    else
        x = xx;

    i = 0;
    do {
        buf[i++] = digits[x % base];
    } while ((x /= base) != 0);

    if (sign)
        buf[i++] = '-';

    while (--i >= 0)
        consputc(buf[i]);
}
// PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void cprintf(char* fmt, ...) {
    int i, c, locking;
    uint* argp;
    char* s;

    locking = cons.locking;
    if (locking)
        acquire(&cons.lock);

    if (fmt == 0)
        panic("null fmt");

    argp = (uint*)(void*)(&fmt + 1);
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
        if (c != '%') {
            consputc(c);
            continue;
        }
        c = fmt[++i] & 0xff;
        if (c == 0)
            break;
        switch (c) {
        case 'd':
            printint(*argp++, 10, 1);
            break;
        case 'x':
        case 'p':
            printint(*argp++, 16, 0);
            break;
        case 's':
            if ((s = (char*)*argp++) == 0)
                s = "(null)";
            for (; *s; s++)
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

    if (locking)
        release(&cons.lock);
}

void panic(char* s) {
    int i;
    uint pcs[10];

    cli();
    cons.locking = 0;
    // use lapiccpunum so that we can call panic from mycpu()
    cprintf("lapicid %d: panic: ", lapicid());
    cprintf(s);
    cprintf("\n");
    getcallerpcs(&s, pcs);
    for (i = 0; i < 10; i++)
        cprintf(" %p", pcs[i]);
    panicked = 1; // freeze other CPU
    for (;;)
        ;
}

// PAGEBREAK: 50
#define BACKSPACE 0x100
#define CRTPORT   0x3d4
static ushort* crt = (ushort*)P2V(0xb8000); // CGA memory

// Cursor position: col + 80*row.
static int
getpos(void) {
    int pos;
    outb(CRTPORT, 14);
    pos = inb(CRTPORT + 1) << 8;
    outb(CRTPORT, 15);
    pos |= inb(CRTPORT + 1);
    return pos;
}

// sets cursor position
static void
setpos(int pos) {
    outb(CRTPORT, 14);
    outb(CRTPORT + 1, pos >> 8);
    outb(CRTPORT, 15);
    outb(CRTPORT + 1, pos);
}

// erases character at position
static void
conserasechar(int pos) {
    crt[pos] = ' ' | 0x0700;
}

// writes character at position
static void
conswritechar(int pos, int c) {
    crt[pos] = (c & 0xff) | 0x0700;
}

static void
cgaputc(int c) {
    int pos;

    pos = getpos();

    if (c == '\n')
        pos += 80 - pos % 80;
    else if (c == BACKSPACE) {
        if (pos > 0)
            --pos;
    }
    else
        crt[pos++] = (c & 0xff) | 0x0700; // black on white

    if (pos < 0 || pos > 25 * 80)
        panic("pos under/overflow");

    if ((pos / 80) >= 24) { // Scroll up.
        memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
        pos -= 80;
        memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
    }

    setpos(pos);
    conserasechar(pos);
}

void consputc(int c) {
    if (panicked) {
        cli();
        for (;;)
            ;
    }

    if (c == BACKSPACE) {
        uartputc('\b');
        uartputc(' ');
        uartputc('\b');
    }
    else
        uartputc(c);
    cgaputc(c);
}

#define INPUT_BUF 128

// a struct to store input buffer and its indices (r, w, e)
// it's implemented in a circular way
struct {
    char buf[INPUT_BUF];
    uint r;     // Read idx
    uint w;     // Write idx
    uint e;     // Edit idx
    uint shift; // number of times cursor has been shifted to left (>= 0)
} input;

// to put a string on the console and in the input buffer
void consputs(char* s) {
    for (int i = 0; i < INPUT_BUF && (s[i]); ++i) {
        input.buf[input.e++ % INPUT_BUF] = s[i];
        consputc(s[i]);
    }
}

// functions to move cursor more easily
static void
movpostoend(void) {
    setpos(getpos() + input.shift);
}

static void
movpostoleft(void) {
    setpos(getpos() - 1);
}

static void
movpostoright(void) {
    setpos(getpos() + 1);
}

// erase line and clear input buffer
static void
conseraseline(void) {
    movpostoend();
    input.shift = 0;

    while (input.e != input.w && input.buf[(input.e - 1) % INPUT_BUF] != '\n') {
        input.e--;
        consputc(BACKSPACE);
    }
}

// erase terminal screen
static void
consclear(void) {
    int pos;
    pos = getpos();
    while (pos >= 0)
        conserasechar(pos--);
}

// print shell prompt
static void
consnewcommand(void) {
    conswritechar(0, '$');
    setpos(2);
}

// shifting by one character
static void
inputshiftleft(void) {
    for (int i = input.shift + 1; i > 1; i--)
        input.buf[(input.e - i) % INPUT_BUF] = input.buf[(input.e - i + 1) % INPUT_BUF];

    input.e--;
}

static void
inputshiftright(void) {
    for (int i = 0; i < input.shift; i++)
        input.buf[(input.e - i) % INPUT_BUF] = input.buf[(input.e - i - 1) % INPUT_BUF];
}

// update console after input buffer has been modified
static void
consshiftleft(void) {
    movpostoend();
    for (int i = 0; i <= input.shift; i++)
        consputc(BACKSPACE);
    for (int i = input.shift; i > 0; i--)
        consputc(input.buf[(input.e - i) % INPUT_BUF]);
    setpos(getpos() - input.shift);
}

static void
consshiftright(void) {
    movpostoend();
    for (int i = 0; i < input.shift; i++)
        consputc(BACKSPACE);
    for (int i = input.shift; i >= 0; i--)
        consputc(input.buf[(input.e - i) % INPUT_BUF]);
    setpos(getpos() - input.shift);
}

// to insert a character in the middle of the input buffer and update console
static void
inputputc(char c) {
    if (input.shift == 0) {
        input.buf[input.e % INPUT_BUF] = c;
        consputc(c);
    }
    else {
        inputshiftright();
        input.buf[(input.e - input.shift) % INPUT_BUF] = c;
        consshiftright();
    }
    input.e++;
}

// to delete all numbers in the input buffer and update console
static void
delnums(void) {
    char line[INPUT_BUF];
    int lineidx = 0;
    for (int inputidx = 0; inputidx < input.e - input.w; inputidx++) {
        int idx = (input.w + inputidx) % INPUT_BUF;
        if (input.buf[idx] >= '0' && input.buf[idx] <= '9')
            continue;
        line[lineidx++] = input.buf[idx];
    }
    line[lineidx] = 0;
    conseraseline();
    consputs(line);
}

// to reverse line
static void
revline(char* src, uint len) {
    int i = 0, j = len - 1;
    while (i < j) {
        char tmp = src[i];
        src[i] = src[j];
        src[j] = tmp;
        i++;
        j--;
    }
}

// buffer (history) of entered commands
#define COMMAND_BUF 10
struct {
    char buf[COMMAND_BUF][INPUT_BUF]; // buffer
    int r;                            // range[1,10], read index
    int w;                            // write index
    int intab;                        // whether we are in tab mode
    char tmpcmd[INPUT_BUF];           // temporary command
    int tmpcmdsize;                   // size of temporary command
    int lastusedidx;                  // index of last used command
} cmds;

// load and store cmd
static void
storecmd(void) {
    for (int i = cmds.w - 1; i > 0; i--)
        for (int j = 0; j < INPUT_BUF; j++)
            cmds.buf[i][j] = cmds.buf[i - 1][j];

    int j = 0;
    for (int i = input.w; i < input.e; i++) {
        cmds.buf[0][j] = input.buf[i];
        j++;
    }
    for (; j < INPUT_BUF; j++) {
        cmds.buf[0][j] = 0;
    }
}

static void
loadcmd(void) {
    conseraseline();
    int n = cmds.r - 1;
    for (int i = 0; i < INPUT_BUF; i++) {
        if (cmds.buf[n][i] == 0)
            break;
        input.buf[input.e++ % INPUT_BUF] = cmds.buf[n][i];
        consputc(cmds.buf[n][i]);
    }
}

// for copying current command which has not been processed yet
static void
copycmd(void) {
    for (int i = 0; i < INPUT_BUF; i++) {
        cmds.tmpcmd[i] = input.buf[input.w + i];
        if (cmds.tmpcmd[i] == 0)
            break;
    }
    cmds.tmpcmdsize = input.e - input.w;
}

static void
recovercmd(void) {
    conseraseline();
    for (int i = 0; i < cmds.tmpcmdsize; i++) {
        input.buf[input.e++ % INPUT_BUF] = cmds.tmpcmd[i];
        consputc(cmds.tmpcmd[i]);
    }
}

// predicting command based on input
// the priority is for the most recent command
static int
ispred(const char* cmd, const char* input, int input_size) {
    for (int i = 0; i < input_size; i++)
        if (cmd[i] != input[i])
            return 0;
    return 1;
}

static int
getpred(const char* cmd, uint cmd_size, int lastusedidx) {
    for (int i = lastusedidx; i < cmds.w; i++) {
        if (ispred(cmds.buf[i], cmd, cmd_size))
            return i;
    }
    return -1;
}

static void
predcmd(void) {
    int predicted_cmd = -1;
    if (!cmds.intab) {
        cmds.lastusedidx = 0;
        predicted_cmd = getpred(input.buf + input.w, input.e - input.w, cmds.lastusedidx);
        copycmd();
    }
    else {
        predicted_cmd = getpred(input.buf + input.w, input.e - input.w, cmds.lastusedidx + 1);
    }

    if (predicted_cmd >= 0) {
        cmds.intab = 1;
        cmds.lastusedidx = predicted_cmd;
        conseraseline();
        consputs(cmds.buf[predicted_cmd]);
    }
}

// this function resets everything in cmd
static void
resetcmds(void) {
    cmds.intab = 0;
    cmds.tmpcmd[0] = '\0';
    cmds.tmpcmdsize = 0;
    cmds.lastusedidx = 0;
    cmds.w = ((cmds.w + 1) > COMMAND_BUF ? COMMAND_BUF : (cmds.w + 1));
    storecmd();
    cmds.r = 0;
    movpostoend();
}

#define C(x)       ((x) - '@') // Control-x
#define ARROW_UP   226
#define ARROW_DOWN 227
#define TAB        '\t'

void consoleintr(int (*getc)(void)) {
    int c, doprocdump = 0;

    acquire(&cons.lock);
    while ((c = getc()) >= 0) {
        switch (c) {
        case C('P'): // Process listing.
            // procdump() locks cons.lock indirectly; invoke later
            doprocdump = 1;
            break;

        case C('U'): // Kill line.
            conseraseline();
            break;

        case C('H'):
        case '\x7f': // Backspace
            if ((input.e - input.shift) > input.w) {
                // first we update input
                inputshiftleft();
                // then we update console
                consshiftleft();
            }
            break;

        case C('L'):
            conseraseline();
            consclear();
            consnewcommand();
            break;

        case C('B'):
            if (input.shift < input.e - input.w) {
                input.shift++;
                movpostoleft();
            }
            break;

        case C('F'):
            if (input.shift > 0) {
                input.shift--;
                movpostoright();
            }
            break;

        case C('N'): // Remove numbers
            delnums();
            break;

        case C('R'): // Reverse line
            char line[INPUT_BUF];
            memcpy(line, input.buf + input.w, input.e - input.w);
            line[input.e - input.w] = 0;
            revline(line, input.e - input.w);
            conseraseline();
            consputs(line);
            break;

        case ARROW_UP:
            if (cmds.r == 0)
                copycmd();
            cmds.r++;
            if (cmds.r > cmds.w)
                cmds.r = cmds.w;
            loadcmd();
            break;

        case ARROW_DOWN:
            cmds.r--;
            if (cmds.r > 0)
                loadcmd();
            else {
                cmds.r = 0;
                recovercmd();
            }
            break;

        case TAB:
            predcmd();
            break;

        default:
            if (c != 0 && input.e - input.r < INPUT_BUF) {
                c = (c == '\r') ? '\n' : c;
                if (c == '\n' && input.e - input.w > 0) {
                    resetcmds();
                    input.shift = 0;
                }

                inputputc(c);

                if (c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF) {
                    input.w = input.e;
                    wakeup(&input.r);
                }
            }
            break;
        }
    }
    release(&cons.lock);
    if (doprocdump) {
        procdump(); // now call procdump() wo. cons.lock held
    }
}

int consoleread(struct inode* ip, char* dst, int n) {
    uint target;
    int c;

    iunlock(ip);
    target = n;
    acquire(&cons.lock);
    while (n > 0) {
        while (input.r == input.w) {
            if (myproc()->killed) {
                release(&cons.lock);
                ilock(ip);
                return -1;
            }
            sleep(&input.r, &cons.lock);
        }
        c = input.buf[input.r++ % INPUT_BUF];
        if (c == C('D')) { // EOF
            if (n < target) {
                // Save ^D for next time, to make sure
                // caller gets a 0-byte result.
                input.r--;
            }
            break;
        }
        *dst++ = c;
        --n;
        if (c == '\n')
            break;
    }
    release(&cons.lock);
    ilock(ip);

    return target - n;
}

int consolewrite(struct inode* ip, char* buf, int n) {
    int i;

    iunlock(ip);
    acquire(&cons.lock);
    for (i = 0; i < n; i++)
        consputc(buf[i] & 0xff);
    release(&cons.lock);
    ilock(ip);

    return n;
}

void consoleinit(void) {
    initlock(&cons.lock, "console");

    devsw[CONSOLE].write = consolewrite;
    devsw[CONSOLE].read = consoleread;
    cons.locking = 1;

    ioapicenable(IRQ_KBD, 0);
}
