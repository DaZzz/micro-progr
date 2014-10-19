		.model 	small
		.stack 	100h
		.code
		
print_from_range proc
print_loop:
	
print_from_range endp
 
start:

; 21 to 2f 
		;mov 	cx, 15
		mov 	dx, 21h
loop1:	
		mov 	ah, 2
		int 	21h
		inc 	dl
		cmp		dl, 2fh
		jne 	loop1
		
		mov dl, 0dh
		int 21h
		mov dl, 0ah
		int 21h

; 3a to 40 
		mov 	cx, 7
		mov 	dx, 3ah
loop2:	
		mov 	ah, 2
		int 	21h
		inc 	dl
		loop 	loop2
		
		mov dl, 0dh
		int 21h
		mov dl, 0ah
		int 21h
		
; 5b to 60 
		mov 	cx, 6
		mov 	dx, 5bh
loop3:	
		mov 	ah, 2
		int 	21h
		inc 	dl
		loop 	loop3
		
		mov dl, 0dh
		int 21h
		mov dl, 0ah
		int 21h

; 7b to 7e 
		mov 	cx, 4
		mov 	dx, 7bh
loop4:	
		mov 	ah, 2
		int 	21h
		inc 	dl
		loop 	loop4
		
		mov dl, 0dh
		int 21h
		mov dl, 0ah
		int 21h
		


; Finishing program
		mov 	ah, 1
		int 	21h
		
		mov 	ax, 4c00h
		int		21h

		end start


	 	