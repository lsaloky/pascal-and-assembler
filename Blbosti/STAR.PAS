program Star_LC_20;
uses Crt,Okno,Printer;
var s:string;
    x:integer;
    ch:char;
procedure Font;
begin
  OknoCiste(7,7,57,10);
  writeln(' Draft pismo');
  writeln(' listove pismo - Courier');
  writeln(' listove pismo - Sanserif');
  writeln(' listove pismo - orator s Malymi pismenami');
  writeln(' listove pismo - orator so Zrezanymi pismenami');
  writeln(' Kurziva');
  writeln(' Preskrtavaj nulu');
  ch:=readkey;
end;
procedure Velkost_pisma;
begin
  OknoCiste(7,7,37,7);
  writeln(' Pocet znakov na palec');
  writeln(' dvojita Vyska');
  writeln(' dvojita Sirka');
  writeln(' Riadkovanie (v palcoch)');
  ch:=readkey;
end;
procedure Posun_papiera;
begin
  OknoCiste(10,8,47,9);
  writeln(' posun papiera Dopredu o 1 riadok');
  writeln(' posun papiera dOzadu o 1 riadok');
  writeln(' Mikroposun dopredu');
  writeln(' mIkroposun dozadu');
  writeln(' Posun o zadany pocet riadkov dopredu');
  writeln(' posun Na zaciatok strany');
  ch:=readkey;
end;
procedure Vzhlad_strany;
begin
  OknoCiste(13,9,57,7);
  writeln(' Nastavenie zaciatku strany na sucasnu poziciu');
  writeln(' Dlzka strany v riadkoch');
  writeln(' nastavenie Laveho okraja');
  writeln(' nastavenie Praveho okraja');
  ch:=readkey;
end;
procedure Dalsie_moznosti;
begin
  OknoCiste(22,9,47,8);
  writeln(' Najvyssi bit');
  writeln(' Ticha tlac');
  writeln(' Pipnutie');
  writeln(' Obojsmerne pisanie');
  writeln(' Reinicializacia tlaciarne');
  ch:=readkey;
end;
BEGIN
repeat
  textbackground(0);ClrScr;
  write('  Program pre tlaciaren ');
  TextAttr:=red+128;
  write(' STAR LC 20');
  textattr:=(white+16*magenta);
  OknoCiste(5,3,28,18);
  KurzorOff;
  writeln(' Font                 ...');
  writeln(' Velkost pisma        ...');
  writeln(' poSun papiera        ...');
  writeln(' vzhlAd strany        ...');
  writeln(' dalsie Moznosti      ...');
  writeln(' zarovnavanie zLava');
  writeln(' zarovnavanie sPrava');
  writeln(' Centrovanie');
  writeln(' Zvyraznenie');
  writeln(' pOdciarkovanie');
  writeln(' precIarkovanie');
  writeln(' Horny index');
  writeln(' Dolny index');
  writeln(' pRoporcionalne pismo');
  writeln(' Koniec');
  ch:=readkey;
  textbackground(blue);
  case ch of
  'f':font;
  'v':velkost_pisma;
  's':posun_papiera;
  'a':vzhlad_strany;
  'm':dalsie_moznosti;
  'l':begin
      end;
  'p':begin
      end;
  'c':begin
      end;
  'z':begin
      end;
  'o':begin
      end;
  'i':begin
      end;
  'h':begin
      end;
  'd':begin
      end;
  'r':begin
      end;
  end;
until ch='k';
end.





