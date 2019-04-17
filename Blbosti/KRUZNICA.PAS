program Kruznica;
uses Graph;
const gd:integer=9;
      gm:integer=2;
      sx=320;sy=240;r=200;
var x,y,dy,pred:integer;
procedure KresliSymBody;
begin
  PutPixel(sx+x,sy-y,15);
  PutPixel(sx+x,sy+y,14);
  PutPixel(sx-x,sy-y,13);
  PutPixel(sx-x,sy+y,12);
  PutPixel(sx+y,sy-x,11);
  PutPixel(sx+y,sy+x,10);
  PutPixel(sx-y,sy-x,9);
  PutPixel(sx-y,sy+x,7);
end;
BEGIN
  InitGraph(gd,gm,'d:\bp\bgi');
  x:=0;
  y:=r;
  pred:=3-2*r;
  repeat
    KresliSymBody;
    if pred<0 then
      Inc(pred,4*x+6)
    else begin
      Inc(pred,4*(x-y)+10);
      Dec(y);
    end;
    Inc(x);
  until x>y;
  ReadLn;
END.