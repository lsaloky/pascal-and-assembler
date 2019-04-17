program Pascalov_trojuholnik;
var n,y:integer;
    vysledok:real;
function Faktorial(x:real):real;
begin
  if (x=1) or (x=0) then Faktorial:=1
  else Faktorial:=Faktorial(x-1)*x;
end;
BEGIN
  writeln('Zadaj cislo riadku');
  readln(n);
  for y:=0 to n do begin
    vysledok:=Faktorial(n)/Faktorial(n-y)/Faktorial(y);
    write(vysledok:5:0,' ');
  end;
  readln;
END.