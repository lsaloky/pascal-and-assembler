program Pricitavanie_k_prvkom_pola;
var a:array[1..10] of integer;
    x:integer;
procedure Modifikuj;
begin
  for x:=1 to 10 do if x mod 2=0 then a[x]:=a[x]+x;
end;
BEGIN
  Randomize;
  for x:=1 to 10 do begin
    a[x]:=random(10);
    write(a[x],',');
  end;
  writeln;
  Modifikuj;
  for x:=1 to 10 do begin
    write(a[x],',');
  end;
  readln;
END.