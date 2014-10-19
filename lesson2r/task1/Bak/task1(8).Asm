.186
assume cs:cseg, ds:dseg, ss:sseg

include ..\lib.asm

cseg segment
start:
		; Initiating ds, es
		mov		ax, dseg
        	mov 		ds, ax
        	mov 		es, ax
        	
        	; Reading n 			
		mov 		ah, 09h
        	lea		dx,  str1
        	int 		21h
        	
        	call 		readln_num
        	mov 		n, ax      	
        	
        	; Reading n nums
        	mov 		ah, 09h
        	lea 		dx, str2
        	int		21h
        	
        	mov 		ax, n
        	call		write_num
        	
        	mov 		ah, 09h
        	lea 		dx, str3
        	int		21h
 
 		mov 		cx, n
start@cycle:
		pusha
        	call 		readln_num
        	test		ax, 1
        	jz		start@if_even
start@if_odd:
		lea		di, odd_nums
		add		di, odds_cnt
		add		di, odds_cnt
		mov		[di], ax
		inc		odds_cnt		
		jmp 		start@end_if
start@if_even:
		lea		di, even_nums
		add		di, evens_cnt
		add		di, evens_cnt
		mov		[di], ax
		inc		evens_cnt
start@end_if:
        	popa
        	loop		start@cycle
        	
        	; Writing results
        	mov 		ah, 09h
        	lea 		dx, str4
        	int		21h
        	
        	mov		cx, evens_cnt
        	lea		di, even_nums
start@cycle2:
		mov		ah, 02h
		mov		dl, ' '
		int		21h
		
		mov		ax, [di]
		call		write_num
		add		di, 2
		loop		start@cycle2
		
		mov		ah, 02h
		mov		dl, 13
		int		21h
		
		mov		ah, 02h
		mov		dl, 10
		int		21h
		
		mov 		ah, 09h
        	lea 		dx, str5
        	int		21h
        	
        	mov		cx, odds_cnt
        	lea		di, odd_nums
start@cycle3:
		mov		ah, 02h
		mov		dl, ' '
		int		21h
		
		mov		ax, [di]
		call		write_num
		add		di, 2
		loop		start@cycle3
        	
        	call		readln_num	; Test
        
; exit to DOS
        	mov 		ax, 4c00h
        	int 		21h

write_nums proc
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
write_nums endp

cseg ends

dseg segment byte

		str1 		db "Enter amount of numbers (n): $"
		str2 		db "Enter $"
		str3 		db " numbers:",13,10, '$'
		str4		db "Even numbers:$"
		str5		db "Odd numbers:$"
		n		dw 0
		evens_cnt dw 0
		odds_cnt	dw 0
		even_nums dw 1000 dup(?)
		odd_nums dw 1000 dup(?)				

dseg ends

sseg segment stack

        db 100h dup(?)

sseg ends

end start
