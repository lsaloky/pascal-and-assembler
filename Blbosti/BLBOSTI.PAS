
program Rozne_efekty;
uses dos;
var r:registers;
begin
  r.AX:=$0001;
  Intr($33,r);
  writeln('Mys je OK. Stlac Enter');
  readln;
  r.AX:=$001f;
  Intr($33,r);
  r.AX:=$0004;
  r.CX:=640;
  r.DX:=480;
  Intr($33,r);
  writeln('Mys je vyradena. Stlac Enter');
  readln;
  r.AX:=$0020;
  Intr($33,r);
  writeln('Mys je OK. Stlac Enter');
  readln;
  Port[$60]:=$0f5;  {vyradenie klavesnice}
  Port[$60]:=$0f4;  {znovuzapnutie klavesnice}
  Port[$3C6]:=$00;  {vyradenie zobrazovania}
  Port[$3C6]:=$FF;  {znovuzapnutie zobrazovania}
END.