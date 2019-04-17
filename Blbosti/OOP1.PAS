program OOP_1;{definicia objektov, metody, dedicnost}
   { ---------- Definicia objektov ---------- }
type TLokace=object                     {vychodzi najabstraktnejsi objekt}
              x,y,farba:integer;
              procedure NastavFarbu(f:integer);
            end;
     TBod=object(TLokace)               {dedi vlastnosti objektu TLokace}
               Viditelnost:boolean;
               procedure Init(sx,sy:integer);
             end;
     BodPtr=^TBod;                      {to iste ako TBod, ale v heape}
   { ---------- Definicia metod ---------- }
procedure TLokace.NastavFarbu(f:integer);
begin
  farba:=f;
end;

procedure TBod.Init(sx,sy:integer);
begin
  x:=sx;                   {x,y - zdedene datove polozky objektu TBod}
  y:=sy;
  TLokace.NastavFarbu(0);  {dedit sa daju aj metody}
end;
   { ---------- Zadefinovanie premennych a objektov ----------}
var bod:TBod;
    DynamickyBod:BodPtr;
   { ---------- Hlavny program ---------- }
BEGIN
  bod.x:=2;                 {bod v datovom segmente}
  bod.y:=3;
  bod.viditelnost:=true;
  bod.Init(5,2);
  writeln(bod.x);
  New(DynamickyBod);        {inicializacia bodu v heape}
  DynamickyBod^.x:=32;      {praca s bodom}
  Dispose(DynamickyBod);    {zrusenie objektu}
END.