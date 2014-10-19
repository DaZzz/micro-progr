		.model 	tiny
		.code
		org		100h

start:
		mov 	cx, 10

cloop:	
		mov 	dx, 30h
		mov 	ah, 2
		int 	21h
		inc 	dx
		loop 	cloop
		
		mov 	ah, 1
		int 	21h
		
		ret
		end start
	 	