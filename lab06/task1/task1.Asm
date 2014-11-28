assume  cs:cseg, ds:dseg, ss:sseg

        ; code
cseg    segment
start:
	mov 	ax, dseg
	mov 	ds, ax

	mov 	ax, 3
	int 	10h
	mov 	ax, 0B800h
	mov 	es, ax 		
					
					
					
	mov 	di, 1672 	
	lea 	si, txt
	cld				
	mov 	cx, txt_len/2 
	rep 	movsw

	mov 	ah, 1
    int 	21h
    
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
