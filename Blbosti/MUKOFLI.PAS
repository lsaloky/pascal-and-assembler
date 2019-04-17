program MukoSoft_prehravanie_FLI;
uses Crt,PomGr,MainGr;
BEGIN
  InicializujGrafiku;
  repeat
    NahrajAPustFLI('e:\animace\fli\topgun03.fli');
  until KeyPressed;
  ReadKey;
  ZavriGrafiku;
END.