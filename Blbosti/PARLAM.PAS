{priklad cislo 28}
program Parlament;
uses Crt;
var a,b,c:array[0..11,0..11] of real;{0,1 je nazor, 0.5 nazor neposkodi}
    c1,c2:integer;
    priemer,suma:real;
    s,t:string;
    rozne:boolean;
procedure Vypis;
begin
  GotoXY(1,3);
  writeln('         Koalicia');
  writeln('        ----------');
  for c1:=1 to 10 do begin
    if c1=1 then write('Lavica |')
            else write('       |');
    for c2:=1 to 10 do write(a[c1,c2]:0:0);
    if c1=1 then writeln(' |Pravica')
            else writeln(' |');
  end;
  writeln('        ----------');
  writeln('         Opozicia');
end;
label 1;
BEGIN
  Randomize;
  ClrScr;
  writeln('Simulator parlamentu. Aky zakon sa bude prerokuvat?');
  readln(t);
  for c1:=0 to 11 do
    for c2:=0 to 11 do begin
      b[c1,c2]:=0.5;
      a[c1,c2]:=0.5;
    end;
1:for c1:=1 to 10 do
    for c2:=1 to 10 do
      a[c1,c2]:=Random(2);
  repeat
    for c1:=1 to 10 do
      for c2:=1 to 10 do begin
        priemer:=(a[c1-1,c2]+a[c1+1,c2]+a[c1,c2-1]+a[c1,c2+1])/4;
        if priemer=0.5 then b[c1,c2]:=random(2);{hlasuje nahodne}
        if priemer>0.5 then b[c1,c2]:=1;       {pripoji sa}
        if priemer<0.5 then b[c1,c2]:=0;
        if (priemer>1) or (priemer<0) then writeln('Chyba algoritmu!!!');{pozor}
      end;
    move(a,c,SizeOf(b));
    move(b,a,SizeOf(b));
    Vypis;
    suma:=0;
    for c1:=1 to 10 do
      for c2:=1 to 10 do
        suma:=suma+a[c1,c2];
    readln(s);
  until (s='stop') or (suma=0) or (suma=100);
  if suma=0 then writeln(t,' nebol schvaleny.');
  if suma=100 then writeln(t,' bol schvaleny.');
  if (suma>0) and (suma<100) then begin
    writeln('Chces to prerokovat na dalsej schodzi?');
    readln(s);
    GotoXY(1,WhereY-3);
    DelLine;
    DelLine;
    DelLine;
    if s='ano' then goto 1;
  end;
END.