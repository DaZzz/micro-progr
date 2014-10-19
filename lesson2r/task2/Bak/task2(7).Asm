.386
assume cs:cseg, ds:dseg, ss:sseg

include ..\lib.asm

cseg segment
start:
		; Initiating ds, es
		mov		eax, dseg
        	mov 		ds, eax
        	mov 		es, eax
        	
        	; Saving to memory powers of 2
        	mov		ecx, 17
        	lea		edi, pwrs
        	mov		ebx, 2
        	xor		edx, edx
        	mov		eax, 1
start@cycle:
		mov		[edi], eax
		add		di, 2
		mov		[di], dx
		add		di, 2
		mul		bx
		loop	start@cycle
		
        	mov		ah, 09h
        	lea		dx, str1
        	int		21h
        	
        	mov		cx, 17
        	lea		di, pwrs
start@cycle2:
		pusha
		mov		ah, 02h
		mov		dl, ' '
		int		21h
		popa
		
		mov		ax, [di]
		call		write_num
		add		di, 2
		loop start@cycle2
        	
        	call		readln_num	; Test
        
; exit to DOS
        	mov 		ax, 4c00h
        	int 		21h

cseg ends

dseg segment byte

		str1 		db "Powers of two:$"
		pwrs		dd 17 dup(?)	

dseg ends

sseg segment stack

        db 100h dup(?)

sseg ends

end start
