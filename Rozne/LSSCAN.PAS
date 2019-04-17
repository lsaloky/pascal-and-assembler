program Najdi_virusy;
uses Dos;
var reg:registers;
    vysledok:boolean;
begin
  vysledok:=false;
  reg.AX:=$4BA6;
  Intr($21,reg);
  if reg.AX=$4B4C then begin
    writeln('VIRUS LION KING NAJDENY!!!');
    writeln('Pozri PC Revue 3/95');
    vysledok:=true;
  end;
  reg. AX:=$FFFF;
  Intr($21,reg);
  if reg.AX=$3333 then begin
    writeln('VIRUS 33 NAJDENY!!!');
    writeln('Pozri PC Revue 11/94 a necisti TBAVom!');
    vysledok:=true;
  end;
  reg. AX:=$6666;
  Intr($21,reg);
  if reg.AX=$1977 then begin
    writeln('Virus MURUROA najdeny!!!.');
    writeln('Pozri PC Revue 2/96');
    vysledok:=true;
  end;
  if vysledok=false then writeln('Vsetko je OK.');
end.