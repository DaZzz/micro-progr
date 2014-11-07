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
; Check valid current and previous 
;;;
check_valid_word proc uses bx dx cx di si
	lea 	dx, current_word_buffer
	mov		di, dx
	
	lea		dx, previous_word_buffer
	mov		si, dx
	
	; Check eqaul length
	cmp		di, si
	jne		if_false
	
	; Check different 1 symbol
	xor		bh, bh 			; flag that 1 different symbol
	mov		bl, [di + 1]	; length
	
	xor		cx, cx
	mov		cl, bl
	
	; Skip meta indexes
	add		di, 2
	add		si, 2
	
validation_step:
	cmp 	[di], [si]
	je		if_equal
	
	; Not equal
	cmp		bh, 1
	je		if_false
	mov		bh, 1
	
if_equal:
	add		di, 1
	add		si, 1
	loop 	validation_step
	
	cmp		bh,	1
	je	if_true
	
if_false:
	mov		ax, 0
	ret

if_true:
	mov		ax, 1
	ret

check_valid_word endp


;;;
; Input next word and check that correct
;;;
input_next_word proc uses bx dx cx di

try_again:
	; Intro
	mov 	ah, 09h
	lea 	dx, next_word_string
	int		21h
	
	; Read string
	mov 	ah, 0ah
	lea		dx, term_buffer
	int 	21h
	call 	print_linebreak
	
	; Check valid word
	call 	check_valid_word
	
	cmp		ax, 1
	je 		if_valid_word
	jmp		if_not_valid
	
if_not_valid:
	; Print wrong word
	mov 	ah, 09h
	lea 	dx, wrong_word_string
	int		21h
	jmp		try_again

if_valid:
	call	copy_previous_to_current
	ret
input_next_word	endp

;;;
; Main body of the game 
; AX == 1 - win
; AX == 0 - lose
;;;
start_game proc uses bx dx cx di si

event_loop:
	; Input next word
	call	input_next_word

	; Check win
	call	check_is_final
	cmp		ax, 1
	je		if_final
	
	; Check loose
	call	check_is_first
	cmp		ax, 1
	je		if_first
	
	jmp		even_loop
	
if_final:
	mov 	ax, 1
	ret
	
if_first:
	mov		ax, 0
	ret

start_game endp

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
	
	; Main function
	call	start_game
	
	cmp 	ax, 1
	je		if_win
	jmp		if_lose


if_win:
	mov 	ah, 09h
	lea 	dx, you_win_string
	int		21h
	call 	print_linebreak
	jmp 	end_if
	
if_lose:
	mov 	ah, 09h
	lea 	dx, you_lose_string
	int		21h
	call 	print_linebreak
	jmp 	end_if
	
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
	first_string    db "First word: ", '$'
	second_string   db "Second word: ", '$'
	
	you_win_string  db "You win!", '$'
	you_lose_string db "You lose!", '$'
	
	wrong_word_string	db "Wrong word! Try again! Word: ", '$'
	next_word_string	db "Good! Enter next word: ", '$'
	current_word_string	db "Current word: ", '$'
	word_string			db "Imput word: ", '$'
	
	first_buffer    db 254, 256 dup('$')
	second_buffer   db 254, 256 dup('$')
	
	previous_word_buffer		db 254, 256 dup('$')
	current_word_buffer			db 254, 256 dup('$')
	
	linebreak	  	db 13, 10, '$'
dseg ends

end start