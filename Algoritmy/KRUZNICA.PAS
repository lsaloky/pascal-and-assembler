program Kruznicokreslic;
uses MainGr;
var i:integer;
BEGIN
  InicializujGrafiku;
  for i:=1 to 10000 do Kruznica(160,100,90,14);
  ZavriGrafiku;
END.