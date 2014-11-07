.286
assume cs:cseg, ds:dseg, ss:sseg

;;;
; Code
;;;
cseg segment 

;;;
; Outut 13, 10 into 
;;;
print_linebreak proc uses dx ax
	mov		ah, 09h
	lea 	dx, linebreak
	int		21h
	ret
print_linebreak endp

;;;
; Checks if letter in first_word
;;;
is_in_array proc uses bx dx cx di si
	; DI := first_word[0]
	lea 	dx, first_buffer
	mov		di, dx
	
	xor		cx, cx
	mov		cl, [di + 1]
	
	add		di, 2
check_next_symbol:
	cmp		al, [di]
	je		if_found
	inc		di
	loop	check_next_symbol
	
	mov		ax, 0
	ret
if_found:
	mov		ax, 1
	ret		
is_in_array endp

;;;
; Checks if second_word is a subset of first_word
;;;
is_subset proc uses bx dx cx di si
	; DI := first_word[0]
	lea 	dx, first_buffer
	mov		di, dx
	
	; SI := second_word[0]
	lea 	dx, second_buffer
	mov		si,	dx
	
	; BH := first_word.length
	mov		bh, [di + 1]
	; BL := second_word.length
	mov		bl, [si + 1]
	
	; CL := second_word.length
	xor		cx, cx
	mov		cl, bl
	
	add		si, 2
	add		di, 2

check_next_symbol:
	; check AL in array
	mov		al, [si] 
	call 	is_in_array
	cmp		ax, 0
	je		if_not_member
	inc		si
	loop	check_next_symbol
	
	; if true
	mov		ax, 1
	ret
	
	; if false
if_not_member:
	mov		ax, 0
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
	
	; Check subset
	call	is_subset
	cmp 	ax, 1
	je		if_subset
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
	linebreak	  	db 13, 10, '$'
dseg ends

end start