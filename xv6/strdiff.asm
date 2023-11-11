
_strdiff:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    diff[i++] = '\n';
    diff[i] = '\0';
    return 1;
}

int main(int argc, char* argv[]) {
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	56                   	push   %esi
  12:	53                   	push   %ebx
  13:	51                   	push   %ecx
  14:	83 ec 0c             	sub    $0xc,%esp
    if (argc != 3) {
  17:	83 39 03             	cmpl   $0x3,(%ecx)
int main(int argc, char* argv[]) {
  1a:	8b 59 04             	mov    0x4(%ecx),%ebx
    if (argc != 3) {
  1d:	74 13                	je     32 <main+0x32>
        printf(2, "Please enter exactly two strings!\n");
  1f:	50                   	push   %eax
  20:	50                   	push   %eax
  21:	68 f8 09 00 00       	push   $0x9f8
  26:	6a 02                	push   $0x2
  28:	e8 63 06 00 00       	call   690 <printf>
        exit();
  2d:	e8 f1 04 00 00       	call   523 <exit>
    }
    if ((strlen(argv[1]) > 15) || (strlen(argv[2]) > 15)) {
  32:	83 ec 0c             	sub    $0xc,%esp
  35:	ff 73 04             	pushl  0x4(%ebx)
  38:	e8 03 03 00 00       	call   340 <strlen>
  3d:	83 c4 10             	add    $0x10,%esp
  40:	83 f8 0f             	cmp    $0xf,%eax
  43:	77 61                	ja     a6 <main+0xa6>
  45:	83 ec 0c             	sub    $0xc,%esp
  48:	ff 73 08             	pushl  0x8(%ebx)
  4b:	e8 f0 02 00 00       	call   340 <strlen>
  50:	83 c4 10             	add    $0x10,%esp
  53:	83 f8 0f             	cmp    $0xf,%eax
  56:	77 4e                	ja     a6 <main+0xa6>
        printf(2, "Length of strings must be equal or less than 15!\n");
        exit();
    }

    unlink("strdiff_result.txt"); // remove links of any file to strdiff_result.txt
  58:	83 ec 0c             	sub    $0xc,%esp
  5b:	68 ab 0a 00 00       	push   $0xaab
  60:	e8 0e 05 00 00       	call   573 <unlink>

    int fd = open("strdiff_result.txt", O_CREATE | O_WRONLY); // create or open file
  65:	5e                   	pop    %esi
  66:	58                   	pop    %eax
  67:	68 01 02 00 00       	push   $0x201
  6c:	68 ab 0a 00 00       	push   $0xaab
  71:	e8 ed 04 00 00       	call   563 <open>
    if (fd < 0) {
  76:	83 c4 10             	add    $0x10,%esp
    int fd = open("strdiff_result.txt", O_CREATE | O_WRONLY); // create or open file
  79:	89 c6                	mov    %eax,%esi
    if (fd < 0) {
  7b:	85 c0                	test   %eax,%eax
  7d:	78 3a                	js     b9 <main+0xb9>
        printf(2, "Error happens when trying making file!\n");
        exit();
    }

    if (strdiff(argv[1], argv[2]) == 0) {
  7f:	52                   	push   %edx
  80:	52                   	push   %edx
  81:	ff 73 08             	pushl  0x8(%ebx)
  84:	ff 73 04             	pushl  0x4(%ebx)
  87:	e8 04 01 00 00       	call   190 <strdiff>
  8c:	83 c4 10             	add    $0x10,%esp
  8f:	85 c0                	test   %eax,%eax
  91:	75 39                	jne    cc <main+0xcc>
        printf(2, "String must only include alphabetical characters!\n");
  93:	50                   	push   %eax
  94:	50                   	push   %eax
  95:	68 78 0a 00 00       	push   $0xa78
  9a:	6a 02                	push   $0x2
  9c:	e8 ef 05 00 00       	call   690 <printf>
        exit();
  a1:	e8 7d 04 00 00       	call   523 <exit>
        printf(2, "Length of strings must be equal or less than 15!\n");
  a6:	50                   	push   %eax
  a7:	50                   	push   %eax
  a8:	68 1c 0a 00 00       	push   $0xa1c
  ad:	6a 02                	push   $0x2
  af:	e8 dc 05 00 00       	call   690 <printf>
        exit();
  b4:	e8 6a 04 00 00       	call   523 <exit>
        printf(2, "Error happens when trying making file!\n");
  b9:	51                   	push   %ecx
  ba:	51                   	push   %ecx
  bb:	68 50 0a 00 00       	push   $0xa50
  c0:	6a 02                	push   $0x2
  c2:	e8 c9 05 00 00       	call   690 <printf>
        exit();
  c7:	e8 57 04 00 00       	call   523 <exit>
    }

    write(fd, diff, strlen(diff));
  cc:	83 ec 0c             	sub    $0xc,%esp
  cf:	68 00 0e 00 00       	push   $0xe00
  d4:	e8 67 02 00 00       	call   340 <strlen>
  d9:	83 c4 0c             	add    $0xc,%esp
  dc:	50                   	push   %eax
  dd:	68 00 0e 00 00       	push   $0xe00
  e2:	56                   	push   %esi
  e3:	e8 5b 04 00 00       	call   543 <write>
    close(fd);
  e8:	89 34 24             	mov    %esi,(%esp)
  eb:	e8 5b 04 00 00       	call   54b <close>

    exit();
  f0:	e8 2e 04 00 00       	call   523 <exit>
  f5:	66 90                	xchg   %ax,%ax
  f7:	66 90                	xchg   %ax,%ax
  f9:	66 90                	xchg   %ax,%ax
  fb:	66 90                	xchg   %ax,%ax
  fd:	66 90                	xchg   %ax,%ax
  ff:	90                   	nop

00000100 <to_lower>:
char* to_lower(char* word) {
 100:	f3 0f 1e fb          	endbr32 
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	57                   	push   %edi
 108:	56                   	push   %esi
 109:	53                   	push   %ebx
 10a:	83 ec 28             	sub    $0x28,%esp
 10d:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int length = strlen(word);
 110:	53                   	push   %ebx
 111:	e8 2a 02 00 00       	call   340 <strlen>
 116:	89 c7                	mov    %eax,%edi
    char* lower_word = (char*)malloc((length + 1) * sizeof(char));
 118:	83 c0 01             	add    $0x1,%eax
 11b:	89 04 24             	mov    %eax,(%esp)
 11e:	e8 cd 07 00 00       	call   8f0 <malloc>
    for (int i = 0; i < length; i++) {
 123:	83 c4 10             	add    $0x10,%esp
    char* lower_word = (char*)malloc((length + 1) * sizeof(char));
 126:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for (int i = 0; i < length; i++) {
 129:	85 ff                	test   %edi,%edi
 12b:	7e 2d                	jle    15a <to_lower+0x5a>
 12d:	89 d9                	mov    %ebx,%ecx
 12f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
 132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (word[i] >= 'a' && word[i] <= 'z')
 138:	0f b6 11             	movzbl (%ecx),%edx
 13b:	8d 5a 9f             	lea    -0x61(%edx),%ebx
 13e:	80 fb 19             	cmp    $0x19,%bl
 141:	76 0b                	jbe    14e <to_lower+0x4e>
        else if (word[i] >= 'A' && word[i] <= 'Z')
 143:	8d 5a bf             	lea    -0x41(%edx),%ebx
 146:	80 fb 19             	cmp    $0x19,%bl
 149:	77 25                	ja     170 <to_lower+0x70>
            lower_word[i] = word[i] + 32;
 14b:	83 c2 20             	add    $0x20,%edx
 14e:	83 c1 01             	add    $0x1,%ecx
 151:	88 10                	mov    %dl,(%eax)
    for (int i = 0; i < length; i++) {
 153:	83 c0 01             	add    $0x1,%eax
 156:	39 f1                	cmp    %esi,%ecx
 158:	75 de                	jne    138 <to_lower+0x38>
    lower_word[length] = 0;
 15a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 15d:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
}
 161:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 164:	8d 65 f4             	lea    -0xc(%ebp),%esp
 167:	5b                   	pop    %ebx
 168:	5e                   	pop    %esi
 169:	5f                   	pop    %edi
 16a:	5d                   	pop    %ebp
 16b:	c3                   	ret    
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            return 0;
 170:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
 177:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 17a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 17d:	5b                   	pop    %ebx
 17e:	5e                   	pop    %esi
 17f:	5f                   	pop    %edi
 180:	5d                   	pop    %ebp
 181:	c3                   	ret    
 182:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000190 <strdiff>:
int strdiff(char* str1, char* str2) {
 190:	f3 0f 1e fb          	endbr32 
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	57                   	push   %edi
 198:	56                   	push   %esi
 199:	53                   	push   %ebx
 19a:	83 ec 28             	sub    $0x28,%esp
    str1 = to_lower(str1);
 19d:	ff 75 08             	pushl  0x8(%ebp)
 1a0:	e8 5b ff ff ff       	call   100 <to_lower>
 1a5:	89 c3                	mov    %eax,%ebx
    str2 = to_lower(str2);
 1a7:	58                   	pop    %eax
 1a8:	ff 75 0c             	pushl  0xc(%ebp)
 1ab:	e8 50 ff ff ff       	call   100 <to_lower>
    if (str1 == 0 || str2 == 0)
 1b0:	83 c4 10             	add    $0x10,%esp
 1b3:	85 db                	test   %ebx,%ebx
 1b5:	0f 84 b5 00 00 00    	je     270 <strdiff+0xe0>
 1bb:	89 c6                	mov    %eax,%esi
 1bd:	85 c0                	test   %eax,%eax
 1bf:	0f 84 ab 00 00 00    	je     270 <strdiff+0xe0>
    if (strlen(str1) >= strlen(str2)) {
 1c5:	83 ec 0c             	sub    $0xc,%esp
 1c8:	53                   	push   %ebx
 1c9:	e8 72 01 00 00       	call   340 <strlen>
 1ce:	89 34 24             	mov    %esi,(%esp)
 1d1:	89 c7                	mov    %eax,%edi
 1d3:	e8 68 01 00 00       	call   340 <strlen>
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	39 c7                	cmp    %eax,%edi
 1dd:	0f 82 9d 00 00 00    	jb     280 <strdiff+0xf0>
        max_len = strlen(str1);
 1e3:	83 ec 0c             	sub    $0xc,%esp
 1e6:	53                   	push   %ebx
 1e7:	e8 54 01 00 00       	call   340 <strlen>
        min_len = strlen(str2);
 1ec:	89 34 24             	mov    %esi,(%esp)
        max_len = strlen(str1);
 1ef:	89 c7                	mov    %eax,%edi
        min_len = strlen(str2);
 1f1:	e8 4a 01 00 00       	call   340 <strlen>
        max_str = 1;
 1f6:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
 1fd:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < min_len; i++) {
 200:	85 c0                	test   %eax,%eax
 202:	0f 8e a0 00 00 00    	jle    2a8 <strdiff+0x118>
 208:	31 c9                	xor    %ecx,%ecx
 20a:	eb 06                	jmp    212 <strdiff+0x82>
 20c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 210:	89 d1                	mov    %edx,%ecx
            diff[i] = '1';
 212:	0f b6 14 0e          	movzbl (%esi,%ecx,1),%edx
 216:	38 14 0b             	cmp    %dl,(%ebx,%ecx,1)
 219:	0f 9c c2             	setl   %dl
 21c:	83 c2 30             	add    $0x30,%edx
 21f:	88 91 00 0e 00 00    	mov    %dl,0xe00(%ecx)
    for (i = 0; i < min_len; i++) {
 225:	8d 51 01             	lea    0x1(%ecx),%edx
 228:	39 d0                	cmp    %edx,%eax
 22a:	75 e4                	jne    210 <strdiff+0x80>
 22c:	83 c1 02             	add    $0x2,%ecx
    for (; i < max_len; i++) {
 22f:	39 d7                	cmp    %edx,%edi
 231:	7e 1f                	jle    252 <strdiff+0xc2>
 233:	b8 31 00 00 00       	mov    $0x31,%eax
 238:	2a 45 e4             	sub    -0x1c(%ebp),%al
 23b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 23f:	90                   	nop
        if (max_str == 0)
 240:	88 82 00 0e 00 00    	mov    %al,0xe00(%edx)
    for (; i < max_len; i++) {
 246:	89 d1                	mov    %edx,%ecx
 248:	83 c2 01             	add    $0x1,%edx
 24b:	39 d7                	cmp    %edx,%edi
 24d:	75 f1                	jne    240 <strdiff+0xb0>
 24f:	83 c1 02             	add    $0x2,%ecx
    diff[i++] = '\n';
 252:	c6 82 00 0e 00 00 0a 	movb   $0xa,0xe00(%edx)
    return 1;
 259:	b8 01 00 00 00       	mov    $0x1,%eax
    diff[i] = '\0';
 25e:	c6 81 00 0e 00 00 00 	movb   $0x0,0xe00(%ecx)
}
 265:	8d 65 f4             	lea    -0xc(%ebp),%esp
 268:	5b                   	pop    %ebx
 269:	5e                   	pop    %esi
 26a:	5f                   	pop    %edi
 26b:	5d                   	pop    %ebp
 26c:	c3                   	ret    
 26d:	8d 76 00             	lea    0x0(%esi),%esi
 270:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 273:	31 c0                	xor    %eax,%eax
}
 275:	5b                   	pop    %ebx
 276:	5e                   	pop    %esi
 277:	5f                   	pop    %edi
 278:	5d                   	pop    %ebp
 279:	c3                   	ret    
 27a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        max_len = strlen(str2);
 280:	83 ec 0c             	sub    $0xc,%esp
 283:	56                   	push   %esi
 284:	e8 b7 00 00 00       	call   340 <strlen>
        min_len = strlen(str1);
 289:	89 1c 24             	mov    %ebx,(%esp)
        max_len = strlen(str2);
 28c:	89 c7                	mov    %eax,%edi
        min_len = strlen(str1);
 28e:	e8 ad 00 00 00       	call   340 <strlen>
    int min_len, max_len, max_str = 0;
 293:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
        min_len = strlen(str1);
 29a:	83 c4 10             	add    $0x10,%esp
 29d:	e9 5e ff ff ff       	jmp    200 <strdiff+0x70>
 2a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (i = 0; i < min_len; i++) {
 2a8:	b9 01 00 00 00       	mov    $0x1,%ecx
 2ad:	31 d2                	xor    %edx,%edx
 2af:	e9 7b ff ff ff       	jmp    22f <strdiff+0x9f>
 2b4:	66 90                	xchg   %ax,%ax
 2b6:	66 90                	xchg   %ax,%ax
 2b8:	66 90                	xchg   %ax,%ax
 2ba:	66 90                	xchg   %ax,%ax
 2bc:	66 90                	xchg   %ax,%ax
 2be:	66 90                	xchg   %ax,%ax

000002c0 <strcpy>:
#include "stat.h"
#include "fcntl.h"
#include "user.h"
#include "x86.h"

char* strcpy(char* s, const char* t) {
 2c0:	f3 0f 1e fb          	endbr32 
 2c4:	55                   	push   %ebp
    char* os;

    os = s;
    while ((*s++ = *t++) != 0)
 2c5:	31 c0                	xor    %eax,%eax
char* strcpy(char* s, const char* t) {
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	53                   	push   %ebx
 2ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    while ((*s++ = *t++) != 0)
 2d0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 2d4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 2d7:	83 c0 01             	add    $0x1,%eax
 2da:	84 d2                	test   %dl,%dl
 2dc:	75 f2                	jne    2d0 <strcpy+0x10>
        ;
    return os;
}
 2de:	89 c8                	mov    %ecx,%eax
 2e0:	5b                   	pop    %ebx
 2e1:	5d                   	pop    %ebp
 2e2:	c3                   	ret    
 2e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002f0 <strcmp>:

int strcmp(const char* p, const char* q) {
 2f0:	f3 0f 1e fb          	endbr32 
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
 2f7:	53                   	push   %ebx
 2f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2fb:	8b 55 0c             	mov    0xc(%ebp),%edx
    while (*p && *p == *q)
 2fe:	0f b6 01             	movzbl (%ecx),%eax
 301:	0f b6 1a             	movzbl (%edx),%ebx
 304:	84 c0                	test   %al,%al
 306:	75 19                	jne    321 <strcmp+0x31>
 308:	eb 26                	jmp    330 <strcmp+0x40>
 30a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 310:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
        p++, q++;
 314:	83 c1 01             	add    $0x1,%ecx
 317:	83 c2 01             	add    $0x1,%edx
    while (*p && *p == *q)
 31a:	0f b6 1a             	movzbl (%edx),%ebx
 31d:	84 c0                	test   %al,%al
 31f:	74 0f                	je     330 <strcmp+0x40>
 321:	38 d8                	cmp    %bl,%al
 323:	74 eb                	je     310 <strcmp+0x20>
    return (uchar)*p - (uchar)*q;
 325:	29 d8                	sub    %ebx,%eax
}
 327:	5b                   	pop    %ebx
 328:	5d                   	pop    %ebp
 329:	c3                   	ret    
 32a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 330:	31 c0                	xor    %eax,%eax
    return (uchar)*p - (uchar)*q;
 332:	29 d8                	sub    %ebx,%eax
}
 334:	5b                   	pop    %ebx
 335:	5d                   	pop    %ebp
 336:	c3                   	ret    
 337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 33e:	66 90                	xchg   %ax,%ax

00000340 <strlen>:

uint strlen(const char* s) {
 340:	f3 0f 1e fb          	endbr32 
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	8b 55 08             	mov    0x8(%ebp),%edx
    int n;

    for (n = 0; s[n]; n++)
 34a:	80 3a 00             	cmpb   $0x0,(%edx)
 34d:	74 21                	je     370 <strlen+0x30>
 34f:	31 c0                	xor    %eax,%eax
 351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 358:	83 c0 01             	add    $0x1,%eax
 35b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 35f:	89 c1                	mov    %eax,%ecx
 361:	75 f5                	jne    358 <strlen+0x18>
        ;
    return n;
}
 363:	89 c8                	mov    %ecx,%eax
 365:	5d                   	pop    %ebp
 366:	c3                   	ret    
 367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 36e:	66 90                	xchg   %ax,%ax
    for (n = 0; s[n]; n++)
 370:	31 c9                	xor    %ecx,%ecx
}
 372:	5d                   	pop    %ebp
 373:	89 c8                	mov    %ecx,%eax
 375:	c3                   	ret    
 376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 37d:	8d 76 00             	lea    0x0(%esi),%esi

00000380 <memset>:

void* memset(void* dst, int c, uint n) {
 380:	f3 0f 1e fb          	endbr32 
 384:	55                   	push   %ebp
 385:	89 e5                	mov    %esp,%ebp
 387:	57                   	push   %edi
 388:	8b 55 08             	mov    0x8(%ebp),%edx
                 : "cc");
}

static inline void
stosb(void* addr, int data, int cnt) {
    asm volatile("cld; rep stosb"
 38b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 38e:	8b 45 0c             	mov    0xc(%ebp),%eax
 391:	89 d7                	mov    %edx,%edi
 393:	fc                   	cld    
 394:	f3 aa                	rep stos %al,%es:(%edi)
    stosb(dst, c, n);
    return dst;
}
 396:	89 d0                	mov    %edx,%eax
 398:	5f                   	pop    %edi
 399:	5d                   	pop    %ebp
 39a:	c3                   	ret    
 39b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 39f:	90                   	nop

000003a0 <strchr>:

char* strchr(const char* s, char c) {
 3a0:	f3 0f 1e fb          	endbr32 
 3a4:	55                   	push   %ebp
 3a5:	89 e5                	mov    %esp,%ebp
 3a7:	8b 45 08             	mov    0x8(%ebp),%eax
 3aa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
    for (; *s; s++)
 3ae:	0f b6 10             	movzbl (%eax),%edx
 3b1:	84 d2                	test   %dl,%dl
 3b3:	75 16                	jne    3cb <strchr+0x2b>
 3b5:	eb 21                	jmp    3d8 <strchr+0x38>
 3b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3be:	66 90                	xchg   %ax,%ax
 3c0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 3c4:	83 c0 01             	add    $0x1,%eax
 3c7:	84 d2                	test   %dl,%dl
 3c9:	74 0d                	je     3d8 <strchr+0x38>
        if (*s == c)
 3cb:	38 d1                	cmp    %dl,%cl
 3cd:	75 f1                	jne    3c0 <strchr+0x20>
            return (char*)s;
    return 0;
}
 3cf:	5d                   	pop    %ebp
 3d0:	c3                   	ret    
 3d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
 3d8:	31 c0                	xor    %eax,%eax
}
 3da:	5d                   	pop    %ebp
 3db:	c3                   	ret    
 3dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003e0 <gets>:

char* gets(char* buf, int max) {
 3e0:	f3 0f 1e fb          	endbr32 
 3e4:	55                   	push   %ebp
 3e5:	89 e5                	mov    %esp,%ebp
 3e7:	57                   	push   %edi
 3e8:	56                   	push   %esi
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;) {
 3e9:	31 f6                	xor    %esi,%esi
char* gets(char* buf, int max) {
 3eb:	53                   	push   %ebx
 3ec:	89 f3                	mov    %esi,%ebx
 3ee:	83 ec 1c             	sub    $0x1c,%esp
 3f1:	8b 7d 08             	mov    0x8(%ebp),%edi
    for (i = 0; i + 1 < max;) {
 3f4:	eb 33                	jmp    429 <gets+0x49>
 3f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3fd:	8d 76 00             	lea    0x0(%esi),%esi
        cc = read(0, &c, 1);
 400:	83 ec 04             	sub    $0x4,%esp
 403:	8d 45 e7             	lea    -0x19(%ebp),%eax
 406:	6a 01                	push   $0x1
 408:	50                   	push   %eax
 409:	6a 00                	push   $0x0
 40b:	e8 2b 01 00 00       	call   53b <read>
        if (cc < 1)
 410:	83 c4 10             	add    $0x10,%esp
 413:	85 c0                	test   %eax,%eax
 415:	7e 1c                	jle    433 <gets+0x53>
            break;
        buf[i++] = c;
 417:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 41b:	83 c7 01             	add    $0x1,%edi
 41e:	88 47 ff             	mov    %al,-0x1(%edi)
        if (c == '\n' || c == '\r')
 421:	3c 0a                	cmp    $0xa,%al
 423:	74 23                	je     448 <gets+0x68>
 425:	3c 0d                	cmp    $0xd,%al
 427:	74 1f                	je     448 <gets+0x68>
    for (i = 0; i + 1 < max;) {
 429:	83 c3 01             	add    $0x1,%ebx
 42c:	89 fe                	mov    %edi,%esi
 42e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 431:	7c cd                	jl     400 <gets+0x20>
 433:	89 f3                	mov    %esi,%ebx
            break;
    }
    buf[i] = '\0';
    return buf;
}
 435:	8b 45 08             	mov    0x8(%ebp),%eax
    buf[i] = '\0';
 438:	c6 03 00             	movb   $0x0,(%ebx)
}
 43b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 43e:	5b                   	pop    %ebx
 43f:	5e                   	pop    %esi
 440:	5f                   	pop    %edi
 441:	5d                   	pop    %ebp
 442:	c3                   	ret    
 443:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 447:	90                   	nop
 448:	8b 75 08             	mov    0x8(%ebp),%esi
 44b:	8b 45 08             	mov    0x8(%ebp),%eax
 44e:	01 de                	add    %ebx,%esi
 450:	89 f3                	mov    %esi,%ebx
    buf[i] = '\0';
 452:	c6 03 00             	movb   $0x0,(%ebx)
}
 455:	8d 65 f4             	lea    -0xc(%ebp),%esp
 458:	5b                   	pop    %ebx
 459:	5e                   	pop    %esi
 45a:	5f                   	pop    %edi
 45b:	5d                   	pop    %ebp
 45c:	c3                   	ret    
 45d:	8d 76 00             	lea    0x0(%esi),%esi

00000460 <stat>:

int stat(const char* n, struct stat* st) {
 460:	f3 0f 1e fb          	endbr32 
 464:	55                   	push   %ebp
 465:	89 e5                	mov    %esp,%ebp
 467:	56                   	push   %esi
 468:	53                   	push   %ebx
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 469:	83 ec 08             	sub    $0x8,%esp
 46c:	6a 00                	push   $0x0
 46e:	ff 75 08             	pushl  0x8(%ebp)
 471:	e8 ed 00 00 00       	call   563 <open>
    if (fd < 0)
 476:	83 c4 10             	add    $0x10,%esp
 479:	85 c0                	test   %eax,%eax
 47b:	78 2b                	js     4a8 <stat+0x48>
        return -1;
    r = fstat(fd, st);
 47d:	83 ec 08             	sub    $0x8,%esp
 480:	ff 75 0c             	pushl  0xc(%ebp)
 483:	89 c3                	mov    %eax,%ebx
 485:	50                   	push   %eax
 486:	e8 f0 00 00 00       	call   57b <fstat>
    close(fd);
 48b:	89 1c 24             	mov    %ebx,(%esp)
    r = fstat(fd, st);
 48e:	89 c6                	mov    %eax,%esi
    close(fd);
 490:	e8 b6 00 00 00       	call   54b <close>
    return r;
 495:	83 c4 10             	add    $0x10,%esp
}
 498:	8d 65 f8             	lea    -0x8(%ebp),%esp
 49b:	89 f0                	mov    %esi,%eax
 49d:	5b                   	pop    %ebx
 49e:	5e                   	pop    %esi
 49f:	5d                   	pop    %ebp
 4a0:	c3                   	ret    
 4a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
 4a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 4ad:	eb e9                	jmp    498 <stat+0x38>
 4af:	90                   	nop

000004b0 <atoi>:

int atoi(const char* s) {
 4b0:	f3 0f 1e fb          	endbr32 
 4b4:	55                   	push   %ebp
 4b5:	89 e5                	mov    %esp,%ebp
 4b7:	53                   	push   %ebx
 4b8:	8b 55 08             	mov    0x8(%ebp),%edx
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 4bb:	0f be 02             	movsbl (%edx),%eax
 4be:	8d 48 d0             	lea    -0x30(%eax),%ecx
 4c1:	80 f9 09             	cmp    $0x9,%cl
    n = 0;
 4c4:	b9 00 00 00 00       	mov    $0x0,%ecx
    while ('0' <= *s && *s <= '9')
 4c9:	77 1a                	ja     4e5 <atoi+0x35>
 4cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4cf:	90                   	nop
        n = n * 10 + *s++ - '0';
 4d0:	83 c2 01             	add    $0x1,%edx
 4d3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 4d6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
    while ('0' <= *s && *s <= '9')
 4da:	0f be 02             	movsbl (%edx),%eax
 4dd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 4e0:	80 fb 09             	cmp    $0x9,%bl
 4e3:	76 eb                	jbe    4d0 <atoi+0x20>
    return n;
}
 4e5:	89 c8                	mov    %ecx,%eax
 4e7:	5b                   	pop    %ebx
 4e8:	5d                   	pop    %ebp
 4e9:	c3                   	ret    
 4ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004f0 <memmove>:

void* memmove(void* vdst, const void* vsrc, int n) {
 4f0:	f3 0f 1e fb          	endbr32 
 4f4:	55                   	push   %ebp
 4f5:	89 e5                	mov    %esp,%ebp
 4f7:	57                   	push   %edi
 4f8:	8b 45 10             	mov    0x10(%ebp),%eax
 4fb:	8b 55 08             	mov    0x8(%ebp),%edx
 4fe:	56                   	push   %esi
 4ff:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* dst;
    const char* src;

    dst = vdst;
    src = vsrc;
    while (n-- > 0)
 502:	85 c0                	test   %eax,%eax
 504:	7e 0f                	jle    515 <memmove+0x25>
 506:	01 d0                	add    %edx,%eax
    dst = vdst;
 508:	89 d7                	mov    %edx,%edi
 50a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        *dst++ = *src++;
 510:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while (n-- > 0)
 511:	39 f8                	cmp    %edi,%eax
 513:	75 fb                	jne    510 <memmove+0x20>
    return vdst;
}
 515:	5e                   	pop    %esi
 516:	89 d0                	mov    %edx,%eax
 518:	5f                   	pop    %edi
 519:	5d                   	pop    %ebp
 51a:	c3                   	ret    

0000051b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 51b:	b8 01 00 00 00       	mov    $0x1,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <exit>:
SYSCALL(exit)
 523:	b8 02 00 00 00       	mov    $0x2,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <wait>:
SYSCALL(wait)
 52b:	b8 03 00 00 00       	mov    $0x3,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <pipe>:
SYSCALL(pipe)
 533:	b8 04 00 00 00       	mov    $0x4,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <read>:
SYSCALL(read)
 53b:	b8 05 00 00 00       	mov    $0x5,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <write>:
SYSCALL(write)
 543:	b8 10 00 00 00       	mov    $0x10,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <close>:
SYSCALL(close)
 54b:	b8 15 00 00 00       	mov    $0x15,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <kill>:
SYSCALL(kill)
 553:	b8 06 00 00 00       	mov    $0x6,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <exec>:
SYSCALL(exec)
 55b:	b8 07 00 00 00       	mov    $0x7,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <open>:
SYSCALL(open)
 563:	b8 0f 00 00 00       	mov    $0xf,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <mknod>:
SYSCALL(mknod)
 56b:	b8 11 00 00 00       	mov    $0x11,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <unlink>:
SYSCALL(unlink)
 573:	b8 12 00 00 00       	mov    $0x12,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <fstat>:
SYSCALL(fstat)
 57b:	b8 08 00 00 00       	mov    $0x8,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <link>:
SYSCALL(link)
 583:	b8 13 00 00 00       	mov    $0x13,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <mkdir>:
SYSCALL(mkdir)
 58b:	b8 14 00 00 00       	mov    $0x14,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <chdir>:
SYSCALL(chdir)
 593:	b8 09 00 00 00       	mov    $0x9,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <dup>:
SYSCALL(dup)
 59b:	b8 0a 00 00 00       	mov    $0xa,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <getpid>:
SYSCALL(getpid)
 5a3:	b8 0b 00 00 00       	mov    $0xb,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <sbrk>:
SYSCALL(sbrk)
 5ab:	b8 0c 00 00 00       	mov    $0xc,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <sleep>:
SYSCALL(sleep)
 5b3:	b8 0d 00 00 00       	mov    $0xd,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <uptime>:
SYSCALL(uptime)
 5bb:	b8 0e 00 00 00       	mov    $0xe,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <nuncle>:
SYSCALL(nuncle)
 5c3:	b8 16 00 00 00       	mov    $0x16,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <ptime>:
SYSCALL(ptime)
 5cb:	b8 17 00 00 00       	mov    $0x17,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <fcopy>:
SYSCALL(fcopy)
 5d3:	b8 18 00 00 00       	mov    $0x18,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    
 5db:	66 90                	xchg   %ax,%ax
 5dd:	66 90                	xchg   %ax,%ax
 5df:	90                   	nop

000005e0 <printint>:
putc(int fd, char c) {
    write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn) {
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	57                   	push   %edi
 5e4:	56                   	push   %esi
 5e5:	53                   	push   %ebx
 5e6:	83 ec 3c             	sub    $0x3c,%esp
 5e9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
    uint x;

    neg = 0;
    if (sgn && xx < 0) {
        neg = 1;
        x = -xx;
 5ec:	89 d1                	mov    %edx,%ecx
printint(int fd, int xx, int base, int sgn) {
 5ee:	89 45 b8             	mov    %eax,-0x48(%ebp)
    if (sgn && xx < 0) {
 5f1:	85 d2                	test   %edx,%edx
 5f3:	0f 89 7f 00 00 00    	jns    678 <printint+0x98>
 5f9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5fd:	74 79                	je     678 <printint+0x98>
        neg = 1;
 5ff:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
        x = -xx;
 606:	f7 d9                	neg    %ecx
    }
    else {
        x = xx;
    }

    i = 0;
 608:	31 db                	xor    %ebx,%ebx
 60a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 60d:	8d 76 00             	lea    0x0(%esi),%esi
    do {
        buf[i++] = digits[x % base];
 610:	89 c8                	mov    %ecx,%eax
 612:	31 d2                	xor    %edx,%edx
 614:	89 cf                	mov    %ecx,%edi
 616:	f7 75 c4             	divl   -0x3c(%ebp)
 619:	0f b6 92 c8 0a 00 00 	movzbl 0xac8(%edx),%edx
 620:	89 45 c0             	mov    %eax,-0x40(%ebp)
 623:	89 d8                	mov    %ebx,%eax
 625:	8d 5b 01             	lea    0x1(%ebx),%ebx
    } while ((x /= base) != 0);
 628:	8b 4d c0             	mov    -0x40(%ebp),%ecx
        buf[i++] = digits[x % base];
 62b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
    } while ((x /= base) != 0);
 62e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 631:	76 dd                	jbe    610 <printint+0x30>
    if (neg)
 633:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 636:	85 c9                	test   %ecx,%ecx
 638:	74 0c                	je     646 <printint+0x66>
        buf[i++] = '-';
 63a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
        buf[i++] = digits[x % base];
 63f:	89 d8                	mov    %ebx,%eax
        buf[i++] = '-';
 641:	ba 2d 00 00 00       	mov    $0x2d,%edx

    while (--i >= 0)
 646:	8b 7d b8             	mov    -0x48(%ebp),%edi
 649:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 64d:	eb 07                	jmp    656 <printint+0x76>
 64f:	90                   	nop
 650:	0f b6 13             	movzbl (%ebx),%edx
 653:	83 eb 01             	sub    $0x1,%ebx
    write(fd, &c, 1);
 656:	83 ec 04             	sub    $0x4,%esp
 659:	88 55 d7             	mov    %dl,-0x29(%ebp)
 65c:	6a 01                	push   $0x1
 65e:	56                   	push   %esi
 65f:	57                   	push   %edi
 660:	e8 de fe ff ff       	call   543 <write>
    while (--i >= 0)
 665:	83 c4 10             	add    $0x10,%esp
 668:	39 de                	cmp    %ebx,%esi
 66a:	75 e4                	jne    650 <printint+0x70>
        putc(fd, buf[i]);
}
 66c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 66f:	5b                   	pop    %ebx
 670:	5e                   	pop    %esi
 671:	5f                   	pop    %edi
 672:	5d                   	pop    %ebp
 673:	c3                   	ret    
 674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    neg = 0;
 678:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 67f:	eb 87                	jmp    608 <printint+0x28>
 681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 68f:	90                   	nop

00000690 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void printf(int fd, const char* fmt, ...) {
 690:	f3 0f 1e fb          	endbr32 
 694:	55                   	push   %ebp
 695:	89 e5                	mov    %esp,%ebp
 697:	57                   	push   %edi
 698:	56                   	push   %esi
 699:	53                   	push   %ebx
 69a:	83 ec 2c             	sub    $0x2c,%esp
    int c, i, state;
    uint* ap;

    state = 0;
    ap = (uint*)(void*)&fmt + 1;
    for (i = 0; fmt[i]; i++) {
 69d:	8b 75 0c             	mov    0xc(%ebp),%esi
 6a0:	0f b6 1e             	movzbl (%esi),%ebx
 6a3:	84 db                	test   %bl,%bl
 6a5:	0f 84 b4 00 00 00    	je     75f <printf+0xcf>
    ap = (uint*)(void*)&fmt + 1;
 6ab:	8d 45 10             	lea    0x10(%ebp),%eax
 6ae:	83 c6 01             	add    $0x1,%esi
    write(fd, &c, 1);
 6b1:	8d 7d e7             	lea    -0x19(%ebp),%edi
    state = 0;
 6b4:	31 d2                	xor    %edx,%edx
    ap = (uint*)(void*)&fmt + 1;
 6b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6b9:	eb 33                	jmp    6ee <printf+0x5e>
 6bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6bf:	90                   	nop
 6c0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        c = fmt[i] & 0xff;
        if (state == 0) {
            if (c == '%') {
                state = '%';
 6c3:	ba 25 00 00 00       	mov    $0x25,%edx
            if (c == '%') {
 6c8:	83 f8 25             	cmp    $0x25,%eax
 6cb:	74 17                	je     6e4 <printf+0x54>
    write(fd, &c, 1);
 6cd:	83 ec 04             	sub    $0x4,%esp
 6d0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6d3:	6a 01                	push   $0x1
 6d5:	57                   	push   %edi
 6d6:	ff 75 08             	pushl  0x8(%ebp)
 6d9:	e8 65 fe ff ff       	call   543 <write>
 6de:	8b 55 d4             	mov    -0x2c(%ebp),%edx
            }
            else {
                putc(fd, c);
 6e1:	83 c4 10             	add    $0x10,%esp
    for (i = 0; fmt[i]; i++) {
 6e4:	0f b6 1e             	movzbl (%esi),%ebx
 6e7:	83 c6 01             	add    $0x1,%esi
 6ea:	84 db                	test   %bl,%bl
 6ec:	74 71                	je     75f <printf+0xcf>
        c = fmt[i] & 0xff;
 6ee:	0f be cb             	movsbl %bl,%ecx
 6f1:	0f b6 c3             	movzbl %bl,%eax
        if (state == 0) {
 6f4:	85 d2                	test   %edx,%edx
 6f6:	74 c8                	je     6c0 <printf+0x30>
            }
        }
        else if (state == '%') {
 6f8:	83 fa 25             	cmp    $0x25,%edx
 6fb:	75 e7                	jne    6e4 <printf+0x54>
            if (c == 'd') {
 6fd:	83 f8 64             	cmp    $0x64,%eax
 700:	0f 84 9a 00 00 00    	je     7a0 <printf+0x110>
                printint(fd, *ap, 10, 1);
                ap++;
            }
            else if (c == 'x' || c == 'p') {
 706:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 70c:	83 f9 70             	cmp    $0x70,%ecx
 70f:	74 5f                	je     770 <printf+0xe0>
                printint(fd, *ap, 16, 0);
                ap++;
            }
            else if (c == 's') {
 711:	83 f8 73             	cmp    $0x73,%eax
 714:	0f 84 d6 00 00 00    	je     7f0 <printf+0x160>
                while (*s != 0) {
                    putc(fd, *s);
                    s++;
                }
            }
            else if (c == 'c') {
 71a:	83 f8 63             	cmp    $0x63,%eax
 71d:	0f 84 8d 00 00 00    	je     7b0 <printf+0x120>
                putc(fd, *ap);
                ap++;
            }
            else if (c == '%') {
 723:	83 f8 25             	cmp    $0x25,%eax
 726:	0f 84 b4 00 00 00    	je     7e0 <printf+0x150>
    write(fd, &c, 1);
 72c:	83 ec 04             	sub    $0x4,%esp
 72f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 733:	6a 01                	push   $0x1
 735:	57                   	push   %edi
 736:	ff 75 08             	pushl  0x8(%ebp)
 739:	e8 05 fe ff ff       	call   543 <write>
                putc(fd, c);
            }
            else {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
                putc(fd, c);
 73e:	88 5d e7             	mov    %bl,-0x19(%ebp)
    write(fd, &c, 1);
 741:	83 c4 0c             	add    $0xc,%esp
 744:	6a 01                	push   $0x1
 746:	83 c6 01             	add    $0x1,%esi
 749:	57                   	push   %edi
 74a:	ff 75 08             	pushl  0x8(%ebp)
 74d:	e8 f1 fd ff ff       	call   543 <write>
    for (i = 0; fmt[i]; i++) {
 752:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
                putc(fd, c);
 756:	83 c4 10             	add    $0x10,%esp
            }
            state = 0;
 759:	31 d2                	xor    %edx,%edx
    for (i = 0; fmt[i]; i++) {
 75b:	84 db                	test   %bl,%bl
 75d:	75 8f                	jne    6ee <printf+0x5e>
        }
    }
}
 75f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 762:	5b                   	pop    %ebx
 763:	5e                   	pop    %esi
 764:	5f                   	pop    %edi
 765:	5d                   	pop    %ebp
 766:	c3                   	ret    
 767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 76e:	66 90                	xchg   %ax,%ax
                printint(fd, *ap, 16, 0);
 770:	83 ec 0c             	sub    $0xc,%esp
 773:	b9 10 00 00 00       	mov    $0x10,%ecx
 778:	6a 00                	push   $0x0
 77a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 77d:	8b 45 08             	mov    0x8(%ebp),%eax
 780:	8b 13                	mov    (%ebx),%edx
 782:	e8 59 fe ff ff       	call   5e0 <printint>
                ap++;
 787:	89 d8                	mov    %ebx,%eax
 789:	83 c4 10             	add    $0x10,%esp
            state = 0;
 78c:	31 d2                	xor    %edx,%edx
                ap++;
 78e:	83 c0 04             	add    $0x4,%eax
 791:	89 45 d0             	mov    %eax,-0x30(%ebp)
 794:	e9 4b ff ff ff       	jmp    6e4 <printf+0x54>
 799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                printint(fd, *ap, 10, 1);
 7a0:	83 ec 0c             	sub    $0xc,%esp
 7a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7a8:	6a 01                	push   $0x1
 7aa:	eb ce                	jmp    77a <printf+0xea>
 7ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                putc(fd, *ap);
 7b0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    write(fd, &c, 1);
 7b3:	83 ec 04             	sub    $0x4,%esp
                putc(fd, *ap);
 7b6:	8b 03                	mov    (%ebx),%eax
    write(fd, &c, 1);
 7b8:	6a 01                	push   $0x1
                ap++;
 7ba:	83 c3 04             	add    $0x4,%ebx
    write(fd, &c, 1);
 7bd:	57                   	push   %edi
 7be:	ff 75 08             	pushl  0x8(%ebp)
                putc(fd, *ap);
 7c1:	88 45 e7             	mov    %al,-0x19(%ebp)
    write(fd, &c, 1);
 7c4:	e8 7a fd ff ff       	call   543 <write>
                ap++;
 7c9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 7cc:	83 c4 10             	add    $0x10,%esp
            state = 0;
 7cf:	31 d2                	xor    %edx,%edx
 7d1:	e9 0e ff ff ff       	jmp    6e4 <printf+0x54>
 7d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7dd:	8d 76 00             	lea    0x0(%esi),%esi
                putc(fd, c);
 7e0:	88 5d e7             	mov    %bl,-0x19(%ebp)
    write(fd, &c, 1);
 7e3:	83 ec 04             	sub    $0x4,%esp
 7e6:	e9 59 ff ff ff       	jmp    744 <printf+0xb4>
 7eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7ef:	90                   	nop
                s = (char*)*ap;
 7f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 7f3:	8b 18                	mov    (%eax),%ebx
                ap++;
 7f5:	83 c0 04             	add    $0x4,%eax
 7f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
                if (s == 0)
 7fb:	85 db                	test   %ebx,%ebx
 7fd:	74 17                	je     816 <printf+0x186>
                while (*s != 0) {
 7ff:	0f b6 03             	movzbl (%ebx),%eax
            state = 0;
 802:	31 d2                	xor    %edx,%edx
                while (*s != 0) {
 804:	84 c0                	test   %al,%al
 806:	0f 84 d8 fe ff ff    	je     6e4 <printf+0x54>
 80c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 80f:	89 de                	mov    %ebx,%esi
 811:	8b 5d 08             	mov    0x8(%ebp),%ebx
 814:	eb 1a                	jmp    830 <printf+0x1a0>
                    s = "(null)";
 816:	bb be 0a 00 00       	mov    $0xabe,%ebx
                while (*s != 0) {
 81b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 81e:	b8 28 00 00 00       	mov    $0x28,%eax
 823:	89 de                	mov    %ebx,%esi
 825:	8b 5d 08             	mov    0x8(%ebp),%ebx
 828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 82f:	90                   	nop
    write(fd, &c, 1);
 830:	83 ec 04             	sub    $0x4,%esp
                    s++;
 833:	83 c6 01             	add    $0x1,%esi
 836:	88 45 e7             	mov    %al,-0x19(%ebp)
    write(fd, &c, 1);
 839:	6a 01                	push   $0x1
 83b:	57                   	push   %edi
 83c:	53                   	push   %ebx
 83d:	e8 01 fd ff ff       	call   543 <write>
                while (*s != 0) {
 842:	0f b6 06             	movzbl (%esi),%eax
 845:	83 c4 10             	add    $0x10,%esp
 848:	84 c0                	test   %al,%al
 84a:	75 e4                	jne    830 <printf+0x1a0>
 84c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
            state = 0;
 84f:	31 d2                	xor    %edx,%edx
 851:	e9 8e fe ff ff       	jmp    6e4 <printf+0x54>
 856:	66 90                	xchg   %ax,%ax
 858:	66 90                	xchg   %ax,%ax
 85a:	66 90                	xchg   %ax,%ax
 85c:	66 90                	xchg   %ax,%ax
 85e:	66 90                	xchg   %ax,%ax

00000860 <free>:
typedef union header Header;

static Header base;
static Header* freep;

void free(void* ap) {
 860:	f3 0f 1e fb          	endbr32 
 864:	55                   	push   %ebp
    Header *bp, *p;

    bp = (Header*)ap - 1;
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 865:	a1 f4 0d 00 00       	mov    0xdf4,%eax
void free(void* ap) {
 86a:	89 e5                	mov    %esp,%ebp
 86c:	57                   	push   %edi
 86d:	56                   	push   %esi
 86e:	53                   	push   %ebx
 86f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 872:	8b 10                	mov    (%eax),%edx
    bp = (Header*)ap - 1;
 874:	8d 4b f8             	lea    -0x8(%ebx),%ecx
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 877:	39 c8                	cmp    %ecx,%eax
 879:	73 15                	jae    890 <free+0x30>
 87b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 87f:	90                   	nop
 880:	39 d1                	cmp    %edx,%ecx
 882:	72 14                	jb     898 <free+0x38>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 884:	39 d0                	cmp    %edx,%eax
 886:	73 10                	jae    898 <free+0x38>
void free(void* ap) {
 888:	89 d0                	mov    %edx,%eax
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88a:	8b 10                	mov    (%eax),%edx
 88c:	39 c8                	cmp    %ecx,%eax
 88e:	72 f0                	jb     880 <free+0x20>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 890:	39 d0                	cmp    %edx,%eax
 892:	72 f4                	jb     888 <free+0x28>
 894:	39 d1                	cmp    %edx,%ecx
 896:	73 f0                	jae    888 <free+0x28>
            break;
    if (bp + bp->s.size == p->s.ptr) {
 898:	8b 73 fc             	mov    -0x4(%ebx),%esi
 89b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 89e:	39 fa                	cmp    %edi,%edx
 8a0:	74 1e                	je     8c0 <free+0x60>
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
    }
    else
        bp->s.ptr = p->s.ptr;
 8a2:	89 53 f8             	mov    %edx,-0x8(%ebx)
    if (p + p->s.size == bp) {
 8a5:	8b 50 04             	mov    0x4(%eax),%edx
 8a8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8ab:	39 f1                	cmp    %esi,%ecx
 8ad:	74 28                	je     8d7 <free+0x77>
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
    }
    else
        p->s.ptr = bp;
 8af:	89 08                	mov    %ecx,(%eax)
    freep = p;
}
 8b1:	5b                   	pop    %ebx
    freep = p;
 8b2:	a3 f4 0d 00 00       	mov    %eax,0xdf4
}
 8b7:	5e                   	pop    %esi
 8b8:	5f                   	pop    %edi
 8b9:	5d                   	pop    %ebp
 8ba:	c3                   	ret    
 8bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8bf:	90                   	nop
        bp->s.size += p->s.ptr->s.size;
 8c0:	03 72 04             	add    0x4(%edx),%esi
 8c3:	89 73 fc             	mov    %esi,-0x4(%ebx)
        bp->s.ptr = p->s.ptr->s.ptr;
 8c6:	8b 10                	mov    (%eax),%edx
 8c8:	8b 12                	mov    (%edx),%edx
 8ca:	89 53 f8             	mov    %edx,-0x8(%ebx)
    if (p + p->s.size == bp) {
 8cd:	8b 50 04             	mov    0x4(%eax),%edx
 8d0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8d3:	39 f1                	cmp    %esi,%ecx
 8d5:	75 d8                	jne    8af <free+0x4f>
        p->s.size += bp->s.size;
 8d7:	03 53 fc             	add    -0x4(%ebx),%edx
    freep = p;
 8da:	a3 f4 0d 00 00       	mov    %eax,0xdf4
        p->s.size += bp->s.size;
 8df:	89 50 04             	mov    %edx,0x4(%eax)
        p->s.ptr = bp->s.ptr;
 8e2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 8e5:	89 10                	mov    %edx,(%eax)
}
 8e7:	5b                   	pop    %ebx
 8e8:	5e                   	pop    %esi
 8e9:	5f                   	pop    %edi
 8ea:	5d                   	pop    %ebp
 8eb:	c3                   	ret    
 8ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008f0 <malloc>:
    hp->s.size = nu;
    free((void*)(hp + 1));
    return freep;
}

void* malloc(uint nbytes) {
 8f0:	f3 0f 1e fb          	endbr32 
 8f4:	55                   	push   %ebp
 8f5:	89 e5                	mov    %esp,%ebp
 8f7:	57                   	push   %edi
 8f8:	56                   	push   %esi
 8f9:	53                   	push   %ebx
 8fa:	83 ec 1c             	sub    $0x1c,%esp
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8fd:	8b 45 08             	mov    0x8(%ebp),%eax
    if ((prevp = freep) == 0) {
 900:	8b 3d f4 0d 00 00    	mov    0xdf4,%edi
    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 906:	8d 70 07             	lea    0x7(%eax),%esi
 909:	c1 ee 03             	shr    $0x3,%esi
 90c:	83 c6 01             	add    $0x1,%esi
    if ((prevp = freep) == 0) {
 90f:	85 ff                	test   %edi,%edi
 911:	0f 84 a9 00 00 00    	je     9c0 <malloc+0xd0>
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 917:	8b 07                	mov    (%edi),%eax
        if (p->s.size >= nunits) {
 919:	8b 48 04             	mov    0x4(%eax),%ecx
 91c:	39 f1                	cmp    %esi,%ecx
 91e:	73 6d                	jae    98d <malloc+0x9d>
 920:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 926:	bb 00 10 00 00       	mov    $0x1000,%ebx
 92b:	0f 43 de             	cmovae %esi,%ebx
    p = sbrk(nu * sizeof(Header));
 92e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 935:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 938:	eb 17                	jmp    951 <malloc+0x61>
 93a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 940:	8b 10                	mov    (%eax),%edx
        if (p->s.size >= nunits) {
 942:	8b 4a 04             	mov    0x4(%edx),%ecx
 945:	39 f1                	cmp    %esi,%ecx
 947:	73 4f                	jae    998 <malloc+0xa8>
 949:	8b 3d f4 0d 00 00    	mov    0xdf4,%edi
 94f:	89 d0                	mov    %edx,%eax
                p->s.size = nunits;
            }
            freep = prevp;
            return (void*)(p + 1);
        }
        if (p == freep)
 951:	39 c7                	cmp    %eax,%edi
 953:	75 eb                	jne    940 <malloc+0x50>
    p = sbrk(nu * sizeof(Header));
 955:	83 ec 0c             	sub    $0xc,%esp
 958:	ff 75 e4             	pushl  -0x1c(%ebp)
 95b:	e8 4b fc ff ff       	call   5ab <sbrk>
    if (p == (char*)-1)
 960:	83 c4 10             	add    $0x10,%esp
 963:	83 f8 ff             	cmp    $0xffffffff,%eax
 966:	74 1b                	je     983 <malloc+0x93>
    hp->s.size = nu;
 968:	89 58 04             	mov    %ebx,0x4(%eax)
    free((void*)(hp + 1));
 96b:	83 ec 0c             	sub    $0xc,%esp
 96e:	83 c0 08             	add    $0x8,%eax
 971:	50                   	push   %eax
 972:	e8 e9 fe ff ff       	call   860 <free>
    return freep;
 977:	a1 f4 0d 00 00       	mov    0xdf4,%eax
            if ((p = morecore(nunits)) == 0)
 97c:	83 c4 10             	add    $0x10,%esp
 97f:	85 c0                	test   %eax,%eax
 981:	75 bd                	jne    940 <malloc+0x50>
                return 0;
    }
}
 983:	8d 65 f4             	lea    -0xc(%ebp),%esp
                return 0;
 986:	31 c0                	xor    %eax,%eax
}
 988:	5b                   	pop    %ebx
 989:	5e                   	pop    %esi
 98a:	5f                   	pop    %edi
 98b:	5d                   	pop    %ebp
 98c:	c3                   	ret    
        if (p->s.size >= nunits) {
 98d:	89 c2                	mov    %eax,%edx
 98f:	89 f8                	mov    %edi,%eax
 991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            if (p->s.size == nunits)
 998:	39 ce                	cmp    %ecx,%esi
 99a:	74 54                	je     9f0 <malloc+0x100>
                p->s.size -= nunits;
 99c:	29 f1                	sub    %esi,%ecx
 99e:	89 4a 04             	mov    %ecx,0x4(%edx)
                p += p->s.size;
 9a1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
                p->s.size = nunits;
 9a4:	89 72 04             	mov    %esi,0x4(%edx)
            freep = prevp;
 9a7:	a3 f4 0d 00 00       	mov    %eax,0xdf4
}
 9ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return (void*)(p + 1);
 9af:	8d 42 08             	lea    0x8(%edx),%eax
}
 9b2:	5b                   	pop    %ebx
 9b3:	5e                   	pop    %esi
 9b4:	5f                   	pop    %edi
 9b5:	5d                   	pop    %ebp
 9b6:	c3                   	ret    
 9b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9be:	66 90                	xchg   %ax,%ax
        base.s.ptr = freep = prevp = &base;
 9c0:	c7 05 f4 0d 00 00 f8 	movl   $0xdf8,0xdf4
 9c7:	0d 00 00 
        base.s.size = 0;
 9ca:	bf f8 0d 00 00       	mov    $0xdf8,%edi
        base.s.ptr = freep = prevp = &base;
 9cf:	c7 05 f8 0d 00 00 f8 	movl   $0xdf8,0xdf8
 9d6:	0d 00 00 
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9d9:	89 f8                	mov    %edi,%eax
        base.s.size = 0;
 9db:	c7 05 fc 0d 00 00 00 	movl   $0x0,0xdfc
 9e2:	00 00 00 
        if (p->s.size >= nunits) {
 9e5:	e9 36 ff ff ff       	jmp    920 <malloc+0x30>
 9ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                prevp->s.ptr = p->s.ptr;
 9f0:	8b 0a                	mov    (%edx),%ecx
 9f2:	89 08                	mov    %ecx,(%eax)
 9f4:	eb b1                	jmp    9a7 <malloc+0xb7>
