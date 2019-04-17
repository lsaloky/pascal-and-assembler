program ROBOT;
const maxn=100;
type tb=record
          x,y:integer;
          end;
var vstup,vystup:text;
    bod:array [1..maxn] of tb;
    p,x,y,i:integer;
    f:boolean;

procedure QuickSort(l,r:integer);
var i,j,x:integer;
    w:tb;
begin
  i:=l;
  j:=r;
  x:=bod[(i+j) div 2].y;
  repeat
    while bod[i].y<x do Inc(i);
    while bod[j].y>x do Dec(j);
    if i<=j then begin
      w:=bod[i];
      bod[i]:=bod[j];
      bod[j]:=w;
      Inc(i);
      Dec(j);
      end;
  until i>j;
  if l<j then QuickSort(l,j);
  if r>i then QuickSort(i,r);
  end;

function Smernica(i1,i2:integer):real;
var dx,dy:integer;
begin
  dx:=bod[i1].x-bod[i2].x;
  dy:=bod[i2].y-bod[i1].y;
  if dy=0 then Smernica:=32766*dx/Abs(dx)
          else Smernica:=dx/dy;
  end;

function ZistiKonvexnost(n:integer):boolean;
var x1,plb,ppb,i:integer;
    plsm,ppsm:real;
    f:boolean;
begin
  f:=true;
  if n>1 then begin
    QuickSort(1,n);
    x1:=bod[1].x;
    plsm:=32767;
    plb:=1;
    ppsm:=-32767;
    ppb:=1;
    i:=2;
    repeat
      if bod[i].x<=x1 then
        if Smernica(plb,i)<plsm then begin
          plsm:=Smernica(plb,i);
          plb:=i;
          end
                                else f:=false
                      else
        if Smernica(ppb,i)>ppsm then begin
          ppsm:=Smernica(ppb,i);
          ppb:=i;
          end
                                else f:=false;
      Inc(i);
    until (i>n) or not f;
    end;
  ZistiKonvexnost:=f;
  end;

begin
  Assign(vstup,'D:\TP\OKTAVA\ROBOT.IN');
  Reset(vstup);
  Assign(vystup,'D:\TP\OKTAVA\ROBOT.OUT');
  Rewrite(vystup);
  repeat
    p:=0;
    ReadLn(vstup,x,y);
    while (x<>0) or (y<>0) do begin
      i:=1;
      while (i<=p) and ((bod[i].x<>x) or (bod[i].y<>y)) do Inc(i);
      if i>p then begin
        Inc(p);
        bod[p].x:=x;
        bod[p].y:=y;
        end;
      ReadLn(vstup,x,y);
      end;
    if p>0 then begin
      f:=ZistiKonvexnost(p);
      if f then WriteLn(vystup,'ANO')
           else WriteLn(vystup,'NIE');
      end;
  until p=0;
  Close(vstup);
  Close(vystup);
end.
