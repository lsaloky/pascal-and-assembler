program Testovanie_ci_je_platna_velka_Fermatova_veta;
{zly algoritmus, neprehladava vsetky moznosti. 20 sekund}
const pm=1000; {pocet mocnin,moze byt az po 4096}
var m:array[1..pm+1]of comp;  {tuna su tretie mocniny}
    x,suc:comp;
    c1,c2,vacsie,mensie,index:word;
BEGIN
  for c1:=1 to 24 do writeln;
  x:=1;c1:=1;
  repeat
    m[c1]:=x*x*x;
    x:=x+1;
    c1:=c1+1;
  until x>pm;
  m[7]:=125+216;
  m[pm+1]:=9.2E18;
  for c1:=1 to pm do             {5000}
    for c2:=c1 to pm do begin    {12.500.000}
      suc:=m[c1]+m[c2];          {12.500.000 krat sa opakuje prikaz}
      if c1>c2 then begin        {12.500.000}
        vacsie:=c1;mensie:=c2;   {12.500.000}
      end else begin
        vacsie:=c2;mensie:=c1;
      end;
      index:=pm-vacsie;          {12.500.000}
      repeat
        index:=index shr 1;
        if m[vacsie]=suc then writeln('a^3+b^3=c^3 pre ',c1,',',c2,',',vacsie+index);
        if m[vacsie]>suc then vacsie:=vacsie-index else vacsie:=vacsie+index;
      until index<1;
    end;
END.