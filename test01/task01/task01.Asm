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
	
	push	ax
	loop	pushing_stack
	
	mov		cx, bx
	
	test	ah, ah
	jz		popping_stack
	
	inc		si
popping_stack:
	xor 	ah, ah
	mov 	al, [si]
	
	pop 	ax

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

;;;
; Checks if second_word is a subset of first_word
;;;
is_subset proc uses bx dx di
	
	ret
is_subset endp

start:
	; Basic memory setup
	mov 	ax, dseg
	mov 	ds, ax 
	mov 	es, ax
	
	; Intro 1
	mov 	ah, 09h
	lea 	dx, first_string
	int		21h
	
	; Read string 1
	mov 	ah, 0ah
	lea		dx, first_buffer
	int 	21h
	call 	print_linebreak
	
	; Intro 1
	mov 	ah, 09h
	lea 	dx, second_string
	int		21h
	
	; Read string 2
	mov 	ah, 0ah
	lea		dx, second_buffer
	int 	21h
	call 	print_linebreak
	
	; Output result
	mov 	ah, 09h
	lea 	dx, result_string
	int		21h
	
	test 	ax, ax
	jnz		if_subset
	jmp		if_not_subset

if_subset:
	mov 	ah, 09h
	lea 	dx, subset_msg
	int		21h
	call 	print_linebreak
	jmp		end_if
	
if_not_subset:
	mov 	ah, 09h
	lea 	dx, not_subset_msg
	int		21h
	call 	print_linebreak
	jmp		end_if
	
end_if:		
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
	first_string    db "First string: ", '$'
	second_string   db "Second string: ", '$'
	result_string   db "Result: ", '$'
	first_buffer    db 254, 256 dup('$')
	second_buffer   db 254, 256 dup('$')
	subset_msg	 	db "Subset!", '$'
	not_subset_msg	db "Not a subset!", '$'
dseg ends

end start