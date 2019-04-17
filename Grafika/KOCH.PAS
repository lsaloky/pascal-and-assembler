program Kochova_krivka;
uses Graph;
const gd:integer=9;
      gm:integer=2;
var Farba:word;
procedure Koch(x,y,Dlzka,Uhol:real);
begin
  if Dlzka<2 then PutPixel(Round(x),Round(y),Farba)
  else begin
    Koch(x                    ,y                    ,Dlzka/3,Uhol     );
    Koch(x+sin(Uhol)*Dlzka*2/3,y+cos(Uhol)*Dlzka*2/3,Dlzka/3,Uhol     );
    Koch(x+sin(Uhol)*Dlzka  /3,y+cos(Uhol)*Dlzka  /3,Dlzka/3,Uhol+pi/3);
{    Koch(x+sin(Uhol)*Dlzka*2/3,y+cos(Uhol)*Dlzka*2/3,Dlzka/3,Uhol+2*pi/3);}
    Koch(x+(sin(Uhol)+sin(Uhol+pi/3))*Dlzka/3,
         y+(cos(Uhol)+cos(Uhol+pi/3))*Dlzka/3,Dlzka/3,Uhol-pi/3);
  end;
end;
procedure Sierpinski(x,y,Dlzka,Vyska:real);
begin
  if Dlzka<1 then PutPixel(Round(x),Round(y),Farba)
  else begin
    Sierpinski(x,        y,        Dlzka/2,Vyska/2);
    Sierpinski(x+Dlzka/2,y,        Dlzka/2,Vyska/2);
    Sierpinski(x+Dlzka/4,y+Vyska/2,Dlzka/2,Vyska/2);
  end;
end;
BEGIN
  InitGraph(gd,gm,'d:\bp\bgi');
  Farba:=LightRed;
  Koch(0,200,640,pi/2);
  Farba:=White;
  Koch(320,240,200,pi/6);
  Koch(220,413,200,pi*5/6);
  Koch(420,413,200,3*pi/2);
  ReadLn;
  ClearDevice;
  Sierpinski(10,450,500,-433);
  ReadLn;
END.