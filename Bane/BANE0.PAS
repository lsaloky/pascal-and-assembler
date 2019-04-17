program Kozmicke_bane;
		{aaa}
uses Crt;
var x,PocetBani,PocetLudi,Peniaze,Tazba,Zasoby,CenaBane,CenaRudy,Rok,Koniec:longint;
    Spokojnost:real;
procedure Vypis;
begin
  GotoXY(11,2);write(PocetLudi);
  GotoXY(11,3);write(PocetBani);
  GotoXY(26,4);write(Tazba);
  GotoXY(17,5);write('     ');
  GotoXY(17,5);write(Zasoby);
  GotoXY(28,6);write(Spokojnost:0:2);
  GotoXY(23,7);write(CenaRudy);
  GotoXY(22,8);write(CenaBane);
  GotoXY(46,2);write('      ');
  GotoXY(46,2);write(Peniaze);
  GotoXY(1,10);
  DelLine;
end;

BEGIN
  Randomize;
  PocetBani:=Random(3)+5;
  PocetLudi:=Random(60)+40;
  Peniaze:=(Random(50)+10)*PocetLudi;
  Tazba:=Random(60)+80;
  Spokojnost:=1;
  Zasoby:=0;
  Koniec:=0;
  Rok:=1996;
  Clrscr;
  repeat
    ClrScr;
    CenaBane:=Random(2000)+2000;
    CenaRudy:=Random(12)+7;
    Zasoby:=Zasoby+PocetBani*Tazba;
    writeln('ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
    writeln('³Osada ma     robotnikov.      ³Tvoje konto:       ³');
    writeln('³Vlastnis    bani.             ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´');
    writeln('³Z kazdej bane sa vytazi     ton rudy.             ³');
    writeln('³Zasoba rudy je       ton.                         ³');
    writeln('³Koeficient spokojnosti je                         ³');
    writeln('³Cena za tonu rudy je          ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´');
    writeln('³Cena jednej bane je           ³ Pise sa rok ',Rok,'. ³');
    writeln('ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
    Vypis;
    writeln('Kolko rudy predas?');
    repeat
      readln(x);
    until (x>=0) and (x<=Zasoby);
    Zasoby:=Zasoby-x;
    Peniaze:=Peniaze+CenaRudy*x;
    Vypis;
    writeln('Kolko minies na platy?');
    repeat
      readln(x);
    until (x>=0) and (x<=Peniaze);
    Peniaze:=Peniaze-x;
    Spokojnost:=Spokojnost*sqrt(x/PocetLudi/100);
    if Spokojnost>2 then Spokojnost:=2;
    Vypis;
    writeln('Kolko bani kupis? Ak chces predat bane, daj zaporne cislo');
    repeat
      readln(x);
    until(x>=-PocetBani) and (CenaBane*x<=Peniaze);
    PocetBani:=PocetBani+x;
    Peniaze:=Peniaze-x*CenaBane;
    Vypis;
    if Spokojnost<0 then Koniec:=1;
    if Spokojnost>1.1 then PocetLudi:=PocetLudi+Random(10)+round(10*Spokojnost-10);
    if Spokojnost<0.9 then PocetLudi:=PocetLudi-Random(10);
    if PocetLudi div PocetBani<10 then Koniec:=2;
    if PocetLudi<=0 then Koniec:=3;
    if Random(100)=7 then begin
      writeln('Radioaktivne ziarenie zabilo polovicu ludi.'#13#10'Stlac Enter.');
      PocetLudi:=PocetLudi div 2;
    end;
    Tazba:=Random(round(60*Spokojnost))+80;
    Inc(Rok);
  until Rok>1997;
  ClrScr;
  writeln('Koniec hry.');
  case Koniec of
    0:writeln('Gratulujem, dokazal si uspesne prezit v tvrdej konkurencii.'#13#10'Teraz mozes ist na zasluzeny odpocinok.');
    1:writeln('Koeficient spokojnosti klesol pod nulu. Ludia sa vzburili.');
    2:writeln('Na jednu banu je menej ako 10 robotnikov. Ludia sa vzburili.');
    3:writeln('Uz nemas robotnikov.');
  end;
END.