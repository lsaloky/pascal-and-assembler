program Stolne_hry;
{$I Trum-sum.Inc}
BEGIN
  Inicializuj;
  Hra:=TureckaDama;
{ ----- inicializacia hracieho planu ----- }
  AktHrac:=1;BolTah:=False;
  FillChar(Pohyb,SizeOf(Pohyb),0);
  Case Hra of
    TureckaDama:begin
      RozX:=24;RozY:=24;PocHrac:=2;
      for sx:=0 to 7 do
        for sy:=0 to 7 do begin
          Nastav(sx*24,sy*24,0);
          PrilepBitmapu(24,24,OfsP24);
        end;
      Pohyb[0,-1,0]:=1;{kde sa moze pohnut pesiak}
      Pohyb[0,1,0]:=1;
      Pohyb[0,0,1]:=1;
      Pohyb[0,-2,0]:=1;{skok - kontroluje sa az potom, ci je tam figurka}
      Pohyb[0,2,0]:=1;
      Pohyb[0,0,2]:=1;
      SmerX[1]:=1;SmerY[1]:=1;{natocenie hracieho planu pre daneho hraca}
      SmerX[2]:=1;SmerY[2]:=-1;
      PocetFigur[1]:=16;PocetFigur[2]:=16;
      for sx:=-7 to 7 do Pohyb[1,sx,0]:=1;{a kde vezir}
      for sx:=-7 to 7 do Pohyb[1,0,sx]:=1;
      for sy:=0 to 7 do begin
        PrilepFigurku(Ofs24,sy*24+7680,Farba[1]);
        Sachovnica[sy+1,2]:=1;
        PrilepFigurku(Ofs24,sy*24+15360,Farba[1]);
        Sachovnica[sy+1,3]:=1;
        PrilepFigurku(Ofs24,sy*24+38400,Farba[2]);
        Sachovnica[sy+1,6]:=2;
        PrilepFigurku(Ofs24,sy*24+46080,Farba[2]);
        Sachovnica[sy+1,7]:=2;
      end;
    end;
  end;
{ ----- inicializacia veci nezavislych na hracom plane ----- }
  Nastav(240,0,0);
  VypisPriehladne(NaTahu1+#13+NaTahu2,SvetloModra);
  for sx:=0 to 4 do begin
    Nastav(240,30+20*sx,15);
    Ramcek(72,16,8);
    Nastav(244,34+20*sx,0);
    VypisPriehladne(TlacStr[sx+1],Zlta);
  end;
    Nastav(264,8,Farba[AktHrac]+10);
    VyplnPlochu(50,20);
  ZapniKurzorMysi;
{ ----- hra ----- }
  repeat
    repeat
      ZistiPoziciu(x,y,Tlacidla);
    until Tlacidla>0;
    x:=x div 2;
    if x<240 then begin
      case Hra of
        TureckaDama:begin
          Move(Policka24x24[1,0],Buffer,576);
          x:=x div 24;y:=y div 24;
          StaryX:=x*24;StaryY:=y*24;
          if Sachovnica[x+1,y+1] and $03=AktHrac then NastavKurzor(StaryX*2,StaryY);
          if (x<8) and (y<8) and (Tlacidla=1) and
             (Sachovnica[x+1,y+1] and $03=AktHrac) then begin
            VypniKurzorMysi;
            AktFarba:=Farba[Sachovnica[x+1,y+1]];
            OknoKurzora(0,336,0,168);
            repeat
              ZistiPoziciu(NovyX,NovyY,Tlacidla);
              NovyX:=NovyX div 2;
              if (StaryX<>NovyX) or (StaryY<>NovyY) then begin
                CakajNaVOI;
                Nastav(StaryX,StaryY,0);
                PrilepBitmapu(RozX,RozY,Ofs(Buffer));
                Nastav(NovyX,NovyY,0);
                StiahniBitmapu(RozX,RozY,Ofs(Buffer));
                PrilepFigurku(Ofs24,NovyX+320*NovyY,AktFarba);
                StaryX:=NovyX;StaryY:=NovyY;
                BolTah:=True;
              end;
              NovyX:=(NovyX+12) div 24;NovyY:=(NovyY+12) div 24;
              sx:=SmerX[AktHrac]*(Integer(NovyX)-Integer(x));{suradnice cieloveho policka v poli Pohyb}
              sy:=SmerY[AktHRac]*(Integer(NovyY)-Integer(y));
              PomB:=Sachovnica[x+1+sx div 2,y+1+sy div 2];
              if (Tlacidla=0) and (
                 (Sachovnica[NovyX+1,NovyY+1]>0) or         {je tam figurka}
                 (Pohyb[Sachovnica[x+1,y+1] shr 2,sx,sy]=0)){nie je dovoleny pohyb}
              then begin
                NovyX:=x;NovyY:=Y;BolTah:=False;
              end;
              if (Tlacidla=0) and ((Abs(sx)=2) or (Abs(sy)=2)) and (Pohyb[Sachovnica[x+1,y+1] shr 2,sx,sy]=1) then begin
                sx:=sx*SmerX[AktHrac];sy:=sy*SmerY[AktHrac];
                PomB:=Sachovnica[x+1+sx div 2,y+1+sy div 2];
                Sachovnica[x+1+sx div 2,y+1+sy div 2]:=0;{vypadla figurka}
                Nastav(24*(x+sx div 2),24*(y+sy div 2),0);
                PrilepBitmapu(24,24,Ofs(Policka24x24));
                Dec(PocetFigur[PomB]);
              end;
            until Tlacidla=0;
            OknoKurzora(0,639,0,199);
            Nastav(StaryX,StaryY,0);
            PrilepBitmapu(RozX,RozY,Ofs(Buffer));
            PrilepFigurku(Ofs24,NovyX*24+320*24*NovyY,AktFarba);
            PomB:=Sachovnica[x+1,y+1];
            Sachovnica[x+1,y+1]:=0;
            Sachovnica[NovyX+1,NovyY+1]:=PomB;
            Nastav(x*24,y*24,0);
            PrilepBitmapu(24,24,OfsP24);
            PrilepFigurku(Ofs24,NovyY*320*24+NovyX*24,AktFarba);
            ZapniKurzorMysi;
          end;
        end;
      end;
      if BolTah then begin
        Inc(AktHrac);
        if AktHrac>PocHrac then AktHrac:=1;
        Nastav(264,8,Farba[AktHrac]+10);
        VypniKurzorMysi;
        VyplnPlochu(50,20);
        ZapniKurzorMysi;
        BolTah:=False;
      end;
    end else begin
      case y of
        30..46:Udalost:=1;
        50..66:Udalost:=2;
        70..86:Udalost:=3;
        90..106:Udalost:=4;
        110..126:Udalost:=5;
      end;
{ ----- spracovanie veci nezavislych na hracom plane ----- }
      if x>312 then Udalost:=0;
      case Udalost of
        1:Koniec:=True;
      end;
    end;
  until Koniec;
  ZavriGrafiku;
END.