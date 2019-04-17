program na_vypisanie_stromovej_struktury_disku;
uses Dos;
var e:integer;
    d:longint;
procedure adresar(zac:string);
var z:searchrec;
begin
  FindFirst(zac+'*.*',0,z);
  while DosError=0 do begin
    Inc(e);
    d:=d+z.Size;
{    writeln(zac+z.name);
    if e mod 24=23 then begin
      write('Stlac Enter');
      readln;
    end;}
    FindNext(z);
  end;
  FindFirst(zac+'*.*',$10,z);
  while DosError=0 do begin
    if (z.attr and directory<>0) and (z.name<>'.') and (z.name<>'..') then adresar(zac+z.name+'\');
    FindNext(z);
  end;
end;
BEGIN
  d:=0;e:=0;
  adresar('e:\');
  writeln('Pocet suborov= ',e);
  writeln('Celkova dlzka= ',d);
END.

