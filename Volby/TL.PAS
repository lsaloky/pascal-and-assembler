var Zavaznost:word;

{ ----- KANCELARIA / TAJNA LINKA / KAUZA ----- }

const AktivTLKauza:array[1..6,1..4] of word=(
        (43,19,59,35),(127,19,141,35),(56,60,256,80),(80,108,240,124),
        (240,184,319,199),(400,0,0,0));
      KlavTLKauza:array[1..6] of char=('<','>',#8,'v','n',#255);
var ZoznamKauz:array[1..MaxKauz] of record
                 Obet:word;    {por. cislo strany}
                 Datum:TDatum;
                 Index:word;   {por. cislo v zozname kauz}
               end;
    PoslKauza:word;
procedure PridajKauzu(Obet,Index:word);
begin
  if PoslKauza=PocetKauz then PoslKauza:=0;  {na staru kauzu sa zabudne, aj ked sa na nu nereagovalo}
  Inc(PoslKauza);
  ZoznamKauz[PoslKauza].Obet:=Obet;
  ZoznamKauz[PoslKauza].Datum:=Datum;
  ZoznamKauz[PoslKauza].Index:=Index;
  Kauza[Index].Pouzita:=1;
  DostKauz:=True;
  s:=VsunNazovStrany(Kauza[Index].Znenie,Obet);
  VypisFormatovany(10,147,MSFP[1],s,SvetloModra,310);
  CakajNaUdalost;
end;
procedure OdstranKauzu(PorCislo:word);
begin
  Dec(PoslKauza);
  for i:=PorCislo+1 to MaxKauz do begin
    ZoznamKauz[i-1].Obet:=ZoznamKauz[i].Obet;
    ZoznamKauz[i-1].Datum:=ZoznamKauz[i].Datum;
    ZoznamKauz[i-1].Index:=ZoznamKauz[i].Index;
  end;
end;
procedure PrekresliTLKauza;
begin
  Color:=171;
  Ramcek(64,19,58,16,165);
  VypisPO(68,23,MSFP[1],NazovStrany[AktStrana],Zlta);
  PrilepBMP(Zavaznost,60,MBP[9]);
  if DostKauz then begin
    Color:=0;
    VyplnPlochu(80,108,160,16);
    VypisPO(80,111,MSFP[1],'1 kauza denne je maximum',Zlta);
  end;
end;
procedure TajnaLinkaKauza;
begin
  AktStrana:=1;
  Zavaznost:=56;
  VykresliMGP(MGPPomP[12],@MBP,@MSFP);
  repeat
    PrekresliTLKauza;
    Udalost:=ObsluzUdalost(@AktivTLKauza,@KlavTLKauza);
    case Udalost of
      0,5:StlacNaspat;
      1:Tlacidlo3D(43,19,16,16,MSFP[1],'<',10,3,True);
      2:Tlacidlo3D(127,19,16,16,MSFP[1],'>',10,3,True);
      4:if not DostKauz then begin
        Tlacidlo3D(80,108,160,16,MSFP[1],'Vyrob kauzu',10,3,True);
        VypisPO(120,113,MSFP[1],'V',6);
      end;
    end;
    CakajNaPustenie;
    case Udalost of
      1:begin
        Tlacidlo3D(43,19,16,16,MSFP[1],'<',10,3,False);
        if AktStrana>1 then begin
          Dec(AktStrana);
          PrekresliTLKauza;
        end;
      end;
      2:begin
        Tlacidlo3D(127,19,16,16,MSFP[1],'>',10,3,False);
        if AktStrana<PocetStran then begin
          Inc(AktStrana);
          PrekresliTLKauza;
        end;
      end;
      3:begin
        Color:=0;
        VyplnPlochu(Zavaznost,60,14,14);
        PrilepBMP(MysX,60,MBP[9]);
        Zavaznost:=MysX;
      end;
      4:if not DostKauz then begin
        Tlacidlo3D(80,108,160,16,MSFP[1],'Vyrob kauzu',10,3,False);
        VypisPO(120,113,MSFP[1],'V',6);
        i:=((Zavaznost-56)*PocetKauz) div 200;
        PridajKauzu(AktStrana,{i}1);
      {strata preferencii obvineneho subjektu}
        UpravGlobalnePref(ZoznamKauz[1].Obet,-Kauza[1].StrataPref);
      end;
      0,5:PustNaspat;
    end;
  until (Udalost=5) or (Udalost=0) or (Udalost=4);
end;

{ ----- KANCELARIA / TAJNA LINKA / OHOVARANIE ----- }

const AktivTLOhovaranie:array[1..6,1..4] of word=(
        (43,19,59,35),(127,19,141,35),(56,60,256,80),(80,108,240,124),
        (240,184,319,199),(400,0,0,0));
      KlavTLOhovaranie:array[1..6] of char=('<','>',#8,'v','n',#255);
var ZoznamOhovarani:array[1..MaxUrazok] of record
                 Obet:word;    {por. cislo strany}
                 Datum:TDatum;
                 Index:word;   {por. cislo v zozname ohovarani}
               end;
    PoslOhovaranie:word;

procedure PridajOhovaranie(Obet,Index:word);
begin
  if PoslOhovaranie=PocetUrazok then PoslOhovaranie:=0;  {na staru kauzu sa zabudne, aj ked sa na nu nereagovalo}
  Inc(PoslOhovaranie);
  ZoznamOhovarani[PoslOhovaranie].Obet:=Obet;
  ZoznamOhovarani[PoslOhovaranie].Datum:=Datum;
  ZoznamOhovarani[PoslOhovaranie].Index:=Index;
  Urazka[Index].Pouzita:=1;
  DostOhovarani:=True;
  s:=VsunNazovStrany(Urazka[Index].Znenie,Obet);
  VypisFormatovany(10,147,MSFP[1],s,SvetloModra,310);
  CakajNaUdalost;
end;
procedure OdstranOhovaranie(PorCislo:word);
begin
  Dec(PoslOhovaranie);
  for i:=PorCislo+1 to MaxUrazok do begin
    ZoznamOhovarani[i-1].Obet:=ZoznamOhovarani[i].Obet;
    ZoznamOhovarani[i-1].Datum:=ZoznamOhovarani[i].Datum;
    ZoznamOhovarani[i-1].Index:=ZoznamOhovarani[i].Index;
  end;
end;
procedure PrekresliTLOhovaranie;
begin
  Color:=171;
  Ramcek(64,19,58,16,165);
  VypisPO(68,23,MSFP[1],NazovStrany[AktStrana],Zlta);
  PrilepBMP(Zavaznost,60,MBP[9]);
  if DostOhovarani then begin
    Color:=0;
    VyplnPlochu(80,108,160,16);
    VypisPO(50,111,MSFP[1],'1 nechutn`y v`yrok denne je maximum',Zlta);
  end;
end;
procedure TajnaLinkaOhovaranie;
begin
  AktStrana:=1;
  Zavaznost:=56;
  VykresliMGP(MGPPomP[13],@MBP,@MSFP);
  repeat
    PrekresliTLOhovaranie;
    Udalost:=ObsluzUdalost(@AktivTLOhovaranie,@KlavTLOhovaranie);
    case Udalost of
      0,5:StlacNaspat;
      1:Tlacidlo3D(43,19,16,16,MSFP[1],'<',10,3,True);
      2:Tlacidlo3D(127,19,16,16,MSFP[1],'>',10,3,True);
      4:if not DostOhovarani then begin
        Tlacidlo3D(80,108,160,16,MSFP[1],'Vyrob v`yrok',10,3,True);
        VypisPO(120,113,MSFP[1],'V',6);
      end;
    end;
    CakajNaPustenie;
    case Udalost of
      1:begin
        Tlacidlo3D(43,19,16,16,MSFP[1],'<',10,3,False);
        if AktStrana>1 then begin
          Dec(AktStrana);
          PrekresliTLOhovaranie;
        end;
      end;
      2:begin
        Tlacidlo3D(127,19,16,16,MSFP[1],'>',10,3,False);
        if AktStrana<PocetStran then begin
          Inc(AktStrana);
          PrekresliTLOhovaranie;
        end;
      end;
      3:begin
        Color:=0;
        VyplnPlochu(Zavaznost,60,14,14);
        PrilepBMP(MysX,60,MBP[9]);
        Zavaznost:=MysX;
      end;
      4:if not DostOhovarani then begin
        Tlacidlo3D(80,108,160,16,MSFP[1],'Vyrob v`yrok',10,3,False);
        VypisPO(120,113,MSFP[1],'V',6);
        i:=((Zavaznost-56)*PocetUrazok) div 200;
        PridajOhovaranie(AktStrana,{i}1);
      {strata preferencii ohovaraneho subjektu}

        UpravGlobalnePref(ZoznamOhovarani[1].Obet,-0.02*Urazka[ZoznamOhovarani[1].Index].Sila);
      end;
      0,5:PustNaspat;
    end;
  until (Udalost=5) or (Udalost=0) or (Udalost=4);
end;

{ ----- KANCELARIA / TAJNA LINKA ----- }

const AktivTL:array[1..4,1..4] of word=(
        (94,21,194,51),(100,79,200,109),(240,184,319,199),(400,0,0,0));
      KlavTL:array[1..4] of char=('k','o','n',#255);
procedure TajnaLinka;
begin
  repeat
    VykresliMGP(MGPPomP[11],@MBP,@MSFP);
    Udalost:=ObsluzUdalost(@AktivTL,@KlavTL);
    if (Udalost=3) or (Udalost=0) then StlacNaspat;
    CakajNaPustenie;
    case Udalost of
      1:TajnaLinkaKauza;
      2:TajnaLinkaOhovaranie;
    end;
    if (Udalost=3) or (Udalost=0) then PustNaspat;
  until (Udalost=3) or (Udalost=0);
end;
