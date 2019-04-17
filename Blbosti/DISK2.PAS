program Demonstracne_ukazky_prace_s_diskom;
{$I-} {vyradenie Compiler/I/O checking}
var f1:file of string;                     {typovy subor}
    f2:text;                               {textovy subor}
    f3:file;                               {netypovy subor}
    s:string;
    a:array[0..255] of byte;

procedure Chyba;{rutiny na testovanie uspesnosti I/O operacii}
var pom:integer;
begin
  pom:=IOResult;     {v tejto premennej sa vracia chybovy kod}
  if pom<>0 then write(#7);     {zvukovy signal}
  case pom of
    $00:write('OK '); {vsetko v  poriadku}
    $01:writeln('Subor neexistuje');
    $02:writeln('Subor nie je mozne otvorit pre vstup');
    $03:writeln('Subor nie je mozne otvorit pre vystup');
    $04:writeln('Subor nie je mozne otvorit');
    $05:writeln('Zo suboru nie je mozne citat');
    $06:writeln('Do suboru nie je mozne zapisovat');
    $10:writeln('Chyba v ciselnom formate');
    $20:writeln('Nedovolena operacia na zariadenie');
    $21:writeln('Pristup nie je dovoleny v priamom mode');
    $22:writeln('Nie je mozne priradit na standardny subor');
    $90:writeln('Rozdielna dlzka zaznamu');
    $91:writeln('Ukazatele za koncom suboru');
    $99:writeln('Neocakavany koniec suboru');
    $F0:writeln('Chyba zapisu na disk');
    $F1:writeln('Adresar je plny');
    $F2:writeln('Prekrocenie objemu suboru');
    $FF:writeln('Subor zmizol!!!');
    else writeln('Neznama chyba!!!');
  end;
end;

BEGIN
  {praca s typovym suborom}
  Assign(f1,'retazec.dat');     {priradenie premennej fyzickemu suboru}
  Chyba;                        {testovanie uspesnosti bezprostredne po operacii}
  Rewrite(f1);                  {otvorenie suboru pre zapis}
  s:='Toto je retazec';
  write(f1,s);                  {zapis do typoveho suboru - write, nie writeln}
  Close(f1);                    {ukoncenie prace so suborom}
  s:='';
  Reset(f1);                    {otvorenie suboru pre citanie}
  read(f1,s);                   {citanie z typoveho suboru}
  writeln(s);
  Seek(f1,0);                    {znovunastavenie na zaciatok suboru}
  Seek(f1,FileSize(f1));         {                   koniec suboru}
  Close(f1);

  {praca s textovym suborom - pri pisani do textoveho suboru}
  {je zaistena automaticka konverzia datovych typov na string}
  Assign(f2,'text.dat');        {priradenie premennej fyzickemu suboru}
  Rewrite(f2);
  writeln(f2,'Riadok v textovom subore');   {writeln, nie write}
  writeln(f2,'Demonstracia konverzie:',2+2);
  Close(f2);
  Reset(f2);                    {otvorenie suboru pre citanie}
  while not Eof(f2) do begin
    readLn(f2,s);                   {citanie z typoveho suboru}
    writeln(s);
  end;
  Close(f2);

  {praca s netypovym suborom}
  Assign(f3,'chaos.dat');
  Rewrite(f3,256);              {256=dlzka jedneho bloku dat}
  readln;
END.