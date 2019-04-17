program Dynamicke_premenne;
uses Dos;
type a=array[1..65000] of byte;
     b=array[1..65000] of byte;
var p:^a;
    r:^b;
begin
  writeln;
  writeln('Dostupna pamat:',MaxAvail);
  GetMem(p,65000);
  FillChar(p,1,0);
  GetMem(r,65000);
  writeln('Po rezervovani:',MaxAvail);
  p^[64000]:=225;
  r^[64000]:=90;
  writeln('hodnoty v hromade:',p^[64000],' ',r^[64000]);
  FreeMem(p,65000);       {uvolnenie pamate}
  FreeMem(r,65000);
  readln;
end.