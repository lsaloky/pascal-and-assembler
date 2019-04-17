constructor TKrivka.Init;
begin
  tmin:=1;
  tmax:=2*pi;
  PocetHodnot:=1000;
  tkrel:=(tmax-tmin)/PocetHodnot;
end;
procedure TKrivka.SpracujZadanie;
begin
  for i:=0 to PocetHodnot do begin
    tk:=tmin+i*tkrel;
    HodnX[i]:=200*sin(tk);
    HodnY[i]:=200*cos(tk);
  end;
end;