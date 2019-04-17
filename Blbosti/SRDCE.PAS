program Nakresli_srdce;
uses Graph;
const gd:integer=9;
      gm:integer=2;
      xmin=-6;
      xmax=6;
      ymin=-6;
      ymax=6;
      cesta='d:\bp\bgi';
var HorizRes,VertRes,z:longint;
    XRel,YRel,x,y:real;
BEGIN
  InitGraph(gd,gm,cesta);
  HorizRes:=GetMaxX;
  VertRes:=GetMaxY;
  XRel:=(xmax-xmin)/HorizRes;
  YRel:=(ymax-ymin)/VertRes;
  x:=xmin;
  for z:=0 to HorizRes div 2 do begin
    y:=2/3*((Sqr(x)+Abs(x)-6)/(Sqr(x)+Abs(x)+2)+Sqrt(36-Sqr(x)));
    PutPixel(z,round((VertRes*(ymax-y))/(ymax-ymin)),12);
    PutPixel(HorizRes-z,round((VertRes*(ymax-y))/(ymax-ymin)),12);
    y:=2/3*((Sqr(x)+Abs(x)-6)/(Sqr(x)+Abs(x)+2)-Sqrt(36-Sqr(x)));
    PutPixel(z,round((VertRes*(ymax-y))/(ymax-ymin)),12);
    PutPixel(HorizRes-z,round((VertRes*(ymax-y))/(ymax-ymin)),12);
    x:=x+xrel;
  end;
  readln;
END.



