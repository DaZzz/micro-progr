.286
assume cs:cseg, ds:dseg, ss:sseg

;;;
; Includes
;;;
include ..\..\lib.Asm

;;;
; Code
;;;
cseg segment 

;;;
; Checks if word is a polyndrome
;;;
is_polindrome proc uses bx dx di
	; Write line length to bl
	xor 	bx, bx
	mov		si, dx
	mov 	bl, [si + 1]
	
	mov		ax, bx
	; here ax == bx
		
	mov		cl, 2
	div		cl
	
	xor		ch, ch
	mov		cl, al
	mov		bx, cx
	; here cx = bx = length/2 = al | ah = rst
	
	; Skip sizes
	add		si, 2
pushing_stack:

	mov		al, [si]
	inc		si
	;xor     ah, ah
	call	print_number
	call    print_linebreak
	
	push	ax
	loop	pushing_stack
	
	mov		cx, bx
	
	test	ah, ah
	jz		popping_stack
	inc		si
	call	print_linebreak
popping_stack:
	xor 	ah, ah
	mov 	al, [si]
	call	print_number
	call 	print_linebreak
	
	pop 	ax
	call    print_number
	call    print_linebreak
	call    print_linebreak
	
	cmp		al, [si]
	jne		return_false2
	inc		si
	call	print_debug
	loop 	popping_stack
	
	mov 	ax, 1
	ret
	
return_false2:
	dec		cx
return_false:
	pop		ax
	loop	return_false
	mov 	ax, 0
	ret
is_polindrome endp
	
start:
	; Basic memory setup
	mov 	ax, dseg
	mov 	ds, ax 
	mov 	es, ax
	
	; Intro
	mov 	ah, 09h
	lea 	dx, str_input_word
	int		21h
	
	; Read word
	mov 	ah, 0ah
	lea		dx, input_buffer
	int 	21h
	call 	print_linebreak
	
	call	is_polindrome
	
	call 	print_number
	

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
	str_input_word db "Enter string: ", '$'
	input_buffer   db 254, 256 dup('$')
dseg ends

end start