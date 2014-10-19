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

; Printing lower case letters		
		mov		cx 26
		mov 	dx 61H
lowercase_loop:	
		mov 	ah, 2
		int 	21h
		inc 	dl
		loop 	numbers_loop

; Printing upper case letters
		mov		cx 26
		mov 	dx 41H
uppercase_loop:	
		mov 	ah, 2
		int 	21h
		inc 	dl
		loop 	numbers_loop
			
		mov 	ah, 1
		int 	21h
		
		ret
		end start
	 	