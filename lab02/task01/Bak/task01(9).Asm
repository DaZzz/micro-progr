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

;;;
; Read n numbers from keyboard
;;;
read_n_numbers proc uses cx
	mov 	cx, n
while_has_numbers:
	call	read_number
	test	ax, 1
	jz	 	if_even
	jmp		if_odd

if_even:
	lea 	di, even_numbers	; put even numbers address to di
	add		di, even_count		; add twice index, because of dw type
	add		di, even_count
	mov 	[di], ax			; put next number to [di]
	inc		even_count			; increment even numbers counter
	jmp		end_if
	
if_odd:
	lea 	di, odd_numbers
	add		di, odd_count
	add		di, odd_count
	mov 	[di], ax
	inc		odd_count
	jmp		end_if

end_if:
	loop 	while_has_numbers
	ret
read_n_numbers endp

start:
	; Basic memory setup
	mov 	ax, dseg
	mov 	ds, ax 
	mov 	es, ax
	
	; Input n
	mov 	ah, 09h
	lea 	dx, str_enter_n
	int 	21h
	call 	read_number
	mov 	n, ax
	
	; Read n numbers
	mov 	ah, 09h
	lea		dx, str_enter_numbers
	int 	21h
	call	read_n_numbers
		
	; Output 
	mov		cx, even_count
	lea		di, even_numbers
	call	print_array
	
	; Output 
	mov		cx, odd_count
	lea		di, odd_numbers
	call	print_array
		
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
	str_enter_n		 	db "Enter N: $"
	str_enter_numbers	db "Enter N numbers:", 10, 13, '$'
	str_even_numbers	db "Even numbers: $"
	str_odd_numbers		db "Odd numbers: $"
	n					dw ?
	even_count 			dw 0
	odd_count			dw 0
	even_numbers		dw 100 dup(?)
	odd_numbers			dw 100 dup(?)
dseg ends

end start