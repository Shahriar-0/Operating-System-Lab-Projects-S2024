
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 3b 10 80       	mov    $0x80103be0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
    // Linked list of all buffers, through prev/next.
    // head.next is most recently used.
    struct buf head;
} bcache;

void binit(void) {
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

    // PAGEBREAK!
    //  Create linked list of buffers
    bcache.head.prev = &bcache.head;
    bcache.head.next = &bcache.head;
    for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
80100048:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
void binit(void) {
8010004d:	83 ec 0c             	sub    $0xc,%esp
    initlock(&bcache.lock, "bcache");
80100050:	68 e0 7d 10 80       	push   $0x80107de0
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 b1 4f 00 00       	call   80105010 <initlock>
    bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc 0c 11 80       	mov    $0x80110cbc,%eax
    bcache.head.prev = &bcache.head;
80100067:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
8010006e:	0c 11 80 
    bcache.head.next = &bcache.head;
80100071:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
80100078:	0c 11 80 
    for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
        b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
        b->prev = &bcache.head;
        initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
        b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
        initsleeplock(&b->lock, "buffer");
80100092:	68 e7 7d 10 80       	push   $0x80107de7
80100097:	50                   	push   %eax
80100098:	e8 33 4e 00 00       	call   80104ed0 <initsleeplock>
        bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
        bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
        bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
    for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
801000b6:	81 fb 60 0a 11 80    	cmp    $0x80110a60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
    }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
    panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno) {
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
    acquire(&bcache.lock);
801000e3:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e8:	e8 a3 50 00 00       	call   80105190 <acquire>
    for (b = bcache.head.next; b != &bcache.head; b = b->next) {
801000ed:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
        if (b->dev == dev && b->blockno == blockno) {
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
            b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
            release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
    for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
        if (b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
            b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
            b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
            b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
            b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
            release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 e9 50 00 00       	call   80105250 <release>
            acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 4d 00 00       	call   80104f10 <acquiresleep>
            return b;
80100172:	83 c4 10             	add    $0x10,%esp
    struct buf* b;

    b = bget(dev, blockno);
    if ((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
        iderw(b);
    }
    return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 8f 2c 00 00       	call   80102e20 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
    panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 ee 7d 10 80       	push   $0x80107dee
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void bwrite(struct buf* b) {
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 e9 4d 00 00       	call   80104fb0 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
        panic("bwrite");
    b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
    iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
    iderw(b);
801001d8:	e9 43 2c 00 00       	jmp    80102e20 <iderw>
        panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 ff 7d 10 80       	push   $0x80107dff
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void brelse(struct buf* b) {
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 a8 4d 00 00       	call   80104fb0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
        panic("brelse");

    releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 58 4d 00 00       	call   80104f70 <releasesleep>

    acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 6c 4f 00 00       	call   80105190 <acquire>
    b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
    if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
    b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
    if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
        // no one is waiting for it.
        b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
        b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
        b->next = bcache.head.next;
80100246:	a1 10 0d 11 80       	mov    0x80110d10,%eax
        b->prev = &bcache.head;
8010024b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
        b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
        bcache.head.next->prev = b;
80100255:	a1 10 0d 11 80       	mov    0x80110d10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
        bcache.head.next = b;
8010025d:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
    }

    release(&bcache.lock);
80100263:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
    release(&bcache.lock);
80100270:	e9 db 4f 00 00       	jmp    80105250 <release>
        panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 06 7e 10 80       	push   $0x80107e06
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
    if (doprocdump) {
        procdump(); // now call procdump() wo. cons.lock held
    }
}

int consoleread(struct inode* ip, char* dst, int n) {
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
    uint target;
    int c;

    iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
int consoleread(struct inode* ip, char* dst, int n) {
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
    target = n;
801002a3:	89 de                	mov    %ebx,%esi
    iunlock(ip);
801002a5:	e8 36 21 00 00       	call   801023e0 <iunlock>
    acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 da 4e 00 00       	call   80105190 <acquire>
                // caller gets a 0-byte result.
                input.r--;
            }
            break;
        }
        *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
    while (n > 0) {
801002b9:	83 c4 10             	add    $0x10,%esp
        *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
    while (n > 0) {
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
        while (input.r == input.w) {
801002c6:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002cb:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
            sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 a0 0f 11 80       	push   $0x80110fa0
801002e5:	e8 e6 47 00 00       	call   80104ad0 <sleep>
        while (input.r == input.w) {
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
            if (myproc()->killed) {
801002fa:	e8 01 42 00 00       	call   80104500 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
                release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 3d 4f 00 00       	call   80105250 <release>
                ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 e4 1f 00 00       	call   80102300 <ilock>
                return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
    }
    release(&cons.lock);
    ilock(ip);

    return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
                return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%ecx
        if (c == C('D')) { // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
        *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
        --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
        *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
        if (c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
    release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 e6 4e 00 00       	call   80105250 <release>
    ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 8d 1f 00 00       	call   80102300 <ilock>
    return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
            if (n < target) {
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
                input.r--;
80100386:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
void panic(char* s) {
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
                 : "r"(v));
}

static inline void
cli(void) {
    asm volatile("cli");
8010039c:	fa                   	cli    
    cons.locking = 0;
8010039d:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a4:	00 00 00 
    getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
    cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 8e 30 00 00       	call   80103440 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 0d 7e 10 80       	push   $0x80107e0d
801003bb:	e8 00 04 00 00       	call   801007c0 <cprintf>
    cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 f7 03 00 00       	call   801007c0 <cprintf>
    cprintf("\n");
801003c9:	c7 04 24 e0 85 10 80 	movl   $0x801085e0,(%esp)
801003d0:	e8 eb 03 00 00       	call   801007c0 <cprintf>
    getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 4f 4c 00 00       	call   80105030 <getcallerpcs>
    for (i = 0; i < 10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
        cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 21 7e 10 80       	push   $0x80107e21
801003f1:	e8 ca 03 00 00       	call   801007c0 <cprintf>
    for (i = 0; i < 10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
    panicked = 1; // freeze other CPU
801003fd:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100404:	00 00 00 
    for (;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
void consputc(int c) {
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
    if (c == BACKSPACE) {
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
        uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 b1 65 00 00       	call   801069e0 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
    asm volatile("out %0,%1"
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
    pos = inb(CRTPORT + 1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
    asm volatile("out %0,%1"
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
    pos |= inb(CRTPORT + 1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
    if (c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
    else if (c == BACKSPACE) {
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
        crt[pos++] = (c & 0xff) | 0x0700; // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
    if (pos < 0 || pos > 25 * 80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
    if ((pos / 80) >= 24) { // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
    asm volatile("out %0,%1"
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
    crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
            --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
        if (pos > 0)
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        pos += 80 - pos % 80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
        uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 c6 64 00 00       	call   801069e0 <uartputc>
        uartputc(' ');
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 ba 64 00 00       	call   801069e0 <uartputc>
        uartputc('\b');
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 ae 64 00 00       	call   801069e0 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
80100540:	83 ec 04             	sub    $0x4,%esp
        pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
        memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
        memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 da 4d 00 00       	call   80105340 <memmove>
        memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 25 4d 00 00       	call   801052a0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
        panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 25 7e 10 80       	push   $0x80107e25
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
printint(int xx, int base, int sign) {
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
        x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
    i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
        buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 a8 7e 10 80 	movzbl -0x7fef8158(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
    } while ((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
        buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
    } while ((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
    if (sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
        buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
        buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
        buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
    while (--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
    if (panicked) {
80100603:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
    asm volatile("cli");
8010060d:	fa                   	cli    
        for (;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
    while (--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
        x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <conseraseline>:
conseraseline(void) {
80100640:	55                   	push   %ebp
    asm volatile("out %0,%1"
80100641:	b8 0e 00 00 00       	mov    $0xe,%eax
80100646:	89 e5                	mov    %esp,%ebp
80100648:	57                   	push   %edi
80100649:	56                   	push   %esi
8010064a:	53                   	push   %ebx
8010064b:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100650:	89 da                	mov    %ebx,%edx
80100652:	83 ec 0c             	sub    $0xc,%esp
80100655:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80100656:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010065b:	89 ca                	mov    %ecx,%edx
8010065d:	ec                   	in     (%dx),%al
    asm volatile("out %0,%1"
8010065e:	bf 0f 00 00 00       	mov    $0xf,%edi
    pos = inb(CRTPORT + 1) << 8;
80100663:	0f b6 f0             	movzbl %al,%esi
80100666:	89 da                	mov    %ebx,%edx
80100668:	c1 e6 08             	shl    $0x8,%esi
8010066b:	89 f8                	mov    %edi,%eax
8010066d:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
8010066e:	89 ca                	mov    %ecx,%edx
80100670:	ec                   	in     (%dx),%al
    pos |= inb(CRTPORT + 1);
80100671:	0f b6 c0             	movzbl %al,%eax
    asm volatile("out %0,%1"
80100674:	89 da                	mov    %ebx,%edx
80100676:	09 c6                	or     %eax,%esi
80100678:	b8 0e 00 00 00       	mov    $0xe,%eax
    setpos(getpos() + input.shift);
8010067d:	03 35 ac 0f 11 80    	add    0x80110fac,%esi
80100683:	ee                   	out    %al,(%dx)
    outb(CRTPORT + 1, pos >> 8);
80100684:	89 f0                	mov    %esi,%eax
80100686:	89 ca                	mov    %ecx,%edx
80100688:	c1 f8 08             	sar    $0x8,%eax
8010068b:	ee                   	out    %al,(%dx)
8010068c:	89 f8                	mov    %edi,%eax
8010068e:	89 da                	mov    %ebx,%edx
80100690:	ee                   	out    %al,(%dx)
80100691:	89 f0                	mov    %esi,%eax
80100693:	89 ca                	mov    %ecx,%edx
80100695:	ee                   	out    %al,(%dx)
    input.shift = 0;
80100696:	c7 05 ac 0f 11 80 00 	movl   $0x0,0x80110fac
8010069d:	00 00 00 
    while (input.e != input.w && input.buf[(input.e - 1) % INPUT_BUF] != '\n') {
801006a0:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801006a5:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801006ab:	74 3a                	je     801006e7 <conseraseline+0xa7>
801006ad:	83 e8 01             	sub    $0x1,%eax
801006b0:	89 c2                	mov    %eax,%edx
801006b2:	83 e2 7f             	and    $0x7f,%edx
801006b5:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
801006bc:	74 29                	je     801006e7 <conseraseline+0xa7>
        input.e--;
801006be:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
    if (panicked) {
801006c3:	a1 58 b5 10 80       	mov    0x8010b558,%eax
801006c8:	85 c0                	test   %eax,%eax
801006ca:	74 04                	je     801006d0 <conseraseline+0x90>
    asm volatile("cli");
801006cc:	fa                   	cli    
        for (;;)
801006cd:	eb fe                	jmp    801006cd <conseraseline+0x8d>
801006cf:	90                   	nop
801006d0:	b8 00 01 00 00       	mov    $0x100,%eax
801006d5:	e8 36 fd ff ff       	call   80100410 <consputc.part.0>
    while (input.e != input.w && input.buf[(input.e - 1) % INPUT_BUF] != '\n') {
801006da:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801006df:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801006e5:	75 c6                	jne    801006ad <conseraseline+0x6d>
}
801006e7:	83 c4 0c             	add    $0xc,%esp
801006ea:	5b                   	pop    %ebx
801006eb:	5e                   	pop    %esi
801006ec:	5f                   	pop    %edi
801006ed:	5d                   	pop    %ebp
801006ee:	c3                   	ret    
801006ef:	90                   	nop

801006f0 <loadcmd>:
loadcmd(void) {
801006f0:	55                   	push   %ebp
801006f1:	89 e5                	mov    %esp,%ebp
801006f3:	56                   	push   %esi
801006f4:	53                   	push   %ebx
    conseraseline();
801006f5:	e8 46 ff ff ff       	call   80100640 <conseraseline>
    int n = cmds.r - 1;
801006fa:	a1 c0 14 11 80       	mov    0x801114c0,%eax
801006ff:	83 e8 01             	sub    $0x1,%eax
80100702:	c1 e0 07             	shl    $0x7,%eax
80100705:	8d 98 c0 0f 11 80    	lea    -0x7feef040(%eax),%ebx
8010070b:	8d b0 40 10 11 80    	lea    -0x7feeefc0(%eax),%esi
        if (cmds.buf[n][i] == 0)
80100711:	0f be 03             	movsbl (%ebx),%eax
80100714:	84 c0                	test   %al,%al
80100716:	74 34                	je     8010074c <loadcmd+0x5c>
        input.buf[input.e++ % INPUT_BUF] = cmds.buf[n][i];
80100718:	8b 15 a8 0f 11 80    	mov    0x80110fa8,%edx
8010071e:	8d 4a 01             	lea    0x1(%edx),%ecx
80100721:	83 e2 7f             	and    $0x7f,%edx
80100724:	88 82 20 0f 11 80    	mov    %al,-0x7feef0e0(%edx)
    if (panicked) {
8010072a:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.buf[input.e++ % INPUT_BUF] = cmds.buf[n][i];
80100730:	89 0d a8 0f 11 80    	mov    %ecx,0x80110fa8
    if (panicked) {
80100736:	85 d2                	test   %edx,%edx
80100738:	74 06                	je     80100740 <loadcmd+0x50>
8010073a:	fa                   	cli    
        for (;;)
8010073b:	eb fe                	jmp    8010073b <loadcmd+0x4b>
8010073d:	8d 76 00             	lea    0x0(%esi),%esi
80100740:	e8 cb fc ff ff       	call   80100410 <consputc.part.0>
    for (int i = 0; i < INPUT_BUF; i++) {
80100745:	83 c3 01             	add    $0x1,%ebx
80100748:	39 f3                	cmp    %esi,%ebx
8010074a:	75 c5                	jne    80100711 <loadcmd+0x21>
}
8010074c:	5b                   	pop    %ebx
8010074d:	5e                   	pop    %esi
8010074e:	5d                   	pop    %ebp
8010074f:	c3                   	ret    

80100750 <consolewrite>:

int consolewrite(struct inode* ip, char* buf, int n) {
80100750:	f3 0f 1e fb          	endbr32 
80100754:	55                   	push   %ebp
80100755:	89 e5                	mov    %esp,%ebp
80100757:	57                   	push   %edi
80100758:	56                   	push   %esi
80100759:	53                   	push   %ebx
8010075a:	83 ec 18             	sub    $0x18,%esp
    int i;

    iunlock(ip);
8010075d:	ff 75 08             	pushl  0x8(%ebp)
int consolewrite(struct inode* ip, char* buf, int n) {
80100760:	8b 5d 10             	mov    0x10(%ebp),%ebx
    iunlock(ip);
80100763:	e8 78 1c 00 00       	call   801023e0 <iunlock>
    acquire(&cons.lock);
80100768:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010076f:	e8 1c 4a 00 00       	call   80105190 <acquire>
    for (i = 0; i < n; i++)
80100774:	83 c4 10             	add    $0x10,%esp
80100777:	85 db                	test   %ebx,%ebx
80100779:	7e 24                	jle    8010079f <consolewrite+0x4f>
8010077b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010077e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
    if (panicked) {
80100781:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100787:	85 d2                	test   %edx,%edx
80100789:	74 05                	je     80100790 <consolewrite+0x40>
8010078b:	fa                   	cli    
        for (;;)
8010078c:	eb fe                	jmp    8010078c <consolewrite+0x3c>
8010078e:	66 90                	xchg   %ax,%ax
        consputc(buf[i] & 0xff);
80100790:	0f b6 07             	movzbl (%edi),%eax
80100793:	83 c7 01             	add    $0x1,%edi
80100796:	e8 75 fc ff ff       	call   80100410 <consputc.part.0>
    for (i = 0; i < n; i++)
8010079b:	39 fe                	cmp    %edi,%esi
8010079d:	75 e2                	jne    80100781 <consolewrite+0x31>
    release(&cons.lock);
8010079f:	83 ec 0c             	sub    $0xc,%esp
801007a2:	68 20 b5 10 80       	push   $0x8010b520
801007a7:	e8 a4 4a 00 00       	call   80105250 <release>
    ilock(ip);
801007ac:	58                   	pop    %eax
801007ad:	ff 75 08             	pushl  0x8(%ebp)
801007b0:	e8 4b 1b 00 00       	call   80102300 <ilock>

    return n;
}
801007b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801007b8:	89 d8                	mov    %ebx,%eax
801007ba:	5b                   	pop    %ebx
801007bb:	5e                   	pop    %esi
801007bc:	5f                   	pop    %edi
801007bd:	5d                   	pop    %ebp
801007be:	c3                   	ret    
801007bf:	90                   	nop

801007c0 <cprintf>:
void cprintf(char* fmt, ...) {
801007c0:	f3 0f 1e fb          	endbr32 
801007c4:	55                   	push   %ebp
801007c5:	89 e5                	mov    %esp,%ebp
801007c7:	57                   	push   %edi
801007c8:	56                   	push   %esi
801007c9:	53                   	push   %ebx
801007ca:	83 ec 1c             	sub    $0x1c,%esp
    locking = cons.locking;
801007cd:	a1 54 b5 10 80       	mov    0x8010b554,%eax
801007d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (locking)
801007d5:	85 c0                	test   %eax,%eax
801007d7:	0f 85 e8 00 00 00    	jne    801008c5 <cprintf+0x105>
    if (fmt == 0)
801007dd:	8b 45 08             	mov    0x8(%ebp),%eax
801007e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007e3:	85 c0                	test   %eax,%eax
801007e5:	0f 84 5a 01 00 00    	je     80100945 <cprintf+0x185>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
801007eb:	0f b6 00             	movzbl (%eax),%eax
801007ee:	85 c0                	test   %eax,%eax
801007f0:	74 36                	je     80100828 <cprintf+0x68>
    argp = (uint*)(void*)(&fmt + 1);
801007f2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
801007f5:	31 f6                	xor    %esi,%esi
        if (c != '%') {
801007f7:	83 f8 25             	cmp    $0x25,%eax
801007fa:	74 44                	je     80100840 <cprintf+0x80>
    if (panicked) {
801007fc:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100802:	85 c9                	test   %ecx,%ecx
80100804:	74 0f                	je     80100815 <cprintf+0x55>
80100806:	fa                   	cli    
        for (;;)
80100807:	eb fe                	jmp    80100807 <cprintf+0x47>
80100809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100810:	b8 25 00 00 00       	mov    $0x25,%eax
80100815:	e8 f6 fb ff ff       	call   80100410 <consputc.part.0>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
8010081a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010081d:	83 c6 01             	add    $0x1,%esi
80100820:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100824:	85 c0                	test   %eax,%eax
80100826:	75 cf                	jne    801007f7 <cprintf+0x37>
    if (locking)
80100828:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010082b:	85 c0                	test   %eax,%eax
8010082d:	0f 85 fd 00 00 00    	jne    80100930 <cprintf+0x170>
}
80100833:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100836:	5b                   	pop    %ebx
80100837:	5e                   	pop    %esi
80100838:	5f                   	pop    %edi
80100839:	5d                   	pop    %ebp
8010083a:	c3                   	ret    
8010083b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010083f:	90                   	nop
        c = fmt[++i] & 0xff;
80100840:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100843:	83 c6 01             	add    $0x1,%esi
80100846:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
        if (c == 0)
8010084a:	85 ff                	test   %edi,%edi
8010084c:	74 da                	je     80100828 <cprintf+0x68>
        switch (c) {
8010084e:	83 ff 70             	cmp    $0x70,%edi
80100851:	74 5a                	je     801008ad <cprintf+0xed>
80100853:	7f 2a                	jg     8010087f <cprintf+0xbf>
80100855:	83 ff 25             	cmp    $0x25,%edi
80100858:	0f 84 92 00 00 00    	je     801008f0 <cprintf+0x130>
8010085e:	83 ff 64             	cmp    $0x64,%edi
80100861:	0f 85 a1 00 00 00    	jne    80100908 <cprintf+0x148>
            printint(*argp++, 10, 1);
80100867:	8b 03                	mov    (%ebx),%eax
80100869:	8d 7b 04             	lea    0x4(%ebx),%edi
8010086c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100871:	ba 0a 00 00 00       	mov    $0xa,%edx
80100876:	89 fb                	mov    %edi,%ebx
80100878:	e8 23 fd ff ff       	call   801005a0 <printint>
            break;
8010087d:	eb 9b                	jmp    8010081a <cprintf+0x5a>
        switch (c) {
8010087f:	83 ff 73             	cmp    $0x73,%edi
80100882:	75 24                	jne    801008a8 <cprintf+0xe8>
            if ((s = (char*)*argp++) == 0)
80100884:	8d 7b 04             	lea    0x4(%ebx),%edi
80100887:	8b 1b                	mov    (%ebx),%ebx
80100889:	85 db                	test   %ebx,%ebx
8010088b:	75 55                	jne    801008e2 <cprintf+0x122>
                s = "(null)";
8010088d:	bb 38 7e 10 80       	mov    $0x80107e38,%ebx
            for (; *s; s++)
80100892:	b8 28 00 00 00       	mov    $0x28,%eax
    if (panicked) {
80100897:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
8010089d:	85 d2                	test   %edx,%edx
8010089f:	74 39                	je     801008da <cprintf+0x11a>
801008a1:	fa                   	cli    
        for (;;)
801008a2:	eb fe                	jmp    801008a2 <cprintf+0xe2>
801008a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        switch (c) {
801008a8:	83 ff 78             	cmp    $0x78,%edi
801008ab:	75 5b                	jne    80100908 <cprintf+0x148>
            printint(*argp++, 16, 0);
801008ad:	8b 03                	mov    (%ebx),%eax
801008af:	8d 7b 04             	lea    0x4(%ebx),%edi
801008b2:	31 c9                	xor    %ecx,%ecx
801008b4:	ba 10 00 00 00       	mov    $0x10,%edx
801008b9:	89 fb                	mov    %edi,%ebx
801008bb:	e8 e0 fc ff ff       	call   801005a0 <printint>
            break;
801008c0:	e9 55 ff ff ff       	jmp    8010081a <cprintf+0x5a>
        acquire(&cons.lock);
801008c5:	83 ec 0c             	sub    $0xc,%esp
801008c8:	68 20 b5 10 80       	push   $0x8010b520
801008cd:	e8 be 48 00 00       	call   80105190 <acquire>
801008d2:	83 c4 10             	add    $0x10,%esp
801008d5:	e9 03 ff ff ff       	jmp    801007dd <cprintf+0x1d>
801008da:	e8 31 fb ff ff       	call   80100410 <consputc.part.0>
            for (; *s; s++)
801008df:	83 c3 01             	add    $0x1,%ebx
801008e2:	0f be 03             	movsbl (%ebx),%eax
801008e5:	84 c0                	test   %al,%al
801008e7:	75 ae                	jne    80100897 <cprintf+0xd7>
            if ((s = (char*)*argp++) == 0)
801008e9:	89 fb                	mov    %edi,%ebx
801008eb:	e9 2a ff ff ff       	jmp    8010081a <cprintf+0x5a>
    if (panicked) {
801008f0:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
801008f6:	85 ff                	test   %edi,%edi
801008f8:	0f 84 12 ff ff ff    	je     80100810 <cprintf+0x50>
801008fe:	fa                   	cli    
        for (;;)
801008ff:	eb fe                	jmp    801008ff <cprintf+0x13f>
80100901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (panicked) {
80100908:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
8010090e:	85 c9                	test   %ecx,%ecx
80100910:	74 06                	je     80100918 <cprintf+0x158>
80100912:	fa                   	cli    
        for (;;)
80100913:	eb fe                	jmp    80100913 <cprintf+0x153>
80100915:	8d 76 00             	lea    0x0(%esi),%esi
80100918:	b8 25 00 00 00       	mov    $0x25,%eax
8010091d:	e8 ee fa ff ff       	call   80100410 <consputc.part.0>
    if (panicked) {
80100922:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100928:	85 d2                	test   %edx,%edx
8010092a:	74 2c                	je     80100958 <cprintf+0x198>
8010092c:	fa                   	cli    
        for (;;)
8010092d:	eb fe                	jmp    8010092d <cprintf+0x16d>
8010092f:	90                   	nop
        release(&cons.lock);
80100930:	83 ec 0c             	sub    $0xc,%esp
80100933:	68 20 b5 10 80       	push   $0x8010b520
80100938:	e8 13 49 00 00       	call   80105250 <release>
8010093d:	83 c4 10             	add    $0x10,%esp
}
80100940:	e9 ee fe ff ff       	jmp    80100833 <cprintf+0x73>
        panic("null fmt");
80100945:	83 ec 0c             	sub    $0xc,%esp
80100948:	68 3f 7e 10 80       	push   $0x80107e3f
8010094d:	e8 3e fa ff ff       	call   80100390 <panic>
80100952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100958:	89 f8                	mov    %edi,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc.part.0>
8010095f:	e9 b6 fe ff ff       	jmp    8010081a <cprintf+0x5a>
80100964:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010096b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010096f:	90                   	nop

80100970 <consputs>:
void consputs(char* s) {
80100970:	f3 0f 1e fb          	endbr32 
80100974:	55                   	push   %ebp
80100975:	89 e5                	mov    %esp,%ebp
80100977:	56                   	push   %esi
80100978:	53                   	push   %ebx
80100979:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010097c:	8d b3 80 00 00 00    	lea    0x80(%ebx),%esi
    for (int i = 0; i < INPUT_BUF && (s[i]); ++i) {
80100982:	80 3b 00             	cmpb   $0x0,(%ebx)
80100985:	74 38                	je     801009bf <consputs+0x4f>
        input.buf[input.e++ % INPUT_BUF] = s[i];
80100987:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010098c:	8d 50 01             	lea    0x1(%eax),%edx
8010098f:	83 e0 7f             	and    $0x7f,%eax
80100992:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
80100998:	0f b6 13             	movzbl (%ebx),%edx
8010099b:	88 90 20 0f 11 80    	mov    %dl,-0x7feef0e0(%eax)
    if (panicked) {
801009a1:	a1 58 b5 10 80       	mov    0x8010b558,%eax
801009a6:	85 c0                	test   %eax,%eax
801009a8:	74 06                	je     801009b0 <consputs+0x40>
801009aa:	fa                   	cli    
        for (;;)
801009ab:	eb fe                	jmp    801009ab <consputs+0x3b>
801009ad:	8d 76 00             	lea    0x0(%esi),%esi
        consputc(s[i]);
801009b0:	0f be 03             	movsbl (%ebx),%eax
801009b3:	83 c3 01             	add    $0x1,%ebx
801009b6:	e8 55 fa ff ff       	call   80100410 <consputc.part.0>
    for (int i = 0; i < INPUT_BUF && (s[i]); ++i) {
801009bb:	39 f3                	cmp    %esi,%ebx
801009bd:	75 c3                	jne    80100982 <consputs+0x12>
}
801009bf:	5b                   	pop    %ebx
801009c0:	5e                   	pop    %esi
801009c1:	5d                   	pop    %ebp
801009c2:	c3                   	ret    
801009c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801009d0 <consoleintr>:
void consoleintr(int (*getc)(void)) {
801009d0:	f3 0f 1e fb          	endbr32 
801009d4:	55                   	push   %ebp
801009d5:	89 e5                	mov    %esp,%ebp
801009d7:	57                   	push   %edi
801009d8:	56                   	push   %esi
801009d9:	53                   	push   %ebx
801009da:	81 ec b8 00 00 00    	sub    $0xb8,%esp
    acquire(&cons.lock);
801009e0:	68 20 b5 10 80       	push   $0x8010b520
801009e5:	e8 a6 47 00 00       	call   80105190 <acquire>
    while ((c = getc()) >= 0) {
801009ea:	83 c4 10             	add    $0x10,%esp
    int c, doprocdump = 0;
801009ed:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
801009f4:	00 00 00 
801009f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009fe:	66 90                	xchg   %ax,%ax
    while ((c = getc()) >= 0) {
80100a00:	ff 55 08             	call   *0x8(%ebp)
80100a03:	89 c3                	mov    %eax,%ebx
80100a05:	85 c0                	test   %eax,%eax
80100a07:	78 2d                	js     80100a36 <consoleintr+0x66>
        switch (c) {
80100a09:	83 fb 15             	cmp    $0x15,%ebx
80100a0c:	7f 52                	jg     80100a60 <consoleintr+0x90>
80100a0e:	85 db                	test   %ebx,%ebx
80100a10:	74 ee                	je     80100a00 <consoleintr+0x30>
80100a12:	83 fb 15             	cmp    $0x15,%ebx
80100a15:	0f 87 43 05 00 00    	ja     80100f5e <consoleintr+0x58e>
80100a1b:	3e ff 24 9d 50 7e 10 	notrack jmp *-0x7fef81b0(,%ebx,4)
80100a22:	80 
80100a23:	c7 85 64 ff ff ff 01 	movl   $0x1,-0x9c(%ebp)
80100a2a:	00 00 00 
    while ((c = getc()) >= 0) {
80100a2d:	ff 55 08             	call   *0x8(%ebp)
80100a30:	89 c3                	mov    %eax,%ebx
80100a32:	85 c0                	test   %eax,%eax
80100a34:	79 d3                	jns    80100a09 <consoleintr+0x39>
    release(&cons.lock);
80100a36:	83 ec 0c             	sub    $0xc,%esp
80100a39:	68 20 b5 10 80       	push   $0x8010b520
80100a3e:	e8 0d 48 00 00       	call   80105250 <release>
    if (doprocdump) {
80100a43:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	85 c0                	test   %eax,%eax
80100a4e:	0f 85 cc 04 00 00    	jne    80100f20 <consoleintr+0x550>
}
80100a54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a57:	5b                   	pop    %ebx
80100a58:	5e                   	pop    %esi
80100a59:	5f                   	pop    %edi
80100a5a:	5d                   	pop    %ebp
80100a5b:	c3                   	ret    
80100a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        switch (c) {
80100a60:	81 fb e2 00 00 00    	cmp    $0xe2,%ebx
80100a66:	0f 84 c4 04 00 00    	je     80100f30 <consoleintr+0x560>
80100a6c:	81 fb e3 00 00 00    	cmp    $0xe3,%ebx
80100a72:	75 24                	jne    80100a98 <consoleintr+0xc8>
            cmds.r--;
80100a74:	a1 c0 14 11 80       	mov    0x801114c0,%eax
80100a79:	83 e8 01             	sub    $0x1,%eax
80100a7c:	a3 c0 14 11 80       	mov    %eax,0x801114c0
            if (cmds.r > 0)
80100a81:	85 c0                	test   %eax,%eax
80100a83:	0f 8e a7 06 00 00    	jle    80101130 <consoleintr+0x760>
                loadcmd();
80100a89:	e8 62 fc ff ff       	call   801006f0 <loadcmd>
80100a8e:	e9 6d ff ff ff       	jmp    80100a00 <consoleintr+0x30>
80100a93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a97:	90                   	nop
        switch (c) {
80100a98:	83 fb 7f             	cmp    $0x7f,%ebx
80100a9b:	0f 85 c5 04 00 00    	jne    80100f66 <consoleintr+0x596>
            if ((input.e - input.shift) > input.w) {
80100aa1:	8b 1d a8 0f 11 80    	mov    0x80110fa8,%ebx
80100aa7:	8b 0d ac 0f 11 80    	mov    0x80110fac,%ecx
80100aad:	89 d8                	mov    %ebx,%eax
80100aaf:	29 c8                	sub    %ecx,%eax
80100ab1:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100ab7:	0f 86 43 ff ff ff    	jbe    80100a00 <consoleintr+0x30>
    for (int i = input.shift + 1; i > 1; i--)
80100abd:	8d 51 01             	lea    0x1(%ecx),%edx
80100ac0:	89 ce                	mov    %ecx,%esi
80100ac2:	83 fa 01             	cmp    $0x1,%edx
80100ac5:	7e 2a                	jle    80100af1 <consoleintr+0x121>
80100ac7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ace:	66 90                	xchg   %ax,%ax
        input.buf[(input.e - i) % INPUT_BUF] = input.buf[(input.e - i + 1) % INPUT_BUF];
80100ad0:	89 c2                	mov    %eax,%edx
80100ad2:	83 e2 7f             	and    $0x7f,%edx
80100ad5:	0f b6 8a 20 0f 11 80 	movzbl -0x7feef0e0(%edx),%ecx
80100adc:	8d 50 ff             	lea    -0x1(%eax),%edx
80100adf:	83 c0 01             	add    $0x1,%eax
80100ae2:	83 e2 7f             	and    $0x7f,%edx
80100ae5:	88 8a 20 0f 11 80    	mov    %cl,-0x7feef0e0(%edx)
    for (int i = input.shift + 1; i > 1; i--)
80100aeb:	39 c3                	cmp    %eax,%ebx
80100aed:	75 e1                	jne    80100ad0 <consoleintr+0x100>
80100aef:	89 f1                	mov    %esi,%ecx
    input.e--;
80100af1:	83 eb 01             	sub    $0x1,%ebx
    asm volatile("out %0,%1"
80100af4:	b8 0e 00 00 00       	mov    $0xe,%eax
80100af9:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100afe:	89 1d a8 0f 11 80    	mov    %ebx,0x80110fa8
80100b04:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80100b05:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100b0a:	89 da                	mov    %ebx,%edx
80100b0c:	ec                   	in     (%dx),%al
    pos = inb(CRTPORT + 1) << 8;
80100b0d:	0f b6 c0             	movzbl %al,%eax
    asm volatile("out %0,%1"
80100b10:	be 0f 00 00 00       	mov    $0xf,%esi
80100b15:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100b1a:	89 c7                	mov    %eax,%edi
80100b1c:	89 f0                	mov    %esi,%eax
80100b1e:	c1 e7 08             	shl    $0x8,%edi
80100b21:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80100b22:	89 da                	mov    %ebx,%edx
80100b24:	ec                   	in     (%dx),%al
    pos |= inb(CRTPORT + 1);
80100b25:	0f b6 c0             	movzbl %al,%eax
    asm volatile("out %0,%1"
80100b28:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100b2d:	09 f8                	or     %edi,%eax
    setpos(getpos() + input.shift);
80100b2f:	01 c1                	add    %eax,%ecx
80100b31:	b8 0e 00 00 00       	mov    $0xe,%eax
80100b36:	ee                   	out    %al,(%dx)
    outb(CRTPORT + 1, pos >> 8);
80100b37:	89 c8                	mov    %ecx,%eax
80100b39:	89 da                	mov    %ebx,%edx
80100b3b:	c1 f8 08             	sar    $0x8,%eax
80100b3e:	ee                   	out    %al,(%dx)
80100b3f:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100b44:	89 f0                	mov    %esi,%eax
80100b46:	ee                   	out    %al,(%dx)
80100b47:	89 c8                	mov    %ecx,%eax
80100b49:	89 da                	mov    %ebx,%edx
80100b4b:	ee                   	out    %al,(%dx)
    for (int i = 0; i <= input.shift; i++)
80100b4c:	31 db                	xor    %ebx,%ebx
    if (panicked) {
80100b4e:	8b 35 58 b5 10 80    	mov    0x8010b558,%esi
80100b54:	85 f6                	test   %esi,%esi
80100b56:	0f 84 d4 06 00 00    	je     80101230 <consoleintr+0x860>
    asm volatile("cli");
80100b5c:	fa                   	cli    
        for (;;)
80100b5d:	eb fe                	jmp    80100b5d <consoleintr+0x18d>
            if (input.shift > 0) {
80100b5f:	a1 ac 0f 11 80       	mov    0x80110fac,%eax
80100b64:	85 c0                	test   %eax,%eax
80100b66:	0f 84 94 fe ff ff    	je     80100a00 <consoleintr+0x30>
                input.shift--;
80100b6c:	83 e8 01             	sub    $0x1,%eax
    asm volatile("out %0,%1"
80100b6f:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100b74:	a3 ac 0f 11 80       	mov    %eax,0x80110fac
80100b79:	b8 0e 00 00 00       	mov    $0xe,%eax
80100b7e:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80100b7f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100b84:	89 da                	mov    %ebx,%edx
80100b86:	ec                   	in     (%dx),%al
    pos = inb(CRTPORT + 1) << 8;
80100b87:	0f b6 c8             	movzbl %al,%ecx
    asm volatile("out %0,%1"
80100b8a:	be 0f 00 00 00       	mov    $0xf,%esi
80100b8f:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100b94:	89 cf                	mov    %ecx,%edi
80100b96:	89 f0                	mov    %esi,%eax
80100b98:	c1 e7 08             	shl    $0x8,%edi
80100b9b:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80100b9c:	89 da                	mov    %ebx,%edx
80100b9e:	ec                   	in     (%dx),%al
    pos |= inb(CRTPORT + 1);
80100b9f:	0f b6 c8             	movzbl %al,%ecx
80100ba2:	09 f9                	or     %edi,%ecx
    setpos(getpos() + 1);
80100ba4:	83 c1 01             	add    $0x1,%ecx
    asm volatile("out %0,%1"
80100ba7:	b8 0e 00 00 00       	mov    $0xe,%eax
80100bac:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100bb1:	ee                   	out    %al,(%dx)
    outb(CRTPORT + 1, pos >> 8);
80100bb2:	89 c8                	mov    %ecx,%eax
80100bb4:	89 da                	mov    %ebx,%edx
80100bb6:	c1 f8 08             	sar    $0x8,%eax
80100bb9:	ee                   	out    %al,(%dx)
80100bba:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100bbf:	89 f0                	mov    %esi,%eax
80100bc1:	ee                   	out    %al,(%dx)
80100bc2:	89 c8                	mov    %ecx,%eax
80100bc4:	89 da                	mov    %ebx,%edx
80100bc6:	ee                   	out    %al,(%dx)
}
80100bc7:	e9 34 fe ff ff       	jmp    80100a00 <consoleintr+0x30>
80100bcc:	b8 0e 00 00 00       	mov    $0xe,%eax
80100bd1:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100bd6:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80100bd7:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100bdc:	89 da                	mov    %ebx,%edx
80100bde:	ec                   	in     (%dx),%al
    pos = inb(CRTPORT + 1) << 8;
80100bdf:	0f b6 c8             	movzbl %al,%ecx
    asm volatile("out %0,%1"
80100be2:	be 0f 00 00 00       	mov    $0xf,%esi
80100be7:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100bec:	89 cf                	mov    %ecx,%edi
80100bee:	89 f0                	mov    %esi,%eax
80100bf0:	c1 e7 08             	shl    $0x8,%edi
80100bf3:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80100bf4:	89 da                	mov    %ebx,%edx
80100bf6:	ec                   	in     (%dx),%al
    pos |= inb(CRTPORT + 1);
80100bf7:	0f b6 c8             	movzbl %al,%ecx
    asm volatile("out %0,%1"
80100bfa:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100bff:	b8 0e 00 00 00       	mov    $0xe,%eax
80100c04:	09 f9                	or     %edi,%ecx
    setpos(getpos() + input.shift);
80100c06:	03 0d ac 0f 11 80    	add    0x80110fac,%ecx
80100c0c:	ee                   	out    %al,(%dx)
    outb(CRTPORT + 1, pos >> 8);
80100c0d:	89 c8                	mov    %ecx,%eax
80100c0f:	89 da                	mov    %ebx,%edx
80100c11:	c1 f8 08             	sar    $0x8,%eax
80100c14:	ee                   	out    %al,(%dx)
80100c15:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100c1a:	89 f0                	mov    %esi,%eax
80100c1c:	ee                   	out    %al,(%dx)
80100c1d:	89 c8                	mov    %ecx,%eax
80100c1f:	89 da                	mov    %ebx,%edx
80100c21:	ee                   	out    %al,(%dx)
            input.shift = 0;
80100c22:	c7 05 ac 0f 11 80 00 	movl   $0x0,0x80110fac
80100c29:	00 00 00 
            break;
80100c2c:	e9 cf fd ff ff       	jmp    80100a00 <consoleintr+0x30>
            if (input.shift < input.e - input.w) {
80100c31:	8b 15 ac 0f 11 80    	mov    0x80110fac,%edx
80100c37:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100c3c:	2b 05 a4 0f 11 80    	sub    0x80110fa4,%eax
80100c42:	39 c2                	cmp    %eax,%edx
80100c44:	0f 83 b6 fd ff ff    	jae    80100a00 <consoleintr+0x30>
                input.shift++;
80100c4a:	83 c2 01             	add    $0x1,%edx
80100c4d:	b8 0e 00 00 00       	mov    $0xe,%eax
80100c52:	89 15 ac 0f 11 80    	mov    %edx,0x80110fac
80100c58:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100c5d:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80100c5e:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100c63:	89 da                	mov    %ebx,%edx
80100c65:	ec                   	in     (%dx),%al
    pos = inb(CRTPORT + 1) << 8;
80100c66:	0f b6 c8             	movzbl %al,%ecx
    asm volatile("out %0,%1"
80100c69:	be 0f 00 00 00       	mov    $0xf,%esi
80100c6e:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100c73:	89 cf                	mov    %ecx,%edi
80100c75:	89 f0                	mov    %esi,%eax
80100c77:	c1 e7 08             	shl    $0x8,%edi
80100c7a:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80100c7b:	89 da                	mov    %ebx,%edx
80100c7d:	ec                   	in     (%dx),%al
    pos |= inb(CRTPORT + 1);
80100c7e:	0f b6 c8             	movzbl %al,%ecx
80100c81:	09 f9                	or     %edi,%ecx
    setpos(getpos() - 1);
80100c83:	83 e9 01             	sub    $0x1,%ecx
80100c86:	e9 1c ff ff ff       	jmp    80100ba7 <consoleintr+0x1d7>
            if (input.shift < input.e - input.w) {
80100c8b:	8b 1d a8 0f 11 80    	mov    0x80110fa8,%ebx
80100c91:	8b 0d a4 0f 11 80    	mov    0x80110fa4,%ecx
80100c97:	89 d8                	mov    %ebx,%eax
80100c99:	29 c8                	sub    %ecx,%eax
80100c9b:	39 05 ac 0f 11 80    	cmp    %eax,0x80110fac
80100ca1:	0f 83 59 fd ff ff    	jae    80100a00 <consoleintr+0x30>
    input.shift = input.e - input.w;
80100ca7:	a3 ac 0f 11 80       	mov    %eax,0x80110fac
    asm volatile("out %0,%1"
80100cac:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100cb1:	b8 0e 00 00 00       	mov    $0xe,%eax
80100cb6:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80100cb7:	be d5 03 00 00       	mov    $0x3d5,%esi
80100cbc:	89 f2                	mov    %esi,%edx
80100cbe:	ec                   	in     (%dx),%al
    pos = inb(CRTPORT + 1) << 8;
80100cbf:	0f b6 c0             	movzbl %al,%eax
    asm volatile("out %0,%1"
80100cc2:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100cc7:	89 c7                	mov    %eax,%edi
80100cc9:	c1 e7 08             	shl    $0x8,%edi
80100ccc:	89 bd 60 ff ff ff    	mov    %edi,-0xa0(%ebp)
80100cd2:	bf 0f 00 00 00       	mov    $0xf,%edi
80100cd7:	89 f8                	mov    %edi,%eax
80100cd9:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80100cda:	89 f2                	mov    %esi,%edx
80100cdc:	ec                   	in     (%dx),%al
    setpos(getpos() - input.shift);
80100cdd:	29 d9                	sub    %ebx,%ecx
    pos |= inb(CRTPORT + 1);
80100cdf:	0f b6 c0             	movzbl %al,%eax
80100ce2:	0b 85 60 ff ff ff    	or     -0xa0(%ebp),%eax
    asm volatile("out %0,%1"
80100ce8:	ba d4 03 00 00       	mov    $0x3d4,%edx
    setpos(getpos() - input.shift);
80100ced:	01 c1                	add    %eax,%ecx
80100cef:	b8 0e 00 00 00       	mov    $0xe,%eax
80100cf4:	ee                   	out    %al,(%dx)
    outb(CRTPORT + 1, pos >> 8);
80100cf5:	89 c8                	mov    %ecx,%eax
80100cf7:	89 f2                	mov    %esi,%edx
80100cf9:	c1 f8 08             	sar    $0x8,%eax
80100cfc:	ee                   	out    %al,(%dx)
80100cfd:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100d02:	89 f8                	mov    %edi,%eax
80100d04:	ee                   	out    %al,(%dx)
80100d05:	89 c8                	mov    %ecx,%eax
80100d07:	89 f2                	mov    %esi,%edx
80100d09:	ee                   	out    %al,(%dx)
                input.shift = input.e - input.w;
80100d0a:	e9 f1 fc ff ff       	jmp    80100a00 <consoleintr+0x30>
            conseraseline();
80100d0f:	e8 2c f9 ff ff       	call   80100640 <conseraseline>
            break;
80100d14:	e9 e7 fc ff ff       	jmp    80100a00 <consoleintr+0x30>
    for (int inputidx = 0; inputidx < input.e - input.w; inputidx++) {
80100d19:	8b 35 a8 0f 11 80    	mov    0x80110fa8,%esi
80100d1f:	a1 a4 0f 11 80       	mov    0x80110fa4,%eax
    int lineidx = 0;
80100d24:	31 c9                	xor    %ecx,%ecx
    for (int inputidx = 0; inputidx < input.e - input.w; inputidx++) {
80100d26:	39 c6                	cmp    %eax,%esi
80100d28:	74 2b                	je     80100d55 <consoleintr+0x385>
80100d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        int idx = (input.w + inputidx) % INPUT_BUF;
80100d30:	89 c2                	mov    %eax,%edx
80100d32:	83 e2 7f             	and    $0x7f,%edx
        if (input.buf[idx] >= '0' && input.buf[idx] <= '9')
80100d35:	0f b6 92 20 0f 11 80 	movzbl -0x7feef0e0(%edx),%edx
80100d3c:	8d 5a d0             	lea    -0x30(%edx),%ebx
80100d3f:	80 fb 09             	cmp    $0x9,%bl
80100d42:	76 0a                	jbe    80100d4e <consoleintr+0x37e>
        line[lineidx++] = input.buf[idx];
80100d44:	88 94 0d 68 ff ff ff 	mov    %dl,-0x98(%ebp,%ecx,1)
80100d4b:	83 c1 01             	add    $0x1,%ecx
    for (int inputidx = 0; inputidx < input.e - input.w; inputidx++) {
80100d4e:	83 c0 01             	add    $0x1,%eax
80100d51:	39 c6                	cmp    %eax,%esi
80100d53:	75 db                	jne    80100d30 <consoleintr+0x360>
    line[lineidx] = 0;
80100d55:	c6 84 0d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ecx,1)
80100d5c:	00 
    conseraseline();
80100d5d:	e8 de f8 ff ff       	call   80100640 <conseraseline>
    consputs(line);
80100d62:	83 ec 0c             	sub    $0xc,%esp
80100d65:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80100d6b:	50                   	push   %eax
80100d6c:	e8 ff fb ff ff       	call   80100970 <consputs>
}
80100d71:	83 c4 10             	add    $0x10,%esp
80100d74:	e9 87 fc ff ff       	jmp    80100a00 <consoleintr+0x30>
            conseraseline();
80100d79:	e8 c2 f8 ff ff       	call   80100640 <conseraseline>
80100d7e:	b8 0e 00 00 00       	mov    $0xe,%eax
80100d83:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100d88:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80100d89:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100d8e:	89 ca                	mov    %ecx,%edx
80100d90:	ec                   	in     (%dx),%al
    pos = inb(CRTPORT + 1) << 8;
80100d91:	0f b6 c0             	movzbl %al,%eax
    asm volatile("out %0,%1"
80100d94:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100d99:	c1 e0 08             	shl    $0x8,%eax
80100d9c:	89 c3                	mov    %eax,%ebx
80100d9e:	b8 0f 00 00 00       	mov    $0xf,%eax
80100da3:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80100da4:	89 ca                	mov    %ecx,%edx
80100da6:	ec                   	in     (%dx),%al
    pos |= inb(CRTPORT + 1);
80100da7:	0f b6 c0             	movzbl %al,%eax
80100daa:	09 d8                	or     %ebx,%eax
80100dac:	8d 84 00 00 80 0b 80 	lea    -0x7ff48000(%eax,%eax,1),%eax
80100db3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100db7:	90                   	nop
    crt[pos] = ' ' | 0x0700;
80100db8:	ba 20 07 00 00       	mov    $0x720,%edx
80100dbd:	83 e8 02             	sub    $0x2,%eax
80100dc0:	66 89 50 02          	mov    %dx,0x2(%eax)
    while (pos >= 0)
80100dc4:	3d fe 7f 0b 80       	cmp    $0x800b7ffe,%eax
80100dc9:	75 ed                	jne    80100db8 <consoleintr+0x3e8>
    crt[pos] = (c & 0xff) | 0x0700;
80100dcb:	b8 24 07 00 00       	mov    $0x724,%eax
    asm volatile("out %0,%1"
80100dd0:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100dd5:	66 a3 00 80 0b 80    	mov    %ax,0x800b8000
80100ddb:	b8 0e 00 00 00       	mov    $0xe,%eax
80100de0:	ee                   	out    %al,(%dx)
80100de1:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100de6:	31 c0                	xor    %eax,%eax
80100de8:	89 ca                	mov    %ecx,%edx
80100dea:	ee                   	out    %al,(%dx)
80100deb:	b8 0f 00 00 00       	mov    $0xf,%eax
80100df0:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100df5:	ee                   	out    %al,(%dx)
80100df6:	b8 02 00 00 00       	mov    $0x2,%eax
80100dfb:	89 ca                	mov    %ecx,%edx
80100dfd:	ee                   	out    %al,(%dx)
}
80100dfe:	e9 fd fb ff ff       	jmp    80100a00 <consoleintr+0x30>
    if (!cmds.intab) {
80100e03:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100e08:	8b 35 c4 14 11 80    	mov    0x801114c4,%esi
80100e0e:	8b 0d a4 0f 11 80    	mov    0x80110fa4,%ecx
80100e14:	8b 3d c8 14 11 80    	mov    0x801114c8,%edi
80100e1a:	89 c2                	mov    %eax,%edx
80100e1c:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
80100e22:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
80100e28:	29 ca                	sub    %ecx,%edx
80100e2a:	85 ff                	test   %edi,%edi
80100e2c:	0f 85 56 02 00 00    	jne    80101088 <consoleintr+0x6b8>
        cmds.lastusedidx = 0;
80100e32:	c7 05 4c 15 11 80 00 	movl   $0x0,0x8011154c
80100e39:	00 00 00 
    for (int i = lastusedidx; i < cmds.w; i++) {
80100e3c:	85 f6                	test   %esi,%esi
80100e3e:	0f 8e b4 05 00 00    	jle    801013f8 <consoleintr+0xa28>
80100e44:	31 db                	xor    %ebx,%ebx
80100e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e4d:	8d 76 00             	lea    0x0(%esi),%esi
        if (ispred(cmds.buf[i], cmd, cmd_size))
80100e50:	89 de                	mov    %ebx,%esi
80100e52:	c1 e6 07             	shl    $0x7,%esi
80100e55:	81 c6 c0 0f 11 80    	add    $0x80110fc0,%esi
    for (int i = 0; i < input_size; i++)
80100e5b:	85 d2                	test   %edx,%edx
80100e5d:	7e 41                	jle    80100ea0 <consoleintr+0x4d0>
80100e5f:	89 9d 60 ff ff ff    	mov    %ebx,-0xa0(%ebp)
80100e65:	31 c0                	xor    %eax,%eax
80100e67:	eb 12                	jmp    80100e7b <consoleintr+0x4ab>
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e70:	83 c0 01             	add    $0x1,%eax
80100e73:	39 d0                	cmp    %edx,%eax
80100e75:	0f 84 2d 03 00 00    	je     801011a8 <consoleintr+0x7d8>
        if (cmd[i] != input[i])
80100e7b:	0f b6 9c 08 20 0f 11 	movzbl -0x7feef0e0(%eax,%ecx,1),%ebx
80100e82:	80 
80100e83:	38 1c 06             	cmp    %bl,(%esi,%eax,1)
80100e86:	74 e8                	je     80100e70 <consoleintr+0x4a0>
80100e88:	8b 9d 60 ff ff ff    	mov    -0xa0(%ebp),%ebx
    for (int i = lastusedidx; i < cmds.w; i++) {
80100e8e:	83 c3 01             	add    $0x1,%ebx
80100e91:	3b 9d 5c ff ff ff    	cmp    -0xa4(%ebp),%ebx
80100e97:	75 b7                	jne    80100e50 <consoleintr+0x480>
    return -1;
80100e99:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80100e9e:	66 90                	xchg   %ax,%ax
    for(int i = input.w; i < input.e; i++) {
80100ea0:	3b 8d 58 ff ff ff    	cmp    -0xa8(%ebp),%ecx
80100ea6:	73 58                	jae    80100f00 <consoleintr+0x530>
    return -1;
80100ea8:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
80100eae:	8b b5 58 ff ff ff    	mov    -0xa8(%ebp),%esi
80100eb4:	89 c8                	mov    %ecx,%eax
80100eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ebd:	8d 76 00             	lea    0x0(%esi),%esi
        cmds.tmpcmd[j] = input.buf[i];
80100ec0:	0f b6 90 20 0f 11 80 	movzbl -0x7feef0e0(%eax),%edx
    for(int i = input.w; i < input.e; i++) {
80100ec7:	83 c0 01             	add    $0x1,%eax
        j++;
80100eca:	83 c7 01             	add    $0x1,%edi
        cmds.tmpcmd[j] = input.buf[i];
80100ecd:	88 97 cb 14 11 80    	mov    %dl,-0x7feeeb35(%edi)
    for(int i = input.w; i < input.e; i++) {
80100ed3:	39 f0                	cmp    %esi,%eax
80100ed5:	72 e9                	jb     80100ec0 <consoleintr+0x4f0>
80100ed7:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
80100edd:	83 c1 01             	add    $0x1,%ecx
80100ee0:	bf 01 00 00 00       	mov    $0x1,%edi
80100ee5:	3b 8d 58 ff ff ff    	cmp    -0xa8(%ebp),%ecx
80100eeb:	0f 46 fa             	cmovbe %edx,%edi
    for(; j < INPUT_BUF; j++) {
80100eee:	83 ff 7f             	cmp    $0x7f,%edi
80100ef1:	0f 8f ff 01 00 00    	jg     801010f6 <consoleintr+0x726>
80100ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100efe:	66 90                	xchg   %ax,%ax
        cmds.tmpcmd[j] = 0;
80100f00:	c6 87 cc 14 11 80 00 	movb   $0x0,-0x7feeeb34(%edi)
    for(; j < INPUT_BUF; j++) {
80100f07:	83 c7 01             	add    $0x1,%edi
80100f0a:	81 ff 80 00 00 00    	cmp    $0x80,%edi
80100f10:	75 ee                	jne    80100f00 <consoleintr+0x530>
80100f12:	e9 df 01 00 00       	jmp    801010f6 <consoleintr+0x726>
80100f17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f1e:	66 90                	xchg   %ax,%ax
        procdump(); // now call procdump() wo. cons.lock held
80100f20:	e8 5b 3e 00 00       	call   80104d80 <procdump>
}
80100f25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f28:	5b                   	pop    %ebx
80100f29:	5e                   	pop    %esi
80100f2a:	5f                   	pop    %edi
80100f2b:	5d                   	pop    %ebp
80100f2c:	c3                   	ret    
80100f2d:	8d 76 00             	lea    0x0(%esi),%esi
            if (cmds.r == 0)
80100f30:	8b 15 c0 14 11 80    	mov    0x801114c0,%edx
80100f36:	85 d2                	test   %edx,%edx
80100f38:	0f 84 9a 02 00 00    	je     801011d8 <consoleintr+0x808>
            if (cmds.r > cmds.w)
80100f3e:	a1 c4 14 11 80       	mov    0x801114c4,%eax
            cmds.r++;
80100f43:	83 c2 01             	add    $0x1,%edx
80100f46:	89 15 c0 14 11 80    	mov    %edx,0x801114c0
            if (cmds.r > cmds.w)
80100f4c:	39 c2                	cmp    %eax,%edx
80100f4e:	0f 8e 35 fb ff ff    	jle    80100a89 <consoleintr+0xb9>
                cmds.r = cmds.w;
80100f54:	a3 c0 14 11 80       	mov    %eax,0x801114c0
80100f59:	e9 a2 fa ff ff       	jmp    80100a00 <consoleintr+0x30>
            if (c != 0 && input.e - input.r < INPUT_BUF) {
80100f5e:	85 db                	test   %ebx,%ebx
80100f60:	0f 84 9a fa ff ff    	je     80100a00 <consoleintr+0x30>
80100f66:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100f6b:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
80100f71:	2b 05 a0 0f 11 80    	sub    0x80110fa0,%eax
80100f77:	83 f8 7f             	cmp    $0x7f,%eax
80100f7a:	0f 87 80 fa ff ff    	ja     80100a00 <consoleintr+0x30>
                if (c == '\n' && input.e - input.w > 0) {
80100f80:	83 fb 0d             	cmp    $0xd,%ebx
80100f83:	0f 84 ef 01 00 00    	je     80101178 <consoleintr+0x7a8>
80100f89:	89 df                	mov    %ebx,%edi
80100f8b:	0f be d3             	movsbl %bl,%edx
80100f8e:	83 fb 0a             	cmp    $0xa,%ebx
80100f91:	0f 84 e1 01 00 00    	je     80101178 <consoleintr+0x7a8>
    if (input.shift == 0) {
80100f97:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
80100f9d:	8b 0d ac 0f 11 80    	mov    0x80110fac,%ecx
80100fa3:	83 e8 01             	sub    $0x1,%eax
80100fa6:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
80100fac:	89 c6                	mov    %eax,%esi
80100fae:	29 ce                	sub    %ecx,%esi
80100fb0:	85 c9                	test   %ecx,%ecx
80100fb2:	0f 84 38 03 00 00    	je     801012f0 <consoleintr+0x920>
80100fb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fbf:	90                   	nop
        input.buf[(input.e - i) % INPUT_BUF] = input.buf[(input.e - i - 1) % INPUT_BUF];
80100fc0:	89 c2                	mov    %eax,%edx
80100fc2:	83 e2 7f             	and    $0x7f,%edx
80100fc5:	0f b6 8a 20 0f 11 80 	movzbl -0x7feef0e0(%edx),%ecx
80100fcc:	8d 50 01             	lea    0x1(%eax),%edx
80100fcf:	83 e8 01             	sub    $0x1,%eax
80100fd2:	83 e2 7f             	and    $0x7f,%edx
80100fd5:	88 8a 20 0f 11 80    	mov    %cl,-0x7feef0e0(%edx)
    for (int i = 0; i < input.shift; i++)
80100fdb:	39 c6                	cmp    %eax,%esi
80100fdd:	75 e1                	jne    80100fc0 <consoleintr+0x5f0>
        input.buf[(input.e - input.shift) % INPUT_BUF] = c;
80100fdf:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
80100fe5:	2b 85 60 ff ff ff    	sub    -0xa0(%ebp),%eax
80100feb:	89 f9                	mov    %edi,%ecx
80100fed:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100ff2:	83 e0 7f             	and    $0x7f,%eax
80100ff5:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
80100ffb:	b8 0e 00 00 00       	mov    $0xe,%eax
80101000:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80101001:	be d5 03 00 00       	mov    $0x3d5,%esi
80101006:	89 f2                	mov    %esi,%edx
80101008:	ec                   	in     (%dx),%al
    asm volatile("out %0,%1"
80101009:	bf 0f 00 00 00       	mov    $0xf,%edi
    pos = inb(CRTPORT + 1) << 8;
8010100e:	0f b6 c8             	movzbl %al,%ecx
80101011:	ba d4 03 00 00       	mov    $0x3d4,%edx
80101016:	c1 e1 08             	shl    $0x8,%ecx
80101019:	89 f8                	mov    %edi,%eax
8010101b:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
8010101c:	89 f2                	mov    %esi,%edx
8010101e:	ec                   	in     (%dx),%al
    pos |= inb(CRTPORT + 1);
8010101f:	0f b6 c0             	movzbl %al,%eax
    asm volatile("out %0,%1"
80101022:	ba d4 03 00 00       	mov    $0x3d4,%edx
80101027:	09 c1                	or     %eax,%ecx
80101029:	b8 0e 00 00 00       	mov    $0xe,%eax
    setpos(getpos() + input.shift);
8010102e:	03 8d 60 ff ff ff    	add    -0xa0(%ebp),%ecx
80101034:	ee                   	out    %al,(%dx)
    outb(CRTPORT + 1, pos >> 8);
80101035:	89 c8                	mov    %ecx,%eax
80101037:	89 f2                	mov    %esi,%edx
80101039:	c1 f8 08             	sar    $0x8,%eax
8010103c:	ee                   	out    %al,(%dx)
8010103d:	ba d4 03 00 00       	mov    $0x3d4,%edx
80101042:	89 f8                	mov    %edi,%eax
80101044:	ee                   	out    %al,(%dx)
80101045:	89 c8                	mov    %ecx,%eax
80101047:	89 f2                	mov    %esi,%edx
80101049:	ee                   	out    %al,(%dx)
    for (int i = 0; i < input.shift; i++)
8010104a:	31 f6                	xor    %esi,%esi
    if (panicked) {
8010104c:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80101052:	85 c9                	test   %ecx,%ecx
80101054:	0f 85 01 03 00 00    	jne    8010135b <consoleintr+0x98b>
8010105a:	b8 00 01 00 00       	mov    $0x100,%eax
    for (int i = 0; i < input.shift; i++)
8010105f:	83 c6 01             	add    $0x1,%esi
80101062:	e8 a9 f3 ff ff       	call   80100410 <consputc.part.0>
80101067:	a1 ac 0f 11 80       	mov    0x80110fac,%eax
8010106c:	39 c6                	cmp    %eax,%esi
8010106e:	72 dc                	jb     8010104c <consoleintr+0x67c>
    for (int i = input.shift; i >= 0; i--)
80101070:	89 c6                	mov    %eax,%esi
    if (panicked) {
80101072:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80101078:	85 d2                	test   %edx,%edx
8010107a:	0f 84 24 04 00 00    	je     801014a4 <consoleintr+0xad4>
    asm volatile("cli");
80101080:	fa                   	cli    
        for (;;)
80101081:	eb fe                	jmp    80101081 <consoleintr+0x6b1>
80101083:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101087:	90                   	nop
        predicted_cmd = getpred(input.buf + input.w, input.e - input.w, cmds.lastusedidx + 1);
80101088:	a1 4c 15 11 80       	mov    0x8011154c,%eax
    for (int i = lastusedidx; i < cmds.w; i++) {
8010108d:	8b bd 5c ff ff ff    	mov    -0xa4(%ebp),%edi
        predicted_cmd = getpred(input.buf + input.w, input.e - input.w, cmds.lastusedidx + 1);
80101093:	8d 58 01             	lea    0x1(%eax),%ebx
    for (int i = lastusedidx; i < cmds.w; i++) {
80101096:	39 fb                	cmp    %edi,%ebx
80101098:	0f 8d 62 f9 ff ff    	jge    80100a00 <consoleintr+0x30>
8010109e:	66 90                	xchg   %ax,%ax
        if (ispred(cmds.buf[i], cmd, cmd_size))
801010a0:	89 de                	mov    %ebx,%esi
801010a2:	c1 e6 07             	shl    $0x7,%esi
801010a5:	81 c6 c0 0f 11 80    	add    $0x80110fc0,%esi
    for (int i = 0; i < input_size; i++)
801010ab:	85 d2                	test   %edx,%edx
801010ad:	7e 47                	jle    801010f6 <consoleintr+0x726>
801010af:	89 9d 60 ff ff ff    	mov    %ebx,-0xa0(%ebp)
801010b5:	31 c0                	xor    %eax,%eax
801010b7:	eb 0e                	jmp    801010c7 <consoleintr+0x6f7>
801010b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010c0:	83 c0 01             	add    $0x1,%eax
801010c3:	39 d0                	cmp    %edx,%eax
801010c5:	74 29                	je     801010f0 <consoleintr+0x720>
        if (cmd[i] != input[i])
801010c7:	0f b6 9c 08 20 0f 11 	movzbl -0x7feef0e0(%eax,%ecx,1),%ebx
801010ce:	80 
801010cf:	38 1c 06             	cmp    %bl,(%esi,%eax,1)
801010d2:	74 ec                	je     801010c0 <consoleintr+0x6f0>
801010d4:	8b 9d 60 ff ff ff    	mov    -0xa0(%ebp),%ebx
    for (int i = lastusedidx; i < cmds.w; i++) {
801010da:	83 c3 01             	add    $0x1,%ebx
801010dd:	39 fb                	cmp    %edi,%ebx
801010df:	75 bf                	jne    801010a0 <consoleintr+0x6d0>
801010e1:	e9 1a f9 ff ff       	jmp    80100a00 <consoleintr+0x30>
801010e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ed:	8d 76 00             	lea    0x0(%esi),%esi
801010f0:	8b 9d 60 ff ff ff    	mov    -0xa0(%ebp),%ebx
    if (predicted_cmd >= 0) {
801010f6:	85 db                	test   %ebx,%ebx
801010f8:	0f 88 02 f9 ff ff    	js     80100a00 <consoleintr+0x30>
        cmds.lastusedidx = predicted_cmd;
801010fe:	89 1d 4c 15 11 80    	mov    %ebx,0x8011154c
        consputs(cmds.buf[predicted_cmd]);
80101104:	c1 e3 07             	shl    $0x7,%ebx
        cmds.intab = 1;
80101107:	c7 05 c8 14 11 80 01 	movl   $0x1,0x801114c8
8010110e:	00 00 00 
        consputs(cmds.buf[predicted_cmd]);
80101111:	81 c3 c0 0f 11 80    	add    $0x80110fc0,%ebx
        conseraseline();
80101117:	e8 24 f5 ff ff       	call   80100640 <conseraseline>
        consputs(cmds.buf[predicted_cmd]);
8010111c:	83 ec 0c             	sub    $0xc,%esp
8010111f:	53                   	push   %ebx
80101120:	e8 4b f8 ff ff       	call   80100970 <consputs>
80101125:	83 c4 10             	add    $0x10,%esp
80101128:	e9 d3 f8 ff ff       	jmp    80100a00 <consoleintr+0x30>
8010112d:	8d 76 00             	lea    0x0(%esi),%esi
                cmds.r = 0;
80101130:	c7 05 c0 14 11 80 00 	movl   $0x0,0x801114c0
80101137:	00 00 00 
    for (int i = 0; i < INPUT_BUF; i++) {
8010113a:	31 db                	xor    %ebx,%ebx
    conseraseline();
8010113c:	e8 ff f4 ff ff       	call   80100640 <conseraseline>
        if(cmds.tmpcmd[i] == 0)
80101141:	0f b6 93 cc 14 11 80 	movzbl -0x7feeeb34(%ebx),%edx
80101148:	84 d2                	test   %dl,%dl
8010114a:	0f 84 b0 f8 ff ff    	je     80100a00 <consoleintr+0x30>
        input.buf[input.e++ % INPUT_BUF] = cmds.tmpcmd[i];
80101150:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
    if (panicked) {
80101155:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
        input.buf[input.e++ % INPUT_BUF] = cmds.tmpcmd[i];
8010115b:	8d 48 01             	lea    0x1(%eax),%ecx
8010115e:	83 e0 7f             	and    $0x7f,%eax
80101161:	89 0d a8 0f 11 80    	mov    %ecx,0x80110fa8
80101167:	88 90 20 0f 11 80    	mov    %dl,-0x7feef0e0(%eax)
    if (panicked) {
8010116d:	85 ff                	test   %edi,%edi
8010116f:	74 47                	je     801011b8 <consoleintr+0x7e8>
80101171:	fa                   	cli    
        for (;;)
80101172:	eb fe                	jmp    80101172 <consoleintr+0x7a2>
80101174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                if (c == '\n' && input.e - input.w > 0) {
80101178:	a1 a4 0f 11 80       	mov    0x80110fa4,%eax
8010117d:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
80101183:	39 85 58 ff ff ff    	cmp    %eax,-0xa8(%ebp)
80101189:	0f 85 d1 01 00 00    	jne    80101360 <consoleintr+0x990>
8010118f:	ba 0a 00 00 00       	mov    $0xa,%edx
80101194:	bf 0a 00 00 00       	mov    $0xa,%edi
80101199:	bb 0a 00 00 00       	mov    $0xa,%ebx
8010119e:	e9 f4 fd ff ff       	jmp    80100f97 <consoleintr+0x5c7>
801011a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011a7:	90                   	nop
801011a8:	8b 9d 60 ff ff ff    	mov    -0xa0(%ebp),%ebx
801011ae:	e9 ed fc ff ff       	jmp    80100ea0 <consoleintr+0x4d0>
801011b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011b7:	90                   	nop
        consputc(cmds.tmpcmd[i]);
801011b8:	0f be c2             	movsbl %dl,%eax
    for (int i = 0; i < INPUT_BUF; i++) {
801011bb:	83 c3 01             	add    $0x1,%ebx
801011be:	e8 4d f2 ff ff       	call   80100410 <consputc.part.0>
801011c3:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801011c9:	0f 85 72 ff ff ff    	jne    80101141 <consoleintr+0x771>
801011cf:	e9 2c f8 ff ff       	jmp    80100a00 <consoleintr+0x30>
801011d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(int i = input.w; i < input.e; i++) {
801011d8:	8b 35 a4 0f 11 80    	mov    0x80110fa4,%esi
801011de:	8b 1d a8 0f 11 80    	mov    0x80110fa8,%ebx
801011e4:	39 de                	cmp    %ebx,%esi
801011e6:	73 1f                	jae    80101207 <consoleintr+0x837>
801011e8:	29 f3                	sub    %esi,%ebx
    int j = 0;
801011ea:	31 c0                	xor    %eax,%eax
801011ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cmds.tmpcmd[j] = input.buf[i];
801011f0:	0f b6 8c 06 20 0f 11 	movzbl -0x7feef0e0(%esi,%eax,1),%ecx
801011f7:	80 
        j++;
801011f8:	83 c0 01             	add    $0x1,%eax
        cmds.tmpcmd[j] = input.buf[i];
801011fb:	88 88 cb 14 11 80    	mov    %cl,-0x7feeeb35(%eax)
    for(int i = input.w; i < input.e; i++) {
80101201:	39 d8                	cmp    %ebx,%eax
80101203:	75 eb                	jne    801011f0 <consoleintr+0x820>
80101205:	eb 13                	jmp    8010121a <consoleintr+0x84a>
    int j = 0;
80101207:	31 c0                	xor    %eax,%eax
80101209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cmds.tmpcmd[j] = 0;
80101210:	c6 80 cc 14 11 80 00 	movb   $0x0,-0x7feeeb34(%eax)
    for(; j < INPUT_BUF; j++) {
80101217:	83 c0 01             	add    $0x1,%eax
8010121a:	3d 80 00 00 00       	cmp    $0x80,%eax
8010121f:	75 ef                	jne    80101210 <consoleintr+0x840>
80101221:	e9 18 fd ff ff       	jmp    80100f3e <consoleintr+0x56e>
80101226:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010122d:	8d 76 00             	lea    0x0(%esi),%esi
80101230:	b8 00 01 00 00       	mov    $0x100,%eax
    for (int i = 0; i <= input.shift; i++)
80101235:	83 c3 01             	add    $0x1,%ebx
80101238:	e8 d3 f1 ff ff       	call   80100410 <consputc.part.0>
8010123d:	a1 ac 0f 11 80       	mov    0x80110fac,%eax
80101242:	39 c3                	cmp    %eax,%ebx
80101244:	0f 86 04 f9 ff ff    	jbe    80100b4e <consoleintr+0x17e>
    for (int i = input.shift; i > 0; i--)
8010124a:	89 c3                	mov    %eax,%ebx
8010124c:	85 c0                	test   %eax,%eax
8010124e:	0f 84 15 02 00 00    	je     80101469 <consoleintr+0xa99>
    if (panicked) {
80101254:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
8010125a:	85 c9                	test   %ecx,%ecx
8010125c:	0f 84 e8 01 00 00    	je     8010144a <consoleintr+0xa7a>
80101262:	fa                   	cli    
        for (;;)
80101263:	eb fe                	jmp    80101263 <consoleintr+0x893>
80101265:	8d 76 00             	lea    0x0(%esi),%esi
        cmds.buf[0][j] = 0;
80101268:	c6 80 c0 0f 11 80 00 	movb   $0x0,-0x7feef040(%eax)
    for (; j < INPUT_BUF; j++) {
8010126f:	83 c0 01             	add    $0x1,%eax
80101272:	3d 80 00 00 00       	cmp    $0x80,%eax
80101277:	75 ef                	jne    80101268 <consoleintr+0x898>
    cmds.r = 0;
80101279:	c7 05 c0 14 11 80 00 	movl   $0x0,0x801114c0
80101280:	00 00 00 
    asm volatile("out %0,%1"
80101283:	b8 0e 00 00 00       	mov    $0xe,%eax
80101288:	ba d4 03 00 00       	mov    $0x3d4,%edx
8010128d:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
8010128e:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80101293:	89 da                	mov    %ebx,%edx
80101295:	ec                   	in     (%dx),%al
    asm volatile("out %0,%1"
80101296:	be 0f 00 00 00       	mov    $0xf,%esi
    pos = inb(CRTPORT + 1) << 8;
8010129b:	0f b6 c8             	movzbl %al,%ecx
8010129e:	ba d4 03 00 00       	mov    $0x3d4,%edx
801012a3:	c1 e1 08             	shl    $0x8,%ecx
801012a6:	89 f0                	mov    %esi,%eax
801012a8:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
801012a9:	89 da                	mov    %ebx,%edx
801012ab:	ec                   	in     (%dx),%al
    pos |= inb(CRTPORT + 1);
801012ac:	0f b6 c0             	movzbl %al,%eax
    asm volatile("out %0,%1"
801012af:	ba d4 03 00 00       	mov    $0x3d4,%edx
801012b4:	09 c1                	or     %eax,%ecx
801012b6:	b8 0e 00 00 00       	mov    $0xe,%eax
    setpos(getpos() + input.shift);
801012bb:	03 0d ac 0f 11 80    	add    0x80110fac,%ecx
801012c1:	ee                   	out    %al,(%dx)
    outb(CRTPORT + 1, pos >> 8);
801012c2:	89 c8                	mov    %ecx,%eax
801012c4:	89 da                	mov    %ebx,%edx
801012c6:	c1 f8 08             	sar    $0x8,%eax
801012c9:	ee                   	out    %al,(%dx)
801012ca:	ba d4 03 00 00       	mov    $0x3d4,%edx
801012cf:	89 f0                	mov    %esi,%eax
801012d1:	ee                   	out    %al,(%dx)
801012d2:	89 c8                	mov    %ecx,%eax
801012d4:	89 da                	mov    %ebx,%edx
801012d6:	ee                   	out    %al,(%dx)
                    input.shift = 0;
801012d7:	bb 0a 00 00 00       	mov    $0xa,%ebx
                inputputc(c);
801012dc:	ba 0a 00 00 00       	mov    $0xa,%edx
801012e1:	bf 0a 00 00 00       	mov    $0xa,%edi
                    input.shift = 0;
801012e6:	c7 05 ac 0f 11 80 00 	movl   $0x0,0x80110fac
801012ed:	00 00 00 
        input.buf[input.e % INPUT_BUF] = c;
801012f0:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
    if (panicked) {
801012f6:	8b 35 58 b5 10 80    	mov    0x8010b558,%esi
        input.buf[input.e % INPUT_BUF] = c;
801012fc:	89 f9                	mov    %edi,%ecx
801012fe:	83 e0 7f             	and    $0x7f,%eax
80101301:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
    if (panicked) {
80101307:	85 f6                	test   %esi,%esi
80101309:	0f 85 e2 00 00 00    	jne    801013f1 <consoleintr+0xa21>
8010130f:	89 d0                	mov    %edx,%eax
80101311:	e8 fa f0 ff ff       	call   80100410 <consputc.part.0>
    input.e++;
80101316:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010131b:	83 c0 01             	add    $0x1,%eax
8010131e:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
                if (c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF) {
80101323:	83 fb 0a             	cmp    $0xa,%ebx
80101326:	74 19                	je     80101341 <consoleintr+0x971>
80101328:	83 fb 04             	cmp    $0x4,%ebx
8010132b:	74 14                	je     80101341 <consoleintr+0x971>
8010132d:	8b 3d a0 0f 11 80    	mov    0x80110fa0,%edi
80101333:	8d 97 80 00 00 00    	lea    0x80(%edi),%edx
80101339:	39 c2                	cmp    %eax,%edx
8010133b:	0f 85 bf f6 ff ff    	jne    80100a00 <consoleintr+0x30>
                    wakeup(&input.r);
80101341:	83 ec 0c             	sub    $0xc,%esp
                    input.w = input.e;
80101344:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
                    wakeup(&input.r);
80101349:	68 a0 0f 11 80       	push   $0x80110fa0
8010134e:	e8 3d 39 00 00       	call   80104c90 <wakeup>
80101353:	83 c4 10             	add    $0x10,%esp
80101356:	e9 a5 f6 ff ff       	jmp    80100a00 <consoleintr+0x30>
    asm volatile("cli");
8010135b:	fa                   	cli    
        for (;;)
8010135c:	eb fe                	jmp    8010135c <consoleintr+0x98c>
8010135e:	66 90                	xchg   %ax,%ax
    cmds.w = ((cmds.w + 1) > COMMAND_BUF ? COMMAND_BUF : (cmds.w + 1));
80101360:	8b 15 c4 14 11 80    	mov    0x801114c4,%edx
80101366:	b8 09 00 00 00       	mov    $0x9,%eax
    cmds.intab = 0;
8010136b:	c7 05 c8 14 11 80 00 	movl   $0x0,0x801114c8
80101372:	00 00 00 
    cmds.tmpcmd[0] = '\0';
80101375:	c6 05 cc 14 11 80 00 	movb   $0x0,0x801114cc
    cmds.lastusedidx = 0;
8010137c:	c7 05 4c 15 11 80 00 	movl   $0x0,0x8011154c
80101383:	00 00 00 
    cmds.w = ((cmds.w + 1) > COMMAND_BUF ? COMMAND_BUF : (cmds.w + 1));
80101386:	83 fa 09             	cmp    $0x9,%edx
80101389:	0f 4e c2             	cmovle %edx,%eax
8010138c:	8d 48 01             	lea    0x1(%eax),%ecx
8010138f:	89 0d c4 14 11 80    	mov    %ecx,0x801114c4
    for (int i = cmds.w - 1; i > 0; i--)
80101395:	85 d2                	test   %edx,%edx
80101397:	7e 77                	jle    80101410 <consoleintr+0xa40>
80101399:	8d 78 ff             	lea    -0x1(%eax),%edi
8010139c:	89 c3                	mov    %eax,%ebx
8010139e:	89 f9                	mov    %edi,%ecx
801013a0:	c1 e3 07             	shl    $0x7,%ebx
801013a3:	f7 d9                	neg    %ecx
801013a5:	8d b3 c0 0f 11 80    	lea    -0x7feef040(%ebx),%esi
801013ab:	c1 e1 07             	shl    $0x7,%ecx
801013ae:	66 90                	xchg   %ax,%ax
801013b0:	8d 46 80             	lea    -0x80(%esi),%eax
801013b3:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
801013b9:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
801013bf:	90                   	nop
            cmds.buf[i][j] = cmds.buf[i - 1][j];
801013c0:	8b 8d 60 ff ff ff    	mov    -0xa0(%ebp),%ecx
801013c6:	8d 14 01             	lea    (%ecx,%eax,1),%edx
801013c9:	0f b6 08             	movzbl (%eax),%ecx
801013cc:	83 c0 01             	add    $0x1,%eax
801013cf:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
        for (int j = 0; j < INPUT_BUF; j++)
801013d2:	39 c6                	cmp    %eax,%esi
801013d4:	75 ea                	jne    801013c0 <consoleintr+0x9f0>
801013d6:	8b 8d 60 ff ff ff    	mov    -0xa0(%ebp),%ecx
    for (int i = cmds.w - 1; i > 0; i--)
801013dc:	8b b5 5c ff ff ff    	mov    -0xa4(%ebp),%esi
801013e2:	83 c3 80             	add    $0xffffff80,%ebx
801013e5:	83 e9 80             	sub    $0xffffff80,%ecx
801013e8:	85 ff                	test   %edi,%edi
801013ea:	7e 24                	jle    80101410 <consoleintr+0xa40>
801013ec:	83 ef 01             	sub    $0x1,%edi
801013ef:	eb bf                	jmp    801013b0 <consoleintr+0x9e0>
801013f1:	fa                   	cli    
        for (;;)
801013f2:	eb fe                	jmp    801013f2 <consoleintr+0xa22>
801013f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801013f8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    for(int i = input.w; i < input.e; i++) {
801013fd:	3b 8d 58 ff ff ff    	cmp    -0xa8(%ebp),%ecx
80101403:	0f 82 9f fa ff ff    	jb     80100ea8 <consoleintr+0x4d8>
80101409:	e9 f2 fa ff ff       	jmp    80100f00 <consoleintr+0x530>
8010140e:	66 90                	xchg   %ax,%ax
    for (int i = input.w; i < input.e; i++) {
80101410:	8b bd 58 ff ff ff    	mov    -0xa8(%ebp),%edi
80101416:	8b b5 54 ff ff ff    	mov    -0xac(%ebp),%esi
    int j = 0;
8010141c:	31 c0                	xor    %eax,%eax
8010141e:	8b 9d 54 ff ff ff    	mov    -0xac(%ebp),%ebx
80101424:	89 f9                	mov    %edi,%ecx
80101426:	29 f1                	sub    %esi,%ecx
    for (int i = input.w; i < input.e; i++) {
80101428:	39 f7                	cmp    %esi,%edi
8010142a:	0f 86 38 fe ff ff    	jbe    80101268 <consoleintr+0x898>
        cmds.buf[0][j] = input.buf[i];
80101430:	0f b6 94 03 20 0f 11 	movzbl -0x7feef0e0(%ebx,%eax,1),%edx
80101437:	80 
        j++;
80101438:	83 c0 01             	add    $0x1,%eax
        cmds.buf[0][j] = input.buf[i];
8010143b:	88 90 bf 0f 11 80    	mov    %dl,-0x7feef041(%eax)
    for (int i = input.w; i < input.e; i++) {
80101441:	39 c8                	cmp    %ecx,%eax
80101443:	75 eb                	jne    80101430 <consoleintr+0xa60>
80101445:	e9 28 fe ff ff       	jmp    80101272 <consoleintr+0x8a2>
        consputc(input.buf[(input.e - i) % INPUT_BUF]);
8010144a:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010144f:	29 d8                	sub    %ebx,%eax
80101451:	83 e0 7f             	and    $0x7f,%eax
80101454:	0f be 80 20 0f 11 80 	movsbl -0x7feef0e0(%eax),%eax
8010145b:	e8 b0 ef ff ff       	call   80100410 <consputc.part.0>
    for (int i = input.shift; i > 0; i--)
80101460:	83 eb 01             	sub    $0x1,%ebx
80101463:	0f 85 eb fd ff ff    	jne    80101254 <consoleintr+0x884>
    asm volatile("out %0,%1"
80101469:	b8 0e 00 00 00       	mov    $0xe,%eax
8010146e:	ba d4 03 00 00       	mov    $0x3d4,%edx
80101473:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80101474:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80101479:	89 da                	mov    %ebx,%edx
8010147b:	ec                   	in     (%dx),%al
    pos = inb(CRTPORT + 1) << 8;
8010147c:	0f b6 c8             	movzbl %al,%ecx
    asm volatile("out %0,%1"
8010147f:	be 0f 00 00 00       	mov    $0xf,%esi
80101484:	ba d4 03 00 00       	mov    $0x3d4,%edx
80101489:	89 cf                	mov    %ecx,%edi
8010148b:	89 f0                	mov    %esi,%eax
8010148d:	c1 e7 08             	shl    $0x8,%edi
80101490:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80101491:	89 da                	mov    %ebx,%edx
80101493:	ec                   	in     (%dx),%al
80101494:	0f b6 c8             	movzbl %al,%ecx
    pos |= inb(CRTPORT + 1);
80101497:	09 f9                	or     %edi,%ecx
    setpos(getpos() - input.shift);
80101499:	2b 0d ac 0f 11 80    	sub    0x80110fac,%ecx
    asm volatile("out %0,%1"
8010149f:	e9 03 f7 ff ff       	jmp    80100ba7 <consoleintr+0x1d7>
        consputc(input.buf[(input.e - i) % INPUT_BUF]);
801014a4:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801014a9:	29 f0                	sub    %esi,%eax
    for (int i = input.shift; i >= 0; i--)
801014ab:	83 ee 01             	sub    $0x1,%esi
        consputc(input.buf[(input.e - i) % INPUT_BUF]);
801014ae:	83 e0 7f             	and    $0x7f,%eax
801014b1:	0f be 80 20 0f 11 80 	movsbl -0x7feef0e0(%eax),%eax
801014b8:	e8 53 ef ff ff       	call   80100410 <consputc.part.0>
    for (int i = input.shift; i >= 0; i--)
801014bd:	83 fe ff             	cmp    $0xffffffff,%esi
801014c0:	0f 85 ac fb ff ff    	jne    80101072 <consoleintr+0x6a2>
801014c6:	b8 0e 00 00 00       	mov    $0xe,%eax
801014cb:	ba d4 03 00 00       	mov    $0x3d4,%edx
801014d0:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
801014d1:	be d5 03 00 00       	mov    $0x3d5,%esi
801014d6:	89 f2                	mov    %esi,%edx
801014d8:	ec                   	in     (%dx),%al
    asm volatile("out %0,%1"
801014d9:	bf 0f 00 00 00       	mov    $0xf,%edi
    asm volatile("in %1,%0"
801014de:	0f b6 c8             	movzbl %al,%ecx
    asm volatile("out %0,%1"
801014e1:	ba d4 03 00 00       	mov    $0x3d4,%edx
    pos = inb(CRTPORT + 1) << 8;
801014e6:	c1 e1 08             	shl    $0x8,%ecx
801014e9:	89 f8                	mov    %edi,%eax
801014eb:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
801014ec:	89 f2                	mov    %esi,%edx
801014ee:	ec                   	in     (%dx),%al
    pos |= inb(CRTPORT + 1);
801014ef:	0f b6 c0             	movzbl %al,%eax
    asm volatile("out %0,%1"
801014f2:	ba d4 03 00 00       	mov    $0x3d4,%edx
801014f7:	09 c1                	or     %eax,%ecx
801014f9:	b8 0e 00 00 00       	mov    $0xe,%eax
    setpos(getpos() - input.shift);
801014fe:	2b 0d ac 0f 11 80    	sub    0x80110fac,%ecx
80101504:	ee                   	out    %al,(%dx)
    outb(CRTPORT + 1, pos >> 8);
80101505:	89 c8                	mov    %ecx,%eax
80101507:	89 f2                	mov    %esi,%edx
80101509:	c1 f8 08             	sar    $0x8,%eax
8010150c:	ee                   	out    %al,(%dx)
8010150d:	ba d4 03 00 00       	mov    $0x3d4,%edx
80101512:	89 f8                	mov    %edi,%eax
80101514:	ee                   	out    %al,(%dx)
80101515:	89 c8                	mov    %ecx,%eax
80101517:	89 f2                	mov    %esi,%edx
80101519:	ee                   	out    %al,(%dx)
}
8010151a:	e9 f7 fd ff ff       	jmp    80101316 <consoleintr+0x946>
8010151f:	90                   	nop

80101520 <consoleinit>:

void consoleinit(void) {
80101520:	f3 0f 1e fb          	endbr32 
80101524:	55                   	push   %ebp
80101525:	89 e5                	mov    %esp,%ebp
80101527:	83 ec 10             	sub    $0x10,%esp
    initlock(&cons.lock, "console");
8010152a:	68 48 7e 10 80       	push   $0x80107e48
8010152f:	68 20 b5 10 80       	push   $0x8010b520
80101534:	e8 d7 3a 00 00       	call   80105010 <initlock>

    devsw[CONSOLE].write = consolewrite;
    devsw[CONSOLE].read = consoleread;
    cons.locking = 1;

    ioapicenable(IRQ_KBD, 0);
80101539:	58                   	pop    %eax
8010153a:	5a                   	pop    %edx
8010153b:	6a 00                	push   $0x0
8010153d:	6a 01                	push   $0x1
    devsw[CONSOLE].write = consolewrite;
8010153f:	c7 05 0c 1f 11 80 50 	movl   $0x80100750,0x80111f0c
80101546:	07 10 80 
    devsw[CONSOLE].read = consoleread;
80101549:	c7 05 08 1f 11 80 90 	movl   $0x80100290,0x80111f08
80101550:	02 10 80 
    cons.locking = 1;
80101553:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
8010155a:	00 00 00 
    ioapicenable(IRQ_KBD, 0);
8010155d:	e8 6e 1a 00 00       	call   80102fd0 <ioapicenable>
80101562:	83 c4 10             	add    $0x10,%esp
80101565:	c9                   	leave  
80101566:	c3                   	ret    
80101567:	66 90                	xchg   %ax,%ax
80101569:	66 90                	xchg   %ax,%ax
8010156b:	66 90                	xchg   %ax,%ax
8010156d:	66 90                	xchg   %ax,%ax
8010156f:	90                   	nop

80101570 <exec>:
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"

int exec(char* path, char** argv) {
80101570:	f3 0f 1e fb          	endbr32 
80101574:	55                   	push   %ebp
80101575:	89 e5                	mov    %esp,%ebp
80101577:	57                   	push   %edi
80101578:	56                   	push   %esi
80101579:	53                   	push   %ebx
8010157a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
    uint argc, sz, sp, ustack[3 + MAXARG + 1];
    struct elfhdr elf;
    struct inode* ip;
    struct proghdr ph;
    pde_t *pgdir, *oldpgdir;
    struct proc* curproc = myproc();
80101580:	e8 7b 2f 00 00       	call   80104500 <myproc>
80101585:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

    begin_op();
8010158b:	e8 40 23 00 00       	call   801038d0 <begin_op>

    if ((ip = namei(path)) == 0) {
80101590:	83 ec 0c             	sub    $0xc,%esp
80101593:	ff 75 08             	pushl  0x8(%ebp)
80101596:	e8 35 16 00 00       	call   80102bd0 <namei>
8010159b:	83 c4 10             	add    $0x10,%esp
8010159e:	85 c0                	test   %eax,%eax
801015a0:	0f 84 fe 02 00 00    	je     801018a4 <exec+0x334>
        end_op();
        cprintf("exec: fail\n");
        return -1;
    }
    ilock(ip);
801015a6:	83 ec 0c             	sub    $0xc,%esp
801015a9:	89 c3                	mov    %eax,%ebx
801015ab:	50                   	push   %eax
801015ac:	e8 4f 0d 00 00       	call   80102300 <ilock>
    pgdir = 0;

    // Check ELF header
    if (readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801015b1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801015b7:	6a 34                	push   $0x34
801015b9:	6a 00                	push   $0x0
801015bb:	50                   	push   %eax
801015bc:	53                   	push   %ebx
801015bd:	e8 3e 10 00 00       	call   80102600 <readi>
801015c2:	83 c4 20             	add    $0x20,%esp
801015c5:	83 f8 34             	cmp    $0x34,%eax
801015c8:	74 26                	je     801015f0 <exec+0x80>

bad:
    if (pgdir)
        freevm(pgdir);
    if (ip) {
        iunlockput(ip);
801015ca:	83 ec 0c             	sub    $0xc,%esp
801015cd:	53                   	push   %ebx
801015ce:	e8 cd 0f 00 00       	call   801025a0 <iunlockput>
        end_op();
801015d3:	e8 68 23 00 00       	call   80103940 <end_op>
801015d8:	83 c4 10             	add    $0x10,%esp
    }
    return -1;
801015db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801015e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015e3:	5b                   	pop    %ebx
801015e4:	5e                   	pop    %esi
801015e5:	5f                   	pop    %edi
801015e6:	5d                   	pop    %ebp
801015e7:	c3                   	ret    
801015e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ef:	90                   	nop
    if (elf.magic != ELF_MAGIC)
801015f0:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801015f7:	45 4c 46 
801015fa:	75 ce                	jne    801015ca <exec+0x5a>
    if ((pgdir = setupkvm()) == 0)
801015fc:	e8 4f 65 00 00       	call   80107b50 <setupkvm>
80101601:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80101607:	85 c0                	test   %eax,%eax
80101609:	74 bf                	je     801015ca <exec+0x5a>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
8010160b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101612:	00 
80101613:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80101619:	0f 84 a4 02 00 00    	je     801018c3 <exec+0x353>
    sz = 0;
8010161f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101626:	00 00 00 
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80101629:	31 ff                	xor    %edi,%edi
8010162b:	e9 86 00 00 00       	jmp    801016b6 <exec+0x146>
        if (ph.type != ELF_PROG_LOAD)
80101630:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80101637:	75 6c                	jne    801016a5 <exec+0x135>
        if (ph.memsz < ph.filesz)
80101639:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
8010163f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80101645:	0f 82 87 00 00 00    	jb     801016d2 <exec+0x162>
        if (ph.vaddr + ph.memsz < ph.vaddr)
8010164b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101651:	72 7f                	jb     801016d2 <exec+0x162>
        if ((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80101653:	83 ec 04             	sub    $0x4,%esp
80101656:	50                   	push   %eax
80101657:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
8010165d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101663:	e8 08 63 00 00       	call   80107970 <allocuvm>
80101668:	83 c4 10             	add    $0x10,%esp
8010166b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101671:	85 c0                	test   %eax,%eax
80101673:	74 5d                	je     801016d2 <exec+0x162>
        if (ph.vaddr % PGSIZE != 0)
80101675:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
8010167b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101680:	75 50                	jne    801016d2 <exec+0x162>
        if (loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101682:	83 ec 0c             	sub    $0xc,%esp
80101685:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
8010168b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80101691:	53                   	push   %ebx
80101692:	50                   	push   %eax
80101693:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101699:	e8 02 62 00 00       	call   801078a0 <loaduvm>
8010169e:	83 c4 20             	add    $0x20,%esp
801016a1:	85 c0                	test   %eax,%eax
801016a3:	78 2d                	js     801016d2 <exec+0x162>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
801016a5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
801016ac:	83 c7 01             	add    $0x1,%edi
801016af:	83 c6 20             	add    $0x20,%esi
801016b2:	39 f8                	cmp    %edi,%eax
801016b4:	7e 3a                	jle    801016f0 <exec+0x180>
        if (readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801016b6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801016bc:	6a 20                	push   $0x20
801016be:	56                   	push   %esi
801016bf:	50                   	push   %eax
801016c0:	53                   	push   %ebx
801016c1:	e8 3a 0f 00 00       	call   80102600 <readi>
801016c6:	83 c4 10             	add    $0x10,%esp
801016c9:	83 f8 20             	cmp    $0x20,%eax
801016cc:	0f 84 5e ff ff ff    	je     80101630 <exec+0xc0>
        freevm(pgdir);
801016d2:	83 ec 0c             	sub    $0xc,%esp
801016d5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801016db:	e8 f0 63 00 00       	call   80107ad0 <freevm>
    if (ip) {
801016e0:	83 c4 10             	add    $0x10,%esp
801016e3:	e9 e2 fe ff ff       	jmp    801015ca <exec+0x5a>
801016e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016ef:	90                   	nop
801016f0:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
801016f6:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
801016fc:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80101702:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
    iunlockput(ip);
80101708:	83 ec 0c             	sub    $0xc,%esp
8010170b:	53                   	push   %ebx
8010170c:	e8 8f 0e 00 00       	call   801025a0 <iunlockput>
    end_op();
80101711:	e8 2a 22 00 00       	call   80103940 <end_op>
    if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0)
80101716:	83 c4 0c             	add    $0xc,%esp
80101719:	56                   	push   %esi
8010171a:	57                   	push   %edi
8010171b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80101721:	57                   	push   %edi
80101722:	e8 49 62 00 00       	call   80107970 <allocuvm>
80101727:	83 c4 10             	add    $0x10,%esp
8010172a:	89 c6                	mov    %eax,%esi
8010172c:	85 c0                	test   %eax,%eax
8010172e:	0f 84 94 00 00 00    	je     801017c8 <exec+0x258>
    clearpteu(pgdir, (char*)(sz - 2 * PGSIZE));
80101734:	83 ec 08             	sub    $0x8,%esp
80101737:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
    for (argc = 0; argv[argc]; argc++) {
8010173d:	89 f3                	mov    %esi,%ebx
    clearpteu(pgdir, (char*)(sz - 2 * PGSIZE));
8010173f:	50                   	push   %eax
80101740:	57                   	push   %edi
    for (argc = 0; argv[argc]; argc++) {
80101741:	31 ff                	xor    %edi,%edi
    clearpteu(pgdir, (char*)(sz - 2 * PGSIZE));
80101743:	e8 a8 64 00 00       	call   80107bf0 <clearpteu>
    for (argc = 0; argv[argc]; argc++) {
80101748:	8b 45 0c             	mov    0xc(%ebp),%eax
8010174b:	83 c4 10             	add    $0x10,%esp
8010174e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80101754:	8b 00                	mov    (%eax),%eax
80101756:	85 c0                	test   %eax,%eax
80101758:	0f 84 8b 00 00 00    	je     801017e9 <exec+0x279>
8010175e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80101764:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
8010176a:	eb 23                	jmp    8010178f <exec+0x21f>
8010176c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101770:	8b 45 0c             	mov    0xc(%ebp),%eax
        ustack[3 + argc] = sp;
80101773:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    for (argc = 0; argv[argc]; argc++) {
8010177a:	83 c7 01             	add    $0x1,%edi
        ustack[3 + argc] = sp;
8010177d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    for (argc = 0; argv[argc]; argc++) {
80101783:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101786:	85 c0                	test   %eax,%eax
80101788:	74 59                	je     801017e3 <exec+0x273>
        if (argc >= MAXARG)
8010178a:	83 ff 20             	cmp    $0x20,%edi
8010178d:	74 39                	je     801017c8 <exec+0x258>
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010178f:	83 ec 0c             	sub    $0xc,%esp
80101792:	50                   	push   %eax
80101793:	e8 08 3d 00 00       	call   801054a0 <strlen>
80101798:	f7 d0                	not    %eax
8010179a:	01 c3                	add    %eax,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010179c:	58                   	pop    %eax
8010179d:	8b 45 0c             	mov    0xc(%ebp),%eax
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801017a0:	83 e3 fc             	and    $0xfffffffc,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801017a3:	ff 34 b8             	pushl  (%eax,%edi,4)
801017a6:	e8 f5 3c 00 00       	call   801054a0 <strlen>
801017ab:	83 c0 01             	add    $0x1,%eax
801017ae:	50                   	push   %eax
801017af:	8b 45 0c             	mov    0xc(%ebp),%eax
801017b2:	ff 34 b8             	pushl  (%eax,%edi,4)
801017b5:	53                   	push   %ebx
801017b6:	56                   	push   %esi
801017b7:	e8 94 65 00 00       	call   80107d50 <copyout>
801017bc:	83 c4 20             	add    $0x20,%esp
801017bf:	85 c0                	test   %eax,%eax
801017c1:	79 ad                	jns    80101770 <exec+0x200>
801017c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017c7:	90                   	nop
        freevm(pgdir);
801017c8:	83 ec 0c             	sub    $0xc,%esp
801017cb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801017d1:	e8 fa 62 00 00       	call   80107ad0 <freevm>
801017d6:	83 c4 10             	add    $0x10,%esp
    return -1;
801017d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801017de:	e9 fd fd ff ff       	jmp    801015e0 <exec+0x70>
801017e3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
    ustack[2] = sp - (argc + 1) * 4; // argv pointer
801017e9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
801017f0:	89 d9                	mov    %ebx,%ecx
    ustack[3 + argc] = 0;
801017f2:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
801017f9:	00 00 00 00 
    ustack[2] = sp - (argc + 1) * 4; // argv pointer
801017fd:	29 c1                	sub    %eax,%ecx
    sp -= (3 + argc + 1) * 4;
801017ff:	83 c0 0c             	add    $0xc,%eax
    ustack[1] = argc;
80101802:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
    sp -= (3 + argc + 1) * 4;
80101808:	29 c3                	sub    %eax,%ebx
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
8010180a:	50                   	push   %eax
8010180b:	52                   	push   %edx
8010180c:	53                   	push   %ebx
8010180d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
    ustack[0] = 0xffffffff; // fake return PC
80101813:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010181a:	ff ff ff 
    ustack[2] = sp - (argc + 1) * 4; // argv pointer
8010181d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
80101823:	e8 28 65 00 00       	call   80107d50 <copyout>
80101828:	83 c4 10             	add    $0x10,%esp
8010182b:	85 c0                	test   %eax,%eax
8010182d:	78 99                	js     801017c8 <exec+0x258>
    for (last = s = path; *s; s++)
8010182f:	8b 45 08             	mov    0x8(%ebp),%eax
80101832:	8b 55 08             	mov    0x8(%ebp),%edx
80101835:	0f b6 00             	movzbl (%eax),%eax
80101838:	84 c0                	test   %al,%al
8010183a:	74 13                	je     8010184f <exec+0x2df>
8010183c:	89 d1                	mov    %edx,%ecx
8010183e:	66 90                	xchg   %ax,%ax
        if (*s == '/')
80101840:	83 c1 01             	add    $0x1,%ecx
80101843:	3c 2f                	cmp    $0x2f,%al
    for (last = s = path; *s; s++)
80101845:	0f b6 01             	movzbl (%ecx),%eax
        if (*s == '/')
80101848:	0f 44 d1             	cmove  %ecx,%edx
    for (last = s = path; *s; s++)
8010184b:	84 c0                	test   %al,%al
8010184d:	75 f1                	jne    80101840 <exec+0x2d0>
    safestrcpy(curproc->name, last, sizeof(curproc->name));
8010184f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80101855:	83 ec 04             	sub    $0x4,%esp
80101858:	6a 10                	push   $0x10
8010185a:	89 f8                	mov    %edi,%eax
8010185c:	52                   	push   %edx
8010185d:	83 c0 6c             	add    $0x6c,%eax
80101860:	50                   	push   %eax
80101861:	e8 fa 3b 00 00       	call   80105460 <safestrcpy>
    curproc->pgdir = pgdir;
80101866:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    oldpgdir = curproc->pgdir;
8010186c:	89 f8                	mov    %edi,%eax
8010186e:	8b 7f 04             	mov    0x4(%edi),%edi
    curproc->sz = sz;
80101871:	89 30                	mov    %esi,(%eax)
    curproc->pgdir = pgdir;
80101873:	89 48 04             	mov    %ecx,0x4(%eax)
    curproc->tf->eip = elf.entry; // main
80101876:	89 c1                	mov    %eax,%ecx
80101878:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010187e:	8b 40 18             	mov    0x18(%eax),%eax
80101881:	89 50 38             	mov    %edx,0x38(%eax)
    curproc->tf->esp = sp;
80101884:	8b 41 18             	mov    0x18(%ecx),%eax
80101887:	89 58 44             	mov    %ebx,0x44(%eax)
    switchuvm(curproc);
8010188a:	89 0c 24             	mov    %ecx,(%esp)
8010188d:	e8 7e 5e 00 00       	call   80107710 <switchuvm>
    freevm(oldpgdir);
80101892:	89 3c 24             	mov    %edi,(%esp)
80101895:	e8 36 62 00 00       	call   80107ad0 <freevm>
    return 0;
8010189a:	83 c4 10             	add    $0x10,%esp
8010189d:	31 c0                	xor    %eax,%eax
8010189f:	e9 3c fd ff ff       	jmp    801015e0 <exec+0x70>
        end_op();
801018a4:	e8 97 20 00 00       	call   80103940 <end_op>
        cprintf("exec: fail\n");
801018a9:	83 ec 0c             	sub    $0xc,%esp
801018ac:	68 b9 7e 10 80       	push   $0x80107eb9
801018b1:	e8 0a ef ff ff       	call   801007c0 <cprintf>
        return -1;
801018b6:	83 c4 10             	add    $0x10,%esp
801018b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018be:	e9 1d fd ff ff       	jmp    801015e0 <exec+0x70>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
801018c3:	31 ff                	xor    %edi,%edi
801018c5:	be 00 20 00 00       	mov    $0x2000,%esi
801018ca:	e9 39 fe ff ff       	jmp    80101708 <exec+0x198>
801018cf:	90                   	nop

801018d0 <fileinit>:
struct {
    struct spinlock lock;
    struct file file[NFILE];
} ftable;

void fileinit(void) {
801018d0:	f3 0f 1e fb          	endbr32 
801018d4:	55                   	push   %ebp
801018d5:	89 e5                	mov    %esp,%ebp
801018d7:	83 ec 10             	sub    $0x10,%esp
    initlock(&ftable.lock, "ftable");
801018da:	68 c5 7e 10 80       	push   $0x80107ec5
801018df:	68 60 15 11 80       	push   $0x80111560
801018e4:	e8 27 37 00 00       	call   80105010 <initlock>
}
801018e9:	83 c4 10             	add    $0x10,%esp
801018ec:	c9                   	leave  
801018ed:	c3                   	ret    
801018ee:	66 90                	xchg   %ax,%ax

801018f0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void) {
801018f0:	f3 0f 1e fb          	endbr32 
801018f4:	55                   	push   %ebp
801018f5:	89 e5                	mov    %esp,%ebp
801018f7:	53                   	push   %ebx
    struct file* f;

    acquire(&ftable.lock);
    for (f = ftable.file; f < ftable.file + NFILE; f++) {
801018f8:	bb 94 15 11 80       	mov    $0x80111594,%ebx
filealloc(void) {
801018fd:	83 ec 10             	sub    $0x10,%esp
    acquire(&ftable.lock);
80101900:	68 60 15 11 80       	push   $0x80111560
80101905:	e8 86 38 00 00       	call   80105190 <acquire>
8010190a:	83 c4 10             	add    $0x10,%esp
8010190d:	eb 0c                	jmp    8010191b <filealloc+0x2b>
8010190f:	90                   	nop
    for (f = ftable.file; f < ftable.file + NFILE; f++) {
80101910:	83 c3 18             	add    $0x18,%ebx
80101913:	81 fb f4 1e 11 80    	cmp    $0x80111ef4,%ebx
80101919:	74 25                	je     80101940 <filealloc+0x50>
        if (f->ref == 0) {
8010191b:	8b 43 04             	mov    0x4(%ebx),%eax
8010191e:	85 c0                	test   %eax,%eax
80101920:	75 ee                	jne    80101910 <filealloc+0x20>
            f->ref = 1;
            release(&ftable.lock);
80101922:	83 ec 0c             	sub    $0xc,%esp
            f->ref = 1;
80101925:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
            release(&ftable.lock);
8010192c:	68 60 15 11 80       	push   $0x80111560
80101931:	e8 1a 39 00 00       	call   80105250 <release>
            return f;
        }
    }
    release(&ftable.lock);
    return 0;
}
80101936:	89 d8                	mov    %ebx,%eax
            return f;
80101938:	83 c4 10             	add    $0x10,%esp
}
8010193b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010193e:	c9                   	leave  
8010193f:	c3                   	ret    
    release(&ftable.lock);
80101940:	83 ec 0c             	sub    $0xc,%esp
    return 0;
80101943:	31 db                	xor    %ebx,%ebx
    release(&ftable.lock);
80101945:	68 60 15 11 80       	push   $0x80111560
8010194a:	e8 01 39 00 00       	call   80105250 <release>
}
8010194f:	89 d8                	mov    %ebx,%eax
    return 0;
80101951:	83 c4 10             	add    $0x10,%esp
}
80101954:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101957:	c9                   	leave  
80101958:	c3                   	ret    
80101959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101960 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file* f) {
80101960:	f3 0f 1e fb          	endbr32 
80101964:	55                   	push   %ebp
80101965:	89 e5                	mov    %esp,%ebp
80101967:	53                   	push   %ebx
80101968:	83 ec 10             	sub    $0x10,%esp
8010196b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ftable.lock);
8010196e:	68 60 15 11 80       	push   $0x80111560
80101973:	e8 18 38 00 00       	call   80105190 <acquire>
    if (f->ref < 1)
80101978:	8b 43 04             	mov    0x4(%ebx),%eax
8010197b:	83 c4 10             	add    $0x10,%esp
8010197e:	85 c0                	test   %eax,%eax
80101980:	7e 1a                	jle    8010199c <filedup+0x3c>
        panic("filedup");
    f->ref++;
80101982:	83 c0 01             	add    $0x1,%eax
    release(&ftable.lock);
80101985:	83 ec 0c             	sub    $0xc,%esp
    f->ref++;
80101988:	89 43 04             	mov    %eax,0x4(%ebx)
    release(&ftable.lock);
8010198b:	68 60 15 11 80       	push   $0x80111560
80101990:	e8 bb 38 00 00       	call   80105250 <release>
    return f;
}
80101995:	89 d8                	mov    %ebx,%eax
80101997:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010199a:	c9                   	leave  
8010199b:	c3                   	ret    
        panic("filedup");
8010199c:	83 ec 0c             	sub    $0xc,%esp
8010199f:	68 cc 7e 10 80       	push   $0x80107ecc
801019a4:	e8 e7 e9 ff ff       	call   80100390 <panic>
801019a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801019b0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file* f) {
801019b0:	f3 0f 1e fb          	endbr32 
801019b4:	55                   	push   %ebp
801019b5:	89 e5                	mov    %esp,%ebp
801019b7:	57                   	push   %edi
801019b8:	56                   	push   %esi
801019b9:	53                   	push   %ebx
801019ba:	83 ec 28             	sub    $0x28,%esp
801019bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct file ff;

    acquire(&ftable.lock);
801019c0:	68 60 15 11 80       	push   $0x80111560
801019c5:	e8 c6 37 00 00       	call   80105190 <acquire>
    if (f->ref < 1)
801019ca:	8b 53 04             	mov    0x4(%ebx),%edx
801019cd:	83 c4 10             	add    $0x10,%esp
801019d0:	85 d2                	test   %edx,%edx
801019d2:	0f 8e a1 00 00 00    	jle    80101a79 <fileclose+0xc9>
        panic("fileclose");
    if (--f->ref > 0) {
801019d8:	83 ea 01             	sub    $0x1,%edx
801019db:	89 53 04             	mov    %edx,0x4(%ebx)
801019de:	75 40                	jne    80101a20 <fileclose+0x70>
        release(&ftable.lock);
        return;
    }
    ff = *f;
801019e0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
    f->ref = 0;
    f->type = FD_NONE;
    release(&ftable.lock);
801019e4:	83 ec 0c             	sub    $0xc,%esp
    ff = *f;
801019e7:	8b 3b                	mov    (%ebx),%edi
    f->type = FD_NONE;
801019e9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    ff = *f;
801019ef:	8b 73 0c             	mov    0xc(%ebx),%esi
801019f2:	88 45 e7             	mov    %al,-0x19(%ebp)
801019f5:	8b 43 10             	mov    0x10(%ebx),%eax
    release(&ftable.lock);
801019f8:	68 60 15 11 80       	push   $0x80111560
    ff = *f;
801019fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    release(&ftable.lock);
80101a00:	e8 4b 38 00 00       	call   80105250 <release>

    if (ff.type == FD_PIPE)
80101a05:	83 c4 10             	add    $0x10,%esp
80101a08:	83 ff 01             	cmp    $0x1,%edi
80101a0b:	74 53                	je     80101a60 <fileclose+0xb0>
        pipeclose(ff.pipe, ff.writable);
    else if (ff.type == FD_INODE) {
80101a0d:	83 ff 02             	cmp    $0x2,%edi
80101a10:	74 26                	je     80101a38 <fileclose+0x88>
        begin_op();
        iput(ff.ip);
        end_op();
    }
}
80101a12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a15:	5b                   	pop    %ebx
80101a16:	5e                   	pop    %esi
80101a17:	5f                   	pop    %edi
80101a18:	5d                   	pop    %ebp
80101a19:	c3                   	ret    
80101a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        release(&ftable.lock);
80101a20:	c7 45 08 60 15 11 80 	movl   $0x80111560,0x8(%ebp)
}
80101a27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a2a:	5b                   	pop    %ebx
80101a2b:	5e                   	pop    %esi
80101a2c:	5f                   	pop    %edi
80101a2d:	5d                   	pop    %ebp
        release(&ftable.lock);
80101a2e:	e9 1d 38 00 00       	jmp    80105250 <release>
80101a33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a37:	90                   	nop
        begin_op();
80101a38:	e8 93 1e 00 00       	call   801038d0 <begin_op>
        iput(ff.ip);
80101a3d:	83 ec 0c             	sub    $0xc,%esp
80101a40:	ff 75 e0             	pushl  -0x20(%ebp)
80101a43:	e8 e8 09 00 00       	call   80102430 <iput>
        end_op();
80101a48:	83 c4 10             	add    $0x10,%esp
}
80101a4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a4e:	5b                   	pop    %ebx
80101a4f:	5e                   	pop    %esi
80101a50:	5f                   	pop    %edi
80101a51:	5d                   	pop    %ebp
        end_op();
80101a52:	e9 e9 1e 00 00       	jmp    80103940 <end_op>
80101a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a5e:	66 90                	xchg   %ax,%ax
        pipeclose(ff.pipe, ff.writable);
80101a60:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101a64:	83 ec 08             	sub    $0x8,%esp
80101a67:	53                   	push   %ebx
80101a68:	56                   	push   %esi
80101a69:	e8 32 26 00 00       	call   801040a0 <pipeclose>
80101a6e:	83 c4 10             	add    $0x10,%esp
}
80101a71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a74:	5b                   	pop    %ebx
80101a75:	5e                   	pop    %esi
80101a76:	5f                   	pop    %edi
80101a77:	5d                   	pop    %ebp
80101a78:	c3                   	ret    
        panic("fileclose");
80101a79:	83 ec 0c             	sub    $0xc,%esp
80101a7c:	68 d4 7e 10 80       	push   $0x80107ed4
80101a81:	e8 0a e9 ff ff       	call   80100390 <panic>
80101a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a8d:	8d 76 00             	lea    0x0(%esi),%esi

80101a90 <filestat>:

// Get metadata about file f.
int filestat(struct file* f, struct stat* st) {
80101a90:	f3 0f 1e fb          	endbr32 
80101a94:	55                   	push   %ebp
80101a95:	89 e5                	mov    %esp,%ebp
80101a97:	53                   	push   %ebx
80101a98:	83 ec 04             	sub    $0x4,%esp
80101a9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (f->type == FD_INODE) {
80101a9e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101aa1:	75 2d                	jne    80101ad0 <filestat+0x40>
        ilock(f->ip);
80101aa3:	83 ec 0c             	sub    $0xc,%esp
80101aa6:	ff 73 10             	pushl  0x10(%ebx)
80101aa9:	e8 52 08 00 00       	call   80102300 <ilock>
        stati(f->ip, st);
80101aae:	58                   	pop    %eax
80101aaf:	5a                   	pop    %edx
80101ab0:	ff 75 0c             	pushl  0xc(%ebp)
80101ab3:	ff 73 10             	pushl  0x10(%ebx)
80101ab6:	e8 15 0b 00 00       	call   801025d0 <stati>
        iunlock(f->ip);
80101abb:	59                   	pop    %ecx
80101abc:	ff 73 10             	pushl  0x10(%ebx)
80101abf:	e8 1c 09 00 00       	call   801023e0 <iunlock>
        return 0;
    }
    return -1;
}
80101ac4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
        return 0;
80101ac7:	83 c4 10             	add    $0x10,%esp
80101aca:	31 c0                	xor    %eax,%eax
}
80101acc:	c9                   	leave  
80101acd:	c3                   	ret    
80101ace:	66 90                	xchg   %ax,%ax
80101ad0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80101ad3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101ad8:	c9                   	leave  
80101ad9:	c3                   	ret    
80101ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ae0 <fileread>:

// Read from file f.
int fileread(struct file* f, char* addr, int n) {
80101ae0:	f3 0f 1e fb          	endbr32 
80101ae4:	55                   	push   %ebp
80101ae5:	89 e5                	mov    %esp,%ebp
80101ae7:	57                   	push   %edi
80101ae8:	56                   	push   %esi
80101ae9:	53                   	push   %ebx
80101aea:	83 ec 0c             	sub    $0xc,%esp
80101aed:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101af0:	8b 75 0c             	mov    0xc(%ebp),%esi
80101af3:	8b 7d 10             	mov    0x10(%ebp),%edi
    int r;

    if (f->readable == 0)
80101af6:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101afa:	74 64                	je     80101b60 <fileread+0x80>
        return -1;
    if (f->type == FD_PIPE)
80101afc:	8b 03                	mov    (%ebx),%eax
80101afe:	83 f8 01             	cmp    $0x1,%eax
80101b01:	74 45                	je     80101b48 <fileread+0x68>
        return piperead(f->pipe, addr, n);
    if (f->type == FD_INODE) {
80101b03:	83 f8 02             	cmp    $0x2,%eax
80101b06:	75 5f                	jne    80101b67 <fileread+0x87>
        ilock(f->ip);
80101b08:	83 ec 0c             	sub    $0xc,%esp
80101b0b:	ff 73 10             	pushl  0x10(%ebx)
80101b0e:	e8 ed 07 00 00       	call   80102300 <ilock>
        if ((r = readi(f->ip, addr, f->off, n)) > 0)
80101b13:	57                   	push   %edi
80101b14:	ff 73 14             	pushl  0x14(%ebx)
80101b17:	56                   	push   %esi
80101b18:	ff 73 10             	pushl  0x10(%ebx)
80101b1b:	e8 e0 0a 00 00       	call   80102600 <readi>
80101b20:	83 c4 20             	add    $0x20,%esp
80101b23:	89 c6                	mov    %eax,%esi
80101b25:	85 c0                	test   %eax,%eax
80101b27:	7e 03                	jle    80101b2c <fileread+0x4c>
            f->off += r;
80101b29:	01 43 14             	add    %eax,0x14(%ebx)
        iunlock(f->ip);
80101b2c:	83 ec 0c             	sub    $0xc,%esp
80101b2f:	ff 73 10             	pushl  0x10(%ebx)
80101b32:	e8 a9 08 00 00       	call   801023e0 <iunlock>
        return r;
80101b37:	83 c4 10             	add    $0x10,%esp
    }
    panic("fileread");
}
80101b3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b3d:	89 f0                	mov    %esi,%eax
80101b3f:	5b                   	pop    %ebx
80101b40:	5e                   	pop    %esi
80101b41:	5f                   	pop    %edi
80101b42:	5d                   	pop    %ebp
80101b43:	c3                   	ret    
80101b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return piperead(f->pipe, addr, n);
80101b48:	8b 43 0c             	mov    0xc(%ebx),%eax
80101b4b:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101b4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b51:	5b                   	pop    %ebx
80101b52:	5e                   	pop    %esi
80101b53:	5f                   	pop    %edi
80101b54:	5d                   	pop    %ebp
        return piperead(f->pipe, addr, n);
80101b55:	e9 e6 26 00 00       	jmp    80104240 <piperead>
80101b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return -1;
80101b60:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101b65:	eb d3                	jmp    80101b3a <fileread+0x5a>
    panic("fileread");
80101b67:	83 ec 0c             	sub    $0xc,%esp
80101b6a:	68 de 7e 10 80       	push   $0x80107ede
80101b6f:	e8 1c e8 ff ff       	call   80100390 <panic>
80101b74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b7f:	90                   	nop

80101b80 <filewrite>:

// PAGEBREAK!
//  Write to file f.
int filewrite(struct file* f, char* addr, int n) {
80101b80:	f3 0f 1e fb          	endbr32 
80101b84:	55                   	push   %ebp
80101b85:	89 e5                	mov    %esp,%ebp
80101b87:	57                   	push   %edi
80101b88:	56                   	push   %esi
80101b89:	53                   	push   %ebx
80101b8a:	83 ec 1c             	sub    $0x1c,%esp
80101b8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b90:	8b 75 08             	mov    0x8(%ebp),%esi
80101b93:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101b96:	8b 45 10             	mov    0x10(%ebp),%eax
    int r;

    if (f->writable == 0)
80101b99:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
int filewrite(struct file* f, char* addr, int n) {
80101b9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (f->writable == 0)
80101ba0:	0f 84 c1 00 00 00    	je     80101c67 <filewrite+0xe7>
        return -1;
    if (f->type == FD_PIPE)
80101ba6:	8b 06                	mov    (%esi),%eax
80101ba8:	83 f8 01             	cmp    $0x1,%eax
80101bab:	0f 84 c3 00 00 00    	je     80101c74 <filewrite+0xf4>
        return pipewrite(f->pipe, addr, n);
    if (f->type == FD_INODE) {
80101bb1:	83 f8 02             	cmp    $0x2,%eax
80101bb4:	0f 85 cc 00 00 00    	jne    80101c86 <filewrite+0x106>
        // and 2 blocks of slop for non-aligned writes.
        // this really belongs lower down, since writei()
        // might be writing a device like the console.
        int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * 512;
        int i = 0;
        while (i < n) {
80101bba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        int i = 0;
80101bbd:	31 ff                	xor    %edi,%edi
        while (i < n) {
80101bbf:	85 c0                	test   %eax,%eax
80101bc1:	7f 34                	jg     80101bf7 <filewrite+0x77>
80101bc3:	e9 98 00 00 00       	jmp    80101c60 <filewrite+0xe0>
80101bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bcf:	90                   	nop
                n1 = max;

            begin_op();
            ilock(f->ip);
            if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
                f->off += r;
80101bd0:	01 46 14             	add    %eax,0x14(%esi)
            iunlock(f->ip);
80101bd3:	83 ec 0c             	sub    $0xc,%esp
80101bd6:	ff 76 10             	pushl  0x10(%esi)
                f->off += r;
80101bd9:	89 45 e0             	mov    %eax,-0x20(%ebp)
            iunlock(f->ip);
80101bdc:	e8 ff 07 00 00       	call   801023e0 <iunlock>
            end_op();
80101be1:	e8 5a 1d 00 00       	call   80103940 <end_op>

            if (r < 0)
                break;
            if (r != n1)
80101be6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101be9:	83 c4 10             	add    $0x10,%esp
80101bec:	39 c3                	cmp    %eax,%ebx
80101bee:	75 60                	jne    80101c50 <filewrite+0xd0>
                panic("short filewrite");
            i += r;
80101bf0:	01 df                	add    %ebx,%edi
        while (i < n) {
80101bf2:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101bf5:	7e 69                	jle    80101c60 <filewrite+0xe0>
            int n1 = n - i;
80101bf7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bfa:	b8 00 06 00 00       	mov    $0x600,%eax
80101bff:	29 fb                	sub    %edi,%ebx
            if (n1 > max)
80101c01:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101c07:	0f 4f d8             	cmovg  %eax,%ebx
            begin_op();
80101c0a:	e8 c1 1c 00 00       	call   801038d0 <begin_op>
            ilock(f->ip);
80101c0f:	83 ec 0c             	sub    $0xc,%esp
80101c12:	ff 76 10             	pushl  0x10(%esi)
80101c15:	e8 e6 06 00 00       	call   80102300 <ilock>
            if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101c1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101c1d:	53                   	push   %ebx
80101c1e:	ff 76 14             	pushl  0x14(%esi)
80101c21:	01 f8                	add    %edi,%eax
80101c23:	50                   	push   %eax
80101c24:	ff 76 10             	pushl  0x10(%esi)
80101c27:	e8 d4 0a 00 00       	call   80102700 <writei>
80101c2c:	83 c4 20             	add    $0x20,%esp
80101c2f:	85 c0                	test   %eax,%eax
80101c31:	7f 9d                	jg     80101bd0 <filewrite+0x50>
            iunlock(f->ip);
80101c33:	83 ec 0c             	sub    $0xc,%esp
80101c36:	ff 76 10             	pushl  0x10(%esi)
80101c39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101c3c:	e8 9f 07 00 00       	call   801023e0 <iunlock>
            end_op();
80101c41:	e8 fa 1c 00 00       	call   80103940 <end_op>
            if (r < 0)
80101c46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c49:	83 c4 10             	add    $0x10,%esp
80101c4c:	85 c0                	test   %eax,%eax
80101c4e:	75 17                	jne    80101c67 <filewrite+0xe7>
                panic("short filewrite");
80101c50:	83 ec 0c             	sub    $0xc,%esp
80101c53:	68 e7 7e 10 80       	push   $0x80107ee7
80101c58:	e8 33 e7 ff ff       	call   80100390 <panic>
80101c5d:	8d 76 00             	lea    0x0(%esi),%esi
        }
        return i == n ? n : -1;
80101c60:	89 f8                	mov    %edi,%eax
80101c62:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101c65:	74 05                	je     80101c6c <filewrite+0xec>
80101c67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    panic("filewrite");
}
80101c6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c6f:	5b                   	pop    %ebx
80101c70:	5e                   	pop    %esi
80101c71:	5f                   	pop    %edi
80101c72:	5d                   	pop    %ebp
80101c73:	c3                   	ret    
        return pipewrite(f->pipe, addr, n);
80101c74:	8b 46 0c             	mov    0xc(%esi),%eax
80101c77:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101c7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c7d:	5b                   	pop    %ebx
80101c7e:	5e                   	pop    %esi
80101c7f:	5f                   	pop    %edi
80101c80:	5d                   	pop    %ebp
        return pipewrite(f->pipe, addr, n);
80101c81:	e9 ba 24 00 00       	jmp    80104140 <pipewrite>
    panic("filewrite");
80101c86:	83 ec 0c             	sub    $0xc,%esp
80101c89:	68 ed 7e 10 80       	push   $0x80107eed
80101c8e:	e8 fd e6 ff ff       	call   80100390 <panic>
80101c93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ca0 <fcopy>:

int fcopy(struct inode* src, struct inode* dest) {
80101ca0:	f3 0f 1e fb          	endbr32 
80101ca4:	55                   	push   %ebp
80101ca5:	89 e5                	mov    %esp,%ebp
80101ca7:	57                   	push   %edi
    begin_op();
    
    ilock(src);
    ilock(dest);
    
    uint offset = 0;
80101ca8:	31 ff                	xor    %edi,%edi
int fcopy(struct inode* src, struct inode* dest) {
80101caa:	56                   	push   %esi
    memset(buffer, 0, BUF_SIZE);
80101cab:	8d 75 e7             	lea    -0x19(%ebp),%esi
int fcopy(struct inode* src, struct inode* dest) {
80101cae:	53                   	push   %ebx
80101caf:	83 ec 20             	sub    $0x20,%esp
80101cb2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    memset(buffer, 0, BUF_SIZE);
80101cb5:	6a 01                	push   $0x1
80101cb7:	6a 00                	push   $0x0
80101cb9:	56                   	push   %esi
80101cba:	e8 e1 35 00 00       	call   801052a0 <memset>
    begin_op();
80101cbf:	e8 0c 1c 00 00       	call   801038d0 <begin_op>
    ilock(src);
80101cc4:	58                   	pop    %eax
80101cc5:	ff 75 08             	pushl  0x8(%ebp)
80101cc8:	e8 33 06 00 00       	call   80102300 <ilock>
    ilock(dest);
80101ccd:	89 1c 24             	mov    %ebx,(%esp)
80101cd0:	e8 2b 06 00 00       	call   80102300 <ilock>
    dest->size = 0;
80101cd5:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
    while(readi(src, buffer, offset, BUF_SIZE) > 0) {
80101cdc:	83 c4 10             	add    $0x10,%esp
80101cdf:	eb 30                	jmp    80101d11 <fcopy+0x71>
80101ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        dest->size += BUF_SIZE;
80101ce8:	83 43 58 01          	addl   $0x1,0x58(%ebx)
        writei(dest, buffer, offset, BUF_SIZE);
80101cec:	6a 01                	push   $0x1
80101cee:	57                   	push   %edi
        memset(buffer, 0, BUF_SIZE);
        iupdate(dest);
        offset += BUF_SIZE;
80101cef:	83 c7 01             	add    $0x1,%edi
        writei(dest, buffer, offset, BUF_SIZE);
80101cf2:	56                   	push   %esi
80101cf3:	53                   	push   %ebx
80101cf4:	e8 07 0a 00 00       	call   80102700 <writei>
        memset(buffer, 0, BUF_SIZE);
80101cf9:	83 c4 0c             	add    $0xc,%esp
80101cfc:	6a 01                	push   $0x1
80101cfe:	6a 00                	push   $0x0
80101d00:	56                   	push   %esi
80101d01:	e8 9a 35 00 00       	call   801052a0 <memset>
        iupdate(dest);
80101d06:	89 1c 24             	mov    %ebx,(%esp)
80101d09:	e8 32 05 00 00       	call   80102240 <iupdate>
        offset += BUF_SIZE;
80101d0e:	83 c4 10             	add    $0x10,%esp
    while(readi(src, buffer, offset, BUF_SIZE) > 0) {
80101d11:	6a 01                	push   $0x1
80101d13:	57                   	push   %edi
80101d14:	56                   	push   %esi
80101d15:	ff 75 08             	pushl  0x8(%ebp)
80101d18:	e8 e3 08 00 00       	call   80102600 <readi>
80101d1d:	83 c4 10             	add    $0x10,%esp
80101d20:	85 c0                	test   %eax,%eax
80101d22:	7f c4                	jg     80101ce8 <fcopy+0x48>
    }

    iunlock(src);
80101d24:	83 ec 0c             	sub    $0xc,%esp
80101d27:	ff 75 08             	pushl  0x8(%ebp)
80101d2a:	e8 b1 06 00 00       	call   801023e0 <iunlock>
    iunlock(dest);
80101d2f:	89 1c 24             	mov    %ebx,(%esp)
80101d32:	e8 a9 06 00 00       	call   801023e0 <iunlock>
    end_op();
80101d37:	e8 04 1c 00 00       	call   80103940 <end_op>

    return 0;
80101d3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d3f:	31 c0                	xor    %eax,%eax
80101d41:	5b                   	pop    %ebx
80101d42:	5e                   	pop    %esi
80101d43:	5f                   	pop    %edi
80101d44:	5d                   	pop    %ebp
80101d45:	c3                   	ret    
80101d46:	66 90                	xchg   %ax,%ax
80101d48:	66 90                	xchg   %ax,%ax
80101d4a:	66 90                	xchg   %ax,%ax
80101d4c:	66 90                	xchg   %ax,%ax
80101d4e:	66 90                	xchg   %ax,%ax

80101d50 <bfree>:
    panic("balloc: out of blocks");
}

// Free a disk block.
static void
bfree(int dev, uint b) {
80101d50:	55                   	push   %ebp
80101d51:	89 c1                	mov    %eax,%ecx
    struct buf* bp;
    int bi, m;

    bp = bread(dev, BBLOCK(b, sb));
80101d53:	89 d0                	mov    %edx,%eax
80101d55:	c1 e8 0c             	shr    $0xc,%eax
80101d58:	03 05 78 1f 11 80    	add    0x80111f78,%eax
bfree(int dev, uint b) {
80101d5e:	89 e5                	mov    %esp,%ebp
80101d60:	56                   	push   %esi
80101d61:	53                   	push   %ebx
80101d62:	89 d3                	mov    %edx,%ebx
    bp = bread(dev, BBLOCK(b, sb));
80101d64:	83 ec 08             	sub    $0x8,%esp
80101d67:	50                   	push   %eax
80101d68:	51                   	push   %ecx
80101d69:	e8 62 e3 ff ff       	call   801000d0 <bread>
    bi = b % BPB;
    m = 1 << (bi % 8);
80101d6e:	89 d9                	mov    %ebx,%ecx
    if ((bp->data[bi / 8] & m) == 0)
80101d70:	c1 fb 03             	sar    $0x3,%ebx
    m = 1 << (bi % 8);
80101d73:	ba 01 00 00 00       	mov    $0x1,%edx
80101d78:	83 e1 07             	and    $0x7,%ecx
    if ((bp->data[bi / 8] & m) == 0)
80101d7b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101d81:	83 c4 10             	add    $0x10,%esp
    m = 1 << (bi % 8);
80101d84:	d3 e2                	shl    %cl,%edx
    if ((bp->data[bi / 8] & m) == 0)
80101d86:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101d8b:	85 d1                	test   %edx,%ecx
80101d8d:	74 25                	je     80101db4 <bfree+0x64>
        panic("freeing free block");
    bp->data[bi / 8] &= ~m;
80101d8f:	f7 d2                	not    %edx
    log_write(bp);
80101d91:	83 ec 0c             	sub    $0xc,%esp
80101d94:	89 c6                	mov    %eax,%esi
    bp->data[bi / 8] &= ~m;
80101d96:	21 ca                	and    %ecx,%edx
80101d98:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
    log_write(bp);
80101d9c:	50                   	push   %eax
80101d9d:	e8 0e 1d 00 00       	call   80103ab0 <log_write>
    brelse(bp);
80101da2:	89 34 24             	mov    %esi,(%esp)
80101da5:	e8 46 e4 ff ff       	call   801001f0 <brelse>
}
80101daa:	83 c4 10             	add    $0x10,%esp
80101dad:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101db0:	5b                   	pop    %ebx
80101db1:	5e                   	pop    %esi
80101db2:	5d                   	pop    %ebp
80101db3:	c3                   	ret    
        panic("freeing free block");
80101db4:	83 ec 0c             	sub    $0xc,%esp
80101db7:	68 f7 7e 10 80       	push   $0x80107ef7
80101dbc:	e8 cf e5 ff ff       	call   80100390 <panic>
80101dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dcf:	90                   	nop

80101dd0 <balloc>:
balloc(uint dev) {
80101dd0:	55                   	push   %ebp
80101dd1:	89 e5                	mov    %esp,%ebp
80101dd3:	57                   	push   %edi
80101dd4:	56                   	push   %esi
80101dd5:	53                   	push   %ebx
80101dd6:	83 ec 1c             	sub    $0x1c,%esp
    for (b = 0; b < sb.size; b += BPB) {
80101dd9:	8b 0d 60 1f 11 80    	mov    0x80111f60,%ecx
balloc(uint dev) {
80101ddf:	89 45 d8             	mov    %eax,-0x28(%ebp)
    for (b = 0; b < sb.size; b += BPB) {
80101de2:	85 c9                	test   %ecx,%ecx
80101de4:	0f 84 87 00 00 00    	je     80101e71 <balloc+0xa1>
80101dea:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
        bp = bread(dev, BBLOCK(b, sb));
80101df1:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101df4:	83 ec 08             	sub    $0x8,%esp
80101df7:	89 f0                	mov    %esi,%eax
80101df9:	c1 f8 0c             	sar    $0xc,%eax
80101dfc:	03 05 78 1f 11 80    	add    0x80111f78,%eax
80101e02:	50                   	push   %eax
80101e03:	ff 75 d8             	pushl  -0x28(%ebp)
80101e06:	e8 c5 e2 ff ff       	call   801000d0 <bread>
80101e0b:	83 c4 10             	add    $0x10,%esp
80101e0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
80101e11:	a1 60 1f 11 80       	mov    0x80111f60,%eax
80101e16:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101e19:	31 c0                	xor    %eax,%eax
80101e1b:	eb 2f                	jmp    80101e4c <balloc+0x7c>
80101e1d:	8d 76 00             	lea    0x0(%esi),%esi
            m = 1 << (bi % 8);
80101e20:	89 c1                	mov    %eax,%ecx
80101e22:	bb 01 00 00 00       	mov    $0x1,%ebx
            if ((bp->data[bi / 8] & m) == 0) { // Is block free?
80101e27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            m = 1 << (bi % 8);
80101e2a:	83 e1 07             	and    $0x7,%ecx
80101e2d:	d3 e3                	shl    %cl,%ebx
            if ((bp->data[bi / 8] & m) == 0) { // Is block free?
80101e2f:	89 c1                	mov    %eax,%ecx
80101e31:	c1 f9 03             	sar    $0x3,%ecx
80101e34:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101e39:	89 fa                	mov    %edi,%edx
80101e3b:	85 df                	test   %ebx,%edi
80101e3d:	74 41                	je     80101e80 <balloc+0xb0>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
80101e3f:	83 c0 01             	add    $0x1,%eax
80101e42:	83 c6 01             	add    $0x1,%esi
80101e45:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101e4a:	74 05                	je     80101e51 <balloc+0x81>
80101e4c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
80101e4f:	77 cf                	ja     80101e20 <balloc+0x50>
        brelse(bp);
80101e51:	83 ec 0c             	sub    $0xc,%esp
80101e54:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e57:	e8 94 e3 ff ff       	call   801001f0 <brelse>
    for (b = 0; b < sb.size; b += BPB) {
80101e5c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101e63:	83 c4 10             	add    $0x10,%esp
80101e66:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e69:	39 05 60 1f 11 80    	cmp    %eax,0x80111f60
80101e6f:	77 80                	ja     80101df1 <balloc+0x21>
    panic("balloc: out of blocks");
80101e71:	83 ec 0c             	sub    $0xc,%esp
80101e74:	68 0a 7f 10 80       	push   $0x80107f0a
80101e79:	e8 12 e5 ff ff       	call   80100390 <panic>
80101e7e:	66 90                	xchg   %ax,%ax
                bp->data[bi / 8] |= m;         // Mark block in use.
80101e80:	8b 7d e4             	mov    -0x1c(%ebp),%edi
                log_write(bp);
80101e83:	83 ec 0c             	sub    $0xc,%esp
                bp->data[bi / 8] |= m;         // Mark block in use.
80101e86:	09 da                	or     %ebx,%edx
80101e88:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
                log_write(bp);
80101e8c:	57                   	push   %edi
80101e8d:	e8 1e 1c 00 00       	call   80103ab0 <log_write>
                brelse(bp);
80101e92:	89 3c 24             	mov    %edi,(%esp)
80101e95:	e8 56 e3 ff ff       	call   801001f0 <brelse>
    bp = bread(dev, bno);
80101e9a:	58                   	pop    %eax
80101e9b:	5a                   	pop    %edx
80101e9c:	56                   	push   %esi
80101e9d:	ff 75 d8             	pushl  -0x28(%ebp)
80101ea0:	e8 2b e2 ff ff       	call   801000d0 <bread>
    memset(bp->data, 0, BSIZE);
80101ea5:	83 c4 0c             	add    $0xc,%esp
    bp = bread(dev, bno);
80101ea8:	89 c3                	mov    %eax,%ebx
    memset(bp->data, 0, BSIZE);
80101eaa:	8d 40 5c             	lea    0x5c(%eax),%eax
80101ead:	68 00 02 00 00       	push   $0x200
80101eb2:	6a 00                	push   $0x0
80101eb4:	50                   	push   %eax
80101eb5:	e8 e6 33 00 00       	call   801052a0 <memset>
    log_write(bp);
80101eba:	89 1c 24             	mov    %ebx,(%esp)
80101ebd:	e8 ee 1b 00 00       	call   80103ab0 <log_write>
    brelse(bp);
80101ec2:	89 1c 24             	mov    %ebx,(%esp)
80101ec5:	e8 26 e3 ff ff       	call   801001f0 <brelse>
}
80101eca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ecd:	89 f0                	mov    %esi,%eax
80101ecf:	5b                   	pop    %ebx
80101ed0:	5e                   	pop    %esi
80101ed1:	5f                   	pop    %edi
80101ed2:	5d                   	pop    %ebp
80101ed3:	c3                   	ret    
80101ed4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101edb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101edf:	90                   	nop

80101ee0 <iget>:

// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum) {
80101ee0:	55                   	push   %ebp
80101ee1:	89 e5                	mov    %esp,%ebp
80101ee3:	57                   	push   %edi
80101ee4:	89 c7                	mov    %eax,%edi
80101ee6:	56                   	push   %esi
    struct inode *ip, *empty;

    acquire(&icache.lock);

    // Is the inode already cached?
    empty = 0;
80101ee7:	31 f6                	xor    %esi,%esi
iget(uint dev, uint inum) {
80101ee9:	53                   	push   %ebx
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
80101eea:	bb b4 1f 11 80       	mov    $0x80111fb4,%ebx
iget(uint dev, uint inum) {
80101eef:	83 ec 28             	sub    $0x28,%esp
80101ef2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    acquire(&icache.lock);
80101ef5:	68 80 1f 11 80       	push   $0x80111f80
80101efa:	e8 91 32 00 00       	call   80105190 <acquire>
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
80101eff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    acquire(&icache.lock);
80101f02:	83 c4 10             	add    $0x10,%esp
80101f05:	eb 1b                	jmp    80101f22 <iget+0x42>
80101f07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0e:	66 90                	xchg   %ax,%ax
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
80101f10:	39 3b                	cmp    %edi,(%ebx)
80101f12:	74 6c                	je     80101f80 <iget+0xa0>
80101f14:	81 c3 90 00 00 00    	add    $0x90,%ebx
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
80101f1a:	81 fb d4 3b 11 80    	cmp    $0x80113bd4,%ebx
80101f20:	73 26                	jae    80101f48 <iget+0x68>
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
80101f22:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101f25:	85 c9                	test   %ecx,%ecx
80101f27:	7f e7                	jg     80101f10 <iget+0x30>
            ip->ref++;
            release(&icache.lock);
            return ip;
        }
        if (empty == 0 && ip->ref == 0) // Remember empty slot.
80101f29:	85 f6                	test   %esi,%esi
80101f2b:	75 e7                	jne    80101f14 <iget+0x34>
80101f2d:	89 d8                	mov    %ebx,%eax
80101f2f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101f35:	85 c9                	test   %ecx,%ecx
80101f37:	75 6e                	jne    80101fa7 <iget+0xc7>
80101f39:	89 c6                	mov    %eax,%esi
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
80101f3b:	81 fb d4 3b 11 80    	cmp    $0x80113bd4,%ebx
80101f41:	72 df                	jb     80101f22 <iget+0x42>
80101f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f47:	90                   	nop
            empty = ip;
    }

    // Recycle an inode cache entry.
    if (empty == 0)
80101f48:	85 f6                	test   %esi,%esi
80101f4a:	74 73                	je     80101fbf <iget+0xdf>
    ip = empty;
    ip->dev = dev;
    ip->inum = inum;
    ip->ref = 1;
    ip->valid = 0;
    release(&icache.lock);
80101f4c:	83 ec 0c             	sub    $0xc,%esp
    ip->dev = dev;
80101f4f:	89 3e                	mov    %edi,(%esi)
    ip->inum = inum;
80101f51:	89 56 04             	mov    %edx,0x4(%esi)
    ip->ref = 1;
80101f54:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
    ip->valid = 0;
80101f5b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
    release(&icache.lock);
80101f62:	68 80 1f 11 80       	push   $0x80111f80
80101f67:	e8 e4 32 00 00       	call   80105250 <release>

    return ip;
80101f6c:	83 c4 10             	add    $0x10,%esp
}
80101f6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f72:	89 f0                	mov    %esi,%eax
80101f74:	5b                   	pop    %ebx
80101f75:	5e                   	pop    %esi
80101f76:	5f                   	pop    %edi
80101f77:	5d                   	pop    %ebp
80101f78:	c3                   	ret    
80101f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
80101f80:	39 53 04             	cmp    %edx,0x4(%ebx)
80101f83:	75 8f                	jne    80101f14 <iget+0x34>
            release(&icache.lock);
80101f85:	83 ec 0c             	sub    $0xc,%esp
            ip->ref++;
80101f88:	83 c1 01             	add    $0x1,%ecx
            return ip;
80101f8b:	89 de                	mov    %ebx,%esi
            release(&icache.lock);
80101f8d:	68 80 1f 11 80       	push   $0x80111f80
            ip->ref++;
80101f92:	89 4b 08             	mov    %ecx,0x8(%ebx)
            release(&icache.lock);
80101f95:	e8 b6 32 00 00       	call   80105250 <release>
            return ip;
80101f9a:	83 c4 10             	add    $0x10,%esp
}
80101f9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fa0:	89 f0                	mov    %esi,%eax
80101fa2:	5b                   	pop    %ebx
80101fa3:	5e                   	pop    %esi
80101fa4:	5f                   	pop    %edi
80101fa5:	5d                   	pop    %ebp
80101fa6:	c3                   	ret    
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
80101fa7:	81 fb d4 3b 11 80    	cmp    $0x80113bd4,%ebx
80101fad:	73 10                	jae    80101fbf <iget+0xdf>
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
80101faf:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101fb2:	85 c9                	test   %ecx,%ecx
80101fb4:	0f 8f 56 ff ff ff    	jg     80101f10 <iget+0x30>
80101fba:	e9 6e ff ff ff       	jmp    80101f2d <iget+0x4d>
        panic("iget: no inodes");
80101fbf:	83 ec 0c             	sub    $0xc,%esp
80101fc2:	68 20 7f 10 80       	push   $0x80107f20
80101fc7:	e8 c4 e3 ff ff       	call   80100390 <panic>
80101fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101fd0 <bmap>:
//  listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode* ip, uint bn) {
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
80101fd3:	57                   	push   %edi
80101fd4:	56                   	push   %esi
80101fd5:	89 c6                	mov    %eax,%esi
80101fd7:	53                   	push   %ebx
80101fd8:	83 ec 1c             	sub    $0x1c,%esp
    uint addr, *a;
    struct buf* bp;

    if (bn < NDIRECT) {
80101fdb:	83 fa 0b             	cmp    $0xb,%edx
80101fde:	0f 86 84 00 00 00    	jbe    80102068 <bmap+0x98>
        if ((addr = ip->addrs[bn]) == 0)
            ip->addrs[bn] = addr = balloc(ip->dev);
        return addr;
    }
    bn -= NDIRECT;
80101fe4:	8d 5a f4             	lea    -0xc(%edx),%ebx

    if (bn < NINDIRECT) {
80101fe7:	83 fb 7f             	cmp    $0x7f,%ebx
80101fea:	0f 87 98 00 00 00    	ja     80102088 <bmap+0xb8>
        // Load indirect block, allocating if necessary.
        if ((addr = ip->addrs[NDIRECT]) == 0)
80101ff0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101ff6:	8b 16                	mov    (%esi),%edx
80101ff8:	85 c0                	test   %eax,%eax
80101ffa:	74 54                	je     80102050 <bmap+0x80>
            ip->addrs[NDIRECT] = addr = balloc(ip->dev);
        bp = bread(ip->dev, addr);
80101ffc:	83 ec 08             	sub    $0x8,%esp
80101fff:	50                   	push   %eax
80102000:	52                   	push   %edx
80102001:	e8 ca e0 ff ff       	call   801000d0 <bread>
        a = (uint*)bp->data;
        if ((addr = a[bn]) == 0) {
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
        bp = bread(ip->dev, addr);
8010200d:	89 c7                	mov    %eax,%edi
        if ((addr = a[bn]) == 0) {
8010200f:	8b 1a                	mov    (%edx),%ebx
80102011:	85 db                	test   %ebx,%ebx
80102013:	74 1b                	je     80102030 <bmap+0x60>
            a[bn] = addr = balloc(ip->dev);
            log_write(bp);
        }
        brelse(bp);
80102015:	83 ec 0c             	sub    $0xc,%esp
80102018:	57                   	push   %edi
80102019:	e8 d2 e1 ff ff       	call   801001f0 <brelse>
        return addr;
8010201e:	83 c4 10             	add    $0x10,%esp
    }

    panic("bmap: out of range");
}
80102021:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102024:	89 d8                	mov    %ebx,%eax
80102026:	5b                   	pop    %ebx
80102027:	5e                   	pop    %esi
80102028:	5f                   	pop    %edi
80102029:	5d                   	pop    %ebp
8010202a:	c3                   	ret    
8010202b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010202f:	90                   	nop
            a[bn] = addr = balloc(ip->dev);
80102030:	8b 06                	mov    (%esi),%eax
80102032:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102035:	e8 96 fd ff ff       	call   80101dd0 <balloc>
8010203a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            log_write(bp);
8010203d:	83 ec 0c             	sub    $0xc,%esp
            a[bn] = addr = balloc(ip->dev);
80102040:	89 c3                	mov    %eax,%ebx
80102042:	89 02                	mov    %eax,(%edx)
            log_write(bp);
80102044:	57                   	push   %edi
80102045:	e8 66 1a 00 00       	call   80103ab0 <log_write>
8010204a:	83 c4 10             	add    $0x10,%esp
8010204d:	eb c6                	jmp    80102015 <bmap+0x45>
8010204f:	90                   	nop
            ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80102050:	89 d0                	mov    %edx,%eax
80102052:	e8 79 fd ff ff       	call   80101dd0 <balloc>
80102057:	8b 16                	mov    (%esi),%edx
80102059:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010205f:	eb 9b                	jmp    80101ffc <bmap+0x2c>
80102061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if ((addr = ip->addrs[bn]) == 0)
80102068:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010206b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010206e:	85 db                	test   %ebx,%ebx
80102070:	75 af                	jne    80102021 <bmap+0x51>
            ip->addrs[bn] = addr = balloc(ip->dev);
80102072:	8b 00                	mov    (%eax),%eax
80102074:	e8 57 fd ff ff       	call   80101dd0 <balloc>
80102079:	89 47 5c             	mov    %eax,0x5c(%edi)
8010207c:	89 c3                	mov    %eax,%ebx
}
8010207e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102081:	89 d8                	mov    %ebx,%eax
80102083:	5b                   	pop    %ebx
80102084:	5e                   	pop    %esi
80102085:	5f                   	pop    %edi
80102086:	5d                   	pop    %ebp
80102087:	c3                   	ret    
    panic("bmap: out of range");
80102088:	83 ec 0c             	sub    $0xc,%esp
8010208b:	68 30 7f 10 80       	push   $0x80107f30
80102090:	e8 fb e2 ff ff       	call   80100390 <panic>
80102095:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010209c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020a0 <readsb>:
void readsb(int dev, struct superblock* sb) {
801020a0:	f3 0f 1e fb          	endbr32 
801020a4:	55                   	push   %ebp
801020a5:	89 e5                	mov    %esp,%ebp
801020a7:	56                   	push   %esi
801020a8:	53                   	push   %ebx
801020a9:	8b 75 0c             	mov    0xc(%ebp),%esi
    bp = bread(dev, 1);
801020ac:	83 ec 08             	sub    $0x8,%esp
801020af:	6a 01                	push   $0x1
801020b1:	ff 75 08             	pushl  0x8(%ebp)
801020b4:	e8 17 e0 ff ff       	call   801000d0 <bread>
    memmove(sb, bp->data, sizeof(*sb));
801020b9:	83 c4 0c             	add    $0xc,%esp
    bp = bread(dev, 1);
801020bc:	89 c3                	mov    %eax,%ebx
    memmove(sb, bp->data, sizeof(*sb));
801020be:	8d 40 5c             	lea    0x5c(%eax),%eax
801020c1:	6a 1c                	push   $0x1c
801020c3:	50                   	push   %eax
801020c4:	56                   	push   %esi
801020c5:	e8 76 32 00 00       	call   80105340 <memmove>
    brelse(bp);
801020ca:	89 5d 08             	mov    %ebx,0x8(%ebp)
801020cd:	83 c4 10             	add    $0x10,%esp
}
801020d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801020d3:	5b                   	pop    %ebx
801020d4:	5e                   	pop    %esi
801020d5:	5d                   	pop    %ebp
    brelse(bp);
801020d6:	e9 15 e1 ff ff       	jmp    801001f0 <brelse>
801020db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020df:	90                   	nop

801020e0 <iinit>:
void iinit(int dev) {
801020e0:	f3 0f 1e fb          	endbr32 
801020e4:	55                   	push   %ebp
801020e5:	89 e5                	mov    %esp,%ebp
801020e7:	53                   	push   %ebx
801020e8:	bb c0 1f 11 80       	mov    $0x80111fc0,%ebx
801020ed:	83 ec 0c             	sub    $0xc,%esp
    initlock(&icache.lock, "icache");
801020f0:	68 43 7f 10 80       	push   $0x80107f43
801020f5:	68 80 1f 11 80       	push   $0x80111f80
801020fa:	e8 11 2f 00 00       	call   80105010 <initlock>
    for (i = 0; i < NINODE; i++) {
801020ff:	83 c4 10             	add    $0x10,%esp
80102102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        initsleeplock(&icache.inode[i].lock, "inode");
80102108:	83 ec 08             	sub    $0x8,%esp
8010210b:	68 4a 7f 10 80       	push   $0x80107f4a
80102110:	53                   	push   %ebx
80102111:	81 c3 90 00 00 00    	add    $0x90,%ebx
80102117:	e8 b4 2d 00 00       	call   80104ed0 <initsleeplock>
    for (i = 0; i < NINODE; i++) {
8010211c:	83 c4 10             	add    $0x10,%esp
8010211f:	81 fb e0 3b 11 80    	cmp    $0x80113be0,%ebx
80102125:	75 e1                	jne    80102108 <iinit+0x28>
    readsb(dev, &sb);
80102127:	83 ec 08             	sub    $0x8,%esp
8010212a:	68 60 1f 11 80       	push   $0x80111f60
8010212f:	ff 75 08             	pushl  0x8(%ebp)
80102132:	e8 69 ff ff ff       	call   801020a0 <readsb>
    cprintf(
80102137:	ff 35 78 1f 11 80    	pushl  0x80111f78
8010213d:	ff 35 74 1f 11 80    	pushl  0x80111f74
80102143:	ff 35 70 1f 11 80    	pushl  0x80111f70
80102149:	ff 35 6c 1f 11 80    	pushl  0x80111f6c
8010214f:	ff 35 68 1f 11 80    	pushl  0x80111f68
80102155:	ff 35 64 1f 11 80    	pushl  0x80111f64
8010215b:	ff 35 60 1f 11 80    	pushl  0x80111f60
80102161:	68 b0 7f 10 80       	push   $0x80107fb0
80102166:	e8 55 e6 ff ff       	call   801007c0 <cprintf>
}
8010216b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010216e:	83 c4 30             	add    $0x30,%esp
80102171:	c9                   	leave  
80102172:	c3                   	ret    
80102173:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010217a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102180 <ialloc>:
ialloc(uint dev, short type) {
80102180:	f3 0f 1e fb          	endbr32 
80102184:	55                   	push   %ebp
80102185:	89 e5                	mov    %esp,%ebp
80102187:	57                   	push   %edi
80102188:	56                   	push   %esi
80102189:	53                   	push   %ebx
8010218a:	83 ec 1c             	sub    $0x1c,%esp
8010218d:	8b 45 0c             	mov    0xc(%ebp),%eax
    for (inum = 1; inum < sb.ninodes; inum++) {
80102190:	83 3d 68 1f 11 80 01 	cmpl   $0x1,0x80111f68
ialloc(uint dev, short type) {
80102197:	8b 75 08             	mov    0x8(%ebp),%esi
8010219a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for (inum = 1; inum < sb.ninodes; inum++) {
8010219d:	0f 86 8d 00 00 00    	jbe    80102230 <ialloc+0xb0>
801021a3:	bf 01 00 00 00       	mov    $0x1,%edi
801021a8:	eb 1d                	jmp    801021c7 <ialloc+0x47>
801021aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        brelse(bp);
801021b0:	83 ec 0c             	sub    $0xc,%esp
    for (inum = 1; inum < sb.ninodes; inum++) {
801021b3:	83 c7 01             	add    $0x1,%edi
        brelse(bp);
801021b6:	53                   	push   %ebx
801021b7:	e8 34 e0 ff ff       	call   801001f0 <brelse>
    for (inum = 1; inum < sb.ninodes; inum++) {
801021bc:	83 c4 10             	add    $0x10,%esp
801021bf:	3b 3d 68 1f 11 80    	cmp    0x80111f68,%edi
801021c5:	73 69                	jae    80102230 <ialloc+0xb0>
        bp = bread(dev, IBLOCK(inum, sb));
801021c7:	89 f8                	mov    %edi,%eax
801021c9:	83 ec 08             	sub    $0x8,%esp
801021cc:	c1 e8 03             	shr    $0x3,%eax
801021cf:	03 05 74 1f 11 80    	add    0x80111f74,%eax
801021d5:	50                   	push   %eax
801021d6:	56                   	push   %esi
801021d7:	e8 f4 de ff ff       	call   801000d0 <bread>
        if (dip->type == 0) { // a free inode
801021dc:	83 c4 10             	add    $0x10,%esp
        bp = bread(dev, IBLOCK(inum, sb));
801021df:	89 c3                	mov    %eax,%ebx
        dip = (struct dinode*)bp->data + inum % IPB;
801021e1:	89 f8                	mov    %edi,%eax
801021e3:	83 e0 07             	and    $0x7,%eax
801021e6:	c1 e0 06             	shl    $0x6,%eax
801021e9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
        if (dip->type == 0) { // a free inode
801021ed:	66 83 39 00          	cmpw   $0x0,(%ecx)
801021f1:	75 bd                	jne    801021b0 <ialloc+0x30>
            memset(dip, 0, sizeof(*dip));
801021f3:	83 ec 04             	sub    $0x4,%esp
801021f6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801021f9:	6a 40                	push   $0x40
801021fb:	6a 00                	push   $0x0
801021fd:	51                   	push   %ecx
801021fe:	e8 9d 30 00 00       	call   801052a0 <memset>
            dip->type = type;
80102203:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80102207:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010220a:	66 89 01             	mov    %ax,(%ecx)
            log_write(bp); // mark it allocated on the disk
8010220d:	89 1c 24             	mov    %ebx,(%esp)
80102210:	e8 9b 18 00 00       	call   80103ab0 <log_write>
            brelse(bp);
80102215:	89 1c 24             	mov    %ebx,(%esp)
80102218:	e8 d3 df ff ff       	call   801001f0 <brelse>
            return iget(dev, inum);
8010221d:	83 c4 10             	add    $0x10,%esp
}
80102220:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return iget(dev, inum);
80102223:	89 fa                	mov    %edi,%edx
}
80102225:	5b                   	pop    %ebx
            return iget(dev, inum);
80102226:	89 f0                	mov    %esi,%eax
}
80102228:	5e                   	pop    %esi
80102229:	5f                   	pop    %edi
8010222a:	5d                   	pop    %ebp
            return iget(dev, inum);
8010222b:	e9 b0 fc ff ff       	jmp    80101ee0 <iget>
    panic("ialloc: no inodes");
80102230:	83 ec 0c             	sub    $0xc,%esp
80102233:	68 50 7f 10 80       	push   $0x80107f50
80102238:	e8 53 e1 ff ff       	call   80100390 <panic>
8010223d:	8d 76 00             	lea    0x0(%esi),%esi

80102240 <iupdate>:
void iupdate(struct inode* ip) {
80102240:	f3 0f 1e fb          	endbr32 
80102244:	55                   	push   %ebp
80102245:	89 e5                	mov    %esp,%ebp
80102247:	56                   	push   %esi
80102248:	53                   	push   %ebx
80102249:	8b 5d 08             	mov    0x8(%ebp),%ebx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010224c:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010224f:	83 c3 5c             	add    $0x5c,%ebx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102252:	83 ec 08             	sub    $0x8,%esp
80102255:	c1 e8 03             	shr    $0x3,%eax
80102258:	03 05 74 1f 11 80    	add    0x80111f74,%eax
8010225e:	50                   	push   %eax
8010225f:	ff 73 a4             	pushl  -0x5c(%ebx)
80102262:	e8 69 de ff ff       	call   801000d0 <bread>
    dip->type = ip->type;
80102267:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010226b:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010226e:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum % IPB;
80102270:	8b 43 a8             	mov    -0x58(%ebx),%eax
80102273:	83 e0 07             	and    $0x7,%eax
80102276:	c1 e0 06             	shl    $0x6,%eax
80102279:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    dip->type = ip->type;
8010227d:	66 89 10             	mov    %dx,(%eax)
    dip->major = ip->major;
80102280:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102284:	83 c0 0c             	add    $0xc,%eax
    dip->major = ip->major;
80102287:	66 89 50 f6          	mov    %dx,-0xa(%eax)
    dip->minor = ip->minor;
8010228b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010228f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
    dip->nlink = ip->nlink;
80102293:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80102297:	66 89 50 fa          	mov    %dx,-0x6(%eax)
    dip->size = ip->size;
8010229b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010229e:	89 50 fc             	mov    %edx,-0x4(%eax)
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801022a1:	6a 34                	push   $0x34
801022a3:	53                   	push   %ebx
801022a4:	50                   	push   %eax
801022a5:	e8 96 30 00 00       	call   80105340 <memmove>
    log_write(bp);
801022aa:	89 34 24             	mov    %esi,(%esp)
801022ad:	e8 fe 17 00 00       	call   80103ab0 <log_write>
    brelse(bp);
801022b2:	89 75 08             	mov    %esi,0x8(%ebp)
801022b5:	83 c4 10             	add    $0x10,%esp
}
801022b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022bb:	5b                   	pop    %ebx
801022bc:	5e                   	pop    %esi
801022bd:	5d                   	pop    %ebp
    brelse(bp);
801022be:	e9 2d df ff ff       	jmp    801001f0 <brelse>
801022c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801022d0 <idup>:
idup(struct inode* ip) {
801022d0:	f3 0f 1e fb          	endbr32 
801022d4:	55                   	push   %ebp
801022d5:	89 e5                	mov    %esp,%ebp
801022d7:	53                   	push   %ebx
801022d8:	83 ec 10             	sub    $0x10,%esp
801022db:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&icache.lock);
801022de:	68 80 1f 11 80       	push   $0x80111f80
801022e3:	e8 a8 2e 00 00       	call   80105190 <acquire>
    ip->ref++;
801022e8:	83 43 08 01          	addl   $0x1,0x8(%ebx)
    release(&icache.lock);
801022ec:	c7 04 24 80 1f 11 80 	movl   $0x80111f80,(%esp)
801022f3:	e8 58 2f 00 00       	call   80105250 <release>
}
801022f8:	89 d8                	mov    %ebx,%eax
801022fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022fd:	c9                   	leave  
801022fe:	c3                   	ret    
801022ff:	90                   	nop

80102300 <ilock>:
void ilock(struct inode* ip) {
80102300:	f3 0f 1e fb          	endbr32 
80102304:	55                   	push   %ebp
80102305:	89 e5                	mov    %esp,%ebp
80102307:	56                   	push   %esi
80102308:	53                   	push   %ebx
80102309:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (ip == 0 || ip->ref < 1)
8010230c:	85 db                	test   %ebx,%ebx
8010230e:	0f 84 b3 00 00 00    	je     801023c7 <ilock+0xc7>
80102314:	8b 53 08             	mov    0x8(%ebx),%edx
80102317:	85 d2                	test   %edx,%edx
80102319:	0f 8e a8 00 00 00    	jle    801023c7 <ilock+0xc7>
    acquiresleep(&ip->lock);
8010231f:	83 ec 0c             	sub    $0xc,%esp
80102322:	8d 43 0c             	lea    0xc(%ebx),%eax
80102325:	50                   	push   %eax
80102326:	e8 e5 2b 00 00       	call   80104f10 <acquiresleep>
    if (ip->valid == 0) {
8010232b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010232e:	83 c4 10             	add    $0x10,%esp
80102331:	85 c0                	test   %eax,%eax
80102333:	74 0b                	je     80102340 <ilock+0x40>
}
80102335:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102338:	5b                   	pop    %ebx
80102339:	5e                   	pop    %esi
8010233a:	5d                   	pop    %ebp
8010233b:	c3                   	ret    
8010233c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102340:	8b 43 04             	mov    0x4(%ebx),%eax
80102343:	83 ec 08             	sub    $0x8,%esp
80102346:	c1 e8 03             	shr    $0x3,%eax
80102349:	03 05 74 1f 11 80    	add    0x80111f74,%eax
8010234f:	50                   	push   %eax
80102350:	ff 33                	pushl  (%ebx)
80102352:	e8 79 dd ff ff       	call   801000d0 <bread>
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102357:	83 c4 0c             	add    $0xc,%esp
        bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010235a:	89 c6                	mov    %eax,%esi
        dip = (struct dinode*)bp->data + ip->inum % IPB;
8010235c:	8b 43 04             	mov    0x4(%ebx),%eax
8010235f:	83 e0 07             	and    $0x7,%eax
80102362:	c1 e0 06             	shl    $0x6,%eax
80102365:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
        ip->type = dip->type;
80102369:	0f b7 10             	movzwl (%eax),%edx
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010236c:	83 c0 0c             	add    $0xc,%eax
        ip->type = dip->type;
8010236f:	66 89 53 50          	mov    %dx,0x50(%ebx)
        ip->major = dip->major;
80102373:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80102377:	66 89 53 52          	mov    %dx,0x52(%ebx)
        ip->minor = dip->minor;
8010237b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010237f:	66 89 53 54          	mov    %dx,0x54(%ebx)
        ip->nlink = dip->nlink;
80102383:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80102387:	66 89 53 56          	mov    %dx,0x56(%ebx)
        ip->size = dip->size;
8010238b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010238e:	89 53 58             	mov    %edx,0x58(%ebx)
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102391:	6a 34                	push   $0x34
80102393:	50                   	push   %eax
80102394:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102397:	50                   	push   %eax
80102398:	e8 a3 2f 00 00       	call   80105340 <memmove>
        brelse(bp);
8010239d:	89 34 24             	mov    %esi,(%esp)
801023a0:	e8 4b de ff ff       	call   801001f0 <brelse>
        if (ip->type == 0)
801023a5:	83 c4 10             	add    $0x10,%esp
801023a8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
        ip->valid = 1;
801023ad:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
        if (ip->type == 0)
801023b4:	0f 85 7b ff ff ff    	jne    80102335 <ilock+0x35>
            panic("ilock: no type");
801023ba:	83 ec 0c             	sub    $0xc,%esp
801023bd:	68 68 7f 10 80       	push   $0x80107f68
801023c2:	e8 c9 df ff ff       	call   80100390 <panic>
        panic("ilock");
801023c7:	83 ec 0c             	sub    $0xc,%esp
801023ca:	68 62 7f 10 80       	push   $0x80107f62
801023cf:	e8 bc df ff ff       	call   80100390 <panic>
801023d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023df:	90                   	nop

801023e0 <iunlock>:
void iunlock(struct inode* ip) {
801023e0:	f3 0f 1e fb          	endbr32 
801023e4:	55                   	push   %ebp
801023e5:	89 e5                	mov    %esp,%ebp
801023e7:	56                   	push   %esi
801023e8:	53                   	push   %ebx
801023e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801023ec:	85 db                	test   %ebx,%ebx
801023ee:	74 28                	je     80102418 <iunlock+0x38>
801023f0:	83 ec 0c             	sub    $0xc,%esp
801023f3:	8d 73 0c             	lea    0xc(%ebx),%esi
801023f6:	56                   	push   %esi
801023f7:	e8 b4 2b 00 00       	call   80104fb0 <holdingsleep>
801023fc:	83 c4 10             	add    $0x10,%esp
801023ff:	85 c0                	test   %eax,%eax
80102401:	74 15                	je     80102418 <iunlock+0x38>
80102403:	8b 43 08             	mov    0x8(%ebx),%eax
80102406:	85 c0                	test   %eax,%eax
80102408:	7e 0e                	jle    80102418 <iunlock+0x38>
    releasesleep(&ip->lock);
8010240a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010240d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102410:	5b                   	pop    %ebx
80102411:	5e                   	pop    %esi
80102412:	5d                   	pop    %ebp
    releasesleep(&ip->lock);
80102413:	e9 58 2b 00 00       	jmp    80104f70 <releasesleep>
        panic("iunlock");
80102418:	83 ec 0c             	sub    $0xc,%esp
8010241b:	68 77 7f 10 80       	push   $0x80107f77
80102420:	e8 6b df ff ff       	call   80100390 <panic>
80102425:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010242c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102430 <iput>:
void iput(struct inode* ip) {
80102430:	f3 0f 1e fb          	endbr32 
80102434:	55                   	push   %ebp
80102435:	89 e5                	mov    %esp,%ebp
80102437:	57                   	push   %edi
80102438:	56                   	push   %esi
80102439:	53                   	push   %ebx
8010243a:	83 ec 28             	sub    $0x28,%esp
8010243d:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquiresleep(&ip->lock);
80102440:	8d 7b 0c             	lea    0xc(%ebx),%edi
80102443:	57                   	push   %edi
80102444:	e8 c7 2a 00 00       	call   80104f10 <acquiresleep>
    if (ip->valid && ip->nlink == 0) {
80102449:	8b 53 4c             	mov    0x4c(%ebx),%edx
8010244c:	83 c4 10             	add    $0x10,%esp
8010244f:	85 d2                	test   %edx,%edx
80102451:	74 07                	je     8010245a <iput+0x2a>
80102453:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102458:	74 36                	je     80102490 <iput+0x60>
    releasesleep(&ip->lock);
8010245a:	83 ec 0c             	sub    $0xc,%esp
8010245d:	57                   	push   %edi
8010245e:	e8 0d 2b 00 00       	call   80104f70 <releasesleep>
    acquire(&icache.lock);
80102463:	c7 04 24 80 1f 11 80 	movl   $0x80111f80,(%esp)
8010246a:	e8 21 2d 00 00       	call   80105190 <acquire>
    ip->ref--;
8010246f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
    release(&icache.lock);
80102473:	83 c4 10             	add    $0x10,%esp
80102476:	c7 45 08 80 1f 11 80 	movl   $0x80111f80,0x8(%ebp)
}
8010247d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102480:	5b                   	pop    %ebx
80102481:	5e                   	pop    %esi
80102482:	5f                   	pop    %edi
80102483:	5d                   	pop    %ebp
    release(&icache.lock);
80102484:	e9 c7 2d 00 00       	jmp    80105250 <release>
80102489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        acquire(&icache.lock);
80102490:	83 ec 0c             	sub    $0xc,%esp
80102493:	68 80 1f 11 80       	push   $0x80111f80
80102498:	e8 f3 2c 00 00       	call   80105190 <acquire>
        int r = ip->ref;
8010249d:	8b 73 08             	mov    0x8(%ebx),%esi
        release(&icache.lock);
801024a0:	c7 04 24 80 1f 11 80 	movl   $0x80111f80,(%esp)
801024a7:	e8 a4 2d 00 00       	call   80105250 <release>
        if (r == 1) {
801024ac:	83 c4 10             	add    $0x10,%esp
801024af:	83 fe 01             	cmp    $0x1,%esi
801024b2:	75 a6                	jne    8010245a <iput+0x2a>
801024b4:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801024ba:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801024bd:	8d 73 5c             	lea    0x5c(%ebx),%esi
801024c0:	89 cf                	mov    %ecx,%edi
801024c2:	eb 0b                	jmp    801024cf <iput+0x9f>
801024c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
itrunc(struct inode* ip) {
    int i, j;
    struct buf* bp;
    uint* a;

    for (i = 0; i < NDIRECT; i++) {
801024c8:	83 c6 04             	add    $0x4,%esi
801024cb:	39 fe                	cmp    %edi,%esi
801024cd:	74 19                	je     801024e8 <iput+0xb8>
        if (ip->addrs[i]) {
801024cf:	8b 16                	mov    (%esi),%edx
801024d1:	85 d2                	test   %edx,%edx
801024d3:	74 f3                	je     801024c8 <iput+0x98>
            bfree(ip->dev, ip->addrs[i]);
801024d5:	8b 03                	mov    (%ebx),%eax
801024d7:	e8 74 f8 ff ff       	call   80101d50 <bfree>
            ip->addrs[i] = 0;
801024dc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801024e2:	eb e4                	jmp    801024c8 <iput+0x98>
801024e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        }
    }

    if (ip->addrs[NDIRECT]) {
801024e8:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801024ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801024f1:	85 c0                	test   %eax,%eax
801024f3:	75 33                	jne    80102528 <iput+0xf8>
        bfree(ip->dev, ip->addrs[NDIRECT]);
        ip->addrs[NDIRECT] = 0;
    }

    ip->size = 0;
    iupdate(ip);
801024f5:	83 ec 0c             	sub    $0xc,%esp
    ip->size = 0;
801024f8:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
    iupdate(ip);
801024ff:	53                   	push   %ebx
80102500:	e8 3b fd ff ff       	call   80102240 <iupdate>
            ip->type = 0;
80102505:	31 c0                	xor    %eax,%eax
80102507:	66 89 43 50          	mov    %ax,0x50(%ebx)
            iupdate(ip);
8010250b:	89 1c 24             	mov    %ebx,(%esp)
8010250e:	e8 2d fd ff ff       	call   80102240 <iupdate>
            ip->valid = 0;
80102513:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010251a:	83 c4 10             	add    $0x10,%esp
8010251d:	e9 38 ff ff ff       	jmp    8010245a <iput+0x2a>
80102522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        bp = bread(ip->dev, ip->addrs[NDIRECT]);
80102528:	83 ec 08             	sub    $0x8,%esp
8010252b:	50                   	push   %eax
8010252c:	ff 33                	pushl  (%ebx)
8010252e:	e8 9d db ff ff       	call   801000d0 <bread>
80102533:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102536:	83 c4 10             	add    $0x10,%esp
80102539:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010253f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < NINDIRECT; j++) {
80102542:	8d 70 5c             	lea    0x5c(%eax),%esi
80102545:	89 cf                	mov    %ecx,%edi
80102547:	eb 0e                	jmp    80102557 <iput+0x127>
80102549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102550:	83 c6 04             	add    $0x4,%esi
80102553:	39 f7                	cmp    %esi,%edi
80102555:	74 19                	je     80102570 <iput+0x140>
            if (a[j])
80102557:	8b 16                	mov    (%esi),%edx
80102559:	85 d2                	test   %edx,%edx
8010255b:	74 f3                	je     80102550 <iput+0x120>
                bfree(ip->dev, a[j]);
8010255d:	8b 03                	mov    (%ebx),%eax
8010255f:	e8 ec f7 ff ff       	call   80101d50 <bfree>
80102564:	eb ea                	jmp    80102550 <iput+0x120>
80102566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010256d:	8d 76 00             	lea    0x0(%esi),%esi
        brelse(bp);
80102570:	83 ec 0c             	sub    $0xc,%esp
80102573:	ff 75 e4             	pushl  -0x1c(%ebp)
80102576:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102579:	e8 72 dc ff ff       	call   801001f0 <brelse>
        bfree(ip->dev, ip->addrs[NDIRECT]);
8010257e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80102584:	8b 03                	mov    (%ebx),%eax
80102586:	e8 c5 f7 ff ff       	call   80101d50 <bfree>
        ip->addrs[NDIRECT] = 0;
8010258b:	83 c4 10             	add    $0x10,%esp
8010258e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80102595:	00 00 00 
80102598:	e9 58 ff ff ff       	jmp    801024f5 <iput+0xc5>
8010259d:	8d 76 00             	lea    0x0(%esi),%esi

801025a0 <iunlockput>:
void iunlockput(struct inode* ip) {
801025a0:	f3 0f 1e fb          	endbr32 
801025a4:	55                   	push   %ebp
801025a5:	89 e5                	mov    %esp,%ebp
801025a7:	53                   	push   %ebx
801025a8:	83 ec 10             	sub    $0x10,%esp
801025ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
    iunlock(ip);
801025ae:	53                   	push   %ebx
801025af:	e8 2c fe ff ff       	call   801023e0 <iunlock>
    iput(ip);
801025b4:	89 5d 08             	mov    %ebx,0x8(%ebp)
801025b7:	83 c4 10             	add    $0x10,%esp
}
801025ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025bd:	c9                   	leave  
    iput(ip);
801025be:	e9 6d fe ff ff       	jmp    80102430 <iput>
801025c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801025d0 <stati>:
}

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode* ip, struct stat* st) {
801025d0:	f3 0f 1e fb          	endbr32 
801025d4:	55                   	push   %ebp
801025d5:	89 e5                	mov    %esp,%ebp
801025d7:	8b 55 08             	mov    0x8(%ebp),%edx
801025da:	8b 45 0c             	mov    0xc(%ebp),%eax
    st->dev = ip->dev;
801025dd:	8b 0a                	mov    (%edx),%ecx
801025df:	89 48 04             	mov    %ecx,0x4(%eax)
    st->ino = ip->inum;
801025e2:	8b 4a 04             	mov    0x4(%edx),%ecx
801025e5:	89 48 08             	mov    %ecx,0x8(%eax)
    st->type = ip->type;
801025e8:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801025ec:	66 89 08             	mov    %cx,(%eax)
    st->nlink = ip->nlink;
801025ef:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801025f3:	66 89 48 0c          	mov    %cx,0xc(%eax)
    st->size = ip->size;
801025f7:	8b 52 58             	mov    0x58(%edx),%edx
801025fa:	89 50 10             	mov    %edx,0x10(%eax)
}
801025fd:	5d                   	pop    %ebp
801025fe:	c3                   	ret    
801025ff:	90                   	nop

80102600 <readi>:

// PAGEBREAK!
//  Read data from inode.
//  Caller must hold ip->lock.
int readi(struct inode* ip, char* dst, uint off, uint n) {
80102600:	f3 0f 1e fb          	endbr32 
80102604:	55                   	push   %ebp
80102605:	89 e5                	mov    %esp,%ebp
80102607:	57                   	push   %edi
80102608:	56                   	push   %esi
80102609:	53                   	push   %ebx
8010260a:	83 ec 1c             	sub    $0x1c,%esp
8010260d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102610:	8b 45 08             	mov    0x8(%ebp),%eax
80102613:	8b 75 10             	mov    0x10(%ebp),%esi
80102616:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102619:	8b 7d 14             	mov    0x14(%ebp),%edi
    uint tot, m;
    struct buf* bp;

    if (ip->type == T_DEV) {
8010261c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
int readi(struct inode* ip, char* dst, uint off, uint n) {
80102621:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102624:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    if (ip->type == T_DEV) {
80102627:	0f 84 a3 00 00 00    	je     801026d0 <readi+0xd0>
        if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
            return -1;
        return devsw[ip->major].read(ip, dst, n);
    }

    if (off > ip->size || off + n < off)
8010262d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102630:	8b 40 58             	mov    0x58(%eax),%eax
80102633:	39 c6                	cmp    %eax,%esi
80102635:	0f 87 b6 00 00 00    	ja     801026f1 <readi+0xf1>
8010263b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010263e:	31 c9                	xor    %ecx,%ecx
80102640:	89 da                	mov    %ebx,%edx
80102642:	01 f2                	add    %esi,%edx
80102644:	0f 92 c1             	setb   %cl
80102647:	89 cf                	mov    %ecx,%edi
80102649:	0f 82 a2 00 00 00    	jb     801026f1 <readi+0xf1>
        return -1;
    if (off + n > ip->size)
        n = ip->size - off;
8010264f:	89 c1                	mov    %eax,%ecx
80102651:	29 f1                	sub    %esi,%ecx
80102653:	39 d0                	cmp    %edx,%eax
80102655:	0f 43 cb             	cmovae %ebx,%ecx
80102658:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
8010265b:	85 c9                	test   %ecx,%ecx
8010265d:	74 63                	je     801026c2 <readi+0xc2>
8010265f:	90                   	nop
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
80102660:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102663:	89 f2                	mov    %esi,%edx
80102665:	c1 ea 09             	shr    $0x9,%edx
80102668:	89 d8                	mov    %ebx,%eax
8010266a:	e8 61 f9 ff ff       	call   80101fd0 <bmap>
8010266f:	83 ec 08             	sub    $0x8,%esp
80102672:	50                   	push   %eax
80102673:	ff 33                	pushl  (%ebx)
80102675:	e8 56 da ff ff       	call   801000d0 <bread>
        m = min(n - tot, BSIZE - off % BSIZE);
8010267a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010267d:	b9 00 02 00 00       	mov    $0x200,%ecx
80102682:	83 c4 0c             	add    $0xc,%esp
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
80102685:	89 c2                	mov    %eax,%edx
        m = min(n - tot, BSIZE - off % BSIZE);
80102687:	89 f0                	mov    %esi,%eax
80102689:	25 ff 01 00 00       	and    $0x1ff,%eax
8010268e:	29 fb                	sub    %edi,%ebx
        memmove(dst, bp->data + off % BSIZE, m);
80102690:	89 55 dc             	mov    %edx,-0x24(%ebp)
        m = min(n - tot, BSIZE - off % BSIZE);
80102693:	29 c1                	sub    %eax,%ecx
        memmove(dst, bp->data + off % BSIZE, m);
80102695:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
        m = min(n - tot, BSIZE - off % BSIZE);
80102699:	39 d9                	cmp    %ebx,%ecx
8010269b:	0f 46 d9             	cmovbe %ecx,%ebx
        memmove(dst, bp->data + off % BSIZE, m);
8010269e:	53                   	push   %ebx
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
8010269f:	01 df                	add    %ebx,%edi
801026a1:	01 de                	add    %ebx,%esi
        memmove(dst, bp->data + off % BSIZE, m);
801026a3:	50                   	push   %eax
801026a4:	ff 75 e0             	pushl  -0x20(%ebp)
801026a7:	e8 94 2c 00 00       	call   80105340 <memmove>
        brelse(bp);
801026ac:	8b 55 dc             	mov    -0x24(%ebp),%edx
801026af:	89 14 24             	mov    %edx,(%esp)
801026b2:	e8 39 db ff ff       	call   801001f0 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
801026b7:	01 5d e0             	add    %ebx,-0x20(%ebp)
801026ba:	83 c4 10             	add    $0x10,%esp
801026bd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801026c0:	77 9e                	ja     80102660 <readi+0x60>
    }
    return n;
801026c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801026c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026c8:	5b                   	pop    %ebx
801026c9:	5e                   	pop    %esi
801026ca:	5f                   	pop    %edi
801026cb:	5d                   	pop    %ebp
801026cc:	c3                   	ret    
801026cd:	8d 76 00             	lea    0x0(%esi),%esi
        if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801026d0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801026d4:	66 83 f8 09          	cmp    $0x9,%ax
801026d8:	77 17                	ja     801026f1 <readi+0xf1>
801026da:	8b 04 c5 00 1f 11 80 	mov    -0x7feee100(,%eax,8),%eax
801026e1:	85 c0                	test   %eax,%eax
801026e3:	74 0c                	je     801026f1 <readi+0xf1>
        return devsw[ip->major].read(ip, dst, n);
801026e5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801026e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026eb:	5b                   	pop    %ebx
801026ec:	5e                   	pop    %esi
801026ed:	5f                   	pop    %edi
801026ee:	5d                   	pop    %ebp
        return devsw[ip->major].read(ip, dst, n);
801026ef:	ff e0                	jmp    *%eax
            return -1;
801026f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801026f6:	eb cd                	jmp    801026c5 <readi+0xc5>
801026f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ff:	90                   	nop

80102700 <writei>:

// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int writei(struct inode* ip, char* src, uint off, uint n) {
80102700:	f3 0f 1e fb          	endbr32 
80102704:	55                   	push   %ebp
80102705:	89 e5                	mov    %esp,%ebp
80102707:	57                   	push   %edi
80102708:	56                   	push   %esi
80102709:	53                   	push   %ebx
8010270a:	83 ec 1c             	sub    $0x1c,%esp
8010270d:	8b 45 08             	mov    0x8(%ebp),%eax
80102710:	8b 75 0c             	mov    0xc(%ebp),%esi
80102713:	8b 7d 14             	mov    0x14(%ebp),%edi
    uint tot, m;
    struct buf* bp;

    if (ip->type == T_DEV) {
80102716:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
int writei(struct inode* ip, char* src, uint off, uint n) {
8010271b:	89 75 dc             	mov    %esi,-0x24(%ebp)
8010271e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102721:	8b 75 10             	mov    0x10(%ebp),%esi
80102724:	89 7d e0             	mov    %edi,-0x20(%ebp)
    if (ip->type == T_DEV) {
80102727:	0f 84 b3 00 00 00    	je     801027e0 <writei+0xe0>
        if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
            return -1;
        return devsw[ip->major].write(ip, src, n);
    }

    if (off > ip->size || off + n < off)
8010272d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102730:	39 70 58             	cmp    %esi,0x58(%eax)
80102733:	0f 82 e3 00 00 00    	jb     8010281c <writei+0x11c>
        return -1;
    if (off + n > MAXFILE * BSIZE)
80102739:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010273c:	89 f8                	mov    %edi,%eax
8010273e:	01 f0                	add    %esi,%eax
80102740:	0f 82 d6 00 00 00    	jb     8010281c <writei+0x11c>
80102746:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010274b:	0f 87 cb 00 00 00    	ja     8010281c <writei+0x11c>
        return -1;

    for (tot = 0; tot < n; tot += m, off += m, src += m) {
80102751:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102758:	85 ff                	test   %edi,%edi
8010275a:	74 75                	je     801027d1 <writei+0xd1>
8010275c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
80102760:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102763:	89 f2                	mov    %esi,%edx
80102765:	c1 ea 09             	shr    $0x9,%edx
80102768:	89 f8                	mov    %edi,%eax
8010276a:	e8 61 f8 ff ff       	call   80101fd0 <bmap>
8010276f:	83 ec 08             	sub    $0x8,%esp
80102772:	50                   	push   %eax
80102773:	ff 37                	pushl  (%edi)
80102775:	e8 56 d9 ff ff       	call   801000d0 <bread>
        m = min(n - tot, BSIZE - off % BSIZE);
8010277a:	b9 00 02 00 00       	mov    $0x200,%ecx
8010277f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102782:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
80102785:	89 c7                	mov    %eax,%edi
        m = min(n - tot, BSIZE - off % BSIZE);
80102787:	89 f0                	mov    %esi,%eax
80102789:	83 c4 0c             	add    $0xc,%esp
8010278c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102791:	29 c1                	sub    %eax,%ecx
        memmove(bp->data + off % BSIZE, src, m);
80102793:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
        m = min(n - tot, BSIZE - off % BSIZE);
80102797:	39 d9                	cmp    %ebx,%ecx
80102799:	0f 46 d9             	cmovbe %ecx,%ebx
        memmove(bp->data + off % BSIZE, src, m);
8010279c:	53                   	push   %ebx
    for (tot = 0; tot < n; tot += m, off += m, src += m) {
8010279d:	01 de                	add    %ebx,%esi
        memmove(bp->data + off % BSIZE, src, m);
8010279f:	ff 75 dc             	pushl  -0x24(%ebp)
801027a2:	50                   	push   %eax
801027a3:	e8 98 2b 00 00       	call   80105340 <memmove>
        log_write(bp);
801027a8:	89 3c 24             	mov    %edi,(%esp)
801027ab:	e8 00 13 00 00       	call   80103ab0 <log_write>
        brelse(bp);
801027b0:	89 3c 24             	mov    %edi,(%esp)
801027b3:	e8 38 da ff ff       	call   801001f0 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, src += m) {
801027b8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
801027bb:	83 c4 10             	add    $0x10,%esp
801027be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801027c1:	01 5d dc             	add    %ebx,-0x24(%ebp)
801027c4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
801027c7:	77 97                	ja     80102760 <writei+0x60>
    }

    if (n > 0 && off > ip->size) {
801027c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801027cc:	3b 70 58             	cmp    0x58(%eax),%esi
801027cf:	77 37                	ja     80102808 <writei+0x108>
        ip->size = off;
        iupdate(ip);
    }
    return n;
801027d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
801027d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027d7:	5b                   	pop    %ebx
801027d8:	5e                   	pop    %esi
801027d9:	5f                   	pop    %edi
801027da:	5d                   	pop    %ebp
801027db:	c3                   	ret    
801027dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801027e0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801027e4:	66 83 f8 09          	cmp    $0x9,%ax
801027e8:	77 32                	ja     8010281c <writei+0x11c>
801027ea:	8b 04 c5 04 1f 11 80 	mov    -0x7feee0fc(,%eax,8),%eax
801027f1:	85 c0                	test   %eax,%eax
801027f3:	74 27                	je     8010281c <writei+0x11c>
        return devsw[ip->major].write(ip, src, n);
801027f5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801027f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027fb:	5b                   	pop    %ebx
801027fc:	5e                   	pop    %esi
801027fd:	5f                   	pop    %edi
801027fe:	5d                   	pop    %ebp
        return devsw[ip->major].write(ip, src, n);
801027ff:	ff e0                	jmp    *%eax
80102801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        ip->size = off;
80102808:	8b 45 d8             	mov    -0x28(%ebp),%eax
        iupdate(ip);
8010280b:	83 ec 0c             	sub    $0xc,%esp
        ip->size = off;
8010280e:	89 70 58             	mov    %esi,0x58(%eax)
        iupdate(ip);
80102811:	50                   	push   %eax
80102812:	e8 29 fa ff ff       	call   80102240 <iupdate>
80102817:	83 c4 10             	add    $0x10,%esp
8010281a:	eb b5                	jmp    801027d1 <writei+0xd1>
            return -1;
8010281c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102821:	eb b1                	jmp    801027d4 <writei+0xd4>
80102823:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010282a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102830 <namecmp>:

// PAGEBREAK!
//  Directories

int namecmp(const char* s, const char* t) {
80102830:	f3 0f 1e fb          	endbr32 
80102834:	55                   	push   %ebp
80102835:	89 e5                	mov    %esp,%ebp
80102837:	83 ec 0c             	sub    $0xc,%esp
    return strncmp(s, t, DIRSIZ);
8010283a:	6a 0e                	push   $0xe
8010283c:	ff 75 0c             	pushl  0xc(%ebp)
8010283f:	ff 75 08             	pushl  0x8(%ebp)
80102842:	e8 69 2b 00 00       	call   801053b0 <strncmp>
}
80102847:	c9                   	leave  
80102848:	c3                   	ret    
80102849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102850 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode* dp, char* name, uint* poff) {
80102850:	f3 0f 1e fb          	endbr32 
80102854:	55                   	push   %ebp
80102855:	89 e5                	mov    %esp,%ebp
80102857:	57                   	push   %edi
80102858:	56                   	push   %esi
80102859:	53                   	push   %ebx
8010285a:	83 ec 1c             	sub    $0x1c,%esp
8010285d:	8b 5d 08             	mov    0x8(%ebp),%ebx
    uint off, inum;
    struct dirent de;

    if (dp->type != T_DIR)
80102860:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102865:	0f 85 89 00 00 00    	jne    801028f4 <dirlookup+0xa4>
        panic("dirlookup not DIR");

    for (off = 0; off < dp->size; off += sizeof(de)) {
8010286b:	8b 53 58             	mov    0x58(%ebx),%edx
8010286e:	31 ff                	xor    %edi,%edi
80102870:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102873:	85 d2                	test   %edx,%edx
80102875:	74 42                	je     801028b9 <dirlookup+0x69>
80102877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010287e:	66 90                	xchg   %ax,%ax
        if (readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102880:	6a 10                	push   $0x10
80102882:	57                   	push   %edi
80102883:	56                   	push   %esi
80102884:	53                   	push   %ebx
80102885:	e8 76 fd ff ff       	call   80102600 <readi>
8010288a:	83 c4 10             	add    $0x10,%esp
8010288d:	83 f8 10             	cmp    $0x10,%eax
80102890:	75 55                	jne    801028e7 <dirlookup+0x97>
            panic("dirlookup read");
        if (de.inum == 0)
80102892:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102897:	74 18                	je     801028b1 <dirlookup+0x61>
    return strncmp(s, t, DIRSIZ);
80102899:	83 ec 04             	sub    $0x4,%esp
8010289c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010289f:	6a 0e                	push   $0xe
801028a1:	50                   	push   %eax
801028a2:	ff 75 0c             	pushl  0xc(%ebp)
801028a5:	e8 06 2b 00 00       	call   801053b0 <strncmp>
            continue;
        if (namecmp(name, de.name) == 0) {
801028aa:	83 c4 10             	add    $0x10,%esp
801028ad:	85 c0                	test   %eax,%eax
801028af:	74 17                	je     801028c8 <dirlookup+0x78>
    for (off = 0; off < dp->size; off += sizeof(de)) {
801028b1:	83 c7 10             	add    $0x10,%edi
801028b4:	3b 7b 58             	cmp    0x58(%ebx),%edi
801028b7:	72 c7                	jb     80102880 <dirlookup+0x30>
            return iget(dp->dev, inum);
        }
    }

    return 0;
}
801028b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801028bc:	31 c0                	xor    %eax,%eax
}
801028be:	5b                   	pop    %ebx
801028bf:	5e                   	pop    %esi
801028c0:	5f                   	pop    %edi
801028c1:	5d                   	pop    %ebp
801028c2:	c3                   	ret    
801028c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028c7:	90                   	nop
            if (poff)
801028c8:	8b 45 10             	mov    0x10(%ebp),%eax
801028cb:	85 c0                	test   %eax,%eax
801028cd:	74 05                	je     801028d4 <dirlookup+0x84>
                *poff = off;
801028cf:	8b 45 10             	mov    0x10(%ebp),%eax
801028d2:	89 38                	mov    %edi,(%eax)
            inum = de.inum;
801028d4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
            return iget(dp->dev, inum);
801028d8:	8b 03                	mov    (%ebx),%eax
801028da:	e8 01 f6 ff ff       	call   80101ee0 <iget>
}
801028df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801028e2:	5b                   	pop    %ebx
801028e3:	5e                   	pop    %esi
801028e4:	5f                   	pop    %edi
801028e5:	5d                   	pop    %ebp
801028e6:	c3                   	ret    
            panic("dirlookup read");
801028e7:	83 ec 0c             	sub    $0xc,%esp
801028ea:	68 91 7f 10 80       	push   $0x80107f91
801028ef:	e8 9c da ff ff       	call   80100390 <panic>
        panic("dirlookup not DIR");
801028f4:	83 ec 0c             	sub    $0xc,%esp
801028f7:	68 7f 7f 10 80       	push   $0x80107f7f
801028fc:	e8 8f da ff ff       	call   80100390 <panic>
80102901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102908:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290f:	90                   	nop

80102910 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char* path, int nameiparent, char* name) {
80102910:	55                   	push   %ebp
80102911:	89 e5                	mov    %esp,%ebp
80102913:	57                   	push   %edi
80102914:	56                   	push   %esi
80102915:	53                   	push   %ebx
80102916:	89 c3                	mov    %eax,%ebx
80102918:	83 ec 1c             	sub    $0x1c,%esp
    struct inode *ip, *next;

    if (*path == '/')
8010291b:	80 38 2f             	cmpb   $0x2f,(%eax)
namex(char* path, int nameiparent, char* name) {
8010291e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102921:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    if (*path == '/')
80102924:	0f 84 86 01 00 00    	je     80102ab0 <namex+0x1a0>
        ip = iget(ROOTDEV, ROOTINO);
    else
        ip = idup(myproc()->cwd);
8010292a:	e8 d1 1b 00 00       	call   80104500 <myproc>
    acquire(&icache.lock);
8010292f:	83 ec 0c             	sub    $0xc,%esp
80102932:	89 df                	mov    %ebx,%edi
        ip = idup(myproc()->cwd);
80102934:	8b 70 68             	mov    0x68(%eax),%esi
    acquire(&icache.lock);
80102937:	68 80 1f 11 80       	push   $0x80111f80
8010293c:	e8 4f 28 00 00       	call   80105190 <acquire>
    ip->ref++;
80102941:	83 46 08 01          	addl   $0x1,0x8(%esi)
    release(&icache.lock);
80102945:	c7 04 24 80 1f 11 80 	movl   $0x80111f80,(%esp)
8010294c:	e8 ff 28 00 00       	call   80105250 <release>
80102951:	83 c4 10             	add    $0x10,%esp
80102954:	eb 0d                	jmp    80102963 <namex+0x53>
80102956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010295d:	8d 76 00             	lea    0x0(%esi),%esi
        path++;
80102960:	83 c7 01             	add    $0x1,%edi
    while (*path == '/')
80102963:	0f b6 07             	movzbl (%edi),%eax
80102966:	3c 2f                	cmp    $0x2f,%al
80102968:	74 f6                	je     80102960 <namex+0x50>
    if (*path == 0)
8010296a:	84 c0                	test   %al,%al
8010296c:	0f 84 ee 00 00 00    	je     80102a60 <namex+0x150>
    while (*path != '/' && *path != 0)
80102972:	0f b6 07             	movzbl (%edi),%eax
80102975:	84 c0                	test   %al,%al
80102977:	0f 84 fb 00 00 00    	je     80102a78 <namex+0x168>
8010297d:	89 fb                	mov    %edi,%ebx
8010297f:	3c 2f                	cmp    $0x2f,%al
80102981:	0f 84 f1 00 00 00    	je     80102a78 <namex+0x168>
80102987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010298e:	66 90                	xchg   %ax,%ax
80102990:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
        path++;
80102994:	83 c3 01             	add    $0x1,%ebx
    while (*path != '/' && *path != 0)
80102997:	3c 2f                	cmp    $0x2f,%al
80102999:	74 04                	je     8010299f <namex+0x8f>
8010299b:	84 c0                	test   %al,%al
8010299d:	75 f1                	jne    80102990 <namex+0x80>
    len = path - s;
8010299f:	89 d8                	mov    %ebx,%eax
801029a1:	29 f8                	sub    %edi,%eax
    if (len >= DIRSIZ)
801029a3:	83 f8 0d             	cmp    $0xd,%eax
801029a6:	0f 8e 84 00 00 00    	jle    80102a30 <namex+0x120>
        memmove(name, s, DIRSIZ);
801029ac:	83 ec 04             	sub    $0x4,%esp
801029af:	6a 0e                	push   $0xe
801029b1:	57                   	push   %edi
        path++;
801029b2:	89 df                	mov    %ebx,%edi
        memmove(name, s, DIRSIZ);
801029b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801029b7:	e8 84 29 00 00       	call   80105340 <memmove>
801029bc:	83 c4 10             	add    $0x10,%esp
    while (*path == '/')
801029bf:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801029c2:	75 0c                	jne    801029d0 <namex+0xc0>
801029c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        path++;
801029c8:	83 c7 01             	add    $0x1,%edi
    while (*path == '/')
801029cb:	80 3f 2f             	cmpb   $0x2f,(%edi)
801029ce:	74 f8                	je     801029c8 <namex+0xb8>

    while ((path = skipelem(path, name)) != 0) {
        ilock(ip);
801029d0:	83 ec 0c             	sub    $0xc,%esp
801029d3:	56                   	push   %esi
801029d4:	e8 27 f9 ff ff       	call   80102300 <ilock>
        if (ip->type != T_DIR) {
801029d9:	83 c4 10             	add    $0x10,%esp
801029dc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801029e1:	0f 85 a1 00 00 00    	jne    80102a88 <namex+0x178>
            iunlockput(ip);
            return 0;
        }
        if (nameiparent && *path == '\0') {
801029e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801029ea:	85 d2                	test   %edx,%edx
801029ec:	74 09                	je     801029f7 <namex+0xe7>
801029ee:	80 3f 00             	cmpb   $0x0,(%edi)
801029f1:	0f 84 d9 00 00 00    	je     80102ad0 <namex+0x1c0>
            // Stop one level early.
            iunlock(ip);
            return ip;
        }
        if ((next = dirlookup(ip, name, 0)) == 0) {
801029f7:	83 ec 04             	sub    $0x4,%esp
801029fa:	6a 00                	push   $0x0
801029fc:	ff 75 e4             	pushl  -0x1c(%ebp)
801029ff:	56                   	push   %esi
80102a00:	e8 4b fe ff ff       	call   80102850 <dirlookup>
80102a05:	83 c4 10             	add    $0x10,%esp
80102a08:	89 c3                	mov    %eax,%ebx
80102a0a:	85 c0                	test   %eax,%eax
80102a0c:	74 7a                	je     80102a88 <namex+0x178>
    iunlock(ip);
80102a0e:	83 ec 0c             	sub    $0xc,%esp
80102a11:	56                   	push   %esi
80102a12:	e8 c9 f9 ff ff       	call   801023e0 <iunlock>
    iput(ip);
80102a17:	89 34 24             	mov    %esi,(%esp)
80102a1a:	89 de                	mov    %ebx,%esi
80102a1c:	e8 0f fa ff ff       	call   80102430 <iput>
80102a21:	83 c4 10             	add    $0x10,%esp
80102a24:	e9 3a ff ff ff       	jmp    80102963 <namex+0x53>
80102a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102a33:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80102a36:	89 4d dc             	mov    %ecx,-0x24(%ebp)
        memmove(name, s, len);
80102a39:	83 ec 04             	sub    $0x4,%esp
80102a3c:	50                   	push   %eax
80102a3d:	57                   	push   %edi
        name[len] = 0;
80102a3e:	89 df                	mov    %ebx,%edi
        memmove(name, s, len);
80102a40:	ff 75 e4             	pushl  -0x1c(%ebp)
80102a43:	e8 f8 28 00 00       	call   80105340 <memmove>
        name[len] = 0;
80102a48:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102a4b:	83 c4 10             	add    $0x10,%esp
80102a4e:	c6 00 00             	movb   $0x0,(%eax)
80102a51:	e9 69 ff ff ff       	jmp    801029bf <namex+0xaf>
80102a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a5d:	8d 76 00             	lea    0x0(%esi),%esi
            return 0;
        }
        iunlockput(ip);
        ip = next;
    }
    if (nameiparent) {
80102a60:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102a63:	85 c0                	test   %eax,%eax
80102a65:	0f 85 85 00 00 00    	jne    80102af0 <namex+0x1e0>
        iput(ip);
        return 0;
    }
    return ip;
}
80102a6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a6e:	89 f0                	mov    %esi,%eax
80102a70:	5b                   	pop    %ebx
80102a71:	5e                   	pop    %esi
80102a72:	5f                   	pop    %edi
80102a73:	5d                   	pop    %ebp
80102a74:	c3                   	ret    
80102a75:	8d 76 00             	lea    0x0(%esi),%esi
    while (*path != '/' && *path != 0)
80102a78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102a7b:	89 fb                	mov    %edi,%ebx
80102a7d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a80:	31 c0                	xor    %eax,%eax
80102a82:	eb b5                	jmp    80102a39 <namex+0x129>
80102a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlock(ip);
80102a88:	83 ec 0c             	sub    $0xc,%esp
80102a8b:	56                   	push   %esi
80102a8c:	e8 4f f9 ff ff       	call   801023e0 <iunlock>
    iput(ip);
80102a91:	89 34 24             	mov    %esi,(%esp)
            return 0;
80102a94:	31 f6                	xor    %esi,%esi
    iput(ip);
80102a96:	e8 95 f9 ff ff       	call   80102430 <iput>
            return 0;
80102a9b:	83 c4 10             	add    $0x10,%esp
}
80102a9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102aa1:	89 f0                	mov    %esi,%eax
80102aa3:	5b                   	pop    %ebx
80102aa4:	5e                   	pop    %esi
80102aa5:	5f                   	pop    %edi
80102aa6:	5d                   	pop    %ebp
80102aa7:	c3                   	ret    
80102aa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aaf:	90                   	nop
        ip = iget(ROOTDEV, ROOTINO);
80102ab0:	ba 01 00 00 00       	mov    $0x1,%edx
80102ab5:	b8 01 00 00 00       	mov    $0x1,%eax
80102aba:	89 df                	mov    %ebx,%edi
80102abc:	e8 1f f4 ff ff       	call   80101ee0 <iget>
80102ac1:	89 c6                	mov    %eax,%esi
80102ac3:	e9 9b fe ff ff       	jmp    80102963 <namex+0x53>
80102ac8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102acf:	90                   	nop
            iunlock(ip);
80102ad0:	83 ec 0c             	sub    $0xc,%esp
80102ad3:	56                   	push   %esi
80102ad4:	e8 07 f9 ff ff       	call   801023e0 <iunlock>
            return ip;
80102ad9:	83 c4 10             	add    $0x10,%esp
}
80102adc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102adf:	89 f0                	mov    %esi,%eax
80102ae1:	5b                   	pop    %ebx
80102ae2:	5e                   	pop    %esi
80102ae3:	5f                   	pop    %edi
80102ae4:	5d                   	pop    %ebp
80102ae5:	c3                   	ret    
80102ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aed:	8d 76 00             	lea    0x0(%esi),%esi
        iput(ip);
80102af0:	83 ec 0c             	sub    $0xc,%esp
80102af3:	56                   	push   %esi
        return 0;
80102af4:	31 f6                	xor    %esi,%esi
        iput(ip);
80102af6:	e8 35 f9 ff ff       	call   80102430 <iput>
        return 0;
80102afb:	83 c4 10             	add    $0x10,%esp
80102afe:	e9 68 ff ff ff       	jmp    80102a6b <namex+0x15b>
80102b03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b10 <dirlink>:
int dirlink(struct inode* dp, char* name, uint inum) {
80102b10:	f3 0f 1e fb          	endbr32 
80102b14:	55                   	push   %ebp
80102b15:	89 e5                	mov    %esp,%ebp
80102b17:	57                   	push   %edi
80102b18:	56                   	push   %esi
80102b19:	53                   	push   %ebx
80102b1a:	83 ec 20             	sub    $0x20,%esp
80102b1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if ((ip = dirlookup(dp, name, 0)) != 0) {
80102b20:	6a 00                	push   $0x0
80102b22:	ff 75 0c             	pushl  0xc(%ebp)
80102b25:	53                   	push   %ebx
80102b26:	e8 25 fd ff ff       	call   80102850 <dirlookup>
80102b2b:	83 c4 10             	add    $0x10,%esp
80102b2e:	85 c0                	test   %eax,%eax
80102b30:	75 6b                	jne    80102b9d <dirlink+0x8d>
    for (off = 0; off < dp->size; off += sizeof(de)) {
80102b32:	8b 7b 58             	mov    0x58(%ebx),%edi
80102b35:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102b38:	85 ff                	test   %edi,%edi
80102b3a:	74 2d                	je     80102b69 <dirlink+0x59>
80102b3c:	31 ff                	xor    %edi,%edi
80102b3e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102b41:	eb 0d                	jmp    80102b50 <dirlink+0x40>
80102b43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b47:	90                   	nop
80102b48:	83 c7 10             	add    $0x10,%edi
80102b4b:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102b4e:	73 19                	jae    80102b69 <dirlink+0x59>
        if (readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102b50:	6a 10                	push   $0x10
80102b52:	57                   	push   %edi
80102b53:	56                   	push   %esi
80102b54:	53                   	push   %ebx
80102b55:	e8 a6 fa ff ff       	call   80102600 <readi>
80102b5a:	83 c4 10             	add    $0x10,%esp
80102b5d:	83 f8 10             	cmp    $0x10,%eax
80102b60:	75 4e                	jne    80102bb0 <dirlink+0xa0>
        if (de.inum == 0)
80102b62:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102b67:	75 df                	jne    80102b48 <dirlink+0x38>
    strncpy(de.name, name, DIRSIZ);
80102b69:	83 ec 04             	sub    $0x4,%esp
80102b6c:	8d 45 da             	lea    -0x26(%ebp),%eax
80102b6f:	6a 0e                	push   $0xe
80102b71:	ff 75 0c             	pushl  0xc(%ebp)
80102b74:	50                   	push   %eax
80102b75:	e8 86 28 00 00       	call   80105400 <strncpy>
    if (writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102b7a:	6a 10                	push   $0x10
    de.inum = inum;
80102b7c:	8b 45 10             	mov    0x10(%ebp),%eax
    if (writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102b7f:	57                   	push   %edi
80102b80:	56                   	push   %esi
80102b81:	53                   	push   %ebx
    de.inum = inum;
80102b82:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    if (writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102b86:	e8 75 fb ff ff       	call   80102700 <writei>
80102b8b:	83 c4 20             	add    $0x20,%esp
80102b8e:	83 f8 10             	cmp    $0x10,%eax
80102b91:	75 2a                	jne    80102bbd <dirlink+0xad>
    return 0;
80102b93:	31 c0                	xor    %eax,%eax
}
80102b95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b98:	5b                   	pop    %ebx
80102b99:	5e                   	pop    %esi
80102b9a:	5f                   	pop    %edi
80102b9b:	5d                   	pop    %ebp
80102b9c:	c3                   	ret    
        iput(ip);
80102b9d:	83 ec 0c             	sub    $0xc,%esp
80102ba0:	50                   	push   %eax
80102ba1:	e8 8a f8 ff ff       	call   80102430 <iput>
        return -1;
80102ba6:	83 c4 10             	add    $0x10,%esp
80102ba9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102bae:	eb e5                	jmp    80102b95 <dirlink+0x85>
            panic("dirlink read");
80102bb0:	83 ec 0c             	sub    $0xc,%esp
80102bb3:	68 a0 7f 10 80       	push   $0x80107fa0
80102bb8:	e8 d3 d7 ff ff       	call   80100390 <panic>
        panic("dirlink");
80102bbd:	83 ec 0c             	sub    $0xc,%esp
80102bc0:	68 8a 85 10 80       	push   $0x8010858a
80102bc5:	e8 c6 d7 ff ff       	call   80100390 <panic>
80102bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102bd0 <namei>:

struct inode*
namei(char* path) {
80102bd0:	f3 0f 1e fb          	endbr32 
80102bd4:	55                   	push   %ebp
    char name[DIRSIZ];
    return namex(path, 0, name);
80102bd5:	31 d2                	xor    %edx,%edx
namei(char* path) {
80102bd7:	89 e5                	mov    %esp,%ebp
80102bd9:	83 ec 18             	sub    $0x18,%esp
    return namex(path, 0, name);
80102bdc:	8b 45 08             	mov    0x8(%ebp),%eax
80102bdf:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102be2:	e8 29 fd ff ff       	call   80102910 <namex>
}
80102be7:	c9                   	leave  
80102be8:	c3                   	ret    
80102be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102bf0 <nameiparent>:

struct inode*
nameiparent(char* path, char* name) {
80102bf0:	f3 0f 1e fb          	endbr32 
80102bf4:	55                   	push   %ebp
    return namex(path, 1, name);
80102bf5:	ba 01 00 00 00       	mov    $0x1,%edx
nameiparent(char* path, char* name) {
80102bfa:	89 e5                	mov    %esp,%ebp
    return namex(path, 1, name);
80102bfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102bff:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102c02:	5d                   	pop    %ebp
    return namex(path, 1, name);
80102c03:	e9 08 fd ff ff       	jmp    80102910 <namex>
80102c08:	66 90                	xchg   %ax,%ax
80102c0a:	66 90                	xchg   %ax,%ax
80102c0c:	66 90                	xchg   %ax,%ax
80102c0e:	66 90                	xchg   %ax,%ax

80102c10 <idestart>:
    outb(0x1f6, 0xe0 | (0 << 4));
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf* b) {
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	57                   	push   %edi
80102c14:	56                   	push   %esi
80102c15:	53                   	push   %ebx
80102c16:	83 ec 0c             	sub    $0xc,%esp
    if (b == 0)
80102c19:	85 c0                	test   %eax,%eax
80102c1b:	0f 84 b4 00 00 00    	je     80102cd5 <idestart+0xc5>
        panic("idestart");
    if (b->blockno >= FSSIZE)
80102c21:	8b 70 08             	mov    0x8(%eax),%esi
80102c24:	89 c3                	mov    %eax,%ebx
80102c26:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
80102c2c:	0f 87 96 00 00 00    	ja     80102cc8 <idestart+0xb8>
    asm volatile("in %1,%0"
80102c32:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102c37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c3e:	66 90                	xchg   %ax,%ax
80102c40:	89 ca                	mov    %ecx,%edx
80102c42:	ec                   	in     (%dx),%al
    while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY)
80102c43:	83 e0 c0             	and    $0xffffffc0,%eax
80102c46:	3c 40                	cmp    $0x40,%al
80102c48:	75 f6                	jne    80102c40 <idestart+0x30>
    asm volatile("out %0,%1"
80102c4a:	31 ff                	xor    %edi,%edi
80102c4c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102c51:	89 f8                	mov    %edi,%eax
80102c53:	ee                   	out    %al,(%dx)
80102c54:	b8 01 00 00 00       	mov    $0x1,%eax
80102c59:	ba f2 01 00 00       	mov    $0x1f2,%edx
80102c5e:	ee                   	out    %al,(%dx)
80102c5f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102c64:	89 f0                	mov    %esi,%eax
80102c66:	ee                   	out    %al,(%dx)

    idewait(0);
    outb(0x3f6, 0);                // generate interrupt
    outb(0x1f2, sector_per_block); // number of sectors
    outb(0x1f3, sector & 0xff);
    outb(0x1f4, (sector >> 8) & 0xff);
80102c67:	89 f0                	mov    %esi,%eax
80102c69:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102c6e:	c1 f8 08             	sar    $0x8,%eax
80102c71:	ee                   	out    %al,(%dx)
80102c72:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102c77:	89 f8                	mov    %edi,%eax
80102c79:	ee                   	out    %al,(%dx)
    outb(0x1f5, (sector >> 16) & 0xff);
    outb(0x1f6, 0xe0 | ((b->dev & 1) << 4) | ((sector >> 24) & 0x0f));
80102c7a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
80102c7e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102c83:	c1 e0 04             	shl    $0x4,%eax
80102c86:	83 e0 10             	and    $0x10,%eax
80102c89:	83 c8 e0             	or     $0xffffffe0,%eax
80102c8c:	ee                   	out    %al,(%dx)
    if (b->flags & B_DIRTY) {
80102c8d:	f6 03 04             	testb  $0x4,(%ebx)
80102c90:	75 16                	jne    80102ca8 <idestart+0x98>
80102c92:	b8 20 00 00 00       	mov    $0x20,%eax
80102c97:	89 ca                	mov    %ecx,%edx
80102c99:	ee                   	out    %al,(%dx)
        outsl(0x1f0, b->data, BSIZE / 4);
    }
    else {
        outb(0x1f7, read_cmd);
    }
}
80102c9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c9d:	5b                   	pop    %ebx
80102c9e:	5e                   	pop    %esi
80102c9f:	5f                   	pop    %edi
80102ca0:	5d                   	pop    %ebp
80102ca1:	c3                   	ret    
80102ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102ca8:	b8 30 00 00 00       	mov    $0x30,%eax
80102cad:	89 ca                	mov    %ecx,%edx
80102caf:	ee                   	out    %al,(%dx)
    asm volatile("cld; rep outsl"
80102cb0:	b9 80 00 00 00       	mov    $0x80,%ecx
        outsl(0x1f0, b->data, BSIZE / 4);
80102cb5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102cb8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102cbd:	fc                   	cld    
80102cbe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102cc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cc3:	5b                   	pop    %ebx
80102cc4:	5e                   	pop    %esi
80102cc5:	5f                   	pop    %edi
80102cc6:	5d                   	pop    %ebp
80102cc7:	c3                   	ret    
        panic("incorrect blockno");
80102cc8:	83 ec 0c             	sub    $0xc,%esp
80102ccb:	68 0c 80 10 80       	push   $0x8010800c
80102cd0:	e8 bb d6 ff ff       	call   80100390 <panic>
        panic("idestart");
80102cd5:	83 ec 0c             	sub    $0xc,%esp
80102cd8:	68 03 80 10 80       	push   $0x80108003
80102cdd:	e8 ae d6 ff ff       	call   80100390 <panic>
80102ce2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102cf0 <ideinit>:
void ideinit(void) {
80102cf0:	f3 0f 1e fb          	endbr32 
80102cf4:	55                   	push   %ebp
80102cf5:	89 e5                	mov    %esp,%ebp
80102cf7:	83 ec 10             	sub    $0x10,%esp
    initlock(&idelock, "ide");
80102cfa:	68 1e 80 10 80       	push   $0x8010801e
80102cff:	68 80 b5 10 80       	push   $0x8010b580
80102d04:	e8 07 23 00 00       	call   80105010 <initlock>
    ioapicenable(IRQ_IDE, ncpu - 1);
80102d09:	58                   	pop    %eax
80102d0a:	a1 a0 42 11 80       	mov    0x801142a0,%eax
80102d0f:	5a                   	pop    %edx
80102d10:	83 e8 01             	sub    $0x1,%eax
80102d13:	50                   	push   %eax
80102d14:	6a 0e                	push   $0xe
80102d16:	e8 b5 02 00 00       	call   80102fd0 <ioapicenable>
    while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY)
80102d1b:	83 c4 10             	add    $0x10,%esp
    asm volatile("in %1,%0"
80102d1e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d27:	90                   	nop
80102d28:	ec                   	in     (%dx),%al
80102d29:	83 e0 c0             	and    $0xffffffc0,%eax
80102d2c:	3c 40                	cmp    $0x40,%al
80102d2e:	75 f8                	jne    80102d28 <ideinit+0x38>
    asm volatile("out %0,%1"
80102d30:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102d35:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102d3a:	ee                   	out    %al,(%dx)
80102d3b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
    asm volatile("in %1,%0"
80102d40:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102d45:	eb 0e                	jmp    80102d55 <ideinit+0x65>
80102d47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d4e:	66 90                	xchg   %ax,%ax
    for (i = 0; i < 1000; i++) {
80102d50:	83 e9 01             	sub    $0x1,%ecx
80102d53:	74 0f                	je     80102d64 <ideinit+0x74>
80102d55:	ec                   	in     (%dx),%al
        if (inb(0x1f7) != 0) {
80102d56:	84 c0                	test   %al,%al
80102d58:	74 f6                	je     80102d50 <ideinit+0x60>
            havedisk1 = 1;
80102d5a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102d61:	00 00 00 
    asm volatile("out %0,%1"
80102d64:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102d69:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102d6e:	ee                   	out    %al,(%dx)
}
80102d6f:	c9                   	leave  
80102d70:	c3                   	ret    
80102d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d7f:	90                   	nop

80102d80 <ideintr>:

// Interrupt handler.
void ideintr(void) {
80102d80:	f3 0f 1e fb          	endbr32 
80102d84:	55                   	push   %ebp
80102d85:	89 e5                	mov    %esp,%ebp
80102d87:	57                   	push   %edi
80102d88:	56                   	push   %esi
80102d89:	53                   	push   %ebx
80102d8a:	83 ec 18             	sub    $0x18,%esp
    struct buf* b;

    // First queued buffer is the active request.
    acquire(&idelock);
80102d8d:	68 80 b5 10 80       	push   $0x8010b580
80102d92:	e8 f9 23 00 00       	call   80105190 <acquire>

    if ((b = idequeue) == 0) {
80102d97:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102d9d:	83 c4 10             	add    $0x10,%esp
80102da0:	85 db                	test   %ebx,%ebx
80102da2:	74 5f                	je     80102e03 <ideintr+0x83>
        release(&idelock);
        return;
    }
    idequeue = b->qnext;
80102da4:	8b 43 58             	mov    0x58(%ebx),%eax
80102da7:	a3 64 b5 10 80       	mov    %eax,0x8010b564

    // Read data if needed.
    if (!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102dac:	8b 33                	mov    (%ebx),%esi
80102dae:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102db4:	75 2b                	jne    80102de1 <ideintr+0x61>
    asm volatile("in %1,%0"
80102db6:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102dbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dbf:	90                   	nop
80102dc0:	ec                   	in     (%dx),%al
    while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY)
80102dc1:	89 c1                	mov    %eax,%ecx
80102dc3:	83 e1 c0             	and    $0xffffffc0,%ecx
80102dc6:	80 f9 40             	cmp    $0x40,%cl
80102dc9:	75 f5                	jne    80102dc0 <ideintr+0x40>
    if (checkerr && (r & (IDE_DF | IDE_ERR)) != 0)
80102dcb:	a8 21                	test   $0x21,%al
80102dcd:	75 12                	jne    80102de1 <ideintr+0x61>
        insl(0x1f0, b->data, BSIZE / 4);
80102dcf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
    asm volatile("cld; rep insl"
80102dd2:	b9 80 00 00 00       	mov    $0x80,%ecx
80102dd7:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102ddc:	fc                   	cld    
80102ddd:	f3 6d                	rep insl (%dx),%es:(%edi)
80102ddf:	8b 33                	mov    (%ebx),%esi

    // Wake process waiting for this buf.
    b->flags |= B_VALID;
    b->flags &= ~B_DIRTY;
80102de1:	83 e6 fb             	and    $0xfffffffb,%esi
    wakeup(b);
80102de4:	83 ec 0c             	sub    $0xc,%esp
    b->flags &= ~B_DIRTY;
80102de7:	83 ce 02             	or     $0x2,%esi
80102dea:	89 33                	mov    %esi,(%ebx)
    wakeup(b);
80102dec:	53                   	push   %ebx
80102ded:	e8 9e 1e 00 00       	call   80104c90 <wakeup>

    // Start disk on next buf in queue.
    if (idequeue != 0)
80102df2:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102df7:	83 c4 10             	add    $0x10,%esp
80102dfa:	85 c0                	test   %eax,%eax
80102dfc:	74 05                	je     80102e03 <ideintr+0x83>
        idestart(idequeue);
80102dfe:	e8 0d fe ff ff       	call   80102c10 <idestart>
        release(&idelock);
80102e03:	83 ec 0c             	sub    $0xc,%esp
80102e06:	68 80 b5 10 80       	push   $0x8010b580
80102e0b:	e8 40 24 00 00       	call   80105250 <release>

    release(&idelock);
}
80102e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e13:	5b                   	pop    %ebx
80102e14:	5e                   	pop    %esi
80102e15:	5f                   	pop    %edi
80102e16:	5d                   	pop    %ebp
80102e17:	c3                   	ret    
80102e18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e1f:	90                   	nop

80102e20 <iderw>:

// PAGEBREAK!
//  Sync buf with disk.
//  If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
//  Else if B_VALID is not set, read buf from disk, set B_VALID.
void iderw(struct buf* b) {
80102e20:	f3 0f 1e fb          	endbr32 
80102e24:	55                   	push   %ebp
80102e25:	89 e5                	mov    %esp,%ebp
80102e27:	53                   	push   %ebx
80102e28:	83 ec 10             	sub    $0x10,%esp
80102e2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct buf** pp;

    if (!holdingsleep(&b->lock))
80102e2e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102e31:	50                   	push   %eax
80102e32:	e8 79 21 00 00       	call   80104fb0 <holdingsleep>
80102e37:	83 c4 10             	add    $0x10,%esp
80102e3a:	85 c0                	test   %eax,%eax
80102e3c:	0f 84 cf 00 00 00    	je     80102f11 <iderw+0xf1>
        panic("iderw: buf not locked");
    if ((b->flags & (B_VALID | B_DIRTY)) == B_VALID)
80102e42:	8b 03                	mov    (%ebx),%eax
80102e44:	83 e0 06             	and    $0x6,%eax
80102e47:	83 f8 02             	cmp    $0x2,%eax
80102e4a:	0f 84 b4 00 00 00    	je     80102f04 <iderw+0xe4>
        panic("iderw: nothing to do");
    if (b->dev != 0 && !havedisk1)
80102e50:	8b 53 04             	mov    0x4(%ebx),%edx
80102e53:	85 d2                	test   %edx,%edx
80102e55:	74 0d                	je     80102e64 <iderw+0x44>
80102e57:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102e5c:	85 c0                	test   %eax,%eax
80102e5e:	0f 84 93 00 00 00    	je     80102ef7 <iderw+0xd7>
        panic("iderw: ide disk 1 not present");

    acquire(&idelock); // DOC:acquire-lock
80102e64:	83 ec 0c             	sub    $0xc,%esp
80102e67:	68 80 b5 10 80       	push   $0x8010b580
80102e6c:	e8 1f 23 00 00       	call   80105190 <acquire>

    // Append b to idequeue.
    b->qnext = 0;
    for (pp = &idequeue; *pp; pp = &(*pp)->qnext) // DOC:insert-queue
80102e71:	a1 64 b5 10 80       	mov    0x8010b564,%eax
    b->qnext = 0;
80102e76:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
    for (pp = &idequeue; *pp; pp = &(*pp)->qnext) // DOC:insert-queue
80102e7d:	83 c4 10             	add    $0x10,%esp
80102e80:	85 c0                	test   %eax,%eax
80102e82:	74 6c                	je     80102ef0 <iderw+0xd0>
80102e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e88:	89 c2                	mov    %eax,%edx
80102e8a:	8b 40 58             	mov    0x58(%eax),%eax
80102e8d:	85 c0                	test   %eax,%eax
80102e8f:	75 f7                	jne    80102e88 <iderw+0x68>
80102e91:	83 c2 58             	add    $0x58,%edx
        ;
    *pp = b;
80102e94:	89 1a                	mov    %ebx,(%edx)

    // Start disk if necessary.
    if (idequeue == b)
80102e96:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
80102e9c:	74 42                	je     80102ee0 <iderw+0xc0>
        idestart(b);

    // Wait for request to finish.
    while ((b->flags & (B_VALID | B_DIRTY)) != B_VALID) {
80102e9e:	8b 03                	mov    (%ebx),%eax
80102ea0:	83 e0 06             	and    $0x6,%eax
80102ea3:	83 f8 02             	cmp    $0x2,%eax
80102ea6:	74 23                	je     80102ecb <iderw+0xab>
80102ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102eaf:	90                   	nop
        sleep(b, &idelock);
80102eb0:	83 ec 08             	sub    $0x8,%esp
80102eb3:	68 80 b5 10 80       	push   $0x8010b580
80102eb8:	53                   	push   %ebx
80102eb9:	e8 12 1c 00 00       	call   80104ad0 <sleep>
    while ((b->flags & (B_VALID | B_DIRTY)) != B_VALID) {
80102ebe:	8b 03                	mov    (%ebx),%eax
80102ec0:	83 c4 10             	add    $0x10,%esp
80102ec3:	83 e0 06             	and    $0x6,%eax
80102ec6:	83 f8 02             	cmp    $0x2,%eax
80102ec9:	75 e5                	jne    80102eb0 <iderw+0x90>
    }

    release(&idelock);
80102ecb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102ed2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ed5:	c9                   	leave  
    release(&idelock);
80102ed6:	e9 75 23 00 00       	jmp    80105250 <release>
80102edb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102edf:	90                   	nop
        idestart(b);
80102ee0:	89 d8                	mov    %ebx,%eax
80102ee2:	e8 29 fd ff ff       	call   80102c10 <idestart>
80102ee7:	eb b5                	jmp    80102e9e <iderw+0x7e>
80102ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (pp = &idequeue; *pp; pp = &(*pp)->qnext) // DOC:insert-queue
80102ef0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102ef5:	eb 9d                	jmp    80102e94 <iderw+0x74>
        panic("iderw: ide disk 1 not present");
80102ef7:	83 ec 0c             	sub    $0xc,%esp
80102efa:	68 4d 80 10 80       	push   $0x8010804d
80102eff:	e8 8c d4 ff ff       	call   80100390 <panic>
        panic("iderw: nothing to do");
80102f04:	83 ec 0c             	sub    $0xc,%esp
80102f07:	68 38 80 10 80       	push   $0x80108038
80102f0c:	e8 7f d4 ff ff       	call   80100390 <panic>
        panic("iderw: buf not locked");
80102f11:	83 ec 0c             	sub    $0xc,%esp
80102f14:	68 22 80 10 80       	push   $0x80108022
80102f19:	e8 72 d4 ff ff       	call   80100390 <panic>
80102f1e:	66 90                	xchg   %ax,%ax

80102f20 <ioapicinit>:
ioapicwrite(int reg, uint data) {
    ioapic->reg = reg;
    ioapic->data = data;
}

void ioapicinit(void) {
80102f20:	f3 0f 1e fb          	endbr32 
80102f24:	55                   	push   %ebp
    int i, id, maxintr;

    ioapic = (volatile struct ioapic*)IOAPIC;
80102f25:	c7 05 d4 3b 11 80 00 	movl   $0xfec00000,0x80113bd4
80102f2c:	00 c0 fe 
void ioapicinit(void) {
80102f2f:	89 e5                	mov    %esp,%ebp
80102f31:	56                   	push   %esi
80102f32:	53                   	push   %ebx
    ioapic->reg = reg;
80102f33:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102f3a:	00 00 00 
    return ioapic->data;
80102f3d:	8b 15 d4 3b 11 80    	mov    0x80113bd4,%edx
80102f43:	8b 72 10             	mov    0x10(%edx),%esi
    ioapic->reg = reg;
80102f46:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    return ioapic->data;
80102f4c:	8b 0d d4 3b 11 80    	mov    0x80113bd4,%ecx
    maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
    id = ioapicread(REG_ID) >> 24;
    if (id != ioapicid)
80102f52:	0f b6 15 00 3d 11 80 	movzbl 0x80113d00,%edx
    maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102f59:	c1 ee 10             	shr    $0x10,%esi
80102f5c:	89 f0                	mov    %esi,%eax
80102f5e:	0f b6 f0             	movzbl %al,%esi
    return ioapic->data;
80102f61:	8b 41 10             	mov    0x10(%ecx),%eax
    id = ioapicread(REG_ID) >> 24;
80102f64:	c1 e8 18             	shr    $0x18,%eax
    if (id != ioapicid)
80102f67:	39 c2                	cmp    %eax,%edx
80102f69:	74 16                	je     80102f81 <ioapicinit+0x61>
        cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102f6b:	83 ec 0c             	sub    $0xc,%esp
80102f6e:	68 6c 80 10 80       	push   $0x8010806c
80102f73:	e8 48 d8 ff ff       	call   801007c0 <cprintf>
80102f78:	8b 0d d4 3b 11 80    	mov    0x80113bd4,%ecx
80102f7e:	83 c4 10             	add    $0x10,%esp
80102f81:	83 c6 21             	add    $0x21,%esi
void ioapicinit(void) {
80102f84:	ba 10 00 00 00       	mov    $0x10,%edx
80102f89:	b8 20 00 00 00       	mov    $0x20,%eax
80102f8e:	66 90                	xchg   %ax,%ax
    ioapic->reg = reg;
80102f90:	89 11                	mov    %edx,(%ecx)

    // Mark all interrupts edge-triggered, active high, disabled,
    // and not routed to any CPUs.
    for (i = 0; i <= maxintr; i++) {
        ioapicwrite(REG_TABLE + 2 * i, INT_DISABLED | (T_IRQ0 + i));
80102f92:	89 c3                	mov    %eax,%ebx
    ioapic->data = data;
80102f94:	8b 0d d4 3b 11 80    	mov    0x80113bd4,%ecx
80102f9a:	83 c0 01             	add    $0x1,%eax
        ioapicwrite(REG_TABLE + 2 * i, INT_DISABLED | (T_IRQ0 + i));
80102f9d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
    ioapic->data = data;
80102fa3:	89 59 10             	mov    %ebx,0x10(%ecx)
    ioapic->reg = reg;
80102fa6:	8d 5a 01             	lea    0x1(%edx),%ebx
80102fa9:	83 c2 02             	add    $0x2,%edx
80102fac:	89 19                	mov    %ebx,(%ecx)
    ioapic->data = data;
80102fae:	8b 0d d4 3b 11 80    	mov    0x80113bd4,%ecx
80102fb4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
    for (i = 0; i <= maxintr; i++) {
80102fbb:	39 f0                	cmp    %esi,%eax
80102fbd:	75 d1                	jne    80102f90 <ioapicinit+0x70>
        ioapicwrite(REG_TABLE + 2 * i + 1, 0);
    }
}
80102fbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102fc2:	5b                   	pop    %ebx
80102fc3:	5e                   	pop    %esi
80102fc4:	5d                   	pop    %ebp
80102fc5:	c3                   	ret    
80102fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fcd:	8d 76 00             	lea    0x0(%esi),%esi

80102fd0 <ioapicenable>:

void ioapicenable(int irq, int cpunum) {
80102fd0:	f3 0f 1e fb          	endbr32 
80102fd4:	55                   	push   %ebp
    ioapic->reg = reg;
80102fd5:	8b 0d d4 3b 11 80    	mov    0x80113bd4,%ecx
void ioapicenable(int irq, int cpunum) {
80102fdb:	89 e5                	mov    %esp,%ebp
80102fdd:	8b 45 08             	mov    0x8(%ebp),%eax
    // Mark interrupt edge-triggered, active high,
    // enabled, and routed to the given cpunum,
    // which happens to be that cpu's APIC ID.
    ioapicwrite(REG_TABLE + 2 * irq, T_IRQ0 + irq);
80102fe0:	8d 50 20             	lea    0x20(%eax),%edx
80102fe3:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
    ioapic->reg = reg;
80102fe7:	89 01                	mov    %eax,(%ecx)
    ioapic->data = data;
80102fe9:	8b 0d d4 3b 11 80    	mov    0x80113bd4,%ecx
    ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
80102fef:	83 c0 01             	add    $0x1,%eax
    ioapic->data = data;
80102ff2:	89 51 10             	mov    %edx,0x10(%ecx)
    ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
80102ff5:	8b 55 0c             	mov    0xc(%ebp),%edx
    ioapic->reg = reg;
80102ff8:	89 01                	mov    %eax,(%ecx)
    ioapic->data = data;
80102ffa:	a1 d4 3b 11 80       	mov    0x80113bd4,%eax
    ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
80102fff:	c1 e2 18             	shl    $0x18,%edx
    ioapic->data = data;
80103002:	89 50 10             	mov    %edx,0x10(%eax)
}
80103005:	5d                   	pop    %ebp
80103006:	c3                   	ret    
80103007:	66 90                	xchg   %ax,%ax
80103009:	66 90                	xchg   %ax,%ax
8010300b:	66 90                	xchg   %ax,%ax
8010300d:	66 90                	xchg   %ax,%ax
8010300f:	90                   	nop

80103010 <kfree>:
// PAGEBREAK: 21
//  Free the page of physical memory pointed at by v,
//  which normally should have been returned by a
//  call to kalloc().  (The exception is when
//  initializing the allocator; see kinit above.)
void kfree(char* v) {
80103010:	f3 0f 1e fb          	endbr32 
80103014:	55                   	push   %ebp
80103015:	89 e5                	mov    %esp,%ebp
80103017:	53                   	push   %ebx
80103018:	83 ec 04             	sub    $0x4,%esp
8010301b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct run* r;

    if ((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010301e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80103024:	75 7a                	jne    801030a0 <kfree+0x90>
80103026:	81 fb 48 6b 11 80    	cmp    $0x80116b48,%ebx
8010302c:	72 72                	jb     801030a0 <kfree+0x90>
8010302e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80103034:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80103039:	77 65                	ja     801030a0 <kfree+0x90>
        panic("kfree");

    // Fill with junk to catch dangling refs.
    memset(v, 1, PGSIZE);
8010303b:	83 ec 04             	sub    $0x4,%esp
8010303e:	68 00 10 00 00       	push   $0x1000
80103043:	6a 01                	push   $0x1
80103045:	53                   	push   %ebx
80103046:	e8 55 22 00 00       	call   801052a0 <memset>

    if (kmem.use_lock)
8010304b:	8b 15 14 3c 11 80    	mov    0x80113c14,%edx
80103051:	83 c4 10             	add    $0x10,%esp
80103054:	85 d2                	test   %edx,%edx
80103056:	75 20                	jne    80103078 <kfree+0x68>
        acquire(&kmem.lock);
    r = (struct run*)v;
    r->next = kmem.freelist;
80103058:	a1 18 3c 11 80       	mov    0x80113c18,%eax
8010305d:	89 03                	mov    %eax,(%ebx)
    kmem.freelist = r;
    if (kmem.use_lock)
8010305f:	a1 14 3c 11 80       	mov    0x80113c14,%eax
    kmem.freelist = r;
80103064:	89 1d 18 3c 11 80    	mov    %ebx,0x80113c18
    if (kmem.use_lock)
8010306a:	85 c0                	test   %eax,%eax
8010306c:	75 22                	jne    80103090 <kfree+0x80>
        release(&kmem.lock);
}
8010306e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103071:	c9                   	leave  
80103072:	c3                   	ret    
80103073:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103077:	90                   	nop
        acquire(&kmem.lock);
80103078:	83 ec 0c             	sub    $0xc,%esp
8010307b:	68 e0 3b 11 80       	push   $0x80113be0
80103080:	e8 0b 21 00 00       	call   80105190 <acquire>
80103085:	83 c4 10             	add    $0x10,%esp
80103088:	eb ce                	jmp    80103058 <kfree+0x48>
8010308a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        release(&kmem.lock);
80103090:	c7 45 08 e0 3b 11 80 	movl   $0x80113be0,0x8(%ebp)
}
80103097:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010309a:	c9                   	leave  
        release(&kmem.lock);
8010309b:	e9 b0 21 00 00       	jmp    80105250 <release>
        panic("kfree");
801030a0:	83 ec 0c             	sub    $0xc,%esp
801030a3:	68 9e 80 10 80       	push   $0x8010809e
801030a8:	e8 e3 d2 ff ff       	call   80100390 <panic>
801030ad:	8d 76 00             	lea    0x0(%esi),%esi

801030b0 <freerange>:
void freerange(void* vstart, void* vend) {
801030b0:	f3 0f 1e fb          	endbr32 
801030b4:	55                   	push   %ebp
801030b5:	89 e5                	mov    %esp,%ebp
801030b7:	56                   	push   %esi
    p = (char*)PGROUNDUP((uint)vstart);
801030b8:	8b 45 08             	mov    0x8(%ebp),%eax
void freerange(void* vstart, void* vend) {
801030bb:	8b 75 0c             	mov    0xc(%ebp),%esi
801030be:	53                   	push   %ebx
    p = (char*)PGROUNDUP((uint)vstart);
801030bf:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801030c5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE)
801030cb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801030d1:	39 de                	cmp    %ebx,%esi
801030d3:	72 1f                	jb     801030f4 <freerange+0x44>
801030d5:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p);
801030d8:	83 ec 0c             	sub    $0xc,%esp
801030db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE)
801030e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(p);
801030e7:	50                   	push   %eax
801030e8:	e8 23 ff ff ff       	call   80103010 <kfree>
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE)
801030ed:	83 c4 10             	add    $0x10,%esp
801030f0:	39 f3                	cmp    %esi,%ebx
801030f2:	76 e4                	jbe    801030d8 <freerange+0x28>
}
801030f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801030f7:	5b                   	pop    %ebx
801030f8:	5e                   	pop    %esi
801030f9:	5d                   	pop    %ebp
801030fa:	c3                   	ret    
801030fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030ff:	90                   	nop

80103100 <kinit1>:
void kinit1(void* vstart, void* vend) {
80103100:	f3 0f 1e fb          	endbr32 
80103104:	55                   	push   %ebp
80103105:	89 e5                	mov    %esp,%ebp
80103107:	56                   	push   %esi
80103108:	53                   	push   %ebx
80103109:	8b 75 0c             	mov    0xc(%ebp),%esi
    initlock(&kmem.lock, "kmem");
8010310c:	83 ec 08             	sub    $0x8,%esp
8010310f:	68 a4 80 10 80       	push   $0x801080a4
80103114:	68 e0 3b 11 80       	push   $0x80113be0
80103119:	e8 f2 1e 00 00       	call   80105010 <initlock>
    p = (char*)PGROUNDUP((uint)vstart);
8010311e:	8b 45 08             	mov    0x8(%ebp),%eax
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103121:	83 c4 10             	add    $0x10,%esp
    kmem.use_lock = 0;
80103124:	c7 05 14 3c 11 80 00 	movl   $0x0,0x80113c14
8010312b:	00 00 00 
    p = (char*)PGROUNDUP((uint)vstart);
8010312e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103134:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010313a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80103140:	39 de                	cmp    %ebx,%esi
80103142:	72 20                	jb     80103164 <kinit1+0x64>
80103144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p);
80103148:	83 ec 0c             	sub    $0xc,%esp
8010314b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103151:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(p);
80103157:	50                   	push   %eax
80103158:	e8 b3 fe ff ff       	call   80103010 <kfree>
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010315d:	83 c4 10             	add    $0x10,%esp
80103160:	39 de                	cmp    %ebx,%esi
80103162:	73 e4                	jae    80103148 <kinit1+0x48>
}
80103164:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103167:	5b                   	pop    %ebx
80103168:	5e                   	pop    %esi
80103169:	5d                   	pop    %ebp
8010316a:	c3                   	ret    
8010316b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010316f:	90                   	nop

80103170 <kinit2>:
void kinit2(void* vstart, void* vend) {
80103170:	f3 0f 1e fb          	endbr32 
80103174:	55                   	push   %ebp
80103175:	89 e5                	mov    %esp,%ebp
80103177:	56                   	push   %esi
    p = (char*)PGROUNDUP((uint)vstart);
80103178:	8b 45 08             	mov    0x8(%ebp),%eax
void kinit2(void* vstart, void* vend) {
8010317b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010317e:	53                   	push   %ebx
    p = (char*)PGROUNDUP((uint)vstart);
8010317f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103185:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010318b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80103191:	39 de                	cmp    %ebx,%esi
80103193:	72 1f                	jb     801031b4 <kinit2+0x44>
80103195:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p);
80103198:	83 ec 0c             	sub    $0xc,%esp
8010319b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE)
801031a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(p);
801031a7:	50                   	push   %eax
801031a8:	e8 63 fe ff ff       	call   80103010 <kfree>
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE)
801031ad:	83 c4 10             	add    $0x10,%esp
801031b0:	39 de                	cmp    %ebx,%esi
801031b2:	73 e4                	jae    80103198 <kinit2+0x28>
    kmem.use_lock = 1;
801031b4:	c7 05 14 3c 11 80 01 	movl   $0x1,0x80113c14
801031bb:	00 00 00 
}
801031be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801031c1:	5b                   	pop    %ebx
801031c2:	5e                   	pop    %esi
801031c3:	5d                   	pop    %ebp
801031c4:	c3                   	ret    
801031c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801031d0 <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char* kalloc(void) {
801031d0:	f3 0f 1e fb          	endbr32 
    struct run* r;

    if (kmem.use_lock)
801031d4:	a1 14 3c 11 80       	mov    0x80113c14,%eax
801031d9:	85 c0                	test   %eax,%eax
801031db:	75 1b                	jne    801031f8 <kalloc+0x28>
        acquire(&kmem.lock);
    r = kmem.freelist;
801031dd:	a1 18 3c 11 80       	mov    0x80113c18,%eax
    if (r)
801031e2:	85 c0                	test   %eax,%eax
801031e4:	74 0a                	je     801031f0 <kalloc+0x20>
        kmem.freelist = r->next;
801031e6:	8b 10                	mov    (%eax),%edx
801031e8:	89 15 18 3c 11 80    	mov    %edx,0x80113c18
    if (kmem.use_lock)
801031ee:	c3                   	ret    
801031ef:	90                   	nop
        release(&kmem.lock);
    return (char*)r;
}
801031f0:	c3                   	ret    
801031f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
char* kalloc(void) {
801031f8:	55                   	push   %ebp
801031f9:	89 e5                	mov    %esp,%ebp
801031fb:	83 ec 24             	sub    $0x24,%esp
        acquire(&kmem.lock);
801031fe:	68 e0 3b 11 80       	push   $0x80113be0
80103203:	e8 88 1f 00 00       	call   80105190 <acquire>
    r = kmem.freelist;
80103208:	a1 18 3c 11 80       	mov    0x80113c18,%eax
    if (r)
8010320d:	8b 15 14 3c 11 80    	mov    0x80113c14,%edx
80103213:	83 c4 10             	add    $0x10,%esp
80103216:	85 c0                	test   %eax,%eax
80103218:	74 08                	je     80103222 <kalloc+0x52>
        kmem.freelist = r->next;
8010321a:	8b 08                	mov    (%eax),%ecx
8010321c:	89 0d 18 3c 11 80    	mov    %ecx,0x80113c18
    if (kmem.use_lock)
80103222:	85 d2                	test   %edx,%edx
80103224:	74 16                	je     8010323c <kalloc+0x6c>
        release(&kmem.lock);
80103226:	83 ec 0c             	sub    $0xc,%esp
80103229:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010322c:	68 e0 3b 11 80       	push   $0x80113be0
80103231:	e8 1a 20 00 00       	call   80105250 <release>
    return (char*)r;
80103236:	8b 45 f4             	mov    -0xc(%ebp),%eax
        release(&kmem.lock);
80103239:	83 c4 10             	add    $0x10,%esp
}
8010323c:	c9                   	leave  
8010323d:	c3                   	ret    
8010323e:	66 90                	xchg   %ax,%ax

80103240 <kbdgetc>:
#include "types.h"
#include "x86.h"
#include "defs.h"
#include "kbd.h"

int kbdgetc(void) {
80103240:	f3 0f 1e fb          	endbr32 
    asm volatile("in %1,%0"
80103244:	ba 64 00 00 00       	mov    $0x64,%edx
80103249:	ec                   	in     (%dx),%al
    static uchar* charcode[4] = {
        normalmap, shiftmap, ctlmap, ctlmap};
    uint st, data, c;

    st = inb(KBSTATP);
    if ((st & KBS_DIB) == 0)
8010324a:	a8 01                	test   $0x1,%al
8010324c:	0f 84 be 00 00 00    	je     80103310 <kbdgetc+0xd0>
int kbdgetc(void) {
80103252:	55                   	push   %ebp
80103253:	ba 60 00 00 00       	mov    $0x60,%edx
80103258:	89 e5                	mov    %esp,%ebp
8010325a:	53                   	push   %ebx
8010325b:	ec                   	in     (%dx),%al
    return data;
8010325c:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
        return -1;
    data = inb(KBDATAP);
80103262:	0f b6 d0             	movzbl %al,%edx

    if (data == 0xE0) {
80103265:	3c e0                	cmp    $0xe0,%al
80103267:	74 57                	je     801032c0 <kbdgetc+0x80>
        shift |= E0ESC;
        return 0;
    }
    else if (data & 0x80) {
80103269:	89 d9                	mov    %ebx,%ecx
8010326b:	83 e1 40             	and    $0x40,%ecx
8010326e:	84 c0                	test   %al,%al
80103270:	78 5e                	js     801032d0 <kbdgetc+0x90>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
        shift &= ~(shiftcode[data] | E0ESC);
        return 0;
    }
    else if (shift & E0ESC) {
80103272:	85 c9                	test   %ecx,%ecx
80103274:	74 09                	je     8010327f <kbdgetc+0x3f>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
80103276:	83 c8 80             	or     $0xffffff80,%eax
        shift &= ~E0ESC;
80103279:	83 e3 bf             	and    $0xffffffbf,%ebx
        data |= 0x80;
8010327c:	0f b6 d0             	movzbl %al,%edx
    }

    shift |= shiftcode[data];
8010327f:	0f b6 8a e0 81 10 80 	movzbl -0x7fef7e20(%edx),%ecx
    shift ^= togglecode[data];
80103286:	0f b6 82 e0 80 10 80 	movzbl -0x7fef7f20(%edx),%eax
    shift |= shiftcode[data];
8010328d:	09 d9                	or     %ebx,%ecx
    shift ^= togglecode[data];
8010328f:	31 c1                	xor    %eax,%ecx
    c = charcode[shift & (CTL | SHIFT)][data];
80103291:	89 c8                	mov    %ecx,%eax
    shift ^= togglecode[data];
80103293:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    c = charcode[shift & (CTL | SHIFT)][data];
80103299:	83 e0 03             	and    $0x3,%eax
    if (shift & CAPSLOCK) {
8010329c:	83 e1 08             	and    $0x8,%ecx
    c = charcode[shift & (CTL | SHIFT)][data];
8010329f:	8b 04 85 c0 80 10 80 	mov    -0x7fef7f40(,%eax,4),%eax
801032a6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
    if (shift & CAPSLOCK) {
801032aa:	74 0b                	je     801032b7 <kbdgetc+0x77>
        if ('a' <= c && c <= 'z')
801032ac:	8d 50 9f             	lea    -0x61(%eax),%edx
801032af:	83 fa 19             	cmp    $0x19,%edx
801032b2:	77 44                	ja     801032f8 <kbdgetc+0xb8>
            c += 'A' - 'a';
801032b4:	83 e8 20             	sub    $0x20,%eax
        else if ('A' <= c && c <= 'Z')
            c += 'a' - 'A';
    }
    return c;
}
801032b7:	5b                   	pop    %ebx
801032b8:	5d                   	pop    %ebp
801032b9:	c3                   	ret    
801032ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        shift |= E0ESC;
801032c0:	83 cb 40             	or     $0x40,%ebx
        return 0;
801032c3:	31 c0                	xor    %eax,%eax
        shift |= E0ESC;
801032c5:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
801032cb:	5b                   	pop    %ebx
801032cc:	5d                   	pop    %ebp
801032cd:	c3                   	ret    
801032ce:	66 90                	xchg   %ax,%ax
        data = (shift & E0ESC ? data : data & 0x7F);
801032d0:	83 e0 7f             	and    $0x7f,%eax
801032d3:	85 c9                	test   %ecx,%ecx
801032d5:	0f 44 d0             	cmove  %eax,%edx
        return 0;
801032d8:	31 c0                	xor    %eax,%eax
        shift &= ~(shiftcode[data] | E0ESC);
801032da:	0f b6 8a e0 81 10 80 	movzbl -0x7fef7e20(%edx),%ecx
801032e1:	83 c9 40             	or     $0x40,%ecx
801032e4:	0f b6 c9             	movzbl %cl,%ecx
801032e7:	f7 d1                	not    %ecx
801032e9:	21 d9                	and    %ebx,%ecx
}
801032eb:	5b                   	pop    %ebx
801032ec:	5d                   	pop    %ebp
        shift &= ~(shiftcode[data] | E0ESC);
801032ed:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
801032f3:	c3                   	ret    
801032f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        else if ('A' <= c && c <= 'Z')
801032f8:	8d 48 bf             	lea    -0x41(%eax),%ecx
            c += 'a' - 'A';
801032fb:	8d 50 20             	lea    0x20(%eax),%edx
}
801032fe:	5b                   	pop    %ebx
801032ff:	5d                   	pop    %ebp
            c += 'a' - 'A';
80103300:	83 f9 1a             	cmp    $0x1a,%ecx
80103303:	0f 42 c2             	cmovb  %edx,%eax
}
80103306:	c3                   	ret    
80103307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010330e:	66 90                	xchg   %ax,%ax
        return -1;
80103310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103315:	c3                   	ret    
80103316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010331d:	8d 76 00             	lea    0x0(%esi),%esi

80103320 <kbdintr>:

void kbdintr(void) {
80103320:	f3 0f 1e fb          	endbr32 
80103324:	55                   	push   %ebp
80103325:	89 e5                	mov    %esp,%ebp
80103327:	83 ec 14             	sub    $0x14,%esp
    consoleintr(kbdgetc);
8010332a:	68 40 32 10 80       	push   $0x80103240
8010332f:	e8 9c d6 ff ff       	call   801009d0 <consoleintr>
}
80103334:	83 c4 10             	add    $0x10,%esp
80103337:	c9                   	leave  
80103338:	c3                   	ret    
80103339:	66 90                	xchg   %ax,%ax
8010333b:	66 90                	xchg   %ax,%ax
8010333d:	66 90                	xchg   %ax,%ax
8010333f:	90                   	nop

80103340 <lapicinit>:
lapicw(int index, int value) {
    lapic[index] = value;
    lapic[ID]; // wait for write to finish, by reading
}

void lapicinit(void) {
80103340:	f3 0f 1e fb          	endbr32 
    if (!lapic)
80103344:	a1 1c 3c 11 80       	mov    0x80113c1c,%eax
80103349:	85 c0                	test   %eax,%eax
8010334b:	0f 84 c7 00 00 00    	je     80103418 <lapicinit+0xd8>
    lapic[index] = value;
80103351:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103358:	01 00 00 
    lapic[ID]; // wait for write to finish, by reading
8010335b:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
8010335e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103365:	00 00 00 
    lapic[ID]; // wait for write to finish, by reading
80103368:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
8010336b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80103372:	00 02 00 
    lapic[ID]; // wait for write to finish, by reading
80103375:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80103378:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010337f:	96 98 00 
    lapic[ID]; // wait for write to finish, by reading
80103382:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80103385:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010338c:	00 01 00 
    lapic[ID]; // wait for write to finish, by reading
8010338f:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80103392:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103399:	00 01 00 
    lapic[ID]; // wait for write to finish, by reading
8010339c:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(LINT0, MASKED);
    lapicw(LINT1, MASKED);

    // Disable performance counter overflow interrupts
    // on machines that provide that interrupt entry.
    if (((lapic[VER] >> 16) & 0xFF) >= 4)
8010339f:	8b 50 30             	mov    0x30(%eax),%edx
801033a2:	c1 ea 10             	shr    $0x10,%edx
801033a5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801033ab:	75 73                	jne    80103420 <lapicinit+0xe0>
    lapic[index] = value;
801033ad:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801033b4:	00 00 00 
    lapic[ID]; // wait for write to finish, by reading
801033b7:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
801033ba:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801033c1:	00 00 00 
    lapic[ID]; // wait for write to finish, by reading
801033c4:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
801033c7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801033ce:	00 00 00 
    lapic[ID]; // wait for write to finish, by reading
801033d1:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
801033d4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801033db:	00 00 00 
    lapic[ID]; // wait for write to finish, by reading
801033de:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
801033e1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801033e8:	00 00 00 
    lapic[ID]; // wait for write to finish, by reading
801033eb:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
801033ee:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801033f5:	85 08 00 
    lapic[ID]; // wait for write to finish, by reading
801033f8:	8b 50 20             	mov    0x20(%eax),%edx
801033fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033ff:	90                   	nop
    lapicw(EOI, 0);

    // Send an Init Level De-Assert to synchronise arbitration ID's.
    lapicw(ICRHI, 0);
    lapicw(ICRLO, BCAST | INIT | LEVEL);
    while (lapic[ICRLO] & DELIVS)
80103400:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103406:	80 e6 10             	and    $0x10,%dh
80103409:	75 f5                	jne    80103400 <lapicinit+0xc0>
    lapic[index] = value;
8010340b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103412:	00 00 00 
    lapic[ID]; // wait for write to finish, by reading
80103415:	8b 40 20             	mov    0x20(%eax),%eax
        ;

    // Enable interrupts on the APIC (but not on the processor).
    lapicw(TPR, 0);
}
80103418:	c3                   	ret    
80103419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    lapic[index] = value;
80103420:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103427:	00 01 00 
    lapic[ID]; // wait for write to finish, by reading
8010342a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010342d:	e9 7b ff ff ff       	jmp    801033ad <lapicinit+0x6d>
80103432:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103440 <lapicid>:

int lapicid(void) {
80103440:	f3 0f 1e fb          	endbr32 
    if (!lapic)
80103444:	a1 1c 3c 11 80       	mov    0x80113c1c,%eax
80103449:	85 c0                	test   %eax,%eax
8010344b:	74 0b                	je     80103458 <lapicid+0x18>
        return 0;
    return lapic[ID] >> 24;
8010344d:	8b 40 20             	mov    0x20(%eax),%eax
80103450:	c1 e8 18             	shr    $0x18,%eax
80103453:	c3                   	ret    
80103454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return 0;
80103458:	31 c0                	xor    %eax,%eax
}
8010345a:	c3                   	ret    
8010345b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010345f:	90                   	nop

80103460 <lapiceoi>:

// Acknowledge interrupt.
void lapiceoi(void) {
80103460:	f3 0f 1e fb          	endbr32 
    if (lapic)
80103464:	a1 1c 3c 11 80       	mov    0x80113c1c,%eax
80103469:	85 c0                	test   %eax,%eax
8010346b:	74 0d                	je     8010347a <lapiceoi+0x1a>
    lapic[index] = value;
8010346d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103474:	00 00 00 
    lapic[ID]; // wait for write to finish, by reading
80103477:	8b 40 20             	mov    0x20(%eax),%eax
        lapicw(EOI, 0);
}
8010347a:	c3                   	ret    
8010347b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010347f:	90                   	nop

80103480 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void microdelay(int us) {
80103480:	f3 0f 1e fb          	endbr32 
}
80103484:	c3                   	ret    
80103485:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010348c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103490 <lapicstartap>:
#define CMOS_PORT   0x70
#define CMOS_RETURN 0x71

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void lapicstartap(uchar apicid, uint addr) {
80103490:	f3 0f 1e fb          	endbr32 
80103494:	55                   	push   %ebp
    asm volatile("out %0,%1"
80103495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010349a:	ba 70 00 00 00       	mov    $0x70,%edx
8010349f:	89 e5                	mov    %esp,%ebp
801034a1:	53                   	push   %ebx
801034a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801034a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034a8:	ee                   	out    %al,(%dx)
801034a9:	b8 0a 00 00 00       	mov    $0xa,%eax
801034ae:	ba 71 00 00 00       	mov    $0x71,%edx
801034b3:	ee                   	out    %al,(%dx)
    // and the warm reset vector (DWORD based at 40:67) to point at
    // the AP startup code prior to the [universal startup algorithm]."
    outb(CMOS_PORT, 0xF); // offset 0xF is shutdown code
    outb(CMOS_PORT + 1, 0x0A);
    wrv = (ushort*)P2V((0x40 << 4 | 0x67)); // Warm reset vector
    wrv[0] = 0;
801034b4:	31 c0                	xor    %eax,%eax
    wrv[1] = addr >> 4;

    // "Universal startup algorithm."
    // Send INIT (level-triggered) interrupt to reset other CPU.
    lapicw(ICRHI, apicid << 24);
801034b6:	c1 e3 18             	shl    $0x18,%ebx
    wrv[0] = 0;
801034b9:	66 a3 67 04 00 80    	mov    %ax,0x80000467
    wrv[1] = addr >> 4;
801034bf:	89 c8                	mov    %ecx,%eax
    // when it is in the halted state due to an INIT.  So the second
    // should be ignored, but it is part of the official Intel algorithm.
    // Bochs complains about the second one.  Too bad for Bochs.
    for (i = 0; i < 2; i++) {
        lapicw(ICRHI, apicid << 24);
        lapicw(ICRLO, STARTUP | (addr >> 12));
801034c1:	c1 e9 0c             	shr    $0xc,%ecx
    lapicw(ICRHI, apicid << 24);
801034c4:	89 da                	mov    %ebx,%edx
    wrv[1] = addr >> 4;
801034c6:	c1 e8 04             	shr    $0x4,%eax
        lapicw(ICRLO, STARTUP | (addr >> 12));
801034c9:	80 cd 06             	or     $0x6,%ch
    wrv[1] = addr >> 4;
801034cc:	66 a3 69 04 00 80    	mov    %ax,0x80000469
    lapic[index] = value;
801034d2:	a1 1c 3c 11 80       	mov    0x80113c1c,%eax
801034d7:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
    lapic[ID]; // wait for write to finish, by reading
801034dd:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
801034e0:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801034e7:	c5 00 00 
    lapic[ID]; // wait for write to finish, by reading
801034ea:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
801034ed:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801034f4:	85 00 00 
    lapic[ID]; // wait for write to finish, by reading
801034f7:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
801034fa:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
    lapic[ID]; // wait for write to finish, by reading
80103500:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
80103503:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    lapic[ID]; // wait for write to finish, by reading
80103509:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
8010350c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
    lapic[ID]; // wait for write to finish, by reading
80103512:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80103515:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
        microdelay(200);
    }
}
8010351b:	5b                   	pop    %ebx
    lapic[ID]; // wait for write to finish, by reading
8010351c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010351f:	5d                   	pop    %ebp
80103520:	c3                   	ret    
80103521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010352f:	90                   	nop

80103530 <cmostime>:
    r->month = cmos_read(MONTH);
    r->year = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate* r) {
80103530:	f3 0f 1e fb          	endbr32 
80103534:	55                   	push   %ebp
80103535:	b8 0b 00 00 00       	mov    $0xb,%eax
8010353a:	ba 70 00 00 00       	mov    $0x70,%edx
8010353f:	89 e5                	mov    %esp,%ebp
80103541:	57                   	push   %edi
80103542:	56                   	push   %esi
80103543:	53                   	push   %ebx
80103544:	83 ec 4c             	sub    $0x4c,%esp
80103547:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80103548:	ba 71 00 00 00       	mov    $0x71,%edx
8010354d:	ec                   	in     (%dx),%al
    struct rtcdate t1, t2;
    int sb, bcd;

    sb = cmos_read(CMOS_STATB);

    bcd = (sb & (1 << 2)) == 0;
8010354e:	83 e0 04             	and    $0x4,%eax
    asm volatile("out %0,%1"
80103551:	bb 70 00 00 00       	mov    $0x70,%ebx
80103556:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103560:	31 c0                	xor    %eax,%eax
80103562:	89 da                	mov    %ebx,%edx
80103564:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80103565:	b9 71 00 00 00       	mov    $0x71,%ecx
8010356a:	89 ca                	mov    %ecx,%edx
8010356c:	ec                   	in     (%dx),%al
8010356d:	88 45 b7             	mov    %al,-0x49(%ebp)
    asm volatile("out %0,%1"
80103570:	89 da                	mov    %ebx,%edx
80103572:	b8 02 00 00 00       	mov    $0x2,%eax
80103577:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80103578:	89 ca                	mov    %ecx,%edx
8010357a:	ec                   	in     (%dx),%al
8010357b:	88 45 b6             	mov    %al,-0x4a(%ebp)
    asm volatile("out %0,%1"
8010357e:	89 da                	mov    %ebx,%edx
80103580:	b8 04 00 00 00       	mov    $0x4,%eax
80103585:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80103586:	89 ca                	mov    %ecx,%edx
80103588:	ec                   	in     (%dx),%al
80103589:	88 45 b5             	mov    %al,-0x4b(%ebp)
    asm volatile("out %0,%1"
8010358c:	89 da                	mov    %ebx,%edx
8010358e:	b8 07 00 00 00       	mov    $0x7,%eax
80103593:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80103594:	89 ca                	mov    %ecx,%edx
80103596:	ec                   	in     (%dx),%al
80103597:	88 45 b4             	mov    %al,-0x4c(%ebp)
    asm volatile("out %0,%1"
8010359a:	89 da                	mov    %ebx,%edx
8010359c:	b8 08 00 00 00       	mov    $0x8,%eax
801035a1:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
801035a2:	89 ca                	mov    %ecx,%edx
801035a4:	ec                   	in     (%dx),%al
801035a5:	89 c7                	mov    %eax,%edi
    asm volatile("out %0,%1"
801035a7:	89 da                	mov    %ebx,%edx
801035a9:	b8 09 00 00 00       	mov    $0x9,%eax
801035ae:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
801035af:	89 ca                	mov    %ecx,%edx
801035b1:	ec                   	in     (%dx),%al
801035b2:	89 c6                	mov    %eax,%esi
    asm volatile("out %0,%1"
801035b4:	89 da                	mov    %ebx,%edx
801035b6:	b8 0a 00 00 00       	mov    $0xa,%eax
801035bb:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
801035bc:	89 ca                	mov    %ecx,%edx
801035be:	ec                   	in     (%dx),%al

    // make sure CMOS doesn't modify time while we read it
    for (;;) {
        fill_rtcdate(&t1);
        if (cmos_read(CMOS_STATA) & CMOS_UIP)
801035bf:	84 c0                	test   %al,%al
801035c1:	78 9d                	js     80103560 <cmostime+0x30>
    return inb(CMOS_RETURN);
801035c3:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801035c7:	89 fa                	mov    %edi,%edx
801035c9:	0f b6 fa             	movzbl %dl,%edi
801035cc:	89 f2                	mov    %esi,%edx
801035ce:	89 45 b8             	mov    %eax,-0x48(%ebp)
801035d1:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801035d5:	0f b6 f2             	movzbl %dl,%esi
    asm volatile("out %0,%1"
801035d8:	89 da                	mov    %ebx,%edx
801035da:	89 7d c8             	mov    %edi,-0x38(%ebp)
801035dd:	89 45 bc             	mov    %eax,-0x44(%ebp)
801035e0:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801035e4:	89 75 cc             	mov    %esi,-0x34(%ebp)
801035e7:	89 45 c0             	mov    %eax,-0x40(%ebp)
801035ea:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801035ee:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801035f1:	31 c0                	xor    %eax,%eax
801035f3:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
801035f4:	89 ca                	mov    %ecx,%edx
801035f6:	ec                   	in     (%dx),%al
801035f7:	0f b6 c0             	movzbl %al,%eax
    asm volatile("out %0,%1"
801035fa:	89 da                	mov    %ebx,%edx
801035fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
801035ff:	b8 02 00 00 00       	mov    $0x2,%eax
80103604:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80103605:	89 ca                	mov    %ecx,%edx
80103607:	ec                   	in     (%dx),%al
80103608:	0f b6 c0             	movzbl %al,%eax
    asm volatile("out %0,%1"
8010360b:	89 da                	mov    %ebx,%edx
8010360d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103610:	b8 04 00 00 00       	mov    $0x4,%eax
80103615:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80103616:	89 ca                	mov    %ecx,%edx
80103618:	ec                   	in     (%dx),%al
80103619:	0f b6 c0             	movzbl %al,%eax
    asm volatile("out %0,%1"
8010361c:	89 da                	mov    %ebx,%edx
8010361e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103621:	b8 07 00 00 00       	mov    $0x7,%eax
80103626:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80103627:	89 ca                	mov    %ecx,%edx
80103629:	ec                   	in     (%dx),%al
8010362a:	0f b6 c0             	movzbl %al,%eax
    asm volatile("out %0,%1"
8010362d:	89 da                	mov    %ebx,%edx
8010362f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103632:	b8 08 00 00 00       	mov    $0x8,%eax
80103637:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80103638:	89 ca                	mov    %ecx,%edx
8010363a:	ec                   	in     (%dx),%al
8010363b:	0f b6 c0             	movzbl %al,%eax
    asm volatile("out %0,%1"
8010363e:	89 da                	mov    %ebx,%edx
80103640:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103643:	b8 09 00 00 00       	mov    $0x9,%eax
80103648:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80103649:	89 ca                	mov    %ecx,%edx
8010364b:	ec                   	in     (%dx),%al
8010364c:	0f b6 c0             	movzbl %al,%eax
            continue;
        fill_rtcdate(&t2);
        if (memcmp(&t1, &t2, sizeof(t1)) == 0)
8010364f:	83 ec 04             	sub    $0x4,%esp
    return inb(CMOS_RETURN);
80103652:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103655:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103658:	6a 18                	push   $0x18
8010365a:	50                   	push   %eax
8010365b:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010365e:	50                   	push   %eax
8010365f:	e8 8c 1c 00 00       	call   801052f0 <memcmp>
80103664:	83 c4 10             	add    $0x10,%esp
80103667:	85 c0                	test   %eax,%eax
80103669:	0f 85 f1 fe ff ff    	jne    80103560 <cmostime+0x30>
            break;
    }

    // convert
    if (bcd) {
8010366f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103673:	75 78                	jne    801036ed <cmostime+0x1bd>
#define CONV(x) (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
        CONV(second);
80103675:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103678:	89 c2                	mov    %eax,%edx
8010367a:	83 e0 0f             	and    $0xf,%eax
8010367d:	c1 ea 04             	shr    $0x4,%edx
80103680:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103683:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103686:	89 45 b8             	mov    %eax,-0x48(%ebp)
        CONV(minute);
80103689:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010368c:	89 c2                	mov    %eax,%edx
8010368e:	83 e0 0f             	and    $0xf,%eax
80103691:	c1 ea 04             	shr    $0x4,%edx
80103694:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103697:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010369a:	89 45 bc             	mov    %eax,-0x44(%ebp)
        CONV(hour);
8010369d:	8b 45 c0             	mov    -0x40(%ebp),%eax
801036a0:	89 c2                	mov    %eax,%edx
801036a2:	83 e0 0f             	and    $0xf,%eax
801036a5:	c1 ea 04             	shr    $0x4,%edx
801036a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801036ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801036ae:	89 45 c0             	mov    %eax,-0x40(%ebp)
        CONV(day);
801036b1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801036b4:	89 c2                	mov    %eax,%edx
801036b6:	83 e0 0f             	and    $0xf,%eax
801036b9:	c1 ea 04             	shr    $0x4,%edx
801036bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801036bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801036c2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        CONV(month);
801036c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
801036c8:	89 c2                	mov    %eax,%edx
801036ca:	83 e0 0f             	and    $0xf,%eax
801036cd:	c1 ea 04             	shr    $0x4,%edx
801036d0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801036d3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801036d6:	89 45 c8             	mov    %eax,-0x38(%ebp)
        CONV(year);
801036d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
801036dc:	89 c2                	mov    %eax,%edx
801036de:	83 e0 0f             	and    $0xf,%eax
801036e1:	c1 ea 04             	shr    $0x4,%edx
801036e4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801036e7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801036ea:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef CONV
    }

    *r = t1;
801036ed:	8b 75 08             	mov    0x8(%ebp),%esi
801036f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
801036f3:	89 06                	mov    %eax,(%esi)
801036f5:	8b 45 bc             	mov    -0x44(%ebp),%eax
801036f8:	89 46 04             	mov    %eax,0x4(%esi)
801036fb:	8b 45 c0             	mov    -0x40(%ebp),%eax
801036fe:	89 46 08             	mov    %eax,0x8(%esi)
80103701:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103704:	89 46 0c             	mov    %eax,0xc(%esi)
80103707:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010370a:	89 46 10             	mov    %eax,0x10(%esi)
8010370d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103710:	89 46 14             	mov    %eax,0x14(%esi)
    r->year += 2000;
80103713:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010371a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010371d:	5b                   	pop    %ebx
8010371e:	5e                   	pop    %esi
8010371f:	5f                   	pop    %edi
80103720:	5d                   	pop    %ebp
80103721:	c3                   	ret    
80103722:	66 90                	xchg   %ax,%ax
80103724:	66 90                	xchg   %ax,%ax
80103726:	66 90                	xchg   %ax,%ax
80103728:	66 90                	xchg   %ax,%ax
8010372a:	66 90                	xchg   %ax,%ax
8010372c:	66 90                	xchg   %ax,%ax
8010372e:	66 90                	xchg   %ax,%ax

80103730 <install_trans>:
// Copy committed blocks from log to their home location
static void
install_trans(void) {
    int tail;

    for (tail = 0; tail < log.lh.n; tail++) {
80103730:	8b 0d 68 3c 11 80    	mov    0x80113c68,%ecx
80103736:	85 c9                	test   %ecx,%ecx
80103738:	0f 8e 8a 00 00 00    	jle    801037c8 <install_trans+0x98>
install_trans(void) {
8010373e:	55                   	push   %ebp
8010373f:	89 e5                	mov    %esp,%ebp
80103741:	57                   	push   %edi
    for (tail = 0; tail < log.lh.n; tail++) {
80103742:	31 ff                	xor    %edi,%edi
install_trans(void) {
80103744:	56                   	push   %esi
80103745:	53                   	push   %ebx
80103746:	83 ec 0c             	sub    $0xc,%esp
80103749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        struct buf* lbuf = bread(log.dev, log.start + tail + 1); // read log block
80103750:	a1 54 3c 11 80       	mov    0x80113c54,%eax
80103755:	83 ec 08             	sub    $0x8,%esp
80103758:	01 f8                	add    %edi,%eax
8010375a:	83 c0 01             	add    $0x1,%eax
8010375d:	50                   	push   %eax
8010375e:	ff 35 64 3c 11 80    	pushl  0x80113c64
80103764:	e8 67 c9 ff ff       	call   801000d0 <bread>
80103769:	89 c6                	mov    %eax,%esi
        struct buf* dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
8010376b:	58                   	pop    %eax
8010376c:	5a                   	pop    %edx
8010376d:	ff 34 bd 6c 3c 11 80 	pushl  -0x7feec394(,%edi,4)
80103774:	ff 35 64 3c 11 80    	pushl  0x80113c64
    for (tail = 0; tail < log.lh.n; tail++) {
8010377a:	83 c7 01             	add    $0x1,%edi
        struct buf* dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
8010377d:	e8 4e c9 ff ff       	call   801000d0 <bread>
        memmove(dbuf->data, lbuf->data, BSIZE);                  // copy block to dst
80103782:	83 c4 0c             	add    $0xc,%esp
        struct buf* dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
80103785:	89 c3                	mov    %eax,%ebx
        memmove(dbuf->data, lbuf->data, BSIZE);                  // copy block to dst
80103787:	8d 46 5c             	lea    0x5c(%esi),%eax
8010378a:	68 00 02 00 00       	push   $0x200
8010378f:	50                   	push   %eax
80103790:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103793:	50                   	push   %eax
80103794:	e8 a7 1b 00 00       	call   80105340 <memmove>
        bwrite(dbuf);                                            // write dst to disk
80103799:	89 1c 24             	mov    %ebx,(%esp)
8010379c:	e8 0f ca ff ff       	call   801001b0 <bwrite>
        brelse(lbuf);
801037a1:	89 34 24             	mov    %esi,(%esp)
801037a4:	e8 47 ca ff ff       	call   801001f0 <brelse>
        brelse(dbuf);
801037a9:	89 1c 24             	mov    %ebx,(%esp)
801037ac:	e8 3f ca ff ff       	call   801001f0 <brelse>
    for (tail = 0; tail < log.lh.n; tail++) {
801037b1:	83 c4 10             	add    $0x10,%esp
801037b4:	39 3d 68 3c 11 80    	cmp    %edi,0x80113c68
801037ba:	7f 94                	jg     80103750 <install_trans+0x20>
    }
}
801037bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037bf:	5b                   	pop    %ebx
801037c0:	5e                   	pop    %esi
801037c1:	5f                   	pop    %edi
801037c2:	5d                   	pop    %ebp
801037c3:	c3                   	ret    
801037c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037c8:	c3                   	ret    
801037c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801037d0 <write_head>:

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void) {
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	53                   	push   %ebx
801037d4:	83 ec 0c             	sub    $0xc,%esp
    struct buf* buf = bread(log.dev, log.start);
801037d7:	ff 35 54 3c 11 80    	pushl  0x80113c54
801037dd:	ff 35 64 3c 11 80    	pushl  0x80113c64
801037e3:	e8 e8 c8 ff ff       	call   801000d0 <bread>
    struct logheader* hb = (struct logheader*)(buf->data);
    int i;
    hb->n = log.lh.n;
    for (i = 0; i < log.lh.n; i++) {
801037e8:	83 c4 10             	add    $0x10,%esp
    struct buf* buf = bread(log.dev, log.start);
801037eb:	89 c3                	mov    %eax,%ebx
    hb->n = log.lh.n;
801037ed:	a1 68 3c 11 80       	mov    0x80113c68,%eax
801037f2:	89 43 5c             	mov    %eax,0x5c(%ebx)
    for (i = 0; i < log.lh.n; i++) {
801037f5:	85 c0                	test   %eax,%eax
801037f7:	7e 19                	jle    80103812 <write_head+0x42>
801037f9:	31 d2                	xor    %edx,%edx
801037fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037ff:	90                   	nop
        hb->block[i] = log.lh.block[i];
80103800:	8b 0c 95 6c 3c 11 80 	mov    -0x7feec394(,%edx,4),%ecx
80103807:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
    for (i = 0; i < log.lh.n; i++) {
8010380b:	83 c2 01             	add    $0x1,%edx
8010380e:	39 d0                	cmp    %edx,%eax
80103810:	75 ee                	jne    80103800 <write_head+0x30>
    }
    bwrite(buf);
80103812:	83 ec 0c             	sub    $0xc,%esp
80103815:	53                   	push   %ebx
80103816:	e8 95 c9 ff ff       	call   801001b0 <bwrite>
    brelse(buf);
8010381b:	89 1c 24             	mov    %ebx,(%esp)
8010381e:	e8 cd c9 ff ff       	call   801001f0 <brelse>
}
80103823:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103826:	83 c4 10             	add    $0x10,%esp
80103829:	c9                   	leave  
8010382a:	c3                   	ret    
8010382b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010382f:	90                   	nop

80103830 <initlog>:
void initlog(int dev) {
80103830:	f3 0f 1e fb          	endbr32 
80103834:	55                   	push   %ebp
80103835:	89 e5                	mov    %esp,%ebp
80103837:	53                   	push   %ebx
80103838:	83 ec 2c             	sub    $0x2c,%esp
8010383b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    initlock(&log.lock, "log");
8010383e:	68 e0 82 10 80       	push   $0x801082e0
80103843:	68 20 3c 11 80       	push   $0x80113c20
80103848:	e8 c3 17 00 00       	call   80105010 <initlock>
    readsb(dev, &sb);
8010384d:	58                   	pop    %eax
8010384e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103851:	5a                   	pop    %edx
80103852:	50                   	push   %eax
80103853:	53                   	push   %ebx
80103854:	e8 47 e8 ff ff       	call   801020a0 <readsb>
    log.start = sb.logstart;
80103859:	8b 45 ec             	mov    -0x14(%ebp),%eax
    struct buf* buf = bread(log.dev, log.start);
8010385c:	59                   	pop    %ecx
    log.dev = dev;
8010385d:	89 1d 64 3c 11 80    	mov    %ebx,0x80113c64
    log.size = sb.nlog;
80103863:	8b 55 e8             	mov    -0x18(%ebp),%edx
    log.start = sb.logstart;
80103866:	a3 54 3c 11 80       	mov    %eax,0x80113c54
    log.size = sb.nlog;
8010386b:	89 15 58 3c 11 80    	mov    %edx,0x80113c58
    struct buf* buf = bread(log.dev, log.start);
80103871:	5a                   	pop    %edx
80103872:	50                   	push   %eax
80103873:	53                   	push   %ebx
80103874:	e8 57 c8 ff ff       	call   801000d0 <bread>
    for (i = 0; i < log.lh.n; i++) {
80103879:	83 c4 10             	add    $0x10,%esp
    log.lh.n = lh->n;
8010387c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010387f:	89 0d 68 3c 11 80    	mov    %ecx,0x80113c68
    for (i = 0; i < log.lh.n; i++) {
80103885:	85 c9                	test   %ecx,%ecx
80103887:	7e 19                	jle    801038a2 <initlog+0x72>
80103889:	31 d2                	xor    %edx,%edx
8010388b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010388f:	90                   	nop
        log.lh.block[i] = lh->block[i];
80103890:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103894:	89 1c 95 6c 3c 11 80 	mov    %ebx,-0x7feec394(,%edx,4)
    for (i = 0; i < log.lh.n; i++) {
8010389b:	83 c2 01             	add    $0x1,%edx
8010389e:	39 d1                	cmp    %edx,%ecx
801038a0:	75 ee                	jne    80103890 <initlog+0x60>
    brelse(buf);
801038a2:	83 ec 0c             	sub    $0xc,%esp
801038a5:	50                   	push   %eax
801038a6:	e8 45 c9 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void) {
    read_head();
    install_trans(); // if committed, copy from log to disk
801038ab:	e8 80 fe ff ff       	call   80103730 <install_trans>
    log.lh.n = 0;
801038b0:	c7 05 68 3c 11 80 00 	movl   $0x0,0x80113c68
801038b7:	00 00 00 
    write_head(); // clear the log
801038ba:	e8 11 ff ff ff       	call   801037d0 <write_head>
}
801038bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038c2:	83 c4 10             	add    $0x10,%esp
801038c5:	c9                   	leave  
801038c6:	c3                   	ret    
801038c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ce:	66 90                	xchg   %ax,%ax

801038d0 <begin_op>:
}

// called at the start of each FS system call.
void begin_op(void) {
801038d0:	f3 0f 1e fb          	endbr32 
801038d4:	55                   	push   %ebp
801038d5:	89 e5                	mov    %esp,%ebp
801038d7:	83 ec 14             	sub    $0x14,%esp
    acquire(&log.lock);
801038da:	68 20 3c 11 80       	push   $0x80113c20
801038df:	e8 ac 18 00 00       	call   80105190 <acquire>
801038e4:	83 c4 10             	add    $0x10,%esp
801038e7:	eb 1c                	jmp    80103905 <begin_op+0x35>
801038e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    while (1) {
        if (log.committing) {
            sleep(&log, &log.lock);
801038f0:	83 ec 08             	sub    $0x8,%esp
801038f3:	68 20 3c 11 80       	push   $0x80113c20
801038f8:	68 20 3c 11 80       	push   $0x80113c20
801038fd:	e8 ce 11 00 00       	call   80104ad0 <sleep>
80103902:	83 c4 10             	add    $0x10,%esp
        if (log.committing) {
80103905:	a1 60 3c 11 80       	mov    0x80113c60,%eax
8010390a:	85 c0                	test   %eax,%eax
8010390c:	75 e2                	jne    801038f0 <begin_op+0x20>
        }
        else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
8010390e:	a1 5c 3c 11 80       	mov    0x80113c5c,%eax
80103913:	8b 15 68 3c 11 80    	mov    0x80113c68,%edx
80103919:	83 c0 01             	add    $0x1,%eax
8010391c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010391f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103922:	83 fa 1e             	cmp    $0x1e,%edx
80103925:	7f c9                	jg     801038f0 <begin_op+0x20>
            // this op might exhaust log space; wait for commit.
            sleep(&log, &log.lock);
        }
        else {
            log.outstanding += 1;
            release(&log.lock);
80103927:	83 ec 0c             	sub    $0xc,%esp
            log.outstanding += 1;
8010392a:	a3 5c 3c 11 80       	mov    %eax,0x80113c5c
            release(&log.lock);
8010392f:	68 20 3c 11 80       	push   $0x80113c20
80103934:	e8 17 19 00 00       	call   80105250 <release>
            break;
        }
    }
}
80103939:	83 c4 10             	add    $0x10,%esp
8010393c:	c9                   	leave  
8010393d:	c3                   	ret    
8010393e:	66 90                	xchg   %ax,%ax

80103940 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void end_op(void) {
80103940:	f3 0f 1e fb          	endbr32 
80103944:	55                   	push   %ebp
80103945:	89 e5                	mov    %esp,%ebp
80103947:	57                   	push   %edi
80103948:	56                   	push   %esi
80103949:	53                   	push   %ebx
8010394a:	83 ec 18             	sub    $0x18,%esp
    int do_commit = 0;

    acquire(&log.lock);
8010394d:	68 20 3c 11 80       	push   $0x80113c20
80103952:	e8 39 18 00 00       	call   80105190 <acquire>
    log.outstanding -= 1;
80103957:	a1 5c 3c 11 80       	mov    0x80113c5c,%eax
    if (log.committing)
8010395c:	8b 35 60 3c 11 80    	mov    0x80113c60,%esi
80103962:	83 c4 10             	add    $0x10,%esp
    log.outstanding -= 1;
80103965:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103968:	89 1d 5c 3c 11 80    	mov    %ebx,0x80113c5c
    if (log.committing)
8010396e:	85 f6                	test   %esi,%esi
80103970:	0f 85 1e 01 00 00    	jne    80103a94 <end_op+0x154>
        panic("log.committing");
    if (log.outstanding == 0) {
80103976:	85 db                	test   %ebx,%ebx
80103978:	0f 85 f2 00 00 00    	jne    80103a70 <end_op+0x130>
        do_commit = 1;
        log.committing = 1;
8010397e:	c7 05 60 3c 11 80 01 	movl   $0x1,0x80113c60
80103985:	00 00 00 
        // begin_op() may be waiting for log space,
        // and decrementing log.outstanding has decreased
        // the amount of reserved space.
        wakeup(&log);
    }
    release(&log.lock);
80103988:	83 ec 0c             	sub    $0xc,%esp
8010398b:	68 20 3c 11 80       	push   $0x80113c20
80103990:	e8 bb 18 00 00       	call   80105250 <release>
    }
}

static void
commit() {
    if (log.lh.n > 0) {
80103995:	8b 0d 68 3c 11 80    	mov    0x80113c68,%ecx
8010399b:	83 c4 10             	add    $0x10,%esp
8010399e:	85 c9                	test   %ecx,%ecx
801039a0:	7f 3e                	jg     801039e0 <end_op+0xa0>
        acquire(&log.lock);
801039a2:	83 ec 0c             	sub    $0xc,%esp
801039a5:	68 20 3c 11 80       	push   $0x80113c20
801039aa:	e8 e1 17 00 00       	call   80105190 <acquire>
        wakeup(&log);
801039af:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
        log.committing = 0;
801039b6:	c7 05 60 3c 11 80 00 	movl   $0x0,0x80113c60
801039bd:	00 00 00 
        wakeup(&log);
801039c0:	e8 cb 12 00 00       	call   80104c90 <wakeup>
        release(&log.lock);
801039c5:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
801039cc:	e8 7f 18 00 00       	call   80105250 <release>
801039d1:	83 c4 10             	add    $0x10,%esp
}
801039d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039d7:	5b                   	pop    %ebx
801039d8:	5e                   	pop    %esi
801039d9:	5f                   	pop    %edi
801039da:	5d                   	pop    %ebp
801039db:	c3                   	ret    
801039dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        struct buf* to = bread(log.dev, log.start + tail + 1); // log block
801039e0:	a1 54 3c 11 80       	mov    0x80113c54,%eax
801039e5:	83 ec 08             	sub    $0x8,%esp
801039e8:	01 d8                	add    %ebx,%eax
801039ea:	83 c0 01             	add    $0x1,%eax
801039ed:	50                   	push   %eax
801039ee:	ff 35 64 3c 11 80    	pushl  0x80113c64
801039f4:	e8 d7 c6 ff ff       	call   801000d0 <bread>
801039f9:	89 c6                	mov    %eax,%esi
        struct buf* from = bread(log.dev, log.lh.block[tail]); // cache block
801039fb:	58                   	pop    %eax
801039fc:	5a                   	pop    %edx
801039fd:	ff 34 9d 6c 3c 11 80 	pushl  -0x7feec394(,%ebx,4)
80103a04:	ff 35 64 3c 11 80    	pushl  0x80113c64
    for (tail = 0; tail < log.lh.n; tail++) {
80103a0a:	83 c3 01             	add    $0x1,%ebx
        struct buf* from = bread(log.dev, log.lh.block[tail]); // cache block
80103a0d:	e8 be c6 ff ff       	call   801000d0 <bread>
        memmove(to->data, from->data, BSIZE);
80103a12:	83 c4 0c             	add    $0xc,%esp
        struct buf* from = bread(log.dev, log.lh.block[tail]); // cache block
80103a15:	89 c7                	mov    %eax,%edi
        memmove(to->data, from->data, BSIZE);
80103a17:	8d 40 5c             	lea    0x5c(%eax),%eax
80103a1a:	68 00 02 00 00       	push   $0x200
80103a1f:	50                   	push   %eax
80103a20:	8d 46 5c             	lea    0x5c(%esi),%eax
80103a23:	50                   	push   %eax
80103a24:	e8 17 19 00 00       	call   80105340 <memmove>
        bwrite(to); // write the log
80103a29:	89 34 24             	mov    %esi,(%esp)
80103a2c:	e8 7f c7 ff ff       	call   801001b0 <bwrite>
        brelse(from);
80103a31:	89 3c 24             	mov    %edi,(%esp)
80103a34:	e8 b7 c7 ff ff       	call   801001f0 <brelse>
        brelse(to);
80103a39:	89 34 24             	mov    %esi,(%esp)
80103a3c:	e8 af c7 ff ff       	call   801001f0 <brelse>
    for (tail = 0; tail < log.lh.n; tail++) {
80103a41:	83 c4 10             	add    $0x10,%esp
80103a44:	3b 1d 68 3c 11 80    	cmp    0x80113c68,%ebx
80103a4a:	7c 94                	jl     801039e0 <end_op+0xa0>
        write_log();     // Write modified blocks from cache to log
        write_head();    // Write header to disk -- the real commit
80103a4c:	e8 7f fd ff ff       	call   801037d0 <write_head>
        install_trans(); // Now install writes to home locations
80103a51:	e8 da fc ff ff       	call   80103730 <install_trans>
        log.lh.n = 0;
80103a56:	c7 05 68 3c 11 80 00 	movl   $0x0,0x80113c68
80103a5d:	00 00 00 
        write_head(); // Erase the transaction from the log
80103a60:	e8 6b fd ff ff       	call   801037d0 <write_head>
80103a65:	e9 38 ff ff ff       	jmp    801039a2 <end_op+0x62>
80103a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        wakeup(&log);
80103a70:	83 ec 0c             	sub    $0xc,%esp
80103a73:	68 20 3c 11 80       	push   $0x80113c20
80103a78:	e8 13 12 00 00       	call   80104c90 <wakeup>
    release(&log.lock);
80103a7d:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80103a84:	e8 c7 17 00 00       	call   80105250 <release>
80103a89:	83 c4 10             	add    $0x10,%esp
}
80103a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a8f:	5b                   	pop    %ebx
80103a90:	5e                   	pop    %esi
80103a91:	5f                   	pop    %edi
80103a92:	5d                   	pop    %ebp
80103a93:	c3                   	ret    
        panic("log.committing");
80103a94:	83 ec 0c             	sub    $0xc,%esp
80103a97:	68 e4 82 10 80       	push   $0x801082e4
80103a9c:	e8 ef c8 ff ff       	call   80100390 <panic>
80103aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aaf:	90                   	nop

80103ab0 <log_write>:
// log_write() replaces bwrite(); a typical use is:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void log_write(struct buf* b) {
80103ab0:	f3 0f 1e fb          	endbr32 
80103ab4:	55                   	push   %ebp
80103ab5:	89 e5                	mov    %esp,%ebp
80103ab7:	53                   	push   %ebx
80103ab8:	83 ec 04             	sub    $0x4,%esp
    int i;

    if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103abb:	8b 15 68 3c 11 80    	mov    0x80113c68,%edx
void log_write(struct buf* b) {
80103ac1:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103ac4:	83 fa 1d             	cmp    $0x1d,%edx
80103ac7:	0f 8f 91 00 00 00    	jg     80103b5e <log_write+0xae>
80103acd:	a1 58 3c 11 80       	mov    0x80113c58,%eax
80103ad2:	83 e8 01             	sub    $0x1,%eax
80103ad5:	39 c2                	cmp    %eax,%edx
80103ad7:	0f 8d 81 00 00 00    	jge    80103b5e <log_write+0xae>
        panic("too big a transaction");
    if (log.outstanding < 1)
80103add:	a1 5c 3c 11 80       	mov    0x80113c5c,%eax
80103ae2:	85 c0                	test   %eax,%eax
80103ae4:	0f 8e 81 00 00 00    	jle    80103b6b <log_write+0xbb>
        panic("log_write outside of trans");

    acquire(&log.lock);
80103aea:	83 ec 0c             	sub    $0xc,%esp
80103aed:	68 20 3c 11 80       	push   $0x80113c20
80103af2:	e8 99 16 00 00       	call   80105190 <acquire>
    for (i = 0; i < log.lh.n; i++) {
80103af7:	8b 15 68 3c 11 80    	mov    0x80113c68,%edx
80103afd:	83 c4 10             	add    $0x10,%esp
80103b00:	85 d2                	test   %edx,%edx
80103b02:	7e 4e                	jle    80103b52 <log_write+0xa2>
        if (log.lh.block[i] == b->blockno) // log absorbtion
80103b04:	8b 4b 08             	mov    0x8(%ebx),%ecx
    for (i = 0; i < log.lh.n; i++) {
80103b07:	31 c0                	xor    %eax,%eax
80103b09:	eb 0c                	jmp    80103b17 <log_write+0x67>
80103b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b0f:	90                   	nop
80103b10:	83 c0 01             	add    $0x1,%eax
80103b13:	39 c2                	cmp    %eax,%edx
80103b15:	74 29                	je     80103b40 <log_write+0x90>
        if (log.lh.block[i] == b->blockno) // log absorbtion
80103b17:	39 0c 85 6c 3c 11 80 	cmp    %ecx,-0x7feec394(,%eax,4)
80103b1e:	75 f0                	jne    80103b10 <log_write+0x60>
            break;
    }
    log.lh.block[i] = b->blockno;
80103b20:	89 0c 85 6c 3c 11 80 	mov    %ecx,-0x7feec394(,%eax,4)
    if (i == log.lh.n)
        log.lh.n++;
    b->flags |= B_DIRTY; // prevent eviction
80103b27:	83 0b 04             	orl    $0x4,(%ebx)
    release(&log.lock);
}
80103b2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    release(&log.lock);
80103b2d:	c7 45 08 20 3c 11 80 	movl   $0x80113c20,0x8(%ebp)
}
80103b34:	c9                   	leave  
    release(&log.lock);
80103b35:	e9 16 17 00 00       	jmp    80105250 <release>
80103b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = b->blockno;
80103b40:	89 0c 95 6c 3c 11 80 	mov    %ecx,-0x7feec394(,%edx,4)
        log.lh.n++;
80103b47:	83 c2 01             	add    $0x1,%edx
80103b4a:	89 15 68 3c 11 80    	mov    %edx,0x80113c68
80103b50:	eb d5                	jmp    80103b27 <log_write+0x77>
    log.lh.block[i] = b->blockno;
80103b52:	8b 43 08             	mov    0x8(%ebx),%eax
80103b55:	a3 6c 3c 11 80       	mov    %eax,0x80113c6c
    if (i == log.lh.n)
80103b5a:	75 cb                	jne    80103b27 <log_write+0x77>
80103b5c:	eb e9                	jmp    80103b47 <log_write+0x97>
        panic("too big a transaction");
80103b5e:	83 ec 0c             	sub    $0xc,%esp
80103b61:	68 f3 82 10 80       	push   $0x801082f3
80103b66:	e8 25 c8 ff ff       	call   80100390 <panic>
        panic("log_write outside of trans");
80103b6b:	83 ec 0c             	sub    $0xc,%esp
80103b6e:	68 09 83 10 80       	push   $0x80108309
80103b73:	e8 18 c8 ff ff       	call   80100390 <panic>
80103b78:	66 90                	xchg   %ax,%ax
80103b7a:	66 90                	xchg   %ax,%ax
80103b7c:	66 90                	xchg   %ax,%ax
80103b7e:	66 90                	xchg   %ax,%ax

80103b80 <mpmain>:
    mpmain();
}

// Common CPU setup code.
static void
mpmain(void) {
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	53                   	push   %ebx
80103b84:	83 ec 04             	sub    $0x4,%esp
    cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103b87:	e8 54 09 00 00       	call   801044e0 <cpuid>
80103b8c:	89 c3                	mov    %eax,%ebx
80103b8e:	e8 4d 09 00 00       	call   801044e0 <cpuid>
80103b93:	83 ec 04             	sub    $0x4,%esp
80103b96:	53                   	push   %ebx
80103b97:	50                   	push   %eax
80103b98:	68 24 83 10 80       	push   $0x80108324
80103b9d:	e8 1e cc ff ff       	call   801007c0 <cprintf>
    idtinit();                    // load idt register
80103ba2:	e8 79 2a 00 00       	call   80106620 <idtinit>
    xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103ba7:	e8 c4 08 00 00       	call   80104470 <mycpu>
80103bac:	89 c2                	mov    %eax,%edx
static inline uint
xchg(volatile uint* addr, uint newval) {
    uint result;

    // The + in "+m" denotes a read-modify-write operand.
    asm volatile("lock; xchgl %0, %1"
80103bae:	b8 01 00 00 00       	mov    $0x1,%eax
80103bb3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
    scheduler();                  // start running processes
80103bba:	e8 21 0c 00 00       	call   801047e0 <scheduler>
80103bbf:	90                   	nop

80103bc0 <mpenter>:
mpenter(void) {
80103bc0:	f3 0f 1e fb          	endbr32 
80103bc4:	55                   	push   %ebp
80103bc5:	89 e5                	mov    %esp,%ebp
80103bc7:	83 ec 08             	sub    $0x8,%esp
    switchkvm();
80103bca:	e8 21 3b 00 00       	call   801076f0 <switchkvm>
    seginit();
80103bcf:	e8 8c 3a 00 00       	call   80107660 <seginit>
    lapicinit();
80103bd4:	e8 67 f7 ff ff       	call   80103340 <lapicinit>
    mpmain();
80103bd9:	e8 a2 ff ff ff       	call   80103b80 <mpmain>
80103bde:	66 90                	xchg   %ax,%ax

80103be0 <main>:
int main(void) {
80103be0:	f3 0f 1e fb          	endbr32 
80103be4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103be8:	83 e4 f0             	and    $0xfffffff0,%esp
80103beb:	ff 71 fc             	pushl  -0x4(%ecx)
80103bee:	55                   	push   %ebp
80103bef:	89 e5                	mov    %esp,%ebp
80103bf1:	53                   	push   %ebx
80103bf2:	51                   	push   %ecx
    kinit1(end, P2V(4 * 1024 * 1024));          // phys page allocator
80103bf3:	83 ec 08             	sub    $0x8,%esp
80103bf6:	68 00 00 40 80       	push   $0x80400000
80103bfb:	68 48 6b 11 80       	push   $0x80116b48
80103c00:	e8 fb f4 ff ff       	call   80103100 <kinit1>
    kvmalloc();                                 // kernel page table
80103c05:	e8 c6 3f 00 00       	call   80107bd0 <kvmalloc>
    mpinit();                                   // detect other processors
80103c0a:	e8 81 01 00 00       	call   80103d90 <mpinit>
    lapicinit();                                // interrupt controller
80103c0f:	e8 2c f7 ff ff       	call   80103340 <lapicinit>
    seginit();                                  // segment descriptors
80103c14:	e8 47 3a 00 00       	call   80107660 <seginit>
    picinit();                                  // disable pic
80103c19:	e8 52 03 00 00       	call   80103f70 <picinit>
    ioapicinit();                               // another interrupt controller
80103c1e:	e8 fd f2 ff ff       	call   80102f20 <ioapicinit>
    consoleinit();                              // console hardware
80103c23:	e8 f8 d8 ff ff       	call   80101520 <consoleinit>
    uartinit();                                 // serial port
80103c28:	e8 f3 2c 00 00       	call   80106920 <uartinit>
    pinit();                                    // process table
80103c2d:	e8 1e 08 00 00       	call   80104450 <pinit>
    tvinit();                                   // trap vectors
80103c32:	e8 69 29 00 00       	call   801065a0 <tvinit>
    binit();                                    // buffer cache
80103c37:	e8 04 c4 ff ff       	call   80100040 <binit>
    fileinit();                                 // file table
80103c3c:	e8 8f dc ff ff       	call   801018d0 <fileinit>
    ideinit();                                  // disk
80103c41:	e8 aa f0 ff ff       	call   80102cf0 <ideinit>

    // Write entry code to unused memory at 0x7000.
    // The linker has placed the image of entryother.S in
    // _binary_entryother_start.
    code = P2V(0x7000);
    memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103c46:	83 c4 0c             	add    $0xc,%esp
80103c49:	68 8a 00 00 00       	push   $0x8a
80103c4e:	68 8c b4 10 80       	push   $0x8010b48c
80103c53:	68 00 70 00 80       	push   $0x80007000
80103c58:	e8 e3 16 00 00       	call   80105340 <memmove>

    for (c = cpus; c < cpus + ncpu; c++) {
80103c5d:	83 c4 10             	add    $0x10,%esp
80103c60:	69 05 a0 42 11 80 b0 	imul   $0xb0,0x801142a0,%eax
80103c67:	00 00 00 
80103c6a:	05 20 3d 11 80       	add    $0x80113d20,%eax
80103c6f:	3d 20 3d 11 80       	cmp    $0x80113d20,%eax
80103c74:	76 7a                	jbe    80103cf0 <main+0x110>
80103c76:	bb 20 3d 11 80       	mov    $0x80113d20,%ebx
80103c7b:	eb 1c                	jmp    80103c99 <main+0xb9>
80103c7d:	8d 76 00             	lea    0x0(%esi),%esi
80103c80:	69 05 a0 42 11 80 b0 	imul   $0xb0,0x801142a0,%eax
80103c87:	00 00 00 
80103c8a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103c90:	05 20 3d 11 80       	add    $0x80113d20,%eax
80103c95:	39 c3                	cmp    %eax,%ebx
80103c97:	73 57                	jae    80103cf0 <main+0x110>
        if (c == mycpu()) // We've started already.
80103c99:	e8 d2 07 00 00       	call   80104470 <mycpu>
80103c9e:	39 c3                	cmp    %eax,%ebx
80103ca0:	74 de                	je     80103c80 <main+0xa0>
            continue;

        // Tell entryother.S what stack to use, where to enter, and what
        // pgdir to use. We cannot use kpgdir yet, because the AP processor
        // is running in low  memory, so we use entrypgdir for the APs too.
        stack = kalloc();
80103ca2:	e8 29 f5 ff ff       	call   801031d0 <kalloc>
        *(void**)(code - 4) = stack + KSTACKSIZE;
        *(void (**)(void))(code - 8) = mpenter;
        *(int**)(code - 12) = (void*)V2P(entrypgdir);

        lapicstartap(c->apicid, V2P(code));
80103ca7:	83 ec 08             	sub    $0x8,%esp
        *(void (**)(void))(code - 8) = mpenter;
80103caa:	c7 05 f8 6f 00 80 c0 	movl   $0x80103bc0,0x80006ff8
80103cb1:	3b 10 80 
        *(int**)(code - 12) = (void*)V2P(entrypgdir);
80103cb4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103cbb:	a0 10 00 
        *(void**)(code - 4) = stack + KSTACKSIZE;
80103cbe:	05 00 10 00 00       	add    $0x1000,%eax
80103cc3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
        lapicstartap(c->apicid, V2P(code));
80103cc8:	0f b6 03             	movzbl (%ebx),%eax
80103ccb:	68 00 70 00 00       	push   $0x7000
80103cd0:	50                   	push   %eax
80103cd1:	e8 ba f7 ff ff       	call   80103490 <lapicstartap>

        // wait for cpu to finish mpmain()
        while (c->started == 0)
80103cd6:	83 c4 10             	add    $0x10,%esp
80103cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ce0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103ce6:	85 c0                	test   %eax,%eax
80103ce8:	74 f6                	je     80103ce0 <main+0x100>
80103cea:	eb 94                	jmp    80103c80 <main+0xa0>
80103cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kinit2(P2V(4 * 1024 * 1024), P2V(PHYSTOP)); // must come after startothers()
80103cf0:	83 ec 08             	sub    $0x8,%esp
80103cf3:	68 00 00 00 8e       	push   $0x8e000000
80103cf8:	68 00 00 40 80       	push   $0x80400000
80103cfd:	e8 6e f4 ff ff       	call   80103170 <kinit2>
    userinit();                                 // first user process
80103d02:	e8 29 08 00 00       	call   80104530 <userinit>
    mpmain();                                   // finish this processor's setup
80103d07:	e8 74 fe ff ff       	call   80103b80 <mpmain>
80103d0c:	66 90                	xchg   %ax,%ax
80103d0e:	66 90                	xchg   %ax,%ax

80103d10 <mpsearch1>:
    return sum;
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len) {
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	57                   	push   %edi
80103d14:	56                   	push   %esi
    uchar *e, *p, *addr;

    addr = P2V(a);
80103d15:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
mpsearch1(uint a, int len) {
80103d1b:	53                   	push   %ebx
    e = addr + len;
80103d1c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
mpsearch1(uint a, int len) {
80103d1f:	83 ec 0c             	sub    $0xc,%esp
    for (p = addr; p < e; p += sizeof(struct mp))
80103d22:	39 de                	cmp    %ebx,%esi
80103d24:	72 10                	jb     80103d36 <mpsearch1+0x26>
80103d26:	eb 50                	jmp    80103d78 <mpsearch1+0x68>
80103d28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d2f:	90                   	nop
80103d30:	89 fe                	mov    %edi,%esi
80103d32:	39 fb                	cmp    %edi,%ebx
80103d34:	76 42                	jbe    80103d78 <mpsearch1+0x68>
        if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103d36:	83 ec 04             	sub    $0x4,%esp
80103d39:	8d 7e 10             	lea    0x10(%esi),%edi
80103d3c:	6a 04                	push   $0x4
80103d3e:	68 38 83 10 80       	push   $0x80108338
80103d43:	56                   	push   %esi
80103d44:	e8 a7 15 00 00       	call   801052f0 <memcmp>
80103d49:	83 c4 10             	add    $0x10,%esp
80103d4c:	85 c0                	test   %eax,%eax
80103d4e:	75 e0                	jne    80103d30 <mpsearch1+0x20>
80103d50:	89 f2                	mov    %esi,%edx
80103d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        sum += addr[i];
80103d58:	0f b6 0a             	movzbl (%edx),%ecx
80103d5b:	83 c2 01             	add    $0x1,%edx
80103d5e:	01 c8                	add    %ecx,%eax
    for (i = 0; i < len; i++)
80103d60:	39 fa                	cmp    %edi,%edx
80103d62:	75 f4                	jne    80103d58 <mpsearch1+0x48>
        if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103d64:	84 c0                	test   %al,%al
80103d66:	75 c8                	jne    80103d30 <mpsearch1+0x20>
            return (struct mp*)p;
    return 0;
}
80103d68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d6b:	89 f0                	mov    %esi,%eax
80103d6d:	5b                   	pop    %ebx
80103d6e:	5e                   	pop    %esi
80103d6f:	5f                   	pop    %edi
80103d70:	5d                   	pop    %ebp
80103d71:	c3                   	ret    
80103d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80103d7b:	31 f6                	xor    %esi,%esi
}
80103d7d:	5b                   	pop    %ebx
80103d7e:	89 f0                	mov    %esi,%eax
80103d80:	5e                   	pop    %esi
80103d81:	5f                   	pop    %edi
80103d82:	5d                   	pop    %ebp
80103d83:	c3                   	ret    
80103d84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d8f:	90                   	nop

80103d90 <mpinit>:
        return 0;
    *pmp = mp;
    return conf;
}

void mpinit(void) {
80103d90:	f3 0f 1e fb          	endbr32 
80103d94:	55                   	push   %ebp
80103d95:	89 e5                	mov    %esp,%ebp
80103d97:	57                   	push   %edi
80103d98:	56                   	push   %esi
80103d99:	53                   	push   %ebx
80103d9a:	83 ec 1c             	sub    $0x1c,%esp
    if ((p = ((bda[0x0F] << 8) | bda[0x0E]) << 4)) {
80103d9d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103da4:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103dab:	c1 e0 08             	shl    $0x8,%eax
80103dae:	09 d0                	or     %edx,%eax
80103db0:	c1 e0 04             	shl    $0x4,%eax
80103db3:	75 1b                	jne    80103dd0 <mpinit+0x40>
        p = ((bda[0x14] << 8) | bda[0x13]) * 1024;
80103db5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103dbc:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103dc3:	c1 e0 08             	shl    $0x8,%eax
80103dc6:	09 d0                	or     %edx,%eax
80103dc8:	c1 e0 0a             	shl    $0xa,%eax
        if ((mp = mpsearch1(p - 1024, 1024)))
80103dcb:	2d 00 04 00 00       	sub    $0x400,%eax
        if ((mp = mpsearch1(p, 1024)))
80103dd0:	ba 00 04 00 00       	mov    $0x400,%edx
80103dd5:	e8 36 ff ff ff       	call   80103d10 <mpsearch1>
80103dda:	89 c6                	mov    %eax,%esi
80103ddc:	85 c0                	test   %eax,%eax
80103dde:	0f 84 4c 01 00 00    	je     80103f30 <mpinit+0x1a0>
    if ((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103de4:	8b 5e 04             	mov    0x4(%esi),%ebx
80103de7:	85 db                	test   %ebx,%ebx
80103de9:	0f 84 61 01 00 00    	je     80103f50 <mpinit+0x1c0>
    if (memcmp(conf, "PCMP", 4) != 0)
80103def:	83 ec 04             	sub    $0x4,%esp
    conf = (struct mpconf*)P2V((uint)mp->physaddr);
80103df2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
    if (memcmp(conf, "PCMP", 4) != 0)
80103df8:	6a 04                	push   $0x4
80103dfa:	68 3d 83 10 80       	push   $0x8010833d
80103dff:	50                   	push   %eax
    conf = (struct mpconf*)P2V((uint)mp->physaddr);
80103e00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (memcmp(conf, "PCMP", 4) != 0)
80103e03:	e8 e8 14 00 00       	call   801052f0 <memcmp>
80103e08:	83 c4 10             	add    $0x10,%esp
80103e0b:	85 c0                	test   %eax,%eax
80103e0d:	0f 85 3d 01 00 00    	jne    80103f50 <mpinit+0x1c0>
    if (conf->version != 1 && conf->version != 4)
80103e13:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103e1a:	3c 01                	cmp    $0x1,%al
80103e1c:	74 08                	je     80103e26 <mpinit+0x96>
80103e1e:	3c 04                	cmp    $0x4,%al
80103e20:	0f 85 2a 01 00 00    	jne    80103f50 <mpinit+0x1c0>
    if (sum((uchar*)conf, conf->length) != 0)
80103e26:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
    for (i = 0; i < len; i++)
80103e2d:	66 85 d2             	test   %dx,%dx
80103e30:	74 26                	je     80103e58 <mpinit+0xc8>
80103e32:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103e35:	89 d8                	mov    %ebx,%eax
    sum = 0;
80103e37:	31 d2                	xor    %edx,%edx
80103e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        sum += addr[i];
80103e40:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103e47:	83 c0 01             	add    $0x1,%eax
80103e4a:	01 ca                	add    %ecx,%edx
    for (i = 0; i < len; i++)
80103e4c:	39 f8                	cmp    %edi,%eax
80103e4e:	75 f0                	jne    80103e40 <mpinit+0xb0>
    if (sum((uchar*)conf, conf->length) != 0)
80103e50:	84 d2                	test   %dl,%dl
80103e52:	0f 85 f8 00 00 00    	jne    80103f50 <mpinit+0x1c0>
    struct mpioapic* ioapic;

    if ((conf = mpconfig(&mp)) == 0)
        panic("Expect to run on an SMP");
    ismp = 1;
    lapic = (uint*)conf->lapicaddr;
80103e58:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103e5e:	a3 1c 3c 11 80       	mov    %eax,0x80113c1c
    for (p = (uchar*)(conf + 1), e = (uchar*)conf + conf->length; p < e;) {
80103e63:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103e69:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
    ismp = 1;
80103e70:	bb 01 00 00 00       	mov    $0x1,%ebx
    for (p = (uchar*)(conf + 1), e = (uchar*)conf + conf->length; p < e;) {
80103e75:	03 55 e4             	add    -0x1c(%ebp),%edx
80103e78:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e7f:	90                   	nop
80103e80:	39 c2                	cmp    %eax,%edx
80103e82:	76 15                	jbe    80103e99 <mpinit+0x109>
        switch (*p) {
80103e84:	0f b6 08             	movzbl (%eax),%ecx
80103e87:	80 f9 02             	cmp    $0x2,%cl
80103e8a:	74 5c                	je     80103ee8 <mpinit+0x158>
80103e8c:	77 42                	ja     80103ed0 <mpinit+0x140>
80103e8e:	84 c9                	test   %cl,%cl
80103e90:	74 6e                	je     80103f00 <mpinit+0x170>
            p += sizeof(struct mpioapic);
            continue;
        case MPBUS:
        case MPIOINTR:
        case MPLINTR:
            p += 8;
80103e92:	83 c0 08             	add    $0x8,%eax
    for (p = (uchar*)(conf + 1), e = (uchar*)conf + conf->length; p < e;) {
80103e95:	39 c2                	cmp    %eax,%edx
80103e97:	77 eb                	ja     80103e84 <mpinit+0xf4>
80103e99:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
        default:
            ismp = 0;
            break;
        }
    }
    if (!ismp)
80103e9c:	85 db                	test   %ebx,%ebx
80103e9e:	0f 84 b9 00 00 00    	je     80103f5d <mpinit+0x1cd>
        panic("Didn't find a suitable machine");

    if (mp->imcrp) {
80103ea4:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103ea8:	74 15                	je     80103ebf <mpinit+0x12f>
    asm volatile("out %0,%1"
80103eaa:	b8 70 00 00 00       	mov    $0x70,%eax
80103eaf:	ba 22 00 00 00       	mov    $0x22,%edx
80103eb4:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80103eb5:	ba 23 00 00 00       	mov    $0x23,%edx
80103eba:	ec                   	in     (%dx),%al
        // Bochs doesn't support IMCR, so this doesn't run on Bochs.
        // But it would on real hardware.
        outb(0x22, 0x70);          // Select IMCR
        outb(0x23, inb(0x23) | 1); // Mask external interrupts.
80103ebb:	83 c8 01             	or     $0x1,%eax
    asm volatile("out %0,%1"
80103ebe:	ee                   	out    %al,(%dx)
    }
}
80103ebf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ec2:	5b                   	pop    %ebx
80103ec3:	5e                   	pop    %esi
80103ec4:	5f                   	pop    %edi
80103ec5:	5d                   	pop    %ebp
80103ec6:	c3                   	ret    
80103ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ece:	66 90                	xchg   %ax,%ax
        switch (*p) {
80103ed0:	83 e9 03             	sub    $0x3,%ecx
80103ed3:	80 f9 01             	cmp    $0x1,%cl
80103ed6:	76 ba                	jbe    80103e92 <mpinit+0x102>
80103ed8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103edf:	eb 9f                	jmp    80103e80 <mpinit+0xf0>
80103ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            ioapicid = ioapic->apicno;
80103ee8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
            p += sizeof(struct mpioapic);
80103eec:	83 c0 08             	add    $0x8,%eax
            ioapicid = ioapic->apicno;
80103eef:	88 0d 00 3d 11 80    	mov    %cl,0x80113d00
            continue;
80103ef5:	eb 89                	jmp    80103e80 <mpinit+0xf0>
80103ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103efe:	66 90                	xchg   %ax,%ax
            if (ncpu < NCPU) {
80103f00:	8b 0d a0 42 11 80    	mov    0x801142a0,%ecx
80103f06:	83 f9 07             	cmp    $0x7,%ecx
80103f09:	7f 19                	jg     80103f24 <mpinit+0x194>
                cpus[ncpu].apicid = proc->apicid; // apicid may differ from ncpu
80103f0b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103f11:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
                ncpu++;
80103f15:	83 c1 01             	add    $0x1,%ecx
80103f18:	89 0d a0 42 11 80    	mov    %ecx,0x801142a0
                cpus[ncpu].apicid = proc->apicid; // apicid may differ from ncpu
80103f1e:	88 9f 20 3d 11 80    	mov    %bl,-0x7feec2e0(%edi)
            p += sizeof(struct mpproc);
80103f24:	83 c0 14             	add    $0x14,%eax
            continue;
80103f27:	e9 54 ff ff ff       	jmp    80103e80 <mpinit+0xf0>
80103f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return mpsearch1(0xF0000, 0x10000);
80103f30:	ba 00 00 01 00       	mov    $0x10000,%edx
80103f35:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103f3a:	e8 d1 fd ff ff       	call   80103d10 <mpsearch1>
80103f3f:	89 c6                	mov    %eax,%esi
    if ((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103f41:	85 c0                	test   %eax,%eax
80103f43:	0f 85 9b fe ff ff    	jne    80103de4 <mpinit+0x54>
80103f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        panic("Expect to run on an SMP");
80103f50:	83 ec 0c             	sub    $0xc,%esp
80103f53:	68 42 83 10 80       	push   $0x80108342
80103f58:	e8 33 c4 ff ff       	call   80100390 <panic>
        panic("Didn't find a suitable machine");
80103f5d:	83 ec 0c             	sub    $0xc,%esp
80103f60:	68 5c 83 10 80       	push   $0x8010835c
80103f65:	e8 26 c4 ff ff       	call   80100390 <panic>
80103f6a:	66 90                	xchg   %ax,%ax
80103f6c:	66 90                	xchg   %ax,%ax
80103f6e:	66 90                	xchg   %ax,%ax

80103f70 <picinit>:
// I/O Addresses of the two programmable interrupt controllers
#define IO_PIC1 0x20 // Master (IRQs 0-7)
#define IO_PIC2 0xA0 // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void picinit(void) {
80103f70:	f3 0f 1e fb          	endbr32 
80103f74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f79:	ba 21 00 00 00       	mov    $0x21,%edx
80103f7e:	ee                   	out    %al,(%dx)
80103f7f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103f84:	ee                   	out    %al,(%dx)
    // mask all interrupts
    outb(IO_PIC1 + 1, 0xFF);
    outb(IO_PIC2 + 1, 0xFF);
}
80103f85:	c3                   	ret    
80103f86:	66 90                	xchg   %ax,%ax
80103f88:	66 90                	xchg   %ax,%ax
80103f8a:	66 90                	xchg   %ax,%ax
80103f8c:	66 90                	xchg   %ax,%ax
80103f8e:	66 90                	xchg   %ax,%ax

80103f90 <pipealloc>:
    uint nwrite;   // number of bytes written
    int readopen;  // read fd is still open
    int writeopen; // write fd is still open
};

int pipealloc(struct file** f0, struct file** f1) {
80103f90:	f3 0f 1e fb          	endbr32 
80103f94:	55                   	push   %ebp
80103f95:	89 e5                	mov    %esp,%ebp
80103f97:	57                   	push   %edi
80103f98:	56                   	push   %esi
80103f99:	53                   	push   %ebx
80103f9a:	83 ec 0c             	sub    $0xc,%esp
80103f9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103fa0:	8b 75 0c             	mov    0xc(%ebp),%esi
    struct pipe* p;

    p = 0;
    *f0 = *f1 = 0;
80103fa3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103fa9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103faf:	e8 3c d9 ff ff       	call   801018f0 <filealloc>
80103fb4:	89 03                	mov    %eax,(%ebx)
80103fb6:	85 c0                	test   %eax,%eax
80103fb8:	0f 84 ac 00 00 00    	je     8010406a <pipealloc+0xda>
80103fbe:	e8 2d d9 ff ff       	call   801018f0 <filealloc>
80103fc3:	89 06                	mov    %eax,(%esi)
80103fc5:	85 c0                	test   %eax,%eax
80103fc7:	0f 84 8b 00 00 00    	je     80104058 <pipealloc+0xc8>
        goto bad;
    if ((p = (struct pipe*)kalloc()) == 0)
80103fcd:	e8 fe f1 ff ff       	call   801031d0 <kalloc>
80103fd2:	89 c7                	mov    %eax,%edi
80103fd4:	85 c0                	test   %eax,%eax
80103fd6:	0f 84 b4 00 00 00    	je     80104090 <pipealloc+0x100>
        goto bad;
    p->readopen = 1;
80103fdc:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103fe3:	00 00 00 
    p->writeopen = 1;
    p->nwrite = 0;
    p->nread = 0;
    initlock(&p->lock, "pipe");
80103fe6:	83 ec 08             	sub    $0x8,%esp
    p->writeopen = 1;
80103fe9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103ff0:	00 00 00 
    p->nwrite = 0;
80103ff3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103ffa:	00 00 00 
    p->nread = 0;
80103ffd:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104004:	00 00 00 
    initlock(&p->lock, "pipe");
80104007:	68 7b 83 10 80       	push   $0x8010837b
8010400c:	50                   	push   %eax
8010400d:	e8 fe 0f 00 00       	call   80105010 <initlock>
    (*f0)->type = FD_PIPE;
80104012:	8b 03                	mov    (%ebx),%eax
    (*f0)->pipe = p;
    (*f1)->type = FD_PIPE;
    (*f1)->readable = 0;
    (*f1)->writable = 1;
    (*f1)->pipe = p;
    return 0;
80104014:	83 c4 10             	add    $0x10,%esp
    (*f0)->type = FD_PIPE;
80104017:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    (*f0)->readable = 1;
8010401d:	8b 03                	mov    (%ebx),%eax
8010401f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
    (*f0)->writable = 0;
80104023:	8b 03                	mov    (%ebx),%eax
80104025:	c6 40 09 00          	movb   $0x0,0x9(%eax)
    (*f0)->pipe = p;
80104029:	8b 03                	mov    (%ebx),%eax
8010402b:	89 78 0c             	mov    %edi,0xc(%eax)
    (*f1)->type = FD_PIPE;
8010402e:	8b 06                	mov    (%esi),%eax
80104030:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    (*f1)->readable = 0;
80104036:	8b 06                	mov    (%esi),%eax
80104038:	c6 40 08 00          	movb   $0x0,0x8(%eax)
    (*f1)->writable = 1;
8010403c:	8b 06                	mov    (%esi),%eax
8010403e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
    (*f1)->pipe = p;
80104042:	8b 06                	mov    (%esi),%eax
80104044:	89 78 0c             	mov    %edi,0xc(%eax)
    if (*f0)
        fileclose(*f0);
    if (*f1)
        fileclose(*f1);
    return -1;
}
80104047:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
8010404a:	31 c0                	xor    %eax,%eax
}
8010404c:	5b                   	pop    %ebx
8010404d:	5e                   	pop    %esi
8010404e:	5f                   	pop    %edi
8010404f:	5d                   	pop    %ebp
80104050:	c3                   	ret    
80104051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (*f0)
80104058:	8b 03                	mov    (%ebx),%eax
8010405a:	85 c0                	test   %eax,%eax
8010405c:	74 1e                	je     8010407c <pipealloc+0xec>
        fileclose(*f0);
8010405e:	83 ec 0c             	sub    $0xc,%esp
80104061:	50                   	push   %eax
80104062:	e8 49 d9 ff ff       	call   801019b0 <fileclose>
80104067:	83 c4 10             	add    $0x10,%esp
    if (*f1)
8010406a:	8b 06                	mov    (%esi),%eax
8010406c:	85 c0                	test   %eax,%eax
8010406e:	74 0c                	je     8010407c <pipealloc+0xec>
        fileclose(*f1);
80104070:	83 ec 0c             	sub    $0xc,%esp
80104073:	50                   	push   %eax
80104074:	e8 37 d9 ff ff       	call   801019b0 <fileclose>
80104079:	83 c4 10             	add    $0x10,%esp
}
8010407c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010407f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104084:	5b                   	pop    %ebx
80104085:	5e                   	pop    %esi
80104086:	5f                   	pop    %edi
80104087:	5d                   	pop    %ebp
80104088:	c3                   	ret    
80104089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (*f0)
80104090:	8b 03                	mov    (%ebx),%eax
80104092:	85 c0                	test   %eax,%eax
80104094:	75 c8                	jne    8010405e <pipealloc+0xce>
80104096:	eb d2                	jmp    8010406a <pipealloc+0xda>
80104098:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010409f:	90                   	nop

801040a0 <pipeclose>:

void pipeclose(struct pipe* p, int writable) {
801040a0:	f3 0f 1e fb          	endbr32 
801040a4:	55                   	push   %ebp
801040a5:	89 e5                	mov    %esp,%ebp
801040a7:	56                   	push   %esi
801040a8:	53                   	push   %ebx
801040a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801040ac:	8b 75 0c             	mov    0xc(%ebp),%esi
    acquire(&p->lock);
801040af:	83 ec 0c             	sub    $0xc,%esp
801040b2:	53                   	push   %ebx
801040b3:	e8 d8 10 00 00       	call   80105190 <acquire>
    if (writable) {
801040b8:	83 c4 10             	add    $0x10,%esp
801040bb:	85 f6                	test   %esi,%esi
801040bd:	74 41                	je     80104100 <pipeclose+0x60>
        p->writeopen = 0;
        wakeup(&p->nread);
801040bf:	83 ec 0c             	sub    $0xc,%esp
801040c2:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
        p->writeopen = 0;
801040c8:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801040cf:	00 00 00 
        wakeup(&p->nread);
801040d2:	50                   	push   %eax
801040d3:	e8 b8 0b 00 00       	call   80104c90 <wakeup>
801040d8:	83 c4 10             	add    $0x10,%esp
    }
    else {
        p->readopen = 0;
        wakeup(&p->nwrite);
    }
    if (p->readopen == 0 && p->writeopen == 0) {
801040db:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801040e1:	85 d2                	test   %edx,%edx
801040e3:	75 0a                	jne    801040ef <pipeclose+0x4f>
801040e5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801040eb:	85 c0                	test   %eax,%eax
801040ed:	74 31                	je     80104120 <pipeclose+0x80>
        release(&p->lock);
        kfree((char*)p);
    }
    else
        release(&p->lock);
801040ef:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801040f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040f5:	5b                   	pop    %ebx
801040f6:	5e                   	pop    %esi
801040f7:	5d                   	pop    %ebp
        release(&p->lock);
801040f8:	e9 53 11 00 00       	jmp    80105250 <release>
801040fd:	8d 76 00             	lea    0x0(%esi),%esi
        wakeup(&p->nwrite);
80104100:	83 ec 0c             	sub    $0xc,%esp
80104103:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
        p->readopen = 0;
80104109:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80104110:	00 00 00 
        wakeup(&p->nwrite);
80104113:	50                   	push   %eax
80104114:	e8 77 0b 00 00       	call   80104c90 <wakeup>
80104119:	83 c4 10             	add    $0x10,%esp
8010411c:	eb bd                	jmp    801040db <pipeclose+0x3b>
8010411e:	66 90                	xchg   %ax,%ax
        release(&p->lock);
80104120:	83 ec 0c             	sub    $0xc,%esp
80104123:	53                   	push   %ebx
80104124:	e8 27 11 00 00       	call   80105250 <release>
        kfree((char*)p);
80104129:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010412c:	83 c4 10             	add    $0x10,%esp
}
8010412f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104132:	5b                   	pop    %ebx
80104133:	5e                   	pop    %esi
80104134:	5d                   	pop    %ebp
        kfree((char*)p);
80104135:	e9 d6 ee ff ff       	jmp    80103010 <kfree>
8010413a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104140 <pipewrite>:

// PAGEBREAK: 40
int pipewrite(struct pipe* p, char* addr, int n) {
80104140:	f3 0f 1e fb          	endbr32 
80104144:	55                   	push   %ebp
80104145:	89 e5                	mov    %esp,%ebp
80104147:	57                   	push   %edi
80104148:	56                   	push   %esi
80104149:	53                   	push   %ebx
8010414a:	83 ec 28             	sub    $0x28,%esp
8010414d:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int i;

    acquire(&p->lock);
80104150:	53                   	push   %ebx
80104151:	e8 3a 10 00 00       	call   80105190 <acquire>
    for (i = 0; i < n; i++) {
80104156:	8b 45 10             	mov    0x10(%ebp),%eax
80104159:	83 c4 10             	add    $0x10,%esp
8010415c:	85 c0                	test   %eax,%eax
8010415e:	0f 8e bc 00 00 00    	jle    80104220 <pipewrite+0xe0>
80104164:	8b 45 0c             	mov    0xc(%ebp),%eax
80104167:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
        while (p->nwrite == p->nread + PIPESIZE) { // DOC: pipewrite-full
            if (p->readopen == 0 || myproc()->killed) {
                release(&p->lock);
                return -1;
            }
            wakeup(&p->nread);
8010416d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80104173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104176:	03 45 10             	add    0x10(%ebp),%eax
80104179:	89 45 e0             	mov    %eax,-0x20(%ebp)
        while (p->nwrite == p->nread + PIPESIZE) { // DOC: pipewrite-full
8010417c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
            sleep(&p->nwrite, &p->lock); // DOC: pipewrite-sleep
80104182:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
        while (p->nwrite == p->nread + PIPESIZE) { // DOC: pipewrite-full
80104188:	89 ca                	mov    %ecx,%edx
8010418a:	05 00 02 00 00       	add    $0x200,%eax
8010418f:	39 c1                	cmp    %eax,%ecx
80104191:	74 3b                	je     801041ce <pipewrite+0x8e>
80104193:	eb 63                	jmp    801041f8 <pipewrite+0xb8>
80104195:	8d 76 00             	lea    0x0(%esi),%esi
            if (p->readopen == 0 || myproc()->killed) {
80104198:	e8 63 03 00 00       	call   80104500 <myproc>
8010419d:	8b 48 24             	mov    0x24(%eax),%ecx
801041a0:	85 c9                	test   %ecx,%ecx
801041a2:	75 34                	jne    801041d8 <pipewrite+0x98>
            wakeup(&p->nread);
801041a4:	83 ec 0c             	sub    $0xc,%esp
801041a7:	57                   	push   %edi
801041a8:	e8 e3 0a 00 00       	call   80104c90 <wakeup>
            sleep(&p->nwrite, &p->lock); // DOC: pipewrite-sleep
801041ad:	58                   	pop    %eax
801041ae:	5a                   	pop    %edx
801041af:	53                   	push   %ebx
801041b0:	56                   	push   %esi
801041b1:	e8 1a 09 00 00       	call   80104ad0 <sleep>
        while (p->nwrite == p->nread + PIPESIZE) { // DOC: pipewrite-full
801041b6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801041bc:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801041c2:	83 c4 10             	add    $0x10,%esp
801041c5:	05 00 02 00 00       	add    $0x200,%eax
801041ca:	39 c2                	cmp    %eax,%edx
801041cc:	75 2a                	jne    801041f8 <pipewrite+0xb8>
            if (p->readopen == 0 || myproc()->killed) {
801041ce:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801041d4:	85 c0                	test   %eax,%eax
801041d6:	75 c0                	jne    80104198 <pipewrite+0x58>
                release(&p->lock);
801041d8:	83 ec 0c             	sub    $0xc,%esp
801041db:	53                   	push   %ebx
801041dc:	e8 6f 10 00 00       	call   80105250 <release>
                return -1;
801041e1:	83 c4 10             	add    $0x10,%esp
801041e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        p->data[p->nwrite++ % PIPESIZE] = addr[i];
    }
    wakeup(&p->nread); // DOC: pipewrite-wakeup1
    release(&p->lock);
    return n;
}
801041e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041ec:	5b                   	pop    %ebx
801041ed:	5e                   	pop    %esi
801041ee:	5f                   	pop    %edi
801041ef:	5d                   	pop    %ebp
801041f0:	c3                   	ret    
801041f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        p->data[p->nwrite++ % PIPESIZE] = addr[i];
801041f8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801041fb:	8d 4a 01             	lea    0x1(%edx),%ecx
801041fe:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80104204:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010420a:	0f b6 06             	movzbl (%esi),%eax
8010420d:	83 c6 01             	add    $0x1,%esi
80104210:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80104213:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
    for (i = 0; i < n; i++) {
80104217:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010421a:	0f 85 5c ff ff ff    	jne    8010417c <pipewrite+0x3c>
    wakeup(&p->nread); // DOC: pipewrite-wakeup1
80104220:	83 ec 0c             	sub    $0xc,%esp
80104223:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80104229:	50                   	push   %eax
8010422a:	e8 61 0a 00 00       	call   80104c90 <wakeup>
    release(&p->lock);
8010422f:	89 1c 24             	mov    %ebx,(%esp)
80104232:	e8 19 10 00 00       	call   80105250 <release>
    return n;
80104237:	8b 45 10             	mov    0x10(%ebp),%eax
8010423a:	83 c4 10             	add    $0x10,%esp
8010423d:	eb aa                	jmp    801041e9 <pipewrite+0xa9>
8010423f:	90                   	nop

80104240 <piperead>:

int piperead(struct pipe* p, char* addr, int n) {
80104240:	f3 0f 1e fb          	endbr32 
80104244:	55                   	push   %ebp
80104245:	89 e5                	mov    %esp,%ebp
80104247:	57                   	push   %edi
80104248:	56                   	push   %esi
80104249:	53                   	push   %ebx
8010424a:	83 ec 18             	sub    $0x18,%esp
8010424d:	8b 75 08             	mov    0x8(%ebp),%esi
80104250:	8b 7d 0c             	mov    0xc(%ebp),%edi
    int i;

    acquire(&p->lock);
80104253:	56                   	push   %esi
80104254:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010425a:	e8 31 0f 00 00       	call   80105190 <acquire>
    while (p->nread == p->nwrite && p->writeopen) { // DOC: pipe-empty
8010425f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104265:	83 c4 10             	add    $0x10,%esp
80104268:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010426e:	74 33                	je     801042a3 <piperead+0x63>
80104270:	eb 3b                	jmp    801042ad <piperead+0x6d>
80104272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (myproc()->killed) {
80104278:	e8 83 02 00 00       	call   80104500 <myproc>
8010427d:	8b 48 24             	mov    0x24(%eax),%ecx
80104280:	85 c9                	test   %ecx,%ecx
80104282:	0f 85 88 00 00 00    	jne    80104310 <piperead+0xd0>
            release(&p->lock);
            return -1;
        }
        sleep(&p->nread, &p->lock); // DOC: piperead-sleep
80104288:	83 ec 08             	sub    $0x8,%esp
8010428b:	56                   	push   %esi
8010428c:	53                   	push   %ebx
8010428d:	e8 3e 08 00 00       	call   80104ad0 <sleep>
    while (p->nread == p->nwrite && p->writeopen) { // DOC: pipe-empty
80104292:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80104298:	83 c4 10             	add    $0x10,%esp
8010429b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
801042a1:	75 0a                	jne    801042ad <piperead+0x6d>
801042a3:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801042a9:	85 c0                	test   %eax,%eax
801042ab:	75 cb                	jne    80104278 <piperead+0x38>
    }
    for (i = 0; i < n; i++) { // DOC: piperead-copy
801042ad:	8b 55 10             	mov    0x10(%ebp),%edx
801042b0:	31 db                	xor    %ebx,%ebx
801042b2:	85 d2                	test   %edx,%edx
801042b4:	7f 28                	jg     801042de <piperead+0x9e>
801042b6:	eb 34                	jmp    801042ec <piperead+0xac>
801042b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042bf:	90                   	nop
        if (p->nread == p->nwrite)
            break;
        addr[i] = p->data[p->nread++ % PIPESIZE];
801042c0:	8d 48 01             	lea    0x1(%eax),%ecx
801042c3:	25 ff 01 00 00       	and    $0x1ff,%eax
801042c8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801042ce:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801042d3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    for (i = 0; i < n; i++) { // DOC: piperead-copy
801042d6:	83 c3 01             	add    $0x1,%ebx
801042d9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801042dc:	74 0e                	je     801042ec <piperead+0xac>
        if (p->nread == p->nwrite)
801042de:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801042e4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801042ea:	75 d4                	jne    801042c0 <piperead+0x80>
    }
    wakeup(&p->nwrite); // DOC: piperead-wakeup
801042ec:	83 ec 0c             	sub    $0xc,%esp
801042ef:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801042f5:	50                   	push   %eax
801042f6:	e8 95 09 00 00       	call   80104c90 <wakeup>
    release(&p->lock);
801042fb:	89 34 24             	mov    %esi,(%esp)
801042fe:	e8 4d 0f 00 00       	call   80105250 <release>
    return i;
80104303:	83 c4 10             	add    $0x10,%esp
}
80104306:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104309:	89 d8                	mov    %ebx,%eax
8010430b:	5b                   	pop    %ebx
8010430c:	5e                   	pop    %esi
8010430d:	5f                   	pop    %edi
8010430e:	5d                   	pop    %ebp
8010430f:	c3                   	ret    
            release(&p->lock);
80104310:	83 ec 0c             	sub    $0xc,%esp
            return -1;
80104313:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
            release(&p->lock);
80104318:	56                   	push   %esi
80104319:	e8 32 0f 00 00       	call   80105250 <release>
            return -1;
8010431e:	83 c4 10             	add    $0x10,%esp
}
80104321:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104324:	89 d8                	mov    %ebx,%eax
80104326:	5b                   	pop    %ebx
80104327:	5e                   	pop    %esi
80104328:	5f                   	pop    %edi
80104329:	5d                   	pop    %ebp
8010432a:	c3                   	ret    
8010432b:	66 90                	xchg   %ax,%ax
8010432d:	66 90                	xchg   %ax,%ax
8010432f:	90                   	nop

80104330 <allocproc>:
//  Look in the process table for an UNUSED proc.
//  If found, change state to EMBRYO and initialize
//  state required to run in the kernel.
//  Otherwise return 0.
static struct proc*
allocproc(void) {
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	53                   	push   %ebx
    struct proc* p;
    char* sp;

    acquire(&ptable.lock);

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104334:	bb f4 42 11 80       	mov    $0x801142f4,%ebx
allocproc(void) {
80104339:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);
8010433c:	68 c0 42 11 80       	push   $0x801142c0
80104341:	e8 4a 0e 00 00       	call   80105190 <acquire>
80104346:	83 c4 10             	add    $0x10,%esp
80104349:	eb 10                	jmp    8010435b <allocproc+0x2b>
8010434b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010434f:	90                   	nop
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104350:	83 eb 80             	sub    $0xffffff80,%ebx
80104353:	81 fb f4 62 11 80    	cmp    $0x801162f4,%ebx
80104359:	74 75                	je     801043d0 <allocproc+0xa0>
        if (p->state == UNUSED)
8010435b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010435e:	85 c0                	test   %eax,%eax
80104360:	75 ee                	jne    80104350 <allocproc+0x20>
    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
    p->pid = nextpid++;
80104362:	a1 04 b0 10 80       	mov    0x8010b004,%eax

    release(&ptable.lock);
80104367:	83 ec 0c             	sub    $0xc,%esp
    p->state = EMBRYO;
8010436a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->pid = nextpid++;
80104371:	89 43 10             	mov    %eax,0x10(%ebx)
80104374:	8d 50 01             	lea    0x1(%eax),%edx
    release(&ptable.lock);
80104377:	68 c0 42 11 80       	push   $0x801142c0
    p->pid = nextpid++;
8010437c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
    release(&ptable.lock);
80104382:	e8 c9 0e 00 00       	call   80105250 <release>

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
80104387:	e8 44 ee ff ff       	call   801031d0 <kalloc>
8010438c:	83 c4 10             	add    $0x10,%esp
8010438f:	89 43 08             	mov    %eax,0x8(%ebx)
80104392:	85 c0                	test   %eax,%eax
80104394:	74 53                	je     801043e9 <allocproc+0xb9>
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
80104396:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    sp -= 4;
    *(uint*)sp = (uint)trapret;

    sp -= sizeof *p->context;
    p->context = (struct context*)sp;
    memset(p->context, 0, sizeof *p->context);
8010439c:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *p->context;
8010439f:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *p->tf;
801043a4:	89 53 18             	mov    %edx,0x18(%ebx)
    *(uint*)sp = (uint)trapret;
801043a7:	c7 40 14 91 65 10 80 	movl   $0x80106591,0x14(%eax)
    p->context = (struct context*)sp;
801043ae:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
801043b1:	6a 14                	push   $0x14
801043b3:	6a 00                	push   $0x0
801043b5:	50                   	push   %eax
801043b6:	e8 e5 0e 00 00       	call   801052a0 <memset>
    p->context->eip = (uint)forkret;
801043bb:	8b 43 1c             	mov    0x1c(%ebx),%eax

    return p;
801043be:	83 c4 10             	add    $0x10,%esp
    p->context->eip = (uint)forkret;
801043c1:	c7 40 10 00 44 10 80 	movl   $0x80104400,0x10(%eax)
}
801043c8:	89 d8                	mov    %ebx,%eax
801043ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043cd:	c9                   	leave  
801043ce:	c3                   	ret    
801043cf:	90                   	nop
    release(&ptable.lock);
801043d0:	83 ec 0c             	sub    $0xc,%esp
    return 0;
801043d3:	31 db                	xor    %ebx,%ebx
    release(&ptable.lock);
801043d5:	68 c0 42 11 80       	push   $0x801142c0
801043da:	e8 71 0e 00 00       	call   80105250 <release>
}
801043df:	89 d8                	mov    %ebx,%eax
    return 0;
801043e1:	83 c4 10             	add    $0x10,%esp
}
801043e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043e7:	c9                   	leave  
801043e8:	c3                   	ret    
        p->state = UNUSED;
801043e9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return 0;
801043f0:	31 db                	xor    %ebx,%ebx
}
801043f2:	89 d8                	mov    %ebx,%eax
801043f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043f7:	c9                   	leave  
801043f8:	c3                   	ret    
801043f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104400 <forkret>:
    release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void) {
80104400:	f3 0f 1e fb          	endbr32 
80104404:	55                   	push   %ebp
80104405:	89 e5                	mov    %esp,%ebp
80104407:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
8010440a:	68 c0 42 11 80       	push   $0x801142c0
8010440f:	e8 3c 0e 00 00       	call   80105250 <release>

    if (first) {
80104414:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104419:	83 c4 10             	add    $0x10,%esp
8010441c:	85 c0                	test   %eax,%eax
8010441e:	75 08                	jne    80104428 <forkret+0x28>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
80104420:	c9                   	leave  
80104421:	c3                   	ret    
80104422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        first = 0;
80104428:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010442f:	00 00 00 
        iinit(ROOTDEV);
80104432:	83 ec 0c             	sub    $0xc,%esp
80104435:	6a 01                	push   $0x1
80104437:	e8 a4 dc ff ff       	call   801020e0 <iinit>
        initlog(ROOTDEV);
8010443c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104443:	e8 e8 f3 ff ff       	call   80103830 <initlog>
}
80104448:	83 c4 10             	add    $0x10,%esp
8010444b:	c9                   	leave  
8010444c:	c3                   	ret    
8010444d:	8d 76 00             	lea    0x0(%esi),%esi

80104450 <pinit>:
void pinit(void) {
80104450:	f3 0f 1e fb          	endbr32 
80104454:	55                   	push   %ebp
80104455:	89 e5                	mov    %esp,%ebp
80104457:	83 ec 10             	sub    $0x10,%esp
    initlock(&ptable.lock, "ptable");
8010445a:	68 80 83 10 80       	push   $0x80108380
8010445f:	68 c0 42 11 80       	push   $0x801142c0
80104464:	e8 a7 0b 00 00       	call   80105010 <initlock>
}
80104469:	83 c4 10             	add    $0x10,%esp
8010446c:	c9                   	leave  
8010446d:	c3                   	ret    
8010446e:	66 90                	xchg   %ax,%ax

80104470 <mycpu>:
mycpu(void) {
80104470:	f3 0f 1e fb          	endbr32 
80104474:	55                   	push   %ebp
80104475:	89 e5                	mov    %esp,%ebp
80104477:	56                   	push   %esi
80104478:	53                   	push   %ebx
    asm volatile("pushfl; popl %0"
80104479:	9c                   	pushf  
8010447a:	58                   	pop    %eax
    if (readeflags() & FL_IF)
8010447b:	f6 c4 02             	test   $0x2,%ah
8010447e:	75 4a                	jne    801044ca <mycpu+0x5a>
    apicid = lapicid();
80104480:	e8 bb ef ff ff       	call   80103440 <lapicid>
    for (i = 0; i < ncpu; ++i) {
80104485:	8b 35 a0 42 11 80    	mov    0x801142a0,%esi
    apicid = lapicid();
8010448b:	89 c3                	mov    %eax,%ebx
    for (i = 0; i < ncpu; ++i) {
8010448d:	85 f6                	test   %esi,%esi
8010448f:	7e 2c                	jle    801044bd <mycpu+0x4d>
80104491:	31 d2                	xor    %edx,%edx
80104493:	eb 0a                	jmp    8010449f <mycpu+0x2f>
80104495:	8d 76 00             	lea    0x0(%esi),%esi
80104498:	83 c2 01             	add    $0x1,%edx
8010449b:	39 f2                	cmp    %esi,%edx
8010449d:	74 1e                	je     801044bd <mycpu+0x4d>
        if (cpus[i].apicid == apicid)
8010449f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801044a5:	0f b6 81 20 3d 11 80 	movzbl -0x7feec2e0(%ecx),%eax
801044ac:	39 d8                	cmp    %ebx,%eax
801044ae:	75 e8                	jne    80104498 <mycpu+0x28>
}
801044b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
            return &cpus[i];
801044b3:	8d 81 20 3d 11 80    	lea    -0x7feec2e0(%ecx),%eax
}
801044b9:	5b                   	pop    %ebx
801044ba:	5e                   	pop    %esi
801044bb:	5d                   	pop    %ebp
801044bc:	c3                   	ret    
    panic("unknown apicid\n");
801044bd:	83 ec 0c             	sub    $0xc,%esp
801044c0:	68 87 83 10 80       	push   $0x80108387
801044c5:	e8 c6 be ff ff       	call   80100390 <panic>
        panic("mycpu called with interrupts enabled\n");
801044ca:	83 ec 0c             	sub    $0xc,%esp
801044cd:	68 64 84 10 80       	push   $0x80108464
801044d2:	e8 b9 be ff ff       	call   80100390 <panic>
801044d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044de:	66 90                	xchg   %ax,%ax

801044e0 <cpuid>:
int cpuid() {
801044e0:	f3 0f 1e fb          	endbr32 
801044e4:	55                   	push   %ebp
801044e5:	89 e5                	mov    %esp,%ebp
801044e7:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
801044ea:	e8 81 ff ff ff       	call   80104470 <mycpu>
}
801044ef:	c9                   	leave  
    return mycpu() - cpus;
801044f0:	2d 20 3d 11 80       	sub    $0x80113d20,%eax
801044f5:	c1 f8 04             	sar    $0x4,%eax
801044f8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801044fe:	c3                   	ret    
801044ff:	90                   	nop

80104500 <myproc>:
myproc(void) {
80104500:	f3 0f 1e fb          	endbr32 
80104504:	55                   	push   %ebp
80104505:	89 e5                	mov    %esp,%ebp
80104507:	53                   	push   %ebx
80104508:	83 ec 04             	sub    $0x4,%esp
    pushcli();
8010450b:	e8 80 0b 00 00       	call   80105090 <pushcli>
    c = mycpu();
80104510:	e8 5b ff ff ff       	call   80104470 <mycpu>
    p = c->proc;
80104515:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
8010451b:	e8 c0 0b 00 00       	call   801050e0 <popcli>
}
80104520:	83 c4 04             	add    $0x4,%esp
80104523:	89 d8                	mov    %ebx,%eax
80104525:	5b                   	pop    %ebx
80104526:	5d                   	pop    %ebp
80104527:	c3                   	ret    
80104528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010452f:	90                   	nop

80104530 <userinit>:
void userinit(void) {
80104530:	f3 0f 1e fb          	endbr32 
80104534:	55                   	push   %ebp
80104535:	89 e5                	mov    %esp,%ebp
80104537:	53                   	push   %ebx
80104538:	83 ec 04             	sub    $0x4,%esp
    p = allocproc();
8010453b:	e8 f0 fd ff ff       	call   80104330 <allocproc>
80104540:	89 c3                	mov    %eax,%ebx
    initproc = p;
80104542:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
    if ((p->pgdir = setupkvm()) == 0)
80104547:	e8 04 36 00 00       	call   80107b50 <setupkvm>
8010454c:	89 43 04             	mov    %eax,0x4(%ebx)
8010454f:	85 c0                	test   %eax,%eax
80104551:	0f 84 bd 00 00 00    	je     80104614 <userinit+0xe4>
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104557:	83 ec 04             	sub    $0x4,%esp
8010455a:	68 2c 00 00 00       	push   $0x2c
8010455f:	68 60 b4 10 80       	push   $0x8010b460
80104564:	50                   	push   %eax
80104565:	e8 b6 32 00 00       	call   80107820 <inituvm>
    memset(p->tf, 0, sizeof(*p->tf));
8010456a:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
8010456d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
80104573:	6a 4c                	push   $0x4c
80104575:	6a 00                	push   $0x0
80104577:	ff 73 18             	pushl  0x18(%ebx)
8010457a:	e8 21 0d 00 00       	call   801052a0 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010457f:	8b 43 18             	mov    0x18(%ebx),%eax
80104582:	ba 1b 00 00 00       	mov    $0x1b,%edx
    safestrcpy(p->name, "initcode", sizeof(p->name));
80104587:	83 c4 0c             	add    $0xc,%esp
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010458a:	b9 23 00 00 00       	mov    $0x23,%ecx
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010458f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104593:	8b 43 18             	mov    0x18(%ebx),%eax
80104596:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->tf->es = p->tf->ds;
8010459a:	8b 43 18             	mov    0x18(%ebx),%eax
8010459d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801045a1:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
801045a5:	8b 43 18             	mov    0x18(%ebx),%eax
801045a8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801045ac:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
801045b0:	8b 43 18             	mov    0x18(%ebx),%eax
801045b3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
801045ba:	8b 43 18             	mov    0x18(%ebx),%eax
801045bd:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0; // beginning of initcode.S
801045c4:	8b 43 18             	mov    0x18(%ebx),%eax
801045c7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
801045ce:	8d 43 6c             	lea    0x6c(%ebx),%eax
801045d1:	6a 10                	push   $0x10
801045d3:	68 b0 83 10 80       	push   $0x801083b0
801045d8:	50                   	push   %eax
801045d9:	e8 82 0e 00 00       	call   80105460 <safestrcpy>
    p->cwd = namei("/");
801045de:	c7 04 24 b9 83 10 80 	movl   $0x801083b9,(%esp)
801045e5:	e8 e6 e5 ff ff       	call   80102bd0 <namei>
801045ea:	89 43 68             	mov    %eax,0x68(%ebx)
    acquire(&ptable.lock);
801045ed:	c7 04 24 c0 42 11 80 	movl   $0x801142c0,(%esp)
801045f4:	e8 97 0b 00 00       	call   80105190 <acquire>
    p->state = RUNNABLE;
801045f9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    release(&ptable.lock);
80104600:	c7 04 24 c0 42 11 80 	movl   $0x801142c0,(%esp)
80104607:	e8 44 0c 00 00       	call   80105250 <release>
}
8010460c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010460f:	83 c4 10             	add    $0x10,%esp
80104612:	c9                   	leave  
80104613:	c3                   	ret    
        panic("userinit: out of memory?");
80104614:	83 ec 0c             	sub    $0xc,%esp
80104617:	68 97 83 10 80       	push   $0x80108397
8010461c:	e8 6f bd ff ff       	call   80100390 <panic>
80104621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010462f:	90                   	nop

80104630 <growproc>:
int growproc(int n) {
80104630:	f3 0f 1e fb          	endbr32 
80104634:	55                   	push   %ebp
80104635:	89 e5                	mov    %esp,%ebp
80104637:	56                   	push   %esi
80104638:	53                   	push   %ebx
80104639:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
8010463c:	e8 4f 0a 00 00       	call   80105090 <pushcli>
    c = mycpu();
80104641:	e8 2a fe ff ff       	call   80104470 <mycpu>
    p = c->proc;
80104646:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
8010464c:	e8 8f 0a 00 00       	call   801050e0 <popcli>
    sz = curproc->sz;
80104651:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80104653:	85 f6                	test   %esi,%esi
80104655:	7f 19                	jg     80104670 <growproc+0x40>
    else if (n < 0) {
80104657:	75 37                	jne    80104690 <growproc+0x60>
    switchuvm(curproc);
80104659:	83 ec 0c             	sub    $0xc,%esp
    curproc->sz = sz;
8010465c:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
8010465e:	53                   	push   %ebx
8010465f:	e8 ac 30 00 00       	call   80107710 <switchuvm>
    return 0;
80104664:	83 c4 10             	add    $0x10,%esp
80104667:	31 c0                	xor    %eax,%eax
}
80104669:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010466c:	5b                   	pop    %ebx
8010466d:	5e                   	pop    %esi
8010466e:	5d                   	pop    %ebp
8010466f:	c3                   	ret    
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104670:	83 ec 04             	sub    $0x4,%esp
80104673:	01 c6                	add    %eax,%esi
80104675:	56                   	push   %esi
80104676:	50                   	push   %eax
80104677:	ff 73 04             	pushl  0x4(%ebx)
8010467a:	e8 f1 32 00 00       	call   80107970 <allocuvm>
8010467f:	83 c4 10             	add    $0x10,%esp
80104682:	85 c0                	test   %eax,%eax
80104684:	75 d3                	jne    80104659 <growproc+0x29>
            return -1;
80104686:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010468b:	eb dc                	jmp    80104669 <growproc+0x39>
8010468d:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104690:	83 ec 04             	sub    $0x4,%esp
80104693:	01 c6                	add    %eax,%esi
80104695:	56                   	push   %esi
80104696:	50                   	push   %eax
80104697:	ff 73 04             	pushl  0x4(%ebx)
8010469a:	e8 01 34 00 00       	call   80107aa0 <deallocuvm>
8010469f:	83 c4 10             	add    $0x10,%esp
801046a2:	85 c0                	test   %eax,%eax
801046a4:	75 b3                	jne    80104659 <growproc+0x29>
801046a6:	eb de                	jmp    80104686 <growproc+0x56>
801046a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046af:	90                   	nop

801046b0 <fork>:
int fork(void) {
801046b0:	f3 0f 1e fb          	endbr32 
801046b4:	55                   	push   %ebp
801046b5:	89 e5                	mov    %esp,%ebp
801046b7:	57                   	push   %edi
801046b8:	56                   	push   %esi
801046b9:	53                   	push   %ebx
801046ba:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
801046bd:	e8 ce 09 00 00       	call   80105090 <pushcli>
    c = mycpu();
801046c2:	e8 a9 fd ff ff       	call   80104470 <mycpu>
    p = c->proc;
801046c7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801046cd:	e8 0e 0a 00 00       	call   801050e0 <popcli>
    if ((np = allocproc()) == 0) {
801046d2:	e8 59 fc ff ff       	call   80104330 <allocproc>
801046d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801046da:	85 c0                	test   %eax,%eax
801046dc:	0f 84 c3 00 00 00    	je     801047a5 <fork+0xf5>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
801046e2:	83 ec 08             	sub    $0x8,%esp
801046e5:	ff 33                	pushl  (%ebx)
801046e7:	89 c7                	mov    %eax,%edi
801046e9:	ff 73 04             	pushl  0x4(%ebx)
801046ec:	e8 2f 35 00 00       	call   80107c20 <copyuvm>
801046f1:	83 c4 10             	add    $0x10,%esp
801046f4:	89 47 04             	mov    %eax,0x4(%edi)
801046f7:	85 c0                	test   %eax,%eax
801046f9:	0f 84 ad 00 00 00    	je     801047ac <fork+0xfc>
    np->sz = curproc->sz;
801046ff:	8b 03                	mov    (%ebx),%eax
80104701:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104704:	89 01                	mov    %eax,(%ecx)
    *np->tf = *curproc->tf;
80104706:	8b 79 18             	mov    0x18(%ecx),%edi
    np->parent = curproc;
80104709:	89 c8                	mov    %ecx,%eax
8010470b:	89 59 14             	mov    %ebx,0x14(%ecx)
    *np->tf = *curproc->tf;
8010470e:	b9 13 00 00 00       	mov    $0x13,%ecx
80104713:	8b 73 18             	mov    0x18(%ebx),%esi
80104716:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (i = 0; i < NOFILE; i++)
80104718:	31 f6                	xor    %esi,%esi
    np->tf->eax = 0;
8010471a:	8b 40 18             	mov    0x18(%eax),%eax
8010471d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    for (i = 0; i < NOFILE; i++)
80104724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (curproc->ofile[i])
80104728:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010472c:	85 c0                	test   %eax,%eax
8010472e:	74 13                	je     80104743 <fork+0x93>
            np->ofile[i] = filedup(curproc->ofile[i]);
80104730:	83 ec 0c             	sub    $0xc,%esp
80104733:	50                   	push   %eax
80104734:	e8 27 d2 ff ff       	call   80101960 <filedup>
80104739:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010473c:	83 c4 10             	add    $0x10,%esp
8010473f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
    for (i = 0; i < NOFILE; i++)
80104743:	83 c6 01             	add    $0x1,%esi
80104746:	83 fe 10             	cmp    $0x10,%esi
80104749:	75 dd                	jne    80104728 <fork+0x78>
    np->cwd = idup(curproc->cwd);
8010474b:	83 ec 0c             	sub    $0xc,%esp
8010474e:	ff 73 68             	pushl  0x68(%ebx)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104751:	83 c3 6c             	add    $0x6c,%ebx
    np->cwd = idup(curproc->cwd);
80104754:	e8 77 db ff ff       	call   801022d0 <idup>
80104759:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010475c:	83 c4 0c             	add    $0xc,%esp
    np->cwd = idup(curproc->cwd);
8010475f:	89 47 68             	mov    %eax,0x68(%edi)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104762:	8d 47 6c             	lea    0x6c(%edi),%eax
80104765:	6a 10                	push   $0x10
80104767:	53                   	push   %ebx
80104768:	50                   	push   %eax
80104769:	e8 f2 0c 00 00       	call   80105460 <safestrcpy>
    pid = np->pid;
8010476e:	8b 5f 10             	mov    0x10(%edi),%ebx
    acquire(&ptable.lock);
80104771:	c7 04 24 c0 42 11 80 	movl   $0x801142c0,(%esp)
80104778:	e8 13 0a 00 00       	call   80105190 <acquire>
    np->state = RUNNABLE;
8010477d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
    release(&ptable.lock);
80104784:	c7 04 24 c0 42 11 80 	movl   $0x801142c0,(%esp)
8010478b:	e8 c0 0a 00 00       	call   80105250 <release>
    np->ctime = ticks;
80104790:	a1 40 6b 11 80       	mov    0x80116b40,%eax
    return pid;
80104795:	83 c4 10             	add    $0x10,%esp
    np->ctime = ticks;
80104798:	89 47 7c             	mov    %eax,0x7c(%edi)
}
8010479b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010479e:	89 d8                	mov    %ebx,%eax
801047a0:	5b                   	pop    %ebx
801047a1:	5e                   	pop    %esi
801047a2:	5f                   	pop    %edi
801047a3:	5d                   	pop    %ebp
801047a4:	c3                   	ret    
        return -1;
801047a5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801047aa:	eb ef                	jmp    8010479b <fork+0xeb>
        kfree(np->kstack);
801047ac:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801047af:	83 ec 0c             	sub    $0xc,%esp
801047b2:	ff 73 08             	pushl  0x8(%ebx)
801047b5:	e8 56 e8 ff ff       	call   80103010 <kfree>
        np->kstack = 0;
801047ba:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        return -1;
801047c1:	83 c4 10             	add    $0x10,%esp
        np->state = UNUSED;
801047c4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return -1;
801047cb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801047d0:	eb c9                	jmp    8010479b <fork+0xeb>
801047d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047e0 <scheduler>:
void scheduler(void) {
801047e0:	f3 0f 1e fb          	endbr32 
801047e4:	55                   	push   %ebp
801047e5:	89 e5                	mov    %esp,%ebp
801047e7:	57                   	push   %edi
801047e8:	56                   	push   %esi
801047e9:	53                   	push   %ebx
801047ea:	83 ec 0c             	sub    $0xc,%esp
    struct cpu* c = mycpu();
801047ed:	e8 7e fc ff ff       	call   80104470 <mycpu>
    c->proc = 0;
801047f2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801047f9:	00 00 00 
    struct cpu* c = mycpu();
801047fc:	89 c6                	mov    %eax,%esi
    c->proc = 0;
801047fe:	8d 78 04             	lea    0x4(%eax),%edi
80104801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    asm volatile("sti");
80104808:	fb                   	sti    
        acquire(&ptable.lock);
80104809:	83 ec 0c             	sub    $0xc,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010480c:	bb f4 42 11 80       	mov    $0x801142f4,%ebx
        acquire(&ptable.lock);
80104811:	68 c0 42 11 80       	push   $0x801142c0
80104816:	e8 75 09 00 00       	call   80105190 <acquire>
8010481b:	83 c4 10             	add    $0x10,%esp
8010481e:	66 90                	xchg   %ax,%ax
            if (p->state != RUNNABLE)
80104820:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104824:	75 33                	jne    80104859 <scheduler+0x79>
            switchuvm(p);
80104826:	83 ec 0c             	sub    $0xc,%esp
            c->proc = p;
80104829:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
            switchuvm(p);
8010482f:	53                   	push   %ebx
80104830:	e8 db 2e 00 00       	call   80107710 <switchuvm>
            swtch(&(c->scheduler), p->context);
80104835:	58                   	pop    %eax
80104836:	5a                   	pop    %edx
80104837:	ff 73 1c             	pushl  0x1c(%ebx)
8010483a:	57                   	push   %edi
            p->state = RUNNING;
8010483b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
            swtch(&(c->scheduler), p->context);
80104842:	e8 7c 0c 00 00       	call   801054c3 <swtch>
            switchkvm();
80104847:	e8 a4 2e 00 00       	call   801076f0 <switchkvm>
            c->proc = 0;
8010484c:	83 c4 10             	add    $0x10,%esp
8010484f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104856:	00 00 00 
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104859:	83 eb 80             	sub    $0xffffff80,%ebx
8010485c:	81 fb f4 62 11 80    	cmp    $0x801162f4,%ebx
80104862:	75 bc                	jne    80104820 <scheduler+0x40>
        release(&ptable.lock);
80104864:	83 ec 0c             	sub    $0xc,%esp
80104867:	68 c0 42 11 80       	push   $0x801142c0
8010486c:	e8 df 09 00 00       	call   80105250 <release>
        sti();
80104871:	83 c4 10             	add    $0x10,%esp
80104874:	eb 92                	jmp    80104808 <scheduler+0x28>
80104876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010487d:	8d 76 00             	lea    0x0(%esi),%esi

80104880 <sched>:
void sched(void) {
80104880:	f3 0f 1e fb          	endbr32 
80104884:	55                   	push   %ebp
80104885:	89 e5                	mov    %esp,%ebp
80104887:	56                   	push   %esi
80104888:	53                   	push   %ebx
    pushcli();
80104889:	e8 02 08 00 00       	call   80105090 <pushcli>
    c = mycpu();
8010488e:	e8 dd fb ff ff       	call   80104470 <mycpu>
    p = c->proc;
80104893:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104899:	e8 42 08 00 00       	call   801050e0 <popcli>
    if (!holding(&ptable.lock))
8010489e:	83 ec 0c             	sub    $0xc,%esp
801048a1:	68 c0 42 11 80       	push   $0x801142c0
801048a6:	e8 95 08 00 00       	call   80105140 <holding>
801048ab:	83 c4 10             	add    $0x10,%esp
801048ae:	85 c0                	test   %eax,%eax
801048b0:	74 4f                	je     80104901 <sched+0x81>
    if (mycpu()->ncli != 1)
801048b2:	e8 b9 fb ff ff       	call   80104470 <mycpu>
801048b7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801048be:	75 68                	jne    80104928 <sched+0xa8>
    if (p->state == RUNNING)
801048c0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801048c4:	74 55                	je     8010491b <sched+0x9b>
    asm volatile("pushfl; popl %0"
801048c6:	9c                   	pushf  
801048c7:	58                   	pop    %eax
    if (readeflags() & FL_IF)
801048c8:	f6 c4 02             	test   $0x2,%ah
801048cb:	75 41                	jne    8010490e <sched+0x8e>
    intena = mycpu()->intena;
801048cd:	e8 9e fb ff ff       	call   80104470 <mycpu>
    swtch(&p->context, mycpu()->scheduler);
801048d2:	83 c3 1c             	add    $0x1c,%ebx
    intena = mycpu()->intena;
801048d5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&p->context, mycpu()->scheduler);
801048db:	e8 90 fb ff ff       	call   80104470 <mycpu>
801048e0:	83 ec 08             	sub    $0x8,%esp
801048e3:	ff 70 04             	pushl  0x4(%eax)
801048e6:	53                   	push   %ebx
801048e7:	e8 d7 0b 00 00       	call   801054c3 <swtch>
    mycpu()->intena = intena;
801048ec:	e8 7f fb ff ff       	call   80104470 <mycpu>
}
801048f1:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
801048f4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801048fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048fd:	5b                   	pop    %ebx
801048fe:	5e                   	pop    %esi
801048ff:	5d                   	pop    %ebp
80104900:	c3                   	ret    
        panic("sched ptable.lock");
80104901:	83 ec 0c             	sub    $0xc,%esp
80104904:	68 bb 83 10 80       	push   $0x801083bb
80104909:	e8 82 ba ff ff       	call   80100390 <panic>
        panic("sched interruptible");
8010490e:	83 ec 0c             	sub    $0xc,%esp
80104911:	68 e7 83 10 80       	push   $0x801083e7
80104916:	e8 75 ba ff ff       	call   80100390 <panic>
        panic("sched running");
8010491b:	83 ec 0c             	sub    $0xc,%esp
8010491e:	68 d9 83 10 80       	push   $0x801083d9
80104923:	e8 68 ba ff ff       	call   80100390 <panic>
        panic("sched locks");
80104928:	83 ec 0c             	sub    $0xc,%esp
8010492b:	68 cd 83 10 80       	push   $0x801083cd
80104930:	e8 5b ba ff ff       	call   80100390 <panic>
80104935:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104940 <exit>:
void exit(void) {
80104940:	f3 0f 1e fb          	endbr32 
80104944:	55                   	push   %ebp
80104945:	89 e5                	mov    %esp,%ebp
80104947:	57                   	push   %edi
80104948:	56                   	push   %esi
80104949:	53                   	push   %ebx
8010494a:	83 ec 0c             	sub    $0xc,%esp
    pushcli();
8010494d:	e8 3e 07 00 00       	call   80105090 <pushcli>
    c = mycpu();
80104952:	e8 19 fb ff ff       	call   80104470 <mycpu>
    p = c->proc;
80104957:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
8010495d:	e8 7e 07 00 00       	call   801050e0 <popcli>
    if (curproc == initproc)
80104962:	8d 5e 28             	lea    0x28(%esi),%ebx
80104965:	8d 7e 68             	lea    0x68(%esi),%edi
80104968:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
8010496e:	0f 84 f3 00 00 00    	je     80104a67 <exit+0x127>
80104974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (curproc->ofile[fd]) {
80104978:	8b 03                	mov    (%ebx),%eax
8010497a:	85 c0                	test   %eax,%eax
8010497c:	74 12                	je     80104990 <exit+0x50>
            fileclose(curproc->ofile[fd]);
8010497e:	83 ec 0c             	sub    $0xc,%esp
80104981:	50                   	push   %eax
80104982:	e8 29 d0 ff ff       	call   801019b0 <fileclose>
            curproc->ofile[fd] = 0;
80104987:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010498d:	83 c4 10             	add    $0x10,%esp
    for (fd = 0; fd < NOFILE; fd++) {
80104990:	83 c3 04             	add    $0x4,%ebx
80104993:	39 df                	cmp    %ebx,%edi
80104995:	75 e1                	jne    80104978 <exit+0x38>
    begin_op();
80104997:	e8 34 ef ff ff       	call   801038d0 <begin_op>
    iput(curproc->cwd);
8010499c:	83 ec 0c             	sub    $0xc,%esp
8010499f:	ff 76 68             	pushl  0x68(%esi)
801049a2:	e8 89 da ff ff       	call   80102430 <iput>
    end_op();
801049a7:	e8 94 ef ff ff       	call   80103940 <end_op>
    curproc->cwd = 0;
801049ac:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
    acquire(&ptable.lock);
801049b3:	c7 04 24 c0 42 11 80 	movl   $0x801142c0,(%esp)
801049ba:	e8 d1 07 00 00       	call   80105190 <acquire>
    wakeup1(curproc->parent);
801049bf:	8b 56 14             	mov    0x14(%esi),%edx
801049c2:	83 c4 10             	add    $0x10,%esp
//  The ptable lock must be held.
static void
wakeup1(void* chan) {
    struct proc* p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049c5:	b8 f4 42 11 80       	mov    $0x801142f4,%eax
801049ca:	eb 0e                	jmp    801049da <exit+0x9a>
801049cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049d0:	83 e8 80             	sub    $0xffffff80,%eax
801049d3:	3d f4 62 11 80       	cmp    $0x801162f4,%eax
801049d8:	74 1c                	je     801049f6 <exit+0xb6>
        if (p->state == SLEEPING && p->chan == chan)
801049da:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801049de:	75 f0                	jne    801049d0 <exit+0x90>
801049e0:	3b 50 20             	cmp    0x20(%eax),%edx
801049e3:	75 eb                	jne    801049d0 <exit+0x90>
            p->state = RUNNABLE;
801049e5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049ec:	83 e8 80             	sub    $0xffffff80,%eax
801049ef:	3d f4 62 11 80       	cmp    $0x801162f4,%eax
801049f4:	75 e4                	jne    801049da <exit+0x9a>
            p->parent = initproc;
801049f6:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801049fc:	ba f4 42 11 80       	mov    $0x801142f4,%edx
80104a01:	eb 10                	jmp    80104a13 <exit+0xd3>
80104a03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a07:	90                   	nop
80104a08:	83 ea 80             	sub    $0xffffff80,%edx
80104a0b:	81 fa f4 62 11 80    	cmp    $0x801162f4,%edx
80104a11:	74 3b                	je     80104a4e <exit+0x10e>
        if (p->parent == curproc) {
80104a13:	39 72 14             	cmp    %esi,0x14(%edx)
80104a16:	75 f0                	jne    80104a08 <exit+0xc8>
            if (p->state == ZOMBIE)
80104a18:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
            p->parent = initproc;
80104a1c:	89 4a 14             	mov    %ecx,0x14(%edx)
            if (p->state == ZOMBIE)
80104a1f:	75 e7                	jne    80104a08 <exit+0xc8>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a21:	b8 f4 42 11 80       	mov    $0x801142f4,%eax
80104a26:	eb 12                	jmp    80104a3a <exit+0xfa>
80104a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a2f:	90                   	nop
80104a30:	83 e8 80             	sub    $0xffffff80,%eax
80104a33:	3d f4 62 11 80       	cmp    $0x801162f4,%eax
80104a38:	74 ce                	je     80104a08 <exit+0xc8>
        if (p->state == SLEEPING && p->chan == chan)
80104a3a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104a3e:	75 f0                	jne    80104a30 <exit+0xf0>
80104a40:	3b 48 20             	cmp    0x20(%eax),%ecx
80104a43:	75 eb                	jne    80104a30 <exit+0xf0>
            p->state = RUNNABLE;
80104a45:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104a4c:	eb e2                	jmp    80104a30 <exit+0xf0>
    curproc->state = ZOMBIE;
80104a4e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
    sched();
80104a55:	e8 26 fe ff ff       	call   80104880 <sched>
    panic("zombie exit");
80104a5a:	83 ec 0c             	sub    $0xc,%esp
80104a5d:	68 08 84 10 80       	push   $0x80108408
80104a62:	e8 29 b9 ff ff       	call   80100390 <panic>
        panic("init exiting");
80104a67:	83 ec 0c             	sub    $0xc,%esp
80104a6a:	68 fb 83 10 80       	push   $0x801083fb
80104a6f:	e8 1c b9 ff ff       	call   80100390 <panic>
80104a74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a7f:	90                   	nop

80104a80 <yield>:
void yield(void) {
80104a80:	f3 0f 1e fb          	endbr32 
80104a84:	55                   	push   %ebp
80104a85:	89 e5                	mov    %esp,%ebp
80104a87:	53                   	push   %ebx
80104a88:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock); // DOC: yieldlock
80104a8b:	68 c0 42 11 80       	push   $0x801142c0
80104a90:	e8 fb 06 00 00       	call   80105190 <acquire>
    pushcli();
80104a95:	e8 f6 05 00 00       	call   80105090 <pushcli>
    c = mycpu();
80104a9a:	e8 d1 f9 ff ff       	call   80104470 <mycpu>
    p = c->proc;
80104a9f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104aa5:	e8 36 06 00 00       	call   801050e0 <popcli>
    myproc()->state = RUNNABLE;
80104aaa:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    sched();
80104ab1:	e8 ca fd ff ff       	call   80104880 <sched>
    release(&ptable.lock);
80104ab6:	c7 04 24 c0 42 11 80 	movl   $0x801142c0,(%esp)
80104abd:	e8 8e 07 00 00       	call   80105250 <release>
}
80104ac2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ac5:	83 c4 10             	add    $0x10,%esp
80104ac8:	c9                   	leave  
80104ac9:	c3                   	ret    
80104aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ad0 <sleep>:
void sleep(void* chan, struct spinlock* lk) {
80104ad0:	f3 0f 1e fb          	endbr32 
80104ad4:	55                   	push   %ebp
80104ad5:	89 e5                	mov    %esp,%ebp
80104ad7:	57                   	push   %edi
80104ad8:	56                   	push   %esi
80104ad9:	53                   	push   %ebx
80104ada:	83 ec 0c             	sub    $0xc,%esp
80104add:	8b 7d 08             	mov    0x8(%ebp),%edi
80104ae0:	8b 75 0c             	mov    0xc(%ebp),%esi
    pushcli();
80104ae3:	e8 a8 05 00 00       	call   80105090 <pushcli>
    c = mycpu();
80104ae8:	e8 83 f9 ff ff       	call   80104470 <mycpu>
    p = c->proc;
80104aed:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104af3:	e8 e8 05 00 00       	call   801050e0 <popcli>
    if (p == 0)
80104af8:	85 db                	test   %ebx,%ebx
80104afa:	0f 84 83 00 00 00    	je     80104b83 <sleep+0xb3>
    if (lk == 0)
80104b00:	85 f6                	test   %esi,%esi
80104b02:	74 72                	je     80104b76 <sleep+0xa6>
    if (lk != &ptable.lock) {  // DOC: sleeplock0
80104b04:	81 fe c0 42 11 80    	cmp    $0x801142c0,%esi
80104b0a:	74 4c                	je     80104b58 <sleep+0x88>
        acquire(&ptable.lock); // DOC: sleeplock1
80104b0c:	83 ec 0c             	sub    $0xc,%esp
80104b0f:	68 c0 42 11 80       	push   $0x801142c0
80104b14:	e8 77 06 00 00       	call   80105190 <acquire>
        release(lk);
80104b19:	89 34 24             	mov    %esi,(%esp)
80104b1c:	e8 2f 07 00 00       	call   80105250 <release>
    p->chan = chan;
80104b21:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
80104b24:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104b2b:	e8 50 fd ff ff       	call   80104880 <sched>
    p->chan = 0;
80104b30:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
        release(&ptable.lock);
80104b37:	c7 04 24 c0 42 11 80 	movl   $0x801142c0,(%esp)
80104b3e:	e8 0d 07 00 00       	call   80105250 <release>
        acquire(lk);
80104b43:	89 75 08             	mov    %esi,0x8(%ebp)
80104b46:	83 c4 10             	add    $0x10,%esp
}
80104b49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b4c:	5b                   	pop    %ebx
80104b4d:	5e                   	pop    %esi
80104b4e:	5f                   	pop    %edi
80104b4f:	5d                   	pop    %ebp
        acquire(lk);
80104b50:	e9 3b 06 00 00       	jmp    80105190 <acquire>
80104b55:	8d 76 00             	lea    0x0(%esi),%esi
    p->chan = chan;
80104b58:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
80104b5b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104b62:	e8 19 fd ff ff       	call   80104880 <sched>
    p->chan = 0;
80104b67:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104b6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b71:	5b                   	pop    %ebx
80104b72:	5e                   	pop    %esi
80104b73:	5f                   	pop    %edi
80104b74:	5d                   	pop    %ebp
80104b75:	c3                   	ret    
        panic("sleep without lk");
80104b76:	83 ec 0c             	sub    $0xc,%esp
80104b79:	68 1a 84 10 80       	push   $0x8010841a
80104b7e:	e8 0d b8 ff ff       	call   80100390 <panic>
        panic("sleep");
80104b83:	83 ec 0c             	sub    $0xc,%esp
80104b86:	68 14 84 10 80       	push   $0x80108414
80104b8b:	e8 00 b8 ff ff       	call   80100390 <panic>

80104b90 <wait>:
int wait(void) {
80104b90:	f3 0f 1e fb          	endbr32 
80104b94:	55                   	push   %ebp
80104b95:	89 e5                	mov    %esp,%ebp
80104b97:	56                   	push   %esi
80104b98:	53                   	push   %ebx
    pushcli();
80104b99:	e8 f2 04 00 00       	call   80105090 <pushcli>
    c = mycpu();
80104b9e:	e8 cd f8 ff ff       	call   80104470 <mycpu>
    p = c->proc;
80104ba3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104ba9:	e8 32 05 00 00       	call   801050e0 <popcli>
    acquire(&ptable.lock);
80104bae:	83 ec 0c             	sub    $0xc,%esp
80104bb1:	68 c0 42 11 80       	push   $0x801142c0
80104bb6:	e8 d5 05 00 00       	call   80105190 <acquire>
80104bbb:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
80104bbe:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104bc0:	bb f4 42 11 80       	mov    $0x801142f4,%ebx
80104bc5:	eb 14                	jmp    80104bdb <wait+0x4b>
80104bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bce:	66 90                	xchg   %ax,%ax
80104bd0:	83 eb 80             	sub    $0xffffff80,%ebx
80104bd3:	81 fb f4 62 11 80    	cmp    $0x801162f4,%ebx
80104bd9:	74 1b                	je     80104bf6 <wait+0x66>
            if (p->parent != curproc)
80104bdb:	39 73 14             	cmp    %esi,0x14(%ebx)
80104bde:	75 f0                	jne    80104bd0 <wait+0x40>
            if (p->state == ZOMBIE) {
80104be0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104be4:	74 32                	je     80104c18 <wait+0x88>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104be6:	83 eb 80             	sub    $0xffffff80,%ebx
            havekids = 1;
80104be9:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104bee:	81 fb f4 62 11 80    	cmp    $0x801162f4,%ebx
80104bf4:	75 e5                	jne    80104bdb <wait+0x4b>
        if (!havekids || curproc->killed) {
80104bf6:	85 c0                	test   %eax,%eax
80104bf8:	74 74                	je     80104c6e <wait+0xde>
80104bfa:	8b 46 24             	mov    0x24(%esi),%eax
80104bfd:	85 c0                	test   %eax,%eax
80104bff:	75 6d                	jne    80104c6e <wait+0xde>
        sleep(curproc, &ptable.lock); // DOC: wait-sleep
80104c01:	83 ec 08             	sub    $0x8,%esp
80104c04:	68 c0 42 11 80       	push   $0x801142c0
80104c09:	56                   	push   %esi
80104c0a:	e8 c1 fe ff ff       	call   80104ad0 <sleep>
        havekids = 0;
80104c0f:	83 c4 10             	add    $0x10,%esp
80104c12:	eb aa                	jmp    80104bbe <wait+0x2e>
80104c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                kfree(p->kstack);
80104c18:	83 ec 0c             	sub    $0xc,%esp
80104c1b:	ff 73 08             	pushl  0x8(%ebx)
                pid = p->pid;
80104c1e:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
80104c21:	e8 ea e3 ff ff       	call   80103010 <kfree>
                freevm(p->pgdir);
80104c26:	5a                   	pop    %edx
80104c27:	ff 73 04             	pushl  0x4(%ebx)
                p->kstack = 0;
80104c2a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
80104c31:	e8 9a 2e 00 00       	call   80107ad0 <freevm>
                release(&ptable.lock);
80104c36:	c7 04 24 c0 42 11 80 	movl   $0x801142c0,(%esp)
                p->pid = 0;
80104c3d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
80104c44:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
80104c4b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
80104c4f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
80104c56:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                release(&ptable.lock);
80104c5d:	e8 ee 05 00 00       	call   80105250 <release>
                return pid;
80104c62:	83 c4 10             	add    $0x10,%esp
}
80104c65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c68:	89 f0                	mov    %esi,%eax
80104c6a:	5b                   	pop    %ebx
80104c6b:	5e                   	pop    %esi
80104c6c:	5d                   	pop    %ebp
80104c6d:	c3                   	ret    
            release(&ptable.lock);
80104c6e:	83 ec 0c             	sub    $0xc,%esp
            return -1;
80104c71:	be ff ff ff ff       	mov    $0xffffffff,%esi
            release(&ptable.lock);
80104c76:	68 c0 42 11 80       	push   $0x801142c0
80104c7b:	e8 d0 05 00 00       	call   80105250 <release>
            return -1;
80104c80:	83 c4 10             	add    $0x10,%esp
80104c83:	eb e0                	jmp    80104c65 <wait+0xd5>
80104c85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c90 <wakeup>:
}

// Wake up all processes sleeping on chan.
void wakeup(void* chan) {
80104c90:	f3 0f 1e fb          	endbr32 
80104c94:	55                   	push   %ebp
80104c95:	89 e5                	mov    %esp,%ebp
80104c97:	53                   	push   %ebx
80104c98:	83 ec 10             	sub    $0x10,%esp
80104c9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
80104c9e:	68 c0 42 11 80       	push   $0x801142c0
80104ca3:	e8 e8 04 00 00       	call   80105190 <acquire>
80104ca8:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cab:	b8 f4 42 11 80       	mov    $0x801142f4,%eax
80104cb0:	eb 10                	jmp    80104cc2 <wakeup+0x32>
80104cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cb8:	83 e8 80             	sub    $0xffffff80,%eax
80104cbb:	3d f4 62 11 80       	cmp    $0x801162f4,%eax
80104cc0:	74 1c                	je     80104cde <wakeup+0x4e>
        if (p->state == SLEEPING && p->chan == chan)
80104cc2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104cc6:	75 f0                	jne    80104cb8 <wakeup+0x28>
80104cc8:	3b 58 20             	cmp    0x20(%eax),%ebx
80104ccb:	75 eb                	jne    80104cb8 <wakeup+0x28>
            p->state = RUNNABLE;
80104ccd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cd4:	83 e8 80             	sub    $0xffffff80,%eax
80104cd7:	3d f4 62 11 80       	cmp    $0x801162f4,%eax
80104cdc:	75 e4                	jne    80104cc2 <wakeup+0x32>
    wakeup1(chan);
    release(&ptable.lock);
80104cde:	c7 45 08 c0 42 11 80 	movl   $0x801142c0,0x8(%ebp)
}
80104ce5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ce8:	c9                   	leave  
    release(&ptable.lock);
80104ce9:	e9 62 05 00 00       	jmp    80105250 <release>
80104cee:	66 90                	xchg   %ax,%ax

80104cf0 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid) {
80104cf0:	f3 0f 1e fb          	endbr32 
80104cf4:	55                   	push   %ebp
80104cf5:	89 e5                	mov    %esp,%ebp
80104cf7:	53                   	push   %ebx
80104cf8:	83 ec 10             	sub    $0x10,%esp
80104cfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc* p;

    acquire(&ptable.lock);
80104cfe:	68 c0 42 11 80       	push   $0x801142c0
80104d03:	e8 88 04 00 00       	call   80105190 <acquire>
80104d08:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104d0b:	b8 f4 42 11 80       	mov    $0x801142f4,%eax
80104d10:	eb 10                	jmp    80104d22 <kill+0x32>
80104d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d18:	83 e8 80             	sub    $0xffffff80,%eax
80104d1b:	3d f4 62 11 80       	cmp    $0x801162f4,%eax
80104d20:	74 36                	je     80104d58 <kill+0x68>
        if (p->pid == pid) {
80104d22:	39 58 10             	cmp    %ebx,0x10(%eax)
80104d25:	75 f1                	jne    80104d18 <kill+0x28>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
80104d27:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
            p->killed = 1;
80104d2b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            if (p->state == SLEEPING)
80104d32:	75 07                	jne    80104d3b <kill+0x4b>
                p->state = RUNNABLE;
80104d34:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            release(&ptable.lock);
80104d3b:	83 ec 0c             	sub    $0xc,%esp
80104d3e:	68 c0 42 11 80       	push   $0x801142c0
80104d43:	e8 08 05 00 00       	call   80105250 <release>
            return 0;
        }
    }
    release(&ptable.lock);
    return -1;
}
80104d48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
            return 0;
80104d4b:	83 c4 10             	add    $0x10,%esp
80104d4e:	31 c0                	xor    %eax,%eax
}
80104d50:	c9                   	leave  
80104d51:	c3                   	ret    
80104d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ptable.lock);
80104d58:	83 ec 0c             	sub    $0xc,%esp
80104d5b:	68 c0 42 11 80       	push   $0x801142c0
80104d60:	e8 eb 04 00 00       	call   80105250 <release>
}
80104d65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104d68:	83 c4 10             	add    $0x10,%esp
80104d6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d70:	c9                   	leave  
80104d71:	c3                   	ret    
80104d72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d80 <procdump>:

// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void) {
80104d80:	f3 0f 1e fb          	endbr32 
80104d84:	55                   	push   %ebp
80104d85:	89 e5                	mov    %esp,%ebp
80104d87:	57                   	push   %edi
80104d88:	56                   	push   %esi
80104d89:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104d8c:	53                   	push   %ebx
80104d8d:	bb 60 43 11 80       	mov    $0x80114360,%ebx
80104d92:	83 ec 3c             	sub    $0x3c,%esp
80104d95:	eb 28                	jmp    80104dbf <procdump+0x3f>
80104d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9e:	66 90                	xchg   %ax,%ax
        if (p->state == SLEEPING) {
            getcallerpcs((uint*)p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80104da0:	83 ec 0c             	sub    $0xc,%esp
80104da3:	68 e0 85 10 80       	push   $0x801085e0
80104da8:	e8 13 ba ff ff       	call   801007c0 <cprintf>
80104dad:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104db0:	83 eb 80             	sub    $0xffffff80,%ebx
80104db3:	81 fb 60 63 11 80    	cmp    $0x80116360,%ebx
80104db9:	0f 84 81 00 00 00    	je     80104e40 <procdump+0xc0>
        if (p->state == UNUSED)
80104dbf:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104dc2:	85 c0                	test   %eax,%eax
80104dc4:	74 ea                	je     80104db0 <procdump+0x30>
            state = "???";
80104dc6:	ba 2b 84 10 80       	mov    $0x8010842b,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104dcb:	83 f8 05             	cmp    $0x5,%eax
80104dce:	77 11                	ja     80104de1 <procdump+0x61>
80104dd0:	8b 14 85 8c 84 10 80 	mov    -0x7fef7b74(,%eax,4),%edx
            state = "???";
80104dd7:	b8 2b 84 10 80       	mov    $0x8010842b,%eax
80104ddc:	85 d2                	test   %edx,%edx
80104dde:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
80104de1:	53                   	push   %ebx
80104de2:	52                   	push   %edx
80104de3:	ff 73 a4             	pushl  -0x5c(%ebx)
80104de6:	68 2f 84 10 80       	push   $0x8010842f
80104deb:	e8 d0 b9 ff ff       	call   801007c0 <cprintf>
        if (p->state == SLEEPING) {
80104df0:	83 c4 10             	add    $0x10,%esp
80104df3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104df7:	75 a7                	jne    80104da0 <procdump+0x20>
            getcallerpcs((uint*)p->context->ebp + 2, pc);
80104df9:	83 ec 08             	sub    $0x8,%esp
80104dfc:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104dff:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104e02:	50                   	push   %eax
80104e03:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104e06:	8b 40 0c             	mov    0xc(%eax),%eax
80104e09:	83 c0 08             	add    $0x8,%eax
80104e0c:	50                   	push   %eax
80104e0d:	e8 1e 02 00 00       	call   80105030 <getcallerpcs>
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104e12:	83 c4 10             	add    $0x10,%esp
80104e15:	8d 76 00             	lea    0x0(%esi),%esi
80104e18:	8b 17                	mov    (%edi),%edx
80104e1a:	85 d2                	test   %edx,%edx
80104e1c:	74 82                	je     80104da0 <procdump+0x20>
                cprintf(" %p", pc[i]);
80104e1e:	83 ec 08             	sub    $0x8,%esp
80104e21:	83 c7 04             	add    $0x4,%edi
80104e24:	52                   	push   %edx
80104e25:	68 21 7e 10 80       	push   $0x80107e21
80104e2a:	e8 91 b9 ff ff       	call   801007c0 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104e2f:	83 c4 10             	add    $0x10,%esp
80104e32:	39 fe                	cmp    %edi,%esi
80104e34:	75 e2                	jne    80104e18 <procdump+0x98>
80104e36:	e9 65 ff ff ff       	jmp    80104da0 <procdump+0x20>
80104e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e3f:	90                   	nop
    }
}
80104e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e43:	5b                   	pop    %ebx
80104e44:	5e                   	pop    %esi
80104e45:	5f                   	pop    %edi
80104e46:	5d                   	pop    %ebp
80104e47:	c3                   	ret    
80104e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e4f:	90                   	nop

80104e50 <nuncle>:

int nuncle() {
80104e50:	f3 0f 1e fb          	endbr32 
80104e54:	55                   	push   %ebp
80104e55:	89 e5                	mov    %esp,%ebp
80104e57:	53                   	push   %ebx
80104e58:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80104e5b:	e8 30 02 00 00       	call   80105090 <pushcli>
    c = mycpu();
80104e60:	e8 0b f6 ff ff       	call   80104470 <mycpu>
    p = c->proc;
80104e65:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104e6b:	e8 70 02 00 00       	call   801050e0 <popcli>
    struct proc* current_proc = myproc();
    struct proc* grandparent = current_proc->parent->parent;

    int uncles = 0;
80104e70:	31 d2                	xor    %edx,%edx
    struct proc* grandparent = current_proc->parent->parent;
80104e72:	8b 43 14             	mov    0x14(%ebx),%eax
80104e75:	8b 58 14             	mov    0x14(%eax),%ebx
    struct proc* p;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104e78:	b8 f4 42 11 80       	mov    $0x801142f4,%eax
80104e7d:	8d 76 00             	lea    0x0(%esi),%esi
        if(p->parent == grandparent)
            uncles++;
80104e80:	31 c9                	xor    %ecx,%ecx
80104e82:	39 58 14             	cmp    %ebx,0x14(%eax)
80104e85:	0f 94 c1             	sete   %cl
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104e88:	83 e8 80             	sub    $0xffffff80,%eax
            uncles++;
80104e8b:	01 ca                	add    %ecx,%edx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104e8d:	3d f4 62 11 80       	cmp    $0x801162f4,%eax
80104e92:	75 ec                	jne    80104e80 <nuncle+0x30>
    }
    return uncles - 1;
}
80104e94:	83 c4 04             	add    $0x4,%esp
    return uncles - 1;
80104e97:	8d 42 ff             	lea    -0x1(%edx),%eax
}
80104e9a:	5b                   	pop    %ebx
80104e9b:	5d                   	pop    %ebp
80104e9c:	c3                   	ret    
80104e9d:	8d 76 00             	lea    0x0(%esi),%esi

80104ea0 <ptime>:

int ptime() {
80104ea0:	f3 0f 1e fb          	endbr32 
80104ea4:	55                   	push   %ebp
80104ea5:	89 e5                	mov    %esp,%ebp
80104ea7:	53                   	push   %ebx
80104ea8:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80104eab:	e8 e0 01 00 00       	call   80105090 <pushcli>
    c = mycpu();
80104eb0:	e8 bb f5 ff ff       	call   80104470 <mycpu>
    p = c->proc;
80104eb5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104ebb:	e8 20 02 00 00       	call   801050e0 <popcli>
    struct proc* current_proc = myproc();
    return ticks - current_proc->ctime;
80104ec0:	a1 40 6b 11 80       	mov    0x80116b40,%eax
80104ec5:	2b 43 7c             	sub    0x7c(%ebx),%eax
}
80104ec8:	83 c4 04             	add    $0x4,%esp
80104ecb:	5b                   	pop    %ebx
80104ecc:	5d                   	pop    %ebp
80104ecd:	c3                   	ret    
80104ece:	66 90                	xchg   %ax,%ax

80104ed0 <initsleeplock>:
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "sleeplock.h"

void initsleeplock(struct sleeplock* lk, char* name) {
80104ed0:	f3 0f 1e fb          	endbr32 
80104ed4:	55                   	push   %ebp
80104ed5:	89 e5                	mov    %esp,%ebp
80104ed7:	53                   	push   %ebx
80104ed8:	83 ec 0c             	sub    $0xc,%esp
80104edb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    initlock(&lk->lk, "sleep lock");
80104ede:	68 a4 84 10 80       	push   $0x801084a4
80104ee3:	8d 43 04             	lea    0x4(%ebx),%eax
80104ee6:	50                   	push   %eax
80104ee7:	e8 24 01 00 00       	call   80105010 <initlock>
    lk->name = name;
80104eec:	8b 45 0c             	mov    0xc(%ebp),%eax
    lk->locked = 0;
80104eef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    lk->pid = 0;
}
80104ef5:	83 c4 10             	add    $0x10,%esp
    lk->pid = 0;
80104ef8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
    lk->name = name;
80104eff:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104f02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f05:	c9                   	leave  
80104f06:	c3                   	ret    
80104f07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f0e:	66 90                	xchg   %ax,%ax

80104f10 <acquiresleep>:

void acquiresleep(struct sleeplock* lk) {
80104f10:	f3 0f 1e fb          	endbr32 
80104f14:	55                   	push   %ebp
80104f15:	89 e5                	mov    %esp,%ebp
80104f17:	56                   	push   %esi
80104f18:	53                   	push   %ebx
80104f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&lk->lk);
80104f1c:	8d 73 04             	lea    0x4(%ebx),%esi
80104f1f:	83 ec 0c             	sub    $0xc,%esp
80104f22:	56                   	push   %esi
80104f23:	e8 68 02 00 00       	call   80105190 <acquire>
    while (lk->locked) {
80104f28:	8b 13                	mov    (%ebx),%edx
80104f2a:	83 c4 10             	add    $0x10,%esp
80104f2d:	85 d2                	test   %edx,%edx
80104f2f:	74 1a                	je     80104f4b <acquiresleep+0x3b>
80104f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        sleep(lk, &lk->lk);
80104f38:	83 ec 08             	sub    $0x8,%esp
80104f3b:	56                   	push   %esi
80104f3c:	53                   	push   %ebx
80104f3d:	e8 8e fb ff ff       	call   80104ad0 <sleep>
    while (lk->locked) {
80104f42:	8b 03                	mov    (%ebx),%eax
80104f44:	83 c4 10             	add    $0x10,%esp
80104f47:	85 c0                	test   %eax,%eax
80104f49:	75 ed                	jne    80104f38 <acquiresleep+0x28>
    }
    lk->locked = 1;
80104f4b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
    lk->pid = myproc()->pid;
80104f51:	e8 aa f5 ff ff       	call   80104500 <myproc>
80104f56:	8b 40 10             	mov    0x10(%eax),%eax
80104f59:	89 43 3c             	mov    %eax,0x3c(%ebx)
    release(&lk->lk);
80104f5c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104f5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f62:	5b                   	pop    %ebx
80104f63:	5e                   	pop    %esi
80104f64:	5d                   	pop    %ebp
    release(&lk->lk);
80104f65:	e9 e6 02 00 00       	jmp    80105250 <release>
80104f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f70 <releasesleep>:

void releasesleep(struct sleeplock* lk) {
80104f70:	f3 0f 1e fb          	endbr32 
80104f74:	55                   	push   %ebp
80104f75:	89 e5                	mov    %esp,%ebp
80104f77:	56                   	push   %esi
80104f78:	53                   	push   %ebx
80104f79:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&lk->lk);
80104f7c:	8d 73 04             	lea    0x4(%ebx),%esi
80104f7f:	83 ec 0c             	sub    $0xc,%esp
80104f82:	56                   	push   %esi
80104f83:	e8 08 02 00 00       	call   80105190 <acquire>
    lk->locked = 0;
80104f88:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    lk->pid = 0;
80104f8e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
    wakeup(lk);
80104f95:	89 1c 24             	mov    %ebx,(%esp)
80104f98:	e8 f3 fc ff ff       	call   80104c90 <wakeup>
    release(&lk->lk);
80104f9d:	89 75 08             	mov    %esi,0x8(%ebp)
80104fa0:	83 c4 10             	add    $0x10,%esp
}
80104fa3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fa6:	5b                   	pop    %ebx
80104fa7:	5e                   	pop    %esi
80104fa8:	5d                   	pop    %ebp
    release(&lk->lk);
80104fa9:	e9 a2 02 00 00       	jmp    80105250 <release>
80104fae:	66 90                	xchg   %ax,%ax

80104fb0 <holdingsleep>:

int holdingsleep(struct sleeplock* lk) {
80104fb0:	f3 0f 1e fb          	endbr32 
80104fb4:	55                   	push   %ebp
80104fb5:	89 e5                	mov    %esp,%ebp
80104fb7:	57                   	push   %edi
80104fb8:	31 ff                	xor    %edi,%edi
80104fba:	56                   	push   %esi
80104fbb:	53                   	push   %ebx
80104fbc:	83 ec 18             	sub    $0x18,%esp
80104fbf:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int r;

    acquire(&lk->lk);
80104fc2:	8d 73 04             	lea    0x4(%ebx),%esi
80104fc5:	56                   	push   %esi
80104fc6:	e8 c5 01 00 00       	call   80105190 <acquire>
    r = lk->locked && (lk->pid == myproc()->pid);
80104fcb:	8b 03                	mov    (%ebx),%eax
80104fcd:	83 c4 10             	add    $0x10,%esp
80104fd0:	85 c0                	test   %eax,%eax
80104fd2:	75 1c                	jne    80104ff0 <holdingsleep+0x40>
    release(&lk->lk);
80104fd4:	83 ec 0c             	sub    $0xc,%esp
80104fd7:	56                   	push   %esi
80104fd8:	e8 73 02 00 00       	call   80105250 <release>
    return r;
}
80104fdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fe0:	89 f8                	mov    %edi,%eax
80104fe2:	5b                   	pop    %ebx
80104fe3:	5e                   	pop    %esi
80104fe4:	5f                   	pop    %edi
80104fe5:	5d                   	pop    %ebp
80104fe6:	c3                   	ret    
80104fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fee:	66 90                	xchg   %ax,%ax
    r = lk->locked && (lk->pid == myproc()->pid);
80104ff0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104ff3:	e8 08 f5 ff ff       	call   80104500 <myproc>
80104ff8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104ffb:	0f 94 c0             	sete   %al
80104ffe:	0f b6 c0             	movzbl %al,%eax
80105001:	89 c7                	mov    %eax,%edi
80105003:	eb cf                	jmp    80104fd4 <holdingsleep+0x24>
80105005:	66 90                	xchg   %ax,%ax
80105007:	66 90                	xchg   %ax,%ax
80105009:	66 90                	xchg   %ax,%ax
8010500b:	66 90                	xchg   %ax,%ax
8010500d:	66 90                	xchg   %ax,%ax
8010500f:	90                   	nop

80105010 <initlock>:
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

void initlock(struct spinlock* lk, char* name) {
80105010:	f3 0f 1e fb          	endbr32 
80105014:	55                   	push   %ebp
80105015:	89 e5                	mov    %esp,%ebp
80105017:	8b 45 08             	mov    0x8(%ebp),%eax
    lk->name = name;
8010501a:	8b 55 0c             	mov    0xc(%ebp),%edx
    lk->locked = 0;
8010501d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    lk->name = name;
80105023:	89 50 04             	mov    %edx,0x4(%eax)
    lk->cpu = 0;
80105026:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010502d:	5d                   	pop    %ebp
8010502e:	c3                   	ret    
8010502f:	90                   	nop

80105030 <getcallerpcs>:

    popcli();
}

// Record the current call stack in pcs[] by following the %ebp chain.
void getcallerpcs(void* v, uint pcs[]) {
80105030:	f3 0f 1e fb          	endbr32 
80105034:	55                   	push   %ebp
    uint* ebp;
    int i;

    ebp = (uint*)v - 2;
    for (i = 0; i < 10; i++) {
80105035:	31 d2                	xor    %edx,%edx
void getcallerpcs(void* v, uint pcs[]) {
80105037:	89 e5                	mov    %esp,%ebp
80105039:	53                   	push   %ebx
    ebp = (uint*)v - 2;
8010503a:	8b 45 08             	mov    0x8(%ebp),%eax
void getcallerpcs(void* v, uint pcs[]) {
8010503d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    ebp = (uint*)v - 2;
80105040:	83 e8 08             	sub    $0x8,%eax
    for (i = 0; i < 10; i++) {
80105043:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105047:	90                   	nop
        if (ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105048:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010504e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80105054:	77 1a                	ja     80105070 <getcallerpcs+0x40>
            break;
        pcs[i] = ebp[1];     // saved %eip
80105056:	8b 58 04             	mov    0x4(%eax),%ebx
80105059:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
    for (i = 0; i < 10; i++) {
8010505c:	83 c2 01             	add    $0x1,%edx
        ebp = (uint*)ebp[0]; // saved %ebp
8010505f:	8b 00                	mov    (%eax),%eax
    for (i = 0; i < 10; i++) {
80105061:	83 fa 0a             	cmp    $0xa,%edx
80105064:	75 e2                	jne    80105048 <getcallerpcs+0x18>
    }
    for (; i < 10; i++)
        pcs[i] = 0;
}
80105066:	5b                   	pop    %ebx
80105067:	5d                   	pop    %ebp
80105068:	c3                   	ret    
80105069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (; i < 10; i++)
80105070:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80105073:	8d 51 28             	lea    0x28(%ecx),%edx
80105076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010507d:	8d 76 00             	lea    0x0(%esi),%esi
        pcs[i] = 0;
80105080:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (; i < 10; i++)
80105086:	83 c0 04             	add    $0x4,%eax
80105089:	39 d0                	cmp    %edx,%eax
8010508b:	75 f3                	jne    80105080 <getcallerpcs+0x50>
}
8010508d:	5b                   	pop    %ebx
8010508e:	5d                   	pop    %ebp
8010508f:	c3                   	ret    

80105090 <pushcli>:

// Pushcli/popcli are like cli/sti except that they are matched:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void pushcli(void) {
80105090:	f3 0f 1e fb          	endbr32 
80105094:	55                   	push   %ebp
80105095:	89 e5                	mov    %esp,%ebp
80105097:	53                   	push   %ebx
80105098:	83 ec 04             	sub    $0x4,%esp
8010509b:	9c                   	pushf  
8010509c:	5b                   	pop    %ebx
    asm volatile("cli");
8010509d:	fa                   	cli    
    int eflags;

    eflags = readeflags();
    cli();
    if (mycpu()->ncli == 0)
8010509e:	e8 cd f3 ff ff       	call   80104470 <mycpu>
801050a3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801050a9:	85 c0                	test   %eax,%eax
801050ab:	74 13                	je     801050c0 <pushcli+0x30>
        mycpu()->intena = eflags & FL_IF;
    mycpu()->ncli += 1;
801050ad:	e8 be f3 ff ff       	call   80104470 <mycpu>
801050b2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801050b9:	83 c4 04             	add    $0x4,%esp
801050bc:	5b                   	pop    %ebx
801050bd:	5d                   	pop    %ebp
801050be:	c3                   	ret    
801050bf:	90                   	nop
        mycpu()->intena = eflags & FL_IF;
801050c0:	e8 ab f3 ff ff       	call   80104470 <mycpu>
801050c5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801050cb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801050d1:	eb da                	jmp    801050ad <pushcli+0x1d>
801050d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801050e0 <popcli>:

void popcli(void) {
801050e0:	f3 0f 1e fb          	endbr32 
801050e4:	55                   	push   %ebp
801050e5:	89 e5                	mov    %esp,%ebp
801050e7:	83 ec 08             	sub    $0x8,%esp
    asm volatile("pushfl; popl %0"
801050ea:	9c                   	pushf  
801050eb:	58                   	pop    %eax
    if (readeflags() & FL_IF)
801050ec:	f6 c4 02             	test   $0x2,%ah
801050ef:	75 31                	jne    80105122 <popcli+0x42>
        panic("popcli - interruptible");
    if (--mycpu()->ncli < 0)
801050f1:	e8 7a f3 ff ff       	call   80104470 <mycpu>
801050f6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801050fd:	78 30                	js     8010512f <popcli+0x4f>
        panic("popcli");
    if (mycpu()->ncli == 0 && mycpu()->intena)
801050ff:	e8 6c f3 ff ff       	call   80104470 <mycpu>
80105104:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010510a:	85 d2                	test   %edx,%edx
8010510c:	74 02                	je     80105110 <popcli+0x30>
        sti();
}
8010510e:	c9                   	leave  
8010510f:	c3                   	ret    
    if (mycpu()->ncli == 0 && mycpu()->intena)
80105110:	e8 5b f3 ff ff       	call   80104470 <mycpu>
80105115:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010511b:	85 c0                	test   %eax,%eax
8010511d:	74 ef                	je     8010510e <popcli+0x2e>
    asm volatile("sti");
8010511f:	fb                   	sti    
}
80105120:	c9                   	leave  
80105121:	c3                   	ret    
        panic("popcli - interruptible");
80105122:	83 ec 0c             	sub    $0xc,%esp
80105125:	68 af 84 10 80       	push   $0x801084af
8010512a:	e8 61 b2 ff ff       	call   80100390 <panic>
        panic("popcli");
8010512f:	83 ec 0c             	sub    $0xc,%esp
80105132:	68 c6 84 10 80       	push   $0x801084c6
80105137:	e8 54 b2 ff ff       	call   80100390 <panic>
8010513c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105140 <holding>:
int holding(struct spinlock* lock) {
80105140:	f3 0f 1e fb          	endbr32 
80105144:	55                   	push   %ebp
80105145:	89 e5                	mov    %esp,%ebp
80105147:	56                   	push   %esi
80105148:	53                   	push   %ebx
80105149:	8b 75 08             	mov    0x8(%ebp),%esi
8010514c:	31 db                	xor    %ebx,%ebx
    pushcli();
8010514e:	e8 3d ff ff ff       	call   80105090 <pushcli>
    r = lock->locked && lock->cpu == mycpu();
80105153:	8b 06                	mov    (%esi),%eax
80105155:	85 c0                	test   %eax,%eax
80105157:	75 0f                	jne    80105168 <holding+0x28>
    popcli();
80105159:	e8 82 ff ff ff       	call   801050e0 <popcli>
}
8010515e:	89 d8                	mov    %ebx,%eax
80105160:	5b                   	pop    %ebx
80105161:	5e                   	pop    %esi
80105162:	5d                   	pop    %ebp
80105163:	c3                   	ret    
80105164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    r = lock->locked && lock->cpu == mycpu();
80105168:	8b 5e 08             	mov    0x8(%esi),%ebx
8010516b:	e8 00 f3 ff ff       	call   80104470 <mycpu>
80105170:	39 c3                	cmp    %eax,%ebx
80105172:	0f 94 c3             	sete   %bl
    popcli();
80105175:	e8 66 ff ff ff       	call   801050e0 <popcli>
    r = lock->locked && lock->cpu == mycpu();
8010517a:	0f b6 db             	movzbl %bl,%ebx
}
8010517d:	89 d8                	mov    %ebx,%eax
8010517f:	5b                   	pop    %ebx
80105180:	5e                   	pop    %esi
80105181:	5d                   	pop    %ebp
80105182:	c3                   	ret    
80105183:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010518a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105190 <acquire>:
void acquire(struct spinlock* lk) {
80105190:	f3 0f 1e fb          	endbr32 
80105194:	55                   	push   %ebp
80105195:	89 e5                	mov    %esp,%ebp
80105197:	56                   	push   %esi
80105198:	53                   	push   %ebx
    pushcli(); // disable interrupts to avoid deadlock.
80105199:	e8 f2 fe ff ff       	call   80105090 <pushcli>
    if (holding(lk))
8010519e:	8b 5d 08             	mov    0x8(%ebp),%ebx
801051a1:	83 ec 0c             	sub    $0xc,%esp
801051a4:	53                   	push   %ebx
801051a5:	e8 96 ff ff ff       	call   80105140 <holding>
801051aa:	83 c4 10             	add    $0x10,%esp
801051ad:	85 c0                	test   %eax,%eax
801051af:	0f 85 7f 00 00 00    	jne    80105234 <acquire+0xa4>
801051b5:	89 c6                	mov    %eax,%esi
    asm volatile("lock; xchgl %0, %1"
801051b7:	ba 01 00 00 00       	mov    $0x1,%edx
801051bc:	eb 05                	jmp    801051c3 <acquire+0x33>
801051be:	66 90                	xchg   %ax,%ax
801051c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801051c3:	89 d0                	mov    %edx,%eax
801051c5:	f0 87 03             	lock xchg %eax,(%ebx)
    while (xchg(&lk->locked, 1) != 0)
801051c8:	85 c0                	test   %eax,%eax
801051ca:	75 f4                	jne    801051c0 <acquire+0x30>
    __sync_synchronize();
801051cc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    lk->cpu = mycpu();
801051d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801051d4:	e8 97 f2 ff ff       	call   80104470 <mycpu>
801051d9:	89 43 08             	mov    %eax,0x8(%ebx)
    ebp = (uint*)v - 2;
801051dc:	89 e8                	mov    %ebp,%eax
801051de:	66 90                	xchg   %ax,%ax
        if (ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801051e0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801051e6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801051ec:	77 22                	ja     80105210 <acquire+0x80>
        pcs[i] = ebp[1];     // saved %eip
801051ee:	8b 50 04             	mov    0x4(%eax),%edx
801051f1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
    for (i = 0; i < 10; i++) {
801051f5:	83 c6 01             	add    $0x1,%esi
        ebp = (uint*)ebp[0]; // saved %ebp
801051f8:	8b 00                	mov    (%eax),%eax
    for (i = 0; i < 10; i++) {
801051fa:	83 fe 0a             	cmp    $0xa,%esi
801051fd:	75 e1                	jne    801051e0 <acquire+0x50>
}
801051ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105202:	5b                   	pop    %ebx
80105203:	5e                   	pop    %esi
80105204:	5d                   	pop    %ebp
80105205:	c3                   	ret    
80105206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010520d:	8d 76 00             	lea    0x0(%esi),%esi
    for (; i < 10; i++)
80105210:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80105214:	83 c3 34             	add    $0x34,%ebx
80105217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010521e:	66 90                	xchg   %ax,%ax
        pcs[i] = 0;
80105220:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (; i < 10; i++)
80105226:	83 c0 04             	add    $0x4,%eax
80105229:	39 d8                	cmp    %ebx,%eax
8010522b:	75 f3                	jne    80105220 <acquire+0x90>
}
8010522d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105230:	5b                   	pop    %ebx
80105231:	5e                   	pop    %esi
80105232:	5d                   	pop    %ebp
80105233:	c3                   	ret    
        panic("acquire");
80105234:	83 ec 0c             	sub    $0xc,%esp
80105237:	68 cd 84 10 80       	push   $0x801084cd
8010523c:	e8 4f b1 ff ff       	call   80100390 <panic>
80105241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010524f:	90                   	nop

80105250 <release>:
void release(struct spinlock* lk) {
80105250:	f3 0f 1e fb          	endbr32 
80105254:	55                   	push   %ebp
80105255:	89 e5                	mov    %esp,%ebp
80105257:	53                   	push   %ebx
80105258:	83 ec 10             	sub    $0x10,%esp
8010525b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (!holding(lk))
8010525e:	53                   	push   %ebx
8010525f:	e8 dc fe ff ff       	call   80105140 <holding>
80105264:	83 c4 10             	add    $0x10,%esp
80105267:	85 c0                	test   %eax,%eax
80105269:	74 22                	je     8010528d <release+0x3d>
    lk->pcs[0] = 0;
8010526b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    lk->cpu = 0;
80105272:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    __sync_synchronize();
80105279:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    asm volatile("movl $0, %0"
8010527e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105284:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105287:	c9                   	leave  
    popcli();
80105288:	e9 53 fe ff ff       	jmp    801050e0 <popcli>
        panic("release");
8010528d:	83 ec 0c             	sub    $0xc,%esp
80105290:	68 d5 84 10 80       	push   $0x801084d5
80105295:	e8 f6 b0 ff ff       	call   80100390 <panic>
8010529a:	66 90                	xchg   %ax,%ax
8010529c:	66 90                	xchg   %ax,%ax
8010529e:	66 90                	xchg   %ax,%ax

801052a0 <memset>:
#include "types.h"
#include "x86.h"

void* memset(void* dst, int c, uint n) {
801052a0:	f3 0f 1e fb          	endbr32 
801052a4:	55                   	push   %ebp
801052a5:	89 e5                	mov    %esp,%ebp
801052a7:	57                   	push   %edi
801052a8:	8b 55 08             	mov    0x8(%ebp),%edx
801052ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
801052ae:	53                   	push   %ebx
801052af:	8b 45 0c             	mov    0xc(%ebp),%eax
    if ((int)dst % 4 == 0 && n % 4 == 0) {
801052b2:	89 d7                	mov    %edx,%edi
801052b4:	09 cf                	or     %ecx,%edi
801052b6:	83 e7 03             	and    $0x3,%edi
801052b9:	75 25                	jne    801052e0 <memset+0x40>
        c &= 0xFF;
801052bb:	0f b6 f8             	movzbl %al,%edi
        stosl(dst, (c << 24) | (c << 16) | (c << 8) | c, n / 4);
801052be:	c1 e0 18             	shl    $0x18,%eax
801052c1:	89 fb                	mov    %edi,%ebx
801052c3:	c1 e9 02             	shr    $0x2,%ecx
801052c6:	c1 e3 10             	shl    $0x10,%ebx
801052c9:	09 d8                	or     %ebx,%eax
801052cb:	09 f8                	or     %edi,%eax
801052cd:	c1 e7 08             	shl    $0x8,%edi
801052d0:	09 f8                	or     %edi,%eax
    asm volatile("cld; rep stosl"
801052d2:	89 d7                	mov    %edx,%edi
801052d4:	fc                   	cld    
801052d5:	f3 ab                	rep stos %eax,%es:(%edi)
    }
    else
        stosb(dst, c, n);
    return dst;
}
801052d7:	5b                   	pop    %ebx
801052d8:	89 d0                	mov    %edx,%eax
801052da:	5f                   	pop    %edi
801052db:	5d                   	pop    %ebp
801052dc:	c3                   	ret    
801052dd:	8d 76 00             	lea    0x0(%esi),%esi
    asm volatile("cld; rep stosb"
801052e0:	89 d7                	mov    %edx,%edi
801052e2:	fc                   	cld    
801052e3:	f3 aa                	rep stos %al,%es:(%edi)
801052e5:	5b                   	pop    %ebx
801052e6:	89 d0                	mov    %edx,%eax
801052e8:	5f                   	pop    %edi
801052e9:	5d                   	pop    %ebp
801052ea:	c3                   	ret    
801052eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052ef:	90                   	nop

801052f0 <memcmp>:

int memcmp(const void* v1, const void* v2, uint n) {
801052f0:	f3 0f 1e fb          	endbr32 
801052f4:	55                   	push   %ebp
801052f5:	89 e5                	mov    %esp,%ebp
801052f7:	56                   	push   %esi
801052f8:	8b 75 10             	mov    0x10(%ebp),%esi
801052fb:	8b 55 08             	mov    0x8(%ebp),%edx
801052fe:	53                   	push   %ebx
801052ff:	8b 45 0c             	mov    0xc(%ebp),%eax
    const uchar *s1, *s2;

    s1 = v1;
    s2 = v2;
    while (n-- > 0) {
80105302:	85 f6                	test   %esi,%esi
80105304:	74 2a                	je     80105330 <memcmp+0x40>
80105306:	01 c6                	add    %eax,%esi
80105308:	eb 10                	jmp    8010531a <memcmp+0x2a>
8010530a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (*s1 != *s2)
            return *s1 - *s2;
        s1++, s2++;
80105310:	83 c0 01             	add    $0x1,%eax
80105313:	83 c2 01             	add    $0x1,%edx
    while (n-- > 0) {
80105316:	39 f0                	cmp    %esi,%eax
80105318:	74 16                	je     80105330 <memcmp+0x40>
        if (*s1 != *s2)
8010531a:	0f b6 0a             	movzbl (%edx),%ecx
8010531d:	0f b6 18             	movzbl (%eax),%ebx
80105320:	38 d9                	cmp    %bl,%cl
80105322:	74 ec                	je     80105310 <memcmp+0x20>
            return *s1 - *s2;
80105324:	0f b6 c1             	movzbl %cl,%eax
80105327:	29 d8                	sub    %ebx,%eax
    }

    return 0;
}
80105329:	5b                   	pop    %ebx
8010532a:	5e                   	pop    %esi
8010532b:	5d                   	pop    %ebp
8010532c:	c3                   	ret    
8010532d:	8d 76 00             	lea    0x0(%esi),%esi
80105330:	5b                   	pop    %ebx
    return 0;
80105331:	31 c0                	xor    %eax,%eax
}
80105333:	5e                   	pop    %esi
80105334:	5d                   	pop    %ebp
80105335:	c3                   	ret    
80105336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010533d:	8d 76 00             	lea    0x0(%esi),%esi

80105340 <memmove>:

void* memmove(void* dst, const void* src, uint n) {
80105340:	f3 0f 1e fb          	endbr32 
80105344:	55                   	push   %ebp
80105345:	89 e5                	mov    %esp,%ebp
80105347:	57                   	push   %edi
80105348:	8b 55 08             	mov    0x8(%ebp),%edx
8010534b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010534e:	56                   	push   %esi
8010534f:	8b 75 0c             	mov    0xc(%ebp),%esi
    const char* s;
    char* d;

    s = src;
    d = dst;
    if (s < d && s + n > d) {
80105352:	39 d6                	cmp    %edx,%esi
80105354:	73 2a                	jae    80105380 <memmove+0x40>
80105356:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105359:	39 fa                	cmp    %edi,%edx
8010535b:	73 23                	jae    80105380 <memmove+0x40>
8010535d:	8d 41 ff             	lea    -0x1(%ecx),%eax
        s += n;
        d += n;
        while (n-- > 0)
80105360:	85 c9                	test   %ecx,%ecx
80105362:	74 13                	je     80105377 <memmove+0x37>
80105364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            *--d = *--s;
80105368:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010536c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
        while (n-- > 0)
8010536f:	83 e8 01             	sub    $0x1,%eax
80105372:	83 f8 ff             	cmp    $0xffffffff,%eax
80105375:	75 f1                	jne    80105368 <memmove+0x28>
    else
        while (n-- > 0)
            *d++ = *s++;

    return dst;
}
80105377:	5e                   	pop    %esi
80105378:	89 d0                	mov    %edx,%eax
8010537a:	5f                   	pop    %edi
8010537b:	5d                   	pop    %ebp
8010537c:	c3                   	ret    
8010537d:	8d 76 00             	lea    0x0(%esi),%esi
        while (n-- > 0)
80105380:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105383:	89 d7                	mov    %edx,%edi
80105385:	85 c9                	test   %ecx,%ecx
80105387:	74 ee                	je     80105377 <memmove+0x37>
80105389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            *d++ = *s++;
80105390:	a4                   	movsb  %ds:(%esi),%es:(%edi)
        while (n-- > 0)
80105391:	39 f0                	cmp    %esi,%eax
80105393:	75 fb                	jne    80105390 <memmove+0x50>
}
80105395:	5e                   	pop    %esi
80105396:	89 d0                	mov    %edx,%eax
80105398:	5f                   	pop    %edi
80105399:	5d                   	pop    %ebp
8010539a:	c3                   	ret    
8010539b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010539f:	90                   	nop

801053a0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void* memcpy(void* dst, const void* src, uint n) {
801053a0:	f3 0f 1e fb          	endbr32 
    return memmove(dst, src, n);
801053a4:	eb 9a                	jmp    80105340 <memmove>
801053a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ad:	8d 76 00             	lea    0x0(%esi),%esi

801053b0 <strncmp>:
}

int strncmp(const char* p, const char* q, uint n) {
801053b0:	f3 0f 1e fb          	endbr32 
801053b4:	55                   	push   %ebp
801053b5:	89 e5                	mov    %esp,%ebp
801053b7:	56                   	push   %esi
801053b8:	8b 75 10             	mov    0x10(%ebp),%esi
801053bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801053be:	53                   	push   %ebx
801053bf:	8b 45 0c             	mov    0xc(%ebp),%eax
    while (n > 0 && *p && *p == *q)
801053c2:	85 f6                	test   %esi,%esi
801053c4:	74 32                	je     801053f8 <strncmp+0x48>
801053c6:	01 c6                	add    %eax,%esi
801053c8:	eb 14                	jmp    801053de <strncmp+0x2e>
801053ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053d0:	38 da                	cmp    %bl,%dl
801053d2:	75 14                	jne    801053e8 <strncmp+0x38>
        n--, p++, q++;
801053d4:	83 c0 01             	add    $0x1,%eax
801053d7:	83 c1 01             	add    $0x1,%ecx
    while (n > 0 && *p && *p == *q)
801053da:	39 f0                	cmp    %esi,%eax
801053dc:	74 1a                	je     801053f8 <strncmp+0x48>
801053de:	0f b6 11             	movzbl (%ecx),%edx
801053e1:	0f b6 18             	movzbl (%eax),%ebx
801053e4:	84 d2                	test   %dl,%dl
801053e6:	75 e8                	jne    801053d0 <strncmp+0x20>
    if (n == 0)
        return 0;
    return (uchar)*p - (uchar)*q;
801053e8:	0f b6 c2             	movzbl %dl,%eax
801053eb:	29 d8                	sub    %ebx,%eax
}
801053ed:	5b                   	pop    %ebx
801053ee:	5e                   	pop    %esi
801053ef:	5d                   	pop    %ebp
801053f0:	c3                   	ret    
801053f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053f8:	5b                   	pop    %ebx
        return 0;
801053f9:	31 c0                	xor    %eax,%eax
}
801053fb:	5e                   	pop    %esi
801053fc:	5d                   	pop    %ebp
801053fd:	c3                   	ret    
801053fe:	66 90                	xchg   %ax,%ax

80105400 <strncpy>:

char* strncpy(char* s, const char* t, int n) {
80105400:	f3 0f 1e fb          	endbr32 
80105404:	55                   	push   %ebp
80105405:	89 e5                	mov    %esp,%ebp
80105407:	57                   	push   %edi
80105408:	56                   	push   %esi
80105409:	8b 75 08             	mov    0x8(%ebp),%esi
8010540c:	53                   	push   %ebx
8010540d:	8b 45 10             	mov    0x10(%ebp),%eax
    char* os;

    os = s;
    while (n-- > 0 && (*s++ = *t++) != 0)
80105410:	89 f2                	mov    %esi,%edx
80105412:	eb 1b                	jmp    8010542f <strncpy+0x2f>
80105414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105418:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010541c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010541f:	83 c2 01             	add    $0x1,%edx
80105422:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105426:	89 f9                	mov    %edi,%ecx
80105428:	88 4a ff             	mov    %cl,-0x1(%edx)
8010542b:	84 c9                	test   %cl,%cl
8010542d:	74 09                	je     80105438 <strncpy+0x38>
8010542f:	89 c3                	mov    %eax,%ebx
80105431:	83 e8 01             	sub    $0x1,%eax
80105434:	85 db                	test   %ebx,%ebx
80105436:	7f e0                	jg     80105418 <strncpy+0x18>
        ;
    while (n-- > 0)
80105438:	89 d1                	mov    %edx,%ecx
8010543a:	85 c0                	test   %eax,%eax
8010543c:	7e 15                	jle    80105453 <strncpy+0x53>
8010543e:	66 90                	xchg   %ax,%ax
        *s++ = 0;
80105440:	83 c1 01             	add    $0x1,%ecx
80105443:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
    while (n-- > 0)
80105447:	89 c8                	mov    %ecx,%eax
80105449:	f7 d0                	not    %eax
8010544b:	01 d0                	add    %edx,%eax
8010544d:	01 d8                	add    %ebx,%eax
8010544f:	85 c0                	test   %eax,%eax
80105451:	7f ed                	jg     80105440 <strncpy+0x40>
    return os;
}
80105453:	5b                   	pop    %ebx
80105454:	89 f0                	mov    %esi,%eax
80105456:	5e                   	pop    %esi
80105457:	5f                   	pop    %edi
80105458:	5d                   	pop    %ebp
80105459:	c3                   	ret    
8010545a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105460 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char* safestrcpy(char* s, const char* t, int n) {
80105460:	f3 0f 1e fb          	endbr32 
80105464:	55                   	push   %ebp
80105465:	89 e5                	mov    %esp,%ebp
80105467:	56                   	push   %esi
80105468:	8b 55 10             	mov    0x10(%ebp),%edx
8010546b:	8b 75 08             	mov    0x8(%ebp),%esi
8010546e:	53                   	push   %ebx
8010546f:	8b 45 0c             	mov    0xc(%ebp),%eax
    char* os;

    os = s;
    if (n <= 0)
80105472:	85 d2                	test   %edx,%edx
80105474:	7e 21                	jle    80105497 <safestrcpy+0x37>
80105476:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010547a:	89 f2                	mov    %esi,%edx
8010547c:	eb 12                	jmp    80105490 <safestrcpy+0x30>
8010547e:	66 90                	xchg   %ax,%ax
        return os;
    while (--n > 0 && (*s++ = *t++) != 0)
80105480:	0f b6 08             	movzbl (%eax),%ecx
80105483:	83 c0 01             	add    $0x1,%eax
80105486:	83 c2 01             	add    $0x1,%edx
80105489:	88 4a ff             	mov    %cl,-0x1(%edx)
8010548c:	84 c9                	test   %cl,%cl
8010548e:	74 04                	je     80105494 <safestrcpy+0x34>
80105490:	39 d8                	cmp    %ebx,%eax
80105492:	75 ec                	jne    80105480 <safestrcpy+0x20>
        ;
    *s = 0;
80105494:	c6 02 00             	movb   $0x0,(%edx)
    return os;
}
80105497:	89 f0                	mov    %esi,%eax
80105499:	5b                   	pop    %ebx
8010549a:	5e                   	pop    %esi
8010549b:	5d                   	pop    %ebp
8010549c:	c3                   	ret    
8010549d:	8d 76 00             	lea    0x0(%esi),%esi

801054a0 <strlen>:

int strlen(const char* s) {
801054a0:	f3 0f 1e fb          	endbr32 
801054a4:	55                   	push   %ebp
    int n;

    for (n = 0; s[n]; n++)
801054a5:	31 c0                	xor    %eax,%eax
int strlen(const char* s) {
801054a7:	89 e5                	mov    %esp,%ebp
801054a9:	8b 55 08             	mov    0x8(%ebp),%edx
    for (n = 0; s[n]; n++)
801054ac:	80 3a 00             	cmpb   $0x0,(%edx)
801054af:	74 10                	je     801054c1 <strlen+0x21>
801054b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054b8:	83 c0 01             	add    $0x1,%eax
801054bb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801054bf:	75 f7                	jne    801054b8 <strlen+0x18>
        ;
    return n;
}
801054c1:	5d                   	pop    %ebp
801054c2:	c3                   	ret    

801054c3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801054c3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801054c7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801054cb:	55                   	push   %ebp
  pushl %ebx
801054cc:	53                   	push   %ebx
  pushl %esi
801054cd:	56                   	push   %esi
  pushl %edi
801054ce:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801054cf:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801054d1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801054d3:	5f                   	pop    %edi
  popl %esi
801054d4:	5e                   	pop    %esi
  popl %ebx
801054d5:	5b                   	pop    %ebx
  popl %ebp
801054d6:	5d                   	pop    %ebp
  ret
801054d7:	c3                   	ret    
801054d8:	66 90                	xchg   %ax,%ax
801054da:	66 90                	xchg   %ax,%ax
801054dc:	66 90                	xchg   %ax,%ax
801054de:	66 90                	xchg   %ax,%ax

801054e0 <fetchint>:
// Arguments on the stack, from the user call to the C
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int fetchint(uint addr, int* ip) {
801054e0:	f3 0f 1e fb          	endbr32 
801054e4:	55                   	push   %ebp
801054e5:	89 e5                	mov    %esp,%ebp
801054e7:	53                   	push   %ebx
801054e8:	83 ec 04             	sub    $0x4,%esp
801054eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc* curproc = myproc();
801054ee:	e8 0d f0 ff ff       	call   80104500 <myproc>

    if (addr >= curproc->sz || addr + 4 > curproc->sz)
801054f3:	8b 00                	mov    (%eax),%eax
801054f5:	39 d8                	cmp    %ebx,%eax
801054f7:	76 17                	jbe    80105510 <fetchint+0x30>
801054f9:	8d 53 04             	lea    0x4(%ebx),%edx
801054fc:	39 d0                	cmp    %edx,%eax
801054fe:	72 10                	jb     80105510 <fetchint+0x30>
        return -1;
    *ip = *(int*)(addr);
80105500:	8b 45 0c             	mov    0xc(%ebp),%eax
80105503:	8b 13                	mov    (%ebx),%edx
80105505:	89 10                	mov    %edx,(%eax)
    return 0;
80105507:	31 c0                	xor    %eax,%eax
}
80105509:	83 c4 04             	add    $0x4,%esp
8010550c:	5b                   	pop    %ebx
8010550d:	5d                   	pop    %ebp
8010550e:	c3                   	ret    
8010550f:	90                   	nop
        return -1;
80105510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105515:	eb f2                	jmp    80105509 <fetchint+0x29>
80105517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010551e:	66 90                	xchg   %ax,%ax

80105520 <fetchstr>:

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int fetchstr(uint addr, char** pp) {
80105520:	f3 0f 1e fb          	endbr32 
80105524:	55                   	push   %ebp
80105525:	89 e5                	mov    %esp,%ebp
80105527:	53                   	push   %ebx
80105528:	83 ec 04             	sub    $0x4,%esp
8010552b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    char *s, *ep;
    struct proc* curproc = myproc();
8010552e:	e8 cd ef ff ff       	call   80104500 <myproc>

    if (addr >= curproc->sz)
80105533:	39 18                	cmp    %ebx,(%eax)
80105535:	76 31                	jbe    80105568 <fetchstr+0x48>
        return -1;
    *pp = (char*)addr;
80105537:	8b 55 0c             	mov    0xc(%ebp),%edx
8010553a:	89 1a                	mov    %ebx,(%edx)
    ep = (char*)curproc->sz;
8010553c:	8b 10                	mov    (%eax),%edx
    for (s = *pp; s < ep; s++) {
8010553e:	39 d3                	cmp    %edx,%ebx
80105540:	73 26                	jae    80105568 <fetchstr+0x48>
80105542:	89 d8                	mov    %ebx,%eax
80105544:	eb 11                	jmp    80105557 <fetchstr+0x37>
80105546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010554d:	8d 76 00             	lea    0x0(%esi),%esi
80105550:	83 c0 01             	add    $0x1,%eax
80105553:	39 c2                	cmp    %eax,%edx
80105555:	76 11                	jbe    80105568 <fetchstr+0x48>
        if (*s == 0)
80105557:	80 38 00             	cmpb   $0x0,(%eax)
8010555a:	75 f4                	jne    80105550 <fetchstr+0x30>
            return s - *pp;
    }
    return -1;
}
8010555c:	83 c4 04             	add    $0x4,%esp
            return s - *pp;
8010555f:	29 d8                	sub    %ebx,%eax
}
80105561:	5b                   	pop    %ebx
80105562:	5d                   	pop    %ebp
80105563:	c3                   	ret    
80105564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105568:	83 c4 04             	add    $0x4,%esp
        return -1;
8010556b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105570:	5b                   	pop    %ebx
80105571:	5d                   	pop    %ebp
80105572:	c3                   	ret    
80105573:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010557a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105580 <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int* ip) {
80105580:	f3 0f 1e fb          	endbr32 
80105584:	55                   	push   %ebp
80105585:	89 e5                	mov    %esp,%ebp
80105587:	56                   	push   %esi
80105588:	53                   	push   %ebx
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80105589:	e8 72 ef ff ff       	call   80104500 <myproc>
8010558e:	8b 55 08             	mov    0x8(%ebp),%edx
80105591:	8b 40 18             	mov    0x18(%eax),%eax
80105594:	8b 40 44             	mov    0x44(%eax),%eax
80105597:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    struct proc* curproc = myproc();
8010559a:	e8 61 ef ff ff       	call   80104500 <myproc>
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
8010559f:	8d 73 04             	lea    0x4(%ebx),%esi
    if (addr >= curproc->sz || addr + 4 > curproc->sz)
801055a2:	8b 00                	mov    (%eax),%eax
801055a4:	39 c6                	cmp    %eax,%esi
801055a6:	73 18                	jae    801055c0 <argint+0x40>
801055a8:	8d 53 08             	lea    0x8(%ebx),%edx
801055ab:	39 d0                	cmp    %edx,%eax
801055ad:	72 11                	jb     801055c0 <argint+0x40>
    *ip = *(int*)(addr);
801055af:	8b 45 0c             	mov    0xc(%ebp),%eax
801055b2:	8b 53 04             	mov    0x4(%ebx),%edx
801055b5:	89 10                	mov    %edx,(%eax)
    return 0;
801055b7:	31 c0                	xor    %eax,%eax
}
801055b9:	5b                   	pop    %ebx
801055ba:	5e                   	pop    %esi
801055bb:	5d                   	pop    %ebp
801055bc:	c3                   	ret    
801055bd:	8d 76 00             	lea    0x0(%esi),%esi
        return -1;
801055c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
801055c5:	eb f2                	jmp    801055b9 <argint+0x39>
801055c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ce:	66 90                	xchg   %ax,%ax

801055d0 <argptr>:

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int argptr(int n, char** pp, int size) {
801055d0:	f3 0f 1e fb          	endbr32 
801055d4:	55                   	push   %ebp
801055d5:	89 e5                	mov    %esp,%ebp
801055d7:	56                   	push   %esi
801055d8:	53                   	push   %ebx
801055d9:	83 ec 10             	sub    $0x10,%esp
801055dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
    int i;
    struct proc* curproc = myproc();
801055df:	e8 1c ef ff ff       	call   80104500 <myproc>

    if (argint(n, &i) < 0)
801055e4:	83 ec 08             	sub    $0x8,%esp
    struct proc* curproc = myproc();
801055e7:	89 c6                	mov    %eax,%esi
    if (argint(n, &i) < 0)
801055e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055ec:	50                   	push   %eax
801055ed:	ff 75 08             	pushl  0x8(%ebp)
801055f0:	e8 8b ff ff ff       	call   80105580 <argint>
        return -1;
    if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz)
801055f5:	83 c4 10             	add    $0x10,%esp
801055f8:	85 c0                	test   %eax,%eax
801055fa:	78 24                	js     80105620 <argptr+0x50>
801055fc:	85 db                	test   %ebx,%ebx
801055fe:	78 20                	js     80105620 <argptr+0x50>
80105600:	8b 16                	mov    (%esi),%edx
80105602:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105605:	39 c2                	cmp    %eax,%edx
80105607:	76 17                	jbe    80105620 <argptr+0x50>
80105609:	01 c3                	add    %eax,%ebx
8010560b:	39 da                	cmp    %ebx,%edx
8010560d:	72 11                	jb     80105620 <argptr+0x50>
        return -1;
    *pp = (char*)i;
8010560f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105612:	89 02                	mov    %eax,(%edx)
    return 0;
80105614:	31 c0                	xor    %eax,%eax
}
80105616:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105619:	5b                   	pop    %ebx
8010561a:	5e                   	pop    %esi
8010561b:	5d                   	pop    %ebp
8010561c:	c3                   	ret    
8010561d:	8d 76 00             	lea    0x0(%esi),%esi
        return -1;
80105620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105625:	eb ef                	jmp    80105616 <argptr+0x46>
80105627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010562e:	66 90                	xchg   %ax,%ax

80105630 <argstr>:

// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int argstr(int n, char** pp) {
80105630:	f3 0f 1e fb          	endbr32 
80105634:	55                   	push   %ebp
80105635:	89 e5                	mov    %esp,%ebp
80105637:	83 ec 20             	sub    $0x20,%esp
    int addr;
    if (argint(n, &addr) < 0)
8010563a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010563d:	50                   	push   %eax
8010563e:	ff 75 08             	pushl  0x8(%ebp)
80105641:	e8 3a ff ff ff       	call   80105580 <argint>
80105646:	83 c4 10             	add    $0x10,%esp
80105649:	85 c0                	test   %eax,%eax
8010564b:	78 13                	js     80105660 <argstr+0x30>
        return -1;
    return fetchstr(addr, pp);
8010564d:	83 ec 08             	sub    $0x8,%esp
80105650:	ff 75 0c             	pushl  0xc(%ebp)
80105653:	ff 75 f4             	pushl  -0xc(%ebp)
80105656:	e8 c5 fe ff ff       	call   80105520 <fetchstr>
8010565b:	83 c4 10             	add    $0x10,%esp
}
8010565e:	c9                   	leave  
8010565f:	c3                   	ret    
80105660:	c9                   	leave  
        return -1;
80105661:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105666:	c3                   	ret    
80105667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010566e:	66 90                	xchg   %ax,%ax

80105670 <syscall>:
    [SYS_nuncle] sys_nuncle,
    [SYS_ptime] sys_ptime,
    [SYS_fcopy] sys_fcopy,
};

void syscall(void) {
80105670:	f3 0f 1e fb          	endbr32 
80105674:	55                   	push   %ebp
80105675:	89 e5                	mov    %esp,%ebp
80105677:	53                   	push   %ebx
80105678:	83 ec 04             	sub    $0x4,%esp
    int num;
    struct proc* curproc = myproc();
8010567b:	e8 80 ee ff ff       	call   80104500 <myproc>
80105680:	89 c3                	mov    %eax,%ebx

    num = curproc->tf->eax;
80105682:	8b 40 18             	mov    0x18(%eax),%eax
80105685:	8b 40 1c             	mov    0x1c(%eax),%eax
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105688:	8d 50 ff             	lea    -0x1(%eax),%edx
8010568b:	83 fa 17             	cmp    $0x17,%edx
8010568e:	77 20                	ja     801056b0 <syscall+0x40>
80105690:	8b 14 85 00 85 10 80 	mov    -0x7fef7b00(,%eax,4),%edx
80105697:	85 d2                	test   %edx,%edx
80105699:	74 15                	je     801056b0 <syscall+0x40>
        curproc->tf->eax = syscalls[num]();
8010569b:	ff d2                	call   *%edx
8010569d:	89 c2                	mov    %eax,%edx
8010569f:	8b 43 18             	mov    0x18(%ebx),%eax
801056a2:	89 50 1c             	mov    %edx,0x1c(%eax)
    else {
        cprintf("%d %s: unknown sys call %d\n",
                curproc->pid, curproc->name, num);
        curproc->tf->eax = -1;
    }
}
801056a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056a8:	c9                   	leave  
801056a9:	c3                   	ret    
801056aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        cprintf("%d %s: unknown sys call %d\n",
801056b0:	50                   	push   %eax
                curproc->pid, curproc->name, num);
801056b1:	8d 43 6c             	lea    0x6c(%ebx),%eax
        cprintf("%d %s: unknown sys call %d\n",
801056b4:	50                   	push   %eax
801056b5:	ff 73 10             	pushl  0x10(%ebx)
801056b8:	68 dd 84 10 80       	push   $0x801084dd
801056bd:	e8 fe b0 ff ff       	call   801007c0 <cprintf>
        curproc->tf->eax = -1;
801056c2:	8b 43 18             	mov    0x18(%ebx),%eax
801056c5:	83 c4 10             	add    $0x10,%esp
801056c8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801056cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056d2:	c9                   	leave  
801056d3:	c3                   	ret    
801056d4:	66 90                	xchg   %ax,%ax
801056d6:	66 90                	xchg   %ax,%ax
801056d8:	66 90                	xchg   %ax,%ax
801056da:	66 90                	xchg   %ax,%ax
801056dc:	66 90                	xchg   %ax,%ax
801056de:	66 90                	xchg   %ax,%ax

801056e0 <create>:
    end_op();
    return -1;
}

static struct inode*
create(char* path, short type, short major, short minor) {
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	57                   	push   %edi
801056e4:	56                   	push   %esi
    struct inode *ip, *dp;
    char name[DIRSIZ];

    if ((dp = nameiparent(path, name)) == 0)
801056e5:	8d 7d da             	lea    -0x26(%ebp),%edi
create(char* path, short type, short major, short minor) {
801056e8:	53                   	push   %ebx
801056e9:	83 ec 34             	sub    $0x34,%esp
801056ec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801056ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
    if ((dp = nameiparent(path, name)) == 0)
801056f2:	57                   	push   %edi
801056f3:	50                   	push   %eax
create(char* path, short type, short major, short minor) {
801056f4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801056f7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
    if ((dp = nameiparent(path, name)) == 0)
801056fa:	e8 f1 d4 ff ff       	call   80102bf0 <nameiparent>
801056ff:	83 c4 10             	add    $0x10,%esp
80105702:	85 c0                	test   %eax,%eax
80105704:	0f 84 46 01 00 00    	je     80105850 <create+0x170>
        return 0;
    ilock(dp);
8010570a:	83 ec 0c             	sub    $0xc,%esp
8010570d:	89 c3                	mov    %eax,%ebx
8010570f:	50                   	push   %eax
80105710:	e8 eb cb ff ff       	call   80102300 <ilock>

    if ((ip = dirlookup(dp, name, 0)) != 0) {
80105715:	83 c4 0c             	add    $0xc,%esp
80105718:	6a 00                	push   $0x0
8010571a:	57                   	push   %edi
8010571b:	53                   	push   %ebx
8010571c:	e8 2f d1 ff ff       	call   80102850 <dirlookup>
80105721:	83 c4 10             	add    $0x10,%esp
80105724:	89 c6                	mov    %eax,%esi
80105726:	85 c0                	test   %eax,%eax
80105728:	74 56                	je     80105780 <create+0xa0>
        iunlockput(dp);
8010572a:	83 ec 0c             	sub    $0xc,%esp
8010572d:	53                   	push   %ebx
8010572e:	e8 6d ce ff ff       	call   801025a0 <iunlockput>
        ilock(ip);
80105733:	89 34 24             	mov    %esi,(%esp)
80105736:	e8 c5 cb ff ff       	call   80102300 <ilock>
        if (type == T_FILE && ip->type == T_FILE)
8010573b:	83 c4 10             	add    $0x10,%esp
8010573e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105743:	75 1b                	jne    80105760 <create+0x80>
80105745:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010574a:	75 14                	jne    80105760 <create+0x80>
        panic("create: dirlink");

    iunlockput(dp);

    return ip;
}
8010574c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010574f:	89 f0                	mov    %esi,%eax
80105751:	5b                   	pop    %ebx
80105752:	5e                   	pop    %esi
80105753:	5f                   	pop    %edi
80105754:	5d                   	pop    %ebp
80105755:	c3                   	ret    
80105756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010575d:	8d 76 00             	lea    0x0(%esi),%esi
        iunlockput(ip);
80105760:	83 ec 0c             	sub    $0xc,%esp
80105763:	56                   	push   %esi
        return 0;
80105764:	31 f6                	xor    %esi,%esi
        iunlockput(ip);
80105766:	e8 35 ce ff ff       	call   801025a0 <iunlockput>
        return 0;
8010576b:	83 c4 10             	add    $0x10,%esp
}
8010576e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105771:	89 f0                	mov    %esi,%eax
80105773:	5b                   	pop    %ebx
80105774:	5e                   	pop    %esi
80105775:	5f                   	pop    %edi
80105776:	5d                   	pop    %ebp
80105777:	c3                   	ret    
80105778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577f:	90                   	nop
    if ((ip = ialloc(dp->dev, type)) == 0)
80105780:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105784:	83 ec 08             	sub    $0x8,%esp
80105787:	50                   	push   %eax
80105788:	ff 33                	pushl  (%ebx)
8010578a:	e8 f1 c9 ff ff       	call   80102180 <ialloc>
8010578f:	83 c4 10             	add    $0x10,%esp
80105792:	89 c6                	mov    %eax,%esi
80105794:	85 c0                	test   %eax,%eax
80105796:	0f 84 cd 00 00 00    	je     80105869 <create+0x189>
    ilock(ip);
8010579c:	83 ec 0c             	sub    $0xc,%esp
8010579f:	50                   	push   %eax
801057a0:	e8 5b cb ff ff       	call   80102300 <ilock>
    ip->major = major;
801057a5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801057a9:	66 89 46 52          	mov    %ax,0x52(%esi)
    ip->minor = minor;
801057ad:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801057b1:	66 89 46 54          	mov    %ax,0x54(%esi)
    ip->nlink = 1;
801057b5:	b8 01 00 00 00       	mov    $0x1,%eax
801057ba:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(ip);
801057be:	89 34 24             	mov    %esi,(%esp)
801057c1:	e8 7a ca ff ff       	call   80102240 <iupdate>
    if (type == T_DIR) { // Create . and .. entries.
801057c6:	83 c4 10             	add    $0x10,%esp
801057c9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801057ce:	74 30                	je     80105800 <create+0x120>
    if (dirlink(dp, name, ip->inum) < 0)
801057d0:	83 ec 04             	sub    $0x4,%esp
801057d3:	ff 76 04             	pushl  0x4(%esi)
801057d6:	57                   	push   %edi
801057d7:	53                   	push   %ebx
801057d8:	e8 33 d3 ff ff       	call   80102b10 <dirlink>
801057dd:	83 c4 10             	add    $0x10,%esp
801057e0:	85 c0                	test   %eax,%eax
801057e2:	78 78                	js     8010585c <create+0x17c>
    iunlockput(dp);
801057e4:	83 ec 0c             	sub    $0xc,%esp
801057e7:	53                   	push   %ebx
801057e8:	e8 b3 cd ff ff       	call   801025a0 <iunlockput>
    return ip;
801057ed:	83 c4 10             	add    $0x10,%esp
}
801057f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057f3:	89 f0                	mov    %esi,%eax
801057f5:	5b                   	pop    %ebx
801057f6:	5e                   	pop    %esi
801057f7:	5f                   	pop    %edi
801057f8:	5d                   	pop    %ebp
801057f9:	c3                   	ret    
801057fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        iupdate(dp);
80105800:	83 ec 0c             	sub    $0xc,%esp
        dp->nlink++;     // for ".."
80105803:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
        iupdate(dp);
80105808:	53                   	push   %ebx
80105809:	e8 32 ca ff ff       	call   80102240 <iupdate>
        if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010580e:	83 c4 0c             	add    $0xc,%esp
80105811:	ff 76 04             	pushl  0x4(%esi)
80105814:	68 80 85 10 80       	push   $0x80108580
80105819:	56                   	push   %esi
8010581a:	e8 f1 d2 ff ff       	call   80102b10 <dirlink>
8010581f:	83 c4 10             	add    $0x10,%esp
80105822:	85 c0                	test   %eax,%eax
80105824:	78 18                	js     8010583e <create+0x15e>
80105826:	83 ec 04             	sub    $0x4,%esp
80105829:	ff 73 04             	pushl  0x4(%ebx)
8010582c:	68 7f 85 10 80       	push   $0x8010857f
80105831:	56                   	push   %esi
80105832:	e8 d9 d2 ff ff       	call   80102b10 <dirlink>
80105837:	83 c4 10             	add    $0x10,%esp
8010583a:	85 c0                	test   %eax,%eax
8010583c:	79 92                	jns    801057d0 <create+0xf0>
            panic("create dots");
8010583e:	83 ec 0c             	sub    $0xc,%esp
80105841:	68 73 85 10 80       	push   $0x80108573
80105846:	e8 45 ab ff ff       	call   80100390 <panic>
8010584b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010584f:	90                   	nop
}
80105850:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
80105853:	31 f6                	xor    %esi,%esi
}
80105855:	5b                   	pop    %ebx
80105856:	89 f0                	mov    %esi,%eax
80105858:	5e                   	pop    %esi
80105859:	5f                   	pop    %edi
8010585a:	5d                   	pop    %ebp
8010585b:	c3                   	ret    
        panic("create: dirlink");
8010585c:	83 ec 0c             	sub    $0xc,%esp
8010585f:	68 82 85 10 80       	push   $0x80108582
80105864:	e8 27 ab ff ff       	call   80100390 <panic>
        panic("create: ialloc");
80105869:	83 ec 0c             	sub    $0xc,%esp
8010586c:	68 64 85 10 80       	push   $0x80108564
80105871:	e8 1a ab ff ff       	call   80100390 <panic>
80105876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010587d:	8d 76 00             	lea    0x0(%esi),%esi

80105880 <argfd.constprop.0>:
argfd(int n, int* pfd, struct file** pf) {
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	56                   	push   %esi
80105884:	89 d6                	mov    %edx,%esi
80105886:	53                   	push   %ebx
80105887:	89 c3                	mov    %eax,%ebx
    if (argint(n, &fd) < 0)
80105889:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int* pfd, struct file** pf) {
8010588c:	83 ec 18             	sub    $0x18,%esp
    if (argint(n, &fd) < 0)
8010588f:	50                   	push   %eax
80105890:	6a 00                	push   $0x0
80105892:	e8 e9 fc ff ff       	call   80105580 <argint>
80105897:	83 c4 10             	add    $0x10,%esp
8010589a:	85 c0                	test   %eax,%eax
8010589c:	78 2a                	js     801058c8 <argfd.constprop.0+0x48>
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010589e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801058a2:	77 24                	ja     801058c8 <argfd.constprop.0+0x48>
801058a4:	e8 57 ec ff ff       	call   80104500 <myproc>
801058a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058ac:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801058b0:	85 c0                	test   %eax,%eax
801058b2:	74 14                	je     801058c8 <argfd.constprop.0+0x48>
    if (pfd)
801058b4:	85 db                	test   %ebx,%ebx
801058b6:	74 02                	je     801058ba <argfd.constprop.0+0x3a>
        *pfd = fd;
801058b8:	89 13                	mov    %edx,(%ebx)
        *pf = f;
801058ba:	89 06                	mov    %eax,(%esi)
    return 0;
801058bc:	31 c0                	xor    %eax,%eax
}
801058be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058c1:	5b                   	pop    %ebx
801058c2:	5e                   	pop    %esi
801058c3:	5d                   	pop    %ebp
801058c4:	c3                   	ret    
801058c5:	8d 76 00             	lea    0x0(%esi),%esi
        return -1;
801058c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058cd:	eb ef                	jmp    801058be <argfd.constprop.0+0x3e>
801058cf:	90                   	nop

801058d0 <sys_dup>:
int sys_dup(void) {
801058d0:	f3 0f 1e fb          	endbr32 
801058d4:	55                   	push   %ebp
    if (argfd(0, 0, &f) < 0)
801058d5:	31 c0                	xor    %eax,%eax
int sys_dup(void) {
801058d7:	89 e5                	mov    %esp,%ebp
801058d9:	56                   	push   %esi
801058da:	53                   	push   %ebx
    if (argfd(0, 0, &f) < 0)
801058db:	8d 55 f4             	lea    -0xc(%ebp),%edx
int sys_dup(void) {
801058de:	83 ec 10             	sub    $0x10,%esp
    if (argfd(0, 0, &f) < 0)
801058e1:	e8 9a ff ff ff       	call   80105880 <argfd.constprop.0>
801058e6:	85 c0                	test   %eax,%eax
801058e8:	78 1e                	js     80105908 <sys_dup+0x38>
    if ((fd = fdalloc(f)) < 0)
801058ea:	8b 75 f4             	mov    -0xc(%ebp),%esi
    for (fd = 0; fd < NOFILE; fd++) {
801058ed:	31 db                	xor    %ebx,%ebx
    struct proc* curproc = myproc();
801058ef:	e8 0c ec ff ff       	call   80104500 <myproc>
    for (fd = 0; fd < NOFILE; fd++) {
801058f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (curproc->ofile[fd] == 0) {
801058f8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801058fc:	85 d2                	test   %edx,%edx
801058fe:	74 20                	je     80105920 <sys_dup+0x50>
    for (fd = 0; fd < NOFILE; fd++) {
80105900:	83 c3 01             	add    $0x1,%ebx
80105903:	83 fb 10             	cmp    $0x10,%ebx
80105906:	75 f0                	jne    801058f8 <sys_dup+0x28>
}
80105908:	8d 65 f8             	lea    -0x8(%ebp),%esp
        return -1;
8010590b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105910:	89 d8                	mov    %ebx,%eax
80105912:	5b                   	pop    %ebx
80105913:	5e                   	pop    %esi
80105914:	5d                   	pop    %ebp
80105915:	c3                   	ret    
80105916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591d:	8d 76 00             	lea    0x0(%esi),%esi
            curproc->ofile[fd] = f;
80105920:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    filedup(f);
80105924:	83 ec 0c             	sub    $0xc,%esp
80105927:	ff 75 f4             	pushl  -0xc(%ebp)
8010592a:	e8 31 c0 ff ff       	call   80101960 <filedup>
    return fd;
8010592f:	83 c4 10             	add    $0x10,%esp
}
80105932:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105935:	89 d8                	mov    %ebx,%eax
80105937:	5b                   	pop    %ebx
80105938:	5e                   	pop    %esi
80105939:	5d                   	pop    %ebp
8010593a:	c3                   	ret    
8010593b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010593f:	90                   	nop

80105940 <sys_read>:
int sys_read(void) {
80105940:	f3 0f 1e fb          	endbr32 
80105944:	55                   	push   %ebp
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105945:	31 c0                	xor    %eax,%eax
int sys_read(void) {
80105947:	89 e5                	mov    %esp,%ebp
80105949:	83 ec 18             	sub    $0x18,%esp
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010594c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010594f:	e8 2c ff ff ff       	call   80105880 <argfd.constprop.0>
80105954:	85 c0                	test   %eax,%eax
80105956:	78 48                	js     801059a0 <sys_read+0x60>
80105958:	83 ec 08             	sub    $0x8,%esp
8010595b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010595e:	50                   	push   %eax
8010595f:	6a 02                	push   $0x2
80105961:	e8 1a fc ff ff       	call   80105580 <argint>
80105966:	83 c4 10             	add    $0x10,%esp
80105969:	85 c0                	test   %eax,%eax
8010596b:	78 33                	js     801059a0 <sys_read+0x60>
8010596d:	83 ec 04             	sub    $0x4,%esp
80105970:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105973:	ff 75 f0             	pushl  -0x10(%ebp)
80105976:	50                   	push   %eax
80105977:	6a 01                	push   $0x1
80105979:	e8 52 fc ff ff       	call   801055d0 <argptr>
8010597e:	83 c4 10             	add    $0x10,%esp
80105981:	85 c0                	test   %eax,%eax
80105983:	78 1b                	js     801059a0 <sys_read+0x60>
    return fileread(f, p, n);
80105985:	83 ec 04             	sub    $0x4,%esp
80105988:	ff 75 f0             	pushl  -0x10(%ebp)
8010598b:	ff 75 f4             	pushl  -0xc(%ebp)
8010598e:	ff 75 ec             	pushl  -0x14(%ebp)
80105991:	e8 4a c1 ff ff       	call   80101ae0 <fileread>
80105996:	83 c4 10             	add    $0x10,%esp
}
80105999:	c9                   	leave  
8010599a:	c3                   	ret    
8010599b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010599f:	90                   	nop
801059a0:	c9                   	leave  
        return -1;
801059a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059a6:	c3                   	ret    
801059a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ae:	66 90                	xchg   %ax,%ax

801059b0 <sys_write>:
int sys_write(void) {
801059b0:	f3 0f 1e fb          	endbr32 
801059b4:	55                   	push   %ebp
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801059b5:	31 c0                	xor    %eax,%eax
int sys_write(void) {
801059b7:	89 e5                	mov    %esp,%ebp
801059b9:	83 ec 18             	sub    $0x18,%esp
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801059bc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801059bf:	e8 bc fe ff ff       	call   80105880 <argfd.constprop.0>
801059c4:	85 c0                	test   %eax,%eax
801059c6:	78 48                	js     80105a10 <sys_write+0x60>
801059c8:	83 ec 08             	sub    $0x8,%esp
801059cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059ce:	50                   	push   %eax
801059cf:	6a 02                	push   $0x2
801059d1:	e8 aa fb ff ff       	call   80105580 <argint>
801059d6:	83 c4 10             	add    $0x10,%esp
801059d9:	85 c0                	test   %eax,%eax
801059db:	78 33                	js     80105a10 <sys_write+0x60>
801059dd:	83 ec 04             	sub    $0x4,%esp
801059e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059e3:	ff 75 f0             	pushl  -0x10(%ebp)
801059e6:	50                   	push   %eax
801059e7:	6a 01                	push   $0x1
801059e9:	e8 e2 fb ff ff       	call   801055d0 <argptr>
801059ee:	83 c4 10             	add    $0x10,%esp
801059f1:	85 c0                	test   %eax,%eax
801059f3:	78 1b                	js     80105a10 <sys_write+0x60>
    return filewrite(f, p, n);
801059f5:	83 ec 04             	sub    $0x4,%esp
801059f8:	ff 75 f0             	pushl  -0x10(%ebp)
801059fb:	ff 75 f4             	pushl  -0xc(%ebp)
801059fe:	ff 75 ec             	pushl  -0x14(%ebp)
80105a01:	e8 7a c1 ff ff       	call   80101b80 <filewrite>
80105a06:	83 c4 10             	add    $0x10,%esp
}
80105a09:	c9                   	leave  
80105a0a:	c3                   	ret    
80105a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a0f:	90                   	nop
80105a10:	c9                   	leave  
        return -1;
80105a11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a16:	c3                   	ret    
80105a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1e:	66 90                	xchg   %ax,%ax

80105a20 <sys_close>:
int sys_close(void) {
80105a20:	f3 0f 1e fb          	endbr32 
80105a24:	55                   	push   %ebp
80105a25:	89 e5                	mov    %esp,%ebp
80105a27:	83 ec 18             	sub    $0x18,%esp
    if (argfd(0, &fd, &f) < 0)
80105a2a:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105a2d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a30:	e8 4b fe ff ff       	call   80105880 <argfd.constprop.0>
80105a35:	85 c0                	test   %eax,%eax
80105a37:	78 27                	js     80105a60 <sys_close+0x40>
    myproc()->ofile[fd] = 0;
80105a39:	e8 c2 ea ff ff       	call   80104500 <myproc>
80105a3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
    fileclose(f);
80105a41:	83 ec 0c             	sub    $0xc,%esp
    myproc()->ofile[fd] = 0;
80105a44:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105a4b:	00 
    fileclose(f);
80105a4c:	ff 75 f4             	pushl  -0xc(%ebp)
80105a4f:	e8 5c bf ff ff       	call   801019b0 <fileclose>
    return 0;
80105a54:	83 c4 10             	add    $0x10,%esp
80105a57:	31 c0                	xor    %eax,%eax
}
80105a59:	c9                   	leave  
80105a5a:	c3                   	ret    
80105a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a5f:	90                   	nop
80105a60:	c9                   	leave  
        return -1;
80105a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a66:	c3                   	ret    
80105a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a6e:	66 90                	xchg   %ax,%ax

80105a70 <sys_fstat>:
int sys_fstat(void) {
80105a70:	f3 0f 1e fb          	endbr32 
80105a74:	55                   	push   %ebp
    if (argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105a75:	31 c0                	xor    %eax,%eax
int sys_fstat(void) {
80105a77:	89 e5                	mov    %esp,%ebp
80105a79:	83 ec 18             	sub    $0x18,%esp
    if (argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105a7c:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105a7f:	e8 fc fd ff ff       	call   80105880 <argfd.constprop.0>
80105a84:	85 c0                	test   %eax,%eax
80105a86:	78 30                	js     80105ab8 <sys_fstat+0x48>
80105a88:	83 ec 04             	sub    $0x4,%esp
80105a8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a8e:	6a 14                	push   $0x14
80105a90:	50                   	push   %eax
80105a91:	6a 01                	push   $0x1
80105a93:	e8 38 fb ff ff       	call   801055d0 <argptr>
80105a98:	83 c4 10             	add    $0x10,%esp
80105a9b:	85 c0                	test   %eax,%eax
80105a9d:	78 19                	js     80105ab8 <sys_fstat+0x48>
    return filestat(f, st);
80105a9f:	83 ec 08             	sub    $0x8,%esp
80105aa2:	ff 75 f4             	pushl  -0xc(%ebp)
80105aa5:	ff 75 f0             	pushl  -0x10(%ebp)
80105aa8:	e8 e3 bf ff ff       	call   80101a90 <filestat>
80105aad:	83 c4 10             	add    $0x10,%esp
}
80105ab0:	c9                   	leave  
80105ab1:	c3                   	ret    
80105ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105ab8:	c9                   	leave  
        return -1;
80105ab9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105abe:	c3                   	ret    
80105abf:	90                   	nop

80105ac0 <sys_link>:
int sys_link(void) {
80105ac0:	f3 0f 1e fb          	endbr32 
80105ac4:	55                   	push   %ebp
80105ac5:	89 e5                	mov    %esp,%ebp
80105ac7:	57                   	push   %edi
80105ac8:	56                   	push   %esi
    if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105ac9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
int sys_link(void) {
80105acc:	53                   	push   %ebx
80105acd:	83 ec 34             	sub    $0x34,%esp
    if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105ad0:	50                   	push   %eax
80105ad1:	6a 00                	push   $0x0
80105ad3:	e8 58 fb ff ff       	call   80105630 <argstr>
80105ad8:	83 c4 10             	add    $0x10,%esp
80105adb:	85 c0                	test   %eax,%eax
80105add:	0f 88 ff 00 00 00    	js     80105be2 <sys_link+0x122>
80105ae3:	83 ec 08             	sub    $0x8,%esp
80105ae6:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105ae9:	50                   	push   %eax
80105aea:	6a 01                	push   $0x1
80105aec:	e8 3f fb ff ff       	call   80105630 <argstr>
80105af1:	83 c4 10             	add    $0x10,%esp
80105af4:	85 c0                	test   %eax,%eax
80105af6:	0f 88 e6 00 00 00    	js     80105be2 <sys_link+0x122>
    begin_op();
80105afc:	e8 cf dd ff ff       	call   801038d0 <begin_op>
    if ((ip = namei(old)) == 0) {
80105b01:	83 ec 0c             	sub    $0xc,%esp
80105b04:	ff 75 d4             	pushl  -0x2c(%ebp)
80105b07:	e8 c4 d0 ff ff       	call   80102bd0 <namei>
80105b0c:	83 c4 10             	add    $0x10,%esp
80105b0f:	89 c3                	mov    %eax,%ebx
80105b11:	85 c0                	test   %eax,%eax
80105b13:	0f 84 e8 00 00 00    	je     80105c01 <sys_link+0x141>
    ilock(ip);
80105b19:	83 ec 0c             	sub    $0xc,%esp
80105b1c:	50                   	push   %eax
80105b1d:	e8 de c7 ff ff       	call   80102300 <ilock>
    if (ip->type == T_DIR) {
80105b22:	83 c4 10             	add    $0x10,%esp
80105b25:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b2a:	0f 84 b9 00 00 00    	je     80105be9 <sys_link+0x129>
    iupdate(ip);
80105b30:	83 ec 0c             	sub    $0xc,%esp
    ip->nlink++;
80105b33:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    if ((dp = nameiparent(new, name)) == 0)
80105b38:	8d 7d da             	lea    -0x26(%ebp),%edi
    iupdate(ip);
80105b3b:	53                   	push   %ebx
80105b3c:	e8 ff c6 ff ff       	call   80102240 <iupdate>
    iunlock(ip);
80105b41:	89 1c 24             	mov    %ebx,(%esp)
80105b44:	e8 97 c8 ff ff       	call   801023e0 <iunlock>
    if ((dp = nameiparent(new, name)) == 0)
80105b49:	58                   	pop    %eax
80105b4a:	5a                   	pop    %edx
80105b4b:	57                   	push   %edi
80105b4c:	ff 75 d0             	pushl  -0x30(%ebp)
80105b4f:	e8 9c d0 ff ff       	call   80102bf0 <nameiparent>
80105b54:	83 c4 10             	add    $0x10,%esp
80105b57:	89 c6                	mov    %eax,%esi
80105b59:	85 c0                	test   %eax,%eax
80105b5b:	74 5f                	je     80105bbc <sys_link+0xfc>
    ilock(dp);
80105b5d:	83 ec 0c             	sub    $0xc,%esp
80105b60:	50                   	push   %eax
80105b61:	e8 9a c7 ff ff       	call   80102300 <ilock>
    if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
80105b66:	8b 03                	mov    (%ebx),%eax
80105b68:	83 c4 10             	add    $0x10,%esp
80105b6b:	39 06                	cmp    %eax,(%esi)
80105b6d:	75 41                	jne    80105bb0 <sys_link+0xf0>
80105b6f:	83 ec 04             	sub    $0x4,%esp
80105b72:	ff 73 04             	pushl  0x4(%ebx)
80105b75:	57                   	push   %edi
80105b76:	56                   	push   %esi
80105b77:	e8 94 cf ff ff       	call   80102b10 <dirlink>
80105b7c:	83 c4 10             	add    $0x10,%esp
80105b7f:	85 c0                	test   %eax,%eax
80105b81:	78 2d                	js     80105bb0 <sys_link+0xf0>
    iunlockput(dp);
80105b83:	83 ec 0c             	sub    $0xc,%esp
80105b86:	56                   	push   %esi
80105b87:	e8 14 ca ff ff       	call   801025a0 <iunlockput>
    iput(ip);
80105b8c:	89 1c 24             	mov    %ebx,(%esp)
80105b8f:	e8 9c c8 ff ff       	call   80102430 <iput>
    end_op();
80105b94:	e8 a7 dd ff ff       	call   80103940 <end_op>
    return 0;
80105b99:	83 c4 10             	add    $0x10,%esp
80105b9c:	31 c0                	xor    %eax,%eax
}
80105b9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ba1:	5b                   	pop    %ebx
80105ba2:	5e                   	pop    %esi
80105ba3:	5f                   	pop    %edi
80105ba4:	5d                   	pop    %ebp
80105ba5:	c3                   	ret    
80105ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bad:	8d 76 00             	lea    0x0(%esi),%esi
        iunlockput(dp);
80105bb0:	83 ec 0c             	sub    $0xc,%esp
80105bb3:	56                   	push   %esi
80105bb4:	e8 e7 c9 ff ff       	call   801025a0 <iunlockput>
        goto bad;
80105bb9:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105bbc:	83 ec 0c             	sub    $0xc,%esp
80105bbf:	53                   	push   %ebx
80105bc0:	e8 3b c7 ff ff       	call   80102300 <ilock>
    ip->nlink--;
80105bc5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
    iupdate(ip);
80105bca:	89 1c 24             	mov    %ebx,(%esp)
80105bcd:	e8 6e c6 ff ff       	call   80102240 <iupdate>
    iunlockput(ip);
80105bd2:	89 1c 24             	mov    %ebx,(%esp)
80105bd5:	e8 c6 c9 ff ff       	call   801025a0 <iunlockput>
    end_op();
80105bda:	e8 61 dd ff ff       	call   80103940 <end_op>
    return -1;
80105bdf:	83 c4 10             	add    $0x10,%esp
80105be2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be7:	eb b5                	jmp    80105b9e <sys_link+0xde>
        iunlockput(ip);
80105be9:	83 ec 0c             	sub    $0xc,%esp
80105bec:	53                   	push   %ebx
80105bed:	e8 ae c9 ff ff       	call   801025a0 <iunlockput>
        end_op();
80105bf2:	e8 49 dd ff ff       	call   80103940 <end_op>
        return -1;
80105bf7:	83 c4 10             	add    $0x10,%esp
80105bfa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bff:	eb 9d                	jmp    80105b9e <sys_link+0xde>
        end_op();
80105c01:	e8 3a dd ff ff       	call   80103940 <end_op>
        return -1;
80105c06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c0b:	eb 91                	jmp    80105b9e <sys_link+0xde>
80105c0d:	8d 76 00             	lea    0x0(%esi),%esi

80105c10 <sys_unlink>:
int sys_unlink(void) {
80105c10:	f3 0f 1e fb          	endbr32 
80105c14:	55                   	push   %ebp
80105c15:	89 e5                	mov    %esp,%ebp
80105c17:	57                   	push   %edi
80105c18:	56                   	push   %esi
    if (argstr(0, &path) < 0)
80105c19:	8d 45 c0             	lea    -0x40(%ebp),%eax
int sys_unlink(void) {
80105c1c:	53                   	push   %ebx
80105c1d:	83 ec 54             	sub    $0x54,%esp
    if (argstr(0, &path) < 0)
80105c20:	50                   	push   %eax
80105c21:	6a 00                	push   $0x0
80105c23:	e8 08 fa ff ff       	call   80105630 <argstr>
80105c28:	83 c4 10             	add    $0x10,%esp
80105c2b:	85 c0                	test   %eax,%eax
80105c2d:	0f 88 7d 01 00 00    	js     80105db0 <sys_unlink+0x1a0>
    begin_op();
80105c33:	e8 98 dc ff ff       	call   801038d0 <begin_op>
    if ((dp = nameiparent(path, name)) == 0) {
80105c38:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105c3b:	83 ec 08             	sub    $0x8,%esp
80105c3e:	53                   	push   %ebx
80105c3f:	ff 75 c0             	pushl  -0x40(%ebp)
80105c42:	e8 a9 cf ff ff       	call   80102bf0 <nameiparent>
80105c47:	83 c4 10             	add    $0x10,%esp
80105c4a:	89 c6                	mov    %eax,%esi
80105c4c:	85 c0                	test   %eax,%eax
80105c4e:	0f 84 66 01 00 00    	je     80105dba <sys_unlink+0x1aa>
    ilock(dp);
80105c54:	83 ec 0c             	sub    $0xc,%esp
80105c57:	50                   	push   %eax
80105c58:	e8 a3 c6 ff ff       	call   80102300 <ilock>
    if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105c5d:	58                   	pop    %eax
80105c5e:	5a                   	pop    %edx
80105c5f:	68 80 85 10 80       	push   $0x80108580
80105c64:	53                   	push   %ebx
80105c65:	e8 c6 cb ff ff       	call   80102830 <namecmp>
80105c6a:	83 c4 10             	add    $0x10,%esp
80105c6d:	85 c0                	test   %eax,%eax
80105c6f:	0f 84 03 01 00 00    	je     80105d78 <sys_unlink+0x168>
80105c75:	83 ec 08             	sub    $0x8,%esp
80105c78:	68 7f 85 10 80       	push   $0x8010857f
80105c7d:	53                   	push   %ebx
80105c7e:	e8 ad cb ff ff       	call   80102830 <namecmp>
80105c83:	83 c4 10             	add    $0x10,%esp
80105c86:	85 c0                	test   %eax,%eax
80105c88:	0f 84 ea 00 00 00    	je     80105d78 <sys_unlink+0x168>
    if ((ip = dirlookup(dp, name, &off)) == 0)
80105c8e:	83 ec 04             	sub    $0x4,%esp
80105c91:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105c94:	50                   	push   %eax
80105c95:	53                   	push   %ebx
80105c96:	56                   	push   %esi
80105c97:	e8 b4 cb ff ff       	call   80102850 <dirlookup>
80105c9c:	83 c4 10             	add    $0x10,%esp
80105c9f:	89 c3                	mov    %eax,%ebx
80105ca1:	85 c0                	test   %eax,%eax
80105ca3:	0f 84 cf 00 00 00    	je     80105d78 <sys_unlink+0x168>
    ilock(ip);
80105ca9:	83 ec 0c             	sub    $0xc,%esp
80105cac:	50                   	push   %eax
80105cad:	e8 4e c6 ff ff       	call   80102300 <ilock>
    if (ip->nlink < 1)
80105cb2:	83 c4 10             	add    $0x10,%esp
80105cb5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105cba:	0f 8e 23 01 00 00    	jle    80105de3 <sys_unlink+0x1d3>
    if (ip->type == T_DIR && !isdirempty(ip)) {
80105cc0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105cc5:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105cc8:	74 66                	je     80105d30 <sys_unlink+0x120>
    memset(&de, 0, sizeof(de));
80105cca:	83 ec 04             	sub    $0x4,%esp
80105ccd:	6a 10                	push   $0x10
80105ccf:	6a 00                	push   $0x0
80105cd1:	57                   	push   %edi
80105cd2:	e8 c9 f5 ff ff       	call   801052a0 <memset>
    if (writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105cd7:	6a 10                	push   $0x10
80105cd9:	ff 75 c4             	pushl  -0x3c(%ebp)
80105cdc:	57                   	push   %edi
80105cdd:	56                   	push   %esi
80105cde:	e8 1d ca ff ff       	call   80102700 <writei>
80105ce3:	83 c4 20             	add    $0x20,%esp
80105ce6:	83 f8 10             	cmp    $0x10,%eax
80105ce9:	0f 85 e7 00 00 00    	jne    80105dd6 <sys_unlink+0x1c6>
    if (ip->type == T_DIR) {
80105cef:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105cf4:	0f 84 96 00 00 00    	je     80105d90 <sys_unlink+0x180>
    iunlockput(dp);
80105cfa:	83 ec 0c             	sub    $0xc,%esp
80105cfd:	56                   	push   %esi
80105cfe:	e8 9d c8 ff ff       	call   801025a0 <iunlockput>
    ip->nlink--;
80105d03:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
    iupdate(ip);
80105d08:	89 1c 24             	mov    %ebx,(%esp)
80105d0b:	e8 30 c5 ff ff       	call   80102240 <iupdate>
    iunlockput(ip);
80105d10:	89 1c 24             	mov    %ebx,(%esp)
80105d13:	e8 88 c8 ff ff       	call   801025a0 <iunlockput>
    end_op();
80105d18:	e8 23 dc ff ff       	call   80103940 <end_op>
    return 0;
80105d1d:	83 c4 10             	add    $0x10,%esp
80105d20:	31 c0                	xor    %eax,%eax
}
80105d22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d25:	5b                   	pop    %ebx
80105d26:	5e                   	pop    %esi
80105d27:	5f                   	pop    %edi
80105d28:	5d                   	pop    %ebp
80105d29:	c3                   	ret    
80105d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
80105d30:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105d34:	76 94                	jbe    80105cca <sys_unlink+0xba>
80105d36:	ba 20 00 00 00       	mov    $0x20,%edx
80105d3b:	eb 0b                	jmp    80105d48 <sys_unlink+0x138>
80105d3d:	8d 76 00             	lea    0x0(%esi),%esi
80105d40:	83 c2 10             	add    $0x10,%edx
80105d43:	39 53 58             	cmp    %edx,0x58(%ebx)
80105d46:	76 82                	jbe    80105cca <sys_unlink+0xba>
        if (readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d48:	6a 10                	push   $0x10
80105d4a:	52                   	push   %edx
80105d4b:	57                   	push   %edi
80105d4c:	53                   	push   %ebx
80105d4d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105d50:	e8 ab c8 ff ff       	call   80102600 <readi>
80105d55:	83 c4 10             	add    $0x10,%esp
80105d58:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80105d5b:	83 f8 10             	cmp    $0x10,%eax
80105d5e:	75 69                	jne    80105dc9 <sys_unlink+0x1b9>
        if (de.inum != 0)
80105d60:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105d65:	74 d9                	je     80105d40 <sys_unlink+0x130>
        iunlockput(ip);
80105d67:	83 ec 0c             	sub    $0xc,%esp
80105d6a:	53                   	push   %ebx
80105d6b:	e8 30 c8 ff ff       	call   801025a0 <iunlockput>
        goto bad;
80105d70:	83 c4 10             	add    $0x10,%esp
80105d73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d77:	90                   	nop
    iunlockput(dp);
80105d78:	83 ec 0c             	sub    $0xc,%esp
80105d7b:	56                   	push   %esi
80105d7c:	e8 1f c8 ff ff       	call   801025a0 <iunlockput>
    end_op();
80105d81:	e8 ba db ff ff       	call   80103940 <end_op>
    return -1;
80105d86:	83 c4 10             	add    $0x10,%esp
80105d89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d8e:	eb 92                	jmp    80105d22 <sys_unlink+0x112>
        iupdate(dp);
80105d90:	83 ec 0c             	sub    $0xc,%esp
        dp->nlink--;
80105d93:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
        iupdate(dp);
80105d98:	56                   	push   %esi
80105d99:	e8 a2 c4 ff ff       	call   80102240 <iupdate>
80105d9e:	83 c4 10             	add    $0x10,%esp
80105da1:	e9 54 ff ff ff       	jmp    80105cfa <sys_unlink+0xea>
80105da6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dad:	8d 76 00             	lea    0x0(%esi),%esi
        return -1;
80105db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105db5:	e9 68 ff ff ff       	jmp    80105d22 <sys_unlink+0x112>
        end_op();
80105dba:	e8 81 db ff ff       	call   80103940 <end_op>
        return -1;
80105dbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dc4:	e9 59 ff ff ff       	jmp    80105d22 <sys_unlink+0x112>
            panic("isdirempty: readi");
80105dc9:	83 ec 0c             	sub    $0xc,%esp
80105dcc:	68 a4 85 10 80       	push   $0x801085a4
80105dd1:	e8 ba a5 ff ff       	call   80100390 <panic>
        panic("unlink: writei");
80105dd6:	83 ec 0c             	sub    $0xc,%esp
80105dd9:	68 b6 85 10 80       	push   $0x801085b6
80105dde:	e8 ad a5 ff ff       	call   80100390 <panic>
        panic("unlink: nlink < 1");
80105de3:	83 ec 0c             	sub    $0xc,%esp
80105de6:	68 92 85 10 80       	push   $0x80108592
80105deb:	e8 a0 a5 ff ff       	call   80100390 <panic>

80105df0 <sys_open>:

int sys_open(void) {
80105df0:	f3 0f 1e fb          	endbr32 
80105df4:	55                   	push   %ebp
80105df5:	89 e5                	mov    %esp,%ebp
80105df7:	57                   	push   %edi
80105df8:	56                   	push   %esi
    char* path;
    int fd, omode;
    struct file* f;
    struct inode* ip;

    if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105df9:	8d 45 e0             	lea    -0x20(%ebp),%eax
int sys_open(void) {
80105dfc:	53                   	push   %ebx
80105dfd:	83 ec 24             	sub    $0x24,%esp
    if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105e00:	50                   	push   %eax
80105e01:	6a 00                	push   $0x0
80105e03:	e8 28 f8 ff ff       	call   80105630 <argstr>
80105e08:	83 c4 10             	add    $0x10,%esp
80105e0b:	85 c0                	test   %eax,%eax
80105e0d:	0f 88 8a 00 00 00    	js     80105e9d <sys_open+0xad>
80105e13:	83 ec 08             	sub    $0x8,%esp
80105e16:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e19:	50                   	push   %eax
80105e1a:	6a 01                	push   $0x1
80105e1c:	e8 5f f7 ff ff       	call   80105580 <argint>
80105e21:	83 c4 10             	add    $0x10,%esp
80105e24:	85 c0                	test   %eax,%eax
80105e26:	78 75                	js     80105e9d <sys_open+0xad>
        return -1;

    begin_op();
80105e28:	e8 a3 da ff ff       	call   801038d0 <begin_op>

    if (omode & O_CREATE) {
80105e2d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105e31:	75 75                	jne    80105ea8 <sys_open+0xb8>
            end_op();
            return -1;
        }
    }
    else {
        if ((ip = namei(path)) == 0) {
80105e33:	83 ec 0c             	sub    $0xc,%esp
80105e36:	ff 75 e0             	pushl  -0x20(%ebp)
80105e39:	e8 92 cd ff ff       	call   80102bd0 <namei>
80105e3e:	83 c4 10             	add    $0x10,%esp
80105e41:	89 c6                	mov    %eax,%esi
80105e43:	85 c0                	test   %eax,%eax
80105e45:	74 7e                	je     80105ec5 <sys_open+0xd5>
            end_op();
            return -1;
        }
        ilock(ip);
80105e47:	83 ec 0c             	sub    $0xc,%esp
80105e4a:	50                   	push   %eax
80105e4b:	e8 b0 c4 ff ff       	call   80102300 <ilock>
        if (ip->type == T_DIR && omode != O_RDONLY) {
80105e50:	83 c4 10             	add    $0x10,%esp
80105e53:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105e58:	0f 84 c2 00 00 00    	je     80105f20 <sys_open+0x130>
            end_op();
            return -1;
        }
    }

    if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
80105e5e:	e8 8d ba ff ff       	call   801018f0 <filealloc>
80105e63:	89 c7                	mov    %eax,%edi
80105e65:	85 c0                	test   %eax,%eax
80105e67:	74 23                	je     80105e8c <sys_open+0x9c>
    struct proc* curproc = myproc();
80105e69:	e8 92 e6 ff ff       	call   80104500 <myproc>
    for (fd = 0; fd < NOFILE; fd++) {
80105e6e:	31 db                	xor    %ebx,%ebx
        if (curproc->ofile[fd] == 0) {
80105e70:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105e74:	85 d2                	test   %edx,%edx
80105e76:	74 60                	je     80105ed8 <sys_open+0xe8>
    for (fd = 0; fd < NOFILE; fd++) {
80105e78:	83 c3 01             	add    $0x1,%ebx
80105e7b:	83 fb 10             	cmp    $0x10,%ebx
80105e7e:	75 f0                	jne    80105e70 <sys_open+0x80>
        if (f)
            fileclose(f);
80105e80:	83 ec 0c             	sub    $0xc,%esp
80105e83:	57                   	push   %edi
80105e84:	e8 27 bb ff ff       	call   801019b0 <fileclose>
80105e89:	83 c4 10             	add    $0x10,%esp
        iunlockput(ip);
80105e8c:	83 ec 0c             	sub    $0xc,%esp
80105e8f:	56                   	push   %esi
80105e90:	e8 0b c7 ff ff       	call   801025a0 <iunlockput>
        end_op();
80105e95:	e8 a6 da ff ff       	call   80103940 <end_op>
        return -1;
80105e9a:	83 c4 10             	add    $0x10,%esp
80105e9d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ea2:	eb 6d                	jmp    80105f11 <sys_open+0x121>
80105ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ip = create(path, T_FILE, 0, 0);
80105ea8:	83 ec 0c             	sub    $0xc,%esp
80105eab:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105eae:	31 c9                	xor    %ecx,%ecx
80105eb0:	ba 02 00 00 00       	mov    $0x2,%edx
80105eb5:	6a 00                	push   $0x0
80105eb7:	e8 24 f8 ff ff       	call   801056e0 <create>
        if (ip == 0) {
80105ebc:	83 c4 10             	add    $0x10,%esp
        ip = create(path, T_FILE, 0, 0);
80105ebf:	89 c6                	mov    %eax,%esi
        if (ip == 0) {
80105ec1:	85 c0                	test   %eax,%eax
80105ec3:	75 99                	jne    80105e5e <sys_open+0x6e>
            end_op();
80105ec5:	e8 76 da ff ff       	call   80103940 <end_op>
            return -1;
80105eca:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ecf:	eb 40                	jmp    80105f11 <sys_open+0x121>
80105ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    iunlock(ip);
80105ed8:	83 ec 0c             	sub    $0xc,%esp
            curproc->ofile[fd] = f;
80105edb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
    iunlock(ip);
80105edf:	56                   	push   %esi
80105ee0:	e8 fb c4 ff ff       	call   801023e0 <iunlock>
    end_op();
80105ee5:	e8 56 da ff ff       	call   80103940 <end_op>

    f->type = FD_INODE;
80105eea:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
    f->ip = ip;
    f->off = 0;
    f->readable = !(omode & O_WRONLY);
80105ef0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ef3:	83 c4 10             	add    $0x10,%esp
    f->ip = ip;
80105ef6:	89 77 10             	mov    %esi,0x10(%edi)
    f->readable = !(omode & O_WRONLY);
80105ef9:	89 d0                	mov    %edx,%eax
    f->off = 0;
80105efb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
    f->readable = !(omode & O_WRONLY);
80105f02:	f7 d0                	not    %eax
80105f04:	83 e0 01             	and    $0x1,%eax
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f07:	83 e2 03             	and    $0x3,%edx
    f->readable = !(omode & O_WRONLY);
80105f0a:	88 47 08             	mov    %al,0x8(%edi)
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f0d:	0f 95 47 09          	setne  0x9(%edi)
    return fd;
}
80105f11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f14:	89 d8                	mov    %ebx,%eax
80105f16:	5b                   	pop    %ebx
80105f17:	5e                   	pop    %esi
80105f18:	5f                   	pop    %edi
80105f19:	5d                   	pop    %ebp
80105f1a:	c3                   	ret    
80105f1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f1f:	90                   	nop
        if (ip->type == T_DIR && omode != O_RDONLY) {
80105f20:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105f23:	85 c9                	test   %ecx,%ecx
80105f25:	0f 84 33 ff ff ff    	je     80105e5e <sys_open+0x6e>
80105f2b:	e9 5c ff ff ff       	jmp    80105e8c <sys_open+0x9c>

80105f30 <sys_mkdir>:

int sys_mkdir(void) {
80105f30:	f3 0f 1e fb          	endbr32 
80105f34:	55                   	push   %ebp
80105f35:	89 e5                	mov    %esp,%ebp
80105f37:	83 ec 18             	sub    $0x18,%esp
    char* path;
    struct inode* ip;

    begin_op();
80105f3a:	e8 91 d9 ff ff       	call   801038d0 <begin_op>
    if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
80105f3f:	83 ec 08             	sub    $0x8,%esp
80105f42:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f45:	50                   	push   %eax
80105f46:	6a 00                	push   $0x0
80105f48:	e8 e3 f6 ff ff       	call   80105630 <argstr>
80105f4d:	83 c4 10             	add    $0x10,%esp
80105f50:	85 c0                	test   %eax,%eax
80105f52:	78 34                	js     80105f88 <sys_mkdir+0x58>
80105f54:	83 ec 0c             	sub    $0xc,%esp
80105f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f5a:	31 c9                	xor    %ecx,%ecx
80105f5c:	ba 01 00 00 00       	mov    $0x1,%edx
80105f61:	6a 00                	push   $0x0
80105f63:	e8 78 f7 ff ff       	call   801056e0 <create>
80105f68:	83 c4 10             	add    $0x10,%esp
80105f6b:	85 c0                	test   %eax,%eax
80105f6d:	74 19                	je     80105f88 <sys_mkdir+0x58>
        end_op();
        return -1;
    }
    iunlockput(ip);
80105f6f:	83 ec 0c             	sub    $0xc,%esp
80105f72:	50                   	push   %eax
80105f73:	e8 28 c6 ff ff       	call   801025a0 <iunlockput>
    end_op();
80105f78:	e8 c3 d9 ff ff       	call   80103940 <end_op>
    return 0;
80105f7d:	83 c4 10             	add    $0x10,%esp
80105f80:	31 c0                	xor    %eax,%eax
}
80105f82:	c9                   	leave  
80105f83:	c3                   	ret    
80105f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        end_op();
80105f88:	e8 b3 d9 ff ff       	call   80103940 <end_op>
        return -1;
80105f8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f92:	c9                   	leave  
80105f93:	c3                   	ret    
80105f94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f9f:	90                   	nop

80105fa0 <sys_mknod>:

int sys_mknod(void) {
80105fa0:	f3 0f 1e fb          	endbr32 
80105fa4:	55                   	push   %ebp
80105fa5:	89 e5                	mov    %esp,%ebp
80105fa7:	83 ec 18             	sub    $0x18,%esp
    struct inode* ip;
    char* path;
    int major, minor;

    begin_op();
80105faa:	e8 21 d9 ff ff       	call   801038d0 <begin_op>
    if ((argstr(0, &path)) < 0 ||
80105faf:	83 ec 08             	sub    $0x8,%esp
80105fb2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105fb5:	50                   	push   %eax
80105fb6:	6a 00                	push   $0x0
80105fb8:	e8 73 f6 ff ff       	call   80105630 <argstr>
80105fbd:	83 c4 10             	add    $0x10,%esp
80105fc0:	85 c0                	test   %eax,%eax
80105fc2:	78 64                	js     80106028 <sys_mknod+0x88>
        argint(1, &major) < 0 ||
80105fc4:	83 ec 08             	sub    $0x8,%esp
80105fc7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fca:	50                   	push   %eax
80105fcb:	6a 01                	push   $0x1
80105fcd:	e8 ae f5 ff ff       	call   80105580 <argint>
    if ((argstr(0, &path)) < 0 ||
80105fd2:	83 c4 10             	add    $0x10,%esp
80105fd5:	85 c0                	test   %eax,%eax
80105fd7:	78 4f                	js     80106028 <sys_mknod+0x88>
        argint(2, &minor) < 0 ||
80105fd9:	83 ec 08             	sub    $0x8,%esp
80105fdc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fdf:	50                   	push   %eax
80105fe0:	6a 02                	push   $0x2
80105fe2:	e8 99 f5 ff ff       	call   80105580 <argint>
        argint(1, &major) < 0 ||
80105fe7:	83 c4 10             	add    $0x10,%esp
80105fea:	85 c0                	test   %eax,%eax
80105fec:	78 3a                	js     80106028 <sys_mknod+0x88>
        (ip = create(path, T_DEV, major, minor)) == 0) {
80105fee:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105ff2:	83 ec 0c             	sub    $0xc,%esp
80105ff5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105ff9:	ba 03 00 00 00       	mov    $0x3,%edx
80105ffe:	50                   	push   %eax
80105fff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106002:	e8 d9 f6 ff ff       	call   801056e0 <create>
        argint(2, &minor) < 0 ||
80106007:	83 c4 10             	add    $0x10,%esp
8010600a:	85 c0                	test   %eax,%eax
8010600c:	74 1a                	je     80106028 <sys_mknod+0x88>
        end_op();
        return -1;
    }
    iunlockput(ip);
8010600e:	83 ec 0c             	sub    $0xc,%esp
80106011:	50                   	push   %eax
80106012:	e8 89 c5 ff ff       	call   801025a0 <iunlockput>
    end_op();
80106017:	e8 24 d9 ff ff       	call   80103940 <end_op>
    return 0;
8010601c:	83 c4 10             	add    $0x10,%esp
8010601f:	31 c0                	xor    %eax,%eax
}
80106021:	c9                   	leave  
80106022:	c3                   	ret    
80106023:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106027:	90                   	nop
        end_op();
80106028:	e8 13 d9 ff ff       	call   80103940 <end_op>
        return -1;
8010602d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106032:	c9                   	leave  
80106033:	c3                   	ret    
80106034:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010603b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010603f:	90                   	nop

80106040 <sys_chdir>:

int sys_chdir(void) {
80106040:	f3 0f 1e fb          	endbr32 
80106044:	55                   	push   %ebp
80106045:	89 e5                	mov    %esp,%ebp
80106047:	56                   	push   %esi
80106048:	53                   	push   %ebx
80106049:	83 ec 10             	sub    $0x10,%esp
    char* path;
    struct inode* ip;
    struct proc* curproc = myproc();
8010604c:	e8 af e4 ff ff       	call   80104500 <myproc>
80106051:	89 c6                	mov    %eax,%esi

    begin_op();
80106053:	e8 78 d8 ff ff       	call   801038d0 <begin_op>
    if (argstr(0, &path) < 0 || (ip = namei(path)) == 0) {
80106058:	83 ec 08             	sub    $0x8,%esp
8010605b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010605e:	50                   	push   %eax
8010605f:	6a 00                	push   $0x0
80106061:	e8 ca f5 ff ff       	call   80105630 <argstr>
80106066:	83 c4 10             	add    $0x10,%esp
80106069:	85 c0                	test   %eax,%eax
8010606b:	78 73                	js     801060e0 <sys_chdir+0xa0>
8010606d:	83 ec 0c             	sub    $0xc,%esp
80106070:	ff 75 f4             	pushl  -0xc(%ebp)
80106073:	e8 58 cb ff ff       	call   80102bd0 <namei>
80106078:	83 c4 10             	add    $0x10,%esp
8010607b:	89 c3                	mov    %eax,%ebx
8010607d:	85 c0                	test   %eax,%eax
8010607f:	74 5f                	je     801060e0 <sys_chdir+0xa0>
        end_op();
        return -1;
    }
    ilock(ip);
80106081:	83 ec 0c             	sub    $0xc,%esp
80106084:	50                   	push   %eax
80106085:	e8 76 c2 ff ff       	call   80102300 <ilock>
    if (ip->type != T_DIR) {
8010608a:	83 c4 10             	add    $0x10,%esp
8010608d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106092:	75 2c                	jne    801060c0 <sys_chdir+0x80>
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
80106094:	83 ec 0c             	sub    $0xc,%esp
80106097:	53                   	push   %ebx
80106098:	e8 43 c3 ff ff       	call   801023e0 <iunlock>
    iput(curproc->cwd);
8010609d:	58                   	pop    %eax
8010609e:	ff 76 68             	pushl  0x68(%esi)
801060a1:	e8 8a c3 ff ff       	call   80102430 <iput>
    end_op();
801060a6:	e8 95 d8 ff ff       	call   80103940 <end_op>
    curproc->cwd = ip;
801060ab:	89 5e 68             	mov    %ebx,0x68(%esi)
    return 0;
801060ae:	83 c4 10             	add    $0x10,%esp
801060b1:	31 c0                	xor    %eax,%eax
}
801060b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801060b6:	5b                   	pop    %ebx
801060b7:	5e                   	pop    %esi
801060b8:	5d                   	pop    %ebp
801060b9:	c3                   	ret    
801060ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        iunlockput(ip);
801060c0:	83 ec 0c             	sub    $0xc,%esp
801060c3:	53                   	push   %ebx
801060c4:	e8 d7 c4 ff ff       	call   801025a0 <iunlockput>
        end_op();
801060c9:	e8 72 d8 ff ff       	call   80103940 <end_op>
        return -1;
801060ce:	83 c4 10             	add    $0x10,%esp
801060d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060d6:	eb db                	jmp    801060b3 <sys_chdir+0x73>
801060d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060df:	90                   	nop
        end_op();
801060e0:	e8 5b d8 ff ff       	call   80103940 <end_op>
        return -1;
801060e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060ea:	eb c7                	jmp    801060b3 <sys_chdir+0x73>
801060ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060f0 <sys_exec>:

int sys_exec(void) {
801060f0:	f3 0f 1e fb          	endbr32 
801060f4:	55                   	push   %ebp
801060f5:	89 e5                	mov    %esp,%ebp
801060f7:	57                   	push   %edi
801060f8:	56                   	push   %esi
    char *path, *argv[MAXARG];
    int i;
    uint uargv, uarg;

    if (argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
801060f9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
int sys_exec(void) {
801060ff:	53                   	push   %ebx
80106100:	81 ec a4 00 00 00    	sub    $0xa4,%esp
    if (argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
80106106:	50                   	push   %eax
80106107:	6a 00                	push   $0x0
80106109:	e8 22 f5 ff ff       	call   80105630 <argstr>
8010610e:	83 c4 10             	add    $0x10,%esp
80106111:	85 c0                	test   %eax,%eax
80106113:	0f 88 8b 00 00 00    	js     801061a4 <sys_exec+0xb4>
80106119:	83 ec 08             	sub    $0x8,%esp
8010611c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106122:	50                   	push   %eax
80106123:	6a 01                	push   $0x1
80106125:	e8 56 f4 ff ff       	call   80105580 <argint>
8010612a:	83 c4 10             	add    $0x10,%esp
8010612d:	85 c0                	test   %eax,%eax
8010612f:	78 73                	js     801061a4 <sys_exec+0xb4>
        return -1;
    }
    memset(argv, 0, sizeof(argv));
80106131:	83 ec 04             	sub    $0x4,%esp
80106134:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
    for (i = 0;; i++) {
8010613a:	31 db                	xor    %ebx,%ebx
    memset(argv, 0, sizeof(argv));
8010613c:	68 80 00 00 00       	push   $0x80
80106141:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106147:	6a 00                	push   $0x0
80106149:	50                   	push   %eax
8010614a:	e8 51 f1 ff ff       	call   801052a0 <memset>
8010614f:	83 c4 10             	add    $0x10,%esp
80106152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (i >= NELEM(argv))
            return -1;
        if (fetchint(uargv + 4 * i, (int*)&uarg) < 0)
80106158:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010615e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106165:	83 ec 08             	sub    $0x8,%esp
80106168:	57                   	push   %edi
80106169:	01 f0                	add    %esi,%eax
8010616b:	50                   	push   %eax
8010616c:	e8 6f f3 ff ff       	call   801054e0 <fetchint>
80106171:	83 c4 10             	add    $0x10,%esp
80106174:	85 c0                	test   %eax,%eax
80106176:	78 2c                	js     801061a4 <sys_exec+0xb4>
            return -1;
        if (uarg == 0) {
80106178:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010617e:	85 c0                	test   %eax,%eax
80106180:	74 36                	je     801061b8 <sys_exec+0xc8>
            argv[i] = 0;
            break;
        }
        if (fetchstr(uarg, &argv[i]) < 0)
80106182:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106188:	83 ec 08             	sub    $0x8,%esp
8010618b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010618e:	52                   	push   %edx
8010618f:	50                   	push   %eax
80106190:	e8 8b f3 ff ff       	call   80105520 <fetchstr>
80106195:	83 c4 10             	add    $0x10,%esp
80106198:	85 c0                	test   %eax,%eax
8010619a:	78 08                	js     801061a4 <sys_exec+0xb4>
    for (i = 0;; i++) {
8010619c:	83 c3 01             	add    $0x1,%ebx
        if (i >= NELEM(argv))
8010619f:	83 fb 20             	cmp    $0x20,%ebx
801061a2:	75 b4                	jne    80106158 <sys_exec+0x68>
            return -1;
    }
    return exec(path, argv);
}
801061a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
801061a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061ac:	5b                   	pop    %ebx
801061ad:	5e                   	pop    %esi
801061ae:	5f                   	pop    %edi
801061af:	5d                   	pop    %ebp
801061b0:	c3                   	ret    
801061b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return exec(path, argv);
801061b8:	83 ec 08             	sub    $0x8,%esp
801061bb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
            argv[i] = 0;
801061c1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801061c8:	00 00 00 00 
    return exec(path, argv);
801061cc:	50                   	push   %eax
801061cd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801061d3:	e8 98 b3 ff ff       	call   80101570 <exec>
801061d8:	83 c4 10             	add    $0x10,%esp
}
801061db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061de:	5b                   	pop    %ebx
801061df:	5e                   	pop    %esi
801061e0:	5f                   	pop    %edi
801061e1:	5d                   	pop    %ebp
801061e2:	c3                   	ret    
801061e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801061f0 <sys_pipe>:

int sys_pipe(void) {
801061f0:	f3 0f 1e fb          	endbr32 
801061f4:	55                   	push   %ebp
801061f5:	89 e5                	mov    %esp,%ebp
801061f7:	57                   	push   %edi
801061f8:	56                   	push   %esi
    int* fd;
    struct file *rf, *wf;
    int fd0, fd1;

    if (argptr(0, (void*)&fd, 2 * sizeof(fd[0])) < 0)
801061f9:	8d 45 dc             	lea    -0x24(%ebp),%eax
int sys_pipe(void) {
801061fc:	53                   	push   %ebx
801061fd:	83 ec 20             	sub    $0x20,%esp
    if (argptr(0, (void*)&fd, 2 * sizeof(fd[0])) < 0)
80106200:	6a 08                	push   $0x8
80106202:	50                   	push   %eax
80106203:	6a 00                	push   $0x0
80106205:	e8 c6 f3 ff ff       	call   801055d0 <argptr>
8010620a:	83 c4 10             	add    $0x10,%esp
8010620d:	85 c0                	test   %eax,%eax
8010620f:	78 4e                	js     8010625f <sys_pipe+0x6f>
        return -1;
    if (pipealloc(&rf, &wf) < 0)
80106211:	83 ec 08             	sub    $0x8,%esp
80106214:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106217:	50                   	push   %eax
80106218:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010621b:	50                   	push   %eax
8010621c:	e8 6f dd ff ff       	call   80103f90 <pipealloc>
80106221:	83 c4 10             	add    $0x10,%esp
80106224:	85 c0                	test   %eax,%eax
80106226:	78 37                	js     8010625f <sys_pipe+0x6f>
        return -1;
    fd0 = -1;
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
80106228:	8b 7d e0             	mov    -0x20(%ebp),%edi
    for (fd = 0; fd < NOFILE; fd++) {
8010622b:	31 db                	xor    %ebx,%ebx
    struct proc* curproc = myproc();
8010622d:	e8 ce e2 ff ff       	call   80104500 <myproc>
    for (fd = 0; fd < NOFILE; fd++) {
80106232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (curproc->ofile[fd] == 0) {
80106238:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010623c:	85 f6                	test   %esi,%esi
8010623e:	74 30                	je     80106270 <sys_pipe+0x80>
    for (fd = 0; fd < NOFILE; fd++) {
80106240:	83 c3 01             	add    $0x1,%ebx
80106243:	83 fb 10             	cmp    $0x10,%ebx
80106246:	75 f0                	jne    80106238 <sys_pipe+0x48>
        if (fd0 >= 0)
            myproc()->ofile[fd0] = 0;
        fileclose(rf);
80106248:	83 ec 0c             	sub    $0xc,%esp
8010624b:	ff 75 e0             	pushl  -0x20(%ebp)
8010624e:	e8 5d b7 ff ff       	call   801019b0 <fileclose>
        fileclose(wf);
80106253:	58                   	pop    %eax
80106254:	ff 75 e4             	pushl  -0x1c(%ebp)
80106257:	e8 54 b7 ff ff       	call   801019b0 <fileclose>
        return -1;
8010625c:	83 c4 10             	add    $0x10,%esp
8010625f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106264:	eb 5b                	jmp    801062c1 <sys_pipe+0xd1>
80106266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010626d:	8d 76 00             	lea    0x0(%esi),%esi
            curproc->ofile[fd] = f;
80106270:	8d 73 08             	lea    0x8(%ebx),%esi
80106273:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
80106277:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    struct proc* curproc = myproc();
8010627a:	e8 81 e2 ff ff       	call   80104500 <myproc>
    for (fd = 0; fd < NOFILE; fd++) {
8010627f:	31 d2                	xor    %edx,%edx
80106281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (curproc->ofile[fd] == 0) {
80106288:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010628c:	85 c9                	test   %ecx,%ecx
8010628e:	74 20                	je     801062b0 <sys_pipe+0xc0>
    for (fd = 0; fd < NOFILE; fd++) {
80106290:	83 c2 01             	add    $0x1,%edx
80106293:	83 fa 10             	cmp    $0x10,%edx
80106296:	75 f0                	jne    80106288 <sys_pipe+0x98>
            myproc()->ofile[fd0] = 0;
80106298:	e8 63 e2 ff ff       	call   80104500 <myproc>
8010629d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801062a4:	00 
801062a5:	eb a1                	jmp    80106248 <sys_pipe+0x58>
801062a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062ae:	66 90                	xchg   %ax,%ax
            curproc->ofile[fd] = f;
801062b0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
    }
    fd[0] = fd0;
801062b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801062b7:	89 18                	mov    %ebx,(%eax)
    fd[1] = fd1;
801062b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801062bc:	89 50 04             	mov    %edx,0x4(%eax)
    return 0;
801062bf:	31 c0                	xor    %eax,%eax
}
801062c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062c4:	5b                   	pop    %ebx
801062c5:	5e                   	pop    %esi
801062c6:	5f                   	pop    %edi
801062c7:	5d                   	pop    %ebp
801062c8:	c3                   	ret    
801062c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062d0 <sys_fcopy>:


int sys_fcopy(void) {
801062d0:	f3 0f 1e fb          	endbr32 
801062d4:	55                   	push   %ebp
801062d5:	89 e5                	mov    %esp,%ebp
801062d7:	56                   	push   %esi
801062d8:	53                   	push   %ebx
    char* src_path, *dest_path;
    argstr(0, &src_path);
801062d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
int sys_fcopy(void) {
801062dc:	83 ec 18             	sub    $0x18,%esp
    argstr(0, &src_path);
801062df:	50                   	push   %eax
801062e0:	6a 00                	push   $0x0
801062e2:	e8 49 f3 ff ff       	call   80105630 <argstr>
    argstr(1, &dest_path);
801062e7:	58                   	pop    %eax
801062e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062eb:	5a                   	pop    %edx
801062ec:	50                   	push   %eax
801062ed:	6a 01                	push   $0x1
801062ef:	e8 3c f3 ff ff       	call   80105630 <argstr>
    struct inode* src = namei(src_path);
801062f4:	59                   	pop    %ecx
801062f5:	ff 75 f0             	pushl  -0x10(%ebp)
801062f8:	e8 d3 c8 ff ff       	call   80102bd0 <namei>
    struct inode* dest = namei(dest_path);
801062fd:	5b                   	pop    %ebx
801062fe:	ff 75 f4             	pushl  -0xc(%ebp)
    struct inode* src = namei(src_path);
80106301:	89 c6                	mov    %eax,%esi
    struct inode* dest = namei(dest_path);
80106303:	e8 c8 c8 ff ff       	call   80102bd0 <namei>
    if(src == 0){
80106308:	83 c4 10             	add    $0x10,%esp
8010630b:	85 f6                	test   %esi,%esi
8010630d:	74 63                	je     80106372 <sys_fcopy+0xa2>
8010630f:	89 c3                	mov    %eax,%ebx
        cprintf("source file does not exist!\n");
        return -1;
    }
    if(dest == 0) {
80106311:	85 c0                	test   %eax,%eax
80106313:	74 2b                	je     80106340 <sys_fcopy+0x70>
        dest = create(dest_path, T_FILE, 0, 1);
    }
    else if(src == dest) {
80106315:	39 c6                	cmp    %eax,%esi
80106317:	74 42                	je     8010635b <sys_fcopy+0x8b>
        cprintf("a file can not be copy at itself!\n");
        return -1;
    }
    else {
        cprintf("[WARNING] destination file exists, it will be overwriten!\n");
80106319:	83 ec 0c             	sub    $0xc,%esp
8010631c:	68 08 86 10 80       	push   $0x80108608
80106321:	e8 9a a4 ff ff       	call   801007c0 <cprintf>
80106326:	83 c4 10             	add    $0x10,%esp
    }
    
    return fcopy(src, dest);
80106329:	83 ec 08             	sub    $0x8,%esp
8010632c:	53                   	push   %ebx
8010632d:	56                   	push   %esi
8010632e:	e8 6d b9 ff ff       	call   80101ca0 <fcopy>
80106333:	83 c4 10             	add    $0x10,%esp
}
80106336:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106339:	5b                   	pop    %ebx
8010633a:	5e                   	pop    %esi
8010633b:	5d                   	pop    %ebp
8010633c:	c3                   	ret    
8010633d:	8d 76 00             	lea    0x0(%esi),%esi
        dest = create(dest_path, T_FILE, 0, 1);
80106340:	83 ec 0c             	sub    $0xc,%esp
80106343:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106346:	31 c9                	xor    %ecx,%ecx
80106348:	ba 02 00 00 00       	mov    $0x2,%edx
8010634d:	6a 01                	push   $0x1
8010634f:	e8 8c f3 ff ff       	call   801056e0 <create>
80106354:	83 c4 10             	add    $0x10,%esp
80106357:	89 c3                	mov    %eax,%ebx
80106359:	eb ce                	jmp    80106329 <sys_fcopy+0x59>
        cprintf("a file can not be copy at itself!\n");
8010635b:	83 ec 0c             	sub    $0xc,%esp
8010635e:	68 e4 85 10 80       	push   $0x801085e4
80106363:	e8 58 a4 ff ff       	call   801007c0 <cprintf>
        return -1;
80106368:	83 c4 10             	add    $0x10,%esp
8010636b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106370:	eb c4                	jmp    80106336 <sys_fcopy+0x66>
        cprintf("source file does not exist!\n");
80106372:	83 ec 0c             	sub    $0xc,%esp
80106375:	68 c5 85 10 80       	push   $0x801085c5
8010637a:	e8 41 a4 ff ff       	call   801007c0 <cprintf>
        return -1;
8010637f:	83 c4 10             	add    $0x10,%esp
80106382:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106387:	eb ad                	jmp    80106336 <sys_fcopy+0x66>
80106389:	66 90                	xchg   %ax,%ax
8010638b:	66 90                	xchg   %ax,%ax
8010638d:	66 90                	xchg   %ax,%ax
8010638f:	90                   	nop

80106390 <sys_fork>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_fork(void) {
80106390:	f3 0f 1e fb          	endbr32 
    return fork();
80106394:	e9 17 e3 ff ff       	jmp    801046b0 <fork>
80106399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063a0 <sys_exit>:
}

int sys_exit(void) {
801063a0:	f3 0f 1e fb          	endbr32 
801063a4:	55                   	push   %ebp
801063a5:	89 e5                	mov    %esp,%ebp
801063a7:	83 ec 08             	sub    $0x8,%esp
    exit();
801063aa:	e8 91 e5 ff ff       	call   80104940 <exit>
    return 0; // not reached
}
801063af:	31 c0                	xor    %eax,%eax
801063b1:	c9                   	leave  
801063b2:	c3                   	ret    
801063b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801063c0 <sys_wait>:

int sys_wait(void) {
801063c0:	f3 0f 1e fb          	endbr32 
    return wait();
801063c4:	e9 c7 e7 ff ff       	jmp    80104b90 <wait>
801063c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063d0 <sys_kill>:
}

int sys_kill(void) {
801063d0:	f3 0f 1e fb          	endbr32 
801063d4:	55                   	push   %ebp
801063d5:	89 e5                	mov    %esp,%ebp
801063d7:	83 ec 20             	sub    $0x20,%esp
    int pid;

    if (argint(0, &pid) < 0)
801063da:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063dd:	50                   	push   %eax
801063de:	6a 00                	push   $0x0
801063e0:	e8 9b f1 ff ff       	call   80105580 <argint>
801063e5:	83 c4 10             	add    $0x10,%esp
801063e8:	85 c0                	test   %eax,%eax
801063ea:	78 14                	js     80106400 <sys_kill+0x30>
        return -1;
    return kill(pid);
801063ec:	83 ec 0c             	sub    $0xc,%esp
801063ef:	ff 75 f4             	pushl  -0xc(%ebp)
801063f2:	e8 f9 e8 ff ff       	call   80104cf0 <kill>
801063f7:	83 c4 10             	add    $0x10,%esp
}
801063fa:	c9                   	leave  
801063fb:	c3                   	ret    
801063fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106400:	c9                   	leave  
        return -1;
80106401:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106406:	c3                   	ret    
80106407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010640e:	66 90                	xchg   %ax,%ax

80106410 <sys_getpid>:

int sys_getpid(void) {
80106410:	f3 0f 1e fb          	endbr32 
80106414:	55                   	push   %ebp
80106415:	89 e5                	mov    %esp,%ebp
80106417:	83 ec 08             	sub    $0x8,%esp
    return myproc()->pid;
8010641a:	e8 e1 e0 ff ff       	call   80104500 <myproc>
8010641f:	8b 40 10             	mov    0x10(%eax),%eax
}
80106422:	c9                   	leave  
80106423:	c3                   	ret    
80106424:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010642b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010642f:	90                   	nop

80106430 <sys_sbrk>:

int sys_sbrk(void) {
80106430:	f3 0f 1e fb          	endbr32 
80106434:	55                   	push   %ebp
80106435:	89 e5                	mov    %esp,%ebp
80106437:	53                   	push   %ebx
    int addr;
    int n;

    if (argint(0, &n) < 0)
80106438:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sbrk(void) {
8010643b:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &n) < 0)
8010643e:	50                   	push   %eax
8010643f:	6a 00                	push   $0x0
80106441:	e8 3a f1 ff ff       	call   80105580 <argint>
80106446:	83 c4 10             	add    $0x10,%esp
80106449:	85 c0                	test   %eax,%eax
8010644b:	78 23                	js     80106470 <sys_sbrk+0x40>
        return -1;
    addr = myproc()->sz;
8010644d:	e8 ae e0 ff ff       	call   80104500 <myproc>
    if (growproc(n) < 0)
80106452:	83 ec 0c             	sub    $0xc,%esp
    addr = myproc()->sz;
80106455:	8b 18                	mov    (%eax),%ebx
    if (growproc(n) < 0)
80106457:	ff 75 f4             	pushl  -0xc(%ebp)
8010645a:	e8 d1 e1 ff ff       	call   80104630 <growproc>
8010645f:	83 c4 10             	add    $0x10,%esp
80106462:	85 c0                	test   %eax,%eax
80106464:	78 0a                	js     80106470 <sys_sbrk+0x40>
        return -1;
    return addr;
}
80106466:	89 d8                	mov    %ebx,%eax
80106468:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010646b:	c9                   	leave  
8010646c:	c3                   	ret    
8010646d:	8d 76 00             	lea    0x0(%esi),%esi
        return -1;
80106470:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106475:	eb ef                	jmp    80106466 <sys_sbrk+0x36>
80106477:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010647e:	66 90                	xchg   %ax,%ax

80106480 <sys_sleep>:

int sys_sleep(void) {
80106480:	f3 0f 1e fb          	endbr32 
80106484:	55                   	push   %ebp
80106485:	89 e5                	mov    %esp,%ebp
80106487:	53                   	push   %ebx
    int n;
    uint ticks0;

    if (argint(0, &n) < 0)
80106488:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sleep(void) {
8010648b:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &n) < 0)
8010648e:	50                   	push   %eax
8010648f:	6a 00                	push   $0x0
80106491:	e8 ea f0 ff ff       	call   80105580 <argint>
80106496:	83 c4 10             	add    $0x10,%esp
80106499:	85 c0                	test   %eax,%eax
8010649b:	0f 88 86 00 00 00    	js     80106527 <sys_sleep+0xa7>
        return -1;
    acquire(&tickslock);
801064a1:	83 ec 0c             	sub    $0xc,%esp
801064a4:	68 00 63 11 80       	push   $0x80116300
801064a9:	e8 e2 ec ff ff       	call   80105190 <acquire>
    ticks0 = ticks;
    while (ticks - ticks0 < n) {
801064ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
    ticks0 = ticks;
801064b1:	8b 1d 40 6b 11 80    	mov    0x80116b40,%ebx
    while (ticks - ticks0 < n) {
801064b7:	83 c4 10             	add    $0x10,%esp
801064ba:	85 d2                	test   %edx,%edx
801064bc:	75 23                	jne    801064e1 <sys_sleep+0x61>
801064be:	eb 50                	jmp    80106510 <sys_sleep+0x90>
        if (myproc()->killed) {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
801064c0:	83 ec 08             	sub    $0x8,%esp
801064c3:	68 00 63 11 80       	push   $0x80116300
801064c8:	68 40 6b 11 80       	push   $0x80116b40
801064cd:	e8 fe e5 ff ff       	call   80104ad0 <sleep>
    while (ticks - ticks0 < n) {
801064d2:	a1 40 6b 11 80       	mov    0x80116b40,%eax
801064d7:	83 c4 10             	add    $0x10,%esp
801064da:	29 d8                	sub    %ebx,%eax
801064dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801064df:	73 2f                	jae    80106510 <sys_sleep+0x90>
        if (myproc()->killed) {
801064e1:	e8 1a e0 ff ff       	call   80104500 <myproc>
801064e6:	8b 40 24             	mov    0x24(%eax),%eax
801064e9:	85 c0                	test   %eax,%eax
801064eb:	74 d3                	je     801064c0 <sys_sleep+0x40>
            release(&tickslock);
801064ed:	83 ec 0c             	sub    $0xc,%esp
801064f0:	68 00 63 11 80       	push   $0x80116300
801064f5:	e8 56 ed ff ff       	call   80105250 <release>
    }
    release(&tickslock);
    return 0;
}
801064fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
            return -1;
801064fd:	83 c4 10             	add    $0x10,%esp
80106500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106505:	c9                   	leave  
80106506:	c3                   	ret    
80106507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010650e:	66 90                	xchg   %ax,%ax
    release(&tickslock);
80106510:	83 ec 0c             	sub    $0xc,%esp
80106513:	68 00 63 11 80       	push   $0x80116300
80106518:	e8 33 ed ff ff       	call   80105250 <release>
    return 0;
8010651d:	83 c4 10             	add    $0x10,%esp
80106520:	31 c0                	xor    %eax,%eax
}
80106522:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106525:	c9                   	leave  
80106526:	c3                   	ret    
        return -1;
80106527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010652c:	eb f4                	jmp    80106522 <sys_sleep+0xa2>
8010652e:	66 90                	xchg   %ax,%ax

80106530 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void) {
80106530:	f3 0f 1e fb          	endbr32 
80106534:	55                   	push   %ebp
80106535:	89 e5                	mov    %esp,%ebp
80106537:	53                   	push   %ebx
80106538:	83 ec 10             	sub    $0x10,%esp
    uint xticks;

    acquire(&tickslock);
8010653b:	68 00 63 11 80       	push   $0x80116300
80106540:	e8 4b ec ff ff       	call   80105190 <acquire>
    xticks = ticks;
80106545:	8b 1d 40 6b 11 80    	mov    0x80116b40,%ebx
    release(&tickslock);
8010654b:	c7 04 24 00 63 11 80 	movl   $0x80116300,(%esp)
80106552:	e8 f9 ec ff ff       	call   80105250 <release>
    return xticks;
}
80106557:	89 d8                	mov    %ebx,%eax
80106559:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010655c:	c9                   	leave  
8010655d:	c3                   	ret    
8010655e:	66 90                	xchg   %ax,%ax

80106560 <sys_nuncle>:

// return number of uncles of a process
int sys_nuncle(void) {
80106560:	f3 0f 1e fb          	endbr32 
    return nuncle();
80106564:	e9 e7 e8 ff ff       	jmp    80104e50 <nuncle>
80106569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106570 <sys_ptime>:
}

// return process time
int sys_ptime(void) {
80106570:	f3 0f 1e fb          	endbr32 
    return ptime();
80106574:	e9 27 e9 ff ff       	jmp    80104ea0 <ptime>

80106579 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106579:	1e                   	push   %ds
  pushl %es
8010657a:	06                   	push   %es
  pushl %fs
8010657b:	0f a0                	push   %fs
  pushl %gs
8010657d:	0f a8                	push   %gs
  pushal
8010657f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106580:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106584:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106586:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106588:	54                   	push   %esp
  call trap
80106589:	e8 c2 00 00 00       	call   80106650 <trap>
  addl $4, %esp
8010658e:	83 c4 04             	add    $0x4,%esp

80106591 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106591:	61                   	popa   
  popl %gs
80106592:	0f a9                	pop    %gs
  popl %fs
80106594:	0f a1                	pop    %fs
  popl %es
80106596:	07                   	pop    %es
  popl %ds
80106597:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106598:	83 c4 08             	add    $0x8,%esp
  iret
8010659b:	cf                   	iret   
8010659c:	66 90                	xchg   %ax,%ax
8010659e:	66 90                	xchg   %ax,%ax

801065a0 <tvinit>:
struct gatedesc idt[256];
extern uint vectors[]; // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void) {
801065a0:	f3 0f 1e fb          	endbr32 
801065a4:	55                   	push   %ebp
    int i;

    for (i = 0; i < 256; i++)
801065a5:	31 c0                	xor    %eax,%eax
void tvinit(void) {
801065a7:	89 e5                	mov    %esp,%ebp
801065a9:	83 ec 08             	sub    $0x8,%esp
801065ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
801065b0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801065b7:	c7 04 c5 42 63 11 80 	movl   $0x8e000008,-0x7fee9cbe(,%eax,8)
801065be:	08 00 00 8e 
801065c2:	66 89 14 c5 40 63 11 	mov    %dx,-0x7fee9cc0(,%eax,8)
801065c9:	80 
801065ca:	c1 ea 10             	shr    $0x10,%edx
801065cd:	66 89 14 c5 46 63 11 	mov    %dx,-0x7fee9cba(,%eax,8)
801065d4:	80 
    for (i = 0; i < 256; i++)
801065d5:	83 c0 01             	add    $0x1,%eax
801065d8:	3d 00 01 00 00       	cmp    $0x100,%eax
801065dd:	75 d1                	jne    801065b0 <tvinit+0x10>
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

    initlock(&tickslock, "time");
801065df:	83 ec 08             	sub    $0x8,%esp
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
801065e2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801065e7:	c7 05 42 65 11 80 08 	movl   $0xef000008,0x80116542
801065ee:	00 00 ef 
    initlock(&tickslock, "time");
801065f1:	68 43 86 10 80       	push   $0x80108643
801065f6:	68 00 63 11 80       	push   $0x80116300
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
801065fb:	66 a3 40 65 11 80    	mov    %ax,0x80116540
80106601:	c1 e8 10             	shr    $0x10,%eax
80106604:	66 a3 46 65 11 80    	mov    %ax,0x80116546
    initlock(&tickslock, "time");
8010660a:	e8 01 ea ff ff       	call   80105010 <initlock>
}
8010660f:	83 c4 10             	add    $0x10,%esp
80106612:	c9                   	leave  
80106613:	c3                   	ret    
80106614:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010661b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010661f:	90                   	nop

80106620 <idtinit>:

void idtinit(void) {
80106620:	f3 0f 1e fb          	endbr32 
80106624:	55                   	push   %ebp
    pd[0] = size - 1;
80106625:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010662a:	89 e5                	mov    %esp,%ebp
8010662c:	83 ec 10             	sub    $0x10,%esp
8010662f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    pd[1] = (uint)p;
80106633:	b8 40 63 11 80       	mov    $0x80116340,%eax
80106638:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    pd[2] = (uint)p >> 16;
8010663c:	c1 e8 10             	shr    $0x10,%eax
8010663f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    asm volatile("lidt (%0)"
80106643:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106646:	0f 01 18             	lidtl  (%eax)
    lidt(idt, sizeof(idt));
}
80106649:	c9                   	leave  
8010664a:	c3                   	ret    
8010664b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010664f:	90                   	nop

80106650 <trap>:

// PAGEBREAK: 41
void trap(struct trapframe* tf) {
80106650:	f3 0f 1e fb          	endbr32 
80106654:	55                   	push   %ebp
80106655:	89 e5                	mov    %esp,%ebp
80106657:	57                   	push   %edi
80106658:	56                   	push   %esi
80106659:	53                   	push   %ebx
8010665a:	83 ec 1c             	sub    $0x1c,%esp
8010665d:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (tf->trapno == T_SYSCALL) {
80106660:	8b 43 30             	mov    0x30(%ebx),%eax
80106663:	83 f8 40             	cmp    $0x40,%eax
80106666:	0f 84 bc 01 00 00    	je     80106828 <trap+0x1d8>
        if (myproc()->killed)
            exit();
        return;
    }

    switch (tf->trapno) {
8010666c:	83 e8 20             	sub    $0x20,%eax
8010666f:	83 f8 1f             	cmp    $0x1f,%eax
80106672:	77 08                	ja     8010667c <trap+0x2c>
80106674:	3e ff 24 85 ec 86 10 	notrack jmp *-0x7fef7914(,%eax,4)
8010667b:	80 
        lapiceoi();
        break;

    // PAGEBREAK: 13
    default:
        if (myproc() == 0 || (tf->cs & 3) == 0) {
8010667c:	e8 7f de ff ff       	call   80104500 <myproc>
80106681:	8b 7b 38             	mov    0x38(%ebx),%edi
80106684:	85 c0                	test   %eax,%eax
80106686:	0f 84 eb 01 00 00    	je     80106877 <trap+0x227>
8010668c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106690:	0f 84 e1 01 00 00    	je     80106877 <trap+0x227>
}

static inline uint
rcr2(void) {
    uint val;
    asm volatile("movl %%cr2,%0"
80106696:	0f 20 d1             	mov    %cr2,%ecx
80106699:	89 4d d8             	mov    %ecx,-0x28(%ebp)
            cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                    tf->trapno, cpuid(), tf->eip, rcr2());
            panic("trap");
        }
        // In user space, assume process misbehaved.
        cprintf(
8010669c:	e8 3f de ff ff       	call   801044e0 <cpuid>
801066a1:	8b 73 30             	mov    0x30(%ebx),%esi
801066a4:	89 45 dc             	mov    %eax,-0x24(%ebp)
801066a7:	8b 43 34             	mov    0x34(%ebx),%eax
801066aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801066ad:	e8 4e de ff ff       	call   80104500 <myproc>
801066b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801066b5:	e8 46 de ff ff       	call   80104500 <myproc>
        cprintf(
801066ba:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801066bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801066c0:	51                   	push   %ecx
801066c1:	57                   	push   %edi
801066c2:	52                   	push   %edx
801066c3:	ff 75 e4             	pushl  -0x1c(%ebp)
801066c6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801066c7:	8b 75 e0             	mov    -0x20(%ebp),%esi
801066ca:	83 c6 6c             	add    $0x6c,%esi
        cprintf(
801066cd:	56                   	push   %esi
801066ce:	ff 70 10             	pushl  0x10(%eax)
801066d1:	68 a8 86 10 80       	push   $0x801086a8
801066d6:	e8 e5 a0 ff ff       	call   801007c0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
        myproc()->killed = 1;
801066db:	83 c4 20             	add    $0x20,%esp
801066de:	e8 1d de ff ff       	call   80104500 <myproc>
801066e3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801066ea:	e8 11 de ff ff       	call   80104500 <myproc>
801066ef:	85 c0                	test   %eax,%eax
801066f1:	74 1d                	je     80106710 <trap+0xc0>
801066f3:	e8 08 de ff ff       	call   80104500 <myproc>
801066f8:	8b 50 24             	mov    0x24(%eax),%edx
801066fb:	85 d2                	test   %edx,%edx
801066fd:	74 11                	je     80106710 <trap+0xc0>
801066ff:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106703:	83 e0 03             	and    $0x3,%eax
80106706:	66 83 f8 03          	cmp    $0x3,%ax
8010670a:	0f 84 50 01 00 00    	je     80106860 <trap+0x210>
        exit();

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if (myproc() && myproc()->state == RUNNING &&
80106710:	e8 eb dd ff ff       	call   80104500 <myproc>
80106715:	85 c0                	test   %eax,%eax
80106717:	74 0f                	je     80106728 <trap+0xd8>
80106719:	e8 e2 dd ff ff       	call   80104500 <myproc>
8010671e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106722:	0f 84 e8 00 00 00    	je     80106810 <trap+0x1c0>
        tf->trapno == T_IRQ0 + IRQ_TIMER)
        yield();

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106728:	e8 d3 dd ff ff       	call   80104500 <myproc>
8010672d:	85 c0                	test   %eax,%eax
8010672f:	74 1d                	je     8010674e <trap+0xfe>
80106731:	e8 ca dd ff ff       	call   80104500 <myproc>
80106736:	8b 40 24             	mov    0x24(%eax),%eax
80106739:	85 c0                	test   %eax,%eax
8010673b:	74 11                	je     8010674e <trap+0xfe>
8010673d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106741:	83 e0 03             	and    $0x3,%eax
80106744:	66 83 f8 03          	cmp    $0x3,%ax
80106748:	0f 84 03 01 00 00    	je     80106851 <trap+0x201>
        exit();
}
8010674e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106751:	5b                   	pop    %ebx
80106752:	5e                   	pop    %esi
80106753:	5f                   	pop    %edi
80106754:	5d                   	pop    %ebp
80106755:	c3                   	ret    
        ideintr();
80106756:	e8 25 c6 ff ff       	call   80102d80 <ideintr>
        lapiceoi();
8010675b:	e8 00 cd ff ff       	call   80103460 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106760:	e8 9b dd ff ff       	call   80104500 <myproc>
80106765:	85 c0                	test   %eax,%eax
80106767:	75 8a                	jne    801066f3 <trap+0xa3>
80106769:	eb a5                	jmp    80106710 <trap+0xc0>
        if (cpuid() == 0) {
8010676b:	e8 70 dd ff ff       	call   801044e0 <cpuid>
80106770:	85 c0                	test   %eax,%eax
80106772:	75 e7                	jne    8010675b <trap+0x10b>
            acquire(&tickslock);
80106774:	83 ec 0c             	sub    $0xc,%esp
80106777:	68 00 63 11 80       	push   $0x80116300
8010677c:	e8 0f ea ff ff       	call   80105190 <acquire>
            wakeup(&ticks);
80106781:	c7 04 24 40 6b 11 80 	movl   $0x80116b40,(%esp)
            ticks++;
80106788:	83 05 40 6b 11 80 01 	addl   $0x1,0x80116b40
            wakeup(&ticks);
8010678f:	e8 fc e4 ff ff       	call   80104c90 <wakeup>
            release(&tickslock);
80106794:	c7 04 24 00 63 11 80 	movl   $0x80116300,(%esp)
8010679b:	e8 b0 ea ff ff       	call   80105250 <release>
801067a0:	83 c4 10             	add    $0x10,%esp
        lapiceoi();
801067a3:	eb b6                	jmp    8010675b <trap+0x10b>
        kbdintr();
801067a5:	e8 76 cb ff ff       	call   80103320 <kbdintr>
        lapiceoi();
801067aa:	e8 b1 cc ff ff       	call   80103460 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801067af:	e8 4c dd ff ff       	call   80104500 <myproc>
801067b4:	85 c0                	test   %eax,%eax
801067b6:	0f 85 37 ff ff ff    	jne    801066f3 <trap+0xa3>
801067bc:	e9 4f ff ff ff       	jmp    80106710 <trap+0xc0>
        uartintr();
801067c1:	e8 4a 02 00 00       	call   80106a10 <uartintr>
        lapiceoi();
801067c6:	e8 95 cc ff ff       	call   80103460 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801067cb:	e8 30 dd ff ff       	call   80104500 <myproc>
801067d0:	85 c0                	test   %eax,%eax
801067d2:	0f 85 1b ff ff ff    	jne    801066f3 <trap+0xa3>
801067d8:	e9 33 ff ff ff       	jmp    80106710 <trap+0xc0>
        cprintf("cpu%d: spurious interrupt at %x:%x\n",
801067dd:	8b 7b 38             	mov    0x38(%ebx),%edi
801067e0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801067e4:	e8 f7 dc ff ff       	call   801044e0 <cpuid>
801067e9:	57                   	push   %edi
801067ea:	56                   	push   %esi
801067eb:	50                   	push   %eax
801067ec:	68 50 86 10 80       	push   $0x80108650
801067f1:	e8 ca 9f ff ff       	call   801007c0 <cprintf>
        lapiceoi();
801067f6:	e8 65 cc ff ff       	call   80103460 <lapiceoi>
        break;
801067fb:	83 c4 10             	add    $0x10,%esp
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801067fe:	e8 fd dc ff ff       	call   80104500 <myproc>
80106803:	85 c0                	test   %eax,%eax
80106805:	0f 85 e8 fe ff ff    	jne    801066f3 <trap+0xa3>
8010680b:	e9 00 ff ff ff       	jmp    80106710 <trap+0xc0>
    if (myproc() && myproc()->state == RUNNING &&
80106810:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106814:	0f 85 0e ff ff ff    	jne    80106728 <trap+0xd8>
        yield();
8010681a:	e8 61 e2 ff ff       	call   80104a80 <yield>
8010681f:	e9 04 ff ff ff       	jmp    80106728 <trap+0xd8>
80106824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (myproc()->killed)
80106828:	e8 d3 dc ff ff       	call   80104500 <myproc>
8010682d:	8b 70 24             	mov    0x24(%eax),%esi
80106830:	85 f6                	test   %esi,%esi
80106832:	75 3c                	jne    80106870 <trap+0x220>
        myproc()->tf = tf;
80106834:	e8 c7 dc ff ff       	call   80104500 <myproc>
80106839:	89 58 18             	mov    %ebx,0x18(%eax)
        syscall();
8010683c:	e8 2f ee ff ff       	call   80105670 <syscall>
        if (myproc()->killed)
80106841:	e8 ba dc ff ff       	call   80104500 <myproc>
80106846:	8b 48 24             	mov    0x24(%eax),%ecx
80106849:	85 c9                	test   %ecx,%ecx
8010684b:	0f 84 fd fe ff ff    	je     8010674e <trap+0xfe>
}
80106851:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106854:	5b                   	pop    %ebx
80106855:	5e                   	pop    %esi
80106856:	5f                   	pop    %edi
80106857:	5d                   	pop    %ebp
            exit();
80106858:	e9 e3 e0 ff ff       	jmp    80104940 <exit>
8010685d:	8d 76 00             	lea    0x0(%esi),%esi
        exit();
80106860:	e8 db e0 ff ff       	call   80104940 <exit>
80106865:	e9 a6 fe ff ff       	jmp    80106710 <trap+0xc0>
8010686a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            exit();
80106870:	e8 cb e0 ff ff       	call   80104940 <exit>
80106875:	eb bd                	jmp    80106834 <trap+0x1e4>
80106877:	0f 20 d6             	mov    %cr2,%esi
            cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010687a:	e8 61 dc ff ff       	call   801044e0 <cpuid>
8010687f:	83 ec 0c             	sub    $0xc,%esp
80106882:	56                   	push   %esi
80106883:	57                   	push   %edi
80106884:	50                   	push   %eax
80106885:	ff 73 30             	pushl  0x30(%ebx)
80106888:	68 74 86 10 80       	push   $0x80108674
8010688d:	e8 2e 9f ff ff       	call   801007c0 <cprintf>
            panic("trap");
80106892:	83 c4 14             	add    $0x14,%esp
80106895:	68 48 86 10 80       	push   $0x80108648
8010689a:	e8 f1 9a ff ff       	call   80100390 <panic>
8010689f:	90                   	nop

801068a0 <uartgetc>:
        microdelay(10);
    outb(COM1 + 0, c);
}

static int
uartgetc(void) {
801068a0:	f3 0f 1e fb          	endbr32 
    if (!uart)
801068a4:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
801068a9:	85 c0                	test   %eax,%eax
801068ab:	74 1b                	je     801068c8 <uartgetc+0x28>
    asm volatile("in %1,%0"
801068ad:	ba fd 03 00 00       	mov    $0x3fd,%edx
801068b2:	ec                   	in     (%dx),%al
        return -1;
    if (!(inb(COM1 + 5) & 0x01))
801068b3:	a8 01                	test   $0x1,%al
801068b5:	74 11                	je     801068c8 <uartgetc+0x28>
801068b7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801068bc:	ec                   	in     (%dx),%al
        return -1;
    return inb(COM1 + 0);
801068bd:	0f b6 c0             	movzbl %al,%eax
801068c0:	c3                   	ret    
801068c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
801068c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068cd:	c3                   	ret    
801068ce:	66 90                	xchg   %ax,%ax

801068d0 <uartputc.part.0>:
void uartputc(int c) {
801068d0:	55                   	push   %ebp
801068d1:	89 e5                	mov    %esp,%ebp
801068d3:	57                   	push   %edi
801068d4:	89 c7                	mov    %eax,%edi
801068d6:	56                   	push   %esi
801068d7:	be fd 03 00 00       	mov    $0x3fd,%esi
801068dc:	53                   	push   %ebx
801068dd:	bb 80 00 00 00       	mov    $0x80,%ebx
801068e2:	83 ec 0c             	sub    $0xc,%esp
801068e5:	eb 1b                	jmp    80106902 <uartputc.part.0+0x32>
801068e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068ee:	66 90                	xchg   %ax,%ax
        microdelay(10);
801068f0:	83 ec 0c             	sub    $0xc,%esp
801068f3:	6a 0a                	push   $0xa
801068f5:	e8 86 cb ff ff       	call   80103480 <microdelay>
    for (i = 0; i < 128 && !(inb(COM1 + 5) & 0x20); i++)
801068fa:	83 c4 10             	add    $0x10,%esp
801068fd:	83 eb 01             	sub    $0x1,%ebx
80106900:	74 07                	je     80106909 <uartputc.part.0+0x39>
80106902:	89 f2                	mov    %esi,%edx
80106904:	ec                   	in     (%dx),%al
80106905:	a8 20                	test   $0x20,%al
80106907:	74 e7                	je     801068f0 <uartputc.part.0+0x20>
    asm volatile("out %0,%1"
80106909:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010690e:	89 f8                	mov    %edi,%eax
80106910:	ee                   	out    %al,(%dx)
}
80106911:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106914:	5b                   	pop    %ebx
80106915:	5e                   	pop    %esi
80106916:	5f                   	pop    %edi
80106917:	5d                   	pop    %ebp
80106918:	c3                   	ret    
80106919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106920 <uartinit>:
void uartinit(void) {
80106920:	f3 0f 1e fb          	endbr32 
80106924:	55                   	push   %ebp
80106925:	31 c9                	xor    %ecx,%ecx
80106927:	89 c8                	mov    %ecx,%eax
80106929:	89 e5                	mov    %esp,%ebp
8010692b:	57                   	push   %edi
8010692c:	56                   	push   %esi
8010692d:	53                   	push   %ebx
8010692e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106933:	89 da                	mov    %ebx,%edx
80106935:	83 ec 0c             	sub    $0xc,%esp
80106938:	ee                   	out    %al,(%dx)
80106939:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010693e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106943:	89 fa                	mov    %edi,%edx
80106945:	ee                   	out    %al,(%dx)
80106946:	b8 0c 00 00 00       	mov    $0xc,%eax
8010694b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106950:	ee                   	out    %al,(%dx)
80106951:	be f9 03 00 00       	mov    $0x3f9,%esi
80106956:	89 c8                	mov    %ecx,%eax
80106958:	89 f2                	mov    %esi,%edx
8010695a:	ee                   	out    %al,(%dx)
8010695b:	b8 03 00 00 00       	mov    $0x3,%eax
80106960:	89 fa                	mov    %edi,%edx
80106962:	ee                   	out    %al,(%dx)
80106963:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106968:	89 c8                	mov    %ecx,%eax
8010696a:	ee                   	out    %al,(%dx)
8010696b:	b8 01 00 00 00       	mov    $0x1,%eax
80106970:	89 f2                	mov    %esi,%edx
80106972:	ee                   	out    %al,(%dx)
    asm volatile("in %1,%0"
80106973:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106978:	ec                   	in     (%dx),%al
    if (inb(COM1 + 5) == 0xFF)
80106979:	3c ff                	cmp    $0xff,%al
8010697b:	74 52                	je     801069cf <uartinit+0xaf>
    uart = 1;
8010697d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106984:	00 00 00 
80106987:	89 da                	mov    %ebx,%edx
80106989:	ec                   	in     (%dx),%al
8010698a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010698f:	ec                   	in     (%dx),%al
    ioapicenable(IRQ_COM1, 0);
80106990:	83 ec 08             	sub    $0x8,%esp
80106993:	be 76 00 00 00       	mov    $0x76,%esi
    for (p = "xv6...\n"; *p; p++)
80106998:	bb 6c 87 10 80       	mov    $0x8010876c,%ebx
    ioapicenable(IRQ_COM1, 0);
8010699d:	6a 00                	push   $0x0
8010699f:	6a 04                	push   $0x4
801069a1:	e8 2a c6 ff ff       	call   80102fd0 <ioapicenable>
801069a6:	83 c4 10             	add    $0x10,%esp
    for (p = "xv6...\n"; *p; p++)
801069a9:	b8 78 00 00 00       	mov    $0x78,%eax
801069ae:	eb 04                	jmp    801069b4 <uartinit+0x94>
801069b0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
    if (!uart)
801069b4:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
801069ba:	85 d2                	test   %edx,%edx
801069bc:	74 08                	je     801069c6 <uartinit+0xa6>
        uartputc(*p);
801069be:	0f be c0             	movsbl %al,%eax
801069c1:	e8 0a ff ff ff       	call   801068d0 <uartputc.part.0>
    for (p = "xv6...\n"; *p; p++)
801069c6:	89 f0                	mov    %esi,%eax
801069c8:	83 c3 01             	add    $0x1,%ebx
801069cb:	84 c0                	test   %al,%al
801069cd:	75 e1                	jne    801069b0 <uartinit+0x90>
}
801069cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069d2:	5b                   	pop    %ebx
801069d3:	5e                   	pop    %esi
801069d4:	5f                   	pop    %edi
801069d5:	5d                   	pop    %ebp
801069d6:	c3                   	ret    
801069d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069de:	66 90                	xchg   %ax,%ax

801069e0 <uartputc>:
void uartputc(int c) {
801069e0:	f3 0f 1e fb          	endbr32 
801069e4:	55                   	push   %ebp
    if (!uart)
801069e5:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
void uartputc(int c) {
801069eb:	89 e5                	mov    %esp,%ebp
801069ed:	8b 45 08             	mov    0x8(%ebp),%eax
    if (!uart)
801069f0:	85 d2                	test   %edx,%edx
801069f2:	74 0c                	je     80106a00 <uartputc+0x20>
}
801069f4:	5d                   	pop    %ebp
801069f5:	e9 d6 fe ff ff       	jmp    801068d0 <uartputc.part.0>
801069fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a00:	5d                   	pop    %ebp
80106a01:	c3                   	ret    
80106a02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a10 <uartintr>:

void uartintr(void) {
80106a10:	f3 0f 1e fb          	endbr32 
80106a14:	55                   	push   %ebp
80106a15:	89 e5                	mov    %esp,%ebp
80106a17:	83 ec 14             	sub    $0x14,%esp
    consoleintr(uartgetc);
80106a1a:	68 a0 68 10 80       	push   $0x801068a0
80106a1f:	e8 ac 9f ff ff       	call   801009d0 <consoleintr>
}
80106a24:	83 c4 10             	add    $0x10,%esp
80106a27:	c9                   	leave  
80106a28:	c3                   	ret    

80106a29 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106a29:	6a 00                	push   $0x0
  pushl $0
80106a2b:	6a 00                	push   $0x0
  jmp alltraps
80106a2d:	e9 47 fb ff ff       	jmp    80106579 <alltraps>

80106a32 <vector1>:
.globl vector1
vector1:
  pushl $0
80106a32:	6a 00                	push   $0x0
  pushl $1
80106a34:	6a 01                	push   $0x1
  jmp alltraps
80106a36:	e9 3e fb ff ff       	jmp    80106579 <alltraps>

80106a3b <vector2>:
.globl vector2
vector2:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $2
80106a3d:	6a 02                	push   $0x2
  jmp alltraps
80106a3f:	e9 35 fb ff ff       	jmp    80106579 <alltraps>

80106a44 <vector3>:
.globl vector3
vector3:
  pushl $0
80106a44:	6a 00                	push   $0x0
  pushl $3
80106a46:	6a 03                	push   $0x3
  jmp alltraps
80106a48:	e9 2c fb ff ff       	jmp    80106579 <alltraps>

80106a4d <vector4>:
.globl vector4
vector4:
  pushl $0
80106a4d:	6a 00                	push   $0x0
  pushl $4
80106a4f:	6a 04                	push   $0x4
  jmp alltraps
80106a51:	e9 23 fb ff ff       	jmp    80106579 <alltraps>

80106a56 <vector5>:
.globl vector5
vector5:
  pushl $0
80106a56:	6a 00                	push   $0x0
  pushl $5
80106a58:	6a 05                	push   $0x5
  jmp alltraps
80106a5a:	e9 1a fb ff ff       	jmp    80106579 <alltraps>

80106a5f <vector6>:
.globl vector6
vector6:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $6
80106a61:	6a 06                	push   $0x6
  jmp alltraps
80106a63:	e9 11 fb ff ff       	jmp    80106579 <alltraps>

80106a68 <vector7>:
.globl vector7
vector7:
  pushl $0
80106a68:	6a 00                	push   $0x0
  pushl $7
80106a6a:	6a 07                	push   $0x7
  jmp alltraps
80106a6c:	e9 08 fb ff ff       	jmp    80106579 <alltraps>

80106a71 <vector8>:
.globl vector8
vector8:
  pushl $8
80106a71:	6a 08                	push   $0x8
  jmp alltraps
80106a73:	e9 01 fb ff ff       	jmp    80106579 <alltraps>

80106a78 <vector9>:
.globl vector9
vector9:
  pushl $0
80106a78:	6a 00                	push   $0x0
  pushl $9
80106a7a:	6a 09                	push   $0x9
  jmp alltraps
80106a7c:	e9 f8 fa ff ff       	jmp    80106579 <alltraps>

80106a81 <vector10>:
.globl vector10
vector10:
  pushl $10
80106a81:	6a 0a                	push   $0xa
  jmp alltraps
80106a83:	e9 f1 fa ff ff       	jmp    80106579 <alltraps>

80106a88 <vector11>:
.globl vector11
vector11:
  pushl $11
80106a88:	6a 0b                	push   $0xb
  jmp alltraps
80106a8a:	e9 ea fa ff ff       	jmp    80106579 <alltraps>

80106a8f <vector12>:
.globl vector12
vector12:
  pushl $12
80106a8f:	6a 0c                	push   $0xc
  jmp alltraps
80106a91:	e9 e3 fa ff ff       	jmp    80106579 <alltraps>

80106a96 <vector13>:
.globl vector13
vector13:
  pushl $13
80106a96:	6a 0d                	push   $0xd
  jmp alltraps
80106a98:	e9 dc fa ff ff       	jmp    80106579 <alltraps>

80106a9d <vector14>:
.globl vector14
vector14:
  pushl $14
80106a9d:	6a 0e                	push   $0xe
  jmp alltraps
80106a9f:	e9 d5 fa ff ff       	jmp    80106579 <alltraps>

80106aa4 <vector15>:
.globl vector15
vector15:
  pushl $0
80106aa4:	6a 00                	push   $0x0
  pushl $15
80106aa6:	6a 0f                	push   $0xf
  jmp alltraps
80106aa8:	e9 cc fa ff ff       	jmp    80106579 <alltraps>

80106aad <vector16>:
.globl vector16
vector16:
  pushl $0
80106aad:	6a 00                	push   $0x0
  pushl $16
80106aaf:	6a 10                	push   $0x10
  jmp alltraps
80106ab1:	e9 c3 fa ff ff       	jmp    80106579 <alltraps>

80106ab6 <vector17>:
.globl vector17
vector17:
  pushl $17
80106ab6:	6a 11                	push   $0x11
  jmp alltraps
80106ab8:	e9 bc fa ff ff       	jmp    80106579 <alltraps>

80106abd <vector18>:
.globl vector18
vector18:
  pushl $0
80106abd:	6a 00                	push   $0x0
  pushl $18
80106abf:	6a 12                	push   $0x12
  jmp alltraps
80106ac1:	e9 b3 fa ff ff       	jmp    80106579 <alltraps>

80106ac6 <vector19>:
.globl vector19
vector19:
  pushl $0
80106ac6:	6a 00                	push   $0x0
  pushl $19
80106ac8:	6a 13                	push   $0x13
  jmp alltraps
80106aca:	e9 aa fa ff ff       	jmp    80106579 <alltraps>

80106acf <vector20>:
.globl vector20
vector20:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $20
80106ad1:	6a 14                	push   $0x14
  jmp alltraps
80106ad3:	e9 a1 fa ff ff       	jmp    80106579 <alltraps>

80106ad8 <vector21>:
.globl vector21
vector21:
  pushl $0
80106ad8:	6a 00                	push   $0x0
  pushl $21
80106ada:	6a 15                	push   $0x15
  jmp alltraps
80106adc:	e9 98 fa ff ff       	jmp    80106579 <alltraps>

80106ae1 <vector22>:
.globl vector22
vector22:
  pushl $0
80106ae1:	6a 00                	push   $0x0
  pushl $22
80106ae3:	6a 16                	push   $0x16
  jmp alltraps
80106ae5:	e9 8f fa ff ff       	jmp    80106579 <alltraps>

80106aea <vector23>:
.globl vector23
vector23:
  pushl $0
80106aea:	6a 00                	push   $0x0
  pushl $23
80106aec:	6a 17                	push   $0x17
  jmp alltraps
80106aee:	e9 86 fa ff ff       	jmp    80106579 <alltraps>

80106af3 <vector24>:
.globl vector24
vector24:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $24
80106af5:	6a 18                	push   $0x18
  jmp alltraps
80106af7:	e9 7d fa ff ff       	jmp    80106579 <alltraps>

80106afc <vector25>:
.globl vector25
vector25:
  pushl $0
80106afc:	6a 00                	push   $0x0
  pushl $25
80106afe:	6a 19                	push   $0x19
  jmp alltraps
80106b00:	e9 74 fa ff ff       	jmp    80106579 <alltraps>

80106b05 <vector26>:
.globl vector26
vector26:
  pushl $0
80106b05:	6a 00                	push   $0x0
  pushl $26
80106b07:	6a 1a                	push   $0x1a
  jmp alltraps
80106b09:	e9 6b fa ff ff       	jmp    80106579 <alltraps>

80106b0e <vector27>:
.globl vector27
vector27:
  pushl $0
80106b0e:	6a 00                	push   $0x0
  pushl $27
80106b10:	6a 1b                	push   $0x1b
  jmp alltraps
80106b12:	e9 62 fa ff ff       	jmp    80106579 <alltraps>

80106b17 <vector28>:
.globl vector28
vector28:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $28
80106b19:	6a 1c                	push   $0x1c
  jmp alltraps
80106b1b:	e9 59 fa ff ff       	jmp    80106579 <alltraps>

80106b20 <vector29>:
.globl vector29
vector29:
  pushl $0
80106b20:	6a 00                	push   $0x0
  pushl $29
80106b22:	6a 1d                	push   $0x1d
  jmp alltraps
80106b24:	e9 50 fa ff ff       	jmp    80106579 <alltraps>

80106b29 <vector30>:
.globl vector30
vector30:
  pushl $0
80106b29:	6a 00                	push   $0x0
  pushl $30
80106b2b:	6a 1e                	push   $0x1e
  jmp alltraps
80106b2d:	e9 47 fa ff ff       	jmp    80106579 <alltraps>

80106b32 <vector31>:
.globl vector31
vector31:
  pushl $0
80106b32:	6a 00                	push   $0x0
  pushl $31
80106b34:	6a 1f                	push   $0x1f
  jmp alltraps
80106b36:	e9 3e fa ff ff       	jmp    80106579 <alltraps>

80106b3b <vector32>:
.globl vector32
vector32:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $32
80106b3d:	6a 20                	push   $0x20
  jmp alltraps
80106b3f:	e9 35 fa ff ff       	jmp    80106579 <alltraps>

80106b44 <vector33>:
.globl vector33
vector33:
  pushl $0
80106b44:	6a 00                	push   $0x0
  pushl $33
80106b46:	6a 21                	push   $0x21
  jmp alltraps
80106b48:	e9 2c fa ff ff       	jmp    80106579 <alltraps>

80106b4d <vector34>:
.globl vector34
vector34:
  pushl $0
80106b4d:	6a 00                	push   $0x0
  pushl $34
80106b4f:	6a 22                	push   $0x22
  jmp alltraps
80106b51:	e9 23 fa ff ff       	jmp    80106579 <alltraps>

80106b56 <vector35>:
.globl vector35
vector35:
  pushl $0
80106b56:	6a 00                	push   $0x0
  pushl $35
80106b58:	6a 23                	push   $0x23
  jmp alltraps
80106b5a:	e9 1a fa ff ff       	jmp    80106579 <alltraps>

80106b5f <vector36>:
.globl vector36
vector36:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $36
80106b61:	6a 24                	push   $0x24
  jmp alltraps
80106b63:	e9 11 fa ff ff       	jmp    80106579 <alltraps>

80106b68 <vector37>:
.globl vector37
vector37:
  pushl $0
80106b68:	6a 00                	push   $0x0
  pushl $37
80106b6a:	6a 25                	push   $0x25
  jmp alltraps
80106b6c:	e9 08 fa ff ff       	jmp    80106579 <alltraps>

80106b71 <vector38>:
.globl vector38
vector38:
  pushl $0
80106b71:	6a 00                	push   $0x0
  pushl $38
80106b73:	6a 26                	push   $0x26
  jmp alltraps
80106b75:	e9 ff f9 ff ff       	jmp    80106579 <alltraps>

80106b7a <vector39>:
.globl vector39
vector39:
  pushl $0
80106b7a:	6a 00                	push   $0x0
  pushl $39
80106b7c:	6a 27                	push   $0x27
  jmp alltraps
80106b7e:	e9 f6 f9 ff ff       	jmp    80106579 <alltraps>

80106b83 <vector40>:
.globl vector40
vector40:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $40
80106b85:	6a 28                	push   $0x28
  jmp alltraps
80106b87:	e9 ed f9 ff ff       	jmp    80106579 <alltraps>

80106b8c <vector41>:
.globl vector41
vector41:
  pushl $0
80106b8c:	6a 00                	push   $0x0
  pushl $41
80106b8e:	6a 29                	push   $0x29
  jmp alltraps
80106b90:	e9 e4 f9 ff ff       	jmp    80106579 <alltraps>

80106b95 <vector42>:
.globl vector42
vector42:
  pushl $0
80106b95:	6a 00                	push   $0x0
  pushl $42
80106b97:	6a 2a                	push   $0x2a
  jmp alltraps
80106b99:	e9 db f9 ff ff       	jmp    80106579 <alltraps>

80106b9e <vector43>:
.globl vector43
vector43:
  pushl $0
80106b9e:	6a 00                	push   $0x0
  pushl $43
80106ba0:	6a 2b                	push   $0x2b
  jmp alltraps
80106ba2:	e9 d2 f9 ff ff       	jmp    80106579 <alltraps>

80106ba7 <vector44>:
.globl vector44
vector44:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $44
80106ba9:	6a 2c                	push   $0x2c
  jmp alltraps
80106bab:	e9 c9 f9 ff ff       	jmp    80106579 <alltraps>

80106bb0 <vector45>:
.globl vector45
vector45:
  pushl $0
80106bb0:	6a 00                	push   $0x0
  pushl $45
80106bb2:	6a 2d                	push   $0x2d
  jmp alltraps
80106bb4:	e9 c0 f9 ff ff       	jmp    80106579 <alltraps>

80106bb9 <vector46>:
.globl vector46
vector46:
  pushl $0
80106bb9:	6a 00                	push   $0x0
  pushl $46
80106bbb:	6a 2e                	push   $0x2e
  jmp alltraps
80106bbd:	e9 b7 f9 ff ff       	jmp    80106579 <alltraps>

80106bc2 <vector47>:
.globl vector47
vector47:
  pushl $0
80106bc2:	6a 00                	push   $0x0
  pushl $47
80106bc4:	6a 2f                	push   $0x2f
  jmp alltraps
80106bc6:	e9 ae f9 ff ff       	jmp    80106579 <alltraps>

80106bcb <vector48>:
.globl vector48
vector48:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $48
80106bcd:	6a 30                	push   $0x30
  jmp alltraps
80106bcf:	e9 a5 f9 ff ff       	jmp    80106579 <alltraps>

80106bd4 <vector49>:
.globl vector49
vector49:
  pushl $0
80106bd4:	6a 00                	push   $0x0
  pushl $49
80106bd6:	6a 31                	push   $0x31
  jmp alltraps
80106bd8:	e9 9c f9 ff ff       	jmp    80106579 <alltraps>

80106bdd <vector50>:
.globl vector50
vector50:
  pushl $0
80106bdd:	6a 00                	push   $0x0
  pushl $50
80106bdf:	6a 32                	push   $0x32
  jmp alltraps
80106be1:	e9 93 f9 ff ff       	jmp    80106579 <alltraps>

80106be6 <vector51>:
.globl vector51
vector51:
  pushl $0
80106be6:	6a 00                	push   $0x0
  pushl $51
80106be8:	6a 33                	push   $0x33
  jmp alltraps
80106bea:	e9 8a f9 ff ff       	jmp    80106579 <alltraps>

80106bef <vector52>:
.globl vector52
vector52:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $52
80106bf1:	6a 34                	push   $0x34
  jmp alltraps
80106bf3:	e9 81 f9 ff ff       	jmp    80106579 <alltraps>

80106bf8 <vector53>:
.globl vector53
vector53:
  pushl $0
80106bf8:	6a 00                	push   $0x0
  pushl $53
80106bfa:	6a 35                	push   $0x35
  jmp alltraps
80106bfc:	e9 78 f9 ff ff       	jmp    80106579 <alltraps>

80106c01 <vector54>:
.globl vector54
vector54:
  pushl $0
80106c01:	6a 00                	push   $0x0
  pushl $54
80106c03:	6a 36                	push   $0x36
  jmp alltraps
80106c05:	e9 6f f9 ff ff       	jmp    80106579 <alltraps>

80106c0a <vector55>:
.globl vector55
vector55:
  pushl $0
80106c0a:	6a 00                	push   $0x0
  pushl $55
80106c0c:	6a 37                	push   $0x37
  jmp alltraps
80106c0e:	e9 66 f9 ff ff       	jmp    80106579 <alltraps>

80106c13 <vector56>:
.globl vector56
vector56:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $56
80106c15:	6a 38                	push   $0x38
  jmp alltraps
80106c17:	e9 5d f9 ff ff       	jmp    80106579 <alltraps>

80106c1c <vector57>:
.globl vector57
vector57:
  pushl $0
80106c1c:	6a 00                	push   $0x0
  pushl $57
80106c1e:	6a 39                	push   $0x39
  jmp alltraps
80106c20:	e9 54 f9 ff ff       	jmp    80106579 <alltraps>

80106c25 <vector58>:
.globl vector58
vector58:
  pushl $0
80106c25:	6a 00                	push   $0x0
  pushl $58
80106c27:	6a 3a                	push   $0x3a
  jmp alltraps
80106c29:	e9 4b f9 ff ff       	jmp    80106579 <alltraps>

80106c2e <vector59>:
.globl vector59
vector59:
  pushl $0
80106c2e:	6a 00                	push   $0x0
  pushl $59
80106c30:	6a 3b                	push   $0x3b
  jmp alltraps
80106c32:	e9 42 f9 ff ff       	jmp    80106579 <alltraps>

80106c37 <vector60>:
.globl vector60
vector60:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $60
80106c39:	6a 3c                	push   $0x3c
  jmp alltraps
80106c3b:	e9 39 f9 ff ff       	jmp    80106579 <alltraps>

80106c40 <vector61>:
.globl vector61
vector61:
  pushl $0
80106c40:	6a 00                	push   $0x0
  pushl $61
80106c42:	6a 3d                	push   $0x3d
  jmp alltraps
80106c44:	e9 30 f9 ff ff       	jmp    80106579 <alltraps>

80106c49 <vector62>:
.globl vector62
vector62:
  pushl $0
80106c49:	6a 00                	push   $0x0
  pushl $62
80106c4b:	6a 3e                	push   $0x3e
  jmp alltraps
80106c4d:	e9 27 f9 ff ff       	jmp    80106579 <alltraps>

80106c52 <vector63>:
.globl vector63
vector63:
  pushl $0
80106c52:	6a 00                	push   $0x0
  pushl $63
80106c54:	6a 3f                	push   $0x3f
  jmp alltraps
80106c56:	e9 1e f9 ff ff       	jmp    80106579 <alltraps>

80106c5b <vector64>:
.globl vector64
vector64:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $64
80106c5d:	6a 40                	push   $0x40
  jmp alltraps
80106c5f:	e9 15 f9 ff ff       	jmp    80106579 <alltraps>

80106c64 <vector65>:
.globl vector65
vector65:
  pushl $0
80106c64:	6a 00                	push   $0x0
  pushl $65
80106c66:	6a 41                	push   $0x41
  jmp alltraps
80106c68:	e9 0c f9 ff ff       	jmp    80106579 <alltraps>

80106c6d <vector66>:
.globl vector66
vector66:
  pushl $0
80106c6d:	6a 00                	push   $0x0
  pushl $66
80106c6f:	6a 42                	push   $0x42
  jmp alltraps
80106c71:	e9 03 f9 ff ff       	jmp    80106579 <alltraps>

80106c76 <vector67>:
.globl vector67
vector67:
  pushl $0
80106c76:	6a 00                	push   $0x0
  pushl $67
80106c78:	6a 43                	push   $0x43
  jmp alltraps
80106c7a:	e9 fa f8 ff ff       	jmp    80106579 <alltraps>

80106c7f <vector68>:
.globl vector68
vector68:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $68
80106c81:	6a 44                	push   $0x44
  jmp alltraps
80106c83:	e9 f1 f8 ff ff       	jmp    80106579 <alltraps>

80106c88 <vector69>:
.globl vector69
vector69:
  pushl $0
80106c88:	6a 00                	push   $0x0
  pushl $69
80106c8a:	6a 45                	push   $0x45
  jmp alltraps
80106c8c:	e9 e8 f8 ff ff       	jmp    80106579 <alltraps>

80106c91 <vector70>:
.globl vector70
vector70:
  pushl $0
80106c91:	6a 00                	push   $0x0
  pushl $70
80106c93:	6a 46                	push   $0x46
  jmp alltraps
80106c95:	e9 df f8 ff ff       	jmp    80106579 <alltraps>

80106c9a <vector71>:
.globl vector71
vector71:
  pushl $0
80106c9a:	6a 00                	push   $0x0
  pushl $71
80106c9c:	6a 47                	push   $0x47
  jmp alltraps
80106c9e:	e9 d6 f8 ff ff       	jmp    80106579 <alltraps>

80106ca3 <vector72>:
.globl vector72
vector72:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $72
80106ca5:	6a 48                	push   $0x48
  jmp alltraps
80106ca7:	e9 cd f8 ff ff       	jmp    80106579 <alltraps>

80106cac <vector73>:
.globl vector73
vector73:
  pushl $0
80106cac:	6a 00                	push   $0x0
  pushl $73
80106cae:	6a 49                	push   $0x49
  jmp alltraps
80106cb0:	e9 c4 f8 ff ff       	jmp    80106579 <alltraps>

80106cb5 <vector74>:
.globl vector74
vector74:
  pushl $0
80106cb5:	6a 00                	push   $0x0
  pushl $74
80106cb7:	6a 4a                	push   $0x4a
  jmp alltraps
80106cb9:	e9 bb f8 ff ff       	jmp    80106579 <alltraps>

80106cbe <vector75>:
.globl vector75
vector75:
  pushl $0
80106cbe:	6a 00                	push   $0x0
  pushl $75
80106cc0:	6a 4b                	push   $0x4b
  jmp alltraps
80106cc2:	e9 b2 f8 ff ff       	jmp    80106579 <alltraps>

80106cc7 <vector76>:
.globl vector76
vector76:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $76
80106cc9:	6a 4c                	push   $0x4c
  jmp alltraps
80106ccb:	e9 a9 f8 ff ff       	jmp    80106579 <alltraps>

80106cd0 <vector77>:
.globl vector77
vector77:
  pushl $0
80106cd0:	6a 00                	push   $0x0
  pushl $77
80106cd2:	6a 4d                	push   $0x4d
  jmp alltraps
80106cd4:	e9 a0 f8 ff ff       	jmp    80106579 <alltraps>

80106cd9 <vector78>:
.globl vector78
vector78:
  pushl $0
80106cd9:	6a 00                	push   $0x0
  pushl $78
80106cdb:	6a 4e                	push   $0x4e
  jmp alltraps
80106cdd:	e9 97 f8 ff ff       	jmp    80106579 <alltraps>

80106ce2 <vector79>:
.globl vector79
vector79:
  pushl $0
80106ce2:	6a 00                	push   $0x0
  pushl $79
80106ce4:	6a 4f                	push   $0x4f
  jmp alltraps
80106ce6:	e9 8e f8 ff ff       	jmp    80106579 <alltraps>

80106ceb <vector80>:
.globl vector80
vector80:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $80
80106ced:	6a 50                	push   $0x50
  jmp alltraps
80106cef:	e9 85 f8 ff ff       	jmp    80106579 <alltraps>

80106cf4 <vector81>:
.globl vector81
vector81:
  pushl $0
80106cf4:	6a 00                	push   $0x0
  pushl $81
80106cf6:	6a 51                	push   $0x51
  jmp alltraps
80106cf8:	e9 7c f8 ff ff       	jmp    80106579 <alltraps>

80106cfd <vector82>:
.globl vector82
vector82:
  pushl $0
80106cfd:	6a 00                	push   $0x0
  pushl $82
80106cff:	6a 52                	push   $0x52
  jmp alltraps
80106d01:	e9 73 f8 ff ff       	jmp    80106579 <alltraps>

80106d06 <vector83>:
.globl vector83
vector83:
  pushl $0
80106d06:	6a 00                	push   $0x0
  pushl $83
80106d08:	6a 53                	push   $0x53
  jmp alltraps
80106d0a:	e9 6a f8 ff ff       	jmp    80106579 <alltraps>

80106d0f <vector84>:
.globl vector84
vector84:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $84
80106d11:	6a 54                	push   $0x54
  jmp alltraps
80106d13:	e9 61 f8 ff ff       	jmp    80106579 <alltraps>

80106d18 <vector85>:
.globl vector85
vector85:
  pushl $0
80106d18:	6a 00                	push   $0x0
  pushl $85
80106d1a:	6a 55                	push   $0x55
  jmp alltraps
80106d1c:	e9 58 f8 ff ff       	jmp    80106579 <alltraps>

80106d21 <vector86>:
.globl vector86
vector86:
  pushl $0
80106d21:	6a 00                	push   $0x0
  pushl $86
80106d23:	6a 56                	push   $0x56
  jmp alltraps
80106d25:	e9 4f f8 ff ff       	jmp    80106579 <alltraps>

80106d2a <vector87>:
.globl vector87
vector87:
  pushl $0
80106d2a:	6a 00                	push   $0x0
  pushl $87
80106d2c:	6a 57                	push   $0x57
  jmp alltraps
80106d2e:	e9 46 f8 ff ff       	jmp    80106579 <alltraps>

80106d33 <vector88>:
.globl vector88
vector88:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $88
80106d35:	6a 58                	push   $0x58
  jmp alltraps
80106d37:	e9 3d f8 ff ff       	jmp    80106579 <alltraps>

80106d3c <vector89>:
.globl vector89
vector89:
  pushl $0
80106d3c:	6a 00                	push   $0x0
  pushl $89
80106d3e:	6a 59                	push   $0x59
  jmp alltraps
80106d40:	e9 34 f8 ff ff       	jmp    80106579 <alltraps>

80106d45 <vector90>:
.globl vector90
vector90:
  pushl $0
80106d45:	6a 00                	push   $0x0
  pushl $90
80106d47:	6a 5a                	push   $0x5a
  jmp alltraps
80106d49:	e9 2b f8 ff ff       	jmp    80106579 <alltraps>

80106d4e <vector91>:
.globl vector91
vector91:
  pushl $0
80106d4e:	6a 00                	push   $0x0
  pushl $91
80106d50:	6a 5b                	push   $0x5b
  jmp alltraps
80106d52:	e9 22 f8 ff ff       	jmp    80106579 <alltraps>

80106d57 <vector92>:
.globl vector92
vector92:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $92
80106d59:	6a 5c                	push   $0x5c
  jmp alltraps
80106d5b:	e9 19 f8 ff ff       	jmp    80106579 <alltraps>

80106d60 <vector93>:
.globl vector93
vector93:
  pushl $0
80106d60:	6a 00                	push   $0x0
  pushl $93
80106d62:	6a 5d                	push   $0x5d
  jmp alltraps
80106d64:	e9 10 f8 ff ff       	jmp    80106579 <alltraps>

80106d69 <vector94>:
.globl vector94
vector94:
  pushl $0
80106d69:	6a 00                	push   $0x0
  pushl $94
80106d6b:	6a 5e                	push   $0x5e
  jmp alltraps
80106d6d:	e9 07 f8 ff ff       	jmp    80106579 <alltraps>

80106d72 <vector95>:
.globl vector95
vector95:
  pushl $0
80106d72:	6a 00                	push   $0x0
  pushl $95
80106d74:	6a 5f                	push   $0x5f
  jmp alltraps
80106d76:	e9 fe f7 ff ff       	jmp    80106579 <alltraps>

80106d7b <vector96>:
.globl vector96
vector96:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $96
80106d7d:	6a 60                	push   $0x60
  jmp alltraps
80106d7f:	e9 f5 f7 ff ff       	jmp    80106579 <alltraps>

80106d84 <vector97>:
.globl vector97
vector97:
  pushl $0
80106d84:	6a 00                	push   $0x0
  pushl $97
80106d86:	6a 61                	push   $0x61
  jmp alltraps
80106d88:	e9 ec f7 ff ff       	jmp    80106579 <alltraps>

80106d8d <vector98>:
.globl vector98
vector98:
  pushl $0
80106d8d:	6a 00                	push   $0x0
  pushl $98
80106d8f:	6a 62                	push   $0x62
  jmp alltraps
80106d91:	e9 e3 f7 ff ff       	jmp    80106579 <alltraps>

80106d96 <vector99>:
.globl vector99
vector99:
  pushl $0
80106d96:	6a 00                	push   $0x0
  pushl $99
80106d98:	6a 63                	push   $0x63
  jmp alltraps
80106d9a:	e9 da f7 ff ff       	jmp    80106579 <alltraps>

80106d9f <vector100>:
.globl vector100
vector100:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $100
80106da1:	6a 64                	push   $0x64
  jmp alltraps
80106da3:	e9 d1 f7 ff ff       	jmp    80106579 <alltraps>

80106da8 <vector101>:
.globl vector101
vector101:
  pushl $0
80106da8:	6a 00                	push   $0x0
  pushl $101
80106daa:	6a 65                	push   $0x65
  jmp alltraps
80106dac:	e9 c8 f7 ff ff       	jmp    80106579 <alltraps>

80106db1 <vector102>:
.globl vector102
vector102:
  pushl $0
80106db1:	6a 00                	push   $0x0
  pushl $102
80106db3:	6a 66                	push   $0x66
  jmp alltraps
80106db5:	e9 bf f7 ff ff       	jmp    80106579 <alltraps>

80106dba <vector103>:
.globl vector103
vector103:
  pushl $0
80106dba:	6a 00                	push   $0x0
  pushl $103
80106dbc:	6a 67                	push   $0x67
  jmp alltraps
80106dbe:	e9 b6 f7 ff ff       	jmp    80106579 <alltraps>

80106dc3 <vector104>:
.globl vector104
vector104:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $104
80106dc5:	6a 68                	push   $0x68
  jmp alltraps
80106dc7:	e9 ad f7 ff ff       	jmp    80106579 <alltraps>

80106dcc <vector105>:
.globl vector105
vector105:
  pushl $0
80106dcc:	6a 00                	push   $0x0
  pushl $105
80106dce:	6a 69                	push   $0x69
  jmp alltraps
80106dd0:	e9 a4 f7 ff ff       	jmp    80106579 <alltraps>

80106dd5 <vector106>:
.globl vector106
vector106:
  pushl $0
80106dd5:	6a 00                	push   $0x0
  pushl $106
80106dd7:	6a 6a                	push   $0x6a
  jmp alltraps
80106dd9:	e9 9b f7 ff ff       	jmp    80106579 <alltraps>

80106dde <vector107>:
.globl vector107
vector107:
  pushl $0
80106dde:	6a 00                	push   $0x0
  pushl $107
80106de0:	6a 6b                	push   $0x6b
  jmp alltraps
80106de2:	e9 92 f7 ff ff       	jmp    80106579 <alltraps>

80106de7 <vector108>:
.globl vector108
vector108:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $108
80106de9:	6a 6c                	push   $0x6c
  jmp alltraps
80106deb:	e9 89 f7 ff ff       	jmp    80106579 <alltraps>

80106df0 <vector109>:
.globl vector109
vector109:
  pushl $0
80106df0:	6a 00                	push   $0x0
  pushl $109
80106df2:	6a 6d                	push   $0x6d
  jmp alltraps
80106df4:	e9 80 f7 ff ff       	jmp    80106579 <alltraps>

80106df9 <vector110>:
.globl vector110
vector110:
  pushl $0
80106df9:	6a 00                	push   $0x0
  pushl $110
80106dfb:	6a 6e                	push   $0x6e
  jmp alltraps
80106dfd:	e9 77 f7 ff ff       	jmp    80106579 <alltraps>

80106e02 <vector111>:
.globl vector111
vector111:
  pushl $0
80106e02:	6a 00                	push   $0x0
  pushl $111
80106e04:	6a 6f                	push   $0x6f
  jmp alltraps
80106e06:	e9 6e f7 ff ff       	jmp    80106579 <alltraps>

80106e0b <vector112>:
.globl vector112
vector112:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $112
80106e0d:	6a 70                	push   $0x70
  jmp alltraps
80106e0f:	e9 65 f7 ff ff       	jmp    80106579 <alltraps>

80106e14 <vector113>:
.globl vector113
vector113:
  pushl $0
80106e14:	6a 00                	push   $0x0
  pushl $113
80106e16:	6a 71                	push   $0x71
  jmp alltraps
80106e18:	e9 5c f7 ff ff       	jmp    80106579 <alltraps>

80106e1d <vector114>:
.globl vector114
vector114:
  pushl $0
80106e1d:	6a 00                	push   $0x0
  pushl $114
80106e1f:	6a 72                	push   $0x72
  jmp alltraps
80106e21:	e9 53 f7 ff ff       	jmp    80106579 <alltraps>

80106e26 <vector115>:
.globl vector115
vector115:
  pushl $0
80106e26:	6a 00                	push   $0x0
  pushl $115
80106e28:	6a 73                	push   $0x73
  jmp alltraps
80106e2a:	e9 4a f7 ff ff       	jmp    80106579 <alltraps>

80106e2f <vector116>:
.globl vector116
vector116:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $116
80106e31:	6a 74                	push   $0x74
  jmp alltraps
80106e33:	e9 41 f7 ff ff       	jmp    80106579 <alltraps>

80106e38 <vector117>:
.globl vector117
vector117:
  pushl $0
80106e38:	6a 00                	push   $0x0
  pushl $117
80106e3a:	6a 75                	push   $0x75
  jmp alltraps
80106e3c:	e9 38 f7 ff ff       	jmp    80106579 <alltraps>

80106e41 <vector118>:
.globl vector118
vector118:
  pushl $0
80106e41:	6a 00                	push   $0x0
  pushl $118
80106e43:	6a 76                	push   $0x76
  jmp alltraps
80106e45:	e9 2f f7 ff ff       	jmp    80106579 <alltraps>

80106e4a <vector119>:
.globl vector119
vector119:
  pushl $0
80106e4a:	6a 00                	push   $0x0
  pushl $119
80106e4c:	6a 77                	push   $0x77
  jmp alltraps
80106e4e:	e9 26 f7 ff ff       	jmp    80106579 <alltraps>

80106e53 <vector120>:
.globl vector120
vector120:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $120
80106e55:	6a 78                	push   $0x78
  jmp alltraps
80106e57:	e9 1d f7 ff ff       	jmp    80106579 <alltraps>

80106e5c <vector121>:
.globl vector121
vector121:
  pushl $0
80106e5c:	6a 00                	push   $0x0
  pushl $121
80106e5e:	6a 79                	push   $0x79
  jmp alltraps
80106e60:	e9 14 f7 ff ff       	jmp    80106579 <alltraps>

80106e65 <vector122>:
.globl vector122
vector122:
  pushl $0
80106e65:	6a 00                	push   $0x0
  pushl $122
80106e67:	6a 7a                	push   $0x7a
  jmp alltraps
80106e69:	e9 0b f7 ff ff       	jmp    80106579 <alltraps>

80106e6e <vector123>:
.globl vector123
vector123:
  pushl $0
80106e6e:	6a 00                	push   $0x0
  pushl $123
80106e70:	6a 7b                	push   $0x7b
  jmp alltraps
80106e72:	e9 02 f7 ff ff       	jmp    80106579 <alltraps>

80106e77 <vector124>:
.globl vector124
vector124:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $124
80106e79:	6a 7c                	push   $0x7c
  jmp alltraps
80106e7b:	e9 f9 f6 ff ff       	jmp    80106579 <alltraps>

80106e80 <vector125>:
.globl vector125
vector125:
  pushl $0
80106e80:	6a 00                	push   $0x0
  pushl $125
80106e82:	6a 7d                	push   $0x7d
  jmp alltraps
80106e84:	e9 f0 f6 ff ff       	jmp    80106579 <alltraps>

80106e89 <vector126>:
.globl vector126
vector126:
  pushl $0
80106e89:	6a 00                	push   $0x0
  pushl $126
80106e8b:	6a 7e                	push   $0x7e
  jmp alltraps
80106e8d:	e9 e7 f6 ff ff       	jmp    80106579 <alltraps>

80106e92 <vector127>:
.globl vector127
vector127:
  pushl $0
80106e92:	6a 00                	push   $0x0
  pushl $127
80106e94:	6a 7f                	push   $0x7f
  jmp alltraps
80106e96:	e9 de f6 ff ff       	jmp    80106579 <alltraps>

80106e9b <vector128>:
.globl vector128
vector128:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $128
80106e9d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106ea2:	e9 d2 f6 ff ff       	jmp    80106579 <alltraps>

80106ea7 <vector129>:
.globl vector129
vector129:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $129
80106ea9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106eae:	e9 c6 f6 ff ff       	jmp    80106579 <alltraps>

80106eb3 <vector130>:
.globl vector130
vector130:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $130
80106eb5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106eba:	e9 ba f6 ff ff       	jmp    80106579 <alltraps>

80106ebf <vector131>:
.globl vector131
vector131:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $131
80106ec1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106ec6:	e9 ae f6 ff ff       	jmp    80106579 <alltraps>

80106ecb <vector132>:
.globl vector132
vector132:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $132
80106ecd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106ed2:	e9 a2 f6 ff ff       	jmp    80106579 <alltraps>

80106ed7 <vector133>:
.globl vector133
vector133:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $133
80106ed9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106ede:	e9 96 f6 ff ff       	jmp    80106579 <alltraps>

80106ee3 <vector134>:
.globl vector134
vector134:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $134
80106ee5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106eea:	e9 8a f6 ff ff       	jmp    80106579 <alltraps>

80106eef <vector135>:
.globl vector135
vector135:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $135
80106ef1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106ef6:	e9 7e f6 ff ff       	jmp    80106579 <alltraps>

80106efb <vector136>:
.globl vector136
vector136:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $136
80106efd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106f02:	e9 72 f6 ff ff       	jmp    80106579 <alltraps>

80106f07 <vector137>:
.globl vector137
vector137:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $137
80106f09:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106f0e:	e9 66 f6 ff ff       	jmp    80106579 <alltraps>

80106f13 <vector138>:
.globl vector138
vector138:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $138
80106f15:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106f1a:	e9 5a f6 ff ff       	jmp    80106579 <alltraps>

80106f1f <vector139>:
.globl vector139
vector139:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $139
80106f21:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106f26:	e9 4e f6 ff ff       	jmp    80106579 <alltraps>

80106f2b <vector140>:
.globl vector140
vector140:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $140
80106f2d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106f32:	e9 42 f6 ff ff       	jmp    80106579 <alltraps>

80106f37 <vector141>:
.globl vector141
vector141:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $141
80106f39:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106f3e:	e9 36 f6 ff ff       	jmp    80106579 <alltraps>

80106f43 <vector142>:
.globl vector142
vector142:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $142
80106f45:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106f4a:	e9 2a f6 ff ff       	jmp    80106579 <alltraps>

80106f4f <vector143>:
.globl vector143
vector143:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $143
80106f51:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106f56:	e9 1e f6 ff ff       	jmp    80106579 <alltraps>

80106f5b <vector144>:
.globl vector144
vector144:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $144
80106f5d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106f62:	e9 12 f6 ff ff       	jmp    80106579 <alltraps>

80106f67 <vector145>:
.globl vector145
vector145:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $145
80106f69:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106f6e:	e9 06 f6 ff ff       	jmp    80106579 <alltraps>

80106f73 <vector146>:
.globl vector146
vector146:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $146
80106f75:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106f7a:	e9 fa f5 ff ff       	jmp    80106579 <alltraps>

80106f7f <vector147>:
.globl vector147
vector147:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $147
80106f81:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106f86:	e9 ee f5 ff ff       	jmp    80106579 <alltraps>

80106f8b <vector148>:
.globl vector148
vector148:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $148
80106f8d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106f92:	e9 e2 f5 ff ff       	jmp    80106579 <alltraps>

80106f97 <vector149>:
.globl vector149
vector149:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $149
80106f99:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106f9e:	e9 d6 f5 ff ff       	jmp    80106579 <alltraps>

80106fa3 <vector150>:
.globl vector150
vector150:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $150
80106fa5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106faa:	e9 ca f5 ff ff       	jmp    80106579 <alltraps>

80106faf <vector151>:
.globl vector151
vector151:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $151
80106fb1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106fb6:	e9 be f5 ff ff       	jmp    80106579 <alltraps>

80106fbb <vector152>:
.globl vector152
vector152:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $152
80106fbd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106fc2:	e9 b2 f5 ff ff       	jmp    80106579 <alltraps>

80106fc7 <vector153>:
.globl vector153
vector153:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $153
80106fc9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106fce:	e9 a6 f5 ff ff       	jmp    80106579 <alltraps>

80106fd3 <vector154>:
.globl vector154
vector154:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $154
80106fd5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106fda:	e9 9a f5 ff ff       	jmp    80106579 <alltraps>

80106fdf <vector155>:
.globl vector155
vector155:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $155
80106fe1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106fe6:	e9 8e f5 ff ff       	jmp    80106579 <alltraps>

80106feb <vector156>:
.globl vector156
vector156:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $156
80106fed:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106ff2:	e9 82 f5 ff ff       	jmp    80106579 <alltraps>

80106ff7 <vector157>:
.globl vector157
vector157:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $157
80106ff9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106ffe:	e9 76 f5 ff ff       	jmp    80106579 <alltraps>

80107003 <vector158>:
.globl vector158
vector158:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $158
80107005:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010700a:	e9 6a f5 ff ff       	jmp    80106579 <alltraps>

8010700f <vector159>:
.globl vector159
vector159:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $159
80107011:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107016:	e9 5e f5 ff ff       	jmp    80106579 <alltraps>

8010701b <vector160>:
.globl vector160
vector160:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $160
8010701d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107022:	e9 52 f5 ff ff       	jmp    80106579 <alltraps>

80107027 <vector161>:
.globl vector161
vector161:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $161
80107029:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010702e:	e9 46 f5 ff ff       	jmp    80106579 <alltraps>

80107033 <vector162>:
.globl vector162
vector162:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $162
80107035:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010703a:	e9 3a f5 ff ff       	jmp    80106579 <alltraps>

8010703f <vector163>:
.globl vector163
vector163:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $163
80107041:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107046:	e9 2e f5 ff ff       	jmp    80106579 <alltraps>

8010704b <vector164>:
.globl vector164
vector164:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $164
8010704d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107052:	e9 22 f5 ff ff       	jmp    80106579 <alltraps>

80107057 <vector165>:
.globl vector165
vector165:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $165
80107059:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010705e:	e9 16 f5 ff ff       	jmp    80106579 <alltraps>

80107063 <vector166>:
.globl vector166
vector166:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $166
80107065:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010706a:	e9 0a f5 ff ff       	jmp    80106579 <alltraps>

8010706f <vector167>:
.globl vector167
vector167:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $167
80107071:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107076:	e9 fe f4 ff ff       	jmp    80106579 <alltraps>

8010707b <vector168>:
.globl vector168
vector168:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $168
8010707d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107082:	e9 f2 f4 ff ff       	jmp    80106579 <alltraps>

80107087 <vector169>:
.globl vector169
vector169:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $169
80107089:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010708e:	e9 e6 f4 ff ff       	jmp    80106579 <alltraps>

80107093 <vector170>:
.globl vector170
vector170:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $170
80107095:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010709a:	e9 da f4 ff ff       	jmp    80106579 <alltraps>

8010709f <vector171>:
.globl vector171
vector171:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $171
801070a1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801070a6:	e9 ce f4 ff ff       	jmp    80106579 <alltraps>

801070ab <vector172>:
.globl vector172
vector172:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $172
801070ad:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801070b2:	e9 c2 f4 ff ff       	jmp    80106579 <alltraps>

801070b7 <vector173>:
.globl vector173
vector173:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $173
801070b9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801070be:	e9 b6 f4 ff ff       	jmp    80106579 <alltraps>

801070c3 <vector174>:
.globl vector174
vector174:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $174
801070c5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801070ca:	e9 aa f4 ff ff       	jmp    80106579 <alltraps>

801070cf <vector175>:
.globl vector175
vector175:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $175
801070d1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801070d6:	e9 9e f4 ff ff       	jmp    80106579 <alltraps>

801070db <vector176>:
.globl vector176
vector176:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $176
801070dd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801070e2:	e9 92 f4 ff ff       	jmp    80106579 <alltraps>

801070e7 <vector177>:
.globl vector177
vector177:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $177
801070e9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801070ee:	e9 86 f4 ff ff       	jmp    80106579 <alltraps>

801070f3 <vector178>:
.globl vector178
vector178:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $178
801070f5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801070fa:	e9 7a f4 ff ff       	jmp    80106579 <alltraps>

801070ff <vector179>:
.globl vector179
vector179:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $179
80107101:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107106:	e9 6e f4 ff ff       	jmp    80106579 <alltraps>

8010710b <vector180>:
.globl vector180
vector180:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $180
8010710d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107112:	e9 62 f4 ff ff       	jmp    80106579 <alltraps>

80107117 <vector181>:
.globl vector181
vector181:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $181
80107119:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010711e:	e9 56 f4 ff ff       	jmp    80106579 <alltraps>

80107123 <vector182>:
.globl vector182
vector182:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $182
80107125:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010712a:	e9 4a f4 ff ff       	jmp    80106579 <alltraps>

8010712f <vector183>:
.globl vector183
vector183:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $183
80107131:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107136:	e9 3e f4 ff ff       	jmp    80106579 <alltraps>

8010713b <vector184>:
.globl vector184
vector184:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $184
8010713d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107142:	e9 32 f4 ff ff       	jmp    80106579 <alltraps>

80107147 <vector185>:
.globl vector185
vector185:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $185
80107149:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010714e:	e9 26 f4 ff ff       	jmp    80106579 <alltraps>

80107153 <vector186>:
.globl vector186
vector186:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $186
80107155:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010715a:	e9 1a f4 ff ff       	jmp    80106579 <alltraps>

8010715f <vector187>:
.globl vector187
vector187:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $187
80107161:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107166:	e9 0e f4 ff ff       	jmp    80106579 <alltraps>

8010716b <vector188>:
.globl vector188
vector188:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $188
8010716d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107172:	e9 02 f4 ff ff       	jmp    80106579 <alltraps>

80107177 <vector189>:
.globl vector189
vector189:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $189
80107179:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010717e:	e9 f6 f3 ff ff       	jmp    80106579 <alltraps>

80107183 <vector190>:
.globl vector190
vector190:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $190
80107185:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010718a:	e9 ea f3 ff ff       	jmp    80106579 <alltraps>

8010718f <vector191>:
.globl vector191
vector191:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $191
80107191:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107196:	e9 de f3 ff ff       	jmp    80106579 <alltraps>

8010719b <vector192>:
.globl vector192
vector192:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $192
8010719d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801071a2:	e9 d2 f3 ff ff       	jmp    80106579 <alltraps>

801071a7 <vector193>:
.globl vector193
vector193:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $193
801071a9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801071ae:	e9 c6 f3 ff ff       	jmp    80106579 <alltraps>

801071b3 <vector194>:
.globl vector194
vector194:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $194
801071b5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801071ba:	e9 ba f3 ff ff       	jmp    80106579 <alltraps>

801071bf <vector195>:
.globl vector195
vector195:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $195
801071c1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801071c6:	e9 ae f3 ff ff       	jmp    80106579 <alltraps>

801071cb <vector196>:
.globl vector196
vector196:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $196
801071cd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801071d2:	e9 a2 f3 ff ff       	jmp    80106579 <alltraps>

801071d7 <vector197>:
.globl vector197
vector197:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $197
801071d9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801071de:	e9 96 f3 ff ff       	jmp    80106579 <alltraps>

801071e3 <vector198>:
.globl vector198
vector198:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $198
801071e5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801071ea:	e9 8a f3 ff ff       	jmp    80106579 <alltraps>

801071ef <vector199>:
.globl vector199
vector199:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $199
801071f1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801071f6:	e9 7e f3 ff ff       	jmp    80106579 <alltraps>

801071fb <vector200>:
.globl vector200
vector200:
  pushl $0
801071fb:	6a 00                	push   $0x0
  pushl $200
801071fd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107202:	e9 72 f3 ff ff       	jmp    80106579 <alltraps>

80107207 <vector201>:
.globl vector201
vector201:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $201
80107209:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010720e:	e9 66 f3 ff ff       	jmp    80106579 <alltraps>

80107213 <vector202>:
.globl vector202
vector202:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $202
80107215:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010721a:	e9 5a f3 ff ff       	jmp    80106579 <alltraps>

8010721f <vector203>:
.globl vector203
vector203:
  pushl $0
8010721f:	6a 00                	push   $0x0
  pushl $203
80107221:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107226:	e9 4e f3 ff ff       	jmp    80106579 <alltraps>

8010722b <vector204>:
.globl vector204
vector204:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $204
8010722d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107232:	e9 42 f3 ff ff       	jmp    80106579 <alltraps>

80107237 <vector205>:
.globl vector205
vector205:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $205
80107239:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010723e:	e9 36 f3 ff ff       	jmp    80106579 <alltraps>

80107243 <vector206>:
.globl vector206
vector206:
  pushl $0
80107243:	6a 00                	push   $0x0
  pushl $206
80107245:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010724a:	e9 2a f3 ff ff       	jmp    80106579 <alltraps>

8010724f <vector207>:
.globl vector207
vector207:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $207
80107251:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107256:	e9 1e f3 ff ff       	jmp    80106579 <alltraps>

8010725b <vector208>:
.globl vector208
vector208:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $208
8010725d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107262:	e9 12 f3 ff ff       	jmp    80106579 <alltraps>

80107267 <vector209>:
.globl vector209
vector209:
  pushl $0
80107267:	6a 00                	push   $0x0
  pushl $209
80107269:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010726e:	e9 06 f3 ff ff       	jmp    80106579 <alltraps>

80107273 <vector210>:
.globl vector210
vector210:
  pushl $0
80107273:	6a 00                	push   $0x0
  pushl $210
80107275:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010727a:	e9 fa f2 ff ff       	jmp    80106579 <alltraps>

8010727f <vector211>:
.globl vector211
vector211:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $211
80107281:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107286:	e9 ee f2 ff ff       	jmp    80106579 <alltraps>

8010728b <vector212>:
.globl vector212
vector212:
  pushl $0
8010728b:	6a 00                	push   $0x0
  pushl $212
8010728d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107292:	e9 e2 f2 ff ff       	jmp    80106579 <alltraps>

80107297 <vector213>:
.globl vector213
vector213:
  pushl $0
80107297:	6a 00                	push   $0x0
  pushl $213
80107299:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010729e:	e9 d6 f2 ff ff       	jmp    80106579 <alltraps>

801072a3 <vector214>:
.globl vector214
vector214:
  pushl $0
801072a3:	6a 00                	push   $0x0
  pushl $214
801072a5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801072aa:	e9 ca f2 ff ff       	jmp    80106579 <alltraps>

801072af <vector215>:
.globl vector215
vector215:
  pushl $0
801072af:	6a 00                	push   $0x0
  pushl $215
801072b1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801072b6:	e9 be f2 ff ff       	jmp    80106579 <alltraps>

801072bb <vector216>:
.globl vector216
vector216:
  pushl $0
801072bb:	6a 00                	push   $0x0
  pushl $216
801072bd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801072c2:	e9 b2 f2 ff ff       	jmp    80106579 <alltraps>

801072c7 <vector217>:
.globl vector217
vector217:
  pushl $0
801072c7:	6a 00                	push   $0x0
  pushl $217
801072c9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801072ce:	e9 a6 f2 ff ff       	jmp    80106579 <alltraps>

801072d3 <vector218>:
.globl vector218
vector218:
  pushl $0
801072d3:	6a 00                	push   $0x0
  pushl $218
801072d5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801072da:	e9 9a f2 ff ff       	jmp    80106579 <alltraps>

801072df <vector219>:
.globl vector219
vector219:
  pushl $0
801072df:	6a 00                	push   $0x0
  pushl $219
801072e1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801072e6:	e9 8e f2 ff ff       	jmp    80106579 <alltraps>

801072eb <vector220>:
.globl vector220
vector220:
  pushl $0
801072eb:	6a 00                	push   $0x0
  pushl $220
801072ed:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801072f2:	e9 82 f2 ff ff       	jmp    80106579 <alltraps>

801072f7 <vector221>:
.globl vector221
vector221:
  pushl $0
801072f7:	6a 00                	push   $0x0
  pushl $221
801072f9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801072fe:	e9 76 f2 ff ff       	jmp    80106579 <alltraps>

80107303 <vector222>:
.globl vector222
vector222:
  pushl $0
80107303:	6a 00                	push   $0x0
  pushl $222
80107305:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010730a:	e9 6a f2 ff ff       	jmp    80106579 <alltraps>

8010730f <vector223>:
.globl vector223
vector223:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $223
80107311:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107316:	e9 5e f2 ff ff       	jmp    80106579 <alltraps>

8010731b <vector224>:
.globl vector224
vector224:
  pushl $0
8010731b:	6a 00                	push   $0x0
  pushl $224
8010731d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107322:	e9 52 f2 ff ff       	jmp    80106579 <alltraps>

80107327 <vector225>:
.globl vector225
vector225:
  pushl $0
80107327:	6a 00                	push   $0x0
  pushl $225
80107329:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010732e:	e9 46 f2 ff ff       	jmp    80106579 <alltraps>

80107333 <vector226>:
.globl vector226
vector226:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $226
80107335:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010733a:	e9 3a f2 ff ff       	jmp    80106579 <alltraps>

8010733f <vector227>:
.globl vector227
vector227:
  pushl $0
8010733f:	6a 00                	push   $0x0
  pushl $227
80107341:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107346:	e9 2e f2 ff ff       	jmp    80106579 <alltraps>

8010734b <vector228>:
.globl vector228
vector228:
  pushl $0
8010734b:	6a 00                	push   $0x0
  pushl $228
8010734d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107352:	e9 22 f2 ff ff       	jmp    80106579 <alltraps>

80107357 <vector229>:
.globl vector229
vector229:
  pushl $0
80107357:	6a 00                	push   $0x0
  pushl $229
80107359:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010735e:	e9 16 f2 ff ff       	jmp    80106579 <alltraps>

80107363 <vector230>:
.globl vector230
vector230:
  pushl $0
80107363:	6a 00                	push   $0x0
  pushl $230
80107365:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010736a:	e9 0a f2 ff ff       	jmp    80106579 <alltraps>

8010736f <vector231>:
.globl vector231
vector231:
  pushl $0
8010736f:	6a 00                	push   $0x0
  pushl $231
80107371:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107376:	e9 fe f1 ff ff       	jmp    80106579 <alltraps>

8010737b <vector232>:
.globl vector232
vector232:
  pushl $0
8010737b:	6a 00                	push   $0x0
  pushl $232
8010737d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107382:	e9 f2 f1 ff ff       	jmp    80106579 <alltraps>

80107387 <vector233>:
.globl vector233
vector233:
  pushl $0
80107387:	6a 00                	push   $0x0
  pushl $233
80107389:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010738e:	e9 e6 f1 ff ff       	jmp    80106579 <alltraps>

80107393 <vector234>:
.globl vector234
vector234:
  pushl $0
80107393:	6a 00                	push   $0x0
  pushl $234
80107395:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010739a:	e9 da f1 ff ff       	jmp    80106579 <alltraps>

8010739f <vector235>:
.globl vector235
vector235:
  pushl $0
8010739f:	6a 00                	push   $0x0
  pushl $235
801073a1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801073a6:	e9 ce f1 ff ff       	jmp    80106579 <alltraps>

801073ab <vector236>:
.globl vector236
vector236:
  pushl $0
801073ab:	6a 00                	push   $0x0
  pushl $236
801073ad:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801073b2:	e9 c2 f1 ff ff       	jmp    80106579 <alltraps>

801073b7 <vector237>:
.globl vector237
vector237:
  pushl $0
801073b7:	6a 00                	push   $0x0
  pushl $237
801073b9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801073be:	e9 b6 f1 ff ff       	jmp    80106579 <alltraps>

801073c3 <vector238>:
.globl vector238
vector238:
  pushl $0
801073c3:	6a 00                	push   $0x0
  pushl $238
801073c5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801073ca:	e9 aa f1 ff ff       	jmp    80106579 <alltraps>

801073cf <vector239>:
.globl vector239
vector239:
  pushl $0
801073cf:	6a 00                	push   $0x0
  pushl $239
801073d1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801073d6:	e9 9e f1 ff ff       	jmp    80106579 <alltraps>

801073db <vector240>:
.globl vector240
vector240:
  pushl $0
801073db:	6a 00                	push   $0x0
  pushl $240
801073dd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801073e2:	e9 92 f1 ff ff       	jmp    80106579 <alltraps>

801073e7 <vector241>:
.globl vector241
vector241:
  pushl $0
801073e7:	6a 00                	push   $0x0
  pushl $241
801073e9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801073ee:	e9 86 f1 ff ff       	jmp    80106579 <alltraps>

801073f3 <vector242>:
.globl vector242
vector242:
  pushl $0
801073f3:	6a 00                	push   $0x0
  pushl $242
801073f5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801073fa:	e9 7a f1 ff ff       	jmp    80106579 <alltraps>

801073ff <vector243>:
.globl vector243
vector243:
  pushl $0
801073ff:	6a 00                	push   $0x0
  pushl $243
80107401:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107406:	e9 6e f1 ff ff       	jmp    80106579 <alltraps>

8010740b <vector244>:
.globl vector244
vector244:
  pushl $0
8010740b:	6a 00                	push   $0x0
  pushl $244
8010740d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107412:	e9 62 f1 ff ff       	jmp    80106579 <alltraps>

80107417 <vector245>:
.globl vector245
vector245:
  pushl $0
80107417:	6a 00                	push   $0x0
  pushl $245
80107419:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010741e:	e9 56 f1 ff ff       	jmp    80106579 <alltraps>

80107423 <vector246>:
.globl vector246
vector246:
  pushl $0
80107423:	6a 00                	push   $0x0
  pushl $246
80107425:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010742a:	e9 4a f1 ff ff       	jmp    80106579 <alltraps>

8010742f <vector247>:
.globl vector247
vector247:
  pushl $0
8010742f:	6a 00                	push   $0x0
  pushl $247
80107431:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107436:	e9 3e f1 ff ff       	jmp    80106579 <alltraps>

8010743b <vector248>:
.globl vector248
vector248:
  pushl $0
8010743b:	6a 00                	push   $0x0
  pushl $248
8010743d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107442:	e9 32 f1 ff ff       	jmp    80106579 <alltraps>

80107447 <vector249>:
.globl vector249
vector249:
  pushl $0
80107447:	6a 00                	push   $0x0
  pushl $249
80107449:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010744e:	e9 26 f1 ff ff       	jmp    80106579 <alltraps>

80107453 <vector250>:
.globl vector250
vector250:
  pushl $0
80107453:	6a 00                	push   $0x0
  pushl $250
80107455:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010745a:	e9 1a f1 ff ff       	jmp    80106579 <alltraps>

8010745f <vector251>:
.globl vector251
vector251:
  pushl $0
8010745f:	6a 00                	push   $0x0
  pushl $251
80107461:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107466:	e9 0e f1 ff ff       	jmp    80106579 <alltraps>

8010746b <vector252>:
.globl vector252
vector252:
  pushl $0
8010746b:	6a 00                	push   $0x0
  pushl $252
8010746d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107472:	e9 02 f1 ff ff       	jmp    80106579 <alltraps>

80107477 <vector253>:
.globl vector253
vector253:
  pushl $0
80107477:	6a 00                	push   $0x0
  pushl $253
80107479:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010747e:	e9 f6 f0 ff ff       	jmp    80106579 <alltraps>

80107483 <vector254>:
.globl vector254
vector254:
  pushl $0
80107483:	6a 00                	push   $0x0
  pushl $254
80107485:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010748a:	e9 ea f0 ff ff       	jmp    80106579 <alltraps>

8010748f <vector255>:
.globl vector255
vector255:
  pushl $0
8010748f:	6a 00                	push   $0x0
  pushl $255
80107491:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107496:	e9 de f0 ff ff       	jmp    80106579 <alltraps>
8010749b:	66 90                	xchg   %ax,%ax
8010749d:	66 90                	xchg   %ax,%ax
8010749f:	90                   	nop

801074a0 <walkpgdir>:

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t*
walkpgdir(pde_t* pgdir, const void* va, int alloc) {
801074a0:	55                   	push   %ebp
801074a1:	89 e5                	mov    %esp,%ebp
801074a3:	57                   	push   %edi
801074a4:	56                   	push   %esi
801074a5:	89 d6                	mov    %edx,%esi
    pde_t* pde;
    pte_t* pgtab;

    pde = &pgdir[PDX(va)];
801074a7:	c1 ea 16             	shr    $0x16,%edx
walkpgdir(pde_t* pgdir, const void* va, int alloc) {
801074aa:	53                   	push   %ebx
    pde = &pgdir[PDX(va)];
801074ab:	8d 3c 90             	lea    (%eax,%edx,4),%edi
walkpgdir(pde_t* pgdir, const void* va, int alloc) {
801074ae:	83 ec 0c             	sub    $0xc,%esp
    if (*pde & PTE_P) {
801074b1:	8b 1f                	mov    (%edi),%ebx
801074b3:	f6 c3 01             	test   $0x1,%bl
801074b6:	74 28                	je     801074e0 <walkpgdir+0x40>
        pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801074be:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
        // The permissions here are overly generous, but they can
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
    return &pgtab[PTX(va)];
801074c4:	89 f0                	mov    %esi,%eax
}
801074c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return &pgtab[PTX(va)];
801074c9:	c1 e8 0a             	shr    $0xa,%eax
801074cc:	25 fc 0f 00 00       	and    $0xffc,%eax
801074d1:	01 d8                	add    %ebx,%eax
}
801074d3:	5b                   	pop    %ebx
801074d4:	5e                   	pop    %esi
801074d5:	5f                   	pop    %edi
801074d6:	5d                   	pop    %ebp
801074d7:	c3                   	ret    
801074d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074df:	90                   	nop
        if (!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801074e0:	85 c9                	test   %ecx,%ecx
801074e2:	74 2c                	je     80107510 <walkpgdir+0x70>
801074e4:	e8 e7 bc ff ff       	call   801031d0 <kalloc>
801074e9:	89 c3                	mov    %eax,%ebx
801074eb:	85 c0                	test   %eax,%eax
801074ed:	74 21                	je     80107510 <walkpgdir+0x70>
        memset(pgtab, 0, PGSIZE);
801074ef:	83 ec 04             	sub    $0x4,%esp
801074f2:	68 00 10 00 00       	push   $0x1000
801074f7:	6a 00                	push   $0x0
801074f9:	50                   	push   %eax
801074fa:	e8 a1 dd ff ff       	call   801052a0 <memset>
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801074ff:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107505:	83 c4 10             	add    $0x10,%esp
80107508:	83 c8 07             	or     $0x7,%eax
8010750b:	89 07                	mov    %eax,(%edi)
8010750d:	eb b5                	jmp    801074c4 <walkpgdir+0x24>
8010750f:	90                   	nop
}
80107510:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return 0;
80107513:	31 c0                	xor    %eax,%eax
}
80107515:	5b                   	pop    %ebx
80107516:	5e                   	pop    %esi
80107517:	5f                   	pop    %edi
80107518:	5d                   	pop    %ebp
80107519:	c3                   	ret    
8010751a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107520 <mappages>:

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t* pgdir, void* va, uint size, uint pa, int perm) {
80107520:	55                   	push   %ebp
80107521:	89 e5                	mov    %esp,%ebp
80107523:	57                   	push   %edi
80107524:	89 c7                	mov    %eax,%edi
    char *a, *last;
    pte_t* pte;

    a = (char*)PGROUNDDOWN((uint)va);
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107526:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
mappages(pde_t* pgdir, void* va, uint size, uint pa, int perm) {
8010752a:	56                   	push   %esi
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010752b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a = (char*)PGROUNDDOWN((uint)va);
80107530:	89 d6                	mov    %edx,%esi
mappages(pde_t* pgdir, void* va, uint size, uint pa, int perm) {
80107532:	53                   	push   %ebx
    a = (char*)PGROUNDDOWN((uint)va);
80107533:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
mappages(pde_t* pgdir, void* va, uint size, uint pa, int perm) {
80107539:	83 ec 1c             	sub    $0x1c,%esp
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010753c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010753f:	8b 45 08             	mov    0x8(%ebp),%eax
80107542:	29 f0                	sub    %esi,%eax
80107544:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107547:	eb 1f                	jmp    80107568 <mappages+0x48>
80107549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (;;) {
        if ((pte = walkpgdir(pgdir, a, 1)) == 0)
            return -1;
        if (*pte & PTE_P)
80107550:	f6 00 01             	testb  $0x1,(%eax)
80107553:	75 45                	jne    8010759a <mappages+0x7a>
            panic("remap");
        *pte = pa | perm | PTE_P;
80107555:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107558:	83 cb 01             	or     $0x1,%ebx
8010755b:	89 18                	mov    %ebx,(%eax)
        if (a == last)
8010755d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107560:	74 2e                	je     80107590 <mappages+0x70>
            break;
        a += PGSIZE;
80107562:	81 c6 00 10 00 00    	add    $0x1000,%esi
    for (;;) {
80107568:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        if ((pte = walkpgdir(pgdir, a, 1)) == 0)
8010756b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107570:	89 f2                	mov    %esi,%edx
80107572:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107575:	89 f8                	mov    %edi,%eax
80107577:	e8 24 ff ff ff       	call   801074a0 <walkpgdir>
8010757c:	85 c0                	test   %eax,%eax
8010757e:	75 d0                	jne    80107550 <mappages+0x30>
        pa += PGSIZE;
    }
    return 0;
}
80107580:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80107583:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107588:	5b                   	pop    %ebx
80107589:	5e                   	pop    %esi
8010758a:	5f                   	pop    %edi
8010758b:	5d                   	pop    %ebp
8010758c:	c3                   	ret    
8010758d:	8d 76 00             	lea    0x0(%esi),%esi
80107590:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107593:	31 c0                	xor    %eax,%eax
}
80107595:	5b                   	pop    %ebx
80107596:	5e                   	pop    %esi
80107597:	5f                   	pop    %edi
80107598:	5d                   	pop    %ebp
80107599:	c3                   	ret    
            panic("remap");
8010759a:	83 ec 0c             	sub    $0xc,%esp
8010759d:	68 74 87 10 80       	push   $0x80108774
801075a2:	e8 e9 8d ff ff       	call   80100390 <panic>
801075a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075ae:	66 90                	xchg   %ax,%ax

801075b0 <deallocuvm.part.0>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int deallocuvm(pde_t* pgdir, uint oldsz, uint newsz) {
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	57                   	push   %edi
801075b4:	56                   	push   %esi
801075b5:	89 c6                	mov    %eax,%esi
801075b7:	53                   	push   %ebx
801075b8:	89 d3                	mov    %edx,%ebx
    uint a, pa;

    if (newsz >= oldsz)
        return oldsz;

    a = PGROUNDUP(newsz);
801075ba:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801075c0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
int deallocuvm(pde_t* pgdir, uint oldsz, uint newsz) {
801075c6:	83 ec 1c             	sub    $0x1c,%esp
801075c9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    for (; a < oldsz; a += PGSIZE) {
801075cc:	39 da                	cmp    %ebx,%edx
801075ce:	73 5b                	jae    8010762b <deallocuvm.part.0+0x7b>
801075d0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801075d3:	89 d7                	mov    %edx,%edi
801075d5:	eb 14                	jmp    801075eb <deallocuvm.part.0+0x3b>
801075d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075de:	66 90                	xchg   %ax,%ax
801075e0:	81 c7 00 10 00 00    	add    $0x1000,%edi
801075e6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801075e9:	76 40                	jbe    8010762b <deallocuvm.part.0+0x7b>
        pte = walkpgdir(pgdir, (char*)a, 0);
801075eb:	31 c9                	xor    %ecx,%ecx
801075ed:	89 fa                	mov    %edi,%edx
801075ef:	89 f0                	mov    %esi,%eax
801075f1:	e8 aa fe ff ff       	call   801074a0 <walkpgdir>
801075f6:	89 c3                	mov    %eax,%ebx
        if (!pte)
801075f8:	85 c0                	test   %eax,%eax
801075fa:	74 44                	je     80107640 <deallocuvm.part.0+0x90>
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
        else if ((*pte & PTE_P) != 0) {
801075fc:	8b 00                	mov    (%eax),%eax
801075fe:	a8 01                	test   $0x1,%al
80107600:	74 de                	je     801075e0 <deallocuvm.part.0+0x30>
            pa = PTE_ADDR(*pte);
            if (pa == 0)
80107602:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107607:	74 47                	je     80107650 <deallocuvm.part.0+0xa0>
                panic("kfree");
            char* v = P2V(pa);
            kfree(v);
80107609:	83 ec 0c             	sub    $0xc,%esp
            char* v = P2V(pa);
8010760c:	05 00 00 00 80       	add    $0x80000000,%eax
80107611:	81 c7 00 10 00 00    	add    $0x1000,%edi
            kfree(v);
80107617:	50                   	push   %eax
80107618:	e8 f3 b9 ff ff       	call   80103010 <kfree>
            *pte = 0;
8010761d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107623:	83 c4 10             	add    $0x10,%esp
    for (; a < oldsz; a += PGSIZE) {
80107626:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107629:	77 c0                	ja     801075eb <deallocuvm.part.0+0x3b>
        }
    }
    return newsz;
}
8010762b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010762e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107631:	5b                   	pop    %ebx
80107632:	5e                   	pop    %esi
80107633:	5f                   	pop    %edi
80107634:	5d                   	pop    %ebp
80107635:	c3                   	ret    
80107636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010763d:	8d 76 00             	lea    0x0(%esi),%esi
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107640:	89 fa                	mov    %edi,%edx
80107642:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107648:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010764e:	eb 96                	jmp    801075e6 <deallocuvm.part.0+0x36>
                panic("kfree");
80107650:	83 ec 0c             	sub    $0xc,%esp
80107653:	68 9e 80 10 80       	push   $0x8010809e
80107658:	e8 33 8d ff ff       	call   80100390 <panic>
8010765d:	8d 76 00             	lea    0x0(%esi),%esi

80107660 <seginit>:
void seginit(void) {
80107660:	f3 0f 1e fb          	endbr32 
80107664:	55                   	push   %ebp
80107665:	89 e5                	mov    %esp,%ebp
80107667:	83 ec 18             	sub    $0x18,%esp
    c = &cpus[cpuid()];
8010766a:	e8 71 ce ff ff       	call   801044e0 <cpuid>
    pd[0] = size - 1;
8010766f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107674:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010767a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
    c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
8010767e:	c7 80 98 3d 11 80 ff 	movl   $0xffff,-0x7feec268(%eax)
80107685:	ff 00 00 
80107688:	c7 80 9c 3d 11 80 00 	movl   $0xcf9a00,-0x7feec264(%eax)
8010768f:	9a cf 00 
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107692:	c7 80 a0 3d 11 80 ff 	movl   $0xffff,-0x7feec260(%eax)
80107699:	ff 00 00 
8010769c:	c7 80 a4 3d 11 80 00 	movl   $0xcf9200,-0x7feec25c(%eax)
801076a3:	92 cf 00 
    c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
801076a6:	c7 80 a8 3d 11 80 ff 	movl   $0xffff,-0x7feec258(%eax)
801076ad:	ff 00 00 
801076b0:	c7 80 ac 3d 11 80 00 	movl   $0xcffa00,-0x7feec254(%eax)
801076b7:	fa cf 00 
    c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801076ba:	c7 80 b0 3d 11 80 ff 	movl   $0xffff,-0x7feec250(%eax)
801076c1:	ff 00 00 
801076c4:	c7 80 b4 3d 11 80 00 	movl   $0xcff200,-0x7feec24c(%eax)
801076cb:	f2 cf 00 
    lgdt(c->gdt, sizeof(c->gdt));
801076ce:	05 90 3d 11 80       	add    $0x80113d90,%eax
    pd[1] = (uint)p;
801076d3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
    pd[2] = (uint)p >> 16;
801076d7:	c1 e8 10             	shr    $0x10,%eax
801076da:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    asm volatile("lgdt (%0)"
801076de:	8d 45 f2             	lea    -0xe(%ebp),%eax
801076e1:	0f 01 10             	lgdtl  (%eax)
}
801076e4:	c9                   	leave  
801076e5:	c3                   	ret    
801076e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ed:	8d 76 00             	lea    0x0(%esi),%esi

801076f0 <switchkvm>:
void switchkvm(void) {
801076f0:	f3 0f 1e fb          	endbr32 
    lcr3(V2P(kpgdir)); // switch to the kernel page table
801076f4:	a1 44 6b 11 80       	mov    0x80116b44,%eax
801076f9:	05 00 00 00 80       	add    $0x80000000,%eax
    return val;
}

static inline void
lcr3(uint val) {
    asm volatile("movl %0,%%cr3"
801076fe:	0f 22 d8             	mov    %eax,%cr3
}
80107701:	c3                   	ret    
80107702:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107710 <switchuvm>:
void switchuvm(struct proc* p) {
80107710:	f3 0f 1e fb          	endbr32 
80107714:	55                   	push   %ebp
80107715:	89 e5                	mov    %esp,%ebp
80107717:	57                   	push   %edi
80107718:	56                   	push   %esi
80107719:	53                   	push   %ebx
8010771a:	83 ec 1c             	sub    $0x1c,%esp
8010771d:	8b 75 08             	mov    0x8(%ebp),%esi
    if (p == 0)
80107720:	85 f6                	test   %esi,%esi
80107722:	0f 84 cb 00 00 00    	je     801077f3 <switchuvm+0xe3>
    if (p->kstack == 0)
80107728:	8b 46 08             	mov    0x8(%esi),%eax
8010772b:	85 c0                	test   %eax,%eax
8010772d:	0f 84 da 00 00 00    	je     8010780d <switchuvm+0xfd>
    if (p->pgdir == 0)
80107733:	8b 46 04             	mov    0x4(%esi),%eax
80107736:	85 c0                	test   %eax,%eax
80107738:	0f 84 c2 00 00 00    	je     80107800 <switchuvm+0xf0>
    pushcli();
8010773e:	e8 4d d9 ff ff       	call   80105090 <pushcli>
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107743:	e8 28 cd ff ff       	call   80104470 <mycpu>
80107748:	89 c3                	mov    %eax,%ebx
8010774a:	e8 21 cd ff ff       	call   80104470 <mycpu>
8010774f:	89 c7                	mov    %eax,%edi
80107751:	e8 1a cd ff ff       	call   80104470 <mycpu>
80107756:	83 c7 08             	add    $0x8,%edi
80107759:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010775c:	e8 0f cd ff ff       	call   80104470 <mycpu>
80107761:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107764:	ba 67 00 00 00       	mov    $0x67,%edx
80107769:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107770:	83 c0 08             	add    $0x8,%eax
80107773:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
    mycpu()->ts.iomb = (ushort)0xFFFF;
8010777a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010777f:	83 c1 08             	add    $0x8,%ecx
80107782:	c1 e8 18             	shr    $0x18,%eax
80107785:	c1 e9 10             	shr    $0x10,%ecx
80107788:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010778e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107794:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107799:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
801077a0:	bb 10 00 00 00       	mov    $0x10,%ebx
    mycpu()->gdt[SEG_TSS].s = 0;
801077a5:	e8 c6 cc ff ff       	call   80104470 <mycpu>
801077aa:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
801077b1:	e8 ba cc ff ff       	call   80104470 <mycpu>
801077b6:	66 89 58 10          	mov    %bx,0x10(%eax)
    mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801077ba:	8b 5e 08             	mov    0x8(%esi),%ebx
801077bd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801077c3:	e8 a8 cc ff ff       	call   80104470 <mycpu>
801077c8:	89 58 0c             	mov    %ebx,0xc(%eax)
    mycpu()->ts.iomb = (ushort)0xFFFF;
801077cb:	e8 a0 cc ff ff       	call   80104470 <mycpu>
801077d0:	66 89 78 6e          	mov    %di,0x6e(%eax)
    asm volatile("ltr %0"
801077d4:	b8 28 00 00 00       	mov    $0x28,%eax
801077d9:	0f 00 d8             	ltr    %ax
    lcr3(V2P(p->pgdir)); // switch to process's address space
801077dc:	8b 46 04             	mov    0x4(%esi),%eax
801077df:	05 00 00 00 80       	add    $0x80000000,%eax
    asm volatile("movl %0,%%cr3"
801077e4:	0f 22 d8             	mov    %eax,%cr3
}
801077e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077ea:	5b                   	pop    %ebx
801077eb:	5e                   	pop    %esi
801077ec:	5f                   	pop    %edi
801077ed:	5d                   	pop    %ebp
    popcli();
801077ee:	e9 ed d8 ff ff       	jmp    801050e0 <popcli>
        panic("switchuvm: no process");
801077f3:	83 ec 0c             	sub    $0xc,%esp
801077f6:	68 7a 87 10 80       	push   $0x8010877a
801077fb:	e8 90 8b ff ff       	call   80100390 <panic>
        panic("switchuvm: no pgdir");
80107800:	83 ec 0c             	sub    $0xc,%esp
80107803:	68 a5 87 10 80       	push   $0x801087a5
80107808:	e8 83 8b ff ff       	call   80100390 <panic>
        panic("switchuvm: no kstack");
8010780d:	83 ec 0c             	sub    $0xc,%esp
80107810:	68 90 87 10 80       	push   $0x80108790
80107815:	e8 76 8b ff ff       	call   80100390 <panic>
8010781a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107820 <inituvm>:
void inituvm(pde_t* pgdir, char* init, uint sz) {
80107820:	f3 0f 1e fb          	endbr32 
80107824:	55                   	push   %ebp
80107825:	89 e5                	mov    %esp,%ebp
80107827:	57                   	push   %edi
80107828:	56                   	push   %esi
80107829:	53                   	push   %ebx
8010782a:	83 ec 1c             	sub    $0x1c,%esp
8010782d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107830:	8b 75 10             	mov    0x10(%ebp),%esi
80107833:	8b 7d 08             	mov    0x8(%ebp),%edi
80107836:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (sz >= PGSIZE)
80107839:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010783f:	77 4b                	ja     8010788c <inituvm+0x6c>
    mem = kalloc();
80107841:	e8 8a b9 ff ff       	call   801031d0 <kalloc>
    memset(mem, 0, PGSIZE);
80107846:	83 ec 04             	sub    $0x4,%esp
80107849:	68 00 10 00 00       	push   $0x1000
    mem = kalloc();
8010784e:	89 c3                	mov    %eax,%ebx
    memset(mem, 0, PGSIZE);
80107850:	6a 00                	push   $0x0
80107852:	50                   	push   %eax
80107853:	e8 48 da ff ff       	call   801052a0 <memset>
    mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
80107858:	58                   	pop    %eax
80107859:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010785f:	5a                   	pop    %edx
80107860:	6a 06                	push   $0x6
80107862:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107867:	31 d2                	xor    %edx,%edx
80107869:	50                   	push   %eax
8010786a:	89 f8                	mov    %edi,%eax
8010786c:	e8 af fc ff ff       	call   80107520 <mappages>
    memmove(mem, init, sz);
80107871:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107874:	89 75 10             	mov    %esi,0x10(%ebp)
80107877:	83 c4 10             	add    $0x10,%esp
8010787a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010787d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107880:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107883:	5b                   	pop    %ebx
80107884:	5e                   	pop    %esi
80107885:	5f                   	pop    %edi
80107886:	5d                   	pop    %ebp
    memmove(mem, init, sz);
80107887:	e9 b4 da ff ff       	jmp    80105340 <memmove>
        panic("inituvm: more than a page");
8010788c:	83 ec 0c             	sub    $0xc,%esp
8010788f:	68 b9 87 10 80       	push   $0x801087b9
80107894:	e8 f7 8a ff ff       	call   80100390 <panic>
80107899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801078a0 <loaduvm>:
int loaduvm(pde_t* pgdir, char* addr, struct inode* ip, uint offset, uint sz) {
801078a0:	f3 0f 1e fb          	endbr32 
801078a4:	55                   	push   %ebp
801078a5:	89 e5                	mov    %esp,%ebp
801078a7:	57                   	push   %edi
801078a8:	56                   	push   %esi
801078a9:	53                   	push   %ebx
801078aa:	83 ec 1c             	sub    $0x1c,%esp
801078ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801078b0:	8b 75 18             	mov    0x18(%ebp),%esi
    if ((uint)addr % PGSIZE != 0)
801078b3:	a9 ff 0f 00 00       	test   $0xfff,%eax
801078b8:	0f 85 99 00 00 00    	jne    80107957 <loaduvm+0xb7>
    for (i = 0; i < sz; i += PGSIZE) {
801078be:	01 f0                	add    %esi,%eax
801078c0:	89 f3                	mov    %esi,%ebx
801078c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (readi(ip, P2V(pa), offset + i, n) != n)
801078c5:	8b 45 14             	mov    0x14(%ebp),%eax
801078c8:	01 f0                	add    %esi,%eax
801078ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for (i = 0; i < sz; i += PGSIZE) {
801078cd:	85 f6                	test   %esi,%esi
801078cf:	75 15                	jne    801078e6 <loaduvm+0x46>
801078d1:	eb 6d                	jmp    80107940 <loaduvm+0xa0>
801078d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801078d7:	90                   	nop
801078d8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801078de:	89 f0                	mov    %esi,%eax
801078e0:	29 d8                	sub    %ebx,%eax
801078e2:	39 c6                	cmp    %eax,%esi
801078e4:	76 5a                	jbe    80107940 <loaduvm+0xa0>
        if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
801078e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801078e9:	8b 45 08             	mov    0x8(%ebp),%eax
801078ec:	31 c9                	xor    %ecx,%ecx
801078ee:	29 da                	sub    %ebx,%edx
801078f0:	e8 ab fb ff ff       	call   801074a0 <walkpgdir>
801078f5:	85 c0                	test   %eax,%eax
801078f7:	74 51                	je     8010794a <loaduvm+0xaa>
        pa = PTE_ADDR(*pte);
801078f9:	8b 00                	mov    (%eax),%eax
        if (readi(ip, P2V(pa), offset + i, n) != n)
801078fb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
        if (sz - i < PGSIZE)
801078fe:	bf 00 10 00 00       	mov    $0x1000,%edi
        pa = PTE_ADDR(*pte);
80107903:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        if (sz - i < PGSIZE)
80107908:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010790e:	0f 46 fb             	cmovbe %ebx,%edi
        if (readi(ip, P2V(pa), offset + i, n) != n)
80107911:	29 d9                	sub    %ebx,%ecx
80107913:	05 00 00 00 80       	add    $0x80000000,%eax
80107918:	57                   	push   %edi
80107919:	51                   	push   %ecx
8010791a:	50                   	push   %eax
8010791b:	ff 75 10             	pushl  0x10(%ebp)
8010791e:	e8 dd ac ff ff       	call   80102600 <readi>
80107923:	83 c4 10             	add    $0x10,%esp
80107926:	39 f8                	cmp    %edi,%eax
80107928:	74 ae                	je     801078d8 <loaduvm+0x38>
}
8010792a:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
8010792d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107932:	5b                   	pop    %ebx
80107933:	5e                   	pop    %esi
80107934:	5f                   	pop    %edi
80107935:	5d                   	pop    %ebp
80107936:	c3                   	ret    
80107937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010793e:	66 90                	xchg   %ax,%ax
80107940:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107943:	31 c0                	xor    %eax,%eax
}
80107945:	5b                   	pop    %ebx
80107946:	5e                   	pop    %esi
80107947:	5f                   	pop    %edi
80107948:	5d                   	pop    %ebp
80107949:	c3                   	ret    
            panic("loaduvm: address should exist");
8010794a:	83 ec 0c             	sub    $0xc,%esp
8010794d:	68 d3 87 10 80       	push   $0x801087d3
80107952:	e8 39 8a ff ff       	call   80100390 <panic>
        panic("loaduvm: addr must be page aligned");
80107957:	83 ec 0c             	sub    $0xc,%esp
8010795a:	68 74 88 10 80       	push   $0x80108874
8010795f:	e8 2c 8a ff ff       	call   80100390 <panic>
80107964:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010796b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010796f:	90                   	nop

80107970 <allocuvm>:
int allocuvm(pde_t* pgdir, uint oldsz, uint newsz) {
80107970:	f3 0f 1e fb          	endbr32 
80107974:	55                   	push   %ebp
80107975:	89 e5                	mov    %esp,%ebp
80107977:	57                   	push   %edi
80107978:	56                   	push   %esi
80107979:	53                   	push   %ebx
8010797a:	83 ec 1c             	sub    $0x1c,%esp
    if (newsz >= KERNBASE)
8010797d:	8b 45 10             	mov    0x10(%ebp),%eax
int allocuvm(pde_t* pgdir, uint oldsz, uint newsz) {
80107980:	8b 7d 08             	mov    0x8(%ebp),%edi
    if (newsz >= KERNBASE)
80107983:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107986:	85 c0                	test   %eax,%eax
80107988:	0f 88 b2 00 00 00    	js     80107a40 <allocuvm+0xd0>
    if (newsz < oldsz)
8010798e:	3b 45 0c             	cmp    0xc(%ebp),%eax
        return oldsz;
80107991:	8b 45 0c             	mov    0xc(%ebp),%eax
    if (newsz < oldsz)
80107994:	0f 82 96 00 00 00    	jb     80107a30 <allocuvm+0xc0>
    a = PGROUNDUP(oldsz);
8010799a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801079a0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    for (; a < newsz; a += PGSIZE) {
801079a6:	39 75 10             	cmp    %esi,0x10(%ebp)
801079a9:	77 40                	ja     801079eb <allocuvm+0x7b>
801079ab:	e9 83 00 00 00       	jmp    80107a33 <allocuvm+0xc3>
        memset(mem, 0, PGSIZE);
801079b0:	83 ec 04             	sub    $0x4,%esp
801079b3:	68 00 10 00 00       	push   $0x1000
801079b8:	6a 00                	push   $0x0
801079ba:	50                   	push   %eax
801079bb:	e8 e0 d8 ff ff       	call   801052a0 <memset>
        if (mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
801079c0:	58                   	pop    %eax
801079c1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801079c7:	5a                   	pop    %edx
801079c8:	6a 06                	push   $0x6
801079ca:	b9 00 10 00 00       	mov    $0x1000,%ecx
801079cf:	89 f2                	mov    %esi,%edx
801079d1:	50                   	push   %eax
801079d2:	89 f8                	mov    %edi,%eax
801079d4:	e8 47 fb ff ff       	call   80107520 <mappages>
801079d9:	83 c4 10             	add    $0x10,%esp
801079dc:	85 c0                	test   %eax,%eax
801079de:	78 78                	js     80107a58 <allocuvm+0xe8>
    for (; a < newsz; a += PGSIZE) {
801079e0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801079e6:	39 75 10             	cmp    %esi,0x10(%ebp)
801079e9:	76 48                	jbe    80107a33 <allocuvm+0xc3>
        mem = kalloc();
801079eb:	e8 e0 b7 ff ff       	call   801031d0 <kalloc>
801079f0:	89 c3                	mov    %eax,%ebx
        if (mem == 0) {
801079f2:	85 c0                	test   %eax,%eax
801079f4:	75 ba                	jne    801079b0 <allocuvm+0x40>
            cprintf("allocuvm out of memory\n");
801079f6:	83 ec 0c             	sub    $0xc,%esp
801079f9:	68 f1 87 10 80       	push   $0x801087f1
801079fe:	e8 bd 8d ff ff       	call   801007c0 <cprintf>
    if (newsz >= oldsz)
80107a03:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a06:	83 c4 10             	add    $0x10,%esp
80107a09:	39 45 10             	cmp    %eax,0x10(%ebp)
80107a0c:	74 32                	je     80107a40 <allocuvm+0xd0>
80107a0e:	8b 55 10             	mov    0x10(%ebp),%edx
80107a11:	89 c1                	mov    %eax,%ecx
80107a13:	89 f8                	mov    %edi,%eax
80107a15:	e8 96 fb ff ff       	call   801075b0 <deallocuvm.part.0>
            return 0;
80107a1a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107a21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a24:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a27:	5b                   	pop    %ebx
80107a28:	5e                   	pop    %esi
80107a29:	5f                   	pop    %edi
80107a2a:	5d                   	pop    %ebp
80107a2b:	c3                   	ret    
80107a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return oldsz;
80107a30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107a33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a39:	5b                   	pop    %ebx
80107a3a:	5e                   	pop    %esi
80107a3b:	5f                   	pop    %edi
80107a3c:	5d                   	pop    %ebp
80107a3d:	c3                   	ret    
80107a3e:	66 90                	xchg   %ax,%ax
        return 0;
80107a40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107a47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a4d:	5b                   	pop    %ebx
80107a4e:	5e                   	pop    %esi
80107a4f:	5f                   	pop    %edi
80107a50:	5d                   	pop    %ebp
80107a51:	c3                   	ret    
80107a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            cprintf("allocuvm out of memory (2)\n");
80107a58:	83 ec 0c             	sub    $0xc,%esp
80107a5b:	68 09 88 10 80       	push   $0x80108809
80107a60:	e8 5b 8d ff ff       	call   801007c0 <cprintf>
    if (newsz >= oldsz)
80107a65:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a68:	83 c4 10             	add    $0x10,%esp
80107a6b:	39 45 10             	cmp    %eax,0x10(%ebp)
80107a6e:	74 0c                	je     80107a7c <allocuvm+0x10c>
80107a70:	8b 55 10             	mov    0x10(%ebp),%edx
80107a73:	89 c1                	mov    %eax,%ecx
80107a75:	89 f8                	mov    %edi,%eax
80107a77:	e8 34 fb ff ff       	call   801075b0 <deallocuvm.part.0>
            kfree(mem);
80107a7c:	83 ec 0c             	sub    $0xc,%esp
80107a7f:	53                   	push   %ebx
80107a80:	e8 8b b5 ff ff       	call   80103010 <kfree>
            return 0;
80107a85:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107a8c:	83 c4 10             	add    $0x10,%esp
}
80107a8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a95:	5b                   	pop    %ebx
80107a96:	5e                   	pop    %esi
80107a97:	5f                   	pop    %edi
80107a98:	5d                   	pop    %ebp
80107a99:	c3                   	ret    
80107a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107aa0 <deallocuvm>:
int deallocuvm(pde_t* pgdir, uint oldsz, uint newsz) {
80107aa0:	f3 0f 1e fb          	endbr32 
80107aa4:	55                   	push   %ebp
80107aa5:	89 e5                	mov    %esp,%ebp
80107aa7:	8b 55 0c             	mov    0xc(%ebp),%edx
80107aaa:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107aad:	8b 45 08             	mov    0x8(%ebp),%eax
    if (newsz >= oldsz)
80107ab0:	39 d1                	cmp    %edx,%ecx
80107ab2:	73 0c                	jae    80107ac0 <deallocuvm+0x20>
}
80107ab4:	5d                   	pop    %ebp
80107ab5:	e9 f6 fa ff ff       	jmp    801075b0 <deallocuvm.part.0>
80107aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107ac0:	89 d0                	mov    %edx,%eax
80107ac2:	5d                   	pop    %ebp
80107ac3:	c3                   	ret    
80107ac4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107acf:	90                   	nop

80107ad0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void freevm(pde_t* pgdir) {
80107ad0:	f3 0f 1e fb          	endbr32 
80107ad4:	55                   	push   %ebp
80107ad5:	89 e5                	mov    %esp,%ebp
80107ad7:	57                   	push   %edi
80107ad8:	56                   	push   %esi
80107ad9:	53                   	push   %ebx
80107ada:	83 ec 0c             	sub    $0xc,%esp
80107add:	8b 75 08             	mov    0x8(%ebp),%esi
    uint i;

    if (pgdir == 0)
80107ae0:	85 f6                	test   %esi,%esi
80107ae2:	74 55                	je     80107b39 <freevm+0x69>
    if (newsz >= oldsz)
80107ae4:	31 c9                	xor    %ecx,%ecx
80107ae6:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107aeb:	89 f0                	mov    %esi,%eax
80107aed:	89 f3                	mov    %esi,%ebx
80107aef:	e8 bc fa ff ff       	call   801075b0 <deallocuvm.part.0>
        panic("freevm: no pgdir");
    deallocuvm(pgdir, KERNBASE, 0);
    for (i = 0; i < NPDENTRIES; i++) {
80107af4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107afa:	eb 0b                	jmp    80107b07 <freevm+0x37>
80107afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107b00:	83 c3 04             	add    $0x4,%ebx
80107b03:	39 df                	cmp    %ebx,%edi
80107b05:	74 23                	je     80107b2a <freevm+0x5a>
        if (pgdir[i] & PTE_P) {
80107b07:	8b 03                	mov    (%ebx),%eax
80107b09:	a8 01                	test   $0x1,%al
80107b0b:	74 f3                	je     80107b00 <freevm+0x30>
            char* v = P2V(PTE_ADDR(pgdir[i]));
80107b0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
            kfree(v);
80107b12:	83 ec 0c             	sub    $0xc,%esp
80107b15:	83 c3 04             	add    $0x4,%ebx
            char* v = P2V(PTE_ADDR(pgdir[i]));
80107b18:	05 00 00 00 80       	add    $0x80000000,%eax
            kfree(v);
80107b1d:	50                   	push   %eax
80107b1e:	e8 ed b4 ff ff       	call   80103010 <kfree>
80107b23:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NPDENTRIES; i++) {
80107b26:	39 df                	cmp    %ebx,%edi
80107b28:	75 dd                	jne    80107b07 <freevm+0x37>
        }
    }
    kfree((char*)pgdir);
80107b2a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107b2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b30:	5b                   	pop    %ebx
80107b31:	5e                   	pop    %esi
80107b32:	5f                   	pop    %edi
80107b33:	5d                   	pop    %ebp
    kfree((char*)pgdir);
80107b34:	e9 d7 b4 ff ff       	jmp    80103010 <kfree>
        panic("freevm: no pgdir");
80107b39:	83 ec 0c             	sub    $0xc,%esp
80107b3c:	68 25 88 10 80       	push   $0x80108825
80107b41:	e8 4a 88 ff ff       	call   80100390 <panic>
80107b46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b4d:	8d 76 00             	lea    0x0(%esi),%esi

80107b50 <setupkvm>:
setupkvm(void) {
80107b50:	f3 0f 1e fb          	endbr32 
80107b54:	55                   	push   %ebp
80107b55:	89 e5                	mov    %esp,%ebp
80107b57:	56                   	push   %esi
80107b58:	53                   	push   %ebx
    if ((pgdir = (pde_t*)kalloc()) == 0)
80107b59:	e8 72 b6 ff ff       	call   801031d0 <kalloc>
80107b5e:	89 c6                	mov    %eax,%esi
80107b60:	85 c0                	test   %eax,%eax
80107b62:	74 42                	je     80107ba6 <setupkvm+0x56>
    memset(pgdir, 0, PGSIZE);
80107b64:	83 ec 04             	sub    $0x4,%esp
    for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107b67:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
    memset(pgdir, 0, PGSIZE);
80107b6c:	68 00 10 00 00       	push   $0x1000
80107b71:	6a 00                	push   $0x0
80107b73:	50                   	push   %eax
80107b74:	e8 27 d7 ff ff       	call   801052a0 <memset>
80107b79:	83 c4 10             	add    $0x10,%esp
                     (uint)k->phys_start, k->perm) < 0) {
80107b7c:	8b 43 04             	mov    0x4(%ebx),%eax
        if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107b7f:	83 ec 08             	sub    $0x8,%esp
80107b82:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107b85:	ff 73 0c             	pushl  0xc(%ebx)
80107b88:	8b 13                	mov    (%ebx),%edx
80107b8a:	50                   	push   %eax
80107b8b:	29 c1                	sub    %eax,%ecx
80107b8d:	89 f0                	mov    %esi,%eax
80107b8f:	e8 8c f9 ff ff       	call   80107520 <mappages>
80107b94:	83 c4 10             	add    $0x10,%esp
80107b97:	85 c0                	test   %eax,%eax
80107b99:	78 15                	js     80107bb0 <setupkvm+0x60>
    for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107b9b:	83 c3 10             	add    $0x10,%ebx
80107b9e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107ba4:	75 d6                	jne    80107b7c <setupkvm+0x2c>
}
80107ba6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ba9:	89 f0                	mov    %esi,%eax
80107bab:	5b                   	pop    %ebx
80107bac:	5e                   	pop    %esi
80107bad:	5d                   	pop    %ebp
80107bae:	c3                   	ret    
80107baf:	90                   	nop
            freevm(pgdir);
80107bb0:	83 ec 0c             	sub    $0xc,%esp
80107bb3:	56                   	push   %esi
            return 0;
80107bb4:	31 f6                	xor    %esi,%esi
            freevm(pgdir);
80107bb6:	e8 15 ff ff ff       	call   80107ad0 <freevm>
            return 0;
80107bbb:	83 c4 10             	add    $0x10,%esp
}
80107bbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107bc1:	89 f0                	mov    %esi,%eax
80107bc3:	5b                   	pop    %ebx
80107bc4:	5e                   	pop    %esi
80107bc5:	5d                   	pop    %ebp
80107bc6:	c3                   	ret    
80107bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bce:	66 90                	xchg   %ax,%ax

80107bd0 <kvmalloc>:
void kvmalloc(void) {
80107bd0:	f3 0f 1e fb          	endbr32 
80107bd4:	55                   	push   %ebp
80107bd5:	89 e5                	mov    %esp,%ebp
80107bd7:	83 ec 08             	sub    $0x8,%esp
    kpgdir = setupkvm();
80107bda:	e8 71 ff ff ff       	call   80107b50 <setupkvm>
80107bdf:	a3 44 6b 11 80       	mov    %eax,0x80116b44
    lcr3(V2P(kpgdir)); // switch to the kernel page table
80107be4:	05 00 00 00 80       	add    $0x80000000,%eax
80107be9:	0f 22 d8             	mov    %eax,%cr3
}
80107bec:	c9                   	leave  
80107bed:	c3                   	ret    
80107bee:	66 90                	xchg   %ax,%ax

80107bf0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void clearpteu(pde_t* pgdir, char* uva) {
80107bf0:	f3 0f 1e fb          	endbr32 
80107bf4:	55                   	push   %ebp
    pte_t* pte;

    pte = walkpgdir(pgdir, uva, 0);
80107bf5:	31 c9                	xor    %ecx,%ecx
void clearpteu(pde_t* pgdir, char* uva) {
80107bf7:	89 e5                	mov    %esp,%ebp
80107bf9:	83 ec 08             	sub    $0x8,%esp
    pte = walkpgdir(pgdir, uva, 0);
80107bfc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107bff:	8b 45 08             	mov    0x8(%ebp),%eax
80107c02:	e8 99 f8 ff ff       	call   801074a0 <walkpgdir>
    if (pte == 0)
80107c07:	85 c0                	test   %eax,%eax
80107c09:	74 05                	je     80107c10 <clearpteu+0x20>
        panic("clearpteu");
    *pte &= ~PTE_U;
80107c0b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107c0e:	c9                   	leave  
80107c0f:	c3                   	ret    
        panic("clearpteu");
80107c10:	83 ec 0c             	sub    $0xc,%esp
80107c13:	68 36 88 10 80       	push   $0x80108836
80107c18:	e8 73 87 ff ff       	call   80100390 <panic>
80107c1d:	8d 76 00             	lea    0x0(%esi),%esi

80107c20 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t* pgdir, uint sz) {
80107c20:	f3 0f 1e fb          	endbr32 
80107c24:	55                   	push   %ebp
80107c25:	89 e5                	mov    %esp,%ebp
80107c27:	57                   	push   %edi
80107c28:	56                   	push   %esi
80107c29:	53                   	push   %ebx
80107c2a:	83 ec 1c             	sub    $0x1c,%esp
    pde_t* d;
    pte_t* pte;
    uint pa, i, flags;
    char* mem;

    if ((d = setupkvm()) == 0)
80107c2d:	e8 1e ff ff ff       	call   80107b50 <setupkvm>
80107c32:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107c35:	85 c0                	test   %eax,%eax
80107c37:	0f 84 9b 00 00 00    	je     80107cd8 <copyuvm+0xb8>
        return 0;
    for (i = 0; i < sz; i += PGSIZE) {
80107c3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107c40:	85 c9                	test   %ecx,%ecx
80107c42:	0f 84 90 00 00 00    	je     80107cd8 <copyuvm+0xb8>
80107c48:	31 f6                	xor    %esi,%esi
80107c4a:	eb 46                	jmp    80107c92 <copyuvm+0x72>
80107c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            panic("copyuvm: page not present");
        pa = PTE_ADDR(*pte);
        flags = PTE_FLAGS(*pte);
        if ((mem = kalloc()) == 0)
            goto bad;
        memmove(mem, (char*)P2V(pa), PGSIZE);
80107c50:	83 ec 04             	sub    $0x4,%esp
80107c53:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107c59:	68 00 10 00 00       	push   $0x1000
80107c5e:	57                   	push   %edi
80107c5f:	50                   	push   %eax
80107c60:	e8 db d6 ff ff       	call   80105340 <memmove>
        if (mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107c65:	58                   	pop    %eax
80107c66:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107c6c:	5a                   	pop    %edx
80107c6d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107c70:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c75:	89 f2                	mov    %esi,%edx
80107c77:	50                   	push   %eax
80107c78:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107c7b:	e8 a0 f8 ff ff       	call   80107520 <mappages>
80107c80:	83 c4 10             	add    $0x10,%esp
80107c83:	85 c0                	test   %eax,%eax
80107c85:	78 61                	js     80107ce8 <copyuvm+0xc8>
    for (i = 0; i < sz; i += PGSIZE) {
80107c87:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107c8d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107c90:	76 46                	jbe    80107cd8 <copyuvm+0xb8>
        if ((pte = walkpgdir(pgdir, (void*)i, 0)) == 0)
80107c92:	8b 45 08             	mov    0x8(%ebp),%eax
80107c95:	31 c9                	xor    %ecx,%ecx
80107c97:	89 f2                	mov    %esi,%edx
80107c99:	e8 02 f8 ff ff       	call   801074a0 <walkpgdir>
80107c9e:	85 c0                	test   %eax,%eax
80107ca0:	74 61                	je     80107d03 <copyuvm+0xe3>
        if (!(*pte & PTE_P))
80107ca2:	8b 00                	mov    (%eax),%eax
80107ca4:	a8 01                	test   $0x1,%al
80107ca6:	74 4e                	je     80107cf6 <copyuvm+0xd6>
        pa = PTE_ADDR(*pte);
80107ca8:	89 c7                	mov    %eax,%edi
        flags = PTE_FLAGS(*pte);
80107caa:	25 ff 0f 00 00       	and    $0xfff,%eax
80107caf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        pa = PTE_ADDR(*pte);
80107cb2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
        if ((mem = kalloc()) == 0)
80107cb8:	e8 13 b5 ff ff       	call   801031d0 <kalloc>
80107cbd:	89 c3                	mov    %eax,%ebx
80107cbf:	85 c0                	test   %eax,%eax
80107cc1:	75 8d                	jne    80107c50 <copyuvm+0x30>
        }
    }
    return d;

bad:
    freevm(d);
80107cc3:	83 ec 0c             	sub    $0xc,%esp
80107cc6:	ff 75 e0             	pushl  -0x20(%ebp)
80107cc9:	e8 02 fe ff ff       	call   80107ad0 <freevm>
    return 0;
80107cce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107cd5:	83 c4 10             	add    $0x10,%esp
}
80107cd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107cdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cde:	5b                   	pop    %ebx
80107cdf:	5e                   	pop    %esi
80107ce0:	5f                   	pop    %edi
80107ce1:	5d                   	pop    %ebp
80107ce2:	c3                   	ret    
80107ce3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107ce7:	90                   	nop
            kfree(mem);
80107ce8:	83 ec 0c             	sub    $0xc,%esp
80107ceb:	53                   	push   %ebx
80107cec:	e8 1f b3 ff ff       	call   80103010 <kfree>
            goto bad;
80107cf1:	83 c4 10             	add    $0x10,%esp
80107cf4:	eb cd                	jmp    80107cc3 <copyuvm+0xa3>
            panic("copyuvm: page not present");
80107cf6:	83 ec 0c             	sub    $0xc,%esp
80107cf9:	68 5a 88 10 80       	push   $0x8010885a
80107cfe:	e8 8d 86 ff ff       	call   80100390 <panic>
            panic("copyuvm: pte should exist");
80107d03:	83 ec 0c             	sub    $0xc,%esp
80107d06:	68 40 88 10 80       	push   $0x80108840
80107d0b:	e8 80 86 ff ff       	call   80100390 <panic>

80107d10 <uva2ka>:

// PAGEBREAK!
//  Map user virtual address to kernel address.
char* uva2ka(pde_t* pgdir, char* uva) {
80107d10:	f3 0f 1e fb          	endbr32 
80107d14:	55                   	push   %ebp
    pte_t* pte;

    pte = walkpgdir(pgdir, uva, 0);
80107d15:	31 c9                	xor    %ecx,%ecx
char* uva2ka(pde_t* pgdir, char* uva) {
80107d17:	89 e5                	mov    %esp,%ebp
80107d19:	83 ec 08             	sub    $0x8,%esp
    pte = walkpgdir(pgdir, uva, 0);
80107d1c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d1f:	8b 45 08             	mov    0x8(%ebp),%eax
80107d22:	e8 79 f7 ff ff       	call   801074a0 <walkpgdir>
    if ((*pte & PTE_P) == 0)
80107d27:	8b 00                	mov    (%eax),%eax
        return 0;
    if ((*pte & PTE_U) == 0)
        return 0;
    return (char*)P2V(PTE_ADDR(*pte));
}
80107d29:	c9                   	leave  
    if ((*pte & PTE_U) == 0)
80107d2a:	89 c2                	mov    %eax,%edx
    return (char*)P2V(PTE_ADDR(*pte));
80107d2c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if ((*pte & PTE_U) == 0)
80107d31:	83 e2 05             	and    $0x5,%edx
    return (char*)P2V(PTE_ADDR(*pte));
80107d34:	05 00 00 00 80       	add    $0x80000000,%eax
80107d39:	83 fa 05             	cmp    $0x5,%edx
80107d3c:	ba 00 00 00 00       	mov    $0x0,%edx
80107d41:	0f 45 c2             	cmovne %edx,%eax
}
80107d44:	c3                   	ret    
80107d45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107d50 <copyout>:

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int copyout(pde_t* pgdir, uint va, void* p, uint len) {
80107d50:	f3 0f 1e fb          	endbr32 
80107d54:	55                   	push   %ebp
80107d55:	89 e5                	mov    %esp,%ebp
80107d57:	57                   	push   %edi
80107d58:	56                   	push   %esi
80107d59:	53                   	push   %ebx
80107d5a:	83 ec 0c             	sub    $0xc,%esp
80107d5d:	8b 75 14             	mov    0x14(%ebp),%esi
80107d60:	8b 55 0c             	mov    0xc(%ebp),%edx
    char *buf, *pa0;
    uint n, va0;

    buf = (char*)p;
    while (len > 0) {
80107d63:	85 f6                	test   %esi,%esi
80107d65:	75 3c                	jne    80107da3 <copyout+0x53>
80107d67:	eb 67                	jmp    80107dd0 <copyout+0x80>
80107d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        va0 = (uint)PGROUNDDOWN(va);
        pa0 = uva2ka(pgdir, (char*)va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (va - va0);
80107d70:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d73:	89 fb                	mov    %edi,%ebx
80107d75:	29 d3                	sub    %edx,%ebx
80107d77:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        if (n > len)
80107d7d:	39 f3                	cmp    %esi,%ebx
80107d7f:	0f 47 de             	cmova  %esi,%ebx
            n = len;
        memmove(pa0 + (va - va0), buf, n);
80107d82:	29 fa                	sub    %edi,%edx
80107d84:	83 ec 04             	sub    $0x4,%esp
80107d87:	01 c2                	add    %eax,%edx
80107d89:	53                   	push   %ebx
80107d8a:	ff 75 10             	pushl  0x10(%ebp)
80107d8d:	52                   	push   %edx
80107d8e:	e8 ad d5 ff ff       	call   80105340 <memmove>
        len -= n;
        buf += n;
80107d93:	01 5d 10             	add    %ebx,0x10(%ebp)
        va = va0 + PGSIZE;
80107d96:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
    while (len > 0) {
80107d9c:	83 c4 10             	add    $0x10,%esp
80107d9f:	29 de                	sub    %ebx,%esi
80107da1:	74 2d                	je     80107dd0 <copyout+0x80>
        va0 = (uint)PGROUNDDOWN(va);
80107da3:	89 d7                	mov    %edx,%edi
        pa0 = uva2ka(pgdir, (char*)va0);
80107da5:	83 ec 08             	sub    $0x8,%esp
        va0 = (uint)PGROUNDDOWN(va);
80107da8:	89 55 0c             	mov    %edx,0xc(%ebp)
80107dab:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
        pa0 = uva2ka(pgdir, (char*)va0);
80107db1:	57                   	push   %edi
80107db2:	ff 75 08             	pushl  0x8(%ebp)
80107db5:	e8 56 ff ff ff       	call   80107d10 <uva2ka>
        if (pa0 == 0)
80107dba:	83 c4 10             	add    $0x10,%esp
80107dbd:	85 c0                	test   %eax,%eax
80107dbf:	75 af                	jne    80107d70 <copyout+0x20>
    }
    return 0;
}
80107dc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80107dc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107dc9:	5b                   	pop    %ebx
80107dca:	5e                   	pop    %esi
80107dcb:	5f                   	pop    %edi
80107dcc:	5d                   	pop    %ebp
80107dcd:	c3                   	ret    
80107dce:	66 90                	xchg   %ax,%ax
80107dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107dd3:	31 c0                	xor    %eax,%eax
}
80107dd5:	5b                   	pop    %ebx
80107dd6:	5e                   	pop    %esi
80107dd7:	5f                   	pop    %edi
80107dd8:	5d                   	pop    %ebp
80107dd9:	c3                   	ret    
