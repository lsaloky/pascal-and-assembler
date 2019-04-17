program Nevypocitatelna_limita;
uses Crt;
var moc,a,uhol:extended;
BEGIN
  writeln;
  a:=1;moc:=2;uhol:=1;
  repeat
    a:=a+cos(uhol)/moc;
    moc:=moc*2;
    uhol:=uhol+1;
    writeln(a);
    ReadKey;
  until 2=3;
END.
{             cos 1     cos 2           cos n
   lim ( 1 + ÄÄÄÄÄÄÄ + ÄÄÄÄÄÄÄ + ... + ÄÄÄÄÄÄÄ ) = 1.02839399521894
   nì          2         4               2ü                       }
