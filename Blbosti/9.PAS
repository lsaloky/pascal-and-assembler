program Vypis_delitelov_cisla;
var cislo,x:longint;
BEGIN
  writeln('Zadaj cislo');
  readln(cislo);
  write('1');
  for x:=2 to cislo do if cislo mod x=0 then write(',',x);
  writeln;
  readln;
END.