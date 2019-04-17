program MukoSoft_demo;
var Zb:word;  {ukazatel pozicie pri vypisovani "Zbierka..."}
    RotPom,HlavnyCyklus:byte;
    ScrollPom:word;
    s,meno:string;
    a:array[1..38400] of byte;
procedure CakajVOI;assembler;
asm
            mov dx,03DAh
@vz1:       in al,dx
            and al,08h
            jnz @vz1
@vz2:       in al,dx
            and al,08h
            jz @vz2
end;

BEGIN
  s:='MukoSoft'+#13#10#13#10+' uv dza'+#13#10+'Z b i e r k u   a n i m   c i ¡';
  meno:='demo.dat'+#0;
  asm
{ ----- inicializacia ----- }
             cld
             mov ax,0A000h
             mov es,ax
             mov ax,0013h
             int 10h
             mov word[ScrollPom],0
             mov byte[RotPom],36h
             mov byte[HlavnyCyklus],36h
             mov word[Zb],0
             mov dx,03C6h{vypni zobrazovanie}
             mov al,0
             out dx,al
{ ----- vypis textov pri vypnutom zobrazovani ----- }
             mov si,offset s
             mov cl,byte[si]
             inc si
             mov ch,0
             mov bx,53
             mov ah,0Eh
@IniDemo1C1: lodsb
             int 10h
             loop @IniDemo1C1
{ ----- kopirovanie textov do buffrov ----- }
             push ds
             mov ax,0A000h
             mov ds,ax
             mov si,0
             pop es
             mov di,offset a
             mov bl,24
@IniDemo1C2: mov cx,32
         rep movsw
             add si,256
             dec bl
             jnz @IniDemo1C2
             mov di,offset a
             add di,1536
             mov bl,8
@IniDemo1C3: mov cx,124
         rep movsw
             add si,72
             dec bl
             jnz @IniDemo1C3
             push es
             pop ds
             mov ax,0A000h
             mov es,ax
{ ----- citanie ciar zo suboru ----- }
             mov ah,3Dh{otvorenie suboru}
             mov al,0{read only}
             lea dx,meno
             inc dx
             int 21h
             mov bx,ax{handle uloz do BX}
             push ds
             mov ax,0A000h
             mov ds,ax
             mov dx,0
             mov ah,3Fh  {citanie zo suboru}
             mov cx,64000{pocet bajtov}
             int 21h
             pop ds
             mov ah,3Eh{zavri subor}
             int 21h
{ -----  prazdny obdlznik v strede ----- }
            mov di,27324
            mov bl,30
            mov ax,0
@E1Cyklus1: mov cx,36
        rep stosw
            add di,248
            dec bl
            jnz @E1Cyklus1
{ ----- ulozenie podkladu pod "Zbierka" do buffra ----- }
            push ds
            pop es
            mov ax,0A000h
            mov ds,ax
            mov si,47716
            mov di,offset a
            add di,3520
            mov dl,8
@E1Cyklus2: mov cx,124
        rep movsw
            add si,72
            dec dl
            jnz @E1Cyklus2
            push es                  {daj do poriadku segmentove registre}
            pop ds
            mov ax,0A000h
            mov es,ax
            mov dx,03C6h             {zapni zobrazovanie}
            mov al,0FFh
            out dx,al
{ ----- hlavne navestie pre efekty 1-5 ----- }
            mov bx,320               {pocet scrollovanych riadkov*320}
{ ----- rotacia palety ----- }
@E2CHlavny: mov ah,52
            mov al,HlavnyCyklus
            mov RotPom,al
            mov dx,03C8h
@E2Cyklus1: mov al,ah  {dalsia farba}
            out dx,al
            inc dx
            mov al,RotPom
            out dx,al
            out dx,al
            out dx,al
            dec dx
            dec RotPom
            jnz @E2Preskoc1
            mov RotPom,52
@E2Preskoc1:dec ah
            jnz @E2Cyklus1
{ ----- koniec rotacia palety ----- }
            mov ah,52
            cmp bx,8320
            ja @E3Nerob{obchadzanie scrollingu}
            cmp HlavnyCyklus,0
            jp @E3Nerob{obchadzanie scrollingu}
{ ----- Scrolling "MukoSoft uvadza" ----- }
            push bx
            std
            mov di,27390
            add di,bx
            mov si,offset a
            add si,1534
@E3Cyklus1: mov cx,32
        rep movsw
            sub di,256
            sub bx,320
            jnz @E3Cyklus1
            pop bx
            cld
            add bx,320
{ ----- koniec scrollingu "MukoSoft uvadza" ----- }
@E3Nerob:   cmp bx,8320
            jb @E4Nerob{Nevypisuj "Zbierka animacii"}
            cmp [Zb],247
            je @E4Nerob{Nevypisuj "Zbierka animacii"}
            cmp HlavnyCyklus,0
            jp @E4Nerob{Nevypisuj "Zbierka animacii"}
{ ----- vypis "Zbierka animacii" ----- }
            mov bx,48036
            add bx,[zb]
            mov si,offset a
            add si,1536
            add si,[Zb]
            inc [Zb]
            mov cx,8
@E4Cyklus1: mov al,byte[si]
            cmp al,1
            jb @E4Preskoc1
            mov byte[es:bx],al
@E4Preskoc1:add bx,320
            add si,248
            loop @E4Cyklus1
{ ----- koniec vypisu "Zbierka animacii" ----- }
@E4Nerob:   cmp bx,0C69Ah
            jb @E5Nerob{nescrolluj "Zbierka animacii"}
            cmp ScrollPom,12800
            ja @E5Nerob{nescrolluj "Zbierka animacii"}
{ ----- scrolling "Zbierka animacii" ----- }
            mov si,offset a
            add si,3520
            mov di,48036
            add di,[ScrollPom]
            sub di,320
            mov dl,8
@E5Cyklus1: mov cx,124  {prilep povodny podklad}
        rep movsw
            add di,72
            dec dl
            jnz @E5Cyklus1

            mov dl,8
            mov di,48036
            add di,ScrollPom
            mov si,offset a
            add si,1536
@E5Cyklus2: mov cx,248     {prilep riadok napisu}
@E5Cyklus3: mov al,byte[si]{prilep bajt napisu}
            inc si
            cmp al,0
            jz @E5Preskoc1{neprilep bajt}
            mov byte[es:di],al
@E5Preskoc1:inc di
            loop @E5Cyklus3
            add di,72
            dec dl
            jnz @E5Cyklus2

            mov si,offset a{skopiruj do buffra riadok pod nadpisom}
            add si,3520
            add si,248
            mov di,offset a
            add di,3520
            mov cx,868
@E5Cyklus4: mov ax,word[si]
            mov word[di],ax
            add si,2
            add di,2
            loop @E5Cyklus4
            mov si,47716
            add si,ScrollPom
            add si,2560
            mov cx,124
@E5Cyklus5: mov ax,word[es:si]{posun buffer o riadok vyssie}
            mov word[di],ax
            add si,2
            add di,2
            loop @E5Cyklus5
            add [ScrollPom],320
{ ----- koniec scrollingu "Zbierka animacii",ide vertikalne zatemnenie ----- }
@E5Nerob:   call CakajVOI
            mov ah,1
            int 16h{kontroluj stlacenie klavesy}
            jnz @D1Koniec
            dec HlavnyCyklus
            jnz @E2CHlavny{skok na hlavne navestie}
            mov HlavnyCyklus,51
            jmp @E2CHlavny{skok na hlavne navestie}
{ ----- koniec dema 1 ----- }
@D1Koniec:  mov ax,0003h
            int 10h
  end;
END.