.286
assume cs:cseg, ds:dseg, ss:sseg

;;;
; Includes
;;;
include ..\..\lib.Asm


;;;
; Code
;;;
cseg segment 

start:
	; Basic memory setup
	mov 	ax, dseg
	mov 	ds, ax 
	mov 	es, ax
	
	mov 	cx, 15  ; assign cx to 10 for multiplication 
next_power:
	mov 	[di], bx
	shl     bx
	jmp		next_power
	
    call 	print     
	mov		ax, bx	; result always goes to ax 
	ret
	
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
	powers_of_two	 	dw 15 dup(?)
dseg ends

end start