program telefonny_zoznam;
uses Crt;
type polozka=record
     meno:string;                {meno ucastnika}
     adresa:string;              {adresa ucastnika}
     telcislo:longint;           {telefonne cislo ucastnika}
     end;
var pocet,x,y,volba,pom1:integer;     {pomocne premenne}
    srchmeno,srchaddr:string;    {premenne pouzivane pri hladani}
    srchtelc:longint;
    zoznam:array[1..10]of polozka;  {telefonny zoznam}
begin
repeat
textbackground(0);clrscr;window(10,10,49,15);textbackground(4);clrscr;
writeln('1 - zadavanie ucastnikov');
writeln('2 - prezeranie zoznamu');
writeln('3 - hladanie');
writeln('4 - koniec');
readln(volba);
case volba of
1:begin                                               {zadavanie}
  window(12,12,60,20);textbackground(5);clrscr;
  write('Zadaj pocet ucastnikov:');readln(pocet);
  for x:=1 to pocet do
  begin
    writeln('--- Zadaj informacie o ',x,'. ucastnikovi. ---');
    write('Meno:');readln(zoznam[x].meno);
    write('Adresa:');readln(zoznam[x].adresa);
    write('Telefonne cislo:');readln(zoznam[x].telcislo);
  end;
  end;
2:begin
  window(14,7,55,25);textbackground(5);clrscr;      {prezeranie}
  for x:=1 to pocet do
  begin
    writeln(' --- ',x,'. ucastnik ---');
    writeln('Meno:',zoznam[x].meno);
    writeln('Adresa:',zoznam[x].adresa);
    writeln('Telefonne cislo:',zoznam[x].telcislo);
    end;
  repeat until keypressed;
  end;
3:begin
  window(14,14,69,22);textbackground(5);clrscr;       {hladanie}
  writeln('Hladanie:1 - podla mena');
  writeln('         2 - podla adresy');
  writeln('         3 - podla telefonneho cisla');
  readln(y);
  pom1:=0;
  case y of
  1:begin
      writeln('Zadaj meno');readln(srchmeno);
      for x:=1 to pocet do
      if srchmeno=zoznam[x].meno then begin
        writeln(zoznam[x].adresa,' , ',zoznam[x].telcislo);
        pom1:=1;
      end;
    end;
  2:begin
      writeln('Zadaj adresu');readln(srchaddr);
      for x:=1 to pocet do
      if srchaddr=zoznam[x].adresa then begin
        writeln(zoznam[x].meno,' , ',zoznam[x].telcislo);
        pom1:=1;
      end;
    end;
  3:begin
      writeln('Zadaj telefonne cislo');readln(srchtelc);
      for x:=1 to pocet do
      if srchtelc=zoznam[x].telcislo then begin
        writeln(zoznam[x].meno,' , ',zoznam[x].adresa);
        pom1:=1;
      end;
    end;
  end;
  if pom1=0 then writeln('Takeho som nenasiel');
  writeln('Stlac klaves');
  repeat until keypressed;
  end;
end;
until volba=4;
end.