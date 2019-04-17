constructor TPismeno.Init;
begin
  PocetKriviek:=0;
  KPrva:=nil;
  KAkt:=nil;
  XMin:=20;
  XMax:=200;
  Ascii:=0;
  PridajKrivku;
end;
procedure TPismeno.PridajKrivku;
begin
  if KPrva=nil then begin
    New(KPrva);
    KAkt:=KPrva;
    KAkt^.Init;
    KPrva^.KDal:=nil;
  end else begin
    KPom:=KPrva;
    while KPom^.KDal<>nil do KPom:=KPom^.KDal;
    New(KPom^.KDal);
    KPom^.KDal^.KDal:=nil;
    KAkt:=KPom^.KDal;
    KAkt^.Init;
  end;
  Inc(PocetKriviek);
  KAkt:=KPrva;
  while KAkt^.KDal<>nil do KAkt:=KAkt^.KDal;
end;
function TPismeno.OdoberKrivku:boolean;
begin
  if KPrva=nil then OdoberKrivku:=False  { nic tam nie je }
  else begin
    if KAkt=KPrva then begin             { odstranenie prvej krivky }
      repeat until not KAkt^.OdoberBod;
      KPrva:=KAkt^.KDal;
      Dispose(KAkt);
      KAkt:=KPrva;
      OdoberKrivku:=True;
      Dec(PocetKriviek);
    end else begin                       { ostatne pripady }
      KPom:=KPrva;
      while (KPom^.KDal<>KAkt) and (KPom^.KDal<>nil) do KPom:=KPom^.KDal;
      if KPom^.KDal=nil then begin
        Menu.Chyba(252);
        OdoberKrivku:=False;
      end else begin
        KPom^.KDal:=KPom^.KDal^.KDal;
        repeat until not KAkt^.OdoberBod;
        Dispose(KAkt);
        KAkt:=KPom;
        OdoberKrivku:=True;
        Dec(PocetKriviek);
      end;
    end;
  end;
end;
procedure TPismeno.DalsiaKrivka;
begin
  KresliPismeno(0,0,1,0);
  if (KAkt<>nil) and (KAkt^.KDal<>nil) then KAkt:=KAkt^.KDal;
  KresliPismeno(0,0,1,15);
end;
procedure TPismeno.PredoslaKrivka;
begin
  KresliPismeno(0,0,1,0);
  if KAkt<>KPrva then begin
    KPom:=KPrva;
    while (KPom^.KDal<>KAkt) and (KPom^.KDal<>nil) do KPom:=KPom^.KDal;
    if KPom^.KDal=nil then Menu.Chyba(253);
    KAkt:=KPom;
  end;
  KresliPismeno(0,0,1,15);
end;
procedure TPismeno.KresliPismeno(PosX,PosY:word;Koef,Farba:byte);
begin
  KPom:=KPrva;
  while KPom<>nil do begin
    if Koef=1 then KPom^.KresliKrivku(PosX,PosY,Koef,Farba)
              else KPom^.KresliKrivku(PosX-Round(XMin/Koef),PosY,Koef,Farba);
    KPom:=KPom^.KDal;
  end;
end;
procedure TPismeno.NastavPismeno;
begin
  VM;VykresliMGP(Menu.MGPP[3],@Menu.MBP,@Menu.MSFP);ZM;
  repeat
    PrepisUdajeOPismene;
    Udalost2:=ObsluzUdalost(@Aktiv4,@Klav4);
    case Udalost2 of
      1,3,4:begin
        VM;
        PrilepBMP(Aktiv4[Udalost2,1],Aktiv4[Udalost2,2],Menu.MBP[12]);
        Citaj(Aktiv4[Udalost2,1]+2,Aktiv4[Udalost2,2]+2,3,s);
        if Udalost2=1 then Val(s,Font.Akt^.XMin,w);
        if Udalost2=3 then Val(s,Font.Akt^.XMax,w);
        if Udalost2=4 then Val(s,Font.Akt^.Ascii,w);
        PrepisUdajeOPismene;
        ZM;
      end;
      2:begin
        Menu.Oznam;
        Udalost2:=5;
      end;
      5:Menu.StavOK(True);
    end;
    CakajNaPustenie;
    Menu.StavOK(False);
  until Udalost2=5;
  VM;
  Menu.ZmazPlochu;
  Menu.KresliOstatne;
  Font.Akt^.KresliPismeno(0,0,1,15);
  ZM;
end;
procedure TPismeno.PrepisUdajeOPismene;
begin
  VM;
  PrilepBMP(64,94,Menu.MBP[12]);
  Str(Font.Akt^.XMin,s);
  VypisP(66,96,Menu.MSFP[1],s,Zelena);
  PrilepBMP(64,107,Menu.MBP[12]);
  Str(Font.Akt^.XMax,s);
  VypisP(66,109,Menu.MSFP[1],s,Zelena);
  PrilepBMP(101,128,Menu.MBP[12]);
  Str(Font.Akt^.Ascii,s);
  VypisP(103,130,Menu.MSFP[1],s,Zelena);
  ZM;
end;
