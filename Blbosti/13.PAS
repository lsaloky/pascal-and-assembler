program Linearne_vyhladavanie;
var a:array[1..21] of integer;
    x,y,z:integer;
begin
  randomize;
  for y:=1 to 20 do a[y]:=random(10);
  for y:=1 to 20 do write(a[y],',');
  writeln;
  writeln('Zadaj cislo, ktore sa ma hladat');
  readln(x);
  y:=1;
  while (a[y]<>x) and (y<21) do Inc(y);
  if y<21 then begin
    writeln(y);
    z:=20;
    while a[z]<>x do Dec(z);
    if z<>y then writeln(z);
  end
   else writeln('Prvok v poli nie je.');
  readln;
end.