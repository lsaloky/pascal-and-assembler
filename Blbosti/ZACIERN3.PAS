program Zacierni;
uses Graph;
const gd:integer=9;
      gm:integer=2;
      cesta='d:\bp\bgi';
      sm=20;     {strana matice, musi byt delitelom 640 aj 480}
var a:array[1..sm*sm] of word;
    x,y,r1,r2,pom:integer;
BEGIN
  Randomize;
  InitGraph(gd,gm,cesta);
  SetFillStyle(1,7);
  Bar(0,0,639,479);
  for x:=1 to sm*sm do a[x]:=x;
  for x:=1 to sm*sm do begin
    r1:=random(sm*sm)+1;
    r2:=random(sm*sm)+1;
    pom:=a[r1];
    a[r1]:=a[r2];
    a[r2]:=pom;
  end;
  for pom:=1 to sm*sm do
    for y:=0 to (480 div sm)-1 do
      for x:=0 to (640 div sm)-1 do
        PutPixel(sm*x+a[pom] div sm,sm*y+a[pom]mod sm,0);
  readln;
END.

