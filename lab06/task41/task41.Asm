assume cs:cseg, ds:dseg, ss:sseg

cseg segment

;;;
; Functions
;;;

;;;
; Bubble sort
; si - array
; bx - string lengths
; di - indexes
;;;
bubble_sort proc uses ax bx cx si di
	
	ret
bubble_sort endp


;;;
; Main program
;;;
start:
	mov		ax, dseg
	mov		ds, ax
	mov		es, ax
	
	; Intro string
	mov		ah, 09h
	lea		dx, str_intro
	int		21h

	; Pause
	mov		ah, 01h
	int		21h
	
	mov		ax, 4c00h
	int		21h

cseg ends

dseg segment byte
	str_sz dw 10
	strs db "zyy$", 6 dup(?), "zxz$", 6 dup(?), "yzx$", 6 dup(?), "zxy$", 6 dup(?) 
	str_nl db 13, 10, '$'
	buf dw 1000 dup(?)
	str1 db 13,10,"Sorted array:",13,10,'$'
	str_intro db "Initial array: ",13,10,'$'
dseg ends

sseg segment

	db 100h dup(?)

sseg ends

end start