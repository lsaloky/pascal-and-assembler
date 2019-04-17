constructor TUI.Init;
begin
  xmin:=-300;
  xmax:= 300;
  ymin:=-230;
  ymax:= 230;
  xrel:=(xmax-xmin)/640;
  yrel:=(ymax-ymin)/480;
  InitGraph(gd,gm,Cesta);
end;
procedure TUI.KresliSpline(Pocet,Multi:word);
begin
  t:=0;i:=0;
  repeat
    X:=(Spline.RBX[i  ]*(1 -3*t +3*t*t -1*t*t*t)+
        Spline.RBX[i+1]*(4      -6*t*t +3*t*t*t)+
        Spline.RBX[i+2]*(1 +3*t +3*t*t -3*t*t*t)+
        Spline.RBX[i+3]*(              +1*t*t*t))/6;
    Y:=(Spline.RBY[i  ]*(1 -3*t +3*t*t -1*t*t*t)+
        Spline.RBY[i+1]*(4      -6*t*t +3*t*t*t)+
        Spline.RBY[i+2]*(1 +3*t +3*t*t -3*t*t*t)+
        Spline.RBY[i+3]*(              +1*t*t*t))/6;
    PutPixel(Round((X-xmin)/xrel),Round((Y-ymin)/yrel),14);
    t:=t+1/Multi;
    if t>=1 then begin
      t:=0;
      Inc(i);
    end;
  until i>=Pocet-2;
end;
procedure TUI.KresliKrivku;
begin
  for i:=0 to Krivka.PocetHodnot do
    PutPixel(Round((Krivka.HodnX[i]-xmin)/xrel),Round((Krivka.HodnY[i]-ymin)/yrel),9);
end;
destructor TUI.Koniec;
begin
  ReadLn;
  CloseGraph;
  WriteLn('MukoSoft interpolacia krivky splajnami'#13#10'Lubos Saloky, 1999');
end;