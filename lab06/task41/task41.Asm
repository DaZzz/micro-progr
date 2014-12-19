assume cs:cseg, ds:dseg, ss:sseg

cseg segment

include ..\..\lib.Asm

;;;
; Functions
;;;

;;;
; Bubble sort
; si - array of strings
; bx - string lengths
; di - indexes
;;;
bubble_sort proc uses ax bx cx si di
	
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
	
	; Setup params
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
	 
	str_nl db 13, 10, '$'
	buf dw 1000 dup(?)
	str1 db 13,10,"Sorted array:",13,10,'$'
	str_intro db "Initial array: ",13,10,'$'
dseg ends

sseg segment

	db 100h dup(?)

sseg ends

end start