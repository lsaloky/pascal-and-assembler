uses crt;
var subor:file of string;
    px,x:integer;
    polozka:array[1..20] of string;
    napis:array[1..20] of string;
    t:boolean;
begin
  napis[1]:='Meno:';
  napis[2]:='Priezvisko:';
  napis[3]:='Datum narodenia:';
  napis[4]:='Vyska:';
  napis[5]:='Vaha:';
  napis[6]:='Adresa:';
  napis[7]:='Povolanie:';
  napis[8]:='Stav:';
  napis[9]:='Deti:';
  napis[10]:='Znacka auta+SPZ:';
  clrscr;
  assign(subor,'udaje.dat');
  rewrite(subor);
  for x:=1 to 10 do
   begin
    seek(subor,0);
    writeln(x,'.',napis[x]);
    gotoxy(20,x);readln(polozka[x]);
   end;
  close(subor);
  readln;
  writeln;
  clrscr;
  clrscr;
  writeln('Zadajte polozku');
  readln(px);
  reset(subor);
  seek(subor,px-1);
  writeln(polozka[px-1]);
  close(subor);
  readln;
end.