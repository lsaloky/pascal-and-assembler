program MukoSoft_demo_2;
{const kruh:array[0..41] of word=(0,5,8,11,13,15,17,19,21,23,24,25,26,27,28,29,30,31,32,32,33,33,34,34,35,35,36,36,37,37,38,38,
                                 38,39,39,39,40,40,40,40,40,0);}
{const hviezda:array[1..100] of byte=(0,0,0,0,1,1,0,0,0,0,
                                     0,0,0,0,2,2,0,0,0,0,
                                     0,0,0,1,3,3,1,0,0,0,
                                     0,0,1,3,4,4,3,1,0,0,
                                     1,2,3,4,5,5,4,3,2,1,
                                     1,2,3,4,5,5,4,3,2,1,
                                     0,0,1,3,4,4,3,1,0,0,
                                     0,0,0,1,3,3,1,0,0,0,
                                     0,0,0,0,2,2,0,0,0,0,
                                     0,0,0,0,1,1,0,0,0,0);
const zdroj:array[1..104] of word=(20,20, 140,22, 190,12, 225,7, 290,13,
                                   5,27, 45,32, 100,37, 192,21, 256,29,
                                   32,43, 69,57, 124,49, 181,33, 289,41,
                                   17,60, 46,71, 152,65, 249,75, 221,68,
                                   22,81, 31,83, 162,72, 208,80, 268,72,
                                   45,103, 72,109, 164,92, 263,108, 288,92,
                                   14,124, 68,118, 122,109, 180,100, 200,120,
                                   56,139, 109,141, 159,129, 261,122, 302,128,
                                   12,151, 29,145, 160,151, 238,140, 284,153,
                                   46,172, 92,181, 109,162, 167,185, 223,173,
                                   268,187, 302,179);
const ciel:array[1..104] of word=(50,40, 62,40, 74,40, 86,40,
                                  44,48, 56,48, 68,48, 80,48, 92,48,
                                  38,56, 50,56, 62,56, 74,56, 86,56, 98,56,
                                  32,64, 44,64, 56,64, 68,64, 80,64, 92,64, 104,64,
                                  26,72, 38,72, 50,72, 62,72, 74,72, 86,72, 98,72, 110,72,
                                  32,80, 44,80, 56,80, 68,80, 80,80, 92,80, 104,80,
                                  38,88, 50,88, 62,88, 74,88, 86,88, 98,88,
                                  44,96, 56,96, 68,96, 80,96, 92,96,
                                  50,104, 62,104, 74,104, 86,104);}
{offsety v premennej a: 0 hviezda, 100 zdroj, 308 ciel,516 kruh,39790 pom}
var Zb,ScrollPom,PocetHviezd,AktualnaHviezda,CisloSnimku,FHandle:word;
    PosunFarby,RotPom,HlavnyCyklus:byte;
    s,Meno:string;
    a:array[0..63999] of byte;
procedure CakajVOI;assembler;{znici DX,AL}
asm
              mov dx,03DAh
@vz1:         in al,dx
              and al,08h
              jnz @vz1
@vz2:         in al,dx
              and al,08h
              jz @vz2
end;
procedure KresliHviezdu;assembler;{znici AX,BX,CX,DX,SI,DI}
asm
             mov bx,39792
             add bx,AktualnaHviezda
             lea si,a
             add bx,offset a       {adresa Y-sur. ->BX}
             mov al,0              {vynasob 320}
             mov ah,byte[bx]
             mov dh,0
             mov dl,ah
             shl dx,6
             add ax,dx
             sub bx,2
             add ax,[bx]            {pripocitaj X-sur.}
             mov di,ax
             mov dl,10
             mov cx,10
@D2ProcC1:   lodsb
             cmp PosunFarby,0
             je @D2PPreskoc
             cmp al,0
             je @D2PNekresli
             add al,PosunFarby
@D2PPreskoc: mov [es:di],al
@D2PNekresli:inc di
             loop @D2ProcC1
             add di,310
             dec dl
             mov cx,10
             jnz @D2ProcC1
end;
BEGIN
  meno:='demo.dat'+#0;
  s:='MukoSoft'+#13#10#13#10+' uv dza'+#13#10+'Z b i e r k u   a n i m   c i ¡';
asm
{ ----- inicializacia dema 1 ----- }
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
             mov FHandle,ax{aj do FHandle}
             push ds
             mov ax,0A000h
             mov ds,ax
             mov dx,0
             mov ah,3Fh  {citanie zo suboru}
             mov cx,64000{pocet bajtov}
             int 21h
             pop ds
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
{ ----- koniec dema 1, inicializacia dema 2 ----- }
@D1Koniec:   mov di,0
             mov cx,32000
             mov ax,0
         rep stosw    {zmazanie obrazovky}
             mov PosunFarby,0
             mov PocetHviezd,208      {nasobky 4}
             mov AktualnaHviezda,208  {nasobky 4}
             mov CisloSnimku,1
             mov ah,3Fh  {citanie dat}
             lea dx,a
             mov cx,600
             mov bx,FHandle
             int 21h
             mov ah,3Eh  {zavretie suboru}
             int 21h
             lea si,a[100]
             mov cx,104
{ ----- kopirovanie z indexu 100 na 39790 (pomocne pole) ----- }
@D2IniC1:    mov ax,word[si]
             mov word[si+39690],ax
             add si,2
             loop @D2IniC1
{ ----- vykreslenie hviezd ----- }
@D2E1C1:     sub AktualnaHviezda,4
             call KresliHviezdu
             cmp AktualnaHviezda,0
             jne @D2E1C1
{----- rozsvietenie hviezd ----- }
             mov cl,1
@D2E2C1:     mov dx,03C8h               {nastav paletu}
             mov bl,1
             mov bh,cl
@D2E2C2:     mov al,bl
             out dx,al
             inc dx
             mov al,bh
             out dx,al
             out dx,al
             xor al,al
             out dx,al
             dec dx
             inc bl
             add bh,cl
             cmp bl,10
             jbe @D2E2C2
             call CakajVOI
             call CakajVOI
             call CakajVOI
             inc cl
             cmp cl,12
             jbe @D2E2C1
{ ----- animacia ----- }
             mov AktualnaHviezda,0
@D2E3C1:     lea si,a[308]            {rozdiel suradnic}
             add si,AktualnaHviezda
             mov ax,[si]
             lea si,a[100]
             add si,AktualnaHviezda
             sub ax,[si]
             imul CisloSnimku         {vynasob cislom snimku}
             jns @D2E2Preskoc
             mov al,ah                {vydel 256 (poctom snimkov)}
             mov ah,0FFh
             jmp @D2E2Dalej
@D2E2Preskoc:mov al,ah
             mov ah,0
@D2E2Dalej:  add ax,[si]              {pripocitaj k povodnej polohe}
             lea di,a[39790]
             add di,AktualnaHviezda
             mov [di],ax              {a uloz novu polohu}
             add AktualnaHviezda,2
             cmp AktualnaHviezda,208
             jb @D2E3C1
             call CakajVOI
@D2E3C2:     sub AktualnaHviezda,4    {vykresli hviezdy v novej polohe}
             call KresliHviezdu
             cmp AktualnaHviezda,0
             jne @D2E3C2
             inc CisloSnimku
             cmp CisloSnimku,255
             jbe @D2E3C1
{ ----- kreslenie slnka: nastavenie farieb na nulu ----- }
             mov cx,64
             mov dx,03C8h
@D2E4Zac:    mov al,cl
             add al,10
             out dx,al
             inc dx
             xor al,al
             out dx,al
             out dx,al
             out dx,al
             dec dx
             loop @D2E4Zac
{ ----- kreslenie slnka ----- }
             lea si,a[516]
             mov di,11908
             mov al,10
             add si,2
             mov cx,[si]
@D2E4C1:     cmp byte[es:di],4 {horna polovica}
             ja @D2E4Nepis1
             mov word[es:di],ax
             mov ah,al
             add al,2
             cmp al,74
             jb @D2E4Nepis1
             sub al,61
@D2E4Nepis1: add di,2
             loop @D2E4C1
             add di,320
             sub di,[si]
             sub di,[si+2]
             add si,2
             mov cx,[si]
             cmp word[si],0
             jnz @D2E4C1
             sub si,2
             sub di,40
             mov cx,[si]
@D2E4C2:     cmp byte[es:di],4{dolna polovica}
             ja @D2E4Nepis2
             mov word[es:di],ax
             mov ah,al
             add al,2
             cmp al,74
             jb @D2E4Nepis2
             sub al,61
@D2E4Nepis2: add di,2
             loop @D2E4C2
             add di,320
             sub di,[si]
             sub di,[si-2]
             sub si,2
             mov cx,[si]
             cmp word[si],0
             jnz @D2E4C2
{ ----- slnko: rozjasnievanie ----- }
             mov bx,63
@D2E4C4:     mov cx,bx
             mov dx,03C8h
@D2E4C3:     mov al,74
             sub al,cl
             out dx,al
             inc dx
             mov al,64
             sub al,bl
             out dx,al
             out dx,al
             xor al,al
             out dx,al
             dec dx
             loop @D2E4C3
             call CakajVOI
             dec bx
             jnz @D2E4C4
{ ----- nastavenie farieb pre oblohu ----- }
             mov dx,03C8h
             mov cx,64
@D2E5C2:     mov al,cl
             add al,74
             out dx,al
             inc dx
             xor al,al
             out dx,al
             out dx,al
             mov al,cl
             cmp al,32
             ja @D2E5Nezvys
             add al,32
@D2E5Nezvys: out dx,al
             dec dx
             loop @D2E5C2
{ ----- nastavenie farby paprskov ----- }
             mov al,1
             out dx,al
             inc dx
             mov al,63
             out dx,al
             out dx,al
             xor al,al
             out dx,al
{ ----- kreslenie oblohy ----- }
             xor bx,bx
             mov di,0
             xor dh,dh
@D2E5C1:     mov dl,[es:di]
             cmp al,115
             jbe @D2E5Menej
             ja @D2E5Viac
@D2E5Menej:  mov dh,1
             jmp @D2E5Pokr
@D2E5Viac:   xor dh,dh
@D2E5Pokr:   cmp dl,dh
             ja @D2E5Nepis
             mov al,[cs:bx]
             shr al,2
             add al,75
             mov [es:di],al
@D2E5Nepis:  inc bx
{ !!!!! Nasledujuce cislo mozes zvysit, az bude dlhsi program !!!!! }
             cmp bx,2500
             jb @D2E5Nenuluj
             xor bx,bx
@D2E5Nenuluj:inc di
             cmp di,64000
             jbe @D2E5C1
{ ----- let lietadla:nastavenie farieb pre smog ----- }
             mov dx,03C8h
             mov cl,140
@D2E6C4:     mov al,cl
             out dx,al
             inc dx
             sub al,140
             out dx,al
             out dx,al
             out dx,al
             dec dx
             inc cl
             cmp cl,204
             jb @D2E6C4
{ ----- let lietadla:kreslenie smogu ----- }
             mov dx,44479
             mov di,44479
             mov bx,1
@D2E6C1:     mov cx,bx
             cmp cx,320
             jb @D2E6Skok3
             not cx
             add cx,460
@D2E6Skok3:  cmp cx,140
             jb @D2E6C2
             mov cx,139
@D2E6C2:     mov ah,byte[cs:si]
             shr ah,2
             add ah,140
             mov byte[es:di],ah{horna polovica smogu}
             inc si
             add di,319
{ !!!!! Nasledujuce cislo mozes zvysit, az bude dlhsi program !!!!! }
             cmp si,2030
             jb @D2E6Skok1
             mov si,0
@D2E6Skok1:  loop @D2E6C2
             add di,1
             cmp di,44479
             ja @D2E6Skok4
             push ax
             mov ax,44480
             sub ax,di
             add di,ax
             add di,ax
             pop ax
@D2E6Skok4:  mov cx,bx
             cmp cx,379
             jb @D2E6Skok5
             mov cx,1
@D2E6Skok5:  cmp cx,320
             jb @D2E6Skok6
             not cx
             add cx,382{tu}
@D2E6Skok6:  cmp cx,60
             jb @D2E6C3
             mov cx,61
@D2E6C3:     mov ah,byte[cs:si]
             shr ah,2
             add ah,140
             mov byte[es:di],ah{dolna polovica smogu}
             inc si
             add di,321
{ !!!!! Nasledujuce cislo mozes zvysit, az bude dlhsi program !!!!! }
             cmp si,2030
             jb @D2E6Skok2
             mov si,0
@D2E6Skok2:  loop @D2E6C3
             sub dx,320
             mov di,dx
             inc bx
             push dx
             call CakajVoi
             pop dx
             cmp bx,140
             jb @D2E6C1
             add dx,319
             mov di,dx
             cmp bx,459
             jb @D2E6C1
{ ----- ukoncenie programu ----- }
@D2Koniec:   mov ah,0
             int 16h
             mov ax,3
             int 10h
  end;
  WriteLn('MukoSoft demo'#13#10'Lubos Saloky, 1996');
END.