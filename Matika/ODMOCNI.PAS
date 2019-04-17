program Vypocet_odmocniny;
var x,err:integer;
    r,v1,v2:real;
    s:string;
    presne:boolean;
begin
  writeln('Zadaj cislo');
  readln(s);
    {Vypocitam odhad - pocet cifier bude polovica zo zadaneho cisla}
  v1:=1;
  for x:=1 to length(s) do if x mod 2=0 then v1:=v1*10;
  if Length(s) mod 2=0 then v1:=v1/3;
    {Odmocnim prvu cislicu}
  Val(s[1],x,err);
  if (x>2) and (x<7) then v1:=v1*2;
  if x>6 then v1:=v1*3;
  writeln('1.odhad: ',v1:1:9);
    {Vypocet odmocniny metodou odhadov}
  Val(s,r,err);
  writeln('Malo by vyjst: ',sqrt(r):1:9);
  presne:=false;
  repeat
    v2:=(v2+r/v1)/2;
    writeln(v2:1:9);
    if Abs(v1-v2)<0.001 then presne:=true;
    v1:=v2;
  until presne;
  writeln('Dosiahnuta presnost 0.001, vysledok: ',v2:1:9);
  readln;
end.
