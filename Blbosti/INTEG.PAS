program Integrovanie; {11:30 - 11:38 jednoduchy, - 11:48 dvojny}
{funkcie pre jednoduchy integral}
function f1(x:real):real;
begin
  f1:=sin(x);
end;
{dvojrozmerny - funkcia a ohranicenia}
function f2(x,y:real):real;
begin
  f2:=x*y;
end;
function OhrYD(x:real):real;
begin
  OhrYD:=0;
end;
function OhrYH(x:real):real;
begin
  OhrYH:=1;
end;
{pocitanie}
function Integral1(OhrD,OhrH,Delenie:real):real;
var i,Suma:real;
begin
  i:=OhrD;Suma:=0;
  while (i<OhrH) do begin
    Suma:=Suma+Delenie*f1(i);
    i:=i+Delenie;
  end;
  Integral1:=Suma;
end;
function Integral2(OhrXD,OhrXH,Delenie:real):real;
var i,j,Suma:real;
begin
  i:=OhrXD;j:=OhrYD(i);Suma:=0;
  while (i<OhrXH) do begin
    while (j<OhrYH(i)) do begin
      Suma:=Suma+Delenie*Delenie*f2(i,j);
      j:=j+Delenie;
    end;
    j:=OhrYD(i);
    i:=i+Delenie;
  end;
  Integral2:=Suma;
end;
{hlavny program}
BEGIN
  writeln(Integral1(0,pi,0.001):0:6);
  writeln(Integral2(0,1,0.01):0:6);
  readln;
END.


