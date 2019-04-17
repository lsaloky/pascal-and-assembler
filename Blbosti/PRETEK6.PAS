program preteky;
uses Crt;
type ucastnik=record                       {charakteristika ucastnika}
     meno,priezvisko,krajina:string;
     cislo:byte;
     shod,chod:0..23;
     smin,cmin:0..59;                {s - cas startu}
     ssec,csec,sec:real;                   {c - cas ciela, bez pismena = celkovy cas}
     end;
     subor=file of ucastnik;               {ucastnici v subore}
var sutaz:ucastnik;
    nadisk:subor;                          {ucastnici budu v subore na disku}
    pocet,x,y,z,a,d,pom2,pom3,volba,volba2,cis,pom4:integer;
    pom1,sekundy:real;
    c:char;
    s:string;
begin
  textbackground(0);clrscr;
  s:='c:data.dat';
  textattr:=white+16*black+blink;
  writeln('Program pre zimne olympijske hry.');
  textattr:=white+16*black;
  writeln('---------------------------------');
  writeln('   Pomocou tohto programu mozes viest zaznamy o ucastnikoch ZOH, mozes');
  writeln('si zoznam prezerat, editovat, zadavat startovacie casy a vypisat poradie');
  writeln('ucastnikov.');
  writeln('');
  writeln('          Stlac akykolvek klaves');
  repeat until keypressed;
  c:=readkey;
  window(15,14,43,18);textbackground(yellow);clrscr;
  writeln('Zapis ucastnikov:');
  writeln('');
  writeln(' 1 - do existujuceho zoznamu');
  writeln(' 2 - novy zoznam');
  c:=readkey;
  volba2:=ord(c)-48;
  case volba2 of
    1:begin
      assign(nadisk,s);
      reset(nadisk);
      x:=filesize(nadisk);
      pocet:=x;
      seek(nadisk,x);
      end;                                            {end of case 1.1}
    2:begin
      assign(nadisk,s);
      rewrite(nadisk);
      pocet:=0;
      end;                                            {end of case 1.2}
    end;
    window(15,14,43,18);textbackground(black);clrscr;
  repeat
    window(10,10,49,17);textbackground(red);clrscr;
    writeln('1 - okienko sponzora');
    writeln('2 - zapis ucastnika');
    writeln('3 - zrusenie ucastnika');
    writeln('4 - vypis ucastnikov podla start. cisla');
    writeln('5 - cas startu, cas ciela');
    writeln('6 - vypis ucastnikov podla poradia');
    writeln('7 - koniec prace');
    c:=readkey;
    volba:=ord(c)-48;
    case volba of                                          {hlavny cyklus}
      2:begin
        window(13,13,40,19);textbackground(green);clrscr;
        textcolor(red);
        writeln('   Zadavanie ucastnika');
        writeln('   -------------------');
        textcolor(white);
        write('Meno:');readln(sutaz.meno);
        write('Priezvisko:');readln(sutaz.priezvisko);
        write('Krajina:');readln(sutaz.krajina);
        pocet:=pocet+1;
        sutaz.cislo:=pocet;
        sutaz.sec:=0;
        write(nadisk,sutaz);
        window(13,13,40,19);textbackground(black);clrscr;
        end;                                              {end of case 2}
      3:begin
        window(13,13,41,19);textbackground(green);clrscr;
        textcolor(red);
        writeln('    Zrusenie ucastnika');
        writeln('    ------------------');
        textcolor(white);
        writeln('Ktore startove cislo?');
        readln(x);
        if x<=filesize(nadisk) then
        begin
          seek(nadisk,x-1);
          read(nadisk,sutaz);
          sutaz.meno:='delucast';
          sutaz.sec:=0;
          seek(nadisk,x-1);
          write(nadisk,sutaz);
        end                                             {end of then in if in case 3}
        else
        begin
          writeln('Taky sutaziaci neexistuje');
          c:=readkey;
        end;                                            {end of else in if in case 3}
        window(13,13,41,19);textbackground(black);clrscr;
      end;                                              {end of case 3}
    4:begin
      window(3,8,77,11);textbackground(green);clrscr;
      textcolor(red);
      writeln('                    Prezeranie ucastnikov');
      writeln('-----------------------------------------------------------');
      textcolor(white);
      window(3,11,77,22);clrscr;
      writeln('');
      d:=0;
      for x:=0 to pocet-1 do
      begin
        seek(nadisk,x);
        read(nadisk,sutaz);
        if sutaz.meno<>'delucast' then
        begin
          d:=d+1;
          gotoxy(1,d);
          writeln('Meno:',sutaz.meno);
          gotoxy(15,d);
          writeln('Priezvisko:',sutaz.priezvisko);
          gotoxy(36,d);
          writeln('Krajina:',sutaz.krajina);
          gotoxy(56,d);
          writeln('Startovacie cislo:',sutaz.cislo);
        end;                                          {endif of case 4}
      end;                                            {end of for in case 4}
      c:=readkey;
      window(3,8,77,22);textbackground(black);clrscr;
    end;                                              {end of case 4}
  5:begin
    window(15,11,69,23);textbackground(magenta);clrscr;
    writeln('Zadavanie casov startu a ciela');
    writeln('------------------------------');
    write('Startovne cislo sutaziaceho:');
    readln(cis);
    if cis>filesize(nadisk) then
    begin
      writeln('Taky sutaziaci neexistuje');
      c:=readkey;
    end                                              {end of then in if in case 5}
    else
    begin
      writeln('');
      seek(nadisk,cis-1);
      read(nadisk,sutaz);
      if (sutaz.sec=0) and (sutaz.meno<>'delucast') then
      begin
        writeln('Zadavanie casu pre sutaziaceho:',sutaz.meno,' ',sutaz.priezvisko);
        writeln('');
        write('Cas startu - hodiny: ');readln(sutaz.shod);
        write('             minuty: ');readln(sutaz.smin);
        write('             sekundy:');readln(sutaz.ssec);
        writeln('');
        write('Cas ciela  - hodiny: ');readln(sutaz.chod);
        write('             minuty: ');readln(sutaz.cmin);
        write('             sekundy:');readln(sutaz.csec);
        sutaz.sec:=(sutaz.chod-sutaz.shod)*3600+(sutaz.cmin-sutaz.smin)*60+sutaz.csec-sutaz.ssec;
        seek(nadisk,cis-1);
        write(nadisk,sutaz);
      end                                               {end of then in if in else in if in case 5}
      else
      begin
        write('Casy nemozu byt zadane,pretoze ');
         if sutaz.meno='delucast' then writeln('ucastnik bol zruseny');
        if sutaz.sec<>0 then writeln('uz si ich zadal.');
        c:=readkey;
      end;                                              {end of else in if in else in if in case 5}
      end;                                              {end of else in if in case 5}
      window(15,11,69,23);textbackground(black);clrscr;
    end;                                              {end of case 5}
  6:begin
    window(16,11,56,20);textbackground(Cyan);clrscr;
    writeln('Vypis ucastnikov podla dosiahnuteho casu');
    writeln('----------------------------------------');
    pom2:=filesize(nadisk)-1;
    pom1:=0;
    pom4:=0;
    for y:=0 to pom2 do
    begin
      for z:=0 to pom2 do
      begin
        seek(nadisk,z);
        read(nadisk,sutaz);
        if (sutaz.sec>pom1) and (sutaz.meno<>'delucast') and (sutaz.shod<>25) then
        begin
          pom3:=z;
          pom4:=1;
        end;                                          {endif in case 6}
      end;                                            {end of for in case 6}
      if pom4=1 then
        begin
        seek(nadisk,pom3);
        read(nadisk,sutaz);
        write(sutaz.meno,':');
        cis:=trunc(sutaz.sec/60);
        sekundy:=sutaz.sec-cis*60;
        writeln(cis,' minut ',sekundy:2:2,' sekund');
        pom1:=sutaz.sec;
        end;                                          {endif in case 6}
      pom4:=0;
      end;                                            {end of second for in case 6}
    repeat until keypressed;
    window(16,11,56,20);textbackground(Black);clrscr;
    end;                                              {end of case 6}
  end;                                                {end of case total}
  until volba=7;
end.