program Telefonni_maniaci;
const PManiakov:word=5;
      Zoznam:array[1..5,1..5] of word=(
        (1,2,5,0,0),(2,5,0,0,0),(3,5,0,0,0),(4,0,0,0,0),(1,5,0,0,0));
var i,j,k,l:word;
    Zmena:boolean;
{ ----- zisti, ci Kto ma Koho cislo ----- }
function MaCislo(Kto,Koho:word):boolean;
var pom:word;
begin
  for pom:=1 to PManiakov do
    if Zoznam[Kto,pom]=Koho then begin
      MaCislo:=True;
      Exit;
    end else MaCislo:=False;
end;
{ ----- prida Komu cislo Koho ----- }
procedure PridajCislo(Komu,Koho:word);
var pom:word;
begin
  pom:=1;
  while Zoznam[Komu,pom]>0 do Inc(pom);
  Zoznam[Komu,pom]:=Koho;
  Zmena:=True;
end;
{ ----- HLAVNY PROGRAM ----- }
BEGIN
  repeat
    Zmena:=False;
{ ----- reflexivnost: T(x,x) ----- }
    for i:=1 to PManiakov do
      if not(MaCislo(i,i)) then PridajCislo(i,i);
{ ----- symetria: T(x,y) => T(y,x) ----- }
    for i:=1 to PManiakov do
      for j:=1 to PManiakov do
        if (MaCislo(i,j)) and
           (not(MaCislo(j,i))) then PridajCislo(j,i);
{ ----- tranzitivnost: T(x,y) a T(y,z) => T(x,z) ----- }
    for i:=1 to PManiakov do
      for j:=1 to PManiakov do
        for k:=1 to PManiakov do
          if (MaCislo(i,j)) and
             (MaCislo(j,k)) and
             (not(MaCislo(i,k))) then PridajCislo(i,k);
  until not Zmena;
{ ----- vypis podskupin indexov ----- }

END.
