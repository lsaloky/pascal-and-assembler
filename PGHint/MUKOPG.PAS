program Finta_na_Panzer_Generala; {verzia 2.0}
{$I mukopom.pas}
BEGIN
{ ----- inicializacia ----- }
  NahodnaBMP(320,200,0,PozP);
  PriemerujBMP(PozP);
  UpravJasBMP(PozP,2,3);
  NacitajPaletu('Prechody.MP',PalP);
  NacitajFont('Hlavny8.MSF',MSFP[1]);
  NacitajFont('Hlavny15.MSF',MSFP[2]);
  Assign(f,'MukoPG.MGP');
  Reset(f,1);
  Seek(f,16);
  for i:=1 to PocetMGP do NacitajMGP(f,MGPP[i]);
  Close(f);
  Assign(f,'MukoPG.MB');
  Reset(f,1);
  Seek(f,769);
  for i:=1 to PocetMB do NacitajBMP(f,pointer(MBP[i]));
  Close(f);
  InicializujGrafiku;
  NastavPaletu(PalP);
  InitHl;
  VykresliMGP(MGPP[1],@MBP,@MSFP);
  AttrCitaj.Font:=MSFP[1];
  ZM;
  VypinajMys:=True;
  CisloZbrane:=1;
  CisloDivizie:=1;
  Assign(FZbran,Path+'dat\PanzEqup.EQP');
  Reset(FZbran,1);
  BlockRead(FZbran,MaxZbrani,2);
  for i:=0 to MaxZbrani-1 do begin
    BlockRead(FZbran,Zbran,50);
    NazovZbrane[i][0]:=#20;
    for j:=1 to 20 do
      if Zbran.Nazov[j]=#0
        then NazovZbrane[i][j]:=' '
        else NazovZbrane[i][j]:=Zbran.Nazov[j];
  end;
  Seek(FZbran,2);
{ ----- HLAVNY PROGRAM ----- }
  repeat
    Udalost:=ObsluzUdalost(@HlAktiv,@HlKlav);
    InitHl;
    case Udalost of
{ ----- globalne nastavenia ----- }
      1:begin
        Zmeneny:=False;
        VykresliMGP(MGPP[2],@MBP,@MSFP);
        InitP1;
        repeat
          Udalost2:=ObsluzUdalost(@P1Aktiv,@P1Klav);
          if Udalost2>0 then begin
            x:=P1Aktiv[Udalost2,1];       {suradnice aktivneho udaju}
            y:=P1Aktiv[Udalost2,2];
          end;
          case Udalost2 of
            1:begin { poradove cislo zbrane }
              UlozZbran;
              PrilepBMP(x,y,MBP[2]);
              Citaj(x+3,y+2,3,s);
              if s[1]='-' then Delete(s,1,1);
              if s<>'' then Val(s,CisloZbrane,Err);
              CisloZbrane:=CisloZbrane mod MaxZbrani;
              InitP1;
            end;
            2:begin { + 1 zbran }
              UlozZbran;
              if CisloZbrane<MaxZbrani then Inc(CisloZbrane);
              PrilepBMP(P1Aktiv[1,1],P1Aktiv[1,2],MBP[2]);
              Str(CisloZbrane,s);
              VypisPO(P1Aktiv[1,1]+3,P1Aktiv[1,2]+2,MSFP[1],s,Zlta);
              InitP1;
            end;
            3:begin { - 1 zbran }
              UlozZbran;
              if CisloZbrane>0 then Dec(CisloZbrane);
              PrilepBMP(P1Aktiv[1,1],P1Aktiv[1,2],MBP[2]);
              Str(CisloZbrane,s);
              VypisPO(P1Aktiv[1,1]+3,P1Aktiv[1,2]+2,MSFP[1],s,Zlta);
              InitP1;
            end;
            4..16:begin { udaje o zbrani }
              PrilepBMP(x,y,MBP[2]);
              Citaj(x+3,y+2,3,s);
              if s<>'' then begin
                Val(s,i,Err);
                if i<>KompZbran[Udalost2] then Zmeneny:=True;
                KompZbran[Udalost2]:=i;
              end;
              KompToZbran;
            end;
          end;
          CakajNaPustenie;
        until Udalost2=0;
        UlozZbran;
      end;
{ ----- lokalne nastavenia ----- }
      2:begin
        VykresliMGP(MGPP[3],@MBP,@MSFP);
        repeat
          Udalost2:=ObsluzUdalost(@P2Aktiv,@P2Klav);
          case Udalost2 of
            1:begin { NAHRAJ }
              CakajNaPustenie;
              SuboroveOkno(MSFP[1],'Nahratie .SAV s`uboru:','*.SV*',Nazov);
              InitHl;
              VykresliMGP(MGPP[3],@MBP,@MSFP);
              VykresliMGP(MGPP[5],@MBP,@MSFP);
              if Nazov<>'' then begin
                Zmeneny:=False;
                Assign(FDivizia,Nazov);
                Reset(FDivizia,1);
                ZacDivizie:=FileSize(FDivizia)-24005;
                KonDivizie:=FileSize(FDivizia);
                InitP3;
              end;
            end; { case 1 }
            2:begin { ULOZ }
{!!!!!UlozDiviziu}
              CakajNaPustenie;
              SuboroveOkno(MSFP[1],'Ulo~zenie .SAV s`uboru:','*.SV*',Nazov);
              InitHl;
              VykresliMGP(MGPP[3],@MBP,@MSFP);
              VykresliMGP(MGPP[5],@MBP,@MSFP);
              if Nazov<>'' then begin

              end;
            end; { case 2 }
          end; { case }
        until Udalost2=0;
      end;
{ ----- o autorovi ----- }
      3:begin
        VykresliMGP(MGPP[4],@MBP,@MSFP);
        ReadLn;
      end;
    end;
    InitHl;
    VykresliMGP(MGPP[1],@MBP,@MSFP);
  until Udalost=4;
{ ----- ukoncenie programu ----- }
  ZavriGrafiku;
  WriteLn('MukoSoft pomocnik pre Panzer Generala'#13#10'Lubos Saloky, 1998');
  Close(FZbran);
{  Close(FDivizia);}
END.