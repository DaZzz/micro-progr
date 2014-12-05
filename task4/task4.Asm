assume cs:cseg, ds:dseg, ss:sseg

cseg segment

;;;
; Main program
;;;
start:
	mov		ax, dseg
	mov		ds, ax
	mov		es, ax

	lea		si, strs
	mov		cx, 4
	mov		bx, str_sz
	call		print_words
	
	mov		ah, 09h
	lea		dx, str1
	int		21h
	
	call		print_sorted_words

	mov		ah, 01h
	int		21h
	
	mov		ax, 4c00h
	int		21h
	
; Write array of words [wlength bx, alength cx] in si
print_words proc uses ax cx dx
	
	mov		dx, si
cycle:
	mov		ah, 09h
	int		21h
	
	push		dx
	mov		ah, 02h
	mov		dl, ' '
	int		21h
	
	pop		dx
	add		dx, bx
	loop 	cycle
	
	mov		ah, 09h
	lea		dx, str_nl
	int		21h
	
	ret

print_words endp

; Index bubble sort of strs in si, indices in di, size of words in bx, size of strs in cx
pIndSort proc uses ax bx cx si di
	
	p1 equ [bp + 0]
	p2 equ [bp + 2]
	p_strs equ [bp + 4]
	p_inds equ [bp + 6]
	p_c1 equ [bp + 8]
	p_wsz equ [bp + 10]
	p_i1 equ [bp + 12]
	p_i2 equ [bp + 14]
	
	push		ax
	push		ax
	push		ax
	push		ax
	push		ax
	push		ax
	push		ax
	push		ax
	mov		bp, sp
	mov		p_strs, si
	mov		p_inds, di
	mov		p_wsz, bx
	
	cld
	
	; Initing indices
	mov		ax, 0
	push		cx
cycle0:
	stosw
	inc		ax
	loop		cycle0
	pop		cx
	
	; Main cycle
	dec		cx
cycle:
	mov		p_c1, cx
	mov		si, p_inds
	lodsw
	mov		bx, ax		; bx - prev value; ax - next value
cycle2:
	lodsw
	mov		p_i1, bx
	mov		p_i2, ax
	
	push		si
	mov		si, p_strs
	mov		ax, p_wsz
	mul		bx
	add		si, ax
	mov		ax, p_i2
	mov		di, p_strs
	mov		bx, p_wsz
	mul		bx
	add		di, ax
	mov		ax, p_i2
	cmpsb
	jna		sorted
	pop		di
	push		di
	sub		di, 4
	mov		ax, p_i2
	stosw
	mov		ax, p_i1
	stosw
sorted:
	pop		si
	mov		bx, ax
	loop		cycle2
	mov		cx, p_c1
	loop		cycle
	
	pop		ax
	pop		ax
	pop		ax
	pop		ax
	pop		ax
	pop		ax
	pop		ax
	pop		ax
	ret

pIndSort endp

; Write array of words with sort [wlength bx, alength cx] in si
print_sorted_words proc uses ax cx dx di
	
	lea		di, buf
	call		pIndSort
cycle:
	push		si
	mov		si, di
	lodsw
	mov		di, si
	pop		si
	push		si
	mul		bx
	add		si, ax
	
	mov		ah, 09h
	mov		dx, si
	int		21h
	
	mov		ah, 02h
	mov		dl, ' ' 
	int		21h
	
	pop		si		
	loop		cycle
	
	mov		ah, 09h
	lea		dx, str_nl
	int		21h
	
	ret

print_sorted_words endp
	
cseg ends

dseg segment byte

	str_sz dw 10
	strs db "zyy$", 6 dup(?), "zxz$", 6 dup(?), "yzx$", 6 dup(?), "zxy$", 6 dup(?) 
	str_nl db 13, 10, '$'
	buf dw 1000 dup(?)
	str1 db 13,10,"Sorted:",13,10,'$'
	
dseg ends

sseg segment

	db 100h dup(?)

sseg ends

end start