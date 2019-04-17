constructor TPovel.Init;
begin
  Kalibrovany:=False;
  InicializujZoznam;
end;
procedure TPovel.CNPTJ;
begin
  repeat
    Joystick.ZistiPoziciu(word(JXAkt),word(JYAkt),JTlac);
  until JTlac=0;
end;
