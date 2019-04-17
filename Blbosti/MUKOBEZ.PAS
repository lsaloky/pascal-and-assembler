program Bezier;{sila MukoSoftu proti Bezierovym krivkam a assembleru}
uses MainGr;
const RB1:Bezier3Struc=((120,65),(40,20),(20,80),(120,170));
      RB2:Bezier3Struc=((120,65),(200,20),(220,80),(120,170));
var i:integer;
BEGIN
  InicializujGrafiku;
  Bezier3(@RB1,10,12);
  Bezier3(@RB2,10,12);
  for i:=1 to 4 do begin
    PolozBod(RB1[i,1],RB1[i,2],15);
    PolozBod(RB2[i,1],RB2[i,2],15);
  end;
  ReadLn;
  ZavriGrafiku;
  Writeln('MukoSoft B‚zierove krivky 2.0'#13#10'Lubos Saloky, 1997');
END.