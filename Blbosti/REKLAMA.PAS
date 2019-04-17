program pocitac;
uses Crt,Graph;
const a:array[1..7] of integer=(-12,-28,-60,-108,-206,-416,-1200);
var gd,gm,col:integer;
    s:string;
procedure kresli;
var x,y,z,le,aktual:integer;
begin
  x:=50;y:=0;le:=16;aktual:=1;  {le - dlzka retazca}
  inc(col);
  repeat
    setusercharsize(y,10,y,10);
    outtextxy(x*6,x div 3+200,s);
    sound(x+1000);
    asm
      hlt
    end;
    if x=10 then
    begin
      nosound;
      delay(1000);
    end;
    setcolor(0);
    outtextxy(x*6,x div 3+200,s);
    setcolor(col);
    inc(y,4);
    x:=x-8;
    if x<a[aktual] then
    begin
      delete(s,le,1);
      dec(le);
      inc(aktual);
    end;
  until x<-500;
end;
begin
detectgraph(gd,gm);
initgraph(gd,gm,'d:\bp\bgi');
settextstyle(sansseriffont,horizdir,4);
col:=3;
s:='   486 sx 33    ';
kresli;
s:='   4 MB RAM     ';
kresli;
s:=' 210 MB harddisk';
kresli;
s:='Color LR monitor';
kresli;
closegraph;
nosound;
end.