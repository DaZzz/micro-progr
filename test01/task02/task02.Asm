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
; Main body of the game 
; AX == 1 - win
; AX == 0 - lose
;;;
start_game proc uses bx dx cx di si
	mov		ax, 1
	
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

	linebreak	  	db 13, 10, '$'
dseg ends

end start