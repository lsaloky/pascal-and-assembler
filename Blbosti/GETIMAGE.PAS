program presun_bitovej_mapy;
uses Graph,Crt;
type obraz=array[0..5258] of byte;
var gd,gm,x,y,barx,bary:integer;
    xz,yz:real;
    p:^obraz;
begin
  gd:=9;gm:=2;initgraph(gd,gm,'d:\bp\bgi');
  ClearDevice;
  GetMem(p,ImageSize(50,0,150,100));
  for x:=1 to 1000 do PutPixel(random(98)+51,random(98)+1,random(16));
  GetImage(50,0,150,100,p^);
  x:=50;y:=0;xz:=3;yz:=3;
  repeat
    x:=round(x+xz);
    y:=round(y+yz);
    if yz<0 then yz:=yz*0.98;
    if yz>0 then yz:=yz*1.020408;
    if x>539 then begin
      x:=538;
      xz:=-xz;
    end;
    if x<0 then begin
      x:=1;
      xz:=-xz;
    end;
    if y<0 then begin
      y:=1;
      yz:=-yz;
    end;
    if y>389 then begin
      y:=388;
      yz:=-yz;
    end;
    PutImage(x,y,p^,ORPut);
    SetfillStyle(0,black);
    barx:=random(620);bary:=random(460);
    Bar(barx,bary,barx+random(40),bary+random(40));
  until keypressed;
end.
