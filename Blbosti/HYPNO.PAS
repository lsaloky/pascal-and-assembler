program Demo;{trapny graficky efekt}
uses Graph,Crt;
var x,y,xrad,yrad,sta,enda,col:integer;

procedure Init;
var gd,gm:integer;
begin
  gd:=9;gm:=2;
  initgraph(gd,gm,'d:\bp\bgi');
end;

BEGIN
  Init;
  x:=320;y:=240;xrad:=10;yrad:=7;sta:=0;enda:=30;col:=1;
  repeat
    SetColor(col);
    ellipse(x,y,sta,enda,xrad,yrad);
    Inc(xrad);
    Inc(yrad);
    Inc(sta);
    Inc(enda,6);
    Inc(col);
    if enda>2000 then begin
      x:=320;y:=240;xrad:=10;yrad:=7;sta:=0;enda:=30;
    end;
  until keypressed;
END.