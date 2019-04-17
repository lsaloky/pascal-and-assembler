program Vypocitavanka;
{$DEFINE INDEX}
const n=5;
      slab=3;{pocet slabik vypocitavanky}
type POsoba=^TOsoba;
     TOsoba=record
{$IFDEF INDEX}
       Index:word;
{$ENDIF}
       JeVon:boolean;
       Dalsi:POsoba;
     end;
var p,r:POsoba;
    x:longint;   {pocitadlo slabik}
    y:longint;   {pocitadlo vypadnutych ucastnikov}
BEGIN
{ ----- inicializacia ----- }
  New(p);
  r:=p;
  for x:=1 to n-1 do begin{vytvorenie struktury}
{$IFDEF INDEX}
    r^.Index:=x;
{$ENDIF}
    r^.JeVon:=false;
    New(r^.Dalsi);
    r:=r^.Dalsi;
  end;
{$IFDEF INDEX}
  write('Poradie vypadavania ucastnikov: ');
  r^.Index:=n;{uzavretie struktury}
{$ENDIF}
  r^.JeVon:=false;
  r^.Dalsi:=p;
{ ----- vypocitavanie ----- }
  y:=0;
  repeat
    x:=0;
    repeat{napocitaj do slab}
      r:=r^.Dalsi;
      if not r^.JeVon then Inc(x);
    until x=slab;
    r^.JeVon:=true;{vyhod ho a vypis to}
{$IFDEF INDEX}
    write(r^.Index,' ');
{$ENDIF}
    Inc(y);
  until y=n-1;
{ ----- vypis toho, kto zostal ----- }
  r:=p;
  x:=1;
  while r^.JeVon do begin
    r:=r^.Dalsi;
    Inc(x);
  end;
  writeln;
  writeln('Zostal teda nakoniec ',x,'. ucastnik.');
  readln;
END.