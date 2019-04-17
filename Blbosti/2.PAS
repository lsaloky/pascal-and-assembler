program Postupnosti;
var x,y:real;
    n,i:longint;
begin
  writeln('Zadaj,ktory clen chces vypocitat');
  readln(n);
  x:=1;y:=2;
  for i:=1 to n do begin
    x:=x/i+y/i/(i+1);
    y:=y/(i+1)+x/i;
  end;
  writeln(x:1:5,',',y:1:5);
  readln;
end.

