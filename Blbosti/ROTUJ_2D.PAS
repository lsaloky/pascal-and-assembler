program Rotacia_stvorca;
uses Graph;
const sx=320;
      sy=240;     {suradnice stredu otacania}
      gd:integer=9;
      gm:integer=2;
      cesta='d:\bp\bgi';
      a:array[1..4,1..2]of longint=((200,100),(300,100),(300,200),(200,200));
var r,fi:array[1..4] of real;
    x,y,z:integer;
procedure Nakresli;
begin
  MoveTo(a[1,1],a[1,2]);
  LineTo(a[2,1],a[2,2]);
  LineTo(a[3,1],a[3,2]);
  LineTo(a[4,1],a[4,2]);
  LineTo(a[1,1],a[1,2]);
end;
BEGIN
  InitGraph(gd,gm,cesta);
  for x:=1 to 4 do begin
    r[x]:=Sqrt((sx-a[x,1])*(sx-a[x,1])+(sy-a[x,2])*(sy-a[x,2]));
    fi[x]:=ArcTan((sy-a[x,2])/(sx-a[x,1]));
  end;
  for z:=1 to 15 do begin
    SetColor(z);
    for y:=1 to 63 do begin
      for x:=1 to 4 do begin
        fi[x]:=fi[x]+0.1;
        a[x,1]:=round(sx-r[x]*sin(fi[x]));
        a[x,2]:=round(sy-r[x]*cos(fi[x]));
      end;
      Nakresli;
    end;
    for x:=1 to 4 do r[x]:=r[x]+10;
  end;
  readln;
  CloseGraph;
  writeln('MukoSoft Rotuj'#13#10'Lubos Saloky, 1996');
END.