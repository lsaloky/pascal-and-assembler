program Zisti_ci_je_matica_symetricka;
uses Crt;
var a:array[1..4,1..4] of byte;
    vysledok:boolean;
    x,y:word;
begin
  ClrScr;
  vysledok:=true;
  writeln('Zadavaj maticu po riadkoch:');
  for y:=1 to 4 do
    for x:=1 to 4 do begin
      GotoXY(x*5,y+1);
      readln(a[x,y]);
    end;
  for x:=1 to 4 do
    for y:=1 to 4 do
      if a[x,y]<>a[y,x] then vysledok:=false;
  write('Matica');
  if vysledok=false then write(' nie');
  writeln(' je symetricka.');
  readln;
end.



