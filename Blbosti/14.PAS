program Matica;
var m:array[1..100,1..100] of byte;
    n,x,y:byte;
BEGIN
  Randomize;
  writeln('Aka velka ma byt matica?');
  readln(n);
  for x:=1 to n do
    for y:=1 to n do
      m[x,y]:=random(256);
  for y:=1 to n do begin
    for x:=1 to n do write(m[x,y],',');
    writeln;
  end;
  readln;
END.


