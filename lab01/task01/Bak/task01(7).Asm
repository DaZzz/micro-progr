		.model 	tiny
		.code
		org		100h

start:
		mov 	cx, 10
		mov 	dx, 30h
		
cloop:	
		mov 	ah, 2
		int 	21h
		inc 	dl
		loop 	cloop
		
		mov 	ah, 1
		int 	21h
		
		ret
		end start
	 	