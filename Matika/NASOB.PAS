program nasobenie;		{vynasobi dve cisla s pozadovanou presnostou}
const presnost=50;
var op1,op2:array[1..presnost] of shortint;      {vstupy}
    vystup,vysl:array[1..2*presnost] of shortint;{vystup a pomocne pole}
    sign:shortint;                    {znamienko}
    x,y,pom:integer;                  {pomocne premenne}
    carry:integer;                    {pretecenie do dalsieho radu}
    ciar,za_e:integer;                {pre spracovanie des. ciarky:1,24E+12}
    dlzka:integer;                    {testuje, ci je dostatocna presnost}
    s:string;                         {cisla su zadavane cez retazec}
    err:integer;                      {chybove hlasenie}
{procedury Chyba, Prevod, Nasob, Vypis}

procedure chyba;
begin
  if err>0 then begin
    writeln('Chybne zadan‚ c¡slo!!!');
    vystup[1]:=127;
  end;
end;

procedure Prevod;          {prevedie retazec na cislo v pozadovanom tvare}
var pom,pom2:integer;      {pomocna premenna}
    e,des:integer;         {pozicia des. ciarky a pismena E, napr. 1,45E+12}
    pomstr:string;         {pomocny retazec}
begin
  for x:=1 to 2*presnost do vystup[x]:=0;
  if s[1]='-' then begin
    delete(s,1,1);
    sign:=sign xor 1;
  end;
  e:=Pos('E',s);
  if e>0 then begin
    pomstr:=Copy(s,e+2,length(s)-e-1);
    Val(pomstr,pom2,err);
    if err>0 then begin
      chyba;
      exit;
    end;
    if s[e+1]='-' then pom2:=-pom2;
    za_e:=za_e+pom2;
    delete(s,e,length(s)-e+1);
  end;
  des:=Pos(',',s);           {osetrenie desatinnej ciarky}
  if des>0 then begin
    ciar:=ciar+length(s)-des;
    delete(s,des,1);
  end;
  err:=0;pom:=1;
  while (length(s)>pom-1) and (err=0) do begin
    Val(s[pom],vystup[pom+presnost-length(s)],err);
    Inc(pom);
  end;
  chyba;
end;

procedure Nasob;
begin
  for y:=presnost downto 1 do              {samotny algoritmus}
    for x:=presnost downto 1 do begin      {ciastocne sucty sa nevytvaraju, scitanie prebieha uz vo vyslednom cisle}
      vysl[y+x]:=vysl[y+x]+op2[y]*op1[x];  {nasobenie,}
      pom:=0;
      if vysl[y+x]>9 then begin
        carry:=vysl[y+x] div 10;           {nasledna zmena cisla na cislicu}
        vysl[y+x]:=vysl[y+x] mod 10;     {s pretecenim do predchadzajucich}
        vysl[y+x-1]:=vysl[y+x-1]+carry;  {poloziek pola}
      end;
    end;
end;

procedure Vypis;                {vypise vysledok na obrazovku}
var prvy:integer;
begin
  writeln;
  if sign=1 then write('-');
  prvy:=presnost;
  for x:=2*presnost downto 1 do if vysl[x]<>0 then prvy:=x;
  for x:=prvy to 2*presnost-ciar do write(vysl[x]);
  if ciar>0 then write(',');
  for x:=2*presnost-ciar+1 to 2*presnost do write(vysl[x]);
  if za_e>0 then write('E+',za_e);
  if za_e<0 then write('E',za_e);
  writeln;
end;

BEGIN      { ----------------   Zacina samotny program   ------------------ }
  ciar:=0;sign:=0;za_e:=0;
  repeat
    writeln('Zadaj operand #1');
    readln(s);
    dlzka:=length(s);
    Prevod;
  until vystup[1]<127;
  move(vystup,op1,sizeof(op1));
  repeat
    writeln('Zadaj operand #2');
    readln(s);
    dlzka:=dlzka+length(s);
    Prevod;
  until vystup[1]<127;
  if dlzka>presnost then begin
    writeln('Pozor, nastav v„csiu presnost!!!');
    exit;
  end;
  move(vystup,op2,sizeof(op2));
  Nasob;
  Vypis;
  readln;
END.
