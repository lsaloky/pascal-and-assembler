program Ekonomicka_statistika;
uses Crt;
type TStat=record
             Nazov:string[20];
             Mena:string[3];
             HDP,HDPUSD,HDPObyv,PObyv,ZObyv,RHDP1996,RHDP1997,I1996,I1997:real;
           end;
type TUsp=record
            Polozka:real;
            Nazov:string[20];
          end;
var Stat:Tstat;
    FStat:file of TStat;
    Usp:array[0..99] of TUsp;
    Pom:real;
    x,y,pos,PocStat:word;
    s:set of char;
    ch:char;
procedure VypisUdaje(des:word;s1,s2:string);
var Suma,Priemer:real;
begin
  ClrScr;
  Suma:=0;
  for pos:=0 to PocStat-1 do begin
    TextColor(7);write('St t: ');
    TextColor(14);write(Usp[pos].Nazov);
    GotoXY(26,WhereY);
    TextColor(7);write(s1);
    TextColor(14);write(Usp[pos].Polozka:0:des);
    Suma:=Suma+Usp[pos].Polozka;
    TextColor(7);writeln(s2);
    if pos mod 22=21 then begin
      writeln('Stlac Enter');
      readln;
      ClrScr;
    end;
  end;
  Priemer:=Suma/PocStat;
  TextColor(7);writeln('------------------------------------------------------------');
  if (ch='1') or (ch='3') then write('Spolu:')
                          else write('Priemer');
  GotoXY(26,WhereY);
  TextColor(7);write(s1);
  TextColor(14);
  if (ch='1') or (ch='3') then write(Suma:0:des)
                          else write(Priemer:0:des);
  TextColor(7);writeln(s2);
  writeln('Stlac Enter');
  readln;
end;
BEGIN
{ ----- inicializacia ----- }
  s:=['v','1','2','3','4','5','6','7','8','9'];
  Assign(FStat,'prog1997.dat');
  Reset(FStat);
  PocStat:=filesize(FStat);
{ ----- hlavny cyklus ----- }
  repeat
{ ----- vypis menu ----- }
    ClrScr;
    TextColor(LightBlue);
    writeln('       Vyber si spr vne p¡smeno');
    TextColor(LightGray);
    writeln('v - vypis vsetkych st tov'#13#10'1 - usporiadanie podla n rodn‚ho produktu'+
            #13#10'2 -              podla produktu na osobu'#13#10'3 -              podla '+
            'poctu obyvatelov'#13#10'4 -              podla zmeny poctu obyvatelov');
    writeln('5 -              podla rastu n rodn‚ho produktu v 1996'#13#10'6 -              '+
            'podla progn¢zy rastu NP v 1997'#13#10'7 -              podla infl cie v 1996'#13#10+
            '8 -              podla odhadu infl cie v 1997'#13#10'9 - koniec programu');
    writeln;
    TextColor(7);
    repeat
      ch:=ReadKey;
    until ch in s;
    Seek(FStat,0);
    Usp[0].Polozka:=-100000;
{ ----- citanie z datoveho suboru ----- }
    for x:=0 to PocStat-1 do begin
      Read(FStat,Stat);
      case ch of
        '1':Pom:=Stat.HDPUSD;
        '2':Pom:=Stat.HDPObyv;
        '3':Pom:=Stat.PObyv;
        '4':Pom:=Stat.ZObyv;
        '5':Pom:=Stat.RHDP1996;
        '6':Pom:=Stat.RHDP1997;
        '7':Pom:=Stat.I1996;
        '8':Pom:=Stat.I1997;
      end;
      pos:=0;
      while Usp[pos].Polozka>pom do Inc(pos);
      for y:=x downto pos do begin
        Usp[y+1].Polozka:=Usp[y].Polozka;
        Usp[y+1].Nazov:=Usp[y].Nazov;
      end;
      Usp[pos].Nazov:=Stat.Nazov;
      Usp[pos].Polozka:=Pom;
    end;
{ ----- jednotlive sluzby programu ----- }
    case ch of
      'v':begin
            for pos:=0 to PocStat-1 do begin
              Seek(FStat,pos);
              Read(FStat,Stat);
              TextColor(7); write('N zov st tu: ');
              TextColor(12);writeln(Stat.Nazov);
              TextColor(7); write('Hruby dom ci produkt: ');
              TextColor(12);write(Stat.HDP:0:2);
              TextColor(7); write(' mld. ',Stat.Mena,' = ');
              TextColor(12);write(Stat.HDPUSD:0:2);
              TextColor(7); write(' mld. USD.'#13#10'Na jedn‚ho obyvatela: ');
              TextColor(12);write(Stat.HDPObyv:0:0);
              TextColor(7); write(' USD.'#13#10'Pocet obyvatelov: ');
              TextColor(12);write(Stat.PObyv:0:2);
              TextColor(7); write(' mil., predpokladan  zmena ');
              TextColor(12);write(Stat.ZObyv:2:1);
              TextColor(7); write(' % obyvatelov.'#13#10'Rast HDP: 1996 ');
              TextColor(12);write(Stat.RHDP1996:0:1);
              TextColor(7); write(' %, 1997 ');
              TextColor(12);write(Stat.RHDP1997:0:1);
              TextColor(7); write(' %.'#13#10'Infl cia: 1996 ');
              TextColor(12);write(Stat.I1996:0:1);
              TextColor(7); write(' %, 1997 ');
              TextColor(12);write(Stat.I1997:0:1);
              TextColor(7); writeln(' %.');
              writeln('Stlac Enter');
              ReadLn;
            end;
          end;
       '1':VypisUdaje(2,' HDP: ',' mld. USD.');
       '2':VypisUdaje(0,' HDP na obyvatela: ',' USD.');
       '3':VypisUdaje(2,' Pocet obyvatelov: ',' mil.');
       '4':VypisUdaje(1,' Predpokladan  zmena poctu obyv. v r. 1997: ',' %.');
       '5':VypisUdaje(1,' Rast HDP v r. 1996: ',' %.');
       '6':VypisUdaje(1,' Rast HDP v r. 1997: ',' %.');
       '7':VypisUdaje(1,' Predpokladan  infl cia v r. 1996: ',' %.');
       '8':VypisUdaje(1,' Predpokladan  infl cia v r. 1997: ',' %.');
    end;
  until ch='9';
  Close(FStat);
END.
