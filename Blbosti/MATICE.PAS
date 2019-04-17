program vynasobmatice;
uses Crt;
var riadok,stlpec,x,y,z,r1,s1,r2,s2,r3,s3:integer;
    m1,m2,m3:array[1..15,1..15]of integer;
begin
textbackground(0);textcolor(lightblue);clrscr;
window(10,10,67,14);textbackground(2);clrscr;
writeln('Zadaj pocet riadkov a stlpcov prvej matice');     {nacitanie dat}
readln(r1,s1);
r2:=s1;
window(12,12,55,15);textbackground(4);clrscr;
writeln('Zadaj pocet stlpcov druhej matice');
readln(s2);
r3:=r1;
s3:=s2;
writeln('Zadavaj prvky matice 1 po riadkoch:');            {1. matica}
window(2,2,8+r1*5,3+s1);textbackground(3);clrscr;
for x:=1 to r1 do
begin
  for y:=1 to s1 do
  begin
    gotoxy(y*6-5,x+1);
    readln(m1[x,y]);
  end;
end;
writeln('');
window(12,12,55,15);textbackground(4);clrscr;
writeln('Zadavaj prvky matice 2 po riadkoch:');             {2. matica}
window(10+s1*5,2,10+s1*5+s2*5,4+r2);textbackground(3);clrscr;
for x:=1 to r2 do
begin
  for y:=1 to s2 do
  begin
    gotoxy(y*6-5,x+1);
    readln(m2[x,y]);
  end;
end;
window(13,11,59,18);textbackground(magenta);clrscr;
writeln('');writeln('Vynasobenim tychto matic vznikne matica:');writeln('');
for x:=1 to r1 do
begin
  for y:=1 to s2 do
  begin
    m3[x,y]:=0;
    for z:=1 to s1 do
      m3[x,y]:=m3[x,y]+m1[x,z]*m2[z,y];
    write(m3[x,y],'   ');
  end;
writeln(' ');
end;
writeln('');writeln('Stlac akukolvek klavesu');
repeat until keypressed;
end.


