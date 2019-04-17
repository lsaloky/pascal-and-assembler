constructor TKrivka.Init;
begin
  Presnost:=6;
  PocetB:=0;
  BPrvy:=nil;
  BAkt:=nil;
end;
procedure TKrivka.PridajBod(x,y:byte);
begin
  with Font.Akt^ do
    if KAkt<>nil then begin
      if BPrvy=nil then begin
        New(BPrvy);
        BAkt:=BPrvy;
        BPrvy^.X:=x;
        BPrvy^.Y:=y;
        BPrvy^.BDal:=nil;
      end else begin
        New(BPom);
        BPom^.BDal:=BAkt^.BDal;
        BAkt^.BDal:=BPom;
        BPom^.X:=x;
        BPom^.Y:=y;
        BAkt:=BPom;
      end;
      Inc(PocetB);
    end;
end;
function TKrivka.OdoberBod:boolean;
begin
  if BAkt=nil then OdoberBod:=False
  else begin
    if BAkt=BPrvy then begin
      BPrvy:=BPrvy^.BDal;
      Dispose(BAkt);
      BAkt:=BPrvy;
      OdoberBod:=True;
      Dec(PocetB);
    end else begin
      BPom:=BPrvy;
      while (BPom^.BDal<>BAkt) and (BPom^.BDal<>nil) do BPom:=BPom^.BDal;
      if BPom^.BDal=nil then begin
        Menu.Chyba(255);
        OdoberBod:=False;
      end else begin
        BPom^.BDal:=BPom^.BDal^.BDal;   { vyhod ho }
        Dispose(BAkt);
        BAkt:=BPom;
        OdoberBod:=True;
        Dec(PocetB);
      end;
    end;
  end;
end;
procedure TKrivka.DalsiBod;
begin
  KresliKrivku(0,0,1,0);
   if (BAkt<>nil) and (BAkt^.BDal<>nil) then BAkt:=BAkt^.BDal;
  KresliKrivku(0,0,1,15);
end;
procedure TKrivka.PredoslyBod;
begin
  KresliKrivku(0,0,1,0);
  if (BAkt<>BPrvy) then begin
    BPom:=BPrvy;
    while (BPom^.BDal<>BAkt) and (BPom^.BDal<>nil) do BPom:=BPom^.BDal;
    if BPom^.BDal=nil then Menu.Chyba(254);
    BAkt:=BPom;
  end;
  KresliKrivku(0,0,1,15);
end;

procedure TKrivka.KresliKrivku(PosX,PosY:word;Koef,Farba:byte);
var t,SumaX,SumaY,PresnostNova:real;
    ti:array[1..4] of real;
    PredX,PredY:word;
    PorC:byte;
    BPom2:PBod;
begin
  if (PocetB>1) and (Presnost=1) then begin
    PredX:=Round(BPrvy^.x/Koef+PosX);
    PredY:=Round(BPrvy^.y/Koef+PosY);
    BPom:=BPrvy^.BDal;
{$IFDEF PlnaVerzia}
    Color:=Farba;
{$ELSE}
    SetColor(Farba);
{$ENDIF}
    repeat
{$IFDEF PlnaVerzia}
      Ciara(PredX,PredY,Round(BPom^.x/Koef+PosX),Round(BPom^.y/Koef+PosY));
{$ELSE}
      Line(PredX,PredY,Round(BPom^.x/Koef+PosX),Round(BPom^.y/Koef+PosY));
{$ENDIF}
      PredX:=Round(BPom^.x/Koef+PosX);
      PredY:=Round(BPom^.y/Koef+PosY);
      BPom:=BPom^.BDal;
    until BPom=nil;
  end;
  if (PocetB>3) and (Presnost>1) then begin
    if Presnost<Koef then PresnostNova:=0.5 { vypocet potrebnej presnosti }
                     else PresnostNova:=1/(Int(Presnost/Koef));
    if PresnostNova>=0.999 then PresnostNova:=0.5;
    t:=0;Color:=Farba;PredX:=321;PredY:=0;BPom:=BPrvy;
    repeat
      ti[1]:=1 -3*t +3*t*t -1*t*t*t; { vzorec pre Coonsovu kubiku - koeficienty }
      ti[2]:=4      -6*t*t +3*t*t*t;
      ti[3]:=1 +3*t +3*t*t -3*t*t*t;
      ti[4]:=              +1*t*t*t;
      SumaX:=0;SumaY:=0;BPom2:=BPom;
      for i:=1 to 4 do begin
        SumaX:=SumaX+ti[i]*BPom2^.x; { koeficienty sa nasobia riadiacimi bodmi }
        SumaY:=SumaY+ti[i]*BPom2^.y; { ide o parametricku funkciu - spline }
        BPom2:=BPom2^.BDal;          { spline = po castiach polynom }
      end;
   { umiestnenie pismena na obrazovke - pridanie suradnic a zmensenie}
      SumaX:=SumaX/6/Koef+PosX;SumaY:=SumaY/6/Koef+PosY;
      if PredX<321 then begin
{$IFDEF PlnaVerzia}
        Ciara(PredX,PredY,Round(SumaX),Round(SumaY));
{$ELSE}
        Line(PredX,PredY,Round(SumaX),Round(SumaY));
{$ENDIF}
      end;
      PredX:=Round(SumaX); { ciara od predosleho bodu }
      PredY:=Round(SumaY);
      t:=t+PresnostNova;
      if t>=1.001 then begin
        t:=0;              { dalsia kubika }
        BPom:=BPom^.BDal;
      end;
    until BPom^.BDal^.BDal^.BDal=nil;
  end;
  if Koef=1 then begin { riadiace body len v originalnej velkosti }
    if self.BPrvy=Font.Akt^.KAkt^.BPrvy then PorC:=1 else PorC:=2;
    Color:=Farba;
    if self.BPrvy<>nil then begin
      BPom:=self.BPrvy;
      repeat       { vykresli vsetky riadiace body }
        if Farba>0 then begin
          if (BPom=BAkt) and (PorC=1) then
            PrilepBMPP(BPom^.x-3,BPom^.y-3,Menu.MBP[13]);
          PrilepBMPP(BPom^.x+PorC-3,BPom^.y+PorC-3,Menu.MBP[PorC])
        end else VyplnPlochu(BPom^.x-3,BPom^.y-3,7,7); { vymaz ich }
        BPom:=BPom^.BDal;
      until BPom=nil;
    end;
  end;
end;
procedure TKrivka.NastavKrivku;
begin
  VM;
  KresliKrivku(0,0,1,0);
  VykresliMGP(Menu.MGPP[4],@Menu.MBP,@Menu.MSFP);
  ZM;
  repeat
    PrepisUdajeOKrivke;
    Udalost2:=ObsluzUdalost(@Aktiv5,@Klav5);
    if Udalost2=1 then begin
      VM;
      PrilepBMP(126,81,Menu.MBP[12]);
      Citaj(128,83,3,s);
      with Font.Akt^.KAkt^ do begin
        Val(s,i,w);
        if i>255 then i:=255;
        Presnost:=i;
        if Presnost=0 then Presnost:=1;
      end;
      PrepisUdajeOKrivke;
      ZM;
    end;
    if Udalost2=2 then Menu.StavOK(True);
    CakajNaPustenie;
    Menu.StavOK(False);
  until Udalost2=2;
  VM;
  Menu.ZmazPlochu;
  Menu.KresliOstatne;
  Font.Akt^.KresliPismeno(0,0,1,15);
  ZM;
end;
procedure TKrivka.PrepisUdajeOKrivke;
begin
  VM;
  PrilepBMP(126,81,Menu.MBP[12]);
  Str(Font.Akt^.KAkt^.Presnost,s);
  VypisP(128,83,Menu.MSFP[1],s,Zelena);
  ZM;
end;
