assume cs:cseg, ds:dseg, ss:sseg

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
	
	mov		ah, 09h
	lea		dx, str_nl
	int		21h
	
	ret
printArray endp

; Copy Seq of digits from si [length cx] to di with replacing 0 to 1
copyAndReplace proc uses ax cx di si
	
	cld
cycle:
	lodsb
	cmp		al, 0
	jne		not_zero
	mov		al, 1
not_zero:
	stosb
	loop		cycle
	ret

copyAndReplace endp	

start:
	mov		ax, dseg
	mov		ds, ax
	mov		es, ax

	mov		cx, 13

	lea		si, arr_src
	call		printArray
	
	lea		di, arr_dst
	call		copyAndReplace
	
	lea		si, arr_dst
	call		printArray

	mov		ah, 01h
	int		21h
	
	mov		ax, 4c00h
	int		21h

cseg ends

dseg segment byte

	arr_src db 0, 1, 0, 2, 3, 0, 4, 5, 6, 0, 7, 8, 9
	arr_dst db 13 dup(?)
	str_nl db 13, 10, '$'

dseg ends

sseg segment

	db 100h dup(?)

sseg ends

end start