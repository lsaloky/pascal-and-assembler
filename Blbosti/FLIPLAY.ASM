.MODEL TINY
.CODE
ORG 100h
START:		jmp START2
; pouziva segment $9000 na nacitavanie dat
FliH     db '	              '
w1       dw 0
Handle   dw 0
sseg     dw 0
FRMSize  dd 0

;{ ----- spracovanie prikazoveho riadka ----- }
START2:		mov si,80h
		mov bl,[si]
		xor bh,bh
		mov byte ptr[si+bx+1],0

;{ ----- nahratie animacie (a sucasne pustanie) ----- }
		mov ax,0013h
		int 10h
		mov ax,3D00h   ;{otvor}
		mov dx,82h
		int 21h
		jnc BezChyby
		jmp Total

BezChyby:	mov Handle,ax  ;{nacitaj hlavicku}
		mov bx,ax
		mov cx,22
		lea dx,FLIH
		mov ah,3Fh
		int 21h

		xor cx,cx     ; {presun na poziciu 128}
		mov ax,4200h
		mov bx,Handle
		mov dx,128
		int 21h

		mov ax,09000h
		mov sseg,ax

;{ ----- hlavny cyklus ----- }
OPAKUJ:		mov w1,1
FOR:		mov ax,word ptr [FLIH+6] ;{cyklus}
		cmp w1,ax
		jnae Hop1
		jmp Koniec

Hop1:		inc w1

		mov ah,3Fh	    ;{nacitaj FrmSize}
		mov bx,Handle
		mov cx,4
		lea dx,FrmSize
		int 21h

		push ds	      ; {nacitaj snimku}
		mov ah,3Fh
		mov bx,Handle
		mov cx,word ptr FrmSize
		sub cx,4
		mov dx,2
		mov ds,sseg
		int 21h
		pop ds
;{ ----- zobrazenie snimky ----- }
		push di
		push si
		push es
		push ds

		cld
		mov ds,sseg
		mov si,4
		lodsw
		mov cx,ax	   ; {pocet chunkov}
		cmp cx,0
		jnz JJump
		jmp eend	    ;{snimok sa nezmenil}
JJump:		mov si,14
Main:		push cx
		add si,4	     ;{preskoc dlzku chunku}
		lodsw
		cmp ax,11	    ;{FLIColor}
		jnz m1
		jmp FLICol
m1:		cmp ax,15	    ;{FLIBrun}
		jnz m2
		jmp FLIBrun
m2:		cmp ax,16	    ;{FLICopy}
		jnz m3
		jmp FLICopy
m3:		cmp ax,12	    ;{FLILC}
		jnz m4
		jmp FLILC
M4:		cmp ax,13	    ;{FLIBlack}
		jnz InaMoznost
		jmp FliBlack
InaMoznost:		nop
MainEnd:		pop cx
		loop Main
		jmp eend

FLICol:		mov dx,03DAh
s1:		in al,dx
		test al,8
		jz s1
		lodsw	        ;{FLI Color chunk}
		mov bx,ax
		xor ah,ah
FC1:		lodsb	        ;{kolko farieb sa preskakuje}
		add ah,al
		mov dx,03C8h
		mov al,ah
		out dx,al
		lodsb	        ;{kolko farieb sa zmenilo}
		mov dl,al
		xor dh,dh
		mov cx,dx
		add cx,dx
		add cx,dx
		cmp cx,0
		jnz fc2
		mov cx,768	   ;{0 = 256 farieb}
fc2:		add ah,al
		mov dx,03C9h
Oblb:	     lodsb
		out dx,al
		loop Oblb
		dec bx
		jnz fc1
		jmp MainEnd

FLIBrun:		mov dx,03DAh
skok:		in al,dx	     ;{CakajNaVOI}
		test al,8
		jz skok
		mov ax,0A000h
		mov es,ax
		mov di,0
		mov ah,200
FB0:		lodsb
		mov bl,al
FB1:		lodsb
		mov cl,al
		xor ch,ch
		test cl,128
		ja FFb1
		lodsb
		rep stosb
		jmp ffb2
FFb1:		neg cl
		rep movsb
FFb2:		dec bl
		jnz FB1
		dec ah
		jnz fb0
		jmp MainEnd

FLICopy:		mov ax,0A000h
		mov es,ax
		mov di,0
		mov cx,64000
		rep movsb
		jmp MainEnd

FLILC:		mov dx,03DAh
synch:		in al,dx
		test al,8
		jz synch
		mov ax,0A000h
		mov es,ax
		lodsw
		mov bx,ax
		xor ax,ax
		mov ah,bl
		mov cl,6
		shl bx,cl
		add ax,bx
		mov di,ax
		xor ch,ch
		xor ah,ah
		lodsw
		mov bl,al
		xor ah,ah
FLC1:		lodsb
		cmp al,0
		jz EOL
		push di
		mov bh,al
FLC2:		lodsb
		add di,ax
		lodsb
		mov cl,al
		test cl,128
		ja FLC5
FLC4:		rep movsb
		jmp FLC6
FLC5:		neg cl
		lodsb
		rep stosb
FLC6:		dec bh
		jnz FLC2
		pop di
EOL:		add di,320
		dec bl
		jnz FLC1
		jmp MainEnd

FLIBlack:		mov ax,0A000h
		mov es,ax
		mov di,0
		mov cx,64000
		xor al,al
		rep stosb
		jmp MainEnd

eend:		pop ds
		mov cx,word ptr FLIH+16
		dec cx
		mov dx,03DAh
Synch1:		in al,dx
		test al,8
		jz Synch1
Synch2:		in al,dx
		test al,8
		jnz Synch2
		loop Synch1

		pop es
		pop si
		pop di
;{ ----- snimka je zobrazena ----- }
		mov ah,1	    ;{klavesnica}
		int 16h
		jnz Hop2
		jmp FOR
Hop2:		mov ax,word ptr [FLIH+6]
		mov w1,ax
		jmp FOR	   ;{cyklus FOR}
Koniec:
		xor cx,cx      ;{presun na poziciu 128}
		mov ax,4200h
		mov bx,Handle
		mov dx,128
		int 21h

		mov ah,1       ;{repeat na navestie opakuj}
		int 16h
		jnz Hop3
		jmp OPAKUJ
;{ ----- ukoncenie programu ----- }
Hop3:		mov bx,Handle  ;{zavri subor}
		mov ah,3Eh
		int 21h

Total:		mov ax,3h    ;{zavri grafiku}
		int 10h

TotalKoniec:		mov ax,4C00h
		int 21h
		END START
