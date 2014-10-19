assume cs:cseg, ds:dseg, ss:sseg

include ..\lib.asm

cseg segment
start:
		; Initiating ds, es
		mov		ax, dseg
        	mov 		ds, ax
        	mov 		es, ax
        	
        	; Reading number
        	mov		ah, 09h
        	lea		dx, str1
        	int		21h
        	
        	call		readln_num
        	mov		n, ax
        	
        	; Writing numbers
        	; DEC
        	mov		ah, 09h
        	lea		dx, str2
        	int		21h
        	
        	mov		ax, n
        	mov		base, 10
        	call		writeln_num_b 
        	
        	; BIN
        	mov		ah, 09h
        	lea		dx, str3
        	int		21h
        	
        	mov		ax, n
        	mov		base, 2
        	call		writeln_num_b
        	
        	; HEX
        	mov		ah, 09h
        	lea		dx, str4
        	int		21h
        	
        	mov		ax, n
        	mov		base, 16
        	call		writeln_num_b        	
        	
        	call		readln_num	; Test
        
; exit to DOS
        	mov 		ax, 4c00h
        	int 		21h

; Write line num from ax to stdout with base
writeln_num_b proc uses di bx cx dx ax
; Making str_buf = "      "
		lea		di, str_buf
		mov 		cx, 5
		mov		bl, ' '
writeln_num_b@cycle:
		mov 		[di], bl
		inc		di
		loop writeln_num_b@cycle
		std
writeln_num_b@cycle2:
		xor		dx, dx
		mov		cx, base
		div 		cx
		cmp		dx, 9
		ja		writeln_num_b@else
		add		dx, '0'
		jmp		writeln_num_b@end_if
writeln_num_b@else:
		sub		dx, 10
writeln_num_b@end_if:
		xchg		ax, dx
		stosb
		xchg		ax, dx
		test		ax, ax
		jnz		writeln_num_b@cycle2
		inc		di	
		mov 		dx, di
		mov		ah, 09h
		int		21h
		mov		ah, 09h
        	lea		dx, nl
        	int		21h
		ret		
writeln_num_b endp

cseg ends

dseg segment byte

		str1 		db "Enter number: $"
		str2		db "DEC number: $"
		str3		db "BIN number: $"
		str4		db "HEX number: $"
		nl		db 13,10,'$'
		n		dw ?
		base		dw ?

dseg ends

sseg segment stack

        db 100h dup(?)

sseg ends

end start
