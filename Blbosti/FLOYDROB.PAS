program Floyd_Steinberg;
uses Graph,Crt;
type s=array[0..79,0..479]of byte;
const gd:integer=9;
      gm:integer=2;
var x,y:word;
    a:s;
    f:file of s;

BEGIN
  assign(f,'vision16.dat');
  reset(f);
  read(f,a);
  initgraph(gd,gm,'d:\bp\bgi');
  for y:=0 to 479 do begin
    for x:=0 to 79 do begin
      if a[x,y] and $01>0 then PutPixel(x*8,y,12);
      if a[x,y] and $02>0 then PutPixel(x*8+1,y,12);
      if a[x,y] and $04>0 then PutPixel(x*8+2,y,12);
      if a[x,y] and $08>0 then PutPixel(x*8+3,y,12);
      if a[x,y] and $10>0 then PutPixel(x*8+4,y,12);
      if a[x,y] and $20>0 then PutPixel(x*8+5,y,12);
      if a[x,y] and $40>0 then PutPixel(x*8+6,y,12);
      if a[x,y] and $80>0 then PutPixel(x*8+7,y,12);
    end;
  end;
  readln;
end.
