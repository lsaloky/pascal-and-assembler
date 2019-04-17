program Rychle_zistenie_ci_je_cislo_prvocislo;
uses Dos;
const prvoc:string='1234567907';
var zvysok,x,del,k,odmoc:longint;
    y,dlzka,err:integer;
    vysl:boolean;
    hod,min,sec,s100:word;
BEGIN
  writeln('Zaciname...');
  GetTime(hod,min,sec,s100);
  writeln(hod,':',min,':',sec,'.',s100);
  vysl:=true;
  val(prvoc,k,err);
  odmoc:=Trunc(Sqrt(k));
  dlzka:=Length(prvoc);
  for x:=1 to dlzka do prvoc[x]:=Chr(Ord(prvoc[x])-48);
  for x:=2 to odmoc do begin
    k:=10-x;
    zvysok:=(Ord(prvoc[1])*k+Ord(prvoc[2])) mod x;
    if dlzka>2 then for y:=3 to dlzka do zvysok:=(k*zvysok+Ord(prvoc[y])) mod x;    if zvysok=0 then vysl:=false;
  end;
  GetTime(hod,min,sec,s100);
  writeln(hod,':',min,':',sec,'.',s100);
  write('Cislo ');
  if vysl=false then write('nie ');
  writeln('je prvocislo');
  readln;
END.