assume cs:cseg, ds:dseg, ss:sseg

;;;
; Includes
;;;
include ..\..\lib.Asm

cseg segment

;;;
; Replaces dots with triple dots
;;;
replace_dots proc uses si dx ax bx
	cld
cycle:
	lodsb
	cmp al, '$'
	je	exit
	
	cmp		al, '.'
	jne		skip_double_repeat
	stosb
	stosb
	
skip_double_repeat:
	stosb
	jmp	cycle

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
	mov 	ah, 09h
	lea 	dx, str_outro
	int		21h
	
	; Write new
	mov 	ah, 09h
	lea 	dx, buffer + 2
	int		21h
	
	
	
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