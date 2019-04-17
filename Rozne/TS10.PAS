program TS_10;
{programovaci jazyk Turingove stroje, verzia 1.0. Lubos Saloky, 19.2.1998}
{na paske je nulova poloha v strede}
type TInstrukcia=record
                   StavStary,PismenoStare,PismenoNove,StavNovy:byte;
                   Smer:char;
                 end;
const MaxPaska=5;
{ ----- program vrati 0, ak je zadane cislo parne; 1, ak je neparne ----- }
      Paska:array[-MaxPaska..MaxPaska] of byte=(0,0,0,0,0,1,1,1,1,1,0);
      MaxInstrukcii=3;
      Instrukcia:array[0..MaxInstrukcii] of TInstrukcia=(
        (StavStary:0;PismenoStare:1;PismenoNove:0;StavNovy:1;Smer:'R'),
        (StavStary:1;PismenoStare:1;PismenoNove:0;StavNovy:0;Smer:'R'),
        (StavStary:0;PismenoStare:0;PismenoNove:1;StavNovy:2;Smer:'N'),
        (StavStary:0;PismenoStare:0;PismenoNove:0;StavNovy:0;Smer:'K'));
(*{ ----- program zastavi prave vtedy ked je parny pocet nul v slove - pred znakom A (=2) ----- }
      Paska:array[-MaxPaska..MaxPaska] of byte=(0,0,0,0,0,1,1,0,1,2,0);
      MaxInstrukcii=5;
      Instrukcia:array[0..MaxInstrukcii] of TInstrukcia=(
        (StavStary:0;PismenoStare:0;PismenoNove:0;StavNovy:1;Smer:'R'),
        (StavStary:1;PismenoStare:0;PismenoNove:0;StavNovy:0;Smer:'R'),
        (StavStary:1;PismenoStare:1;PismenoNove:1;StavNovy:1;Smer:'R'),
        (StavStary:0;PismenoStare:1;PismenoNove:1;StavNovy:0;Smer:'R'),
        (StavStary:1;PismenoStare:2;PismenoNove:2;StavNovy:1;Smer:'N'),
        (StavStary:0;PismenoStare:0;PismenoNove:0;StavNovy:0;Smer:'K'));*)
var AktInstrukcia,AktPozPasky,AktStav,AktPismeno:word;
    i:integer;
procedure VypisPasku;
begin
  Write('Paska: ');
  for i:=-MaxPaska to MaxPaska do write(Paska[i],',');
  WriteLn;
end;
procedure SpustProgram;
begin
  repeat
    AktInstrukcia:=0;
    AktPismeno:=Paska[AktPozPasky];                               {je nove aktualne pismeno}
    while ((AktStav<>Instrukcia[AktInstrukcia].StavStary) or
           (AktPismeno<>Instrukcia[AktInstrukcia].PismenoStare)) and
           (AktInstrukcia<MaxInstrukcii) do Inc(AktInstrukcia);
    if AktInstrukcia<>MaxInstrukcii then begin                    {ak si nasiel instrukciu}
      Paska[AktPozPasky]:=Instrukcia[AktInstrukcia].PismenoNove;  {prepis pismeno}
      AktStav:=Instrukcia[AktInstrukcia].StavNovy;                {zmen stav}
      case Instrukcia[AktInstrukcia].Smer of                      {presun R/W hlavu}
        'R':Inc(AktPozPasky);
        'L':Dec(AktPozPasky);
      end;
    end;
  until ((Instrukcia[AktInstrukcia].Smer='N') or                  {stoji do nekonecna}
         (AktInstrukcia=MaxInstrukcii) or                         {nenaslo instrukciu}
         (Abs(AktPozPasky)>MaxPaska));                            {(teoreticky) prebehlo celu pasku do nekonecna}
  Write('Popis (ne)ukoncenia vypoctu: ');
  if AktInstrukcia=MaxInstrukcii then writeln('STOP: Nenasla sa instrukcia');
  if Abs(AktPozPasky)>MaxPaska then writeln('NONSTOP: Stroj bezi po paske do nekonecna');
  if Instrukcia[AktInstrukcia].Smer='N' then writeln('NONSTOP: Stroj sa zacyklil (pri N)');
end;
BEGIN
  AktStav:=0;
  AktPozPasky:=0;
  WriteLn(#13#10'--------------------'#13#10'Turingove stroje - zaciatok vypoctu:');
  VypisPasku;
  SpustProgram;
  VypisPasku;
  ReadLn;
END.