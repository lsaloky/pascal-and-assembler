program Triedenie;
const velkost=10;
var a:array[1..velkost]of integer;
    x,y,min,pom,index:integer;
begin
  for x:=1 to velkost do a[x]:=random(100);
  for x:=1 to velkost do write(a[x],',');
  writeln;
  for x:=1 to velkost-1 do begin
    min:=32767;
    for y:=x to velkost do begin
      if a[y]<=min then begin
        index:=y;
        min:=a[y];
      end;
    end;
    pom:=a[x];
    a[x]:=a[index];
    a[index]:=pom;
  end;
  for x:=1 to velkost do write(a[x],',');
  writeln;
  readln;
end.