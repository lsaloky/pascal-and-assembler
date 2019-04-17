unit BaneTPU;
INTERFACE
procedure ZapniKurzor;
procedure VypniKurzor;
procedure StavMysi(var x,y:word;var Tlacidla:byte);
procedure NastavKurzor(x,y:word);
procedure OknoKurzora(x1,x2,y1,y2:word);
procedure ZapniTextovyKurzor;
procedure VypniTextovyKurzor;
procedure Informuj(s:string);
procedure NakresliCestu(px,py,objekt:word);
procedure SpytajSa(s:string;max:longint;var pocet:longint);
procedure UlozSkore(body:longint);
procedure Umiestni(x,y:integer;s:string);
procedure VypisInfo;
function OknoSuborov(akcia:integer):integer;
procedure PrepisInformacnyRiadok;
IMPLEMENTATION
uses Dos,Crt;
type THiScore=record
                Meno:string;
                PocetLudi:longint;
              end;
var reg:registers;
    cxuloz,sx,sy:word;
    ch:char;
    tlacidlo:byte;
procedure ZapniKurzor;                     {zapnutie kurzora}
begin
  reg.AX:=1;
  intr($33,reg);
end;
procedure VypniKurzor;
begin
  reg.AX:=2;
  intr($33,reg);
end;
procedure OknoKurzora(x1,x2,y1,y2:word);
begin
  reg.CX:=x1;
  reg.DX:=x2;
  reg.AX:=7;
  Intr($33,reg);
  reg.CX:=y1;
  reg.DX:=y2;
  reg.AX:=8;
  Intr($33,reg);
end;
procedure StavMysi(var x,y:word;var Tlacidla:byte);
begin
  reg.AX:=3;
  Intr($33,reg);
  x:=reg.CX;
  y:=reg.DX;
  if reg.BX=0 then Tlacidla:=0;
  if not(reg.BX and 1=0) then Tlacidla:=1;
  if not(reg.BX and 4=0) then Tlacidla:=2;
  if not(reg.BX and 2=0) then Tlacidla:=3;
end;
procedure NastavKurzor(x,y:word);
begin
  reg.CX:=x;
  reg.DX:=y;
  reg.AX:=$04;
  Intr($33,reg);
end;
procedure ZapniTextovyKurzor;
begin
  asm
  mov cx,cxuloz;
  mov ah,1;
  int $10;
  end;
end;
procedure VypniTextovyKurzor;
begin
  asm
  mov ah,3;
  mov bh,0;
  int $10;
  mov cxuloz,cx;
  mov ch,1;
  mov cl,0;
  mov ah,1;
  int $10;
  end;
end;
procedure Informuj(s:string);
begin
  TextColor(15);
  GotoXY(1,24);write('                                                                       ');
  GotoXY(1,24);write(s);
  if s='' then write('Predaj to–ko rudy, aby si mal na vìplaty. Potom stlaŸ KONIEC ROKA.');
end;
procedure NakresliCestu(px,py,objekt:word);
begin
  TextColor(15);
  GotoXY(px,py);
  case objekt of
    $0000:write('Í');
    $0F00:write('Í');
    $1F00:write('º');
    $2F00:write('Í');
    $3F00:write('È');
    $4F00:write('º');
    $5F00:write('º');
    $6F00:write('É');
    $7F00:write('Ì');
    $8F00:write('Í');
    $9F00:write('¼');
    $AF00:write('Í');
    $BF00:write('Ê');
    $CF00:write('»');
    $DF00:write('¹');
    $EF00:write('Ë');
    $FF00:write('Î');
  end;
end;
procedure SpytajSa(s:string;max:longint;var pocet:longint);
var xpom:word;
begin
  TextColor(15);
  GotoXY(1,24);write('                                                                       ');
  GotoXY(1,24);write(s,' (maxim lne ',max,')');
  ZapniTextovyKurzor;
  xpom:=WhereX;
  repeat
    GotoXY(xpom,24);
    write('          ');
    GotoXY(xpom,24);
    readLn(pocet);
  until (pocet>=0) and (pocet<=max);
  Informuj('');
  VypniTextovyKurzor;
end;
procedure UlozSkore(body:longint);
var HiScores:file of THiScore;
    HiScoreMem:THiScore;
begin
  Assign(HiScores,'topten.dat');
  Reset(HiScores);
  TextColor(15);
  GotoXY(1,24);write('                                                                       ');
  GotoXY(1,24);write('Nap¡ç svoje meno:');
  ZapniTextovyKurzor;
  repeat
    ReadLn(HiScoreMem.Meno);
  until HiScoreMem.Meno<>'';
  HiScoreMem.PocetLudi:=body;
  VypniTextovyKurzor;
  write(HiScores,HiScoreMem);
  Close(HiScores);
end;
procedure Umiestni(x,y:integer;s:string);
begin
  GotoXY(x,y);
  write(s);
end;
procedure VypisInfo;
var pravidla:text;
    x,y:integer;
    s,t:string;
begin
  Assign(pravidla,'pravidla.slo');
  Reset(pravidla);
  TextColor(7);TextBackGround(0);
  Umiestni(5,2,'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
  x:=3;
  repeat
    ReadLn(pravidla,s);
    t:='³                                                                ³';
    Move(s[1],t[3],Length(s));
    Umiestni(5,x,t);
    Inc(x);
  until EOF(pravidla);
  Umiestni(5,x,  '³                                                                ³');
  Umiestni(5,x+1,'³                               OK                               ³');
  Umiestni(5,x+2,'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
  TextColor(7);TextBackGround(5);
  GotoXY(36,x+1);write(' OK ');
  TextBackGround(0);
  repeat
    StavMysi(sx,sy,tlacidlo);
  until (keypressed) or ((tlacidlo=1) and (sy=x*8) and (sx>=280) and (sx<=304));
  if keypressed then s:=ReadKey;
  Close(pravidla);
end;
function OknoSuborov(akcia:integer):integer;
var NazvySavov:file of string;
    s,t:string;
    pom,xpom:word;
begin
  Assign(NazvySavov,'saves.inf');
  Reset(NazvySavov);
  TextColor(7);TextBackGround(0);
                  Umiestni(17,6,'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
  if akcia=1 then Umiestni(17,7,'³       Kam to chceç ulo§iœ?     ³');
  if akcia=2 then Umiestni(17,7,'³ Ktor£ poz¡ciu si chceç nahraœ? ³');
                  Umiestni(17,8,'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´');
  for pom:=1 to 10 do begin
    read(NazvySavov,s);
    if s='' then t:='³ '+Chr(pom+47)+' -     << vo–n‚ miesto >>     ³'
    else begin
      t:='³ '+Chr(pom+47)+' -                            ³';
      Move(s[1],t[7],Length(s));
    end;
    Umiestni(17,8+pom,t);
  end;
  Umiestni(17,19,'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
  ch:=' ';
  repeat
    StavMysi(sx,sy,tlacidlo);
    if keypressed then ch:=ReadKey
  until (Ord(ch)>=48)  and (Ord(ch)<=57)
    or ((tlacidlo=1) and (sx>=136) and (sx<=384) and (sy>=64) and (sy<=136));
  if Ord(ch)>32 then pom:=Ord(ch)-48
    else pom:=(sy div 8)-8;
  if akcia=1 then begin
    TextColor(15);
    ZapniTextovyKurzor;
    GotoXY(1,24);write('                                                                       ');
    GotoXY(1,24);write('Pod akìm n zvom to m m ulo§iœ?');
    xpom:=WhereX;
    repeat
      GotoXY(xpom,24);
      write('                 ');
      GotoXY(xpom,24);
      readLn(s);
    until s<>'';
    Seek(NazvySavov,pom);
    write(NazvySavov,s);
    VypniTextovyKurzor;
  end;
  Close(NazvySavov);
  OknoSuborov:=pom;
end;
procedure PrepisInformacnyRiadok;
begin
  repeat
    StavMysi(sx,sy,tlacidlo);
  until (tlacidlo>0) or (keypressed);
  if keypressed then ch:=readkey;
  Informuj('');
  repeat
    StavMysi(sx,sy,tlacidlo);
  until tlacidlo=0;
end;
END.