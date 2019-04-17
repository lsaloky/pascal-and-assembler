program scitanie;	{scitava so zadanou presnostou}
const presnost=10;
var op1,op2,vystup,vysl:array[1..presnost] of shortint;
    x,y1,suc,y2:integer;
    s:string;

procedure Prevod;              {prevedie retazec na cislo v pozadovanom tvare}
var pom,err,dlz,odc:integer;   { a osetri chyby}
begin
  odc:=0;
  if s[1]='-' then begin       {osetrenie odcitania}
    s[1]:='0';
    odc:=1;
  end;
  for x:=1 to presnost do vystup[x]:=0;
  err:=0;dlz:=length(s);pom:=presnost+1-dlz;
  while (pom<presnost+1) and (err=0) do begin
    if s[pom-presnost+dlz]<>',' then Val(s[pom-presnost+dlz],vystup[pom],err)
                                else vystup[pom]:=126;
    Inc(pom);
  end;
  if odc=1 then for x:=1 to presnost do vystup[x]:=-vystup[x];
  if err>0 then begin
    writeln('Chybne zadan‚ c¡slo!!!');
    vystup[1]:=127;
  end;
end;

procedure Vypis;                {vypise vysledok na obrazovku}
var prvy,y:integer;
begin
  writeln;
  if y2>y1 then y:=y2;
  if y1>y2 then y:=y1;
  if y1=y2 then y:=0;
  prvy:=presnost;
  for x:=presnost downto 1 do if vysl[x]<>0 then prvy:=x;
  for x:=prvy to y-1 do write(vysl[x]);
  write(',');
  for x:=y to presnost do write(vysl[x]);
  writeln;
end;

BEGIN                    { -------   Zacina samotny program   ------ }
  repeat
    writeln('Zadaj operand #1');
    readln(s);
    Prevod;
  until vystup[1]<127;
  move(vystup,op1,sizeof(op1));
  repeat
    writeln('Zadaj operand #2');
    readln(s);
    Prevod;
  until vystup[1]<127;
  move(vystup,op2,sizeof(op2));
                {Rutina osetruj£ca desatinn£ ciarku}
  y1:=0;y2:=0;
  for x:=presnost downto 1 do begin
    if op1[x]=126 then y1:=x;
    if op2[x]=126 then y2:=x;
  end;
  if y1>0 then begin
    for x:=y1 downto 2 do op1[x]:=op1[x-1];
    op1[1]:=0;
  end;
  if y2>0 then begin
    for x:=y2 downto 2 do op2[x]:=op2[x-1];
    op2[1]:=0;
  end;
  if y1<>y2 then begin
    if y1>y2 then begin
      for x:=y1-y2 to presnost-y1+y2 do op1[x]:=op1[x+y1-y2];
      op1[presnost]:=0;
    end;
    if y2>y1 then begin
      for x:=y2-y1 to presnost-y2+y1 do op2[x]:=op2[x+y2-y1];
      op2[presnost]:=0;
    end;
  end;
                {Zacina rutina pre scitanie a odcitanie}
  for x:=1 to presnost do vysl[x]:=0;
  for x:=presnost downto 1 do begin
    suc:=op1[x]+op2[x];
    if suc>9 then begin        {pretecenie pri scitani}
      vysl[x-1]:=1;
      suc:=suc-10;
    end;
    if suc<0 then begin         {podtecenie pri odcitani}
      suc:=suc+10;
      vysl[x-1]:=-1;
    end;
    vysl[x]:=vysl[x]+suc;
  end;
  Vypis;
  readln;
END.