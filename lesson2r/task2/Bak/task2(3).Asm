.186
assume cs:cseg, ds:dseg, ss:sseg

include ..\lib.asm

cseg segment
start:
		; Initiating ds, es
		mov		ax, dseg
        	mov 		ds, ax
        	mov 		es, ax
        	
        	; Saving to memory powers of 2
        	mov		cx, 16
        	lea		di, pwrs
        	mov		bx, 2
        	xor		dx, dx
        	mov		ax, 1
start@cycle:
		mov		[di], ax
		add		di, 2
		mul		bx
		loop	start@cycle
		
        	mov		ah, 09h
        	lea		dx, str1
        	int		21h
        	
        	mov		cx, 16
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
		pwrs		dw 16 dup(?)	

dseg ends

sseg segment stack

        db 100h dup(?)

sseg ends

end start
