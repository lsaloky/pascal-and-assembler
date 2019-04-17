unit Mys;
                                INTERFACE
uses MainGr;
type TKurzor=array[0..33] of word;
const Lave:byte=1;
      Prave:byte=2;
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

var MysX,MysY:word;
    JeMys:boolean;
function IOM:boolean; { instalovany ovladac mysi }
procedure ZM; {Zapni mys}
procedure VM; {Vypni mys}
procedure OknoKurzora(x1,x2,y1,y2:word);
procedure ZistiPoziciu(var x,y:word;var Tlacidla:byte);
procedure NastavKurzor(x,y:word);
procedure CakajNaPustenie;
procedure NastavTvarKurzora(Zdroj:word);
function ObsluzUdalost(Aktiv,Klav:pointer):word;
function ObsluzUdalostSHelpom(Aktiv,Klav,Pismo,Help:pointer):word;
{Aktiv:XMin,YMin,XMax,Ymax; ukonci (400,0,0,0);
 Klav ukonci #255; prave tlacidlo = pripocitane 256}
                             IMPLEMENTATION
function IOM:boolean;assembler;
asm
             mov ax,0
             int 33h
end;
function CitajKlavesAkJe:byte;assembler;
asm   {If KeyPressed then ch:=ReadKey else ch:=0;}
             mov ah,1
             int 16h
             jnz @CitajHo
             xor al,al
             jmp @Koniec
@CitajHo:    mov ah,0
             int 16h
@Koniec:
end;
procedure ZM;assembler;
asm
             cmp JeMys,False
             je @Koniec
             mov ax,1
             int 33h
@Koniec:
end;
procedure VM;assembler;
asm
             cmp JeMys,False
             je @Koniec
             mov ax,2
             int 33h
@Koniec:
end;
procedure OknoKurzora(x1,x2,y1,y2:word);assembler;
asm
             cmp JeMys,False
             je @Koniec
             mov ax,7
             mov cx,x1
             mov dx,x2
             int 33h
             mov ax,8
             mov cx,y1
             mov dx,y2
             int 33h
@Koniec:
end;
procedure ZistiPoziciu(var x,y:word;var Tlacidla:byte);
var px,py:word;Ptlacidla:byte;
begin
  asm
             mov bl,0
             cmp JeMys,False
             je @Koniec
             mov ax,3
             int $33
             mov px,cx
             mov py,dx
@Koniec:     mov pTlacidla,bl
  end;
  x:=px;y:=py;tlacidla:=ptlacidla;
end;
procedure NastavKurzor(x,y:word);assembler;
asm
             cmp JeMys,False
             je @Koniec
             mov ax,4
             mov cx,x
             mov dx,y
             int 33h
@Koniec:
end;
procedure CakajNaPustenie;assembler;
asm
             cmp JeMys,False
             je @Koniec
@Cakaj:      mov ax,3
             int 33h
             cmp bx,0
             jne @Cakaj
@Koniec:
end;
procedure NastavTvarKurzora(Zdroj:word);assembler;
asm
             cmp JeMys,False
             je @Koniec
             mov ax,ds
             mov es,ax
             mov si,Zdroj
             mov dx,si
             add dx,4
             mov ax,9
             mov bx,word[si]
             mov cx,word[si+2]
             int 33h
@Koniec:
end;
function ObsluzUdalost(Aktiv,Klav:pointer):word;
type UBlok=array[1..100,1..4] of word;
     KBlok=array[1..100] of byte;
var pAktiv:^UBlok;
    pKlav:^KBlok;
    kx,ky,Udalost:word;
    Tlacidla,ch,ii:byte;
begin
  pAktiv:=Aktiv;
  pKlav:=Klav;
  Udalost:=0;
  repeat
    ZistiPoziciu(kx,ky,Tlacidla);
    kx:=kx div 2;
    ch:=CitajKlavesAkJe;
    if ch>0 then begin {spracovanie klavesnice}
      ii:=1;
      while (pKlav^[ii]<>ch) and (pKlav^[ii]<>255) do Inc(ii);
      if pKlav^[ii]<255 then Udalost:=ii;
    end;
    if Tlacidla>0 then begin {spracovanie mysi}
      ii:=1;
      while (pAktiv^[ii,1]<400) and
        ((kx<pAktiv^[ii,1]) or (ky<pAktiv^[ii,2]) or (kx>pAktiv^[ii,3]) or (ky>pAktiv^[ii,4]))
        do Inc(ii);
      if pAktiv^[ii,1]<400 then Udalost:=ii;
      if Tlacidla=Prave then Udalost:=Udalost+256;
    end;
  until (ch=27) or (Udalost>0);
  ObsluzUdalost:=Udalost;
  MysX:=kx;MysY:=ky;
end;
function ObsluzUdalostSHelpom(Aktiv,Klav,Pismo,Help:pointer):word;
type UBlok=array[1..100,1..4] of word;
     KBlok=array[1..100] of byte;
     HBlok=array[0..100] of string[40];
var pAktiv:^UBlok;
    pKlav:^KBlok;
    pHelp:^HBlok;
    kx,ky,Udalost,UStara:word;
    Tlacidla,ch,ii:byte;
begin
  pAktiv:=Aktiv;
  pKlav:=Klav;
  pHelp:=Help;
  UStara:=0;
  repeat
    ZistiPoziciu(kx,ky,Tlacidla);
    kx:=kx div 2;
    ch:=CitajKlavesAkJe;
    ii:=1;Udalost:=0;
    while (pAktiv^[ii,1]<400) and
      ((kx<pAktiv^[ii,1]) or (ky<pAktiv^[ii,2]) or (kx>pAktiv^[ii,3]) or (ky>pAktiv^[ii,4]))
      do Inc(ii);
    if pAktiv^[ii,1]<400 then Udalost:=ii;
    if Udalost<>UStara then begin
      VM;
      Color:=0;VyplnPlochu(0,191,320,9);
      VypisPO(0,192,Pismo,pHelp^[Udalost],SvetloModra);
      UStara:=Udalost;
      ZM;
    end; { if }
    if ch>0 then begin {spracovanie klavesnice}
      ii:=1;Udalost:=0;
      while (pKlav^[ii]<>ch) and (pKlav^[ii]<>255) do Inc(ii);
      if pKlav^[ii]<255 then Udalost:=ii;
      if Udalost>0 then Tlacidla:=Lave;
    end;
    if Tlacidla=Prave then Udalost:=Udalost+256;
  until (ch=27) or ((Udalost>0) and (Tlacidla>0));
  ObsluzUdalostSHelpom:=Udalost;
  MysX:=kx;MysY:=ky;
end;
BEGIN
  JeMys:=IOM;
END.