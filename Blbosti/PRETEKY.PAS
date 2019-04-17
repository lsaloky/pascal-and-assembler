program preteky;
uses Crt;
type ucastnik=record                       {charakteristika ucastnika}
     meno,priezvisko,krajina:string;
     cislo:byte;
     shod,smin,chod,cmin:byte;             {s - cas startu}
     ssec,csec:real;                       {c - cas ciela}
     end;
     subor=file of ucastnik;               {ucastnici v subore}
var sutaz:ucastnik;
    nadisk:subor;                          {ucastnici budu v subore na disku}
    pocet,x,y,volba,volba2:integer;
    c:char;
    s:string;
begin
textbackground(0);clrscr;
s:='c:\subory\sexta\lubo\data.dat';
assign (nadisk,s);
writeln('Program pre zimne olympijske hry.');
writeln('---------------------------------');
writeln('   Pomocou tohto programu mozes viest zaznamy o ucastnikoch ZOH, mozes');
writeln('si zoznam prezerat, editovat, zadavat startovacie casy a vypisat poradie');
writeln('ucastnikov.');
writeln('');
writeln('          Stlac akykolvek klaves');
repeat until keypressed;
window(10,10,49,17);textbackground(red);clrscr;
writeln('1 - zapis ucastnika');
writeln('2 - zrusenie ucastnika');
writeln('3 - vypis ucastnikov podla start. cisla');
writeln('4 - cas startu, cas ciela');
writeln('5 - vypis ucastnikov podla poradia');
writeln('6 - koniec prace');
c:=readkey;                                        {????????????}
c:=readkey;
volba:=ord(c)-48;
case volba of                                          {hlavny cyklus}
1:begin
  window(13,13,40,19);textbackground(green);clrscr;
  textcolor(red);
  writeln('   Zadavanie ucastnika');
  writeln('   -------------------');
  textcolor(white);
  writeln('1 - do existujuceho zoznamu');
  writeln('2 - novy zoznam');
  c:=readkey;
  volba2:=ord(c)-48;
  case volba2 of
  1:begin
    reset(nadisk);
    x:=filesize(nadisk);
    seek(nadisk,x);
    end;                                            {end of case 1.1}
  2:begin
    rewrite(nadisk);
    end;                                            {end of case 1.2}
  end;                                              {?????????0}
  end;                                              {end of case 1}
2:begin
  window(13,13,40,19);textbackground(green);clrscr;
  textcolor(red);
  writeln('    Zrusenie ucastnika');
  writeln('    ------------------');
  textcolor(white);
  writeln('Ktore startove cislo?');
  readln(x);
  end;                                              {end of case 2}
3:begin
  window(13,13,40,19);textbackground(green);clrscr;
  textcolor(red);
  writeln('  Prezeranie ucastnikov');
  writeln('  ---------------------');
  textcolor(white);
  for x:=1 to pocet do begin
    seek(nadisk,x);
    read(nadisk,sutaz);
    writeln('Meno',sutaz.meno);
    writeln('Priezvisko',sutaz.priezvisko);
    writeln('Krajina:',sutaz.krajina);
    writeln('startovacie cislo:',sutaz.cislo);
  end;                                              {end of for in case 3}
  end;                                              {end of case 3}
end;                                                {end of case total}
repeat until keypressed;
end.