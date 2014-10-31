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
	
	lea 	di, array 
	
	call 	read_number
	mov 	[di], ax
	
	call 	read_number
	mov 	[di + 2], ax
	
	call 	read_number
	mov 	[di + 4], ax	
	
	call 	swap_next
	add 	di, 2
	call 	swap_next
	sub		di, 2
	call 	swap_next
	
	; Printing
	lea 	di, array
	mov		cx, 3
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
	array dw 3 dup(?)
dseg ends

end start