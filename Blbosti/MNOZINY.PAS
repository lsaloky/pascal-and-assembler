program Dynamicka_mnozina;
{ ----- deklaracie objektov ----- }
type PPrvok=^TPrvok;
     TPrvok=object
       public
         Hodnota:word;
         Dalsi:PPrvok;
     end;
     TMnozina=object
       public
         Zac:PPrvok;
         constructor Init;
         function IsEmpty:boolean;
         procedure AddMember(Novy:word);
         function IsMember(Cislo:word):word;
         procedure Vypis;
         procedure Union(Nova:TMnozina);
       private
         Pocet:word;
         Pom:PPrvok;
     end;
{ ----- metody objektu TMnozina ----- }
constructor TMnozina.Init;
begin
  Zac:=nil;
end;
function TMnozina.IsEmpty:boolean;
begin
  if Zac=nil then IsEmpty:=True else IsEmpty:=False;
end;
procedure TMnozina.AddMember(Novy:word);
begin
  New(Pom);
  Pom^.Hodnota:=Novy;
  Pom^.Dalsi:=Zac;
  Zac:=Pom;
end;
procedure TMnozina.Vypis;
begin
  if Zac=nil then Write('Prazdna');
  Pom:=Zac;
  while Pom<>nil do begin
    Write(Pom^.Hodnota,' ');
    Pom:=Pom^.Dalsi;
  end;
  WriteLn;
end;
function TMnozina.IsMember(Cislo:word):word;
begin
  Pom:=Zac;
  Pocet:=0;
  while Pom<>nil do begin
    if Pom^.Hodnota=Cislo then Inc(Pocet);
    Pom:=Pom^.Dalsi;
  end;
  IsMember:=Pocet;
end;
procedure TMnozina.Union(Nova:TMnozina);
var PozVNovej:PPrvok;
begin
  PozVNovej:=Nova.Zac;
  while (PozVNovej<>nil) do begin
    AddMember(PozVNovej^.Hodnota);
    PozVNovej:=PozVNovej^.Dalsi;
  end;
end;
{ ----- deklaracie a hlavny program ----- }
var Mnozina,Pomocna:TMnozina;
    i:word;
BEGIN
  for i:=1 to 24 do WriteLn;
  Mnozina.Init;
  Write('Mnozina: ');
  Mnozina.Vypis;
  WriteLn('Prazdnost: ',Mnozina.IsEmpty);
  Mnozina.AddMember(2);
  Mnozina.AddMember(3);
  Mnozina.AddMember(4);
  Mnozina.AddMember(2);
  Mnozina.AddMember(4);
  Mnozina.AddMember(4);
  Write('Mnozina: ');
  Mnozina.Vypis;
  WriteLn('Prazdnost: ',Mnozina.IsEmpty);
  for i:=1 to 5 do WriteLn('Cislo ',i,' je v mnozine ',Mnozina.IsMember(i),'. krat');
  Pomocna.Init;
  Pomocna.AddMember(3);
  Pomocna.AddMember(4);
  Pomocna.AddMember(5);
  Pomocna.AddMember(6);
  Write('Pomocna mnozina: ');
  Pomocna.Vypis;
  Mnozina.Union(Pomocna);
  Write('Mnozina po zjednoteni: ');
  Mnozina.Vypis;
END.