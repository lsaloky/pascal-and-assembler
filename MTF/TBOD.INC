procedure TBod.RucneNastavenie;
var Cas:longint;
begin        { posuvanie bodov krivky }
  with Font.Akt^ do
    if (KAkt<>nil) and (KAkt^.PocetB>3) then begin
      BPom:=KAkt^.BPrvy;
      Najdeny:=False;
      repeat           { hladaj body, ktore su blizko kliknutia }
        if Abs(integer(MysX)-BPom^.x)+Abs(integer(MysY)-BPom^.y)<4 then begin
          Najdeny:=True;
          BNajdeny:=BPom;
        end;
        BPom:=BPom^.BDal;
      until (BPom=nil) or Najdeny;{ body sa posuvaju len po jednom (Najdeny) }
      if Najdeny then begin
        Font.Akt^.KAkt^.BAkt:=BNajdeny;
        Cas:=MemL[$0040:$006C];
        repeat
          VM;
          CakajNaVOI;
          KAkt^.KresliKrivku(0,0,1,0);
          if MemL[$0040:$006C]>Cas+3 then begin
            BNajdeny^.x:=MysX;        { presun ich }
            BNajdeny^.y:=MysY;
          end;
          KAkt^.KresliKrivku(0,0,1,15);
          Menu.KresliOstatne;
          ZM;
          ZistiPoziciu(MysX,MysY,b);  { zisti, ci pouzivatel pustil tlacidlo }
          MysX:=MysX div 2;
          if MysX<3 then MysX:=3;
          if MysY<3 then MysY:=3;
          if MysY>189 then MysY:=189;
          if MysX>236 then MysX:=236;
        until b=0;
      end; { end if Najdeny }
    end; { if PocetB>4 }
  Font.Akt^.KresliPismeno(0,0,1,15);
end; { case 257 }

procedure TBod.NastavBod;
begin
  VM;
  VykresliMGP(Menu.MGPP[5],@Menu.MBP,@Menu.MSFP);
  ZM;
  repeat
    PrepisUdajeOBode;
    Udalost2:=ObsluzUdalost(@Aktiv6,@Klav6);
    case Udalost2 of
      1,2:begin
        VM;
        PrilepBMP(Aktiv6[Udalost2,1],Aktiv6[Udalost2,2],Menu.MBP[12]);
        Citaj(Aktiv6[Udalost2,1]+2,Aktiv6[Udalost2,2]+2,3,s);
        Val(s,i,w);
        if i<3 then i:=3;
        if (i>237) and (Udalost2=1) then i:=237;
        if (i>188) and (Udalost2=2) then i:=188;
        if Udalost2=1 then Font.Akt^.KAkt^.BAkt^.x:=i;
        if Udalost2=2 then Font.Akt^.KAkt^.BAkt^.y:=i;
        PrepisUdajeOBode;
        ZM;
      end;
      3:Menu.StavOK(True);
    end;
    CakajNaPustenie;
    Menu.StavOK(False);
  until Udalost2=3;
  VM;
  Menu.ZmazPlochu;
  Menu.KresliOstatne;
  Font.Akt^.KresliPismeno(0,0,1,15);
  ZM;
end;
procedure TBod.PrepisUdajeOBode;
begin
  VM;
  PrilepBMP(43,81,Menu.MBP[12]);
  Str(Font.Akt^.KAkt^.BAkt^.x,s);
  VypisP(45,83,Menu.MSFP[1],s,Zelena);
  PrilepBMP(43,94,Menu.MBP[12]);
  Str(Font.Akt^.KAkt^.BAkt^.y,s);
  VypisP(45,96,Menu.MSFP[1],s,Zelena);
  ZM;
end;
