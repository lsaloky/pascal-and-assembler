unit FastGr;
{PolozBod:        1.300.000 bodov       za sekundu}
{ZistiBod:        1.300.000 bodov       za sekundu}
{Nastav:          700.000 krat          za sekundu}
{ZmazObrazovku:   166 krat              za sekundu}
{CiaraVodorovna:  16.000 ciar dlzky 320 za sekundu}
{CiaraZvisla:     25.000 ciar dlzky 200 za sekundu}
{VyplnPlochu:     3.300 stvorcov 40x40  za sekundu}
{Ramcek:          3.300 ramcekov 40x40  za sekundu}
{VypisPriehladne: 1.100 retazcov dlz.40 za sekundu}
{PrilepBitmapu:   3.300 bitmap   40x40  za sekundu}
{KONVERZNA TABULKA PRE VYPISPRIEHLADNE:
  : -> :
  ; -> dlzen
  < -> .
  = -> makcen
  > -> !
  ? -> prepisujuca medzera
  @ -> priehladna medzera
  [ -> pretacaci pruh - sipka vlavo
  \ ->                        vpravo
  ] ->                        hore
  ^ ->                        dole
  _ -> pretacaci pruh zvisly
  ` ->                vodorovny}
                          INTERFACE
const DlzkaFontu=4928;
var kx,ky,Adresa:word;
    Color:byte;
    Font:array[1..DlzkaFontu] of byte;
    Paleta:array[0..767] of byte;
      { ----- zakladne procedury ----- }
procedure InicializujGrafiku;
procedure ZavriGrafiku;
procedure ZapniZobrazovanie;
procedure VypniZobrazovanie;
      { ----- procedury pre pracu s farbami ----- }
procedure NastavFarbu(cislo,r,g,b:byte);
procedure ZistiFarbu(cislo:byte;var r,g,b:byte);
      { ----- elementarne graficke procedury ----- }
procedure ZmazObrazovku;
procedure Nastav(px,py:word;pColor:byte);  {nastavi kurzor a farbu}
procedure PolozBod;                        {polozi bod v pozicii kurzora aktualnej farby}
procedure ZistiBod;                        {do premennej Color ulozi farbu na mieste kurzora}
procedure CiaraVodorovna(Dlzka:word);      {ciara z miesta kurzora}
procedure CiaraZvisla(Dlzka:word);
procedure VyplnPlochu(DeltaX,DeltaY:word); {vyplni ju zadanou farbou}
      { ----- dalsie graficke procedury ----- }
procedure Ramcek(DeltaX,DeltaY,FarbaVnutra:word);{lavy horny roh na mieste kurzora, vyfarbi znutra}
procedure CakajNaVOI;                      {caka na ukoncenie zobrazovania}
procedure NacitajFontAPaletu;
procedure VypisPriehladne(s:string);       {"prilepuje" retazec na aktualnu poziciu}
      { ----- procedury pre pracu s bitmapami ----- }
procedure PrilepBitmapu(DeltaX,DeltaY,Zdroj:word);{zdroj je offset bitmapy}
procedure PrilepPriehladnuBitmapu(DeltaX,DeltaY,Zdroj:word);
procedure StiahniBitmapu(DeltaX,DeltaY,Ciel:word);{Ciel je offset bitmapy}
                         IMPLEMENTATION
procedure InicializujGrafiku;assembler;
asm
             mov ax,13h
             int 10h
end;
procedure ZavriGrafiku;assembler;
asm
             mov ax,3
             int 10h
end;
procedure VypniZobrazovanie;
begin
  port[$3C6]:=$00;
end;
procedure ZapniZobrazovanie;
begin
  port[$3C6]:=$FF;
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
             mov ax,0A000h
             mov es,ax
             mov cx,32000
             xor di,di
             xor ax,ax
         rep stosw
end;
{parametre:typu WORD, zacinaju na [SS:SP+4], idu od konca, adresuj cez BP}
procedure Nastav(px,py:word;pColor:byte);assembler;
asm
             mov bp,sp
             mov al,pColor
             mov Color,al
             mov cx,320
             mov ax,py
             mov ky,ax
             mul cx
             mov bx,px
             mov kx,bx
             add ax,bx
             mov Adresa,ax       {nastav offset ciela}
end;
procedure PolozBod;assembler;
asm
             mov ax,0A000h
             mov es,ax
             mov di,Adresa
             mov al,Color
             stosb
end;
procedure ZistiBod;assembler;
asm
             mov ax,0A000h
             mov es,ax
             mov di,Adresa
             mov byte[es:di],al
             mov Color,al
end;
procedure CiaraVodorovna(Dlzka:word);assembler;
asm
             cld
             mov ax,0A000h
             mov es,ax
             mov di,Adresa
             mov al,Color
             mov cx,Dlzka
         rep stosb
end;
procedure CiaraZvisla(Dlzka:word);assembler;
asm
             mov ax,0A000h
             mov es,ax
             mov di,Adresa
             mov al,Color
             mov cx,Dlzka
@DalsiBod:   mov [es:di],al
             add di,320
             loop @DalsiBod
end;
procedure VyplnPlochu(DeltaX,DeltaY:word);assembler;
asm
             cld
             mov ax,0A000h
             mov es,ax
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
end;
procedure Ramcek(DeltaX,DeltaY,FarbaVnutra:word);assembler;
asm
             cld
             mov ax,0A000h
             mov es,ax
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
procedure NacitajFontAPaletu;
var f:file;
    pX:word;
begin
  Assign(f,'d:\lubo\pascal\units\font.dat');
  Reset(f,DlzkaFontu);
  BlockRead(f,Font,1);
  Close(f);
  Assign(f,'d:\lubo\pascal\units\paleta.dat');
  Reset(f,768);
  BlockRead(f,Paleta,1);
  Close(f);
  for px:=0 to 255 do NastavFarbu(px,Paleta[3*px],Paleta[3*px+1],Paleta[3*px+2]);
end;
procedure VypisPriehladne(s:string);
var c1,c2:word;
begin
  c2:=0;
  for c1:=1 to Ord(s[0]) do begin
    c2:=c2+1;               {kvoli Enter a vypocitavaniu offsetu ciela}
    asm
             mov ax,0A000h
             mov es,ax
             lea si,Font  {data pre pismeno}
@Dalsie:     lea bx,s
             add bx,c1    {pismeno}
             mov ah,0
             mov al,byte[ss:bx]
             cmp al,13     {spracovanie Enter}
             jne @Normalne
             add Adresa,8*320
             add ky,8
             mov c2,1
             inc c1
             jmp @Dalsie
@Normalne:   sub al,48
             shl ax,6
             add si,ax     {ukazuje na aktualne pismeno}
             mov ax,ky
             mov cx,320
             mul cx
             add ax,kx
             mov bx,c2
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
procedure PrilepBitmapu(DeltaX,DeltaY,Zdroj:word);assembler;
asm
             cld
             mov ax,0A000h
             mov es,ax
             mov di,Adresa
             mov si,Zdroj
             mov dx,320
             sub dx,DeltaX     {v DX je 320-DeltaX}
             mov bx,DeltaY
@DalsiRiadok:mov cx,DeltaX
         rep movsb
             add di,dx
             dec bx
             jnz @DalsiRiadok
end;
procedure PrilepPriehladnuBitmapu(DeltaX,DeltaY,Zdroj:word);assembler;
asm
             cld
             mov ax,0A000h
             mov es,ax
             mov di,Adresa
             mov si,Zdroj
             mov dx,320
             sub dx,DeltaX     {v DX je 320-DeltaX}
             mov bx,DeltaY
@DalsiRiadok:mov cx,DeltaX
@DalsiBod:   lodsb
             cmp al,0
             je @Nezapisuj
             mov [es:di],al
@nezapisuj:  inc di
             loop @DalsiBod
             add di,dx
             dec bx
             jnz @DalsiRiadok
end;
procedure StiahniBitmapu(DeltaX,DeltaY,Ciel:word);assembler;
asm
             cld
             mov si,Adresa
             push ds
             mov ax,ds
             mov es,ax
             mov ax,0A000h
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
end;

BEGIN
END.