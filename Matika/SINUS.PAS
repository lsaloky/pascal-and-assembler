Program Sinus; {interpolacny mnohoclen funguje len na intervale <0;pi/2>}
var uhol,vysledok:real;
begin
  writeln('Zadaj uhol v radianoch');
  readln(uhol);
  if uhol>2*pi then uhol:=uhol-Int(uhol/2/pi)*2*pi;
  if uhol>pi then begin
    vysledok:=-1;
    uhol:=uhol-pi;
  end
  else vysledok:=1;
  if uhol>pi/2 then uhol:=pi-uhol;
  vysledok:=vysledok*uhol*(0.02880*uhol*uhol*uhol-0.20434*uhol*uhol+0.02137*uhol+0.99562);
  writeln('Vypocital interpolacny mnohoclen:',vysledok:1:5);
  writeln('Spravna hodnota:',sin(uhol):1:5);
  readln;
end.