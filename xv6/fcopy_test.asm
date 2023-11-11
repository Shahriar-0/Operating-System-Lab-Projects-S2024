
_fcopy_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char* argv[]) {
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 04             	sub    $0x4,%esp
    if(argc != 3) {
  15:	83 39 03             	cmpl   $0x3,(%ecx)
int main(int argc, char* argv[]) {
  18:	8b 41 04             	mov    0x4(%ecx),%eax
    if(argc != 3) {
  1b:	74 13                	je     30 <main+0x30>
        printf(2, "the command should be: fcopy_test <src> <dest>\n");
  1d:	51                   	push   %ecx
  1e:	51                   	push   %ecx
  1f:	68 88 07 00 00       	push   $0x788
  24:	6a 02                	push   $0x2
  26:	e8 f5 03 00 00       	call   420 <printf>
        exit();
  2b:	e8 83 02 00 00       	call   2b3 <exit>
    }
    fcopy(argv[1], argv[2]);
  30:	52                   	push   %edx
  31:	52                   	push   %edx
  32:	ff 70 08             	pushl  0x8(%eax)
  35:	ff 70 04             	pushl  0x4(%eax)
  38:	e8 26 03 00 00       	call   363 <fcopy>
    
    exit();
  3d:	e8 71 02 00 00       	call   2b3 <exit>
  42:	66 90                	xchg   %ax,%ax
  44:	66 90                	xchg   %ax,%ax
  46:	66 90                	xchg   %ax,%ax
  48:	66 90                	xchg   %ax,%ax
  4a:	66 90                	xchg   %ax,%ax
  4c:	66 90                	xchg   %ax,%ax
  4e:	66 90                	xchg   %ax,%ax

00000050 <strcpy>:
#include "stat.h"
#include "fcntl.h"
#include "user.h"
#include "x86.h"

char* strcpy(char* s, const char* t) {
  50:	f3 0f 1e fb          	endbr32 
  54:	55                   	push   %ebp
    char* os;

    os = s;
    while ((*s++ = *t++) != 0)
  55:	31 c0                	xor    %eax,%eax
char* strcpy(char* s, const char* t) {
  57:	89 e5                	mov    %esp,%ebp
  59:	53                   	push   %ebx
  5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  5d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    while ((*s++ = *t++) != 0)
  60:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  64:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  67:	83 c0 01             	add    $0x1,%eax
  6a:	84 d2                	test   %dl,%dl
  6c:	75 f2                	jne    60 <strcpy+0x10>
        ;
    return os;
}
  6e:	89 c8                	mov    %ecx,%eax
  70:	5b                   	pop    %ebx
  71:	5d                   	pop    %ebp
  72:	c3                   	ret    
  73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000080 <strcmp>:

int strcmp(const char* p, const char* q) {
  80:	f3 0f 1e fb          	endbr32 
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	53                   	push   %ebx
  88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8b:	8b 55 0c             	mov    0xc(%ebp),%edx
    while (*p && *p == *q)
  8e:	0f b6 01             	movzbl (%ecx),%eax
  91:	0f b6 1a             	movzbl (%edx),%ebx
  94:	84 c0                	test   %al,%al
  96:	75 19                	jne    b1 <strcmp+0x31>
  98:	eb 26                	jmp    c0 <strcmp+0x40>
  9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  a0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
        p++, q++;
  a4:	83 c1 01             	add    $0x1,%ecx
  a7:	83 c2 01             	add    $0x1,%edx
    while (*p && *p == *q)
  aa:	0f b6 1a             	movzbl (%edx),%ebx
  ad:	84 c0                	test   %al,%al
  af:	74 0f                	je     c0 <strcmp+0x40>
  b1:	38 d8                	cmp    %bl,%al
  b3:	74 eb                	je     a0 <strcmp+0x20>
    return (uchar)*p - (uchar)*q;
  b5:	29 d8                	sub    %ebx,%eax
}
  b7:	5b                   	pop    %ebx
  b8:	5d                   	pop    %ebp
  b9:	c3                   	ret    
  ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  c0:	31 c0                	xor    %eax,%eax
    return (uchar)*p - (uchar)*q;
  c2:	29 d8                	sub    %ebx,%eax
}
  c4:	5b                   	pop    %ebx
  c5:	5d                   	pop    %ebp
  c6:	c3                   	ret    
  c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ce:	66 90                	xchg   %ax,%ax

000000d0 <strlen>:

uint strlen(const char* s) {
  d0:	f3 0f 1e fb          	endbr32 
  d4:	55                   	push   %ebp
  d5:	89 e5                	mov    %esp,%ebp
  d7:	8b 55 08             	mov    0x8(%ebp),%edx
    int n;

    for (n = 0; s[n]; n++)
  da:	80 3a 00             	cmpb   $0x0,(%edx)
  dd:	74 21                	je     100 <strlen+0x30>
  df:	31 c0                	xor    %eax,%eax
  e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  e8:	83 c0 01             	add    $0x1,%eax
  eb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  ef:	89 c1                	mov    %eax,%ecx
  f1:	75 f5                	jne    e8 <strlen+0x18>
        ;
    return n;
}
  f3:	89 c8                	mov    %ecx,%eax
  f5:	5d                   	pop    %ebp
  f6:	c3                   	ret    
  f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  fe:	66 90                	xchg   %ax,%ax
    for (n = 0; s[n]; n++)
 100:	31 c9                	xor    %ecx,%ecx
}
 102:	5d                   	pop    %ebp
 103:	89 c8                	mov    %ecx,%eax
 105:	c3                   	ret    
 106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10d:	8d 76 00             	lea    0x0(%esi),%esi

00000110 <memset>:

void* memset(void* dst, int c, uint n) {
 110:	f3 0f 1e fb          	endbr32 
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	57                   	push   %edi
 118:	8b 55 08             	mov    0x8(%ebp),%edx
                 : "cc");
}

static inline void
stosb(void* addr, int data, int cnt) {
    asm volatile("cld; rep stosb"
 11b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 11e:	8b 45 0c             	mov    0xc(%ebp),%eax
 121:	89 d7                	mov    %edx,%edi
 123:	fc                   	cld    
 124:	f3 aa                	rep stos %al,%es:(%edi)
    stosb(dst, c, n);
    return dst;
}
 126:	89 d0                	mov    %edx,%eax
 128:	5f                   	pop    %edi
 129:	5d                   	pop    %ebp
 12a:	c3                   	ret    
 12b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 12f:	90                   	nop

00000130 <strchr>:

char* strchr(const char* s, char c) {
 130:	f3 0f 1e fb          	endbr32 
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	8b 45 08             	mov    0x8(%ebp),%eax
 13a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
    for (; *s; s++)
 13e:	0f b6 10             	movzbl (%eax),%edx
 141:	84 d2                	test   %dl,%dl
 143:	75 16                	jne    15b <strchr+0x2b>
 145:	eb 21                	jmp    168 <strchr+0x38>
 147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 14e:	66 90                	xchg   %ax,%ax
 150:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 154:	83 c0 01             	add    $0x1,%eax
 157:	84 d2                	test   %dl,%dl
 159:	74 0d                	je     168 <strchr+0x38>
        if (*s == c)
 15b:	38 d1                	cmp    %dl,%cl
 15d:	75 f1                	jne    150 <strchr+0x20>
            return (char*)s;
    return 0;
}
 15f:	5d                   	pop    %ebp
 160:	c3                   	ret    
 161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
 168:	31 c0                	xor    %eax,%eax
}
 16a:	5d                   	pop    %ebp
 16b:	c3                   	ret    
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000170 <gets>:

char* gets(char* buf, int max) {
 170:	f3 0f 1e fb          	endbr32 
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
 177:	57                   	push   %edi
 178:	56                   	push   %esi
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;) {
 179:	31 f6                	xor    %esi,%esi
char* gets(char* buf, int max) {
 17b:	53                   	push   %ebx
 17c:	89 f3                	mov    %esi,%ebx
 17e:	83 ec 1c             	sub    $0x1c,%esp
 181:	8b 7d 08             	mov    0x8(%ebp),%edi
    for (i = 0; i + 1 < max;) {
 184:	eb 33                	jmp    1b9 <gets+0x49>
 186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18d:	8d 76 00             	lea    0x0(%esi),%esi
        cc = read(0, &c, 1);
 190:	83 ec 04             	sub    $0x4,%esp
 193:	8d 45 e7             	lea    -0x19(%ebp),%eax
 196:	6a 01                	push   $0x1
 198:	50                   	push   %eax
 199:	6a 00                	push   $0x0
 19b:	e8 2b 01 00 00       	call   2cb <read>
        if (cc < 1)
 1a0:	83 c4 10             	add    $0x10,%esp
 1a3:	85 c0                	test   %eax,%eax
 1a5:	7e 1c                	jle    1c3 <gets+0x53>
            break;
        buf[i++] = c;
 1a7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1ab:	83 c7 01             	add    $0x1,%edi
 1ae:	88 47 ff             	mov    %al,-0x1(%edi)
        if (c == '\n' || c == '\r')
 1b1:	3c 0a                	cmp    $0xa,%al
 1b3:	74 23                	je     1d8 <gets+0x68>
 1b5:	3c 0d                	cmp    $0xd,%al
 1b7:	74 1f                	je     1d8 <gets+0x68>
    for (i = 0; i + 1 < max;) {
 1b9:	83 c3 01             	add    $0x1,%ebx
 1bc:	89 fe                	mov    %edi,%esi
 1be:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1c1:	7c cd                	jl     190 <gets+0x20>
 1c3:	89 f3                	mov    %esi,%ebx
            break;
    }
    buf[i] = '\0';
    return buf;
}
 1c5:	8b 45 08             	mov    0x8(%ebp),%eax
    buf[i] = '\0';
 1c8:	c6 03 00             	movb   $0x0,(%ebx)
}
 1cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1ce:	5b                   	pop    %ebx
 1cf:	5e                   	pop    %esi
 1d0:	5f                   	pop    %edi
 1d1:	5d                   	pop    %ebp
 1d2:	c3                   	ret    
 1d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1d7:	90                   	nop
 1d8:	8b 75 08             	mov    0x8(%ebp),%esi
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
 1de:	01 de                	add    %ebx,%esi
 1e0:	89 f3                	mov    %esi,%ebx
    buf[i] = '\0';
 1e2:	c6 03 00             	movb   $0x0,(%ebx)
}
 1e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1e8:	5b                   	pop    %ebx
 1e9:	5e                   	pop    %esi
 1ea:	5f                   	pop    %edi
 1eb:	5d                   	pop    %ebp
 1ec:	c3                   	ret    
 1ed:	8d 76 00             	lea    0x0(%esi),%esi

000001f0 <stat>:

int stat(const char* n, struct stat* st) {
 1f0:	f3 0f 1e fb          	endbr32 
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	56                   	push   %esi
 1f8:	53                   	push   %ebx
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 1f9:	83 ec 08             	sub    $0x8,%esp
 1fc:	6a 00                	push   $0x0
 1fe:	ff 75 08             	pushl  0x8(%ebp)
 201:	e8 ed 00 00 00       	call   2f3 <open>
    if (fd < 0)
 206:	83 c4 10             	add    $0x10,%esp
 209:	85 c0                	test   %eax,%eax
 20b:	78 2b                	js     238 <stat+0x48>
        return -1;
    r = fstat(fd, st);
 20d:	83 ec 08             	sub    $0x8,%esp
 210:	ff 75 0c             	pushl  0xc(%ebp)
 213:	89 c3                	mov    %eax,%ebx
 215:	50                   	push   %eax
 216:	e8 f0 00 00 00       	call   30b <fstat>
    close(fd);
 21b:	89 1c 24             	mov    %ebx,(%esp)
    r = fstat(fd, st);
 21e:	89 c6                	mov    %eax,%esi
    close(fd);
 220:	e8 b6 00 00 00       	call   2db <close>
    return r;
 225:	83 c4 10             	add    $0x10,%esp
}
 228:	8d 65 f8             	lea    -0x8(%ebp),%esp
 22b:	89 f0                	mov    %esi,%eax
 22d:	5b                   	pop    %ebx
 22e:	5e                   	pop    %esi
 22f:	5d                   	pop    %ebp
 230:	c3                   	ret    
 231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
 238:	be ff ff ff ff       	mov    $0xffffffff,%esi
 23d:	eb e9                	jmp    228 <stat+0x38>
 23f:	90                   	nop

00000240 <atoi>:

int atoi(const char* s) {
 240:	f3 0f 1e fb          	endbr32 
 244:	55                   	push   %ebp
 245:	89 e5                	mov    %esp,%ebp
 247:	53                   	push   %ebx
 248:	8b 55 08             	mov    0x8(%ebp),%edx
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 24b:	0f be 02             	movsbl (%edx),%eax
 24e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 251:	80 f9 09             	cmp    $0x9,%cl
    n = 0;
 254:	b9 00 00 00 00       	mov    $0x0,%ecx
    while ('0' <= *s && *s <= '9')
 259:	77 1a                	ja     275 <atoi+0x35>
 25b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 25f:	90                   	nop
        n = n * 10 + *s++ - '0';
 260:	83 c2 01             	add    $0x1,%edx
 263:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 266:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
    while ('0' <= *s && *s <= '9')
 26a:	0f be 02             	movsbl (%edx),%eax
 26d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 270:	80 fb 09             	cmp    $0x9,%bl
 273:	76 eb                	jbe    260 <atoi+0x20>
    return n;
}
 275:	89 c8                	mov    %ecx,%eax
 277:	5b                   	pop    %ebx
 278:	5d                   	pop    %ebp
 279:	c3                   	ret    
 27a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000280 <memmove>:

void* memmove(void* vdst, const void* vsrc, int n) {
 280:	f3 0f 1e fb          	endbr32 
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	57                   	push   %edi
 288:	8b 45 10             	mov    0x10(%ebp),%eax
 28b:	8b 55 08             	mov    0x8(%ebp),%edx
 28e:	56                   	push   %esi
 28f:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* dst;
    const char* src;

    dst = vdst;
    src = vsrc;
    while (n-- > 0)
 292:	85 c0                	test   %eax,%eax
 294:	7e 0f                	jle    2a5 <memmove+0x25>
 296:	01 d0                	add    %edx,%eax
    dst = vdst;
 298:	89 d7                	mov    %edx,%edi
 29a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        *dst++ = *src++;
 2a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while (n-- > 0)
 2a1:	39 f8                	cmp    %edi,%eax
 2a3:	75 fb                	jne    2a0 <memmove+0x20>
    return vdst;
}
 2a5:	5e                   	pop    %esi
 2a6:	89 d0                	mov    %edx,%eax
 2a8:	5f                   	pop    %edi
 2a9:	5d                   	pop    %ebp
 2aa:	c3                   	ret    

000002ab <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ab:	b8 01 00 00 00       	mov    $0x1,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <exit>:
SYSCALL(exit)
 2b3:	b8 02 00 00 00       	mov    $0x2,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <wait>:
SYSCALL(wait)
 2bb:	b8 03 00 00 00       	mov    $0x3,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <pipe>:
SYSCALL(pipe)
 2c3:	b8 04 00 00 00       	mov    $0x4,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <read>:
SYSCALL(read)
 2cb:	b8 05 00 00 00       	mov    $0x5,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <write>:
SYSCALL(write)
 2d3:	b8 10 00 00 00       	mov    $0x10,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <close>:
SYSCALL(close)
 2db:	b8 15 00 00 00       	mov    $0x15,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <kill>:
SYSCALL(kill)
 2e3:	b8 06 00 00 00       	mov    $0x6,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <exec>:
SYSCALL(exec)
 2eb:	b8 07 00 00 00       	mov    $0x7,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <open>:
SYSCALL(open)
 2f3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <mknod>:
SYSCALL(mknod)
 2fb:	b8 11 00 00 00       	mov    $0x11,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <unlink>:
SYSCALL(unlink)
 303:	b8 12 00 00 00       	mov    $0x12,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <fstat>:
SYSCALL(fstat)
 30b:	b8 08 00 00 00       	mov    $0x8,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <link>:
SYSCALL(link)
 313:	b8 13 00 00 00       	mov    $0x13,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <mkdir>:
SYSCALL(mkdir)
 31b:	b8 14 00 00 00       	mov    $0x14,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <chdir>:
SYSCALL(chdir)
 323:	b8 09 00 00 00       	mov    $0x9,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <dup>:
SYSCALL(dup)
 32b:	b8 0a 00 00 00       	mov    $0xa,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <getpid>:
SYSCALL(getpid)
 333:	b8 0b 00 00 00       	mov    $0xb,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <sbrk>:
SYSCALL(sbrk)
 33b:	b8 0c 00 00 00       	mov    $0xc,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <sleep>:
SYSCALL(sleep)
 343:	b8 0d 00 00 00       	mov    $0xd,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <uptime>:
SYSCALL(uptime)
 34b:	b8 0e 00 00 00       	mov    $0xe,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <nuncle>:
SYSCALL(nuncle)
 353:	b8 16 00 00 00       	mov    $0x16,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <ptime>:
SYSCALL(ptime)
 35b:	b8 17 00 00 00       	mov    $0x17,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <fcopy>:
SYSCALL(fcopy)
 363:	b8 18 00 00 00       	mov    $0x18,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    
 36b:	66 90                	xchg   %ax,%ax
 36d:	66 90                	xchg   %ax,%ax
 36f:	90                   	nop

00000370 <printint>:
putc(int fd, char c) {
    write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn) {
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	57                   	push   %edi
 374:	56                   	push   %esi
 375:	53                   	push   %ebx
 376:	83 ec 3c             	sub    $0x3c,%esp
 379:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
    uint x;

    neg = 0;
    if (sgn && xx < 0) {
        neg = 1;
        x = -xx;
 37c:	89 d1                	mov    %edx,%ecx
printint(int fd, int xx, int base, int sgn) {
 37e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    if (sgn && xx < 0) {
 381:	85 d2                	test   %edx,%edx
 383:	0f 89 7f 00 00 00    	jns    408 <printint+0x98>
 389:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 38d:	74 79                	je     408 <printint+0x98>
        neg = 1;
 38f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
        x = -xx;
 396:	f7 d9                	neg    %ecx
    }
    else {
        x = xx;
    }

    i = 0;
 398:	31 db                	xor    %ebx,%ebx
 39a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 39d:	8d 76 00             	lea    0x0(%esi),%esi
    do {
        buf[i++] = digits[x % base];
 3a0:	89 c8                	mov    %ecx,%eax
 3a2:	31 d2                	xor    %edx,%edx
 3a4:	89 cf                	mov    %ecx,%edi
 3a6:	f7 75 c4             	divl   -0x3c(%ebp)
 3a9:	0f b6 92 c0 07 00 00 	movzbl 0x7c0(%edx),%edx
 3b0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 3b3:	89 d8                	mov    %ebx,%eax
 3b5:	8d 5b 01             	lea    0x1(%ebx),%ebx
    } while ((x /= base) != 0);
 3b8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
        buf[i++] = digits[x % base];
 3bb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
    } while ((x /= base) != 0);
 3be:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 3c1:	76 dd                	jbe    3a0 <printint+0x30>
    if (neg)
 3c3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 3c6:	85 c9                	test   %ecx,%ecx
 3c8:	74 0c                	je     3d6 <printint+0x66>
        buf[i++] = '-';
 3ca:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
        buf[i++] = digits[x % base];
 3cf:	89 d8                	mov    %ebx,%eax
        buf[i++] = '-';
 3d1:	ba 2d 00 00 00       	mov    $0x2d,%edx

    while (--i >= 0)
 3d6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 3d9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 3dd:	eb 07                	jmp    3e6 <printint+0x76>
 3df:	90                   	nop
 3e0:	0f b6 13             	movzbl (%ebx),%edx
 3e3:	83 eb 01             	sub    $0x1,%ebx
    write(fd, &c, 1);
 3e6:	83 ec 04             	sub    $0x4,%esp
 3e9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 3ec:	6a 01                	push   $0x1
 3ee:	56                   	push   %esi
 3ef:	57                   	push   %edi
 3f0:	e8 de fe ff ff       	call   2d3 <write>
    while (--i >= 0)
 3f5:	83 c4 10             	add    $0x10,%esp
 3f8:	39 de                	cmp    %ebx,%esi
 3fa:	75 e4                	jne    3e0 <printint+0x70>
        putc(fd, buf[i]);
}
 3fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ff:	5b                   	pop    %ebx
 400:	5e                   	pop    %esi
 401:	5f                   	pop    %edi
 402:	5d                   	pop    %ebp
 403:	c3                   	ret    
 404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    neg = 0;
 408:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 40f:	eb 87                	jmp    398 <printint+0x28>
 411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 418:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 41f:	90                   	nop

00000420 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void printf(int fd, const char* fmt, ...) {
 420:	f3 0f 1e fb          	endbr32 
 424:	55                   	push   %ebp
 425:	89 e5                	mov    %esp,%ebp
 427:	57                   	push   %edi
 428:	56                   	push   %esi
 429:	53                   	push   %ebx
 42a:	83 ec 2c             	sub    $0x2c,%esp
    int c, i, state;
    uint* ap;

    state = 0;
    ap = (uint*)(void*)&fmt + 1;
    for (i = 0; fmt[i]; i++) {
 42d:	8b 75 0c             	mov    0xc(%ebp),%esi
 430:	0f b6 1e             	movzbl (%esi),%ebx
 433:	84 db                	test   %bl,%bl
 435:	0f 84 b4 00 00 00    	je     4ef <printf+0xcf>
    ap = (uint*)(void*)&fmt + 1;
 43b:	8d 45 10             	lea    0x10(%ebp),%eax
 43e:	83 c6 01             	add    $0x1,%esi
    write(fd, &c, 1);
 441:	8d 7d e7             	lea    -0x19(%ebp),%edi
    state = 0;
 444:	31 d2                	xor    %edx,%edx
    ap = (uint*)(void*)&fmt + 1;
 446:	89 45 d0             	mov    %eax,-0x30(%ebp)
 449:	eb 33                	jmp    47e <printf+0x5e>
 44b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 44f:	90                   	nop
 450:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        c = fmt[i] & 0xff;
        if (state == 0) {
            if (c == '%') {
                state = '%';
 453:	ba 25 00 00 00       	mov    $0x25,%edx
            if (c == '%') {
 458:	83 f8 25             	cmp    $0x25,%eax
 45b:	74 17                	je     474 <printf+0x54>
    write(fd, &c, 1);
 45d:	83 ec 04             	sub    $0x4,%esp
 460:	88 5d e7             	mov    %bl,-0x19(%ebp)
 463:	6a 01                	push   $0x1
 465:	57                   	push   %edi
 466:	ff 75 08             	pushl  0x8(%ebp)
 469:	e8 65 fe ff ff       	call   2d3 <write>
 46e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
            }
            else {
                putc(fd, c);
 471:	83 c4 10             	add    $0x10,%esp
    for (i = 0; fmt[i]; i++) {
 474:	0f b6 1e             	movzbl (%esi),%ebx
 477:	83 c6 01             	add    $0x1,%esi
 47a:	84 db                	test   %bl,%bl
 47c:	74 71                	je     4ef <printf+0xcf>
        c = fmt[i] & 0xff;
 47e:	0f be cb             	movsbl %bl,%ecx
 481:	0f b6 c3             	movzbl %bl,%eax
        if (state == 0) {
 484:	85 d2                	test   %edx,%edx
 486:	74 c8                	je     450 <printf+0x30>
            }
        }
        else if (state == '%') {
 488:	83 fa 25             	cmp    $0x25,%edx
 48b:	75 e7                	jne    474 <printf+0x54>
            if (c == 'd') {
 48d:	83 f8 64             	cmp    $0x64,%eax
 490:	0f 84 9a 00 00 00    	je     530 <printf+0x110>
                printint(fd, *ap, 10, 1);
                ap++;
            }
            else if (c == 'x' || c == 'p') {
 496:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 49c:	83 f9 70             	cmp    $0x70,%ecx
 49f:	74 5f                	je     500 <printf+0xe0>
                printint(fd, *ap, 16, 0);
                ap++;
            }
            else if (c == 's') {
 4a1:	83 f8 73             	cmp    $0x73,%eax
 4a4:	0f 84 d6 00 00 00    	je     580 <printf+0x160>
                while (*s != 0) {
                    putc(fd, *s);
                    s++;
                }
            }
            else if (c == 'c') {
 4aa:	83 f8 63             	cmp    $0x63,%eax
 4ad:	0f 84 8d 00 00 00    	je     540 <printf+0x120>
                putc(fd, *ap);
                ap++;
            }
            else if (c == '%') {
 4b3:	83 f8 25             	cmp    $0x25,%eax
 4b6:	0f 84 b4 00 00 00    	je     570 <printf+0x150>
    write(fd, &c, 1);
 4bc:	83 ec 04             	sub    $0x4,%esp
 4bf:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4c3:	6a 01                	push   $0x1
 4c5:	57                   	push   %edi
 4c6:	ff 75 08             	pushl  0x8(%ebp)
 4c9:	e8 05 fe ff ff       	call   2d3 <write>
                putc(fd, c);
            }
            else {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
                putc(fd, c);
 4ce:	88 5d e7             	mov    %bl,-0x19(%ebp)
    write(fd, &c, 1);
 4d1:	83 c4 0c             	add    $0xc,%esp
 4d4:	6a 01                	push   $0x1
 4d6:	83 c6 01             	add    $0x1,%esi
 4d9:	57                   	push   %edi
 4da:	ff 75 08             	pushl  0x8(%ebp)
 4dd:	e8 f1 fd ff ff       	call   2d3 <write>
    for (i = 0; fmt[i]; i++) {
 4e2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
                putc(fd, c);
 4e6:	83 c4 10             	add    $0x10,%esp
            }
            state = 0;
 4e9:	31 d2                	xor    %edx,%edx
    for (i = 0; fmt[i]; i++) {
 4eb:	84 db                	test   %bl,%bl
 4ed:	75 8f                	jne    47e <printf+0x5e>
        }
    }
}
 4ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4f2:	5b                   	pop    %ebx
 4f3:	5e                   	pop    %esi
 4f4:	5f                   	pop    %edi
 4f5:	5d                   	pop    %ebp
 4f6:	c3                   	ret    
 4f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4fe:	66 90                	xchg   %ax,%ax
                printint(fd, *ap, 16, 0);
 500:	83 ec 0c             	sub    $0xc,%esp
 503:	b9 10 00 00 00       	mov    $0x10,%ecx
 508:	6a 00                	push   $0x0
 50a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 50d:	8b 45 08             	mov    0x8(%ebp),%eax
 510:	8b 13                	mov    (%ebx),%edx
 512:	e8 59 fe ff ff       	call   370 <printint>
                ap++;
 517:	89 d8                	mov    %ebx,%eax
 519:	83 c4 10             	add    $0x10,%esp
            state = 0;
 51c:	31 d2                	xor    %edx,%edx
                ap++;
 51e:	83 c0 04             	add    $0x4,%eax
 521:	89 45 d0             	mov    %eax,-0x30(%ebp)
 524:	e9 4b ff ff ff       	jmp    474 <printf+0x54>
 529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                printint(fd, *ap, 10, 1);
 530:	83 ec 0c             	sub    $0xc,%esp
 533:	b9 0a 00 00 00       	mov    $0xa,%ecx
 538:	6a 01                	push   $0x1
 53a:	eb ce                	jmp    50a <printf+0xea>
 53c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                putc(fd, *ap);
 540:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    write(fd, &c, 1);
 543:	83 ec 04             	sub    $0x4,%esp
                putc(fd, *ap);
 546:	8b 03                	mov    (%ebx),%eax
    write(fd, &c, 1);
 548:	6a 01                	push   $0x1
                ap++;
 54a:	83 c3 04             	add    $0x4,%ebx
    write(fd, &c, 1);
 54d:	57                   	push   %edi
 54e:	ff 75 08             	pushl  0x8(%ebp)
                putc(fd, *ap);
 551:	88 45 e7             	mov    %al,-0x19(%ebp)
    write(fd, &c, 1);
 554:	e8 7a fd ff ff       	call   2d3 <write>
                ap++;
 559:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 55c:	83 c4 10             	add    $0x10,%esp
            state = 0;
 55f:	31 d2                	xor    %edx,%edx
 561:	e9 0e ff ff ff       	jmp    474 <printf+0x54>
 566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 56d:	8d 76 00             	lea    0x0(%esi),%esi
                putc(fd, c);
 570:	88 5d e7             	mov    %bl,-0x19(%ebp)
    write(fd, &c, 1);
 573:	83 ec 04             	sub    $0x4,%esp
 576:	e9 59 ff ff ff       	jmp    4d4 <printf+0xb4>
 57b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 57f:	90                   	nop
                s = (char*)*ap;
 580:	8b 45 d0             	mov    -0x30(%ebp),%eax
 583:	8b 18                	mov    (%eax),%ebx
                ap++;
 585:	83 c0 04             	add    $0x4,%eax
 588:	89 45 d0             	mov    %eax,-0x30(%ebp)
                if (s == 0)
 58b:	85 db                	test   %ebx,%ebx
 58d:	74 17                	je     5a6 <printf+0x186>
                while (*s != 0) {
 58f:	0f b6 03             	movzbl (%ebx),%eax
            state = 0;
 592:	31 d2                	xor    %edx,%edx
                while (*s != 0) {
 594:	84 c0                	test   %al,%al
 596:	0f 84 d8 fe ff ff    	je     474 <printf+0x54>
 59c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 59f:	89 de                	mov    %ebx,%esi
 5a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5a4:	eb 1a                	jmp    5c0 <printf+0x1a0>
                    s = "(null)";
 5a6:	bb b8 07 00 00       	mov    $0x7b8,%ebx
                while (*s != 0) {
 5ab:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 5ae:	b8 28 00 00 00       	mov    $0x28,%eax
 5b3:	89 de                	mov    %ebx,%esi
 5b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5bf:	90                   	nop
    write(fd, &c, 1);
 5c0:	83 ec 04             	sub    $0x4,%esp
                    s++;
 5c3:	83 c6 01             	add    $0x1,%esi
 5c6:	88 45 e7             	mov    %al,-0x19(%ebp)
    write(fd, &c, 1);
 5c9:	6a 01                	push   $0x1
 5cb:	57                   	push   %edi
 5cc:	53                   	push   %ebx
 5cd:	e8 01 fd ff ff       	call   2d3 <write>
                while (*s != 0) {
 5d2:	0f b6 06             	movzbl (%esi),%eax
 5d5:	83 c4 10             	add    $0x10,%esp
 5d8:	84 c0                	test   %al,%al
 5da:	75 e4                	jne    5c0 <printf+0x1a0>
 5dc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
            state = 0;
 5df:	31 d2                	xor    %edx,%edx
 5e1:	e9 8e fe ff ff       	jmp    474 <printf+0x54>
 5e6:	66 90                	xchg   %ax,%ax
 5e8:	66 90                	xchg   %ax,%ax
 5ea:	66 90                	xchg   %ax,%ax
 5ec:	66 90                	xchg   %ax,%ax
 5ee:	66 90                	xchg   %ax,%ax

000005f0 <free>:
typedef union header Header;

static Header base;
static Header* freep;

void free(void* ap) {
 5f0:	f3 0f 1e fb          	endbr32 
 5f4:	55                   	push   %ebp
    Header *bp, *p;

    bp = (Header*)ap - 1;
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f5:	a1 68 0a 00 00       	mov    0xa68,%eax
void free(void* ap) {
 5fa:	89 e5                	mov    %esp,%ebp
 5fc:	57                   	push   %edi
 5fd:	56                   	push   %esi
 5fe:	53                   	push   %ebx
 5ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
 602:	8b 10                	mov    (%eax),%edx
    bp = (Header*)ap - 1;
 604:	8d 4b f8             	lea    -0x8(%ebx),%ecx
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 607:	39 c8                	cmp    %ecx,%eax
 609:	73 15                	jae    620 <free+0x30>
 60b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 60f:	90                   	nop
 610:	39 d1                	cmp    %edx,%ecx
 612:	72 14                	jb     628 <free+0x38>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 614:	39 d0                	cmp    %edx,%eax
 616:	73 10                	jae    628 <free+0x38>
void free(void* ap) {
 618:	89 d0                	mov    %edx,%eax
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61a:	8b 10                	mov    (%eax),%edx
 61c:	39 c8                	cmp    %ecx,%eax
 61e:	72 f0                	jb     610 <free+0x20>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 620:	39 d0                	cmp    %edx,%eax
 622:	72 f4                	jb     618 <free+0x28>
 624:	39 d1                	cmp    %edx,%ecx
 626:	73 f0                	jae    618 <free+0x28>
            break;
    if (bp + bp->s.size == p->s.ptr) {
 628:	8b 73 fc             	mov    -0x4(%ebx),%esi
 62b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 62e:	39 fa                	cmp    %edi,%edx
 630:	74 1e                	je     650 <free+0x60>
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
    }
    else
        bp->s.ptr = p->s.ptr;
 632:	89 53 f8             	mov    %edx,-0x8(%ebx)
    if (p + p->s.size == bp) {
 635:	8b 50 04             	mov    0x4(%eax),%edx
 638:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 63b:	39 f1                	cmp    %esi,%ecx
 63d:	74 28                	je     667 <free+0x77>
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
    }
    else
        p->s.ptr = bp;
 63f:	89 08                	mov    %ecx,(%eax)
    freep = p;
}
 641:	5b                   	pop    %ebx
    freep = p;
 642:	a3 68 0a 00 00       	mov    %eax,0xa68
}
 647:	5e                   	pop    %esi
 648:	5f                   	pop    %edi
 649:	5d                   	pop    %ebp
 64a:	c3                   	ret    
 64b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 64f:	90                   	nop
        bp->s.size += p->s.ptr->s.size;
 650:	03 72 04             	add    0x4(%edx),%esi
 653:	89 73 fc             	mov    %esi,-0x4(%ebx)
        bp->s.ptr = p->s.ptr->s.ptr;
 656:	8b 10                	mov    (%eax),%edx
 658:	8b 12                	mov    (%edx),%edx
 65a:	89 53 f8             	mov    %edx,-0x8(%ebx)
    if (p + p->s.size == bp) {
 65d:	8b 50 04             	mov    0x4(%eax),%edx
 660:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 663:	39 f1                	cmp    %esi,%ecx
 665:	75 d8                	jne    63f <free+0x4f>
        p->s.size += bp->s.size;
 667:	03 53 fc             	add    -0x4(%ebx),%edx
    freep = p;
 66a:	a3 68 0a 00 00       	mov    %eax,0xa68
        p->s.size += bp->s.size;
 66f:	89 50 04             	mov    %edx,0x4(%eax)
        p->s.ptr = bp->s.ptr;
 672:	8b 53 f8             	mov    -0x8(%ebx),%edx
 675:	89 10                	mov    %edx,(%eax)
}
 677:	5b                   	pop    %ebx
 678:	5e                   	pop    %esi
 679:	5f                   	pop    %edi
 67a:	5d                   	pop    %ebp
 67b:	c3                   	ret    
 67c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000680 <malloc>:
    hp->s.size = nu;
    free((void*)(hp + 1));
    return freep;
}

void* malloc(uint nbytes) {
 680:	f3 0f 1e fb          	endbr32 
 684:	55                   	push   %ebp
 685:	89 e5                	mov    %esp,%ebp
 687:	57                   	push   %edi
 688:	56                   	push   %esi
 689:	53                   	push   %ebx
 68a:	83 ec 1c             	sub    $0x1c,%esp
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 68d:	8b 45 08             	mov    0x8(%ebp),%eax
    if ((prevp = freep) == 0) {
 690:	8b 3d 68 0a 00 00    	mov    0xa68,%edi
    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 696:	8d 70 07             	lea    0x7(%eax),%esi
 699:	c1 ee 03             	shr    $0x3,%esi
 69c:	83 c6 01             	add    $0x1,%esi
    if ((prevp = freep) == 0) {
 69f:	85 ff                	test   %edi,%edi
 6a1:	0f 84 a9 00 00 00    	je     750 <malloc+0xd0>
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 6a7:	8b 07                	mov    (%edi),%eax
        if (p->s.size >= nunits) {
 6a9:	8b 48 04             	mov    0x4(%eax),%ecx
 6ac:	39 f1                	cmp    %esi,%ecx
 6ae:	73 6d                	jae    71d <malloc+0x9d>
 6b0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 6b6:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6bb:	0f 43 de             	cmovae %esi,%ebx
    p = sbrk(nu * sizeof(Header));
 6be:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 6c5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 6c8:	eb 17                	jmp    6e1 <malloc+0x61>
 6ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 6d0:	8b 10                	mov    (%eax),%edx
        if (p->s.size >= nunits) {
 6d2:	8b 4a 04             	mov    0x4(%edx),%ecx
 6d5:	39 f1                	cmp    %esi,%ecx
 6d7:	73 4f                	jae    728 <malloc+0xa8>
 6d9:	8b 3d 68 0a 00 00    	mov    0xa68,%edi
 6df:	89 d0                	mov    %edx,%eax
                p->s.size = nunits;
            }
            freep = prevp;
            return (void*)(p + 1);
        }
        if (p == freep)
 6e1:	39 c7                	cmp    %eax,%edi
 6e3:	75 eb                	jne    6d0 <malloc+0x50>
    p = sbrk(nu * sizeof(Header));
 6e5:	83 ec 0c             	sub    $0xc,%esp
 6e8:	ff 75 e4             	pushl  -0x1c(%ebp)
 6eb:	e8 4b fc ff ff       	call   33b <sbrk>
    if (p == (char*)-1)
 6f0:	83 c4 10             	add    $0x10,%esp
 6f3:	83 f8 ff             	cmp    $0xffffffff,%eax
 6f6:	74 1b                	je     713 <malloc+0x93>
    hp->s.size = nu;
 6f8:	89 58 04             	mov    %ebx,0x4(%eax)
    free((void*)(hp + 1));
 6fb:	83 ec 0c             	sub    $0xc,%esp
 6fe:	83 c0 08             	add    $0x8,%eax
 701:	50                   	push   %eax
 702:	e8 e9 fe ff ff       	call   5f0 <free>
    return freep;
 707:	a1 68 0a 00 00       	mov    0xa68,%eax
            if ((p = morecore(nunits)) == 0)
 70c:	83 c4 10             	add    $0x10,%esp
 70f:	85 c0                	test   %eax,%eax
 711:	75 bd                	jne    6d0 <malloc+0x50>
                return 0;
    }
}
 713:	8d 65 f4             	lea    -0xc(%ebp),%esp
                return 0;
 716:	31 c0                	xor    %eax,%eax
}
 718:	5b                   	pop    %ebx
 719:	5e                   	pop    %esi
 71a:	5f                   	pop    %edi
 71b:	5d                   	pop    %ebp
 71c:	c3                   	ret    
        if (p->s.size >= nunits) {
 71d:	89 c2                	mov    %eax,%edx
 71f:	89 f8                	mov    %edi,%eax
 721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            if (p->s.size == nunits)
 728:	39 ce                	cmp    %ecx,%esi
 72a:	74 54                	je     780 <malloc+0x100>
                p->s.size -= nunits;
 72c:	29 f1                	sub    %esi,%ecx
 72e:	89 4a 04             	mov    %ecx,0x4(%edx)
                p += p->s.size;
 731:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
                p->s.size = nunits;
 734:	89 72 04             	mov    %esi,0x4(%edx)
            freep = prevp;
 737:	a3 68 0a 00 00       	mov    %eax,0xa68
}
 73c:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return (void*)(p + 1);
 73f:	8d 42 08             	lea    0x8(%edx),%eax
}
 742:	5b                   	pop    %ebx
 743:	5e                   	pop    %esi
 744:	5f                   	pop    %edi
 745:	5d                   	pop    %ebp
 746:	c3                   	ret    
 747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 74e:	66 90                	xchg   %ax,%ax
        base.s.ptr = freep = prevp = &base;
 750:	c7 05 68 0a 00 00 6c 	movl   $0xa6c,0xa68
 757:	0a 00 00 
        base.s.size = 0;
 75a:	bf 6c 0a 00 00       	mov    $0xa6c,%edi
        base.s.ptr = freep = prevp = &base;
 75f:	c7 05 6c 0a 00 00 6c 	movl   $0xa6c,0xa6c
 766:	0a 00 00 
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 769:	89 f8                	mov    %edi,%eax
        base.s.size = 0;
 76b:	c7 05 70 0a 00 00 00 	movl   $0x0,0xa70
 772:	00 00 00 
        if (p->s.size >= nunits) {
 775:	e9 36 ff ff ff       	jmp    6b0 <malloc+0x30>
 77a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                prevp->s.ptr = p->s.ptr;
 780:	8b 0a                	mov    (%edx),%ecx
 782:	89 08                	mov    %ecx,(%eax)
 784:	eb b1                	jmp    737 <malloc+0xb7>
