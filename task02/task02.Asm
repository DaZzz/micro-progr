.286
assume cs:cseg, ds:dseg, ss:sseg

;;;
; Includes
;;;
include ..\lib.Asm


;;;
; Code
;;;
cseg segment 

start:
	; Basic memory setup
	mov 	ax, dseg
	mov 	ds, ax 
	mov 	es, ax
	
	mov 	cx, 16  ; power of two
	mov 	ax, 1	; store current number
	mov 	bx, 2	; store power
	lea		di, powers_of_two
	
next_power:
	mov 	[di], ax
	add 	di, 2
	mul     bx
	loop	next_power
	
	mov 	cx, 16
	lea 	di, powers_of_two  
    call 	print_array     
	
	; Pause
	mov 	ah,1
	int 	21h
	
   	; exit DOS
    mov     ax, 4C00h
    int     21h
cseg ends

;;;
; Stack
;;;
sseg segment 
	stack db 100h dup(?)
sseg ends

;;;
; Data
;;;
dseg segment byte 
	powers_of_two	 	dw 16 dup(?)
dseg ends

end start