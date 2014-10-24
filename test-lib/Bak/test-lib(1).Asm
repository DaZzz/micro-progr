.286
assume  cs:cseg, ds:dseg, ss:sseg

;;;
; Includes
;;;
include ..\lib.Asm 

; code
cseg segment
start:
	; Basic memory setup
	mov 	ax, dseg
	mov 	ds, ax 
	mov 	es, ax
	
	; Read write number test
	;call 	read_number
	;call 	print_number
	;call 	print_linebreak
	
	;call 	read_number
	;call 	print_number
	;call 	print_linebreak
	
	; Test print array
	mov 	cx, 5
	lea 	di, numbers
	call 	print_array 
	
	
	; Pause
	mov 	ah,1
	int 	21h
			
	; Exit
	mov     ax, 4C00h
   	int     21h
cseg    ends


; data
dseg    segment byte
	numbers 			dw 23,34,54,65,76
dseg    ends


; stack
sseg    segment stack
	db      100h    dup(?)
sseg    ends
end start
