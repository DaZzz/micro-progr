assume cs:cseg, ds:dseg, ss:sseg

;;;
; Includes
;;;
include ..\..\lib.Asm

cseg segment

;;;
; write array from si 
;  cx - length
;  si - source
;;
printArray proc uses ax cx dx si
	
	mov		ah, 02h		; symbol print
	cld
	
cycle:
	lodsb
	mov		dl, al
	add		dl, '0'
	int		21h			; print digit
	mov		dl, ' '
	int		21h			; print space
	loop	cycle
	
	call 	print_linebreak
	
	ret
printArray endp

;;;
; Copy digits from si [length cx] to di with replacing 0 to 1
;;;
copyAndReplace proc uses ax cx di si
	cld
cycle:
	lodsb
	cmp		al, 0
	jne		if_not_zero
	mov		al, 1
if_not_zero:
	stosb
	loop		cycle
	ret
copyAndReplace endp	

start:
	mov		ax, dseg
	mov		ds, ax
	mov		es, ax

	mov		cx, 11

	lea		si, arr1
	call		printArray
	
	lea		di, arr2
	call		copyAndReplace
	
	lea		si, arr2
	call		printArray

	mov		ah, 01h
	int		21h
	
	mov		ax, 4c00h
	int		21h

cseg ends

dseg segment byte

	arr1 db 2, 0, 1, 0, 0, 2, 3, 4, 6, 0, 5
	arr2 db 11 dup(?)

dseg ends

sseg segment

	db 100h dup(?)

sseg ends

end start