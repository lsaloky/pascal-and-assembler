uses crt;
var a,b:integer;
begin
clrscr;
randomize;
b:=random(100);
repeat
a:=1;
write('.');
a:=a+1;
until a=b;
readln;
end.