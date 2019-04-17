program rucicky;
var hodiny,minuty:integer;
    uhol,uholm,uholh:real;
 begin
 writeln('Zadaj hodiny: ');
 readln(hodiny);
 writeln('Zadaj minuty: ');
 readln(minuty);
 if hodiny>=12 then hodiny:=hodiny-12;
 uholm:=minuty*6;
 uholh:=(hodiny*5)*6+(minuty div 12)*6;
 uhol:=abs(uholm-uholh);
 writeln('Vysledny uhol je ',uhol:3:0,' stupnov.');
 readln;

 end.