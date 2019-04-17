program Prechadzanie_grafu_cez_dynamicke_premenne;
const PocetLudi=5;
type PZoznam=^TZoznam;
     PClovek=^TClovek;
     TZoznam=record
       Clovek:PClovek;
       Dalsi:PZoznam;
     end;
     TClovek=record
       Cislo:word;
       Zoznam:PZoznam;
     end;
var Zac,p:PClovek;
    Ciel:word;
    Pouzite:array[1..PocetLudi] of boolean;
    Najdeny:boolean;
procedure NajdiCestu(Akt:PClovek);
var Lin:PZoznam;
begin
  if Akt^.Cislo=Ciel then Najdeny:=true;
  Pouzite[Akt^.Cislo]:=true;
  Lin:=Akt^.Zoznam;
  while (Lin<>nil) and (not Najdeny) do begin
    if not Pouzite[Lin^.Clovek^.Cislo] then NajdiCestu(Lin^.Clovek);
    Lin:=Lin^.Dalsi;
  end;
end;
BEGIN
  New(Zac);
  Zac^.Cislo:=1;                              {1 <-> 2 ->3         }
  New(Zac^.Zoznam);                           {      |             }
  New(Zac^.Zoznam^.Clovek);                   {      4             }
  p:=Zac^.Zoznam^.Clovek;
  p^.Cislo:=2;
  New(p^.Zoznam);
  New(p^.Zoznam^.Clovek);
  p^.Zoznam^.Clovek^.Cislo:=3;
  p^.Zoznam^.Clovek^.Zoznam:=nil;
  New(p^.Zoznam^.Dalsi);
  New(p^.Zoznam^.Dalsi^.Clovek);
  p^.Zoznam^.Dalsi^.Clovek^.Cislo:=4;
  p^.Zoznam^.Dalsi^.Clovek^.Zoznam:=nil;
  New(p^.Zoznam^.Dalsi^.Dalsi);
  p^.Zoznam^.Dalsi^.Dalsi^.Clovek:=Zac;        {kruh}
  p^.Zoznam^.Dalsi^.Dalsi^.Dalsi:=nil;

  Ciel:=5;
  NajdiCestu(Zac);
END.