program Pouzivanie_joysticka_pomocou_unitu;
uses Joystk,Crt;
var x,y,c:integer;
    tlacidloA,tlacidloB:boolean;
BEGIN
  for c:=1 to 1000 do begin
    JoyStkPos(0,x,y);
    tlacidloA:=JoyStkBtn(BtnA1);
    tlacidloB:=JoyStkBtn(BtnA2);
    GotoXY(1,1);
    writeln(x,',',y,',',tlacidloA,',',tlacidloB);
  end;
END.