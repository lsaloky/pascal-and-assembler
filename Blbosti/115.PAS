program Priklad_115;
var x,y,pocet:integer;
    a:array[1..101] of integer;
BEGIN
  writeln;
  x:=1;
  a[1]:=1;
  write(x,',');
  for y:=2 to 101 do a[y]:=0;
  for pocet:=1 to 100 do begin
    repeat
      y:=1;
      while (x<>2*a[y]+1) and (x<>3*a[y]+1) and (y<101) do Inc(y);
      if a[y]<>0 then begin
        write(x,',');
        a[pocet+1]:=x;
      end;
      Inc(x);
    until a[y]<>0;
  end;
END.