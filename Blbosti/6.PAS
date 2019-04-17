program Zisti_ci_je_prvocislo;
var prvoc:longint;
    x,odmoc:word;
    vysledok:boolean;
BEGIN
  vysledok:=false;
  writeln('Zadaj cislo');
  readln(prvoc);
  odmoc:=trunc(sqrt(prvoc));
  for x:=2 to odmoc do if prvoc mod x=0 then vysledok:=true;
  write('Cislo ',prvoc,' ');
  if vysledok then write('nie ');
  writeln('je prvocislo');
  readln;
END.