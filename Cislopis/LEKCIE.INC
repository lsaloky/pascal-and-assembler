                { ----- vseobecny typ lekcie ----- }
constructor TLekcia.Init(var ftxt:text;PocetCisel:word;ACisloLekcie:byte);
begin
  ReadLn(ftxt);
  New(PrveCislo);
  ReadLn(ftxt,PrveCislo^.Hodnota);
  PrveCislo^.Dalsi:=nil;
  PosledneCislo:=PrveCislo;
  for i:=1 to PocetCisel-1 do begin
    New(Pom);                                    {pridavanie na koniec}
    ReadLn(ftxt,Pom^.Hodnota);
    Pom^.Dalsi:=nil;
    PosledneCislo^.Dalsi:=Pom;
    PosledneCislo:=Pom;
  end;
  PCisel:=PocetCisel;
  CisloLekcie:=ACisloLekcie;
  MusiBytBezChyby:=False;
end;

procedure TLekcia.Cakaj(Sekund:byte);            {LEN PRIBLIZNE}
var AktCas:longint;
begin
  AktCas:=MemL[$0040:$006C];
  repeat until MemL[$0040:$006C]>AktCas+18*Sekund;
  while JeZnak do CitajZnak;
end;

procedure TLekcia.VypisInfo;
begin
  CakajNaVOI;
  Color:=86;
  VyplnPlochu(50,191,24,8);
  VyplnPlochu(124,191,24,8);
  VyplnPlochu(230,191,24,8);
  Str(PocetChyb,s);
  VypisP(124,192,MSFP[Maly],s,Modra);
  Str(EsteCisel,s);
  VypisP(230,192,MSFP[Maly],s,Modra);
  Str(CisloLekcie,s);
  if CisloLekcie=100 then s:='---';  {nema cislo}
  VypisP(50,192,MSFP[Maly],s,Modra)
end;

procedure TLekcia.CitajCisla;
const MaxCisel=18;
var PosX,PocetVypisovanych:word;
    ZacStranky:PCislo;
    PomTimer:longint;
label KoniecL;
begin
  EsteCisel:=PCisel;
  PocetChyb:=0;
  PocetBkSp:=0;
  Koniec:=False;
  PocetNapisanychZnakov:=0;
  Rychlost:=2;
  Cas:=MemL[$0040:$006C];                        {pouzity casovac BIOSu}
  Pom:=PrveCislo;
  for j:=0 to PCisel div MaxCisel do begin
    VykresliMGP(MGPP[5],@MBP,@MSFP);
    VykresliMGP(MGPP[6+j div 2],@MBP,@MSFP);
    VypisInfo;
    if j<PCisel div MaxCisel then PocetVypisovanych:=MaxCisel
                             else PocetVypisovanych:=PCisel mod MaxCisel;
    ZacStranky:=Pom;
    for i:=0 to PocetVypisovanych-1 do begin
      VypisP(4,3+i*10,MSFP[Maly],Pom^.Hodnota,Zlta);
      Pom:=Pom^.Dalsi;
    end;
{ ----- citanie cisel; musi byt vlastna citacia procedura, aby som odchytil BkSP a pocital statistiky ----- }
    Pom:=ZacStranky;
    for i:=0 to PocetVypisovanych-1 do begin
      VypisInfo;
      PosX:=104;
      AktCislo:='';
      repeat
        Color:=4;
        PomTimer:=MemL[$0040:$006C];
        repeat
          if Abs(MemL[$0040:$006C]-PomTimer)>Rychlost then begin
            PomTimer:=MemL[$0040:$006C];
            if Color=15 then Color:=4 else Color:=15;
            VyplnPlochu(PosX,3+i*10,2,8);
          end;
        until JeZnak;
        ch:=CitajZnak;
        Color:=4;VyplnPlochu(PosX,3+i*10,2,8);
        Inc(PocetNapisanychZnakov);
        if ch in ['0'..'9','+','-','/','*','.'] then begin   {normalny znak}
          VypisP(PosX,3+i*10,MSFP[Maly],ch,Zlta);
          AktCislo:=AktCislo+ch;
          Inc(PosX,LengthPixel(MSFP[Maly],ch));
        end;
        if (ch=#8) and (not (MusiBytBezChyby)) then begin    {BackSpace}
          Inc(PocetBkSp);
          ch:=AktCislo[Length(AktCislo)];
          Dec(PosX,LengthPixel(MSFP[Maly],ch));
          Delete(AktCislo,Length(AktCislo),1);
          Color:=4;VyplnPlochu(PosX,3+i*10,LengthPixel(MSFP[Maly],ch),8);
        end;
        if ch=#27 then begin                     {Esc}
          Koniec:=True;
          goto KoniecL;
        end;
      until (ch=#13) or (Koniec);                {Enter}
      if AktCislo<>Pom^.Hodnota then Inc(PocetChyb);
      if (MusiBytBezChyby) and (PocetChyb>0) then begin
        Koniec:=True;
        goto KoniecL;
      end;
      Pom:=Pom^.Dalsi;
      Dec(EsteCisel);
    end;
  end;
  KoniecL:
  ch:=#0;
  Cas:=MemL[$0040:$006C]-Cas;
  EsteCisel:=PCisel;   {obnov tento udaj}
end;

procedure TLekcia.Vyhodnotenie;
const BaseY=115;    {pociatok vypisovania vyhodnocovacieho textu}
var Chybovost:real; {v percentach}
    UderovZaMin:real;
begin
  Chybovost:=PocetChyb/PCisel*100;
  UderovZaMin:=PocetNapisanychZnakov/(Cas/18.2/60);
  if not Koniec then begin
    VykresliMGP(MGPP[11],@MBP,@MSFP);
    Str(PCisel,s);
    VypisP(200,23,MSFP[Maly],s,Zlta);
    Str(PocetChyb,s);
    VypisP(200,36,MSFP[Maly],s,Zlta);
    Str(PocetBkSp,s);
    VypisP(200,49,MSFP[Maly],s,Zlta);
    Str(Chybovost:3:3,s);
    VypisP(200,62,MSFP[Maly],s,Zlta);
    Str(Cas/18.2:3:2,s);
    VypisP(200,75,MSFP[Maly],s,Zlta);
    Str(UderovZaMin:3:2,s);
    VypisP(200,88,MSFP[Maly],s,Zlta);
    if Chybovost>5 then begin
      VypisP(5,BaseY,MSFP[Maly],'Pri takejto vysokej chybovosti nebude',1);
      VypisP(5,BaseY+10,MSFP[Maly],'va~sa schopnos~t p`isa~t naslepo pou~zite~ln`a!',1);
    end;
    if (Chybovost>3) and (Chybovost<=5) then begin
      VypisP(5,BaseY,MSFP[Maly],'Pri takejto vysokej chybovosti budete ma~t',1);
      VypisP(5,BaseY+10,MSFP[Maly],'s p`isan`im naslepo viac probl`emov ako `u~zitku!',1);
    end;
    if (Chybovost>1) and (Chybovost<=3) then begin
      VypisP(5,BaseY,MSFP[Maly],'Po~cet ch`yb: vyhovuj`uci,',0);
      VypisP(5,BaseY+10,MSFP[Maly],'ale pracujte na zlep~sen`i!',0);
    end;
    if Chybovost<=1 then begin
      VypisP(5,BaseY,MSFP[Maly],'Po~cet ch`yb: dobr`y!,',0);
      VypisP(5,BaseY+10,MSFP[Maly],'ale nezaspite na vavr`inoch.',0);
    end;
    if PocetBkSp>10 then begin
      VypisP(5,BaseY+20,MSFP[Maly],'Velmi intenz`ivne pou~z`ivate kl`avesu BackSpace.',1);
      VypisP(5,BaseY+30,MSFP[Maly],'Nespoliehajte sa na to, ~ze chybu v~cas zbad`ate!',1);
    end;
    if (PocetBkSp>3) and (PocetBkSp<=10) then begin
      VypisP(5,BaseY+20,MSFP[Maly],'Je pekn`e, ~ze niektor`e chyby hne~d oprav`ite, ale',0);
      VypisP(5,BaseY+30,MSFP[Maly],'pri~cast`e pou~z`ivanie BackSpace v`as spoma~luje!',0);
    end;
    if (PocetBkSp<=3) and (Chybovost>3) then begin
      VypisP(5,BaseY+20,MSFP[Maly],'Rob`ite ve~la ch`yb, opravujte si ich',0);
      VypisP(5,BaseY+30,MSFP[Maly],'pomocou kl`avesy BackSpace.',0);
    end;
    if (PocetBkSp<=3) and (Chybovost<=3) then begin
      VypisP(5,BaseY+20,MSFP[Maly],'Gratulujem, dar`i sa v`am!',0);
      VypisP(5,BaseY+30,MSFP[Maly],'Len tak ~dalej.',0);
    end;
{ ----- ale, ale, volako mate naponahlo .... ----- }
    if (UderovZaMin>90) then begin
      if (Chybovost>3) or (PocetBkSp>5) then begin
        VypisP(5,BaseY+40,MSFP[Maly],'Spoma~lte a s`ustre~dte sa na bezchybnos~t.',0);
      end;
      if (Chybovost>1) and (Chybovost<=3) then begin
        VypisP(5,BaseY+40,MSFP[Maly],'M^o~zte p`isa~t aj pomal~sie,',0);
        VypisP(5,BaseY+50,MSFP[Maly],'malo by sa to prejavi~t na zn`i~zen`i po~ctu ch`yb.',0);
      end;
      if (PocetBkSp<=3) and (Chybovost<=3) then begin
        VypisP(5,BaseY+40,MSFP[Maly],'Aj r`ychlos~t je na jednotku.',0);
      end;
    end;
{ ----- Byt, ci nebyt? Zopakovat, alebo ideme dalej? ----- }
    if (Chybovost<3) and (PocetBkSp<5) then begin
      VypisP(100,180,MSFP[Maly],'Pokra~cujte ~dal~sou lekciou.',0);
    end else begin
      VypisP(100,180,MSFP[Maly],'Zopakujte si lekciu e~ste raz.',0);
    end;
    Cakaj(5);
    repeat
      ch:=CitajZnak;
    until ch in [#13,#27];
  end;
  ch:=#0;
end;

function TLekcia.PocetZnakovLekcie:word;
begin
  Pom:=PrveCislo;
  i:=Length(Pom^.Hodnota)+1;
  while (Pom^.Dalsi<>nil) do begin
    Pom:=Pom^.Dalsi;
    Inc(i,Length(Pom^.Hodnota)+1);
  end;
  PocetZnakovLekcie:=i;
end;

destructor TLekcia.Done;
begin
  while PrveCislo<>nil do begin   {zrusenie LZ cisel}
    Pom:=PrveCislo;
    PrveCislo:=PrveCislo^.Dalsi;
    Dispose(Pom);
  end;
end;

                { ----- uvodna lekcia ----- }

procedure TUvodna.Cvicenie;
label KoniecC;
begin
  ZmazObrazovku;
  VykresliMGP(MGPP[3],@MBP,@MSFP);
  repeat
    ch:=CitajZnak;
  until ch in [#13,#27];
  if ch=#27 then goto KoniecC;
  VykresliMGP(MGPP[4],@MBP,@MSFP);
  repeat
    ch:=CitajZnak;
    if UpCase(ch)='O' then begin
      NastavPaletu(HlavnyProgram.ExtraP);
      PrilepBMP(0,0,MBP[3]);
      CitajZnak;
      NastavPaletu(HlavnyProgram.MPP);
      VykresliMGP(MGPP[4],@MBP,@MSFP);
    end;
  until ch in [#13,#27];
  if ch=#27 then goto KoniecC;
  CitajCisla;
  Vyhodnotenie;
  KoniecC:
  ch:=#0;
end;

{ ----- klasicka lekcia ----- }

procedure TObycajna.Cvicenie;
begin
  VykresliMGP(MGPP[11+CisloLekcie],@MBP,@MSFP);
  repeat
    ch:=CitajZnak;
  until ch in [#13,#27];
  if ch<>#27 then begin
    ZmazObrazovku;
    CitajCisla;
    Vyhodnotenie;
  end;
end;

{ ----- specialne lekcie ----- }

procedure TRT.Cvicenie;
begin
  VykresliMGP(MGPP[AktualnyMGP],@MBP,@MSFP);
  repeat
    ch:=CitajZnak;
  until ch in [#13,#27];
  if ch<>#27 then begin
    ZmazObrazovku;
    CitajCisla;
    Vyhodnotenie;
  end;
end;

procedure TZaverecna.Cvicenie;
begin
  VykresliMGP(MGPP[18],@MBP,@MSFP);
  repeat
    ch:=CitajZnak;
  until ch in [#13,#27];
  if ch<>#27 then begin
    ZmazObrazovku;
    CitajCisla;
    Vyhodnotenie;
  end;
end;

procedure TZaverecna.Vyhodnotenie;
begin
  if not Koniec then begin
    VykresliMGP(MGPP[22],@MBP,@MSFP);
    Cakaj(2);
  end else begin
    Color:=29;
    Ramcek(50,80,235,40,0);
    VypisPO(60,83,MSFP[Maly],'Pom`ylil ste sa. V`yuka nem^o~ze',1);
    VypisPO(60,96,MSFP[Maly],'by~t pova~zovan`a za ukon~cen`u, k`ym',1);
    VypisPO(60,109,MSFP[Maly],'tento test nezvl`adnete.',1);
  end;
  repeat
    ch:=CitajZnak;
  until ch in [#13,#27];
  ch:=#0;
end;