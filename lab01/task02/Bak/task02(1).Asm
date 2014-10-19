		.model 	small
		.stack 	100h
		.code
		
print_from_range proc
		mov 	ah, 2
print_loop:		
		int 	21h
		inc 	dl
		cmp		dl, dh
		jne 	print_loop
		
		mov dl, 0dh
		int 21h
		mov dl, 0ah
		int 21h
		ret
print_from_range endp
		
start:

; 21 to 2f 
		mov 	dl, 21h
		mov		dh, 2fh
		call print_from_range


; 3a to 40 
		mov 	dl, 3ah
		mov		dh, 40h
		call print_from_range
		
; 5b to 60 
		mov 	dl, 5bh
		mov		dh, 60h
		call print_from_range

; 7b to 7e 
		mov 	dl, 7bh
		mov		dh, 7eh
		call print_from_range

; Finishing program
		mov 	ah, 1
		int 	21h
		
		mov 	ax, 4c00h
		int		21h

		end start


	 	