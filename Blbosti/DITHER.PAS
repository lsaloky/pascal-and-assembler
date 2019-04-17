   {Zac¡nam s knihou Illumination and Color in Computer Generated Imagery}
                       {4=red, 2=green, 1=blue}
program Dithering_primitivny;
uses Graph;

var gd,gm:integer;

procedure Makaj;
var cell:array[0..15,0..15] of byte;
    x,y,z,ranx,rany,osx,osy:integer;
begin
  x:=0;
  while x<40 do begin
    y:=0;
    Inc(x);
    while y<30 do begin
      Inc(y);
      for osx:=0 to 15 do for osy:=0 to 15 do cell[osx,osy]:=0;
      for z:=1 to x+y do begin
        ranx:=random(8);rany:=random(8);
        while cell[ranx,rany]=1 do ranx:=random(8);rany:=random(8);
        cell[random(16),random(16)]:=1;
      end;
      for osx:=0 to 15 do for osy:=0 to 15 do PutPixel(16*x+osx,16*y+osy,cell[osx,osy]);
    end;
  end;
end;

BEGIN
  gd:=9;gm:=2;
  initgraph(gd,gm,'d:\bp\bgi');
  cleardevice;
  Makaj;
  readln;
  CloseGraph;
END.