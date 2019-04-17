program Vsuvanie_do_jednorozmerneho_pola;
var a:array[1..21] of word;
    x,y,z:word;
begin
  randomize;
  a[1]:=random(10);
  for x:=2 to 20 do begin
    a[x]:=a[x-1]+random(10);
    write(a[x-1],',');
  end;
  writeln(a[20]);
  writeln('Zadaj cislo, ktore sa ma vsunut');
  readln(x);
  y:=1;
  while x>a[y] do Inc(y);
  for z:=21 downto y+1 do a[z]:=a[z-1];
  a[y]:=x;
  for x:=2 to 21 do write(a[x-1],',');
  writeln(a[21]);
  readln;
end.


