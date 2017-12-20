entry 	start

	org 0x00

start:
	cli
	cld
	mov ax,#0x9000
        mov ss,ax
        mov ax, #0x7c0 
        mov ds,ax
        mov sp,#0000
        mov si, #msg          ; Ponteiro para o deslocamento da string
        call p_string            ; Chamar a rotina de impressao

	;mov	ax, #0xFA95
	;call 	p_word 
	;call    newline
        ;sti

	mov	ax, cs
	call    p_word
        call    newline

        call 	get_ip
	call    p_word
        call    newline

	call	newline

	mov	ax, #msg
	call 	p_word
        call    newline

	lea     ax, msg
	call	p_word
	call	newline

	mov     ax, ds
	call	p_word
	call	newline

	call	newline
        mov ax, #0x07a0 
        mov ds,ax
	mov     ax, #msg
        call    p_word
        call    newline
	lea     ax, msg
        call    p_word
        call    newline

	mov     ax, ds
        call    p_word
        call    newline


	;mov     ax, msg
        ;call    p_word
        ;call    newline
	
forever:
	jmp forever

	mov	ax, 1	    ;system call number (sys_exit)
	mov	bx, 0
	int	0x80        ;call kernel

p_string:
        mov ah, #0x0E           ; Indica a rotina de teletipo da BIOS
        mov bx, #0x0007         ; Texto branco em fundo preto

next:   ; Marcador interno para inicio do loop
        lodsb           ; Copia o byte em DS:SI para AL e incrementa SI
        or al,al        ; Verifica se al = 0
        jz volta        ; Se al=0, string terminou e salta para .volta
        int 0x10        ; Se nao, chama INT 10 para imprimir caracter
        jmp next        ; Vai para o inicio do loop

volta:
        ret             ; Retorna 'a rotina principal

newline:
	mov     al, #0x0d
	call 	p_hdigit
	mov     al, #0xa
	jmp	p_hdigit

p_int_untested:
	push	ax
	pop	bx
	pop	ax
	push	bx
	call	p_word
	pop	ax
	call	p_word
	ret
	

p_word:
	push 	ax
	mov 	al, ah
	call 	p_byte
	pop	ax
	call 	p_byte
	ret
	

p_byte:
	push ax
	push ax
	shr al, 4
	call	p_nibble
	pop ax
	call	p_nibble
	pop ax
	ret

p_nibble:
	and	ax, #0x0f
	cmp	ax, #9
	jng	salto1
	add	ax, #7
salto1:
	add	ax, #48
p_hdigit:
	mov	ah, #0x0E
	mov	bh, #0x00
	mov	bl, #0x07
	int     0x10
	ret

get_ip:
	pop	ax
	push	ax
	ret

#section	.data
p_buffer:
	db 0, 0xa
	
msg:
	.ascii	'Hello, world!'
	db 13, 0xa	;our dear string
	db 0
len	equ	14
		;length of our dear string

