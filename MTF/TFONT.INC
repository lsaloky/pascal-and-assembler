constructor TFont.Init;
begin
  PPrve:=nil;
  Akt:=nil;
  Medzera:=20;
  Y1:=15;
  Y2:=80;
  Y3:=145;
  Y4:=175;
  Font.PocetPismen:=0;
  Font.PridajPismeno;
end;
procedure TFont.PridajPismeno;
begin
  if PPrve=nil then begin
    New(PPrve);
    Akt:=PPrve;
    Akt^.Init;
    PPrve^.PPred:=nil;
    PPrve^.PDal:=nil;
  end else begin
    PPom:=PPrve;
    while PPom^.PDal<>nil do PPom:=PPom^.PDal;  { prid na koniec }
    New(PPom^.PDal);
    Akt:=PPom^.PDal;
    Akt^.Init;
    PPom^.PDal^.PDal:=nil;
    PPom^.PDal^.PPred:=PPom;
  end;
  Inc(PocetPismen);
end;
function TFont.OdoberPismeno:boolean;
begin
  if PPrve=nil then OdoberPismeno:=False       { prazdny zoznam pismen }
  else begin
    if Akt=PPrve then begin                    { odstranujeme prve pismeno }
      PPrve:=PPrve^.PDal;
      repeat until not Akt^.OdoberKrivku;
      Dispose(Akt);
      Akt:=PPrve;
      Dec(PocetPismen);
      OdoberPismeno:=True;
    end else begin                             { ostatne pripady }
      PPom:=Akt^.PPred;
      PPom^.PDal:=PPom^.PDal^.PDal;
      repeat until not Akt^.OdoberKrivku;
      Dispose(Akt);
      Akt:=PPom;
      Dec(PocetPismen);
      OdoberPismeno:=True;
    end;
  end;
  Menu.VypisPamat;
end;
procedure TFont.DalsiePismeno;
begin
  VM;
  Menu.ZmazPlochu;
  if (Akt<>nil) and (Akt^.PDal<>nil) then Akt:=Akt^.PDal;
  Menu.KresliOstatne;
  Font.Akt^.KresliPismeno(0,0,1,15);
  ZM;
end;
procedure TFont.PredoslePismeno;
begin
  VM;
  Menu.ZmazPlochu;
  if (Akt<>nil) and (Akt^.PPred<>nil) then Akt:=Akt^.PPred;
  Menu.KresliOstatne;
  Font.Akt^.KresliPismeno(0,0,1,15);
  ZM;
end;
procedure TFont.NastavFont;
begin
  VM;VykresliMGP(Menu.MGPP[6],@Menu.MBP,@Menu.MSFP);ZM;
  repeat
    PrepisUdajeOFonte;
    Udalost2:=ObsluzUdalost(@Aktiv3,@Klav3);
    case Udalost2 of
      1..5:begin
        VM;
        PrilepBMP(Aktiv3[Udalost2,1],Aktiv3[Udalost2,2],Menu.MBP[12]);
        Citaj(Aktiv3[Udalost2,1]+2,Aktiv3[Udalost2,2]+2,3,s);
        if Udalost2=1 then Val(s,Font.Medzera,w);
        if Udalost2=2 then Val(s,Font.Y1,w);
        if Udalost2=3 then Val(s,Font.Y2,w);
        if Udalost2=4 then Val(s,Font.Y3,w);
        if Udalost2=5 then Val(s,Font.Y4,w);
        PrepisUdajeOFonte;
        ZM;
      end;
    6:Menu.StavOK(True);
    end;
    CakajNaPustenie;
    Menu.StavOK(False);
  until Udalost2=6;
  Menu.ZmazPlochu;
  Menu.KresliOstatne;
  Font.Akt^.KresliPismeno(0,0,1,15);
end;
procedure TFont.PrepisUdajeOFonte;
begin
  VM;
  PrilepBMP(96,81,Menu.MBP[12]);
  Str(Font.Medzera,s);
  VypisP(98,83,Menu.MSFP[1],s,Zelena);
  PrilepBMP(49,107,Menu.MBP[12]);
  Str(Font.Y1,s);
  VypisP(51,109,Menu.MSFP[1],s,Zelena);
  PrilepBMP(49,120,Menu.MBP[12]);
  Str(Font.Y2,s);
  VypisP(51,122,Menu.MSFP[1],s,Zelena);
  PrilepBMP(119,107,Menu.MBP[12]);
  Str(Font.Y3,s);
  VypisP(121,109,Menu.MSFP[1],s,Zelena);
  PrilepBMP(119,120,Menu.MBP[12]);
  Str(Font.Y4,s);
  VypisP(121,122,Menu.MSFP[1],s,Zelena);
  ZM;
end;
procedure TFont.UlozFont;
begin
  SuboroveOkno(Menu.MSFP[1],'Ulo~zenie p`isma','*.MTF',Nazov);
  Color:=0;
  VyplnPlochu(0,191,320,9);
  if Nazov<>'' then begin
    Assign(f,Nazov);
    ReWrite(f,1);
    b:=1;                          { hlavicka }
    BlockWrite(f,b,1);
    BlockWrite(f,PocetPismen,1);
    BlockWrite(f,Y1,1);
    BlockWrite(f,Y2,1);
    BlockWrite(f,Y3,1);
    BlockWrite(f,Y4,1);
    BlockWrite(f,Medzera,1);
    b:=0;
    for i:=1 to 9 do BlockWrite(f,b,1);
    PPom:=PPrve;
    while PPom<>nil do begin { cyklus pre pismeno }
      BlockWrite(f,PPom^.PocetKriviek,1); { zapis riadiacich udajov pismena }
      BlockWrite(f,PPom^.XMin,1);
      BlockWrite(f,PPom^.Xmax,1);
      BlockWrite(f,PPom^.Ascii,1);
      KPom:=PPom^.KPrva;
      while KPom<>nil do begin { cyklus pre krivku }
        BlockWrite(f,KPom^.Presnost,1); { zapis riadiacich udajov krivky }
        BlockWrite(f,KPom^.PocetB,1);
        BPom:=KPom^.BPrvy;
        while BPom<>nil do begin { cyklus pre bod }
          BlockWrite(f,BPom^.x,1); { zapis bodu }
          BlockWrite(f,BPom^.y,1);
          BPom:=BPom^.BDal;
        end;
        KPom:=KPom^.KDal;
      end;
      PPom:=PPom^.PDal;
    end;
    Close(f);
  end;
end;
procedure TFont.NahrajFont;
var pp,pk,pb:byte; { pocitanie poctu pismen, kriviek, bodov }
begin
  Nazov:='Pisane.MSF';
{$IFDEF PlnaVerzia}
  SuboroveOkno(Menu.MSFP[1],'Nahratie p`isma','*.MTF',Nazov);
  Color:=0;
  VyplnPlochu(0,191,320,9);
{$ENDIF}
  if Nazov<>'' then begin
    Assign(f,Nazov);
    Reset(f,1);
    BlockRead(f,b,1);   { hlavicka }
    BlockRead(f,pp,1);
    BlockRead(f,Y1,1);
    BlockRead(f,Y2,1);
    BlockRead(f,Y3,1);
    BlockRead(f,Y4,1);
    BlockRead(f,Medzera,1);
    for i:=1 to 9 do BlockRead(f,b,1);
    Akt:=PPrve;
    for i:=1 to pp do begin { cyklus pre pismeno }
      BlockRead(f,pk,1); { zapis riadiacich udajov pismena }
      BlockRead(f,Akt^.XMin,1);
      BlockRead(f,Akt^.Xmax,1);
      BlockRead(f,Akt^.Ascii,1);
      Akt^.KAkt:=Akt^.KPrva;
      for j:=1 to pk do begin { cyklus pre krivku }
        BlockRead(f,Akt^.KAkt^.Presnost,1); { zapis riadiacich udajov krivky }
        BlockRead(f,pb,1);
        for k:=1 to pb do begin { cyklus pre bod }
          BlockRead(f,b,1);
          BlockRead(f,c,1);
          Akt^.KAkt^.PridajBod(b,c);
        end;
        if j<pk then Akt^.PridajKrivku;
      end;
      if i<pp then PridajPismeno;
    end;
    Close(f);
{$IFDEF PlnaVerzia}
    VM;
    Menu.ZmazPlochu;
    Menu.KresliOstatne;
    Akt^.KresliPismeno(0,0,1,15);
    Menu.VypisPamat;
    ZM;
{$ENDIF}
  end;
end;
