		.model 	tiny
		.code
		org		100h

start:

; Printing numbers 
		mov 	cx, 10
		mov 	dx, 30h
numbers_loop:	
		mov 	ah, 2
		int 	21h
		inc 	dl
		loop 	numbers_loop
		
		mov dl, 0dh
		int 21h
		mov dl, 0ah
		int 21h

; Printing lower case letters		
		mov		cx, 26
		mov 	dx, 61H
lowercase_loop:	
		mov 	ah, 2
		int 	21h
		inc 	dl
		loop 	lowercase_loop
		
		mov dl, 0dh
		int 21h
		mov dl, 0ah
		int 21h

; Printing upper case letters
		mov		cx, 26
		mov 	dx, 41H
uppercase_loop:	
		mov 	ah, 2
		int 	21h
		inc 	dl
		loop 	uppercase_loop

; Finishing program
		mov 	ah, 1
		int 	21h
		ret

linebreak
		end start
	 	