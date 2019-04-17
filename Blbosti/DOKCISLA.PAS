program Hladanie_dokonalych_cisel;
const n=100;
var x,y,sucet:word;
BEGIN
  writeln;
  for x:=1 to n do begin
    sucet:=0;
    for y:=1 to x-1 do if x mod y=0 then sucet:=sucet+y;
    if sucet=x then writeln(x);
  end;
END.