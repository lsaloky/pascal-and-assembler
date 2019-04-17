program Testovanie_platnosti_velkej_Fermatovej_vety;
{rychlost overovania: do 1000 za 4 s, 4000 za 55s,10000 za 335s,50000 za 8400 s (odhad na 486 DX2/66}
{tempo overovania: na 486DX2/66 27.000.000 instr./s (???) - asi chyba v odhade poctu skutocne vykonanych instrukcii}
{ !!!!!!!! NEZABUDNI DAT BREAKPOINT NA RIADOK 24 !!!!!!! }
const Lin:array[0..8] of word=(0,128,1024,3456,8192,16000,27648,43904,65535);{hranice medzi polami - 32. az 47.bit 3. mocniny}
      Vypis:string='Naslo sa !!!'#13#10'$';
type tm=array[0..24575] of word;
var c,w1,w2,w3,x1,x2,posun,p1:word;
    p:array[0..7] of ^tm;      {v tomto poli pointrov musia byt dolne slova vynulovane - skontroluj to !!!}

procedure VypisMocniny(x:word);{mocniny v x-tom pointri}
begin
  for p1:=0 to 8191 do begin
    writeln(p[x]^[p1*3]*65536.0*65536.0+p[x]^[p1*3+1]*65536.0+p[x]^[p1*3+2]:20:0);
    if p1 mod 20=19 then readln;
  end;
end;
procedure VypisTrojicu;assembler;
asm
             mov ah,09h
             lea dx,Vypis
             inc dx
             int 21h
{ tu daj breakpoint a pozri si hodnotu x1,x2}
end;
procedure Mocnina;assembler;{c^3 v BX:CX:SI alebo w1:w2:w3, pouziva aj AX,DX,DI,SI}
asm

             mov cx,0
             mov bx,0
             mov ax,c
             mul ax
             mov di,dx
             mul c
             mov si,ax
             mov cx,dx
             mov ax,di
             mul c
             add cx,ax
             adc bx,dx
             mov w1,bx
             mov w2,cx
             mov w3,si
end;
BEGIN
  writeln(maxavail);
  readln;
  for c:=1 to 10 do writeln;
  for c:=0 to 7 do GetMem(p[c],49152);
{ ----- predvypocitanie mocnin do poli p[0..7], v kazdom je 8192 mocnin}
  for c:=0 to 65535 do begin
    Mocnina;
    p[c div 8192]^[(c mod 8192)*3]:=w1;
    p[c div 8192]^[(c mod 8192)*3+1]:=w2;
    p[c div 8192]^[(c mod 8192)*3+2]:=w3;
  end;
  {VypisMocniny(0);}
  for x1:=1 to 1000 do  {max 50000}
    for x2:=x1+1 to 1000 do begin
      asm
{ ----- spracuvame mocninu x1-otky ----- }
             mov ax,x1       {instrukcie sa vykonavaju 1.250.000.000 krat}
             shr ax,13       {v AX je index v poli p[0..7]}
             shl ax,2        {v AX je prirastok offsetu - pointer ma 4 bajty}
             lea si,p
             add si,ax       {v SI je ukazatel na potrebny pointer}
             mov es,[si+2]   {!!!!! v DI musi byt nula, ide tu len o ES !!!!!}
             mov ax,x1
             and ax,1FFFh    {v AX je x1 mod 8192}
             mov si,ax
             add ax,si
             add ax,si
             shl ax,1        {v AX je 6*(x1 mod 8192) - to je offset pre 1. mocninu}
             mov si,ax
             mov bx,[es:si]
             mov cx,[es:si+2]
             mov dx,[es:si+4]{1. tretia mocnina je uz v BX:CX:DX}
{ ----- spracuvame mocninu x2-ojky ----- }
             mov ax,x2
             shr ax,13       {v AX je index v poli p[0..7]}
             shl ax,2        {v AX je prirastok offsetu - pointer ma 4 bajty}
             lea si,p
             add si,ax       {v SI je ukazatel na potrebny pointer}
             mov es,[si+2]   {!!!!! v DI musi byt nula !!!!!}
             mov ax,x2
             and ax,1FFFh    {v AX je x2 mod 8192}
             mov si,ax
             add ax,si
             add ax,si
             shl ax,1        {v AX je 6*(x2 mod 8192) - to je offset pre 2. mocninu}
             mov si,ax
             add dx,[es:si+4]
             adc cx,[es:si+2]
             adc bx,[es:si]  {po scitani s prenosom je v BX:CX:DX sucet}
{ ----- linearne vyhladavanie, v ktorom poli sa nachadza ----- }
             lea si,lin
             mov ax,-4       {aby pre p[0] sa AX=0}
@Dalsi:      add si,2        {cyklus bezi priemerne 4x}
             add ax,4        {pre p[x] v AX je 4*x}
             cmp bx,word[si]
             jae @Dalsi
             lea si,p
             add si,ax
             mov es,[si+2]   {ES ukazuje na ziadane pole}
{ ----- binarne vyhladavanie v tretich mocninach ----- }
             mov si,24570    {zaciname od stredu pola minus 1 cislo}
             mov posun,12288
@Dalej:      cmp bx,[es:si]  {cyklus bezi 13 x (ak nenajde trojicu)}
             ja @ZvysSI      {pri odhade poctu instrukcii pocitam, ze sa vykona}
             jb @ZnizSI      {v priemere 10 z 15 instrukcii tohto cyklu po JAE @Dalej}
             cmp cx,[es:si+2]
             ja @ZvysSI
             jb @ZnizSI
             cmp dx,[es:si+4]
             ja @ZvysSI
             jb @ZnizSI
{ ----- Nasla sa trojica !!! ----- }
             call VypisTrojicu
{ ----- posun index (SI) ----- }
@ZvysSI:     add si,posun
             jmp @ZnizPosun
@ZnizSI:     sub si,posun
@ZnizPosun:  shr posun,1      {nevyhovuje tretie cislo}
             cmp posun,3
             jae @Dalej
      end;
    end;
{suma sumarum pre x1,x2 do 50000 - pocet instrukcii:
    16 instrukcii pre nacitanie 1. cisla
  + 16 instrukcii pre nacitanie 2. cisla
  + 21 instrukcii pre linearne vyhladavanie
  + 130 instrukcii pre binarne vyhladavanie
    -----
    183 instrukcii pre overenie 1 trojice
  * 1.250.000.000 trojic
    -----
    228.750.000.000 instrukcii celkove. V skutocnosti mozno pre bin. vyhladavanie staci aj menej ako 100 instrukcii}
  for c:=0 to 7 do FreeMem(p[c],49152);
  writeln('Hotovo.');
END.
