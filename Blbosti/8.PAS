program Prvocisla;
var a:array[1..255] of word;
    x,y:word;
BEGIN
  for x:=1 to 255 do a[x]:=x;
  for x:=2 to 16 do begin
    for y:=x+1 to 255 do if y mod x=0 then a[y]:=0;
  end;
  a[1]:=0;
  for x:=1 to 255 do if a[x]>0 then write(a[x],' ');
  readln;
END.