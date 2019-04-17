program Kiribatske_klebetnice;    {je zly}
var n,x,y:integer;
    a:array[1..100,1..100] of word;
begin
  writeln('Zadaj pocet liniek');
  readln(n);
  FillChar(a,20000,#0);
  for x:=1 to n do
    for y:=x+1 to n do begin
      write('Dlzka cesty na linke ',x,',',y,'=');
      readln(a[x,y]);
      a[y,x]:=a[x,y];
    end;
  for x:=1 to n do
    for y:=1 to n do begin
      if a[x,1]+a[1,y]<a[x,y] then a[x,y]:=a[x,1]+a[1,y];
      if a[1,x]+a[y,1]<a[y,x] then a[y,x]:=a[1,x]+a[y,1];
    end;
  for y:=1 to n do begin
    for x:=1 to n do
      write(a[x,y],',');
    writeln;
  end;
  writeln('koniec');
  readln;
end.