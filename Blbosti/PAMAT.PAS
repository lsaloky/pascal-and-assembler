program PamatCisel;
uses Crt;
var a:array[1..100] of byte;
    s:string;
    x,y,z:integer;
begin
  ClrScr;y:=1;Randomize;
  writeln('Program na testovanie pam„te c¡sel');
  writeln('----------------------------------');
  writeln;
  for x:=1 to 100 do a[x]:=random(10);
  repeat
    gotoxy(1,4);
    for x:=1 to y do write(a[x]);
    delay(y*300);
    gotoxy(1,4);
    DelLine;
    readln(s);
    z:=0;
    for x:=1 to y do if s[x]<>Chr(a[x]+48) then z:=1;
    Inc(y)
  until z=1;
  writeln('Pomylil si sa. Stlac klavesu.');
  repeat until keypressed;
end.