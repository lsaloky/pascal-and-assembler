program vyries_sustavu_n_rovnic_o_n_neznamych;
uses Crt;
var matica2:array[1..10,1..9]of real;
    pom1,pom2:real;
    x,y,z,pocet:integer;
begin
textbackground(0);ClrScr;
writeln ('Zadaj pocet rovnic:');
read(pocet);
window(1,10,pocet*6+7,pocet+12);
textbackground(4);clrscr;
for x:=1 to pocet do
  write('   x',x);
writeln('   =');
for x:=1 to pocet do begin
  writeln(x,'.');
  for y:=1 to pocet+1 do begin
    gotoxy(y*5-1,x+1);
    readln(pom1);
    matica2[y,x]:=pom1;
  end;
end;
for z:=1 to pocet do begin
  for x:=pocet downto z+1 do begin
    pom1:=matica2[z,z];
    pom2:=matica2[z,x];
    for y:=z to pocet+1 do
      matica2[y,x]:=matica2[y,z]*pom2-matica2[y,x]*pom1;
  end;
end;
window(pocet*6+9,11,pocet*6+19,11+pocet);textbackground(blue);clrscr;
for x:=pocet downto 1 do begin
  pom1:=matica2[pocet+1,x]/matica2[x,x];
  writeln('x',x,'=',pom1:5:3);
  for y:=1 to pocet do begin
    matica2[pocet+1,y]:=matica2[pocet+1,y]-pom1*matica2[x,y];
  end;
end;
repeat until keypressed;
end.
