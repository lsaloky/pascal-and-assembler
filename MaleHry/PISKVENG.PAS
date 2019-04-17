program Engine_pre_piskvorky_3x3;
uses Crt;
var Plan:array[1..3,1..3] of byte; { riadok, stlpec: hrac 1, pocitac 4 }
    i,j,Sucet:integer;
    IsielPocitac,Koniec:boolean;
    HracX,HracY:byte;
{ ----- procedury pre rozmyslanie pocitaca ----- }
function DveRovnakeATretiePrazdne(i:integer):boolean;
begin { tu vidno, preco pocitac ma cislo, kt. je vacsie ako dlzka hr. planu }
  DveRovnakeATretiePrazdne:=False;
  case i of { 1-3 po riadku, 4-6 po stlpci, 7-8 uhlopriecky \,/ }
    1:if Plan[1,1]+Plan[1,2]+Plan[1,3] in [2,8] then DveRovnakeATretiePrazdne:=True;
    2:if Plan[2,1]+Plan[2,2]+Plan[2,3] in [2,8] then DveRovnakeATretiePrazdne:=True;
    3:if Plan[3,1]+Plan[3,2]+Plan[3,3] in [2,8] then DveRovnakeATretiePrazdne:=True;
    4:if Plan[1,1]+Plan[2,1]+Plan[3,1] in [2,8] then DveRovnakeATretiePrazdne:=True;
    5:if Plan[1,2]+Plan[2,2]+Plan[3,2] in [2,8] then DveRovnakeATretiePrazdne:=True;
    6:if Plan[1,3]+Plan[2,3]+Plan[3,3] in [2,8] then DveRovnakeATretiePrazdne:=True;
    7:if Plan[1,1]+Plan[2,2]+Plan[3,3] in [2,8] then DveRovnakeATretiePrazdne:=True;
    8:if Plan[3,1]+Plan[2,2]+Plan[1,3] in [2,8] then DveRovnakeATretiePrazdne:=True;
  end;
end;
procedure ObsadTretie(i:integer);
begin
  case i of
    1:for j:=1 to 3 do if Plan[1  ,j]=0 then Plan[1  ,j]:=4; { uz vieme, }
    2:for j:=1 to 3 do if Plan[2  ,j]=0 then Plan[2  ,j]:=4; { ze je prave }
    3:for j:=1 to 3 do if Plan[3  ,j]=0 then Plan[3  ,j]:=4; { jedna nula }
    4:for j:=1 to 3 do if Plan[j  ,1]=0 then Plan[j  ,1]:=4;
    5:for j:=1 to 3 do if Plan[j  ,2]=0 then Plan[j  ,2]:=4;
    6:for j:=1 to 3 do if Plan[j  ,3]=0 then Plan[j  ,3]:=4;
    7:for j:=1 to 3 do if Plan[j  ,j]=0 then Plan[j  ,j]:=4;
    8:for j:=1 to 3 do if Plan[4-j,j]=0 then Plan[4-j,j]:=4;
  end;
  IsielPocitac:=True; { urcite bolo tretie volne, podarilo sa obsadit }
end;
procedure ObsadRoh;
begin
  if (not IsielPocitac) and (Plan[1,1]=0) then begin
    Plan[1,1]:=4;
    IsielPocitac:=True;
  end;
  if (not IsielPocitac) and (Plan[1,3]=0) then begin
    Plan[1,3]:=4;
    IsielPocitac:=True;
  end;
  if (not IsielPocitac) and (Plan[3,1]=0) then begin
    Plan[3,1]:=4;
    IsielPocitac:=True;
  end;
  if (not IsielPocitac) and (Plan[3,3]=0) then begin
    Plan[3,3]:=4;
    IsielPocitac:=True;
  end;
end;
procedure PolozNahodne; { nie celkom nahodne, da sa to zlepsit }
begin
  for i:=1 to 3 do
    for j:=1 to 3 do
      if (not IsielPocitac) and (Plan[i,j]=0) then begin
        Plan[i,j]:=4;
        IsielPocitac:=True;
      end;
end;



BEGIN
  ClrScr;
  Koniec:=False;
{ ----- HLAVNY CYKLUS ----- }
  repeat
{ ----- zistenie, ci je koniec partie ----- }
  Sucet:=0;
  for i:=1 to 3 do
    for j:=1 to 3 do
      Inc(Sucet,Plan[i,j]);
  if Sucet=5*1+4*4 then Koniec:=True; { plny plan }
  for i:=1 to 8 do
    case i of { 1-3 po riadku, 4-6 po stlpci, 7-8 uhlopriecky \,/ }
      1:if Plan[1,1]+Plan[1,2]+Plan[1,3] in [3,12] then Koniec:=True;
      2:if Plan[2,1]+Plan[2,2]+Plan[2,3] in [3,12] then Koniec:=True;
      3:if Plan[3,1]+Plan[3,2]+Plan[3,3] in [3,12] then Koniec:=True;
      4:if Plan[1,1]+Plan[2,1]+Plan[3,1] in [3,12] then Koniec:=True;
      5:if Plan[1,2]+Plan[2,2]+Plan[3,2] in [3,12] then Koniec:=True;
      6:if Plan[1,3]+Plan[2,3]+Plan[3,3] in [3,12] then Koniec:=True;
      7:if Plan[1,1]+Plan[2,2]+Plan[3,3] in [3,12] then Koniec:=True;
      8:if Plan[3,1]+Plan[2,2]+Plan[1,3] in [3,12] then Koniec:=True;
    end;
{ ----- kreslenie planu ----- }
    for i:=1 to 3 do
      for j:=1 to 3 do begin
        GotoXY(i,j);
        write(Plan[i,j]);
      end;
    if not Koniec then begin
{ ----- citanie hracovho tahu ----- }
      repeat
        repeat
          GotoXY(1,5);
          WriteLn('Zadaj tah (stlpec, riadok z [1..3]):');
          DelLine;
          DelLine;
          ReadLn(HracX,HracY);
        until (HracX in [1,2,3]) and (HracY in [1,2,3]);
      until Plan[HracX,HracY]=0;
      Plan[HracX,HracY]:=1;
{ ----- rozmyslanie pocitaca ----- }
      IsielPocitac:=False;
      if Plan[2,2]=0 then begin { ak je volny stred }
        Plan[2,2]:=4;
        IsielPocitac:=True;
      end else begin
        for i:=1 to 8 do
          if (not IsielPocitac) and (DveRovnakeATretiePrazdne(i))
            then ObsadTretie(i);
        if not IsielPocitac then ObsadRoh;
        if not IsielPocitac then PolozNahodne; {nepolozi, ak je plny plan }
      end;
    end; { if not Koniec }
  until Koniec;
  GotoXY(1,6);
  WriteLn('Koniec partie.');
  DelLine;
  ReadLn;
{ ----- ukoncenie programu ----- }
  ClrScr;
  WriteLn('Engine pre piskvorky'#13#10'Lubos Saloky, september 1999');
END.