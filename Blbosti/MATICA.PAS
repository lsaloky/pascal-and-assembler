program otacajmaticu;
uses crt;
var matica:array[1..10,1..10]of integer;
    c,x,y,f,g:integer;
begin
clrscr;
writeln('Zadaj pocet riadkov matice (do 10)');
readln(f);
writeln('Zadaj pocet stlpcov matice (do 10)');
readln(g);
for x:=1 to f do
begin
  for y:=1 to g do
  begin
    matica[x,y]:=random(20);
    gotoxy(y*5,x+4);
    write(matica[x,y]);
  end;
end;
for x:=1 to f do
begin
  for y:=1 to g do
  begin
    c:=matica[y,x];
    matica[y,x]:=matica[x,y];
    matica[x,y]:=c;
  end;
end;
for x:=1 to f do
begin
  for y:=1 to g do
  begin
    gotoxy(y*5,x+14);
    write(matica[y,x]);
  end;
end;
repeat until keypressed;
end.







end.

