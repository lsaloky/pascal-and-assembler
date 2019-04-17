program N_intervalov;{priklad cislo 12}
var n,x:integer;
    d,h,dp,hp:real;
    prazdny:boolean;
BEGIN
  writeln('Zadaj pocet intervalov');
  readln(n);
  dp:=-3E+10;hp:=3E+10;x:=0;prazdny:=false;
  repeat
    write('Zadaj dolnu hranicu ',x,'. intervalu:');
    readln(d);
    write('Zadaj hornu hranicu ',x,'. intervalu:');
    readln(h);
    if (d>hp) or (h<dp) then prazdny:=true;{disjunktne}
    if (d>dp) and (d<hp) then dp:=d;{zvys dolnu hranicu}
    if (h>dp) and (h<hp) then hp:=h;{zniz hornu hrnicu}
    Inc(x);
  until (x=n) or (prazdny);
  if prazdny then writeln('Nemaju spolocny bod')
             else writeln('Spolocne body tvoria interval ',dp:0:3,',',hp:0:3);
  readln;
END.