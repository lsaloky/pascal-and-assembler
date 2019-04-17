constructor TSpline.Init;
begin
  MaxBodov:=50;
end;
procedure TSpline.SpracujZadanie;
begin
  Presnost:=40; { v pixeloch }
end;
procedure TSpline.Metoda1;
var tzac,tciel:real;    { aktualna pozicia a spracuvany rozsah krivky }
begin
{ ----- polozenie prvych troch riadiacich bodov na zaciatok krivky ----- }
  for Spline.Cyklus:=0 to 2 do begin
    RBX[Cyklus]:=Krivka.HodnX[0];
    RBY[Cyklus]:=Krivka.HodnY[0];
  end;
{ ----- ukladanie dalsich bodov ----- }
  Cyklus:=3;
  tciel:=Krivka.tmin; { len aby preslo While }
  while (Cyklus<MaxBodov-3) and (Krivka.tmax-tciel>0.000001 {tciel<tmax} ) do begin
    tzac:=tciel; { koniec predosleho kroku je zaciatok nasledujuceho }
    tciel:=Krivka.tmax; { koniec nasl. je zatial koniec krivky }
    repeat
      RBX[Cyklus]:=Krivka.HodnX[Round((tciel-Krivka.tmin)/Krivka.tkrel)];
      RBY[Cyklus]:=Krivka.HodnY[Round((tciel-Krivka.tmin)/Krivka.tkrel)]; { polozime dalsi bod }
{ ----- testovanie pesnosti ----- }
      TestMin:=Round((tzac -Krivka.tmin)/Krivka.tkrel);
      TestMax:=Round((tciel-Krivka.tmin)/Krivka.tkrel);
        { testovaci interval na splajne: < TestMin,TestMax > }
      DostPresne:=True;
      for j:=TestMin to TestMax do begin { j bezi po SPLAJNE }
        i:=Cyklus-3;
        ts:=Round((j-TestMin)/(TestMax-TestMin));
          { [SumaX,SumaY] je bod na splajne }
        SumaX:=(RBX[i  ]*(1 -3*ts +3*ts*ts -1*ts*ts*ts)+
                RBX[i+1]*(4       -6*ts*ts +3*ts*ts*ts)+
                RBX[i+2]*(1 +3*ts +3*ts*ts -3*ts*ts*ts)+
                RBX[i+3]*(                 +1*ts*ts*ts))/6;
        SumaY:=(RBY[i  ]*(1 -3*ts +3*ts*ts -1*ts*ts*ts)+
                RBY[i+1]*(4       -6*ts*ts +3*ts*ts*ts)+
                RBY[i+2]*(1 +3*ts +3*ts*ts -3*ts*ts*ts)+
                RBY[i+3]*(                 +1*ts*ts*ts))/6;
        if (Abs(SumaX-Krivka.HodnX[j])>Presnost) or
           (Abs(SumaY-Krivka.HodnY[j])>Presnost) then DostPresne:=False;
      end;
      UI.KresliSpline(Cyklus,10);
{      ch:=ReadKey;
      if ch='a' then DostPresne:=True else DostPresne:=False;}
      if not DostPresne then begin
        tciel:=tciel-(tciel-tzac)/2; { skrat na polovicu }
      end;
    until DostPresne;
    inc(Cyklus);
  end;
{ ----- este sa polozia 2 riadiace body na koniec krivky ----- }
  for i:=Cyklus to Cyklus+1 do begin
    RBX[i]:=Krivka.HodnX[Krivka.PocetHodnot];
    RBY[i]:=Krivka.HodnY[Krivka.PocetHodnot];
  end;

end;
