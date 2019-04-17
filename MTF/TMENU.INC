constructor TMenu.Init;
begin
  NacitajPaletu('Prechody.MP',Menu.PalP);
  NacitajFont('Hlavny8.MSF',Menu.MSFP[1]);
  Assign(f,'MTFEdit.MB');
  Reset(f,1);
  Seek(f,769);
  for i:=1 to PocetMB do NacitajBMP(f,Menu.MBP[i]);
  Close(f);
  Assign(f,'MTFEdit.MGP');
  Reset(f,1);
  Seek(f,16);
  for i:=1 to PocetMGP do NacitajMGP(f,Menu.MGPP[i]);
  Close(f);
  AttrCitaj.Font:=Menu.MSFP[1];
  InicializujGrafiku;
  ZM;
  NastavPaletu(Menu.PalP);
  ZmazObrazovku;
  VykresliMGP(Menu.MGPP[2],@Menu.MBP,@Menu.MSFP);
  PrilepBMPP(248,17,Menu.MBP[11]);
  VypisPamat;

  BZas:=nil;
  KZas:=nil;
  PZas:=nil;
  Objekt:=3;
  KresliOstatne;
end;

procedure TMenu.Novy;
begin
  VM;
  Tlacidlo3D(246,65,32,24,MSFP[1],' ',9,3,True);
  PrilepBMPP(251,70,Menu.MBP[3]);
  ZM;
  case Objekt of
    3:Oznam;
    4:begin
      Font.PridajPismeno;
      VM;
      Menu.ZmazPlochu;
      Menu.KresliOstatne;
      Menu.VypisPamat;
      ZM;
    end;
    5:begin
      Font.Akt^.PridajKrivku;
      VM;
      Font.Akt^.KresliPismeno(0,0,1,0);
      Font.Akt^.KresliPismeno(0,0,1,15);
      Menu.VypisPamat;
      ZM;
    end;
    6:Oznam;
  end;
end;

procedure TMenu.Predosly;
begin
  VM;
  Tlacidlo3D(246,93,32,24,MSFP[1],' ',9,3,True);
  if Objekt=3 then PrilepBMPP(251,98,Menu.MBP[9])
              else PrilepBMPP(251,98,Menu.MBP[5]);
  ZM;
  case Objekt of
    3:Font.NahrajFont;
    4:Font.PredoslePismeno;
    5:Font.Akt^.PredoslaKrivka;
    6:Font.Akt^.KAkt^.PredoslyBod;
  end;
end;

procedure TMenu.Dalsi;
begin
  VM;
  Tlacidlo3D(283,93,32,24,MSFP[1],' ',9,3,True);
  if Objekt=3 then PrilepBMPP(288,98,Menu.MBP[10])
              else PrilepBMPP(288,98,Menu.MBP[6]);
  ZM;
  case Objekt of
    3:Font.UlozFont;
    4:Font.DalsiePismeno;
    5:Font.Akt^.DalsiaKrivka;
    6:Font.Akt^.KAkt^.DalsiBod;
  end;
end;

procedure TMenu.Nastav;
begin
  VM;
  Tlacidlo3D(246,121,32,24,MSFP[1],' ',9,3,True);
  PrilepBMPP(251,126,Menu.MBP[7]);
  ZM;
  case Objekt of
    3:Font.NastavFont;
    4:Font.Akt^.NastavPismeno;
    5:Font.Akt^.KAkt^.NastavKrivku;
    6:Font.Akt^.KAkt^.BAkt^.NastavBod;
  end;
end;

procedure TMenu.Odstran;
begin
  VM;
  Tlacidlo3D(283,65,32,24,MSFP[1],' ',9,3,True);
  if Objekt=3 then PrilepBMPP(288,70,Menu.MBP[8])
              else PrilepBMPP(288,70,Menu.MBP[4]);
  ZM;
  case Objekt of
    3:begin { koniec programu }
      VykresliMGP(Menu.MGPP[7],@Menu.MBP,@Menu.MSFP);
      Udalost2:=ObsluzUdalost(@AktivAnoNie,@KlavAnoNie);
      if Udalost2=1 then begin
        VM;Tlacidlo3D(55,108,48,16,Menu.MSFP[1],'`Ano',9,3,True);ZM;
        Koniec:=True;
        CakajNaPustenie;
      end else begin
        VM;Tlacidlo3D(135,108,48,16,Menu.MSFP[1],'Nie',9,3,True);ZM;
        Koniec:=False;
        CakajNaPustenie;
        Menu.ZmazPlochu;
        Menu.KresliOstatne;
        Font.Akt^.KresliPismeno(0,0,1,15);
      end;
    end;
    4:Oznam;
    5:with Font.Akt^ do begin { krivka }
        OdoberKrivku;
        if PocetKriviek=0 then PridajKrivku;
        VM;
        Menu.ZmazPlochu;
        Menu.KresliOstatne;
        KresliPismeno(0,0,1,15);
        Menu.VypisPamat;
        ZM;
      end;
    6:begin { bod }
      Font.Akt^.KAkt^.OdoberBod;
      VM;
      Menu.ZmazPlochu;
      Menu.KresliOstatne;
      Font.Akt^.KresliPismeno(0,0,1,15);
      Menu.VypisPamat;
      ZM;
    end;
  end;
end;

procedure TMenu.Kopiruj;
begin
  VM;
  if Objekt>3 then begin
    Tlacidlo3D(283,121,32,24,MSFP[1],' ',9,3,True);
    PrilepBMPP(288,126,MBP[14]);
  end;
  ZM;
  case Objekt of
    4:PZas:=Font.Akt;
    5:KZas:=Font.Akt^.KAkt;
    6:BZas:=Font.Akt^.KAkt^.BAkt;
  end;
end;
procedure TMenu.Prilep;
var BPom2:PBod;
begin
  VM;
  if Objekt>3 then begin
    Tlacidlo3D(283,121,32,24,MSFP[1],' ',9,3,True);
    PrilepBMPP(288,126,MBP[14]);
  end;
  ZM;
  case Objekt of
    4:begin
      Menu.Oznam;
    end;
    5:if KZas<>nil then begin
      BPom2:=KZas^.BPrvy;
      if Font.Akt^.KAkt^.PocetB>0 then Font.Akt^.PridajKrivku;
      Font.Akt^.KAkt^.Presnost:=KZas^.Presnost;
      while BPom2<>nil do begin
        Font.Akt^.KAkt^.PridajBod(BPom2^.x,BPom2^.y);
        BPom2:=BPom2^.BDal;
      end;
    end;
    6:if BZas<>nil then Font.Akt^.KAkt^.PridajBod(BZas^.x,BZas^.y);
  end;
  ZmazPlochu;
  KresliOstatne;
  VypisPamat;
  Font.Akt^.KresliPismeno(0,0,1,15);
end;
procedure TMenu.Testuj;
begin
  VykresliMGP(MGPP[11],@MBP,@MSFP);
  repeat
    Udalost2:=ObsluzUdalost(@AktivTest,@KlavTest);
    case Udalost2 of
      1:begin
        VM;
        PrilepBMP(63,129,Menu.MBP[12]);
        PrilepBMP(88,129,Menu.MBP[12]);
        PrilepBMP(113,129,Menu.MBP[12]);
        Citaj(65,131,9,s);
        Color:=8;
        VyplnPlochu(21,64,198,61);
        VypisText(23,66,4,s);
        ZM;
      end;
      2:Menu.StavOK(True);
    end;
    CakajNaPustenie;
    Menu.StavOK(False);
  until Udalost2=2;
  Menu.ZmazPlochu;
  Menu.KresliOstatne;
  Font.Akt^.KresliPismeno(0,0,1,15);
  Menu.VypisPamat;
end;
procedure TMenu.Chyba(Cislo:byte);
begin
  case Cislo of
    255:WriteLn('Chyba pri odstranovani bodu !!!');
    254:WriteLn('Chyba pri presune na predosly bod !!!');
    253:WriteLn('Chyba pri presune na predoslu krivku !!!');
    252:WriteLn('Chyba pri odstranovani krivky !!!');
  end;
end;

procedure TMenu.KresliOstatne;
begin
  VM;
  Color:=69;
  if Font.Y1>0 then CiaraVodorovna(0,Font.Y1,239);
  if Font.Y2>0 then CiaraVodorovna(0,Font.Y2,239);
  if Font.Y3>0 then CiaraVodorovna(0,Font.Y3,239);
  if Font.Y4>0 then CiaraVodorovna(0,Font.Y4,239);
  Color:=68;
  if Font.Akt^.XMin>0 then CiaraZvisla(Font.Akt^.XMin,0,191);
  if Font.Akt^.XMax>0 then CiaraZvisla(Font.Akt^.XMax,0,191);
  Color:=8;
  VyplnPlochu(241,149,78,39);
  VypisP(290,165,MSFP[1],'Test',Zlta);
  VypisP(290,165,MSFP[1],'T',Cervena);
  Font.Akt^.KresliPismeno(243,149,5,15);
  ZM;
end;
procedure TMenu.VypisPamat;
begin
  Color:=8;
  VyplnPlochu(241,2,78,11);
  Str(MemAvail,s);
  VypisP(260,4,MSFP[1],s,Zelena);
end;
procedure TMenu.ZmazPlochu;
begin
  VM;
  Color:=0;
  VyplnPlochu(0,0,240,195);
  ZM;
end;
procedure TMenu.StavOK(Stlaceny:Boolean);
begin
  VM;
  Tlacidlo3D(175,126,40,16,MSFP[1],'OK',9,3,Stlaceny);
  ZM;
end;
procedure TMenu.VypisText(PosX,PosY:word;Koef:byte;Slovo:string);
var pom:integer;
begin
  w:=PosX;
  for pom:=1 to Length(Slovo) do begin
    PPom:=Font.PPrve;
    while (PPom^.Ascii<>Ord(Slovo[pom])) and (PPom^.PDal<>nil) do PPom:=PPom^.PDal;
    if PPom^.Ascii=Ord(Slovo[pom]) then begin
      PPom^.KresliPismeno(w,PosY,Koef,15);
      w:=w+Round((PPom^.XMax-PPom^.XMin+Font.Medzera)/Koef);
      if w>200 then pom:=Length(Slovo);
    end;
  end;
end;
procedure TMenu.Oznam;
begin
  VykresliMGP(MGPP[12],@MBP,@MSFP);
  Udalost2:=ObsluzUdalost(@AktivOznam,@KlavOznam);
  StavOK(True);
  CakajNaPustenie;
  StavOK(False);
  Menu.ZmazPlochu;
  Menu.KresliOstatne;
  Font.Akt^.KresliPismeno(0,0,1,15);
end;