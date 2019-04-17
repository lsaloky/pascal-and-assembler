program TYP_RECORD;
uses Crt;
type datum=record
     den,mesiac:byte;
     rok:integer;
     end;
var dni1,dni2,rozdiel:real;
    jedenden,druhyden:datum;
    a:byte;
    mesiac:array[1..12]of byte;
begin
mesiac[1]:=31;mesiac[2]:=28;mesiac[3]:=31;mesiac[4]:=30;
mesiac[5]:=31;mesiac[6]:=30;mesiac[7]:=31;mesiac[8]:=31;
mesiac[9]:=30;mesiac[10]:=31;mesiac[11]:=30;mesiac[12]:=31;
writeln('Zadaj prvy datum:den,mesiac,rok');
readln(jedenden.den,jedenden.mesiac,jedenden.rok);
writeln('Zadaj druhy datum:den,mesiac,rok');
readln(druhyden.den,druhyden.mesiac,druhyden.rok);
if jedenden.rok>0 then dni1:=int((jedenden.rok-1)*365.25)+jedenden.den;
if druhyden.rok>0 then dni2:=int((druhyden.rok-1)*365.25)+druhyden.den;
if jedenden.mesiac>1 then begin
                          for a:=1 to jedenden.mesiac-1 do
                            dni1:=dni1+mesiac[a];
                          end;
if druhyden.mesiac>1 then begin
                          for a:=1 to jedenden.mesiac-1 do
                            dni2:=dni2+mesiac[a];
                          end;
writeln('Rozdiel je:',dni1,dni2,abs(dni1-dni2):9:0);
repeat until keypressed;
end.
