program Otacanie_stvorca;
uses Graph;
const gd:integer=9;
      gm:integer=2;
      cesta='d:\bp\bgi';
var uhol:real;
    ch:char;
procedure Nakresli;
begin
  Line(100,100,round(100+100*cos(uhol)),round(100-100*sin(uhol)));
  Line(round(100+100*cos(uhol)),round(100-100*sin(uhol)),
  round(100+100*sqrt(2)*cos(uhol+pi/2)),round(100-100*sqrt(2)*sin(uhol+pi/2)));
  Line(100,100,round(100+100*sin(uhol)),round(100+100*cos(uhol)));
  Line(100,200,100,100);
end;

BEGIN
  uhol:=0;
  InitGraph(gd,gm,cesta);
  repeat
    Nakresli;
    uhol:=uhol+0.1;
  until uhol>pi;
  readln;
END.

