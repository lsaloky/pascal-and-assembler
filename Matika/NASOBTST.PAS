program nasobenie;	{testovaci program, ci je dobra nasobiaca rutina}
const presnost=10;
var op1,op2:array[1..presnost] of shortint;
    vystup,vysl:array[1..2*presnost] of shortint;
    x,y,index,suc,pom,carry,t:integer;
    s:string;
    a,b:longint;
procedure Prevod;              {prevedie retazec na cislo v pozadovanom tvare}
var pom,err,dlz:integer;       {a osetri chyby}
begin
  for x:=1 to 2*presnost do vystup[x]:=0;
  err:=0;dlz:=length(s);pom:=presnost+1-dlz;
  while (pom<presnost+1) and (err=0) do begin
    Val(s[pom-presnost+dlz],vystup[pom],err);
    Inc(pom);
  end;
  if err>0 then begin
    writeln('Chybne zadan‚ c¡slo!!!');
    vystup[1]:=127;
  end;
end;

procedure Vypis;                {vypise vysledok na obrazovku}
var prvy:integer;
begin
  writeln;
  prvy:=presnost;
  for x:=2*presnost downto 1 do if vysl[x]<>0 then prvy:=x;
  for x:=prvy to 2*presnost do write(vysl[x]);
  writeln;
end;

BEGIN                    { -------   Zacina samotny program   ------ }
randomize;
for t:=1 to 100 do begin
  a:=random(10000);
  Str(a,s);
  Prevod;
  move(vystup,op1,sizeof(op1));
  b:=random(10000);
  Str(b,s);
  Prevod;
  move(vystup,op2,sizeof(op2));
  for x:=1 to 2*presnost do vysl[x]:=0;
  for y:=presnost downto 1 do              {samotny algoritmus}
    for x:=presnost downto 1 do begin      {ciastocne sucty sa nevytvaraju, scitanie prebieha uz vo vyslednom cisle}
      vysl[y+x]:=vysl[y+x]+op2[y]*op1[x];  {nasobenie,}
      pom:=0;
      if vysl[y+x]>9 then begin
        index:=y+x;
        carry:=vysl[index] div 10;           {nasledna zmena cisla na cislicu}
        vysl[index]:=vysl[index] mod 10;     {s pretecenim do predchadzajucej}
        vysl[index-1]:=vysl[index-1]+carry;  {polozky pola}
      end;
    end;
  writeln('a=',a);
  writeln('b=',b);
  Vypis;
  writeln(a*b);
  writeln('-----------------------');
  readln;
end;
END.
