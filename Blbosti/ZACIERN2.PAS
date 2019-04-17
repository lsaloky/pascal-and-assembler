program Efektne_Zaciernenie_2;
uses Graph,Crt;
type TObraz=array[0..38399]of byte;   {cierny=0}
var PObraz:^TObraz;
    x,y:word;
    BodLin:longint;

procedure Init;
const gd:integer=9;
      gm:integer=2;
      cesta='d:\bp\bgi';
begin
  InitGraph(gd,gm,cesta);
end;

BEGIN
  Init;
  FloodFill(0,0,7);
  GetMem(PObraz,38400);
  SetColor(0);
  FillChar(PObraz^,38400,#255);
  repeat
    x:=Random(38400);
    while PObraz^[x]=0 do begin
      inc(x);
      if x>38399 then x:=0;
    end;
    if PObraz^[x]<255 then begin
      PObraz^[x]:=0;
      BodLin:=x;
      BodLin:=BodLin*8;
      Line(BodLin mod 640,BodLin div 640,BodLin mod 640+7,BodLin div 640);
    end;
    if PObraz^[x]=255 then begin
      PObraz^[x]:=PObraz^[x] xor random(256);
      for y:=1 to 5 do begin
        BodLin:=x;
        BodLin:=BodLin*8;
        PutPixel(BodLin mod 640+random(8),BodLin div 640,0);
      end;
    end;
  until keypressed;
END.