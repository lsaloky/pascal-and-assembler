program Pravidlovy_system;   {verzia 1.0}
const PObjektov=4;        {<255}
      PVlastnosti=6;      {<255}
      PPovodnychFaktov=6;
      PPravidiel=3;
      PPredpokladov=5;    {<255}
      PFaktov=30;
      Objekt:array[1..PObjektov,1..2] of string[10]=(
        ('Jan','Jana'),('Jana','Jany'),('Igor','Igora'),('Pavol','Pala'));
      Vlastnost:array[1..PVlastnosti] of string[20]=
        ('je bratom','je sestrou','je bratrancom','je sesternicou',
         'je muzom','je zenou');
      PovodnyFakt:array[1..PPovodnychFaktov,1..3] of byte=(
        (1,1,2),  { Jan je bratom Jany }
        (1,3,3),  { Jan je bratrancom Igora }
        (2,4,4),  { Jana je sesternicou Pala }
        (2,6,0),  { Jana je zenou}
        (3,5,0),  { Igor je muzom}
        (4,5,0)); { Pavol je muzom}
        {(1,5,0),}  { Jan je muzom}
      Predpoklady:array[1..PPredpokladov+1,1..3] of byte=(
        (1,1,2),                              { X je bratom Y }
        (1,1,2),(2,5,0),                      { X je bratom Y, Y je muz}
        (1,1,2),(2,6,0),                      { X je bratom Y, Y je zena}
        (0,0,0));
      Dosledky:array[1..PPravidiel,1..3] of byte=(
        (1,5,0),                              { X je muz }
        (2,1,1),                              { Y je bratom X }
        (2,2,1));                             { Y je sestrou X }
      Indexy:array[1..PPravidiel+1] of byte=(1,2,4,6);{indexy predpokladov,*3}

var Fakt:array[1..PFaktov,1..3] of byte;
    Filter:array[1..PObjektov] of boolean;
    i,j:integer;

procedure Skumaj;
begin

end;
procedure VypisFakty;
begin
  Writeln(#13#10'Fakty:'#13#10'----------------------');
  i:=1;
  while Fakt[i,1]>0 do begin
    if Fakt[i,3]>0 then WriteLn(Objekt[Fakt[i,1],1],' ',Vlastnost[Fakt[i,2]],' ',Objekt[Fakt[i,3],2],'.')
    else WriteLn(Objekt[Fakt[i,1],1],' ',Vlastnost[Fakt[i,2]],'.');
    Inc(i);
  end;
end;

BEGIN
  Move(PovodnyFakt,Fakt,SizeOf(PovodnyFakt));
  Skumaj;
  VypisFakty;
  ReadLn;
END.
