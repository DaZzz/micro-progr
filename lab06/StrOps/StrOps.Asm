; Template for DOS .exe file
; Программа позволяет ввести две строки и проверяет,  являются ли эти сроки палиндромом
; Например, строка 1  - ''ab", строка 2 - "ba" вместе составляют палиндром "abba" - название известной группы
        assume  cs:cseg, ds:dseg, ss:sseg

        ; code
cseg    segment
start:
        mov ax, dseg
        mov ds, ax
        mov es, ax
	mov di, offset inString1
	call pInString			; Вводим первую строку с клавиатуры
	
	mov di, offset inString2
	call pInString			; Вводим вторуюую строку с клавиатуры

	mov si, offset inString2
	call pInvertString		;  Инвертируем первую строку
	
	mov dx, offset inString2
	mov ah, 9
	int 21h
		
	mov si, offset inString1
	call pLen				; Считаем длину строки (по адресу в SI)
	mov di, offset inString2
	rep cmpsb ;	rep = repz = repe		; Сравниваем инвертированную строку с первой введенной строкой
	cmp cx, 0
	jz equal

	mov dx, offset notEqMsg
	mov ah, 9
	int 21h
	jmp main@end
	
equal:
	mov si, offset inString2			; Если первая строка и инвертированная строка равны, составляем из введенных строк одну целую строку
	call pInvertString				; Для этого опять инвертируем вторую строку
	
	mov si, offset inString1	; strcpy *outString, *inString1  
	mov di, offset outString			; В результирующую строку последовательно копируем символы
	call pLen
	rep movsb
	
	mov si, offset inString2 ; strcat *outString, *inString2
	call pLen
	rep movsb
	mov al, '$'
	stosb

	mov dx, offset okMsg
	mov ah, 9
	int 21h
	mov dx, offset outString
	mov ah, 9
	int 21h
	
main@end: 
	mov ah, 1
        int 21h
        ; exit to DOS
        mov     ax, 4C00h
        int     21h
pInString proc near
	cld
pInString@inloop:        
	mov ah, 1
        int 21h
        stosb
        cmp al, 13
        jnz pInString@inloop
        mov al, '$'
        stosb
	ret

pInString endp

pLen proc near
	
	push si
	xor cx, cx
	mov al, 13
pLen@l1:	cmp [si], al
	jz pLen@ex
	inc si
	inc cx
	jmp pLen@l1
pLen@ex: pop si
	ret

pLen endp

pInvertString proc near
	mov di, si
	mov al, 13
	cld
	mov cx, 0ffffh  ; if cx < len(*di) we'll quit from repnz loop before
	repnz scasb	;  "String",13,'$'
	sub di, 2		;   ^-si ^-di 
pInvertString@l1:
	;lodsb	; mov al, [si] inc si
	mov al, [si] 
	xchg [di], al
	mov [si],al
	inc si
	dec di
	cmp si,di
	jc pInvertString@l1
	ret

pInvertString endp
cseg    ends


        ; data
dseg    segment byte

        inString1 db 100 dup(?)
        inString2 db 100 dup(?)
        invString db 100 dup(?)
        outString db 200 dup(?)
notEqMsg db "Strings are not suitable for palindrome!$"
okMsg db "We get palindrome: $"
dseg    ends


        ; stack
sseg    segment stack

        db      100h    dup(?)

sseg    ends
end start
