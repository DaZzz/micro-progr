.model tiny
.code
.386

org		100h

start:
	; Video
	push	cs
	pop		ds
	push	0b800h
	pop		es
	
	mov		ah, 09h
	lea		dx, str1
	int		21h
	
	call	pReadStr
	
	; Set video
	mov		ax, 03h
	int		10h
	
	; Check V86
	mov		eax, cr0
	test	al, 1
	jz		no_V86
	
	; If not v86
	mov		ah, 09h
	lea		dx, str_v86msg
	int		21h
	
	xor		ah, ah
	int		16h
	
	ret
	
no_V86:
	; reject interaptions
	cli
	
	; reject unmasking
	in		al, 70h
	or		al, 80h
	out		70h, al
	
	; Protected mode
	mov		eax, cr0
	or		al, 1
	mov		cr0, eax
	
	; output string		
	xor		di, di
	lea		si, str_buf
	xor		ch, ch
	mov		cl, ds:[si + 1]
	add		si, 2
	cld
start@cycle:
	lodsb	
	stosb
	mov		al, 7
	stosb
	loop		start@cycle
	
	; switch on real mode
	mov		eax, cr0
	and		al, 0feh
	mov		cr0, eax
	
	; switch on umasking
	in		al, 70h
	and		al, 07fh
	out		70h, al
	
	sti
	
	xor		ah, ah
	int		16h
	
	ret
	
; print new line
pNewLine proc uses ax dx
	
	mov		ah, 09h
	lea		dx, str_nl
	int		21h
	ret

pNewLine endp

; read string
pReadStr proc uses ax dx
	
	mov		ah, 0ah
	lea		dx, str_buf
	int		21h
	
	call		pNewLine	
	ret

pReadStr endp
	
	str_v86msg db "Proccessor in V86 mode can't be switched to PM$"
	str_buf db 254, 256 dup(?)
	str_nl db 13, 10, '$'
	str1 db "Enter string: $"
	
end start
