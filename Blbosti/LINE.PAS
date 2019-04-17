program test;
Uses Graph,Crt;
var x1,x2,y1,y2,gd,gm:integer;
begin
  gd:=9;gm:=2;
  InitGraph(gd,gm,'d:\bp\bgi');
  x1:=random(200)+10;y1:=random(200)+10;x2:=random(240)+400;y2:=random(200)+200;
  repeat
    Line(x1,y1,x2,y2);
    SetColor(random(15)+1);
    x1:=x1+random(7)-3;
    y1:=y1+random(7)-3;
    x2:=x2+random(7)-3;
    y2:=y2+random(7)-3;
    if x1<0 then x1:=0;
    if y1<0 then y1:=0;
    if x2>640 then x2:=640;
    if y2>480 then y2:=480;
  until keypressed;
end.