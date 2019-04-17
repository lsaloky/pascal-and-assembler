unit MukoGr;
                     INTERFACE
type TKurzor=array[0..33] of word;
{ ----- farby, premenne pristupne uzivatelovi ----- }
const Cierna=0;Cervena=1;Oranzova=2;Zlta=3;Zelena=4;Svetlomodra=5;Modra=6;
      Ruzova=7;Bordova=8;Hneda=9;Hnedocervena=10;
      Hodiny:TKurzor=(0,0,61455,57351,49155,32769,0,0,0,0,0,0,32769,49155,57351,
        61455,33153,33729,0,4080,4104,8452,19746,17730,16770,16642,16386,18450,10212,4104,4080,1632,15420,0);
      SipkaDole:TKurzor=(8,13,65535,65535,63519,63519,63519,63519,0,0,32769,49155,57351,61455,63519,
        64575,65151,65535,0,0,0,960,960,960,960,32766,16380,8184,4080,2016,960,384,0,0);
      SipkaHore:TKurzor=(8,2,65535,65151,64575,63519,61455,57351,49155,32769,0,0,63519,63519,63519,
        63519,65535,65535,0,0,384,960,2016,4080,8184,16380,32766,960,960,960,960,0,0,0);
      SipkaVlavo:TKurzor=(2,8,65343,65087,64575,63551,61503,57347,49155,32771,32771,49155,57347,61503,63551,
        64575,65087,65343,0,128,384,896,1920,3968,8184,16376,16376,8184,3968,1920,896,384,128,0);
      SipkaVpravo:TKurzor=(13,8,64767,64639,64575,64543,64527,49159,49155,49153,49153,49155,49159,64527,64543,
        64575,64639,64767,0,256,384,448,480,496,8184,8188,8188,8184,496,480,448,384,256,0);
      Otaznik:TKurzor=(7,14,63519,61455,57351,49603,50115,59331,65415,65295,65055,64575,63615,63615,64767,
        63615,63615,64767,0,2016,3120,6168,6168,24,48,96,192,384,768,768,0,768,768,0);
      Obycajny:TKurzor=(0,0,16383,8191,4095,2047,1023,511,255,127,63,31,511,4351,12543,
        63615,63615,63615,0,16384,24576,28672,30720,31744,32256,32512,32640,31744,27648,17920,1536,768,768,0);
      Terc:TKurzor=(8,8,65535,64543,61447,57347,49281,50145,34800,34352,36408,34352,34800,50145,49281,
        57347,61447,64543,0,0,448,1584,2056,4100,4100,8194,8322,8194,4100,4100,2056,1584,448,0);
      Ruka:TKurzor=(8,0,64543,63503,61447,53251,32769,1,1,32769,49153,57345,61441,61443,63491,63495,63495,
        63495,128,864,1360,1368,9556,21844,19460,9220,4100,2052,1028,1032,520,528,1008,0);
      Paleta:array[0..767] of byte=(
               0,0,0,4,4,4,8,8,8,13,13,13,17,17,17,21,21,21,25,25,25,29,29,29,34,34,34,38,38,38,42,42,
               42,46,46,46,50,50,50,55,55,55,59,59,59,63,63,63,16,0,0,21,0,0,26,0,0,32,0,0,37,0,0,42,
               0,0,47,0,0,53,0,0,58,0,0,63,0,0,63,16,16,63,23,23,63,30,30,63,36,36,63,43,43,63,50,50,
               16,9,0,21,12,0,26,15,0,32,19,0,37,22,0,42,25,0,47,28,0,53,32,0,58,35,0,63,38,0,63,40,
               6,63,43,13,63,46,19,63,48,25,63,50,32,63,53,38,16,16,0,20,20,0,25,25,0,29,29,0,33,33,0,37,
               37,0,42,42,0,46,46,0,50,50,0,54,54,0,59,59,0,63,63,0,63,63,10,63,63,20,63,63,29,63,63,39,
               0,15,0,0,20,0,0,26,0,0,31,0,0,36,0,0,42,0,0,47,0,0,52,0,0,58,0,0,63,0,8,63,
               8,16,63,16,24,63,24,31,63,31,39,63,39,47,63,47,0,15,15,0,19,19,0,24,24,0,28,28,0,32,32,0,
               37,37,0,41,41,0,46,46,0,50,50,0,54,54,0,59,59,0,63,63,10,63,63,20,63,63,30,63,63,40,63,63,
               0,0,20,0,0,24,0,0,28,0,0,32,0,0,36,0,0,40,0,0,43,0,0,47,0,0,51,0,0,55,0,0,
               59,0,0,63,10,10,63,20,20,63,30,30,63,40,40,63,17,0,17,21,0,21,25,0,25,30,0,30,34,0,34,38,
               0,38,42,0,42,46,0,46,50,0,50,55,0,55,59,0,59,63,0,63,63,11,63,63,22,63,63,34,63,63,45,63,
               12,0,17,15,0,22,19,0,26,22,0,31,26,0,35,29,0,40,32,0,45,36,0,49,39,0,54,43,0,58,46,0,
               63,49,8,63,52,16,63,54,24,63,57,32,63,60,40,63,17,12,3,20,15,5,23,17,8,26,20,10,29,23,13,32,
               26,15,35,28,17,38,31,20,41,34,22,44,36,25,47,39,27,49,42,30,51,44,33,53,47,37,55,49,40,57,52,43,
               16,8,16,19,11,19,22,13,22,25,16,25,28,19,28,30,22,30,33,24,33,36,27,36,39,30,39,42,32,42,45,35,
               45,47,38,47,49,41,49,52,45,52,54,48,54,56,51,56,63,63,63,0,62,17,0,61,17,0,61,18,0,60,18,0,
               59,19,0,58,20,0,57,20,0,57,21,0,56,21,0,55,22,0,54,23,0,53,23,0,52,24,0,52,24,0,51,25,
               0,50,26,0,49,26,0,48,27,0,48,27,0,47,28,0,46,29,0,45,29,0,44,30,0,44,30,0,43,31,0,42,
               32,0,41,32,0,40,33,0,40,33,0,39,34,0,38,35,0,37,35,0,36,36,0,36,36,0,35,37,0,34,38,0,
               33,38,0,32,39,0,32,40,0,31,40,0,30,41,0,29,41,0,28,42,0,27,43,0,27,43,0,26,44,0,25,44,
               0,24,45,0,23,46,0,23,46,0,22,47,0,21,47,0,20,48,0,19,49,0,19,49,0,18,50,0,17,50,0,16,
               51,0,15,52,0,15,52,0,14,53,0,13,53,0,12,54,0,11,55,0,10,55,0,10,56,0,9,56,0,8,57,0,
               7,58,0,6,58,0,6,59,0,5,59,0,4,60,0,3,61,0,2,61,0,2,62,0,1,62,0,0,63,63,63,63);
var kx,ky:integer;
    Adresa,Posun:word;                       {aktualny offset, posun pri vypise textov}
    Color:byte;                              {farba}
    Ret:string;                              {tu je retazec po nacitani cez Kurzor}
    OknoXMin,OknoXMax,OknoYMin,OknoYMax:word;{okraje okna pre proceduru PrilepBitmapu}
    VSeg:word;                               {segment VideoRAM}
    Font:array[0..16383] of byte;
      { ----- zakladne procedury ----- }
procedure InicializujGrafiku;
procedure ZavriGrafiku;
      { ----- procedury pre pracu s farbami ----- }
procedure NastavFarbu(cislo,r,g,b:byte);
procedure ZistiFarbu(cislo:byte;var r,g,b:byte);
      { ----- elementarne graficke procedury ----- }
procedure ZmazObrazovku;
procedure Nastav(px,py:integer;pColor:byte);  {nastavi kurzor a farbu}
procedure PolozBod(px,py:word;pColor:byte);{polozi bod v pozicii kurzora aktualnej farby}
function ZistiBod(px,py:word):byte;        {do premennej Color ulozi farbu na mieste kurzora}
procedure CiaraVodorovna(Dlzka:word);      {ciara z miesta kurzora}
procedure CiaraZvisla(Dlzka:word);
procedure VyplnPlochu(DeltaX,DeltaY:word); {vyplni ju zadanou farbou}
      { ----- dalsie procedury ----- }
procedure Obdlznik(DeltaX,DeltaY:word);    {ramcek bez vyplne}
procedure Ramcek(DeltaX,DeltaY,FarbaVnutra:word);{lavy horny roh na mieste kurzora, vyfarbi znutra}
procedure CakajNaVOI;                            {caka na ukoncenie zobrazovania}
procedure NacitajFontAPaletu(FontStr:string);
procedure VypisPriehladne(s:string;Odtien:byte); {40.000 zn./s, "prilepuje" retazec na aktualnu poziciu}
procedure NastavTvarKurzora(Zdroj:word);
      { ----- procedury pre pracu s bitmapami ----- }
procedure PrilepBitmapu(DeltaX,DeltaY,Zdroj:word);{zdroj je offset bitmapy}
procedure PrilepPriehladnuBitmapu(DeltaX,DeltaY,Zdroj:word);
procedure StiahniBitmapu(DeltaX,DeltaY,Ciel:word);{Ciel je offset bitmapy}
procedure KopirujObrazovku(VSeg1,VSeg2:word);
procedure PrilepDynamickuBitmapu(DeltaX,DeltaY:word;Zdroj:pointer);{nerespektuje Okno____}
                   IMPLEMENTATION
var KonY:word;
procedure InicializujGrafiku;
begin
  asm
             mov ax,13h
             int 10h
  end;
end;
procedure ZavriGrafiku;assembler;
asm
             mov ax,3
             int 10h
end;
procedure NastavFarbu(cislo,r,g,b:byte);
begin
  port[$3C8]:=cislo;
  port[$3C9]:=r;
  port[$3C9]:=g;
  port[$3C9]:=b;
end;
procedure ZistiFarbu(cislo:byte;var r,g,b:byte);
var x:byte;
begin
  port[$3C7]:=cislo;
  r:=port[$3C9];
  g:=port[$3C9];
  b:=port[$3C9];
end;
procedure ZmazObrazovku;assembler;
asm
             cld
             mov es,VSeg
 db 66h;     mov cx,16000;        dw 0
 db 66h;     xor di,di;           dw 0
 db 66h;     xor ax,ax;           dw 0
 db 66h; rep stosw;               dw 0
end;
procedure Nastav(px,py:integer;pColor:byte);assembler;
asm
             mov al,pColor
             mov Color,al
             mov cx,320
             mov ax,py
             mov ky,ax
             imul cx
             mov bx,px
             mov kx,bx
             add ax,bx
             mov Adresa,ax       {nastav offset ciela}
end;
procedure PolozBod(px,py:word;pColor:byte);assembler;
asm
             mov es,VSeg
             mov cx,320
             mov ax,py
             mul cx
             add ax,px
             mov di,ax
             mov al,pColor
             stosb
end;
function ZistiBod(px,py:word):byte;
var pColor:byte;
begin
  asm
             mov es,VSeg
             mov cx,320
             mov ax,py
             mul cx
             add ax,px
             mov di,ax
             mov al,byte[es:di]
             mov pColor,al
  end;
  ZistiBod:=pColor;
end;
procedure CiaraVodorovna(Dlzka:word);assembler;
asm
             cld
             mov es,VSeg
             mov di,Adresa
             mov al,Color
             mov cx,Dlzka
             jcxz @Koniec
         rep stosb
@Koniec:
end;
procedure CiaraZvisla(Dlzka:word);assembler;
asm
             mov es,VSeg
             mov di,Adresa
             mov al,Color
             mov cx,Dlzka
             jcxz @Koniec
@DalsiBod:   mov [es:di],al
             add di,320
             loop @DalsiBod
@Koniec:
end;
procedure VyplnPlochu(DeltaX,DeltaY:word);assembler;
asm
             cmp DeltaX,0
             je @Koniec
             cmp DeltaY,0
             je @Koniec
             cld
             mov es,VSeg
             mov di,Adresa
             mov bx,DeltaY
             mov dx,320
             sub dx,DeltaX  {v DX je 320-DeltaX}
             mov al,Color
@DalsiRiadok:mov cx,DeltaX
         rep stosb
             add di,dx
             dec bx
             jnz @DalsiRiadok
@Koniec:
end;
procedure Obdlznik(DeltaX,DeltaY:word);
begin
  CiaraZvisla(DeltaY);
  CiaraVodorovna(DeltaX);
  Adresa:=Adresa+DeltaX-1;
  CiaraZvisla(DeltaY);
  Adresa:=Adresa+320*DeltaY-DeltaX-319;
  CiaraVodorovna(DeltaX);
  Adresa:=Adresa-320*DeltaY;
end;
procedure Ramcek(DeltaX,DeltaY,FarbaVnutra:word);assembler;
asm
             cld
             cmp DeltaX,0
             je @Koniec
             cmp DeltaY,0
             je @Koniec
             mov es,VSeg
             mov di,Adresa
             mov bp,sp
             mov bx,DeltaY
             sub bx,2          {v BX pocet riadkov vnutra}
             mov cx,DeltaX
             mov dx,320
             sub dx,cx         {v DX je 320-DeltaX}
             mov al,Color
         rep stosb             {1. riadok}
@DalsiRiadok:add di,dx
             stosb             {1. bod}
             mov ax,FarbaVnutra
             mov cx,DeltaX
             sub cx,2
         rep stosb             {vnutro}
             mov al,Color
             stosb             {posledny bod}
             dec bx
             jnz @DalsiRiadok
             add di,dx
             mov al,Color
             mov cx,DeltaX
         rep stosb
@Koniec:
end;
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
procedure NacitajFontAPaletu(FontStr:string);
var f:file;
    pX:word;
begin
  Assign(f,FontStr);
  Reset(f,16384);
  BlockRead(f,Font,1);
  Close(f);
  for px:=0 to 255 do NastavFarbu(px,Paleta[3*px],Paleta[3*px+1],Paleta[3*px+2]);
end;
procedure VypisPriehladne(s:string;Odtien:byte);
var c1,c2:word;
    DDiak:boolean;
begin
  c2:=0;
  Odtien:=Odtien*16;
  for c1:=1 to Ord(s[0]) do begin
    c2:=c2+1;               {kvoli Enter a vypocitavaniu offsetu ciela}
    DDiak:=False;
    asm
             mov es,VSeg
             mov dx,Posun
             lea si,Font  {data pre pismeno}
@Dalsie:     lea bx,s
             add bx,c1    {pismeno}
             mov ah,0
             mov al,byte[ss:bx]
             cmp al,13     {spracovanie Enter}
             jne @Normalne
             add Adresa,dx
             mov c2,1
             inc c1
             jmp @Dalsie
{ ----- vypocet offsetov zdroja a ciela ----- }
@Normalne:   mov di,Adresa
             mov bx,c2
             shl bx,3
             sub bx,8
             add di,bx     {offset ciela}
             mov cx,0
             cmp al,'`'    {dlzen}
             je @Diak
             cmp al,'~'    {makcen}
             je @Diak
             cmp al,'^'    {vokan}
             je @Diak
             cmp al,'|'    {dve bodky}
             je @Diak
             jmp @Dalej
@Diak:       sub di,320
             mov DDiak,True
@Dalej:      shl ax,6      {offset zdroja}
             add si,ax     {ukazuje na aktualne pismeno}
{ ----- vypisovanie pismena ----- }
@DalsiBod:   mov al,byte[si]
             and al,$0F
             jz @Nekresli
             mov al,byte[si]
             add al,Odtien
             mov [es:di],al
@Nekresli:   inc si
             inc di
             inc cx
             test cl,00000111b
             jnz @Pokracuj
             add di,312
@Pokracuj:   cmp cx,63
             jbe @DalsiBod
             cmp DDiak,True   {spracovanie diakritiky}
             jne @Koniec
@Diak2:      dec c2
@Koniec:
    end;
  end;
end;
procedure NastavTvarKurzora(Zdroj:word);
begin
  asm
             mov ax,ds
             mov es,ax
             mov si,Zdroj
             mov dx,si
             add dx,4
             mov ax,9
             mov bx,word[si]
             mov cx,word[si+2]
             int 33h
  end;
end;
procedure PrilepBitmapu(DeltaX,DeltaY,Zdroj:word);assembler;
asm
             cld
             cmp DeltaX,0
             je @Koniec
             cmp DeltaY,0
             je @Koniec
             mov ax,DeltaY
             add ax,ky
             mov KonY,ax
             mov es,VSeg
             mov si,Zdroj      { Zdroj -> ... }
             mov di,Adresa     { ... -> Adresa}
             mov bx,kx         { x-ova sur. }
             mov dx,ky         { y-ova sur. }

@DalsiRiadok:mov cx,DeltaX
@DalsiBod:   lodsb
             cmp bx,OknoXMin   {kontrola rozsahu}
             jl @Nekresli
             cmp bx,OknoXMax
             jg @Nekresli
             cmp dx,OknoYMin
             jl @Nekresli
             cmp dx,OknoYMax
             jg @Nekresli
             mov byte[es:di],al
@Nekresli:   inc di            {offset na dalsi bod, aj ked predosly nebol polozeny}
             inc bx            {zvys x-ovu sur.}
             loop @DalsiBod    {potial kreslenie 1 riadka}

             mov bx,kx         {vrat x-ovu sur. na zaciatok}
             inc dx            {dalsi riadok}
             add di,320
             sub di,DeltaX     {uprav DI}
             cmp dx,KonY
             jl @DalsiRiadok
@Koniec:
end;
procedure PrilepPriehladnuBitmapu(DeltaX,DeltaY,Zdroj:word);assembler;
asm
             cld
             cmp DeltaX,0
             je @Koniec
             cmp DeltaY,0
             je @Koniec
             mov ax,DeltaY
             add ax,ky
             mov KonY,ax
             mov es,VSeg
             mov si,Zdroj      { Zdroj -> ... }
             mov di,Adresa     { ... -> Adresa}
             mov bx,kx         { x-ova sur. }
             mov dx,ky         { y-ova sur. }

@DalsiRiadok:mov cx,DeltaX
@DalsiBod:   lodsb
             cmp al,0          {nova podmienka oproti PrilepBitmapu}
             je @Nekresli
             cmp bx,OknoXMin   {kontrola rozsahu}
             jl @Nekresli
             cmp bx,OknoXMax
             jg @Nekresli
             cmp dx,OknoYMin
             jl @Nekresli
             cmp dx,OknoYMax
             jg @Nekresli
             mov byte[es:di],al
@Nekresli:   inc di            {offset na dalsi bod, aj ked predosly nebol polozeny}
             inc bx            {zvys x-ovu sur.}
             loop @DalsiBod    {potial kreslenie 1 riadka}

             mov bx,kx         {vrat x-ovu sur. na zaciatok}
             inc dx            {dalsi riadok}
             add di,320
             sub di,DeltaX     {uprav DI}
             cmp dx,KonY
             jl @DalsiRiadok
@Koniec:
end;
procedure PrilepDynamickuBitmapu(DeltaX,DeltaY:word;Zdroj:pointer);assembler;
asm
             cld
             cmp DeltaX,0
             je @Koniec
             cmp DeltaY,0
             je @Koniec
             mov es,VSeg
             mov dx,DeltaY
             mov bx,DeltaX
             mov di,Adresa     { ... -> Adresa}

             push ds
             lds si,Zdroj      {Zdroj -> .... }
             add si,16

@DalsiRiadok:mov cx,DeltaX
         rep movsb
             add di,320
             sub di,bx         {uprav DI}
             dec dx
             jnz @DalsiRiadok
             pop ds
@Koniec:
end;
procedure StiahniBitmapu(DeltaX,DeltaY,Ciel:word);assembler;
asm
             cld
             cmp DeltaX,0
             je @Koniec
             cmp DeltaY,0
             je @Koniec
             mov si,Adresa
             push ds
             mov ax,ds
             mov es,ax
             mov ax,VSeg
             mov ds,ax
             mov di,Ciel {nastavene su DS:SI -> ES:DI}
             mov dx,320
             sub dx,DeltaX {v DX je posun zdrojoveho offsetu}
             mov bx,DeltaY
@DalsiRiadok:mov cx,DeltaX
         rep movsb
             add si,dx
             dec bx
             jnz @DalsiRiadok
             pop ds
@Koniec:
end;
procedure KopirujObrazovku(VSeg1,VSeg2:word);assembler;
asm
             cld
             push ds
             mov ds,VSeg1
             mov es,VSeg2
 db 66h;     mov si,0;     dw 0
 db 66h;     mov di,0;     dw 0
 db 66h;     mov cx,16000; dw 0
 db 66h; rep movsw
             pop ds
end;
BEGIN
  OknoXMin:=0;
  OknoXMax:=319;
  OknoYMin:=0;
  OknoYMax:=199;
  VSeg:=$A000;
  Posun:=8*320;
END.
