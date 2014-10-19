assume cs:cseg, ds:dseg, ss:sseg

include ..\lib.asm

cseg segment
start:
		; Initiating ds, es
		mov		ax, dseg
        	mov 		ds, ax
        	mov 		es, ax
        	
        	; Reading 3 nums
        	mov		ah, 09h
        	lea		dx, str1
        	int		21h
        	
        	mov		cx, 3
        	lea		di, buf
start@cycle:
		call		readln_num
		mov		[di], ax
		add		di, 2
		loop		start@cycle
        	
        	; Comparing and ordering
        	lea		di, buf
        	call		cmp_and_xchg
        	
        	lea		di, buf + 2
        	call		cmp_and_xchg
        	
        	lea		di, buf
        	call		cmp_and_xchg
        	
        	; Writing result
        	mov		ah, 09h
        	lea		dx, str2
        	int		21h
        	
        	mov		cx, 3
        	lea		di, buf
        	call		write_nums
        	
        	call		readln_num	; Test
        
; exit to DOS
        	mov 		ax, 4c00h
        	int 		21h
      
; cmp and xchg for di   	
cmp_and_xchg proc
		mov		ax, [di]
		mov		bx, [di + 2]
		cmp		ax, bx
		jna		cmp_and_xchg@end_if
		xchg		ax, bx
cmp_and_xchg@end_if:
		mov		[di], ax
		mov		[di + 2], bx
		ret
cmp_and_xchg endp

cseg ends

dseg segment byte

		str1 		db "Enter three numbers:",13,10,'$'
		str2		db "Numbers in order:$"
		buf		dw 3 dup(?)

dseg ends

sseg segment stack

        db 100h dup(?)

sseg ends

end start
