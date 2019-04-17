program Pocitaj_E;
{$N+,E+}
const menovatel:extended=1;
      sucet:extended=0;
var x:word;
begin
  for x:=1 to 17 do begin
    sucet:=sucet+1/menovatel;
    menovatel:=menovatel*x;
  end;
  writeln;
  writeln('Vysledok            ',sucet);
  writeln('Spravne by malo byt ',Exp(1.0));
  readln;
end.