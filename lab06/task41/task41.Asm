assume cs:cseg, ds:dseg, ss:sseg

cseg segment

include ..\..\lib.Asm

;;;
; Macros
;;;
PRINT macro reg
	push	ax
	mov		ax, reg
	call	print_number
	call	print_linebreak
	pop		ax
endm

;;;
; Functions
;;;

;;;
; Swap strings
; bx - word length
; si - array
; ax - index 1
; cx - index 2
;;;
swap_strings_if_greater proc uses ax bx cx si di
	
	; Indexing from 1
	dec	ax
	dec cx
	
	; Init indexes
	i     equ [bp + 0]
	j 	  equ [bp + 2]
	array equ [bp + 4]
	
	push 	si
	push 	cx
	push	ax
	
	mov		bp, sp ; for local variables to work
	
	;;;
	; Compare
	;;;
	; set di to a[i] 
	mov		ax, i
	mul		bx
	mov		di, array
	add		di, ax
	
	; set si to a[j] 
	mov		ax, j
	mul		bx
	mov		si, array
	add		si, ax

	mov		cx, bx	
cycle_to_compare:
	push	bx
	mov		al, [si]
	mov		bl, [di]
	cmp		al, bl
	pop 	bx
	je		continue_loop
	jg		exit
	jl		start_swapping
		
continue_loop:
	inc		si
	inc		di
	loop	cycle_to_compare
	jmp		exit		
	

start_swapping:	
	;;;
	; Copy a[i] to temp
	;;;
	lea 	di, temp_word_buffer
	mov		ax, i
	mul		bx
	mov		si, array
	add		si, ax

	mov		cx, bx		; cx := word_length
	cld
copy1:
	movsb
	loop	copy1
	
	;;;
	; Copy a[j] to a[i]
	;;; 
	
	; set di to a[i] 
	mov		ax, i
	mul		bx
	mov		di, array
	add		di, ax
	
	; set si to a[j]
	mov		si, array 
	mov		ax, j
	mul		bx
	add		si, ax
	
	; set counter
	mov		cx, bx
copy2:
	movsb
	loop	copy2

	;;;
	; Copy temp to a[j]
	;;;
	mov		di, array
	mov		ax, j
	mul		bx
	add		di, ax	
	lea 	si, temp_word_buffer 

	; set counter
	mov		cx, bx
copy3:
	movsb
	loop	copy3	

exit:

	; Release ax, cx
	pop	ax
	pop cx
	pop si
	
	ret

swap_strings_if_greater endp

;;;
; Bubble sort
; bx - word length
; si - array
; cx - amount of words
;;;
bubble_sort proc uses ax bx cx si di
	i equ [bp + 0] ; for outer index
	push	cx
	mov		bp, sp

	; Iterate over all elements
	; for i = n to 1
cycle_outer:
	cmp		cx, 1
	je		exit
	
	push	cx
	mov		i, cx
	
	; for j = i to 0
	dec		cx	
cycle_inner:
	mov		ax, i	
	call 	swap_strings_if_greater
	loop	cycle_inner
	pop		cx
	
	loop	cycle_outer

exit:	
	pop		cx
	ret
bubble_sort endp

;;;
; Print array of strings
; bx - word length
; si - array
; cx - amount of words
;;;
print_string_array proc uses si ax bx cx dx
	
	mov		dx, si

cycle:
	; print word
	mov		ah, 09h
	int 	21h
	
	; print white space
	push	dx
	mov		ah, 02h
	mov		dl, ' '
	int		21h
	pop 	dx
	
	; next word
	add		dx, bx
	loop	cycle
	
	call	print_linebreak
	
	ret

print_string_array endp

;;;
; Main program
;;;
start:
	mov		ax, dseg
	mov		ds, ax
	mov		es, ax
	
	; Intro string
	mov		ah, 09h
	lea		dx, str_intro
	int		21h
	
	; Print initial array
	mov		bx, word_length
	mov		cx, array_length
	lea		si, words
	call	print_string_array
	
	; Bubble sort
	mov		bx, word_length
	mov		cx, array_length
	lea		si, words
	call	bubble_sort
	
	; Intro string
	call	print_linebreak
	mov		ah, 09h
	lea		dx, str_outro
	int		21h
	
	; Print swapped array
	mov		bx, word_length
	mov		cx, array_length
	lea		si, words
	call	print_string_array
	
		
	
	; Pause
	mov		ah, 01h
	int		21h
	
	mov		ax, 4c00h
	int		21h

cseg ends

dseg segment byte
	word_length  dw 10
	array_length dw 4
	words 		 db "zyy$", 6 dup(?), "zxz$", 6 dup(?), "yzx$", 6 dup(?), "zxy$", 6 dup(?)
	temp_word_buffer db 20 dup(?)

	str_intro db "Initial array: ",13,10,'$'
	str_outro db "Sorted array: ",13,10,'$'
dseg ends

sseg segment

	db 100h dup(?)

sseg ends

end start