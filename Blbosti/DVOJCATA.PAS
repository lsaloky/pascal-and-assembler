{priklad cislo 20}
program PrvociselneDvojcata;
var x,y,n:word;
    JePrv,BoloPrv:boolean;
BEGIN
  writeln('Program na hladanie prvociselnych dvojciat. Zadaj, do ktoreho cisla sa ma hladat');
  readln(n);
  x:=3;BoloPrv:=false;
  while x<n do begin
    JePrv:=true;
    for y:=2 to Round(Sqrt(x)) do if x mod y=0 then JePrv:=false;
    if BoloPrv and JePrv then writeln(x-2,',',x);
    BoloPrv:=JePrv;
    x:=x+2;
  end;
  readln;
END.