program damy;
uses Crt;
const dx=19;
      dy=19;
var a:array[-1..dx+2,-1..dy+2] of byte;   {pozor}
    x,y:integer;
    s:string;
    pomx,pomy:integer;
procedure NahodDamu;
var c,d,e,f:integer;
begin
  if dx<dy then e:=dx
           else e:=dy;
  for d:=1 to dx do a[d,y]:=2;                 {smer Ä}
  for d:=1 to dy do a[x,d]:=2;                 {smer ³}
  c:=x-y+1;                                    {smer \}
  f:=e+x-y;                                             {0 2 0 2 0 2 0 0}
  if f>dx then f:=dx;                                   {0 0 2 2 2 0 0 0}
  if c<1 then c:=1;                                     {2 2 2 1 2 2 2 2}
  for d:=c to f do a[d,d-x+y]:=2;                       {0 0 2 2 2 0 0 0}
  c:=x-e+y;                                    {smer /} {0 2 0 2 0 2 0 0}
  f:=x+y-1;                                             {2 0 0 2 0 0 2 0}
  if f>dx then f:=dx;                                   {0 0 0 2 0 0 0 2}
  if c<1 then c:=1;                        {1 - dama, 2 - kontroluje policko}
  for d:=c to f do a[d,x-d+y]:=2;
  if (x>2) and (y>1) then a[x-2,y-1]:=2;         {kone}
  if (x>1) and (y>2) then a[x-1,y-2]:=2;
  if (x<dx) and (y>2) then a[x+1,y-2]:=2;
  if (x<dx-1) and (y>1) then a[x+2,y-1]:=2;
  if (x<dx-1) and (y<dy) then a[x+2,y+1]:=2;
  if (x<dx) and (y<dy-1) then a[x+1,y+2]:=2;
  if (x>1) and (y<dy-1) then a[x-1,y+2]:=2;
  if (x>2) and (y<dy) then a[x-2,y+1]:=2;
  a[x,y]:=1;
end;

begin
  ClrScr;
  x:=1;y:=1;NahodDamu;
  while (x<dx) and (y<dy+1) do begin
    Inc(x);
    if a[x,y]=0 then NahodDamu;
    if x=dx then begin
      x:=1;Inc(y);
    end;
  end;
  for y:=1 to dy do begin
    for x:=1 to dx do begin
      if a[x,y]=0 then write('. ');
      if a[x,y]=1 then write('Û ');
      if a[x,y]=2 then write('+ ');
    end;
    writeln;
  end;
  readln(s);
end.