
bootblock:     file format binary


Disassembly of section .data:

00007c00 <.data>:
    7c00:	fa                   	cli
    7c01:	31 c0                	xor    %ax,%ax
    7c03:	8e d8                	mov    %ax,%ds
    7c05:	8e c0                	mov    %ax,%es
    7c07:	8e d0                	mov    %ax,%ss
    7c09:	e4 64                	in     $0x64,%al
    7c0b:	a8 02                	test   $0x2,%al
    7c0d:	75 fa                	jne    0x7c09
    7c0f:	b0 d1                	mov    $0xd1,%al
    7c11:	e6 64                	out    %al,$0x64
    7c13:	e4 64                	in     $0x64,%al
    7c15:	a8 02                	test   $0x2,%al
    7c17:	75 fa                	jne    0x7c13
    7c19:	b0 df                	mov    $0xdf,%al
    7c1b:	e6 60                	out    %al,$0x60
    7c1d:	0f 01 16 78 7c       	lgdtw  0x7c78
    7c22:	0f 20 c0             	mov    %cr0,%eax
    7c25:	66 83 c8 01          	or     $0x1,%eax
    7c29:	0f 22 c0             	mov    %eax,%cr0
    7c2c:	ea 31 7c 08 00       	ljmp   $0x8,$0x7c31
    7c31:	66 b8 10 00 8e d8    	mov    $0xd88e0010,%eax
    7c37:	8e c0                	mov    %ax,%es
    7c39:	8e d0                	mov    %ax,%ss
    7c3b:	66 b8 00 00 8e e0    	mov    $0xe08e0000,%eax
    7c41:	8e e8                	mov    %ax,%gs
    7c43:	bc 00 7c             	mov    $0x7c00,%sp
    7c46:	00 00                	add    %al,(%bx,%si)
    7c48:	e8 f0 00             	call   0x7d3b
    7c4b:	00 00                	add    %al,(%bx,%si)
    7c4d:	66 b8 00 8a 66 89    	mov    $0x89668a00,%eax
    7c53:	c2 66 ef             	ret    $0xef66
    7c56:	66 b8 e0 8a 66 ef    	mov    $0xef668ae0,%eax
    7c5c:	eb fe                	jmp    0x7c5c
    7c5e:	66 90                	xchg   %eax,%eax
	...
    7c68:	ff                   	(bad)
    7c69:	ff 00                	incw   (%bx,%si)
    7c6b:	00 00                	add    %al,(%bx,%si)
    7c6d:	9a cf 00 ff ff       	lcall  $0xffff,$0xcf
    7c72:	00 00                	add    %al,(%bx,%si)
    7c74:	00 92 cf 00          	add    %dl,0xcf(%bp,%si)
    7c78:	17                   	pop    %ss
    7c79:	00 60 7c             	add    %ah,0x7c(%bx,%si)
    7c7c:	00 00                	add    %al,(%bx,%si)
    7c7e:	ba f7 01             	mov    $0x1f7,%dx
    7c81:	00 00                	add    %al,(%bx,%si)
    7c83:	ec                   	in     (%dx),%al
    7c84:	83 e0 c0             	and    $0xffc0,%ax
    7c87:	3c 40                	cmp    $0x40,%al
    7c89:	75 f8                	jne    0x7c83
    7c8b:	c3                   	ret
    7c8c:	55                   	push   %bp
    7c8d:	89 e5                	mov    %sp,%bp
    7c8f:	57                   	push   %di
    7c90:	53                   	push   %bx
    7c91:	8b 5d 0c             	mov    0xc(%di),%bx
    7c94:	e8 e5 ff             	call   0x7c7c
    7c97:	ff                   	(bad)
    7c98:	ff                   	(bad)
    7c99:	b8 01 00             	mov    $0x1,%ax
    7c9c:	00 00                	add    %al,(%bx,%si)
    7c9e:	ba f2 01             	mov    $0x1f2,%dx
    7ca1:	00 00                	add    %al,(%bx,%si)
    7ca3:	ee                   	out    %al,(%dx)
    7ca4:	ba f3 01             	mov    $0x1f3,%dx
    7ca7:	00 00                	add    %al,(%bx,%si)
    7ca9:	89 d8                	mov    %bx,%ax
    7cab:	ee                   	out    %al,(%dx)
    7cac:	89 d8                	mov    %bx,%ax
    7cae:	c1 e8 08             	shr    $0x8,%ax
    7cb1:	ba f4 01             	mov    $0x1f4,%dx
    7cb4:	00 00                	add    %al,(%bx,%si)
    7cb6:	ee                   	out    %al,(%dx)
    7cb7:	89 d8                	mov    %bx,%ax
    7cb9:	c1 e8 10             	shr    $0x10,%ax
    7cbc:	ba f5 01             	mov    $0x1f5,%dx
    7cbf:	00 00                	add    %al,(%bx,%si)
    7cc1:	ee                   	out    %al,(%dx)
    7cc2:	89 d8                	mov    %bx,%ax
    7cc4:	c1 e8 18             	shr    $0x18,%ax
    7cc7:	83 c8 e0             	or     $0xffe0,%ax
    7cca:	ba f6 01             	mov    $0x1f6,%dx
    7ccd:	00 00                	add    %al,(%bx,%si)
    7ccf:	ee                   	out    %al,(%dx)
    7cd0:	b8 20 00             	mov    $0x20,%ax
    7cd3:	00 00                	add    %al,(%bx,%si)
    7cd5:	ba f7 01             	mov    $0x1f7,%dx
    7cd8:	00 00                	add    %al,(%bx,%si)
    7cda:	ee                   	out    %al,(%dx)
    7cdb:	e8 9e ff             	call   0x7c7c
    7cde:	ff                   	(bad)
    7cdf:	ff 8b 7d 08          	decw   0x87d(%bp,%di)
    7ce3:	b9 80 00             	mov    $0x80,%cx
    7ce6:	00 00                	add    %al,(%bx,%si)
    7ce8:	ba f0 01             	mov    $0x1f0,%dx
    7ceb:	00 00                	add    %al,(%bx,%si)
    7ced:	fc                   	cld
    7cee:	f3 6d                	rep insw (%dx),%es:(%di)
    7cf0:	5b                   	pop    %bx
    7cf1:	5f                   	pop    %di
    7cf2:	5d                   	pop    %bp
    7cf3:	c3                   	ret
    7cf4:	55                   	push   %bp
    7cf5:	89 e5                	mov    %sp,%bp
    7cf7:	57                   	push   %di
    7cf8:	56                   	push   %si
    7cf9:	53                   	push   %bx
    7cfa:	83 ec 0c             	sub    $0xc,%sp
    7cfd:	8b 5d 08             	mov    0x8(%di),%bx
    7d00:	8b 75 10             	mov    0x10(%di),%si
    7d03:	89 df                	mov    %bx,%di
    7d05:	03 7d 0c             	add    0xc(%di),%di
    7d08:	89 f0                	mov    %si,%ax
    7d0a:	25 ff 01             	and    $0x1ff,%ax
    7d0d:	00 00                	add    %al,(%bx,%si)
    7d0f:	29 c3                	sub    %ax,%bx
    7d11:	c1 ee 09             	shr    $0x9,%si
    7d14:	83 c6 01             	add    $0x1,%si
    7d17:	39 fb                	cmp    %di,%bx
    7d19:	73 1a                	jae    0x7d35
    7d1b:	83 ec 08             	sub    $0x8,%sp
    7d1e:	56                   	push   %si
    7d1f:	53                   	push   %bx
    7d20:	e8 67 ff             	call   0x7c8a
    7d23:	ff                   	(bad)
    7d24:	ff 81 c3 00          	incw   0xc3(%bx,%di)
    7d28:	02 00                	add    (%bx,%si),%al
    7d2a:	00 83 c6 01          	add    %al,0x1c6(%bp,%di)
    7d2e:	83 c4 10             	add    $0x10,%sp
    7d31:	39 fb                	cmp    %di,%bx
    7d33:	72 e6                	jb     0x7d1b
    7d35:	8d 65 f4             	lea    -0xc(%di),%sp
    7d38:	5b                   	pop    %bx
    7d39:	5e                   	pop    %si
    7d3a:	5f                   	pop    %di
    7d3b:	5d                   	pop    %bp
    7d3c:	c3                   	ret
    7d3d:	55                   	push   %bp
    7d3e:	89 e5                	mov    %sp,%bp
    7d40:	57                   	push   %di
    7d41:	56                   	push   %si
    7d42:	53                   	push   %bx
    7d43:	83 ec 10             	sub    $0x10,%sp
    7d46:	6a 00                	push   $0x0
    7d48:	68 00 10             	push   $0x1000
    7d4b:	00 00                	add    %al,(%bx,%si)
    7d4d:	68 00 00             	push   $0x0
    7d50:	01 00                	add    %ax,(%bx,%si)
    7d52:	e8 9d ff             	call   0x7cf2
    7d55:	ff                   	(bad)
    7d56:	ff 83 c4 10          	incw   0x10c4(%bp,%di)
    7d5a:	81 3d 00 00          	cmpw   $0x0,(%di)
    7d5e:	01 00                	add    %ax,(%bx,%si)
    7d60:	7f 45                	jg     0x7da7
    7d62:	4c                   	dec    %sp
    7d63:	46                   	inc    %si
    7d64:	75 21                	jne    0x7d87
    7d66:	a1 1c 00             	mov    0x1c,%ax
    7d69:	01 00                	add    %ax,(%bx,%si)
    7d6b:	8d 98 00 00          	lea    0x0(%bx,%si),%bx
    7d6f:	01 00                	add    %ax,(%bx,%si)
    7d71:	0f b7 35             	movzww (%di),%si
    7d74:	2c 00                	sub    $0x0,%al
    7d76:	01 00                	add    %ax,(%bx,%si)
    7d78:	c1 e6 05             	shl    $0x5,%si
    7d7b:	01 de                	add    %bx,%si
    7d7d:	39 f3                	cmp    %si,%bx
    7d7f:	72 15                	jb     0x7d96
    7d81:	ff 15                	call   *(%di)
    7d83:	18 00                	sbb    %al,(%bx,%si)
    7d85:	01 00                	add    %ax,(%bx,%si)
    7d87:	8d 65 f4             	lea    -0xc(%di),%sp
    7d8a:	5b                   	pop    %bx
    7d8b:	5e                   	pop    %si
    7d8c:	5f                   	pop    %di
    7d8d:	5d                   	pop    %bp
    7d8e:	c3                   	ret
    7d8f:	83 c3 20             	add    $0x20,%bx
    7d92:	39 f3                	cmp    %si,%bx
    7d94:	73 eb                	jae    0x7d81
    7d96:	8b 7b 0c             	mov    0xc(%bp,%di),%di
    7d99:	83 ec 04             	sub    $0x4,%sp
    7d9c:	ff 73 04             	push   0x4(%bp,%di)
    7d9f:	ff 73 10             	push   0x10(%bp,%di)
    7da2:	57                   	push   %di
    7da3:	e8 4c ff             	call   0x7cf2
    7da6:	ff                   	(bad)
    7da7:	ff 8b 4b 14          	decw   0x144b(%bp,%di)
    7dab:	8b 43 10             	mov    0x10(%bp,%di),%ax
    7dae:	83 c4 10             	add    $0x10,%sp
    7db1:	39 c8                	cmp    %cx,%ax
    7db3:	73 da                	jae    0x7d8f
    7db5:	01 c7                	add    %ax,%di
    7db7:	29 c1                	sub    %ax,%cx
    7db9:	b8 00 00             	mov    $0x0,%ax
    7dbc:	00 00                	add    %al,(%bx,%si)
    7dbe:	fc                   	cld
    7dbf:	f3 aa                	rep stos %al,%es:(%di)
    7dc1:	eb cc                	jmp    0x7d8f
	...
    7dfb:	00 00                	add    %al,(%bx,%si)
    7dfd:	00 55 aa             	add    %dl,-0x56(%di)
