program Tri_prasiatka;
uses Crt,Dos;
const MaxIndex=420;
      pocetpokusov=65535;
var minuty:array[1..MaxIndex] of longint;
    p:array[1..3] of byte;                 {prasiatka}
    x,pocet:longint;                     {pomocn‚ premenn‚}
    y:byte;
    sucet:longint;
    priemer:real;
    ch:char;
    hod,min,sec,stot:word;
    time:real;

procedure Rozpis;
begin
  ClrScr;
  writeln('Rozpis: 1      3      5      7      9      11     13     15     17     19  ');
  writeln('---------------------------------------------------------------------------');
  for x:=3 to 23 do writeln(20*(x-3));
  for y:= 0 to 20 do begin
    for x:=1 to 20 do begin
      if y*20+x<MaxIndex then begin
        gotoxy(7*x div 2+7,y+3);
        writeln(minuty[y*20+x]);
      end;
      Inc(x);
    end;
  end;
end;

BEGIN
  ClrScr;
  for x:=1 to MaxIndex do minuty[x]:=0;
  sucet:=0;
  Randomize;
  GetTime(hod,min,sec,stot);
  time:=hod*3600+min*60+sec+stot/100;
  for x:=1 to pocetpokusov do begin
    pocet:=0;p[1]:=0;p[2]:=0;p[3]:=0;
    repeat
      y:=random(3)+1;                      {aktu lne prasiatko}
      p[y]:=p[y] xor 1;
      Inc(pocet);
    until p[1]+p[2]+p[3]=3;
    if pocet<MaxIndex then Inc(minuty[pocet])
    else begin
      writeln('Fatal Error!!! Program terminated.');
      Exit;
    end;
  end;
  for x:=1 to MaxIndex do sucet:=sucet+minuty[x]*x;
  priemer:=sucet/pocetpokusov;
  GetTime(hod,min,sec,stot);
  time:=hod*3600+min*60+sec+stot/100-time;
  writeln('Statistick‚ £daje:');
  writeln('Pocet pokusov: ',pocetpokusov);
  writeln('Prasat  pobehovali ',sucet,' minut');
  writeln('Priemerny cas:',priemer:1:2,' minuty');
  writeln('Cas vypoctu: ',time:0:2,' sekund.');
  writeln('--------------------------------------------');
  writeln('Chces rozpis poctu pokusov za jednotliv‚ min£ty? a/n');
  readln(ch);
  if (ch='a') or (ch='A') then Rozpis;
  gotoxy(1,24);
  write('Koniec programu.');
  readln;
END.