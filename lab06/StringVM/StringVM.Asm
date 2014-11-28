        assume  cs:cseg, ds:dseg, ss:sseg
        ; code
cseg    segment
start:
	mov ax, dseg
	mov ds, ax

	mov ax, 3
	int 10h
	mov ax, 0B800h 	;Сегментный адрес видеобуфера
	mov es, ax 		;Инициализируем ES
					;Выводим на экран текст
					; DI - содержит адрес приемника (куда пишем) - es:di !
					; SI - содержит адрес источника (откуда читаем) -  ds:si !
	mov di, 1672 		; Текст выводится посередине экрана
	lea si, txt 
	cld				; Направление обхода цепочек: флаг DF (cld, std). DF=0 — в направлении увеличения адресов, DF=1 — уменьшения.
	mov cx, txt_len/2 ; Длина цепочки задаётся в регистре CX
	rep movsw 		; Итерации задаются префиксом rep* . Окончание указывает на размер элемента цепочки (b - byte, w - word, d - dword)

main@end: 

	mov ah, 1
        int 21h
        ; exit to DOS
        mov     ax, 4C00h
        int     21h

cseg    ends


        ; data
dseg    segment byte public

	txt db 'H',41h, 'e',41h, 'l',41h, 'l'
	db 41h,'o',41h,'!',41h,'!',41h
	txt_len=$-txt 

dseg    ends

        ; stack
sseg    segment stack

        db      100h    dup(?)

sseg    ends
end start
