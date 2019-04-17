program Bezierove_krivky;
uses Graph;
const gd:integer=9;
      gm:integer=2;
      cesta='d:\bp\bgi';
      PocetBodov=4;
      PC=5;   {pocet ciar}
      zdroj:array[1..PocetBodov,1..2]of integer=((300,100),(200,420),(20,220),(620,435));
var x:word;
    BK:array[0..PC,1..2] of longint; {body krivky}
BEGIN
  InitGraph(gd,gm,cesta);
  MoveTo(zdroj[1,1],zdroj[1,2]);
  for x:=0 to PC do begin
    BK[x,1]:=(((PC-x)*(PC-x)*(PC-x) div PC)*zdroj[1,1]) div PC div PC
     +3*(((PC-x)*(PC-x)*x) div PC*zdroj[2,1]) div PC div PC
     +3*(((PC-x)*x*x) div PC*zdroj[3,1]) div PC div PC
     +((x*x*x) div PC*zdroj[4,1]) div PC div PC;
    BK[x,2]:=(((PC-x)*(PC-x)*(PC-x) div PC)*zdroj[1,2]) div PC div PC
     +3*(((PC-x)*(PC-x)*x) div PC*zdroj[2,2]) div PC div PC
     +3*(((PC-x)*x*x) div PC*zdroj[3,2]) div PC div PC
     +((x*x*x) div PC*zdroj[4,2]) div PC div PC;
  end;
  for x:=0 to PC do LineTo(BK[x,1],BK[x,2]);
  readln;
  CloseGraph;
  WriteLn('MukoSoft B‚zierove krivky'#13#10'Lubos Saloky, 1996');
END.

{ ----- Algoritmus, ktory potrebuje realne cisla -----
var x:integer;
    t,u:array[1..PocetCiar,1..3] of real;
    pom:array[1..PocetCiar,1..2] of integer;

BEGIN
  for x:=1 to PocetCiar do begin
    t[x,1]:=1-x*(1/PocetCiar);
    t[x,2]:=t[x,1]*t[x,1];
    t[x,3]:=t[x,2]*t[x,1];
    u[x,1]:=x*(1/PocetCiar);
    u[x,2]:=u[x,1]*u[x,1];
    u[x,3]:=u[x,2]*u[x,1];
  end;
  initgraph(gd,gm,'d:\bp\bgi');
  SetColor(15);
  MoveTo(zdroj[1,1],zdroj[1,2]);
  for x:=1 to PocetCiar do begin
    pom[x,1]:=round(t[x,3]*zdroj[1,1]+3*t[x,2]*u[x,1]*zdroj[2,1]+3*t[x,1]*u[x,2]*zdroj[3,1]+u[x,3]*zdroj[4,1]);
    pom[x,2]:=round(t[x,3]*zdroj[1,2]+3*t[x,2]*u[x,1]*zdroj[2,2]+3*t[x,1]*u[x,2]*zdroj[3,2]+u[x,3]*zdroj[4,2]);
    LineTo(pom[x,1],pom[x,2]);
  end;
  readln;
END.}
