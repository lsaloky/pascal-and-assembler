program Vypis_vsetkych_kombinacii_Ktej_triedy_z_N_prvkov;
const n=6;k=3;
var x,y,z:integer;
    a:array[1..k] of byte;
begin
{ ----- algoritmus s n vnorenymi cyklami ----- }
  writeln;
  for x:=1 to n-2 do begin
    for y:=x+1 to n-1 do
      for z:=y+1 to n do write(x,' ',y,' ',z,'³');
    writeln;
  end;
{ ----- algoritmus pomocou pola ----- }
  writeln;
  for x:=1 to k do a[x]:=x;
  while a[1]<n-k+1 do begin
    for x:=1 to k do write(a[x],' ');
    write('³');
    if a[k]<n then Inc(a[k])
    else begin
      z:=k;
      while a[z]>=n-k+z do Dec(z);
      Inc(a[z]);
      for y:=z+1 to k do a[y]:=a[z]+y-z;
      writeln;
    end;
  end;
  for x:=1 to k do write(a[x],' ');
  write('³');
  writeln;
  readln;
end.