program tovary;
uses crt;
var tovar:array[1..12] of string;
    cena,kusy:array[1..12] of integer;
    x,money,info,quit,y:integer;
    pomstr:string;
begin
tovar[1]:='mlieko';tovar[2]:='chlieb';tovar[3]:='maslo';tovar[4]:='sampon';
tovar[5]:='kalkulacky';tovar[6]:='mys';tovar[7]:='zosit';tovar[8]:='knihy';
tovar[9]:='pero';tovar[10]:='vykresy';tovar[11]:='tchory';tovar[12]:='psy';
for x:=1 to 12 do
begin
  kusy[x]:=random(5)+1;
  cena[x]:=random(20)+1;
end;
x:=0;money:=100;info:=0;
textbackground(0);clrscr;
repeat
  textbackground(0);clrscr;
  window(10,5,30,11);textbackground(5);textcolor(3);clrscr;
  writeln('1 - nakup');
  writeln('2 - predaj');
  writeln('3 - prehlad');
  writeln('4 - editovanie');
  writeln('5 - koniec');
  repeat;readln(quit);until quit<6;
  case quit of
  1:begin                                                {----- nakup -----}
    window(20,7,40,20);textbackground(6);textcolor(3);clrscr;
    writeln('Prijem tovarov.');
    for x:=1 to 12 do
      writeln(x,' - ',tovar[x]);
    repeat
      readln(x);
    until (x>=0) and (x<13);
    repeat
      writeln('Pocet kusov');
      readln(info);
    until money>info*cena[x];
    money:=money-info*cena[x];
    kusy[x]:=kusy[x]+info;
    writeln('Stav tvojho konta:',money);
    repeat until keypressed;
  end;
  2:begin                                                {----- predaj -----}
    window(20,7,40,20);textbackground(6);textcolor(3);clrscr;
    writeln('Predaj tovarov.');
    for x:=1 to 12 do
      writeln(x,' - ',tovar[x]);
    repeat
      readln(x);
    until (x>=0) and (x<13);
    repeat
      writeln('Pocet kusov');
      readln(info);
    until info<kusy[x];
    money:=money+info*cena[x];
    kusy[x]:=kusy[x]-info;
    writeln('Stav tvojho konta:',money);
    repeat until keypressed;
  end;
  3:begin                                                 {----- prehlad -----}
    window(20,10,70,25);textbackground(blue);textcolor (red);clrscr;
    writeln('INFO.     Stav tvojho konta:',money);
    writeln('');
    for x:=1 to 12 do begin
      writeln('Tovar:',tovar[x]);gotoxy(19,x+2);writeln('Kusy:',kusy[x]);gotoxy(29,x+2);writeln('Cena:',cena[x]);
    end;
    repeat until keypressed;
  end;
  4:begin
    window(17,10,78,23);textbackground(3);textcolor(5);clrscr;
    for x:=1 to 12 do begin
      write('Na sklade mas ',tovar[x],'. Stara cena:',cena[x],'. Nova cena:');
    read(cena[x]);
    end;
  end;
end;
until quit=5;
end.


