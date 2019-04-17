program vypocet_kludovej_energie;
uses Crt;
var m:real;
begin;
      clrscr;
      writeln('Zadaj hodnotu hmotnosti {v kg},maximalne 25 cifier.');
      readln(m);
      writeln('Kludova energia je',m*300000*300000:40:2,'joulov.');
      readln;
end.
