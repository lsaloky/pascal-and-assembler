program Pocitanie_faktorialov;   {maximum 1754}
{$n+ r+}
uses crt;
var op1:extended;
    x,faktor:word;
    n:char;
begin
 repeat
  clrscr;
  writeln('Zadaj pocet faktorial');
  readln(faktor);
  op1:=1;
  for x:=1 to faktor do op1:=op1*x;
  writeln(op1:1:0);
  writeln('Chces pokracovat?');
 until readkey = 'n';
end.
