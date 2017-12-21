section	.text
	global _start       ;must be declared for using gcc
_start:                     ;tell linker entry point
	mov	edx, len    ;message length
	mov	ecx, msg    ;message to write
	mov	ebx, 1	    ;file descriptor (stdout)
	mov	eax, 4	    ;system call number (sys_write)
	int	0x80        ;call kernel
	mov	eax, msg
	call 	p_int
        call    newline
	mov	eax, ds
	call	p_int
	call	newline
 	lea	ax, [msg]
	call	p_int
	call	newline
	;mov     ax, msg
        ;call    p_int
        ;call    newline
	mov	ebx, 0
	mov	eax, 1	    ;system call number (sys_exit)
	int	0x80        ;call kernel

newline:
	mov     edx, 1
        mov     ecx, p_buffer + 1
        mov     ebx, 1
        mov     eax, 4
        int     0x80
        ret

p_int:			; print 32 bit unsigned int
	push	eax
	pop	bx
	pop	ax
	push	bx
	call	p_word
	pop	ax
	call	p_word
	ret
	

p_word:			; print 16 bit unsigned word
	push 	ax
	mov 	al, ah
	call 	p_byte
	pop	ax
	call 	p_byte
	ret
	

p_byte:
	push eax
	push ax
	shr al, 4
	call	p_nibble
	pop ax
	call	p_nibble
	pop eax
	ret

p_nibble:
	and	eax, 0x0f
	cmp	ax, 9
	jng	salto1
	add	eax, 64-57
salto1:
	add	eax, 48
	
	mov	[p_buffer], al
	mov	edx, 1
	mov	ecx, p_buffer
	mov	ebx, 1
	mov 	eax, 4
	int     0x80
	ret

section	.data
p_buffer	db 0, 0xa
	
msg	db	'Hello, world!',0xa	;our dear string
len	equ	$ - msg			;length of our dear string

