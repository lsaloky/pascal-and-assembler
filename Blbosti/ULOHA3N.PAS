program uloha3;
type data=record
          lx,ly,sir,vys,col:integer;
          end;
     data2=record
           plocha,farba:integer;
           end;
var papier,papier2:array[1..10,1..10] of integer;
    obdlzniky:array[1..2] of data;
    utvary:array[1..100] of data2;
    x,y,z,zvysok,akt,a,b:integer;
begin
for x:=1 to 24 do writeln;
Zvysok:=0;akt:=1;
for x:=1 to 5 do
  for y:=1 to 5 do
    papier[x,y]:=1;
for x:=1 to 100 do utvary[x].plocha:=0;
obdlzniky[1].lx:=1;obdlzniky[1].ly:=1;obdlzniky[1].sir:=2;obdlzniky[1].vys:=2;obdlzniky[1].col:=3;
obdlzniky[2].lx:=2;obdlzniky[2].ly:=2;obdlzniky[2].sir:=7;obdlzniky[2].vys:=2;obdlzniky[2].col:=4;
for z:=1 to 2 do
  for y:=obdlzniky[z].ly to obdlzniky[z].ly+obdlzniky[z].vys-1 do
    for x:=obdlzniky[z].lx to obdlzniky[z].lx+obdlzniky[z].sir-1 do
      if (x>5) or (y>5) or (y<0) or (y>5) then Inc(Zvysok)
                                          else papier[x,y]:=obdlzniky[z].col;
writeln;
for y:=1 to 5 do begin
  for x:=1 to 5 do
    write(papier[x,y],' ');
  writeln;
end;
move(papier,papier2,sizeof(papier));
writeln('Zvysok:',zvysok);
                                   for y:=1 to 5 do
  for x:=1 to 5 do
    if papier[x,y]>0 then begin
      a:=y;b:=x;
      utvary[akt].farba:=papier[x,y];
      while (b<6) and (papier[a,b]=papier2[y,x]) do begin
        while (a<6) and (papier[a,b]=papier2[y,x]) do begin
          Inc(utvary[akt].plocha);
          papier[a,b]:=0;
          Inc(a);
        end;
        a:=y;
        inc(b);
      end;
      Inc(akt);
    end;
for x:=1 to akt-1 do
  writeln('Plocha:',utvary[x].plocha,'  farba:',utvary[x].farba);
writeln('Zostalo:');
for y:=1 to 5 do begin
  for x:=1 to 5 do
    write(papier[x,y],' ');
  writeln;
end;
readln;
end.
