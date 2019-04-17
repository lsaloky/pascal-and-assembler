program Riadok_Pascalovho_trojuholnika_s_minimalnymi_pamatovymi_narokmi;
const Stupen=10;
var KC:array[0..Stupen] of word;
    n,x,y,pom,pom2:word;
BEGIN
  KC[0]:=1;
  n:=7;
  for x:=1 to n do begin
    pom:=0;
    for y:=0 to x do begin
      pom2:=KC[y];
      if y>0 then KC[y]:=KC[y]+pom;
      pom:=pom2;
    end;
  end;
END.
