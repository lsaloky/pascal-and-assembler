program Vypis_vsetko_vacsie_od_predchadzajuceho;
var a:array[1..100] of word;
    x,y,max:word;
BEGIN
  x:=1;max:=0;
  writeln('Zadavaj cleny postupnosti');
  readln(max);
  repeat
    readln(y);
    if y>max then begin
      max:=y;
      a[x]:=y;
      Inc(x);
    end;
  until y=0;
  writeln;
  for y:=1 to x-1 do write(a[y],',');
  readln;
END.

