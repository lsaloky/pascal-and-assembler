program Kolko_dni_je_do_konca_mesiaca;
var d,m,vysledok:word;
BEGIN
  writeln('Zadaj den a mesiac');
  readln(d,m);
  case m of
   2:vysledok:=28-d;
   4,6,9,11:vysledok:=30-d;
   else vysledok:=31-d;
  end;
  if vysledok>0 then begin
    write('Do konca mesiaca zostava');
    if (vysledok>1) and (vysledok<6) then write('ju');
    write(' ',vysledok,' d');
    if vysledok>1 then writeln('ni.')
     else writeln('en.');
  end
   else writeln('Je koniec mesiaca.');
  readln;
END.