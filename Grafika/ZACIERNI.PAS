program Efektne_zaciernenie;
uses Graph,Crt;
type TObraz=array[0..38399]of byte;   {cierny=0}
var PObraz:^TObraz;
    x,y:word;
    BodLin:Longint;
    BBajt,BBit:word;                  {bod adresovany ako bajt a bit}

procedure Init;
const gd:integer=9;
      gm:integer=2;
      cesta='d:\bp\bgi';
begin
  InitGraph(gd,gm,cesta);
end;

procedure NastavMocninuDvojky;
var pom:word;
begin
  y:=1;pom:=BBit;
  while pom>0 do begin
    y:=y*2;
    Dec(pom);
  end;
end;

procedure NastavBit;
begin
  NastavMocninuDvojky;
  PObraz^[BBajt]:=PObraz^[BBajt] xor y;
end;

Function PrecitajBit:word;       {0=cierny}
begin
  NastavMocninuDvojky;
  if PObraz^[BBajt] and y>0 then PrecitajBit:=1
    else PrecitajBit:=0;
end;

BEGIN
  Init;
  FloodFill(0,0,7);
  GetMem(PObraz,38400);
  FillChar(PObraz^,38400,#255);
  repeat
    BBajt:=Random(38398)+1;
    x:=BBajt-1;
    while (PObraz^[BBajt]=0) and (x<>BBajt) do begin
      Inc(BBajt);
      If Bbajt=38399 then BBajt:=0;
    end;
    BBit:=random(8);
    while PrecitajBit=0 do begin
      Inc(BBit);
      if BBit>7 then BBit:=0;
    end;
    BodLin:=BBajt;
    BodLin:=BodLin*8+BBit;
    NastavBit;
    PutPixel(BodLin mod 640,BodLin div 640,0);
  until keypressed or (x=BBajt);
  readln;
END.
