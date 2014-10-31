.286
assume cs:cseg, ds:dseg, ss:sseg

;;;
; Includes
;;;
include ..\lib.Asm

;;;
; Code
;;;
cseg segment 

;;;
; Write number from AX with base 
;;;
print_number_with_base proc uses ax bx cx dx di
	cmp		ax, 0
	jne		distruct
	call    print_number
	ret
distruct:
	lea		di, string_number
	mov		cx, 16
	mov		bl, ' '
fill_buffer_with_whitespaces:
	mov 	[di], bl
	inc		di
	loop	fill_buffer_with_whitespaces
	
	;;;
	; change direction flag from incrementing to decrementing
	; to decrease DI when we will write symbols backwards
	; using command STOSB
	;;;
	std
print_symbol:
	xor		dx, dx
	mov		cx, base
	div 	cx
	
	cmp		dx, 9
	ja		if_letter
	jna		if_not_letter

if_not_letter:
	add		dx, '0'
	jmp 	end_if
	
if_letter:
	add		dx, 'A'
	sub		dx, 10
	jmp 	end_if

end_if:
	xchg	ax, dx
	stosb
	xchg	ax, dx
	test	ax, ax
	jnz		print_symbol
	
	; Printing number
	inc		di
	mov		dx, di
	mov		ah, 09h
	int		21h
	
	call print_linebreak
	ret
print_number_with_base endp

start:
	; Basic memory setup
	mov 	ax, dseg
	mov 	ds, ax 
	mov 	es, ax

	mov		ah, 09h
	lea 	dx, input_str
	int		21h

	call 	read_number
	mov  	number, ax
	
	; DEC
	mov		ah, 09h
	lea 	dx, dec_str
	int		21h
	mov		ax, number
	mov		base, 10
	call 	print_number_with_base
	
	; BIN
	mov		ah, 09h
	lea 	dx, bin_str
	int		21h
	mov		ax, number
	mov		base, 2
	call 	print_number_with_base
	
	; HEX
	mov		ah, 09h
	lea 	dx, hex_str
	int		21h
	mov		ax, number
	mov		base, 16
	call 	print_number_with_base

	; Pause
	mov 	ah,1
	int 	21h
	
   	; exit DOS
    mov     ax, 4C00h
    int     21h
cseg ends

;;;
; Stack
;;;
sseg segment 
	stack db 100h dup(?)
sseg ends

;;;
; Data
;;;
dseg segment byte 
	number dw ?
	base   dw ?
	string_number	db 17 dup(?), '$'
	input_str db "Input number: ", '$'
	dec_str	  db "DEC number: ", '$'
	hex_str	  db "HEX number: ", '$'
	bin_str	  db "BIN number: ", '$'
dseg ends

end start