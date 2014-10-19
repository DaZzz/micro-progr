cseg segment public

; Reads num from stdin to ax        
readln_num proc uses bx cx
		xor 		bx, bx	
		mov 		cx, 10
readln_num@cycle:
		mov 		ah, 1h
		int 		21h
		cmp 		al, 13
		jz 		readln_num@exit
		xchg 	ax, bx
		mul 		cx
		xchg 	ax, bx
		xor 		ah, ah
		sub 		al, '0'
		add 		bx, ax
		jmp 		readln_num@cycle
readln_num@exit:
        	mov 		ah, 2h
        	mov		dl, 0ah
        	int 		21h
        	mov		dl, 0dh
        	int		21h        	
		mov 		ax, bx
		ret
readln_num endp

; Write num from ax to stdout
write_num proc uses di bx cx dx ax
; Making str_buf = "      "
		lea		di, str_buf
		mov 		cx, 5
		mov		bl, ' '
write_num@cycle:
		mov 		[di], bl
		inc		di
		loop write_num@cycle
		std
write_num@cycle2:
		xor		dx, dx
		mov		cx, 10
		div 		cx
		add		dx, '0'
		xchg		ax, dx
		stosb
		xchg		ax, dx
		test		ax, ax
		jnz		write_num@cycle2
		inc		di	
		mov 		dx, di
		mov		ah, 09h
		int		21h
		ret		
write_num endp

; Write line set of nums to stdout: counter in cx, offset in di
write_nums proc uses ax
write_nums@cycle:
		mov		ah, 02h
		mov		dl, ' '
		int		21h
		
		mov		ax, [di]
		call		write_num
		add		di, 2
		loop		write_nums@cycle
		
		mov		ah, 02h
		mov		dl, 13
		int		21h
		
		mov		ah, 02h
		mov		dl, 10
		int		21h
		
		ret
write_nums endp

cseg ends

dseg segment byte public

		str_buf 	db 6 dup(?)
				db '$'

dseg ends