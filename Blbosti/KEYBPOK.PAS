uses KeyBoard;
var I:integer;
BEGIN

  InicializujZoznam;
  repeat
    for i:=0 to 127 do if Zoznam^[i]>0 then write(i,' ');
  until false;
  ZavriZoznam;
END.