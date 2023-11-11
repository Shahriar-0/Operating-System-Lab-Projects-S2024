
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "fcntl.h"

char* argv[] = {"sh", 0};

int main(void) {
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	53                   	push   %ebx
  12:	51                   	push   %ecx
    int pid, wpid;

    if (open("console", O_RDWR) < 0) {
  13:	83 ec 08             	sub    $0x8,%esp
  16:	6a 02                	push   $0x2
  18:	68 38 08 00 00       	push   $0x838
  1d:	e8 81 03 00 00       	call   3a3 <open>
  22:	83 c4 10             	add    $0x10,%esp
  25:	85 c0                	test   %eax,%eax
  27:	0f 88 ab 00 00 00    	js     d8 <main+0xd8>
        mknod("console", 1, 1);
        open("console", O_RDWR);
    }
    dup(0); // stdout
  2d:	83 ec 0c             	sub    $0xc,%esp
  30:	6a 00                	push   $0x0
  32:	e8 a4 03 00 00       	call   3db <dup>
    dup(0); // stderr
  37:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3e:	e8 98 03 00 00       	call   3db <dup>
  43:	83 c4 10             	add    $0x10,%esp
  46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  4d:	8d 76 00             	lea    0x0(%esi),%esi

    for (;;) {
        printf(1, "init: starting sh\n");
  50:	83 ec 08             	sub    $0x8,%esp
  53:	68 40 08 00 00       	push   $0x840
  58:	6a 01                	push   $0x1
  5a:	e8 71 04 00 00       	call   4d0 <printf>
        printf(1, "Group #17:\n- Sobhan Alaedini\n- Shahriar Attar\n- Matin Bazrafshan\n");
  5f:	58                   	pop    %eax
  60:	5a                   	pop    %edx
  61:	68 88 08 00 00       	push   $0x888
  66:	6a 01                	push   $0x1
  68:	e8 63 04 00 00       	call   4d0 <printf>
        pid = fork();
  6d:	e8 e9 02 00 00       	call   35b <fork>
        if (pid < 0) {
  72:	83 c4 10             	add    $0x10,%esp
        pid = fork();
  75:	89 c3                	mov    %eax,%ebx
        if (pid < 0) {
  77:	85 c0                	test   %eax,%eax
  79:	78 26                	js     a1 <main+0xa1>
            printf(1, "init: fork failed\n");
            exit();
        }
        if (pid == 0) {
  7b:	74 37                	je     b4 <main+0xb4>
  7d:	8d 76 00             	lea    0x0(%esi),%esi
            exec("sh", argv);
            printf(1, "init: exec sh failed\n");
            exit();
        }
        while ((wpid = wait()) >= 0 && wpid != pid)
  80:	e8 e6 02 00 00       	call   36b <wait>
  85:	85 c0                	test   %eax,%eax
  87:	78 c7                	js     50 <main+0x50>
  89:	39 c3                	cmp    %eax,%ebx
  8b:	74 c3                	je     50 <main+0x50>
            printf(1, "zombie!\n");
  8d:	83 ec 08             	sub    $0x8,%esp
  90:	68 7f 08 00 00       	push   $0x87f
  95:	6a 01                	push   $0x1
  97:	e8 34 04 00 00       	call   4d0 <printf>
  9c:	83 c4 10             	add    $0x10,%esp
  9f:	eb df                	jmp    80 <main+0x80>
            printf(1, "init: fork failed\n");
  a1:	53                   	push   %ebx
  a2:	53                   	push   %ebx
  a3:	68 53 08 00 00       	push   $0x853
  a8:	6a 01                	push   $0x1
  aa:	e8 21 04 00 00       	call   4d0 <printf>
            exit();
  af:	e8 af 02 00 00       	call   363 <exit>
            exec("sh", argv);
  b4:	50                   	push   %eax
  b5:	50                   	push   %eax
  b6:	68 80 0b 00 00       	push   $0xb80
  bb:	68 66 08 00 00       	push   $0x866
  c0:	e8 d6 02 00 00       	call   39b <exec>
            printf(1, "init: exec sh failed\n");
  c5:	5a                   	pop    %edx
  c6:	59                   	pop    %ecx
  c7:	68 69 08 00 00       	push   $0x869
  cc:	6a 01                	push   $0x1
  ce:	e8 fd 03 00 00       	call   4d0 <printf>
            exit();
  d3:	e8 8b 02 00 00       	call   363 <exit>
        mknod("console", 1, 1);
  d8:	51                   	push   %ecx
  d9:	6a 01                	push   $0x1
  db:	6a 01                	push   $0x1
  dd:	68 38 08 00 00       	push   $0x838
  e2:	e8 c4 02 00 00       	call   3ab <mknod>
        open("console", O_RDWR);
  e7:	5b                   	pop    %ebx
  e8:	58                   	pop    %eax
  e9:	6a 02                	push   $0x2
  eb:	68 38 08 00 00       	push   $0x838
  f0:	e8 ae 02 00 00       	call   3a3 <open>
  f5:	83 c4 10             	add    $0x10,%esp
  f8:	e9 30 ff ff ff       	jmp    2d <main+0x2d>
  fd:	66 90                	xchg   %ax,%ax
  ff:	90                   	nop

00000100 <strcpy>:
#include "stat.h"
#include "fcntl.h"
#include "user.h"
#include "x86.h"

char* strcpy(char* s, const char* t) {
 100:	f3 0f 1e fb          	endbr32 
 104:	55                   	push   %ebp
    char* os;

    os = s;
    while ((*s++ = *t++) != 0)
 105:	31 c0                	xor    %eax,%eax
char* strcpy(char* s, const char* t) {
 107:	89 e5                	mov    %esp,%ebp
 109:	53                   	push   %ebx
 10a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 10d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    while ((*s++ = *t++) != 0)
 110:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 114:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 117:	83 c0 01             	add    $0x1,%eax
 11a:	84 d2                	test   %dl,%dl
 11c:	75 f2                	jne    110 <strcpy+0x10>
        ;
    return os;
}
 11e:	89 c8                	mov    %ecx,%eax
 120:	5b                   	pop    %ebx
 121:	5d                   	pop    %ebp
 122:	c3                   	ret    
 123:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 12a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000130 <strcmp>:

int strcmp(const char* p, const char* q) {
 130:	f3 0f 1e fb          	endbr32 
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	53                   	push   %ebx
 138:	8b 4d 08             	mov    0x8(%ebp),%ecx
 13b:	8b 55 0c             	mov    0xc(%ebp),%edx
    while (*p && *p == *q)
 13e:	0f b6 01             	movzbl (%ecx),%eax
 141:	0f b6 1a             	movzbl (%edx),%ebx
 144:	84 c0                	test   %al,%al
 146:	75 19                	jne    161 <strcmp+0x31>
 148:	eb 26                	jmp    170 <strcmp+0x40>
 14a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 150:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
        p++, q++;
 154:	83 c1 01             	add    $0x1,%ecx
 157:	83 c2 01             	add    $0x1,%edx
    while (*p && *p == *q)
 15a:	0f b6 1a             	movzbl (%edx),%ebx
 15d:	84 c0                	test   %al,%al
 15f:	74 0f                	je     170 <strcmp+0x40>
 161:	38 d8                	cmp    %bl,%al
 163:	74 eb                	je     150 <strcmp+0x20>
    return (uchar)*p - (uchar)*q;
 165:	29 d8                	sub    %ebx,%eax
}
 167:	5b                   	pop    %ebx
 168:	5d                   	pop    %ebp
 169:	c3                   	ret    
 16a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 170:	31 c0                	xor    %eax,%eax
    return (uchar)*p - (uchar)*q;
 172:	29 d8                	sub    %ebx,%eax
}
 174:	5b                   	pop    %ebx
 175:	5d                   	pop    %ebp
 176:	c3                   	ret    
 177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 17e:	66 90                	xchg   %ax,%ax

00000180 <strlen>:

uint strlen(const char* s) {
 180:	f3 0f 1e fb          	endbr32 
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	8b 55 08             	mov    0x8(%ebp),%edx
    int n;

    for (n = 0; s[n]; n++)
 18a:	80 3a 00             	cmpb   $0x0,(%edx)
 18d:	74 21                	je     1b0 <strlen+0x30>
 18f:	31 c0                	xor    %eax,%eax
 191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 198:	83 c0 01             	add    $0x1,%eax
 19b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 19f:	89 c1                	mov    %eax,%ecx
 1a1:	75 f5                	jne    198 <strlen+0x18>
        ;
    return n;
}
 1a3:	89 c8                	mov    %ecx,%eax
 1a5:	5d                   	pop    %ebp
 1a6:	c3                   	ret    
 1a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ae:	66 90                	xchg   %ax,%ax
    for (n = 0; s[n]; n++)
 1b0:	31 c9                	xor    %ecx,%ecx
}
 1b2:	5d                   	pop    %ebp
 1b3:	89 c8                	mov    %ecx,%eax
 1b5:	c3                   	ret    
 1b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1bd:	8d 76 00             	lea    0x0(%esi),%esi

000001c0 <memset>:

void* memset(void* dst, int c, uint n) {
 1c0:	f3 0f 1e fb          	endbr32 
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	57                   	push   %edi
 1c8:	8b 55 08             	mov    0x8(%ebp),%edx
                 : "cc");
}

static inline void
stosb(void* addr, int data, int cnt) {
    asm volatile("cld; rep stosb"
 1cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d1:	89 d7                	mov    %edx,%edi
 1d3:	fc                   	cld    
 1d4:	f3 aa                	rep stos %al,%es:(%edi)
    stosb(dst, c, n);
    return dst;
}
 1d6:	89 d0                	mov    %edx,%eax
 1d8:	5f                   	pop    %edi
 1d9:	5d                   	pop    %ebp
 1da:	c3                   	ret    
 1db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1df:	90                   	nop

000001e0 <strchr>:

char* strchr(const char* s, char c) {
 1e0:	f3 0f 1e fb          	endbr32 
 1e4:	55                   	push   %ebp
 1e5:	89 e5                	mov    %esp,%ebp
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ea:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
    for (; *s; s++)
 1ee:	0f b6 10             	movzbl (%eax),%edx
 1f1:	84 d2                	test   %dl,%dl
 1f3:	75 16                	jne    20b <strchr+0x2b>
 1f5:	eb 21                	jmp    218 <strchr+0x38>
 1f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1fe:	66 90                	xchg   %ax,%ax
 200:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 204:	83 c0 01             	add    $0x1,%eax
 207:	84 d2                	test   %dl,%dl
 209:	74 0d                	je     218 <strchr+0x38>
        if (*s == c)
 20b:	38 d1                	cmp    %dl,%cl
 20d:	75 f1                	jne    200 <strchr+0x20>
            return (char*)s;
    return 0;
}
 20f:	5d                   	pop    %ebp
 210:	c3                   	ret    
 211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
 218:	31 c0                	xor    %eax,%eax
}
 21a:	5d                   	pop    %ebp
 21b:	c3                   	ret    
 21c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000220 <gets>:

char* gets(char* buf, int max) {
 220:	f3 0f 1e fb          	endbr32 
 224:	55                   	push   %ebp
 225:	89 e5                	mov    %esp,%ebp
 227:	57                   	push   %edi
 228:	56                   	push   %esi
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;) {
 229:	31 f6                	xor    %esi,%esi
char* gets(char* buf, int max) {
 22b:	53                   	push   %ebx
 22c:	89 f3                	mov    %esi,%ebx
 22e:	83 ec 1c             	sub    $0x1c,%esp
 231:	8b 7d 08             	mov    0x8(%ebp),%edi
    for (i = 0; i + 1 < max;) {
 234:	eb 33                	jmp    269 <gets+0x49>
 236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23d:	8d 76 00             	lea    0x0(%esi),%esi
        cc = read(0, &c, 1);
 240:	83 ec 04             	sub    $0x4,%esp
 243:	8d 45 e7             	lea    -0x19(%ebp),%eax
 246:	6a 01                	push   $0x1
 248:	50                   	push   %eax
 249:	6a 00                	push   $0x0
 24b:	e8 2b 01 00 00       	call   37b <read>
        if (cc < 1)
 250:	83 c4 10             	add    $0x10,%esp
 253:	85 c0                	test   %eax,%eax
 255:	7e 1c                	jle    273 <gets+0x53>
            break;
        buf[i++] = c;
 257:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 25b:	83 c7 01             	add    $0x1,%edi
 25e:	88 47 ff             	mov    %al,-0x1(%edi)
        if (c == '\n' || c == '\r')
 261:	3c 0a                	cmp    $0xa,%al
 263:	74 23                	je     288 <gets+0x68>
 265:	3c 0d                	cmp    $0xd,%al
 267:	74 1f                	je     288 <gets+0x68>
    for (i = 0; i + 1 < max;) {
 269:	83 c3 01             	add    $0x1,%ebx
 26c:	89 fe                	mov    %edi,%esi
 26e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 271:	7c cd                	jl     240 <gets+0x20>
 273:	89 f3                	mov    %esi,%ebx
            break;
    }
    buf[i] = '\0';
    return buf;
}
 275:	8b 45 08             	mov    0x8(%ebp),%eax
    buf[i] = '\0';
 278:	c6 03 00             	movb   $0x0,(%ebx)
}
 27b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 27e:	5b                   	pop    %ebx
 27f:	5e                   	pop    %esi
 280:	5f                   	pop    %edi
 281:	5d                   	pop    %ebp
 282:	c3                   	ret    
 283:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 287:	90                   	nop
 288:	8b 75 08             	mov    0x8(%ebp),%esi
 28b:	8b 45 08             	mov    0x8(%ebp),%eax
 28e:	01 de                	add    %ebx,%esi
 290:	89 f3                	mov    %esi,%ebx
    buf[i] = '\0';
 292:	c6 03 00             	movb   $0x0,(%ebx)
}
 295:	8d 65 f4             	lea    -0xc(%ebp),%esp
 298:	5b                   	pop    %ebx
 299:	5e                   	pop    %esi
 29a:	5f                   	pop    %edi
 29b:	5d                   	pop    %ebp
 29c:	c3                   	ret    
 29d:	8d 76 00             	lea    0x0(%esi),%esi

000002a0 <stat>:

int stat(const char* n, struct stat* st) {
 2a0:	f3 0f 1e fb          	endbr32 
 2a4:	55                   	push   %ebp
 2a5:	89 e5                	mov    %esp,%ebp
 2a7:	56                   	push   %esi
 2a8:	53                   	push   %ebx
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 2a9:	83 ec 08             	sub    $0x8,%esp
 2ac:	6a 00                	push   $0x0
 2ae:	ff 75 08             	pushl  0x8(%ebp)
 2b1:	e8 ed 00 00 00       	call   3a3 <open>
    if (fd < 0)
 2b6:	83 c4 10             	add    $0x10,%esp
 2b9:	85 c0                	test   %eax,%eax
 2bb:	78 2b                	js     2e8 <stat+0x48>
        return -1;
    r = fstat(fd, st);
 2bd:	83 ec 08             	sub    $0x8,%esp
 2c0:	ff 75 0c             	pushl  0xc(%ebp)
 2c3:	89 c3                	mov    %eax,%ebx
 2c5:	50                   	push   %eax
 2c6:	e8 f0 00 00 00       	call   3bb <fstat>
    close(fd);
 2cb:	89 1c 24             	mov    %ebx,(%esp)
    r = fstat(fd, st);
 2ce:	89 c6                	mov    %eax,%esi
    close(fd);
 2d0:	e8 b6 00 00 00       	call   38b <close>
    return r;
 2d5:	83 c4 10             	add    $0x10,%esp
}
 2d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2db:	89 f0                	mov    %esi,%eax
 2dd:	5b                   	pop    %ebx
 2de:	5e                   	pop    %esi
 2df:	5d                   	pop    %ebp
 2e0:	c3                   	ret    
 2e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
 2e8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2ed:	eb e9                	jmp    2d8 <stat+0x38>
 2ef:	90                   	nop

000002f0 <atoi>:

int atoi(const char* s) {
 2f0:	f3 0f 1e fb          	endbr32 
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
 2f7:	53                   	push   %ebx
 2f8:	8b 55 08             	mov    0x8(%ebp),%edx
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 2fb:	0f be 02             	movsbl (%edx),%eax
 2fe:	8d 48 d0             	lea    -0x30(%eax),%ecx
 301:	80 f9 09             	cmp    $0x9,%cl
    n = 0;
 304:	b9 00 00 00 00       	mov    $0x0,%ecx
    while ('0' <= *s && *s <= '9')
 309:	77 1a                	ja     325 <atoi+0x35>
 30b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 30f:	90                   	nop
        n = n * 10 + *s++ - '0';
 310:	83 c2 01             	add    $0x1,%edx
 313:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 316:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
    while ('0' <= *s && *s <= '9')
 31a:	0f be 02             	movsbl (%edx),%eax
 31d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 320:	80 fb 09             	cmp    $0x9,%bl
 323:	76 eb                	jbe    310 <atoi+0x20>
    return n;
}
 325:	89 c8                	mov    %ecx,%eax
 327:	5b                   	pop    %ebx
 328:	5d                   	pop    %ebp
 329:	c3                   	ret    
 32a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000330 <memmove>:

void* memmove(void* vdst, const void* vsrc, int n) {
 330:	f3 0f 1e fb          	endbr32 
 334:	55                   	push   %ebp
 335:	89 e5                	mov    %esp,%ebp
 337:	57                   	push   %edi
 338:	8b 45 10             	mov    0x10(%ebp),%eax
 33b:	8b 55 08             	mov    0x8(%ebp),%edx
 33e:	56                   	push   %esi
 33f:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* dst;
    const char* src;

    dst = vdst;
    src = vsrc;
    while (n-- > 0)
 342:	85 c0                	test   %eax,%eax
 344:	7e 0f                	jle    355 <memmove+0x25>
 346:	01 d0                	add    %edx,%eax
    dst = vdst;
 348:	89 d7                	mov    %edx,%edi
 34a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        *dst++ = *src++;
 350:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while (n-- > 0)
 351:	39 f8                	cmp    %edi,%eax
 353:	75 fb                	jne    350 <memmove+0x20>
    return vdst;
}
 355:	5e                   	pop    %esi
 356:	89 d0                	mov    %edx,%eax
 358:	5f                   	pop    %edi
 359:	5d                   	pop    %ebp
 35a:	c3                   	ret    

0000035b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 35b:	b8 01 00 00 00       	mov    $0x1,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <exit>:
SYSCALL(exit)
 363:	b8 02 00 00 00       	mov    $0x2,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <wait>:
SYSCALL(wait)
 36b:	b8 03 00 00 00       	mov    $0x3,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <pipe>:
SYSCALL(pipe)
 373:	b8 04 00 00 00       	mov    $0x4,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <read>:
SYSCALL(read)
 37b:	b8 05 00 00 00       	mov    $0x5,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <write>:
SYSCALL(write)
 383:	b8 10 00 00 00       	mov    $0x10,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <close>:
SYSCALL(close)
 38b:	b8 15 00 00 00       	mov    $0x15,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <kill>:
SYSCALL(kill)
 393:	b8 06 00 00 00       	mov    $0x6,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <exec>:
SYSCALL(exec)
 39b:	b8 07 00 00 00       	mov    $0x7,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <open>:
SYSCALL(open)
 3a3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <mknod>:
SYSCALL(mknod)
 3ab:	b8 11 00 00 00       	mov    $0x11,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <unlink>:
SYSCALL(unlink)
 3b3:	b8 12 00 00 00       	mov    $0x12,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <fstat>:
SYSCALL(fstat)
 3bb:	b8 08 00 00 00       	mov    $0x8,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <link>:
SYSCALL(link)
 3c3:	b8 13 00 00 00       	mov    $0x13,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <mkdir>:
SYSCALL(mkdir)
 3cb:	b8 14 00 00 00       	mov    $0x14,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <chdir>:
SYSCALL(chdir)
 3d3:	b8 09 00 00 00       	mov    $0x9,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <dup>:
SYSCALL(dup)
 3db:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <getpid>:
SYSCALL(getpid)
 3e3:	b8 0b 00 00 00       	mov    $0xb,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <sbrk>:
SYSCALL(sbrk)
 3eb:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <sleep>:
SYSCALL(sleep)
 3f3:	b8 0d 00 00 00       	mov    $0xd,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <uptime>:
SYSCALL(uptime)
 3fb:	b8 0e 00 00 00       	mov    $0xe,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <nuncle>:
SYSCALL(nuncle)
 403:	b8 16 00 00 00       	mov    $0x16,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <ptime>:
SYSCALL(ptime)
 40b:	b8 17 00 00 00       	mov    $0x17,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <fcopy>:
SYSCALL(fcopy)
 413:	b8 18 00 00 00       	mov    $0x18,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    
 41b:	66 90                	xchg   %ax,%ax
 41d:	66 90                	xchg   %ax,%ax
 41f:	90                   	nop

00000420 <printint>:
putc(int fd, char c) {
    write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn) {
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	57                   	push   %edi
 424:	56                   	push   %esi
 425:	53                   	push   %ebx
 426:	83 ec 3c             	sub    $0x3c,%esp
 429:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
    uint x;

    neg = 0;
    if (sgn && xx < 0) {
        neg = 1;
        x = -xx;
 42c:	89 d1                	mov    %edx,%ecx
printint(int fd, int xx, int base, int sgn) {
 42e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    if (sgn && xx < 0) {
 431:	85 d2                	test   %edx,%edx
 433:	0f 89 7f 00 00 00    	jns    4b8 <printint+0x98>
 439:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 43d:	74 79                	je     4b8 <printint+0x98>
        neg = 1;
 43f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
        x = -xx;
 446:	f7 d9                	neg    %ecx
    }
    else {
        x = xx;
    }

    i = 0;
 448:	31 db                	xor    %ebx,%ebx
 44a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 44d:	8d 76 00             	lea    0x0(%esi),%esi
    do {
        buf[i++] = digits[x % base];
 450:	89 c8                	mov    %ecx,%eax
 452:	31 d2                	xor    %edx,%edx
 454:	89 cf                	mov    %ecx,%edi
 456:	f7 75 c4             	divl   -0x3c(%ebp)
 459:	0f b6 92 d4 08 00 00 	movzbl 0x8d4(%edx),%edx
 460:	89 45 c0             	mov    %eax,-0x40(%ebp)
 463:	89 d8                	mov    %ebx,%eax
 465:	8d 5b 01             	lea    0x1(%ebx),%ebx
    } while ((x /= base) != 0);
 468:	8b 4d c0             	mov    -0x40(%ebp),%ecx
        buf[i++] = digits[x % base];
 46b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
    } while ((x /= base) != 0);
 46e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 471:	76 dd                	jbe    450 <printint+0x30>
    if (neg)
 473:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 476:	85 c9                	test   %ecx,%ecx
 478:	74 0c                	je     486 <printint+0x66>
        buf[i++] = '-';
 47a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
        buf[i++] = digits[x % base];
 47f:	89 d8                	mov    %ebx,%eax
        buf[i++] = '-';
 481:	ba 2d 00 00 00       	mov    $0x2d,%edx

    while (--i >= 0)
 486:	8b 7d b8             	mov    -0x48(%ebp),%edi
 489:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 48d:	eb 07                	jmp    496 <printint+0x76>
 48f:	90                   	nop
 490:	0f b6 13             	movzbl (%ebx),%edx
 493:	83 eb 01             	sub    $0x1,%ebx
    write(fd, &c, 1);
 496:	83 ec 04             	sub    $0x4,%esp
 499:	88 55 d7             	mov    %dl,-0x29(%ebp)
 49c:	6a 01                	push   $0x1
 49e:	56                   	push   %esi
 49f:	57                   	push   %edi
 4a0:	e8 de fe ff ff       	call   383 <write>
    while (--i >= 0)
 4a5:	83 c4 10             	add    $0x10,%esp
 4a8:	39 de                	cmp    %ebx,%esi
 4aa:	75 e4                	jne    490 <printint+0x70>
        putc(fd, buf[i]);
}
 4ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4af:	5b                   	pop    %ebx
 4b0:	5e                   	pop    %esi
 4b1:	5f                   	pop    %edi
 4b2:	5d                   	pop    %ebp
 4b3:	c3                   	ret    
 4b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    neg = 0;
 4b8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 4bf:	eb 87                	jmp    448 <printint+0x28>
 4c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4cf:	90                   	nop

000004d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void printf(int fd, const char* fmt, ...) {
 4d0:	f3 0f 1e fb          	endbr32 
 4d4:	55                   	push   %ebp
 4d5:	89 e5                	mov    %esp,%ebp
 4d7:	57                   	push   %edi
 4d8:	56                   	push   %esi
 4d9:	53                   	push   %ebx
 4da:	83 ec 2c             	sub    $0x2c,%esp
    int c, i, state;
    uint* ap;

    state = 0;
    ap = (uint*)(void*)&fmt + 1;
    for (i = 0; fmt[i]; i++) {
 4dd:	8b 75 0c             	mov    0xc(%ebp),%esi
 4e0:	0f b6 1e             	movzbl (%esi),%ebx
 4e3:	84 db                	test   %bl,%bl
 4e5:	0f 84 b4 00 00 00    	je     59f <printf+0xcf>
    ap = (uint*)(void*)&fmt + 1;
 4eb:	8d 45 10             	lea    0x10(%ebp),%eax
 4ee:	83 c6 01             	add    $0x1,%esi
    write(fd, &c, 1);
 4f1:	8d 7d e7             	lea    -0x19(%ebp),%edi
    state = 0;
 4f4:	31 d2                	xor    %edx,%edx
    ap = (uint*)(void*)&fmt + 1;
 4f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4f9:	eb 33                	jmp    52e <printf+0x5e>
 4fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4ff:	90                   	nop
 500:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        c = fmt[i] & 0xff;
        if (state == 0) {
            if (c == '%') {
                state = '%';
 503:	ba 25 00 00 00       	mov    $0x25,%edx
            if (c == '%') {
 508:	83 f8 25             	cmp    $0x25,%eax
 50b:	74 17                	je     524 <printf+0x54>
    write(fd, &c, 1);
 50d:	83 ec 04             	sub    $0x4,%esp
 510:	88 5d e7             	mov    %bl,-0x19(%ebp)
 513:	6a 01                	push   $0x1
 515:	57                   	push   %edi
 516:	ff 75 08             	pushl  0x8(%ebp)
 519:	e8 65 fe ff ff       	call   383 <write>
 51e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
            }
            else {
                putc(fd, c);
 521:	83 c4 10             	add    $0x10,%esp
    for (i = 0; fmt[i]; i++) {
 524:	0f b6 1e             	movzbl (%esi),%ebx
 527:	83 c6 01             	add    $0x1,%esi
 52a:	84 db                	test   %bl,%bl
 52c:	74 71                	je     59f <printf+0xcf>
        c = fmt[i] & 0xff;
 52e:	0f be cb             	movsbl %bl,%ecx
 531:	0f b6 c3             	movzbl %bl,%eax
        if (state == 0) {
 534:	85 d2                	test   %edx,%edx
 536:	74 c8                	je     500 <printf+0x30>
            }
        }
        else if (state == '%') {
 538:	83 fa 25             	cmp    $0x25,%edx
 53b:	75 e7                	jne    524 <printf+0x54>
            if (c == 'd') {
 53d:	83 f8 64             	cmp    $0x64,%eax
 540:	0f 84 9a 00 00 00    	je     5e0 <printf+0x110>
                printint(fd, *ap, 10, 1);
                ap++;
            }
            else if (c == 'x' || c == 'p') {
 546:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 54c:	83 f9 70             	cmp    $0x70,%ecx
 54f:	74 5f                	je     5b0 <printf+0xe0>
                printint(fd, *ap, 16, 0);
                ap++;
            }
            else if (c == 's') {
 551:	83 f8 73             	cmp    $0x73,%eax
 554:	0f 84 d6 00 00 00    	je     630 <printf+0x160>
                while (*s != 0) {
                    putc(fd, *s);
                    s++;
                }
            }
            else if (c == 'c') {
 55a:	83 f8 63             	cmp    $0x63,%eax
 55d:	0f 84 8d 00 00 00    	je     5f0 <printf+0x120>
                putc(fd, *ap);
                ap++;
            }
            else if (c == '%') {
 563:	83 f8 25             	cmp    $0x25,%eax
 566:	0f 84 b4 00 00 00    	je     620 <printf+0x150>
    write(fd, &c, 1);
 56c:	83 ec 04             	sub    $0x4,%esp
 56f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 573:	6a 01                	push   $0x1
 575:	57                   	push   %edi
 576:	ff 75 08             	pushl  0x8(%ebp)
 579:	e8 05 fe ff ff       	call   383 <write>
                putc(fd, c);
            }
            else {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
                putc(fd, c);
 57e:	88 5d e7             	mov    %bl,-0x19(%ebp)
    write(fd, &c, 1);
 581:	83 c4 0c             	add    $0xc,%esp
 584:	6a 01                	push   $0x1
 586:	83 c6 01             	add    $0x1,%esi
 589:	57                   	push   %edi
 58a:	ff 75 08             	pushl  0x8(%ebp)
 58d:	e8 f1 fd ff ff       	call   383 <write>
    for (i = 0; fmt[i]; i++) {
 592:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
                putc(fd, c);
 596:	83 c4 10             	add    $0x10,%esp
            }
            state = 0;
 599:	31 d2                	xor    %edx,%edx
    for (i = 0; fmt[i]; i++) {
 59b:	84 db                	test   %bl,%bl
 59d:	75 8f                	jne    52e <printf+0x5e>
        }
    }
}
 59f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5a2:	5b                   	pop    %ebx
 5a3:	5e                   	pop    %esi
 5a4:	5f                   	pop    %edi
 5a5:	5d                   	pop    %ebp
 5a6:	c3                   	ret    
 5a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ae:	66 90                	xchg   %ax,%ax
                printint(fd, *ap, 16, 0);
 5b0:	83 ec 0c             	sub    $0xc,%esp
 5b3:	b9 10 00 00 00       	mov    $0x10,%ecx
 5b8:	6a 00                	push   $0x0
 5ba:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5bd:	8b 45 08             	mov    0x8(%ebp),%eax
 5c0:	8b 13                	mov    (%ebx),%edx
 5c2:	e8 59 fe ff ff       	call   420 <printint>
                ap++;
 5c7:	89 d8                	mov    %ebx,%eax
 5c9:	83 c4 10             	add    $0x10,%esp
            state = 0;
 5cc:	31 d2                	xor    %edx,%edx
                ap++;
 5ce:	83 c0 04             	add    $0x4,%eax
 5d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5d4:	e9 4b ff ff ff       	jmp    524 <printf+0x54>
 5d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                printint(fd, *ap, 10, 1);
 5e0:	83 ec 0c             	sub    $0xc,%esp
 5e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5e8:	6a 01                	push   $0x1
 5ea:	eb ce                	jmp    5ba <printf+0xea>
 5ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                putc(fd, *ap);
 5f0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    write(fd, &c, 1);
 5f3:	83 ec 04             	sub    $0x4,%esp
                putc(fd, *ap);
 5f6:	8b 03                	mov    (%ebx),%eax
    write(fd, &c, 1);
 5f8:	6a 01                	push   $0x1
                ap++;
 5fa:	83 c3 04             	add    $0x4,%ebx
    write(fd, &c, 1);
 5fd:	57                   	push   %edi
 5fe:	ff 75 08             	pushl  0x8(%ebp)
                putc(fd, *ap);
 601:	88 45 e7             	mov    %al,-0x19(%ebp)
    write(fd, &c, 1);
 604:	e8 7a fd ff ff       	call   383 <write>
                ap++;
 609:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 60c:	83 c4 10             	add    $0x10,%esp
            state = 0;
 60f:	31 d2                	xor    %edx,%edx
 611:	e9 0e ff ff ff       	jmp    524 <printf+0x54>
 616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 61d:	8d 76 00             	lea    0x0(%esi),%esi
                putc(fd, c);
 620:	88 5d e7             	mov    %bl,-0x19(%ebp)
    write(fd, &c, 1);
 623:	83 ec 04             	sub    $0x4,%esp
 626:	e9 59 ff ff ff       	jmp    584 <printf+0xb4>
 62b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 62f:	90                   	nop
                s = (char*)*ap;
 630:	8b 45 d0             	mov    -0x30(%ebp),%eax
 633:	8b 18                	mov    (%eax),%ebx
                ap++;
 635:	83 c0 04             	add    $0x4,%eax
 638:	89 45 d0             	mov    %eax,-0x30(%ebp)
                if (s == 0)
 63b:	85 db                	test   %ebx,%ebx
 63d:	74 17                	je     656 <printf+0x186>
                while (*s != 0) {
 63f:	0f b6 03             	movzbl (%ebx),%eax
            state = 0;
 642:	31 d2                	xor    %edx,%edx
                while (*s != 0) {
 644:	84 c0                	test   %al,%al
 646:	0f 84 d8 fe ff ff    	je     524 <printf+0x54>
 64c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 64f:	89 de                	mov    %ebx,%esi
 651:	8b 5d 08             	mov    0x8(%ebp),%ebx
 654:	eb 1a                	jmp    670 <printf+0x1a0>
                    s = "(null)";
 656:	bb ca 08 00 00       	mov    $0x8ca,%ebx
                while (*s != 0) {
 65b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 65e:	b8 28 00 00 00       	mov    $0x28,%eax
 663:	89 de                	mov    %ebx,%esi
 665:	8b 5d 08             	mov    0x8(%ebp),%ebx
 668:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 66f:	90                   	nop
    write(fd, &c, 1);
 670:	83 ec 04             	sub    $0x4,%esp
                    s++;
 673:	83 c6 01             	add    $0x1,%esi
 676:	88 45 e7             	mov    %al,-0x19(%ebp)
    write(fd, &c, 1);
 679:	6a 01                	push   $0x1
 67b:	57                   	push   %edi
 67c:	53                   	push   %ebx
 67d:	e8 01 fd ff ff       	call   383 <write>
                while (*s != 0) {
 682:	0f b6 06             	movzbl (%esi),%eax
 685:	83 c4 10             	add    $0x10,%esp
 688:	84 c0                	test   %al,%al
 68a:	75 e4                	jne    670 <printf+0x1a0>
 68c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
            state = 0;
 68f:	31 d2                	xor    %edx,%edx
 691:	e9 8e fe ff ff       	jmp    524 <printf+0x54>
 696:	66 90                	xchg   %ax,%ax
 698:	66 90                	xchg   %ax,%ax
 69a:	66 90                	xchg   %ax,%ax
 69c:	66 90                	xchg   %ax,%ax
 69e:	66 90                	xchg   %ax,%ax

000006a0 <free>:
typedef union header Header;

static Header base;
static Header* freep;

void free(void* ap) {
 6a0:	f3 0f 1e fb          	endbr32 
 6a4:	55                   	push   %ebp
    Header *bp, *p;

    bp = (Header*)ap - 1;
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a5:	a1 88 0b 00 00       	mov    0xb88,%eax
void free(void* ap) {
 6aa:	89 e5                	mov    %esp,%ebp
 6ac:	57                   	push   %edi
 6ad:	56                   	push   %esi
 6ae:	53                   	push   %ebx
 6af:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6b2:	8b 10                	mov    (%eax),%edx
    bp = (Header*)ap - 1;
 6b4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b7:	39 c8                	cmp    %ecx,%eax
 6b9:	73 15                	jae    6d0 <free+0x30>
 6bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6bf:	90                   	nop
 6c0:	39 d1                	cmp    %edx,%ecx
 6c2:	72 14                	jb     6d8 <free+0x38>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c4:	39 d0                	cmp    %edx,%eax
 6c6:	73 10                	jae    6d8 <free+0x38>
void free(void* ap) {
 6c8:	89 d0                	mov    %edx,%eax
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ca:	8b 10                	mov    (%eax),%edx
 6cc:	39 c8                	cmp    %ecx,%eax
 6ce:	72 f0                	jb     6c0 <free+0x20>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d0:	39 d0                	cmp    %edx,%eax
 6d2:	72 f4                	jb     6c8 <free+0x28>
 6d4:	39 d1                	cmp    %edx,%ecx
 6d6:	73 f0                	jae    6c8 <free+0x28>
            break;
    if (bp + bp->s.size == p->s.ptr) {
 6d8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6db:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6de:	39 fa                	cmp    %edi,%edx
 6e0:	74 1e                	je     700 <free+0x60>
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
    }
    else
        bp->s.ptr = p->s.ptr;
 6e2:	89 53 f8             	mov    %edx,-0x8(%ebx)
    if (p + p->s.size == bp) {
 6e5:	8b 50 04             	mov    0x4(%eax),%edx
 6e8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6eb:	39 f1                	cmp    %esi,%ecx
 6ed:	74 28                	je     717 <free+0x77>
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
    }
    else
        p->s.ptr = bp;
 6ef:	89 08                	mov    %ecx,(%eax)
    freep = p;
}
 6f1:	5b                   	pop    %ebx
    freep = p;
 6f2:	a3 88 0b 00 00       	mov    %eax,0xb88
}
 6f7:	5e                   	pop    %esi
 6f8:	5f                   	pop    %edi
 6f9:	5d                   	pop    %ebp
 6fa:	c3                   	ret    
 6fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6ff:	90                   	nop
        bp->s.size += p->s.ptr->s.size;
 700:	03 72 04             	add    0x4(%edx),%esi
 703:	89 73 fc             	mov    %esi,-0x4(%ebx)
        bp->s.ptr = p->s.ptr->s.ptr;
 706:	8b 10                	mov    (%eax),%edx
 708:	8b 12                	mov    (%edx),%edx
 70a:	89 53 f8             	mov    %edx,-0x8(%ebx)
    if (p + p->s.size == bp) {
 70d:	8b 50 04             	mov    0x4(%eax),%edx
 710:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 713:	39 f1                	cmp    %esi,%ecx
 715:	75 d8                	jne    6ef <free+0x4f>
        p->s.size += bp->s.size;
 717:	03 53 fc             	add    -0x4(%ebx),%edx
    freep = p;
 71a:	a3 88 0b 00 00       	mov    %eax,0xb88
        p->s.size += bp->s.size;
 71f:	89 50 04             	mov    %edx,0x4(%eax)
        p->s.ptr = bp->s.ptr;
 722:	8b 53 f8             	mov    -0x8(%ebx),%edx
 725:	89 10                	mov    %edx,(%eax)
}
 727:	5b                   	pop    %ebx
 728:	5e                   	pop    %esi
 729:	5f                   	pop    %edi
 72a:	5d                   	pop    %ebp
 72b:	c3                   	ret    
 72c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000730 <malloc>:
    hp->s.size = nu;
    free((void*)(hp + 1));
    return freep;
}

void* malloc(uint nbytes) {
 730:	f3 0f 1e fb          	endbr32 
 734:	55                   	push   %ebp
 735:	89 e5                	mov    %esp,%ebp
 737:	57                   	push   %edi
 738:	56                   	push   %esi
 739:	53                   	push   %ebx
 73a:	83 ec 1c             	sub    $0x1c,%esp
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 73d:	8b 45 08             	mov    0x8(%ebp),%eax
    if ((prevp = freep) == 0) {
 740:	8b 3d 88 0b 00 00    	mov    0xb88,%edi
    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 746:	8d 70 07             	lea    0x7(%eax),%esi
 749:	c1 ee 03             	shr    $0x3,%esi
 74c:	83 c6 01             	add    $0x1,%esi
    if ((prevp = freep) == 0) {
 74f:	85 ff                	test   %edi,%edi
 751:	0f 84 a9 00 00 00    	je     800 <malloc+0xd0>
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 757:	8b 07                	mov    (%edi),%eax
        if (p->s.size >= nunits) {
 759:	8b 48 04             	mov    0x4(%eax),%ecx
 75c:	39 f1                	cmp    %esi,%ecx
 75e:	73 6d                	jae    7cd <malloc+0x9d>
 760:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 766:	bb 00 10 00 00       	mov    $0x1000,%ebx
 76b:	0f 43 de             	cmovae %esi,%ebx
    p = sbrk(nu * sizeof(Header));
 76e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 775:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 778:	eb 17                	jmp    791 <malloc+0x61>
 77a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 780:	8b 10                	mov    (%eax),%edx
        if (p->s.size >= nunits) {
 782:	8b 4a 04             	mov    0x4(%edx),%ecx
 785:	39 f1                	cmp    %esi,%ecx
 787:	73 4f                	jae    7d8 <malloc+0xa8>
 789:	8b 3d 88 0b 00 00    	mov    0xb88,%edi
 78f:	89 d0                	mov    %edx,%eax
                p->s.size = nunits;
            }
            freep = prevp;
            return (void*)(p + 1);
        }
        if (p == freep)
 791:	39 c7                	cmp    %eax,%edi
 793:	75 eb                	jne    780 <malloc+0x50>
    p = sbrk(nu * sizeof(Header));
 795:	83 ec 0c             	sub    $0xc,%esp
 798:	ff 75 e4             	pushl  -0x1c(%ebp)
 79b:	e8 4b fc ff ff       	call   3eb <sbrk>
    if (p == (char*)-1)
 7a0:	83 c4 10             	add    $0x10,%esp
 7a3:	83 f8 ff             	cmp    $0xffffffff,%eax
 7a6:	74 1b                	je     7c3 <malloc+0x93>
    hp->s.size = nu;
 7a8:	89 58 04             	mov    %ebx,0x4(%eax)
    free((void*)(hp + 1));
 7ab:	83 ec 0c             	sub    $0xc,%esp
 7ae:	83 c0 08             	add    $0x8,%eax
 7b1:	50                   	push   %eax
 7b2:	e8 e9 fe ff ff       	call   6a0 <free>
    return freep;
 7b7:	a1 88 0b 00 00       	mov    0xb88,%eax
            if ((p = morecore(nunits)) == 0)
 7bc:	83 c4 10             	add    $0x10,%esp
 7bf:	85 c0                	test   %eax,%eax
 7c1:	75 bd                	jne    780 <malloc+0x50>
                return 0;
    }
}
 7c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
                return 0;
 7c6:	31 c0                	xor    %eax,%eax
}
 7c8:	5b                   	pop    %ebx
 7c9:	5e                   	pop    %esi
 7ca:	5f                   	pop    %edi
 7cb:	5d                   	pop    %ebp
 7cc:	c3                   	ret    
        if (p->s.size >= nunits) {
 7cd:	89 c2                	mov    %eax,%edx
 7cf:	89 f8                	mov    %edi,%eax
 7d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            if (p->s.size == nunits)
 7d8:	39 ce                	cmp    %ecx,%esi
 7da:	74 54                	je     830 <malloc+0x100>
                p->s.size -= nunits;
 7dc:	29 f1                	sub    %esi,%ecx
 7de:	89 4a 04             	mov    %ecx,0x4(%edx)
                p += p->s.size;
 7e1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
                p->s.size = nunits;
 7e4:	89 72 04             	mov    %esi,0x4(%edx)
            freep = prevp;
 7e7:	a3 88 0b 00 00       	mov    %eax,0xb88
}
 7ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return (void*)(p + 1);
 7ef:	8d 42 08             	lea    0x8(%edx),%eax
}
 7f2:	5b                   	pop    %ebx
 7f3:	5e                   	pop    %esi
 7f4:	5f                   	pop    %edi
 7f5:	5d                   	pop    %ebp
 7f6:	c3                   	ret    
 7f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7fe:	66 90                	xchg   %ax,%ax
        base.s.ptr = freep = prevp = &base;
 800:	c7 05 88 0b 00 00 8c 	movl   $0xb8c,0xb88
 807:	0b 00 00 
        base.s.size = 0;
 80a:	bf 8c 0b 00 00       	mov    $0xb8c,%edi
        base.s.ptr = freep = prevp = &base;
 80f:	c7 05 8c 0b 00 00 8c 	movl   $0xb8c,0xb8c
 816:	0b 00 00 
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 819:	89 f8                	mov    %edi,%eax
        base.s.size = 0;
 81b:	c7 05 90 0b 00 00 00 	movl   $0x0,0xb90
 822:	00 00 00 
        if (p->s.size >= nunits) {
 825:	e9 36 ff ff ff       	jmp    760 <malloc+0x30>
 82a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                prevp->s.ptr = p->s.ptr;
 830:	8b 0a                	mov    (%edx),%ecx
 832:	89 08                	mov    %ecx,(%eax)
 834:	eb b1                	jmp    7e7 <malloc+0xb7>
