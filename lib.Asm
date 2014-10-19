
;;;
; Code
;;;
cseg segment public
		
;;;
; Input number from a keyboard
;;;
read_number proc uses cx bx
	xor 	bx, bx	; zeroize bx
	mov 	cx, 10  ; assign cx to 10 for multiplication 
	
input_one_symbol:
	mov 	ah, 1h 	; input symbol
	int 	21h		; call function 	
	cmp 	al, 13 	; compare AL to enter key
	jz		exit
	xchg	ax, bx	; temporary store ax in bx
	mul		cx		; multiply ax and cx, result goes to dx:ax
	xchg	ax, bx	; swap back
	xor 	ah, ah  ; seroize ah
	sub		al,	'0'	; subtract code symbol from al
	add 	bx, ax	; DX += AX
	jmp		input_one_symbol
exit:
	;mov 	ax, 3	; clear screen
	;int 	10h		; call clear sreen
	mov		ax, bx	; result always goes to ax 
	ret
read_number endp

;;;
; Output number from AX
;;;
print_number proc uses di
	pusha	; put all registers on stack
	mov		di, offset string_buffer
	mov		cx, 5
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
	
number_not_zero:
	mov 	dx, 0 	; to avoid overflow during devision by 10
	mov		cx, 10
	div		cx		; divide AX by CX result goes to AX, rest to DX
	add		dx, '0'	; transform to symbol code
	xchg	ax, dx
	stosb			; write from AX to DI
	xchg	ax, dx
	test 	ax, ax 	; AX != 0 (test is by bit multiplication)
	jnz		number_not_zero
	
	inc 	di      ; compensate last move of a pointer during reading symbols
	mov		dx, di	; last written address to DX
	mov		ah, 09h	; print string in DX on screen
	int		21h		
	popa			; return registers in initial state
	ret
print_number endp

;;;
; Print array of WORD numbers
;;;
print_array proc uses di dx ax
while_has_numbers:
	mov 	ah, 02h 			; print symbol (divisor)
	mov 	dl, ' '
	int		21h
	
	mov 	ax, [di]
	call	print_number
	add		di, 2				; add two because of WORD type
	loop	while_has_numbers
	
	call	print_linebreak
	ret
print_array endp

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
; Print debug message
;;;
print_debug proc uses dx ax
	mov		ah, 09h
	lea		dx, debug_message
	int 	21h
	ret
print_debug endp

cseg ends

;;;
; Data
;;;
dseg segment byte
	string_buffer 	db 6 dup(?), '$'
	linebreak	  	db 13, 10, '$'
	debug_message	db "Debug", 13, 10, '$'
dseg ends