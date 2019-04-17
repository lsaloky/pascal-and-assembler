program MukoSoftGrafickeProcesy;{Editor MGP verzia 1.1}
{$I MGP11.Inc}
procedure UlozMGP(s:string);
var i,PocetProcesov:word;
begin
  Assign(f,s);
  ReWrite(f,1);
  PocetProcesov:=0;
  for i:=1 to MaxProcesov do if Proces[i]<>nil then Inc(PocetProcesov);
  Hlavicka[2]:=PocetProcesov;
  BlockWrite(f,Hlavicka,16);
  for i:=1 to MaxProcesov do
    if Proces[i]<>nil then begin
      GenerujMGP(i);
      BlockWrite(f,MGP^,MGP^.Dlzka+2);
    end;
  Close(f);
end;
procedure NahrajMSF(s:string);
begin
  NacitajFont(s,pointer(MSF[PocetMSF]));
  Inc(PocetMSF);
end;
procedure NahrajMB(s:string);
var AktPocet:byte;
begin
  Assign(f,s);
  Reset(f,1);
  Seek(f,768);
  BlockRead(f,AktPocet,1);
  for i:=1 to AktPocet do NacitajBMP(f,pointer(MB[PocetMB+i-1]));
  Close(f);
  Inc(PocetMB,AktPocet);
end;
BEGIN
{ ----- inicializacia ----- }
  for i:=1 to MaxProcesov do Proces[i]:=nil;
  PridajProces;
  NahrajMSF('Hlavny8.MSF');
  NahrajMB('Mapdemo3.MB');
  GetMem(MGP,MaxDlzkaProcesu+2);
  NacitajPaletu('Prechody.MP',Pal);
  NacitajFont('Hlavny8.MSF',FP);
  AttrCitaj.Font:=FP;
  Assign(f,'MGP11.MB');
  Reset(f,1);
  Seek(f,769);
  for i:=1 to PocetBMP do NacitajBMP(f,BMP[i]);
  Close(f);
  Assign(f,'MGP11.MGP');
  Reset(f,1);
  Seek(f,16);
  for i:=1 to PocetMGP do NacitajMGP(f,EMGP[i]);
  Close(f);
  InicializujGrafiku;
  NastavPaletu(Pal);
  InicializujObrazovkuEditora;
  ZM;
  VypinajMys:=True;
  repeat
    Udalost:=ObsluzUdalostSHelpom(@Aktiv,@Klav,FP,@Pomoc);
    case Udalost of
      0:begin { Proces, Zobraz }
        GenerujMGP(AktProces);
        VM;
        ZmazObrazovku;
        ZM;
        VykresliMGP(MGP,@MB,@MSF);
        ReadLn;
        InicializujObrazovkuEditora;
      end;
      1:begin { MGP, Nahraj }
        SuboroveOkno(FP,'Nahratie .MGP s`uboru','*.MGP',s);
        NahrajMGP(s);
      end;
      2:begin { MGP, Uloz }
        SuboroveOkno(FP,'Ulo~zenie .MGP s`uboru','*.MGP',s);
        UlozMGP(s);
      end;
      3:begin { Proces, Predosly }
        if AktProces>0 then Dec(AktProces);
      end;
      4:begin { Proces, Cislo procesu}
        PrilepBMP(76,16,BMP[7]);
        Citaj(77,17,3,s);
        Val(s,AktProces,Err);
        PrepisHodnoty;
      end;
      5:begin { Proces, Nasledujuci }
        Inc(AktProces);
        if Proces[AktProces]=nil then PridajProces;
      end;
      6:begin { Proces, Odstran }
        OdstranProces;
      end;
      7:begin { Element, Predosly }
        with Proces[AktProces]^ do
          if AktElement>0 then begin
            Dec(AktElement);
            AktElementP:=AktElementP^.Predosly;
          end;
      end;
      8:begin { Element, Cislo elementu }
        PrilepBMP(76,29,BMP[7]);
        Citaj(77,30,3,s);
        with Proces[AktProces]^ do begin
          Val(s,AktElement,Err);
          AktElementP:=PrvyElement;
          for i:=1 to AktElement do AktElementP:=AktElementP^.Dalsi;
        end;
        PrepisHodnoty;
      end;
      9:begin { Element, Nasledujuci }
        with Proces[AktProces]^ do
          if AktElementP^.Dalsi<>nil then begin
            Inc(AktElement);
            AktElementP:=AktElementP^.Dalsi;
          end;
      end;
      10:begin { Element, Odstran }
      end;
      11:begin { Font, Predosly }
      end;
      12:begin { Font, Cislo fontu }
      end;
      13:begin { Font, Nasledujuci }
      end;
      14:begin { Font, Nahraj }
        SuboroveOkno(FP,'Nahratie .MSF s`uboru','*.MSF',s);
        NahrajMSF(s);
      end;
      15:begin { Bitmapa, Predosla }
      end;
      16:begin { Bitmapa, Cislo bitmapy }
      end;
      17:begin { Bitmapa, Nasledujuca }
      end;
      18:begin { Bitmapa, Nahraj }
      end;
      19:begin { Paleta, Predosla }
      end;
      20:begin { Paleta, Cislo palety }
      end;
      21:begin { Paleta, Nasledujuca }
      end;
      22:begin { Paleta, Nahraj }
      end;
{case 23 je koniec programu}
      24:begin { CiaraVodorovna }
      end;
      25:begin { CiaraZvisla }
      end;
      26:begin { PolozBod }
      end;
      27:begin { VyplnPlochu }
      end;
      28:begin { Ramcek }
      end;
      29:begin { Vypis }
      end;
      30:begin { VypisPO }
      end;
      31:begin { PrilepBMP }
      end;
      32:begin { Obdlznik }
      end;
      33:begin {Tlacidlo3D }
      end;
      34:begin {PrilepBMPPO }
      end;
    end; { case velky }
    if Udalost in [3,4,5,7,8,9,11,12,13,15,16,17,19,20,21] then PrepisHodnoty;
    CakajNaPustenie;
  until Udalost=23;
  FreeMem(MGP,MaxDlzkaProcesu+2);
END.
