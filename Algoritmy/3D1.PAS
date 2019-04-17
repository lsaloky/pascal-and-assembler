program Kolme_premietanie;
uses MainGr;
{.mpm - MukoSoft priestorovy model}
const XMin:real=-1;XMax:real=2;YMin:real=-0.5;{YMax sa dopocita}
type TVrchol=record
               x,y,z:word;
             end;
var Vrchol:array[0..7] of TVrchol;
    Kocka:array[0..5,0..3] of word;
    f:text;
    YMax,XRel,YRel:real;
    i,j:integer;
function AbsX(x:real):integer;
begin
  AbsX:=Round((x-XMin)/XRel);
  if x>=XMax then AbsX:=319;
  if x<=XMin then AbsX:=0;
end;
function AbsY(y:real):integer;
begin
  AbsY:=Round((YMax-y)/YRel);
  if y>=YMax then AbsY:=199;
  if y<=YMin then AbsY:=0;
end;
procedure CiaraVirt(x1,y1,x2,y2:real;Farba:byte);
var pom:byte;
begin
  pom:=Color;
  Color:=Farba;
  Ciara(AbsX(x1),AbsY(y1),AbsX(x2),AbsY(y2));
  Color:=pom;
end;
procedure ZobrazJednotkoveVektory;
begin
  Color:=1;
  Ciara(AbsX(-0.1),AbsY(0),AbsX(1),AbsY(0));
  Ciara(AbsX(0),AbsY(-0.1),AbsX(0),AbsY(1));
  Ciara(AbsX(0.1),AbsY(0.9),AbsX(0),AbsY(1));
  Ciara(AbsX(-0.1),AbsY(0.9),AbsX(0),AbsY(1));
  Ciara(AbsX(0.9),AbsY(0.1),AbsX(1),AbsY(0));
  Ciara(AbsX(0.9),AbsY(-0.1),AbsX(1),AbsY(0));
end;
procedure KolmePremietanieZ; {z=0}
begin
  for i:=0 to 5 do
    for j:=0 to 3 do
      CiaraVirt(Vrchol[Kocka[i,j]].x,Vrchol[Kocka[i,j]].y,
                Vrchol[Kocka[i,(j+1) mod 4]].x,Vrchol[Kocka[i,(j+1) mod 4]].y,15);
end;
procedure KolmePremietanieY; {y=0}
begin
  for i:=0 to 5 do
    for j:=0 to 3 do
      CiaraVirt(Vrchol[Kocka[i,j]].x,Vrchol[Kocka[i,j]].z,
                Vrchol[Kocka[i,(j+1) mod 4]].x,Vrchol[Kocka[i,(j+1) mod 4]].z,15);
end;
procedure KolmePremietanieX; {x=0}
begin
  for i:=0 to 5 do
    for j:=0 to 3 do
      CiaraVirt(Vrchol[Kocka[i,j]].z,Vrchol[Kocka[i,j]].y,
                Vrchol[Kocka[i,(j+1) mod 4]].z,Vrchol[Kocka[i,(j+1) mod 4]].y,15);
end;
BEGIN
  YMax:=YMin+(XMax-XMin)*200/320;
  XRel:=(XMax-XMin)/320;YRel:=(YMax-YMin)/200;
  Assign(f,'kocka.dat');
  Reset(f);
  ReadLn(f);
  for i:=0 to 7 do ReadLn(f,Vrchol[i].x,Vrchol[i].y,Vrchol[i].z);
  ReadLn(f);
  for i:=0 to 5 do ReadLn(f,Kocka[i,0],Kocka[i,1],Kocka[i,2],Kocka[i,3]);
  Close(f);
  InicializujGrafiku;
  ZobrazJednotkoveVektory;
  KolmePremietanieX;
  KolmePremietanieY;
  KolmePremietanieZ;
  ReadLn;
  ZavriGrafiku;
  WriteLn('MukoSoft prv‚ pokusy s 3D grafikou'#13#10'Lubos Saloky, 1998 ');
END.
