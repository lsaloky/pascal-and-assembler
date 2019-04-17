const VSeg:word=$A000;
      Bity:array[0..7] of byte=(128,64,32,16,8,4,2,1);
{   rychlost:         tieto algoritmy    Pascal BGI interface    Poznamka

  Bod                 533.000 bodov / s     100.000 bodov / s
  Ciara               914.000 bodov / s     800.000 bodov / s    (0,0,639,479)
  Ciara               750.000               500.000 bodov / s    (0,0,20,14)
  ZmazObrazovku    80.840.000 bodov / s  76.800.000 bodov / s
  ZmazOkno         76.800.000 bodov / s
}
procedure InicializujGrafiku;assembler;
asm
             mov ax,12h
             int 10h
end;
procedure ZavriGrafiku;assembler;
asm
             mov ax,3
             int 10h
end;
procedure NastavRovinu;assembler;
asm
             mov dx,03C4h    {  PortW[$3C4]:=$0F02 - do vsetkych bitovych rovin}
             mov al,2
             out dx,ax
end;
procedure ZmazObrazovku;assembler;
asm
             cld
             mov es,VSeg
             xor ax,ax
             mov cx,19200
             mov di,0
         rep stosw
end;
procedure ZmazOkno(xDiv8,y,DeltaXDiv8,DeltaY:word);assembler;
asm
             cld
             mov es,VSeg
             mov ax,y
             mov cx,80
             mul cx
             mov di,ax
             add di,xDiv8 { cielovy offset nastaveny }
             mov dx,DeltaY { pocitadlo riadkov nastavene }
             mov bx,80
             sub bx,DeltaXDiv8 { posun na dalsi riadok o BX bajtov }
             xor ax,ax
@NovyRiadok: mov cx,DeltaXDiv8
             shr cx,1
             jnc @Parne
             stosb
@Parne:  rep stosw
             add di,bx
             dec dx
             jnz @NovyRiadok
end;
procedure NastavCiernoBielu;assembler;
asm
             mov ah,0Fh
             call NastavRovinu
end;
procedure BielyBod(x,y:word);assembler; { pred nim musi byt NastavCiernoBielu }
asm
             mov es,VSeg
             mov ax,80
             mul y
             mov di,ax
             mov bx,x
             mov ax,bx  { odloz si hodnotu }
             shr bx,3
             add di,bx  { cielovy offset vypocitany }

             lea bx,Bity
             and ax,$0007
             xlat { bit na zapisanie pripraveny }
             or byte[es:di],al
end;
procedure CiernyBod(x,y:word);assembler; { pred nim musi byt NastavCiernoBielu }
asm
             mov es,VSeg
             mov ax,80
             mul y
             mov di,ax
             mov bx,x
             mov ax,bx { odloz si hodnotu }
             shr bx,3
             add di,bx { cielovy offset vypocitany }

             lea bx,Bity
             and ax,$0007
             xlat
             not al { bit na zapisanie pripraveny }
             and byte[es:di],al
end;
Procedure Ciara(x1,y1,x2,y2:integer;Farba:byte);assembler;
var SmerX,SmerY:integer;
    PocBit:byte;
asm
             mov SmerX,1
             mov SmerY,80
             mov es,VSeg
{ ----- vypocet DI - pociatocny offset ----- }
             mov ax,80
             mul y1
             mov di,ax
             mov ax,x1
             shr ax,3
             add di,ax        {DI = offset pociatocneho bodu}
{ ----- vypocet pociatocneho cisla bitu }
             mov cx,x1
             not cx
             and cx,$0007
             mov al,1
             shl al,cl
             mov PocBit,al
{ ----- vypocet SI = Abs(2 * DeltaY) a SmerY ----- }
             mov si,y2
             sub si,y1
             cmp si,0
             jg @DeltaYOK
             neg si
             mov SmerY,-80
@DeltaYOK:   add si,si
{ ----- vypocet BX = 2 * Abs(DeltaX) a SmerX ----- }
             mov bx,x2
             sub bx,x1
             cmp bx,0
             jg @DeltaXOK
             neg bx
             mov SmerX,-1
@DeltaXOK:   mov cx,bx        {CX = Delta na riadiacej osi}
             add bx,bx
{ ----- vymena smerov pri smernici >1 ----- }
             cmp bx,si
             ja @Nevymen
             mov ax,SmerX
             xchg SmerY,ax
             mov SmerX,ax
             mov cx,si        {zmen aj pocet kreslenych bodov}
             shr cx,1
             xchg si,bx
@Nevymen:    jcxz @Koniec     {je to ciara nulovej dlzky?}
             cmp cx,640
             ja @Koniec
             mov dx,bx        {DX = predikcia. Ak je >=0, ide sa dalej na nie riadiacej osi}
             shr dx,1
             neg dx           {predikcia sa inicializuje na -Delta na riadiacej osi }
             inc cx           {kresli o 1 bod viac (lebo kreslis od 0)}
             mov al,PocBit
{ ----- hlavny cyklus - rotacia bitu, prilepenie bodu, vypocty, ... ----- }
@DalsiBod:   cmp Farba,0
             jne @Biela
             not al
             and byte[es:di],al
             not al
             jmp @FarbaOK
@Biela:      or byte[es:di],al
@FarbaOK:    cmp SmerX,-1
             je @RotVlavo
             cmp SmerX,1
             jne @Zvysuj
             ror al,1{ vpravo }
             jmp @RotOK
@RotVlavo:   rol al,1
@RotOK:      jnc @Nezvysuj
@Zvysuj:     add di,SmerX
@Nezvysuj:   add dx,si        {pripocitaj 2*DeltaY}
             cmp dx,0
             jl @Neodcitaj
{ ----- spracovanie rotacie bitu na nie riadiacej osi ----- }
             cmp SmerY,-1
             je @RotVlavo2
             cmp SmerY,1
             jne @Zvysuj2
             ror al,1 { vpravo }
             jmp @RotOK2
@RotVlavo2:  rol al,1
@RotOK2:     jnc @Nezvysuj2
@Zvysuj2:    add di,SmerY
@Nezvysuj2:  sub dx,bx        {ak treba, odpocitaj 2*DeltaX}

@Neodcitaj:  loop @DalsiBod
@Koniec:
end;  { Ciara }
