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

;;;
; Swaps [di] and [di+2] if [di+2]
; is greater
;;;
swap_next proc uses ax bx
	mov 	ax, [di]
	mov 	bx,	[di + 2]
	cmp		ax, bx
	
	jna		return		
	mov		[di], bx
	mov		[di + 2], ax	
return:	
	ret
swap_next endp

start:
	; Basic memory setup
	mov 	ax, dseg
	mov 	ds, ax 
	mov 	es, ax
	
	lea 	di, number 
	
	call 	read_number
	mov 	[di], ax
	
	; Printing

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
	number dw ?
dseg ends

end start