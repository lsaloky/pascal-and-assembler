{ZOZNAM PROCEDUR:

----- pred volanim akejkolvek procedury zavolaj VypniKurzorMysi -----

  CakajNaVOI;assembler;
  VykresliLavuCast;assembler;      ES,SI,DI
  VykresliPravuCast;assembler;     ES,SI,DI
  VykresliStred;assembler;         ES,SI,DI
  VykresliCennik;assembler;        ES,SI
  VykresliHra;assembler;           ES,SI
  VykresliPomoc;assembler;         ES,SI
  VykresliBMPTlacidlo;assembler;   ES,SI,pomw
  Bod(x,y:word;col:byte);
  NakresliAktivnuOblast;assembler;
  CiaraVodorovna;assembler;        sx,sy,color,kolko:word;
  CiaraZvisla;assembler;           sx,sy,color,kolko:word;
  VykresliLudiaRuda;assembler;     ES,SI,DI
  NalepText;                       sx,sy:word;s:string;
  ZacierniPlochu;assembler;        DI,AX,DX stlpce,BX riadky
  PrilepObjekt;assembler;          prilepi,pozri popis pri procedure
  NakresliDom;assember;            CX y-ova sur. DX x-ova
  NakresliBanu;assembler;
  NakresliSklad;assembler;
  NakresliBlok;assembler;
  NakresliKino;assembler;
----- tieto si samy volaju VypniKurzorMysi -----
  ObnovPodkladPodZvisListou;assembler;
  ObnovPodkladPodVodListou;assembler;
  NakresliVodorovnuListu;assembler;
  NakresliZvisluListu;assembler;
  NakresliObjekty;assembler;       nakresli vsetko na pracovnej ploche
----- az potial -----
  UlozPodklad;assembler;           pri ukladani objektu
  ObnovPodklad;assembler;
  PosunVRAMHore;assembler;
  PosunVRAMDole;assembler;
  PosunVRAMVlavo;assembler;
  PosunVRAMVpravo;assembler;
  ZmazOblastVBocnomMenu;assembler;  sx,sy,kolko; vyska je 8

subor BITMAPY.DAT:
offset   typ      popis
0        pole     paleta
768      byte     pocet bitmap
769      2 byte   x,y sur. 1. bitmapy
771      pole     bitmapa - lava cast tlacitka nestlaceneho
                          - centralna cast
                          - trava
                          - lava cast tlacitka stlaceneho
                          - centralna cast
                          - bana
                          - sklad
                          - dom
                          - blok}
procedure CakajNaVOI;assembler;
asm
             mov dx,03DAh
@vz1:        in al,dx
             and al,08h
             jnz @vz1
@vz2:        in al,dx
             and al,08h
             jz @vz2
end;
procedure VykresliLavuCast;assembler;{SI,DI musi byt nastavene}
asm
             mov bx,16
@DalsiR1:    mov cx,8
         rep movsw
             add di,304
             dec bx
             jnz @DalsiR1
end;
procedure VykresliStred;assembler;{SI,DI musi byt nastavene}
asm
             mov bx,16
@DalsiR2:    mov cx,8
         rep movsw
             add di,304
             dec bx
             jnz @DalsiR2
end;
procedure VykresliPravuCast;assembler;{nastav DI na pravy horny roh}
asm
             mov cx,16
             mov bx,16
@DalsiR3:    mov al,byte[si]
             mov byte[es:di],al
             inc si
             dec di
             dec bx
             jnz @DalsiR3
             mov bx,16
             add di,336
             dec cx
             jnz @DalsiR3
end;
procedure VykresliCennik;assembler;{SI musi byt inicializovane}
asm
             mov dx,si
             mov di,1284
             call VykresliLavuCast
             mov si,dx
             add si,256
             mov di,1284+16
             call VykresliStred
             mov si,dx
             add si,256
             mov di,1284+32
             call VykresliStred
             mov si,dx
             mov di,1284+63
             call VykresliPravuCast
end;
procedure VykresliHra;assembler;
asm
             mov dx,si
             mov di,1284+68
             call VykresliLavuCast
             mov si,dx
             add si,256
             mov di,1284+68+16
             call VykresliStred
             mov si,dx
             mov di,1284+68+47
             call VykresliPravuCast
end;
procedure VykresliPomoc;assembler;
asm
             mov dx,si
             mov di,1284+120
             call VykresliLavuCast
             mov si,dx
             add si,256
             mov di, 1284+136
             call VykresliStred
             mov si,dx
             add si,256
             mov di, 1284+152
             call VykresliStred
             mov si,dx
             mov di,1284+183
             call VykresliPravuCast
end;
procedure VykresliBMPTlacidlo;assembler;{pomw - offset ciela, SI musi byt inicializovane}
asm
             mov dx,si
             mov di,pomw
             call VykresliLavuCast
             mov si,dx
             add si,256
             mov di,pomw
             add di,16
             call VykresliStred
             mov si,dx
             add si,256
             mov di,pomw
             add di,32
             call VykresliStred
             mov si,dx
             mov di,pomw
             add di,63
             call VykresliPravuCast
end;
procedure Bod(px,py:word;col:byte);
begin
  asm
             call InitAsm
             mov cx,320
             mov ax,py
             mul cx
             add ax,px
             mov di,ax
             mov al,col
             mov [es:di],al
  end;
end;
procedure NakresliAktivnuOblast;assembler;
asm
             call InitAsm
             test lhx,1
             jz @Parne
             mov pomw,65528
             jmp @NastavPomw2
@Parne:      mov pomw,0
@NastavPomw2:test lhy,1
             jz @Parne2
             mov pomw2,24*320
             jmp @Hotovo
@Parne2:     mov pomw2,16*320
@Hotovo:     lea si,pom
             add si,512
             mov pomw3,si
             add pomw3,256    {pomw3 je koncovy offset}
             xor ah,ah
             xor cx,cx        {AH pocitadlo x,CX y}
@NovyOffset: mov bx,pomw      {BX x-ova INTEGER!!!}
             mov dx,pomw2     {DX y-ova WORD!!!}
             add bl,ah
             add dx,cx
@DalsiBod:   cmp bx,sx1         {podmienky okna}
             jl @Nekresli
             cmp bx,sx2
             jg @Nekresli
             cmp dx,sy1
             jb @Nekresli
             cmp dx,sy2
             ja @Nekresli
             mov di,dx         {bod}
             add di,bx
             mov al,byte[si]
             mov byte[es:di],al
@Nekresli:   add bx,16          {ten isty bod o 16 bodov dalej}
             cmp bx,240
             jl @DalsiBod
             mov bx,pomw
             add bl,ah
             add dx,320*16      {prechod na dalsi riadok}
             cmp dx,sy2
             jbe @DalsiBod
             inc si
             inc ah
             cmp ah,16
             jb @NovyOffset
             xor ah,ah
             add cx,320
             cmp cx,16*320
             jb @NovyOffset
             cmp si,pomw3
             jb @DalsiBod
end;
procedure CiaraVodorovna;assembler;
{hodnoty v premennych sx,sy,color,kolko:byte}
asm
             call InitAsm
             mov cx,320
             mov ax,sy
             mul cx
             add ax,sx
             mov di,ax
             mov al,color
             mov cx,kolko
         rep stosb
end;
procedure CiaraZvisla;assembler;
asm
             call InitAsm
             mov cx,320
             mov ax,sy
             mul cx
             add ax,sx
             mov di,ax
             mov al,color
             mov cx,kolko
@DalsiBod:   mov [es:di],al
             add di,320
             loop @DalsiBod
end;
procedure VykresliLudiaRuda;assembler;{SI musi byt nastavene}
asm
             call CakajNaVOI
             mov bx,16
@DalsiR1:    mov cx,20
         rep movsw
             add di,280
             dec bx
             jnz @DalsiR1
             lea si,BocnyPodklad
             mov di,36*320+236
             mov bx,40
@DalsiR2:    mov cx,20
@DalsiBod:   mov ax,word[si]
             mov word[es:di],ax
             mov word[es:di+40],ax
             mov word[es:di+12800],ax
             mov word[es:di+12840],ax
             mov word[es:di+25600],ax
             mov word[es:di+25640],ax
             add si,2
             add di,2
             loop @DalsiBod
             add di,280
             dec bx
             jnz @DalsiR2
{ ----- kreslenie obvodovych ciar ----- }
             mov sy,36
             mov kolko,120
             mov color,$38
             mov sx,236
             call CiaraZvisla
             mov sx,315
             call CiaraZvisla
             mov color,$37
             mov sx,237
             call CiaraZvisla
             mov sx,314
             call CiaraZvisla
             mov color,$36
             mov sx,238
             call CiaraZvisla
             mov sx,313
             call CiaraZvisla
             mov kolko,80
             mov sx,236
             mov sy,156
             call CiaraVodorovna
             mov kolko,78
             inc sx
             dec sy
             inc color
             call CiaraVodorovna
             mov kolko,76
             inc sx
             dec sy
             inc color
             call CiaraVodorovna
end;
procedure NalepText;
{sx,sy,s}
var c1:word;
begin
  for c1:=1 to Ord(s[0]) do begin
    asm
             mov ax,0A000h
             mov es,ax
             lea si,font  {data pre pismeno}
             lea bx,s
             add bx,c1    {pismeno}
             mov ah,0
             mov al,byte[bx]
             sub al,48
             shl ax,6
             add si,ax     {ukazuje na aktualne pismeno}
             mov ax,sy
             mov cx,320
             mul cx
             add ax,sx
             mov bx,c1
             shl bx,3
             sub bx,8
             add ax,bx
             mov di,ax      {offset ciela}
{ ----- vypisovanie pismena ----- }
             mov cx,0
@DalsiBod:   cmp byte[si],0
             je @Nekresli
             mov al,byte[si]
             mov [es:di],al
@Nekresli:   inc si
             inc di
             inc cx
             test cl,00000111b
             jnz @Pokracuj
             add di,312
@Pokracuj:   cmp cx,63
             jbe @DalsiBod
    end;
  end;
end;
procedure ZacierniPlochu;assembler;
{DI offset,AX vypln,DX pocet stlpcov,BX pocet riadkov}
asm
@DalsiR:     mov cx,dx
         rep stosb
             add di,320
             sub di,dx
             dec bx
             jnz @DalsiR
end;
procedure PrilepObjekt;assembler;
{sx1,sx2,sy1,sy2:suradnice; SI,CX,DX musia byt nastavene(CX y-ova,DX x-ova)}
asm
             call InitAsm
             mov di,0
             mov bx,dx        {vypocet DI}
             mov ax,320
             mul cx
             add ax,bx
             add di,ax  {!}
             mov bx,sx1
             mov dx,sy1
@DalsiRiadok:cmp bx,0
             jl @Nekresli
             cmp bx,224
             jge @Nekresli
             cmp dx,32
             jl @Nekresli
             cmp dx,184
             jge @Nekresli
             mov al,byte[si]
             mov byte[es:di],al
@Nekresli:   inc di
             inc si
             inc bx
             cmp bx,sx2
             jl @DalsiRiadok
             inc dx
             mov ax,320
             add ax,sx1
             sub ax,sx2
             add di,ax
             mov bx,sx1
             cmp dx,sy2
             jl @DalsiRiadok
end;
procedure NakresliDom;assembler;
asm
             lea si,dom
             mov sx1,dx
             mov sx2,dx
             add sx2,24
             mov sy1,cx
             mov sy2,cx
             add sy2,24
             call PrilepObjekt
end;
procedure NakresliSklad;assembler;
asm
             lea si,sklad
             mov sx1,dx
             mov sx2,dx
             add sx2,32
             mov sy1,cx
             mov sy2,cx
             add sy2,24
             call PrilepObjekt
end;
procedure NakresliBanu;assembler;
asm
             lea si,bana
             mov sx1,dx
             mov sx2,dx
             add sx2,32
             mov sy1,cx
             mov sy2,cx
             add sy2,32
             call PrilepObjekt
end;
procedure NakresliBlok;assembler;
asm
             lea si,blok
             mov sx1,dx
             mov sx2,dx
             add sx2,24
             mov sy1,cx
             mov sy2,cx
             add sy2,32
             call PrilepObjekt
end;
procedure NakresliKino;assembler;
asm
             lea si,kino
             mov sx1,dx
             mov sx2,dx
             add sx2,24
             mov sy1,cx
             mov sy2,cx
             add sy2,24
             call PrilepObjekt
end;
procedure NakresliKniznicu;assembler;
asm
             lea si,kniznica
             mov sx1,dx
             mov sx2,dx
             add sx2,32
             mov sy1,cx
             mov sy2,cx
             add sy2,24
             call PrilepObjekt
end;
procedure NakresliOceliaren;assembler;
asm
             lea si,oceliaren
             mov sx1,dx
             mov sx2,dx
             add sx2,40
             mov sy1,cx
             mov sy2,cx
             add sy2,32
             call PrilepObjekt
end;
procedure NakresliElektraren;assembler;
asm
             lea si,elektraren
             mov sx1,dx
             mov sx2,dx
             add sx2,40
             mov sy1,cx
             mov sy2,cx
             add sy2,32
             call PrilepObjekt
end;
procedure NakresliZbrojovku;assembler;
asm
             lea si,zbrojovka
             mov sx1,dx
             mov sx2,dx
             add sx2,40
             mov sy1,cx
             mov sy2,cx
             add sy2,40
             call PrilepObjekt
end;
procedure NakresliRCentrum;assembler;
asm
             lea si,rcentrum
             mov sx1,dx
             mov sx2,dx
             add sx2,40
             mov sy1,cx
             mov sy2,cx
             add sy2,16
             call PrilepObjekt
end;
procedure NakresliBonus;assembler;
asm
             lea si,bonus
             mov sx1,dx
             mov sx2,dx
             add sx2,40
             mov sy1,cx
             mov sy2,cx
             add sy2,40
             call PrilepObjekt
end;
procedure ObnovPodkladPodVodListou;assembler;
asm
             call InitAsm
             call VypniKurzorMysi
             mov ax,lhx
             add ax,lhx
             add ax,lhx
             add ax,lhx
             add ax,lhx
             add ax,lhx
             add ax,8     {v AX je x-ova suradnica}
             add ax,25*320{v AX je offset ciela}
             mov di,ax
             mov pomw,ax
             lea si,vod
{----- ulozenie povodnej bitmapy pod listou ----- }
             mov cx,6
@DalsiRiadok:movsw
             movsw
             add di,316
             loop @DalsiRiadok
             call ZapniKurzorMysi
end;
procedure ObnovPodkladPodZvisListou;assembler;
asm
             call InitAsm
             call VypniKurzorMysi
             mov ax,lhy
             shl ax,2
             add ax,40      {v AX je y-ova sur. }
             mov cx,320
             mul cx
             add ax,225     {v AX je offset ciela}
             mov di,ax
             lea si,zvis
{----- ulozenie povodnej bitmapy pod listou ----- }
             mov cx,4
@DalsiRiadok:movsw
             movsw
             movsw
             add di,314
             loop @DalsiRiadok
             call ZapniKurzorMysi
end;
procedure NakresliVodorovnuListu;assembler;
asm
{ ----- x-ova suradnica posuvnej listy je: 8+3*lhx ----- }
             call InitAsm
             call VypniKurzorMysi
             mov ax,lhx
             add ax,lhx
             add ax,lhx
             add ax,lhx
             add ax,lhx
             add ax,lhx
             add ax,8     {v AX je x-ova suradnica}
             add ax,25*320{v AX je offset ciela}
             mov si,ax
             mov pomw,ax
             lea di,vod
{----- ulozenie povodnej bitmapy pod listou ----- }
             mov cx,6
@DalsiRiadok:mov ax,word[es:si]
             mov word[di],ax
             mov ax,word[es:si+2]
             mov word[di+2],ax
             add si,320
             add di,4
             loop @DalsiRiadok
             mov di,pomw
             mov ax,$3838
             mov dx,4
             mov bx,6
             call ZacierniPlochu
             call ZapniKurzorMysi
end;
procedure NakresliZvisluListu;assembler;
asm
             call InitAsm
             call VypniKurzorMysi
             mov ax,lhy
             shl ax,2
             add ax,40      {v AX je y-ova sur. }
             mov cx,320
             mul cx
             add ax,225     {v AX je offset ciela}
             mov si,ax
             mov pomw,ax
{ ----- ulozenie povodnej bitmapy pod listou ----- }
             lea di,zvis
             mov cx,4
@DalsiRiadok:mov ax,word[es:si]
             mov word[di],ax
             mov ax,word[es:si+2]
             mov word[di+2],ax
             mov ax,word[es:si+4]
             mov word[di+4],ax
             add si,320
             add di,6
             loop @DalsiRiadok
{ ----- nakreslenie listy ----- }
             mov di,pomw
             mov ax,$3838
             mov dx,6
             mov bx,4
             call ZacierniPlochu
             call ZapniKurzorMysi
end;
procedure NakresliObjekty;assembler;
asm
             call InitAsm
             call VypniKurzorMysi
             call NakresliVodorovnuListu
             call NakresliZvisluListu
             call CakajNaVOI
             lea si,sav.stavba
             mov pomw,si
{ ----- vypocet suradnic ----- }
@Dalsia:     mov cl,[si+2]
             xor ch,ch
             sub cx,lhy
             shl cx,3
             add cx,32
             mov dl,[si+1]
             xor dh,dh
             sub dx,lhx
             shl dx,3
{ ----- test, ci ma zmysel kreslit neviditelny objekt ----- }
             cmp cx,8
             jl @KonCyklu
             cmp cx,176
             jg @KonCyklu
             cmp dx,-32
             jl @KonCyklu
             cmp dx,240
             jg @KonCyklu
{ ----- urcenie typu objektu ----- }
             cmp byte[si],1
             je @Bana
             cmp byte[si],2
             je @Sklad
             cmp byte[si],3
             je @Dom
             cmp byte[si],5
             je @Blok
             cmp byte[si],6
             je @Kino
             cmp byte[si],7
             je @Kniznica
             cmp byte[si],8
             je @Oceliaren
             cmp byte[si],9
             je @Elektraren
             cmp byte[si],10
             je @Zbrojovka
             cmp byte[si],11
             je @RCentrum
             cmp byte[si],12
             je @Bonus
             jmp @KonCyklu
@Bana:       call NakresliBanu
             jmp @KonCyklu
@Sklad:      call NakresliSklad
             jmp @KonCyklu
@Dom:        call NakresliDom
             jmp @KonCyklu
@Blok:       call NakresliBlok
             jmp @KonCyklu
@Kino:       call NakresliKino
             jmp @KonCyklu
@Kniznica:   call NakresliKniznicu
             jmp @KonCyklu
@Oceliaren:  call NakresliOceliaren
             jmp @KonCyklu
@Elektraren: call NakresliElektraren
             jmp @KonCyklu
@Zbrojovka:  call NakresliZbrojovku
             jmp @KonCyklu
@RCentrum:   call NakresliRCentrum
             jmp @KonCyklu
@Bonus:      call NakresliBonus
@KonCyklu:   add pomw,3
             mov si,pomw
             cmp byte[si],0
             jne @Dalsia
             call ZapniKurzorMysi
end;
procedure UlozPodklad;assembler;
{SI,DI musia byt nastavene, CX pocet stlpcov=delta x,DX delta y}
asm
             call InitAsm
             mov pomw,cx
@DalsiRiadok:mov al,byte[es:si]
             mov byte[di],al
             inc si
             inc di
             loop @DalsiRiadok
             add si,320
             sub si,pomw
             mov cx,pomw
             dec dx
             jnz @DalsiRiadok
end;
procedure ObnovPodklad;assembler;
{SI,DI musia byt nastavene, CX pocet stlpcov=delta x,DX delta y}
asm
              call InitAsm
              mov pomw,cx
@DalsiRiadok: rep movsb
              mov cx,pomw
              add di,320
              sub di,cx
              dec dx
              jnz @DalsiRiadok
end;
procedure PosunVRAMHore;assembler;
asm
             call VypniKurzorMysi
             call InitAsm
             push ds
             mov ds,ax
             mov si,40*320
             mov di,32*320
             mov bx,144
@DalsiRiadok:mov cx,112
         rep movsw
             add si,96
             add di,96
             dec bx
             jnz @DalsiRiadok
             pop ds
             lea si,TV
             test lhx,1
             jz @ParneX
             add si,8
@ParneX:     test lhy,1
             jz @ParneY
             add si,8*240
@ParneY:     mov di,176*320
             mov bx,8
@DalsiR1:    mov cx,112
         rep movsw
             add si,16
             add di,96
             dec bx
             jnz @DalsiR1
             call ZapniKurzorMysi
end;
procedure PosunVRAMDole;assembler;
asm
             call VypniKurzorMysi
             call InitAsm
             push ds
             std
             mov ds,ax
             mov si,175*320+222
             mov di,183*320+222
             mov bx,144
@DalsiRiadok:mov cx,112
         rep movsw
             sub si,96
             sub di,96
             dec bx
             jnz @DalsiRiadok
             pop ds
             cld
             lea si,TV
             test lhx,1
             jz @ParneX
             add si,8
@ParneX:     test lhy,1
             jz @ParneY
             add si,8*240
@ParneY:     mov di,32*320
             mov bx,8
@DalsiR1:    mov cx,112
         rep movsw
             add si,16
             add di,96
             dec bx
             jnz @DalsiR1
             call ZapniKurzorMysi
end;
procedure PosunVRAMVlavo;assembler;
asm
             call VypniKurzorMysi
             call InitAsm
             push ds
             mov ds,ax
             mov di,32*320
             mov si,32*320+8
             mov bx,152
@DalsiRiadok:mov cx,108
         rep movsw
             add si,104
             add di,104
             dec bx
             jnz @DalsiRiadok
             pop ds
             lea si,TZ
             test lhx,1
             jz @ParneX
             add si,8
@ParneX:     test lhy,1
             jz @ParneY
             add si,8*16
@ParneY:     mov di,32*320+216
             mov bx,152
@DalsiR1:    mov cx,4
         rep movsw
             add si,8
             add di,312
             dec bx
             jnz @DalsiR1
             call ZapniKurzorMysi
end;
procedure PosunVRAMVpravo;assembler;
asm
             call VypniKurzorMysi
             call InitAsm
             push ds
             call InitAsm
             std
             mov ds,ax
             mov di,183*320+222
             mov si,183*320+214
             mov bx,152
@DalsiRiadok:mov cx,108
         rep movsw
             sub si,104
             sub di,104
             dec bx
             jnz @DalsiRiadok
             pop ds
             cld
             lea si,TZ
             test lhx,1
             jz @ParneX
             add si,8
@ParneX:     test lhy,1
             jz @ParneY
             add si,8*16
@ParneY:     mov di,32*320
             mov bx,152
@DalsiR1:    mov cx,4
         rep movsw
             add si,8
             add di,312
             dec bx
             jnz @DalsiR1
             call ZapniKurzorMysi
end;
procedure ZmazOblastVBocnomMenu;assembler;{sx,sy,kolko, vyska je 8}
asm
             call InitAsm
             call VypniKurzorMysi
             mov ax,sy
             mov cx,320
             mul cx
             add ax,sx
             mov di,ax {offset ciela}
             lea si,BocnyPodklad
             mov ax,sy
             sub ax,36
             mov cl,40
             div cl
             mov al,ah {offset zdroja - zvysok po deleni 40 nasobim 40.}
             mov cl,40
             mul cl
             add si,ax
             mov bx,sx
             sub bx,236
             cmp bx,40
             jl @NeznizujSI
             sub bx,40
@NeznizujSI: add si,bx
             mov bx,40  {vypocet posunov offsetu}
             sub bx,kolko
             mov pomw,bx   {posun offsetu SI}
             add bx,280
             mov pomw2,bx  {posun offsetu DI}
{ ----- kreslenie podkladu ----- }
             mov bx,8
@DalsiRiadok:mov cx,kolko
             shr cx,1
         rep movsw
             add di,pomw2
             add si,pomw
             dec bx
             jnz @DalsiRiadok
             call ZapniKurzorMysi
end;
