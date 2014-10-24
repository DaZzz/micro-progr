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
	
	call print_debug
	call read_number
	
	; Pause
	mov 	ah,1
	int 	21h
	
	; Exit
	mov     ax, 4C00h
   	int     21h
cseg    ends


; data
dseg    segment byte
dseg    ends


; stack
sseg    segment stack
	db      100h    dup(?)
sseg    ends
end start
