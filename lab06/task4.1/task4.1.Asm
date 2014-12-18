assume cs:cseg, ds:dseg, ss:sseg

;;;
; Includes
;;;
include ..\..\lib.Asm

cseg segment


print_word proc uses di ax
	mov		cx, bx
	cld
	
cycle:
	lodsb
	mov		dl, al
	mov		ah, 02h
	int		21h
	
	loop 	cycle
	
exit:
	ret

print_word endp

;;;
; Replaces dots with triple dots
; - bx - array length
;;;
replace_dots proc uses si di cx dx ax
	mov		cl, [si + 1]
	xor 	ch, ch
	mov		bx, cx
	add		si, 2
	cld
cycle:
	lodsb	
	cmp		al, '.'
	jne		skip_double_repeat
	stosb
	stosb
	
	add 	bx, 2
	
skip_double_repeat:
	stosb
	loop	cycle
exit:
	ret
replace_dots endp

start:
	mov		ax, dseg
	mov		ds, ax
	mov		es, ax

	; Intro
	mov 	ah, 09h
	lea 	dx, str_intro
	int		21h
	
	; Read word
	mov 	ah, 0ah
	lea		dx, input_buffer
	int 	21h
	
	; Replace dots
	lea		si, input_buffer
	lea		di, buffer
	call 	replace_dots
	
	; Outro
	call    print_linebreak
	lea		si, buffer
	call	print_word
	
	; Pause
	mov		ah, 01h
	int		21h
	
	mov		ax, 4c00h
	int		21h

cseg ends

dseg segment byte
	
	str_intro db "Enter string with dots: ", '$'
	str_outro db "Repalced: ", '$'
	input_buffer db 254, 256 dup('$')
	buffer db 254, 256 dup('$')

dseg ends

sseg segment

	db 100h dup(?)

sseg ends

end start