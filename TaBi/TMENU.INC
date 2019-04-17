const HlAktiv:array[1..8,1..4] of word=(
        (17,92,97,108),(17,112,97,128),(17,152,97,168),(17,132,97,148),
        (101,180,129,192),(224,45,313,80),(221,118,276,191),(400,0,0,0));
      HlKlav:array[1..8] of char=('s','o','k','n','p',#0,#0,#255);
      EscAktiv:array[1..6,1..4] of word=(
{!!!!! zapnutie zvuku !!!!!} (0,0,0,0),(155,65,171,81),(177,65,193,81),(101,86,221,102),
        (101,107,221,123),(400,0,0,0));
      EscKlav:array[1..6] of char=('z','-','+','p','h',#255);
      NastAktiv:array[1..24,1..4] of word=(
        (37, 65,81, 77), (187,65,231,77), (37, 140,81, 152),(187,140,231,152),
        (107,65,151,77), (257,65,301,77), (107,140,151,152),(257,140,301,152),
        (37, 82,81, 94), (187,82,231,94), (37, 157,81, 169),(187,157,231,169),
        (107,82,151,94), (257,82,301,94), (107,157,151,169),(257,157,301,169),
        (37, 99,81, 111),(187,99,231,111),(37, 174,81, 186),(187,174,231,186),
        (107,99,151,111),(257,99,301,111),(107,174,151,186),(257,174,301,186));
      NastKlav:char=#255;
procedure TMenu.NastavenieOvladania;
var NUdalost:word;
    AktPovelP:byte;
begin
  VykresliMGP(MGPP[4],@MBP,@MSFP);
  Tank1.VypisStavOvladania;
  Tank2.VypisStavOvladania;
  Tank3.VypisStavOvladania;
  Tank4.VypisStavOvladania;
  repeat
    NUdalost:=ObsluzUdalost(@NastAktiv,@NastKlav);
    if (NUdalost>0) and (NUdalost<25) then begin
      Mys.CakajNaPustenie;
      VM;
      PrilepBMP(NastAktiv[NUdalost,1],NastAktiv[NUdalost,2]+1,MBP[29]);
      AktPovelP:=0;
      repeat
        Mys.ZistiPoziciu(word(i),word(j),b);
        if b>0 then AktPovelP:=254;
        Joystick.ZistiPoziciu(word(i),word(j),b);
        if b>0 then AktPovelP:=255;
        if (AktPovelP=255) and (Povel.Kalibrovany=False) then begin
          ZM;
          for i:=1 to 30 do CakajNaVOI;
          Kalibracia;
          ZmazObrazovku;
          VykresliMGP(MGPP[4],@MBP,@MSFP);
          Tank1.VypisStavOvladania;
          Tank2.VypisStavOvladania;
          Tank3.VypisStavOvladania;
          Tank4.VypisStavOvladania;
          VM;
        end;
        for i:=0 to 127 do if Zoznam^[i]>0 then AktPovelP:=i;
        if StavLock and KAlt>0 then AktPovelP:=132;
        if StavLock and KCtrl>0 then AktPovelP:=131;
        if StavLock and KLShift>0 then AktPovelP:=130;
        if StavLock and KPShift>0 then AktPovelP:=129;
      until AktPovelP>0;
      j:=1;     { prekodovanie na index do pola DefPovel tanku }
      case (NUdalost-1) div 4 +1 of
        1:j:=3;
        2:j:=4;
        3:j:=1;
        4:j:=2;
        5:j:=5;
        6:j:=6;
      end;
      if NUdalost mod 4 = 1 then Tank1.DefPovel[j]:=Chr(AktPovelP);
      if NUdalost mod 4 = 2 then Tank2.DefPovel[j]:=Chr(AktPovelP);
      if NUdalost mod 4 = 3 then Tank3.DefPovel[j]:=Chr(AktPovelP);
      if NUdalost mod 4 = 0 then Tank4.DefPovel[j]:=Chr(AktPovelP);
      Tank1.VypisStavOvladania;
      Tank2.VypisStavOvladania;
      Tank3.VypisStavOvladania;
      Tank4.VypisStavOvladania;
      ZM;
    end; { if }
  until NUdalost=0;
end;
constructor TMenu.Init;
begin
  Randomize;
  for i:=0 to 255 do MapMBP[i]:=nil;
  Hrac[1]:=2;
  Hrac[2]:=2;
  Hrac[3]:=3;
  Hrac[4]:=2;
  AktMapa:=1;
  PocetPartii:=4;
  NacitajPaletu('Prechody.MP',PalP);
  NacitajFont('Hlavny8.MSF',MSFP[1]);
  AttrCitaj.Font:=MSFP[1];
{ ----- procesy ----- }
  Assign(f,'TaBi.MGP');
  Reset(f,1);
  Seek(f,16);
  for i:=1 to PocetMGP do NacitajMGP(f,MGPP[i]);
  Close(f);
  InicializujGrafiku;
  NastavPaletu(PalP);
  VypinajMys:=False;
  VypinajMys:=True;
  ZM;
  SBVoiceInt:=12;SBMasterInt:=12;
end;
procedure TMenu.NacitajMapu;
var PocetMB2:byte;
begin
{ ----- bitmapy k mape ----- }
  case AktMapa of
    1:s:='Planina';
    2:s:='PoloPust';
    3:s:='Krajina';
  end;
  Assign(f,s+'.MB');
  Reset(f,1);
  Seek(f,768);
  BlockRead(f,PocetMB2,1);
  for i:=0 to PocetMB2-1 do begin
    if MapMBP[i]<>nil then FreeMem(MapMBP[i],256+4);
    NacitajBMP(f,Menu.MapMBP[i]);
  end;
  Close(f);
{ ----- mapa ----- }
  for i:=0 to 79 do for j:=0 to 59 do Mapa[i,j]:=0;
  FillChar(Mapa,SizeOf(Mapa),0);
  Assign(f,s+'.MAP');
  Reset(f,1);
  BlockRead(f,HlavickaMAP,16);
  RozX:=HlavickaMAP[1];
  RozY:=HlavickaMAP[2];
  PocX:=(80-RozX) div 2;
  PocY:=(60-RozY) div 2;
  for i:=0 to RozY-1 do
    for j:=0 to RozX-1 do
      BlockRead(f,Mapa[PocX+j,PocY+i],1);
  Close(f);
  NastavPoziciuTankov;
end;
procedure TMenu.HlavneMenu;
  procedure Obnov;
  begin
    Color:=6;
    VyplnPlochu(231,35+12,8,12*3-1); { mazanie bodiek }
    for i:=1 to 4 do VyplnPlochu(211+14*i,108+12*1,8,6*12-1);
    PrilepBMPP(231,35+12*AktMapa,MBP[21]);
    for i:=1 to 4 do               { kreslenie bodiek }
      PrilepBMPP(211+14*i,108+12*(Hrac[i]+(Hrac[i] div 3)),MBP[21]);
    PrilepBMP(101,180,MBP[8]);
    Str(PocetPartii,s);
    VypisP(104,183,MSFP[1],s,Zlta);
  end;
begin
  ZmazObrazovku;
  VykresliMGP(MGPP[6],@Menu.MBP,@Menu.MSFP);
  Obnov;
  repeat
    HlUdalost:=ObsluzUdalost(@HlAktiv,@HlKlav);
    case HlUdalost of
      1:begin { start }
        Hra;
        ZmazObrazovku;
        VykresliMGP(MGPP[6],@Menu.MBP,@Menu.MSFP);
        Obnov;
      end;
      2:begin { nastavenie ovladania }
        if (((Tank1.DefPovel[1]=#255) and (Hrac[1]=2)) or
            ((Tank2.DefPovel[1]=#255) and (Hrac[2]=2)) or
            ((Tank3.DefPovel[1]=#255) and (Hrac[3]=2)) or
            ((Tank4.DefPovel[1]=#255) and (Hrac[4]=2))) and
            (Povel.Kalibrovany=False) then Kalibracia;
        ZmazObrazovku;
        NastavenieOvladania;
        ZmazObrazovku;
        VykresliMGP(MGPP[6],@Menu.MBP,@Menu.MSFP);
        Obnov;
      end;
      4:begin { napoveda }
        VykresliMGP(MGPP[8],@MBP,@MSFP);
        CitajZnak;
        VykresliMGP(MGPP[10],@MBP,@MSFP);
        CitajZnak;
        ZmazObrazovku;
        VykresliMGP(MGPP[6],@Menu.MBP,@Menu.MSFP);
        Obnov;
      end;
      5:begin { pocet partii }
        PrilepBMP(101,180,MBP[8]);
        Citaj(104,183,2,s);
        Val(s,PocetPartii,i);
        Obnov;
      end;
      6:begin { aktualna mapa }
        AktMapa:=(MysY-35) div 12;
        if AktMapa<1 then AktMapa:=1;
        if AktMapa>3 then AktMapa:=3;
        Obnov;
        Mys.CakajNaPustenie;
      end;
      7:begin { kto hra koho }
        i:=(MysX-207) div 14; { kto }
        if i<1 then i:=1;
        if i>4 then i:=4;
        j:=(MysY-106) div 12; { koho }
        if j<1 then j:=1;
        if j>6 then j:=6;
        if j>2 then Dec(j);
        Hrac[i]:=j;
        Obnov;
        Mys.CakajNaPustenie;
      end;
    end;
  until HlUdalost=3;
end;
procedure TMenu.Kalibracia;
begin
  ch:=#0;
  VykresliMGP(MGPP[1],@MBP,@MSFP);
  repeat
    JoyStick.ZistiPoziciu(word(Povel.JXStred),word(Povel.JYStred),Povel.JTlac);
    if JeZnak then ch:=CitajZnak;
  until (Povel.JTlac>0) or (ch=#27);
  for j:=1 to 6 do CakajNaVOI;
  Povel.CNPTJ;
  VykresliMGP(MGPP[2],@MBP,@MSFP);
  repeat
    JoyStick.ZistiPoziciu(word(Povel.JXMin),word(Povel.JYMin),Povel.JTlac);
    if JeZnak then ch:=CitajZnak;
  until (Povel.JTlac>0) or (ch=#27);
  for j:=1 to 20 do CakajNaVOI;
  Povel.CNPTJ;
  VykresliMGP(MGPP[3],@MBP,@MSFP);
  repeat
    JoyStick.ZistiPoziciu(word(Povel.JXMax),word(Povel.JYMax),Povel.JTlac);
    if JeZnak then ch:=CitajZnak;
  until (Povel.JTlac>0) or (ch=#27);
  for j:=1 to 20 do CakajNaVOI;
  Povel.CNPTJ;
  if ch<>#27 then Povel.Kalibrovany:=True else Povel.Kalibrovany:=False;
end;
destructor TMenu.Done;
begin
  ZavriZoznam;
  ZavriGrafiku;
  WriteLn('MukoSoft tankove bitky'#13#10'Lubos Saloky, 1999');
end;
procedure TMenu.KresliMapuVStrede;
  procedure NastavSpravnuFarbu(z:integer);
  begin
    case z of
      36..70:Color:=57;
      16..35:Color:=41;
      else Color:=25;
    end;
  end;
begin
{ ----- kreslenie zivota tankov ----- }
  Color:=0;
  VyplnPlochu(153,0,6,70-Tank1.Zivot);
  VyplnPlochu(162,0,6,70-Tank2.Zivot);
  VyplnPlochu(153,131,6,70-Tank3.Zivot);
  VyplnPlochu(162,131,6,70-Tank4.Zivot);
  NastavSpravnuFarbu(Tank1.Zivot);
  if Tank1.Zivot>0 then VyplnPlochu(153,69-Tank1.Zivot,6,Tank1.Zivot);
  NastavSpravnuFarbu(Tank2.Zivot);
  if Tank2.Zivot>0 then VyplnPlochu(162,69-Tank2.Zivot,6,Tank2.Zivot);
  NastavSpravnuFarbu(Tank3.Zivot);
  if Tank3.Zivot>0 then VyplnPlochu(153,200-Tank3.Zivot,6,Tank3.Zivot);
  NastavSpravnuFarbu(Tank4.Zivot);
  if Tank4.Zivot>0 then VyplnPlochu(162,200-Tank4.Zivot,6,Tank4.Zivot);
{ ----- ramcek v strede ----- }
  Color:=107;
  Ramcek(119,69,82,62,100);
  Color:=15;
  Obdlznik(119+PocX,69+PocY,RozX+2,RozY+2);
end;
procedure TMenu.VypisElevacnyUhol;
begin
  Color:=100;
  VyplnPlochu(4+32,4,24,8);
  Str(Tank1.ElevacnyUhol*180/pi+0.01:0:0,s);
  VypisP(4+32+2,4,Menu.MSFP[1],s,Zlta);
  VyplnPlochu(172+32,4,24,8);
  Str(Tank2.ElevacnyUhol*180/pi+0.01:0:0,s);
  VypisP(172+32+2,4,Menu.MSFP[1],s,Zlta);
  VyplnPlochu(4+32,190,24,8);
  Str(Tank3.ElevacnyUhol*180/pi+0.01:0:0,s);
  VypisP(4+32+2,190,Menu.MSFP[1],s,Zlta);
  VyplnPlochu(172+32,190,24,8);
  Str(Tank4.ElevacnyUhol*180/pi+0.01:0:0,s);
  VypisP(172+32+2,190,Menu.MSFP[1],s,Zlta);
end;
procedure TMenu.HerneMenu;
var HUdalost:word;
begin
  VSeg:=$A000;
  VykresliMGP(MGPP[7],@MBP,@MSFP);
  ZM;
  for i:=1 to 30 do CakajNaVOI;
  repeat
    HUdalost:=ObsluzUdalost(@EscAktiv,@EscKlav);
    case HUdalost of
      2:if SBVoiceInt>0 then begin
        Dec(SBVoiceInt);
        NastavHlasitost(SBVoice,SBVoiceInt,SBVoiceInt);
      end;
      3:if SBVoiceInt<15 then begin
        Inc(SBVoiceInt);
        NastavHlasitost(SBVoice,SBVoiceInt,SBVoiceInt);
      end;
      4:begin
        KoniecPartie:=True;
        HUdalost:=0;
      end;
      5:begin
        Menu.AktPartia:=PocetPartii;
        KoniecPartie:=True;
        HUdalost:=0;
      end;
    end;
  until HUdalost=0;
  VM;
  VSeg:=RealTime.VVRamSeg;
end;
procedure TMenu.Hra;
begin
  VM;
  VypinajMys:=False;
  VSeg:=RealTime.VVRamSeg;
  NacitajMapu;

  for Menu.AktPartia:=1 to PocetPartii do begin
    NastavPoziciuTankov;
{    if Hrac[1]=1 then begin Tank1.x:=RozX*16;Tank1.y:=RozY*16;end;
    if Hrac[2]=1 then begin Tank2.x:=RozX*16;Tank2.y:=RozX*16;end;
    if Hrac[3]=1 then begin Tank3.x:=RozX*16;Tank3.y:=RozX*16;end;
    if Hrac[4]=1 then begin Tank4.x:=RozX*16;Tank4.y:=RozX*16;end;}
    KoniecPartie:=False;
    repeat
      RealTime.SpracujUdalosti;
      if Zoznam^[1]>0 then HerneMenu;
    until KoniecPartie;
    VyhodnoteniePartie;
    Tank1.ObnovNastavenia;
    Tank2.ObnovNastavenia;
    Tank3.ObnovNastavenia;
    Tank4.ObnovNastavenia;
  end;

  VSeg:=$A000;
  VypinajMys:=True;
  ZM;
end;
procedure TMenu.VyhodnoteniePartie;
begin
  VSeg:=$A000;
  VykresliMGP(MGPP[9],@MBP,@MSFP);
  Str(AktPartia,s);
  if AktPartia=PocetPartii then s:='posledna';
  VypisP(160,60,MSFP[1],s+'.',Cervena);
  Str(Tank1.Body,s);
  VypisP(180,73,MSFP[1],s,SvetloModra);
  Str(Tank2.Body,s);
  VypisP(180,86,MSFP[1],s,SvetloModra);
  Str(Tank3.Body,s);
  VypisP(180,99,MSFP[1],s,SvetloModra);
  Str(Tank4.Body,s);
  VypisP(180,112,MSFP[1],s,SvetloModra);
  for i:=1 to 60 do CakajNaVOI;
  CitajZnak;
  VSeg:=RealTime.VVRamSeg;
end;
procedure TMenu.NastavPoziciuTankov;
begin
  Tank1.x:=80;
  Tank1.y:=40;
  Tank2.x:=RozX*16-80;
  Tank2.y:=40;
  Tank3.x:=80;
  Tank3.y:=RozY*16-60;
  Tank4.x:=RozX*16-80;
  Tank4.y:=RozY*16-60;
  Tank1.xr:=Tank1.x;
  Tank1.yr:=Tank1.y;
  Tank2.xr:=Tank2.x;
  Tank2.yr:=Tank2.y;
  Tank3.xr:=Tank3.x;
  Tank3.yr:=Tank3.y;
  Tank4.xr:=Tank4.x;
  Tank4.yr:=Tank4.y;
end;