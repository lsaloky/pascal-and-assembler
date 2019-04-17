uses MainGr,Mys,PomGr;
{pocet procesov max. 1024, pocet elementov v procese max. 65536}
const MaxProcesov=256; {kvoli hlavicke suboru}
      MaxDlzkaProcesu=64000;
      PocetBMP=8;
      PocetMGP=1;
      CCiaraVodorovna=1;
      CCiaraZvisla=2;
      CPolozBod=4;
      CVyplnPlochu=5;
      CRamcek=6;
      CVypis=7;
      CVypisPO=8;
      CPrilepBMP=9;
      CObdlznik=10;
      CTlacidlo3D=11;
      CPrilepBMPPO=12;
      ElementySRetazcom=[CVypis,CVypisPO,CTlacidlo3D];
      DlzElem:array[1..12] of byte=(8,8,0,6,10,11,8,8,6,10,14,6);
      PocetOP=34;
      Aktiv:array[1..PocetOP+1,1..4] of word=(
        (129,3,147,13),   {MGP,Nahraj}    (152,3,170,13),      {MGP,Uloz}
        (62,16,72,26),    {Proces,-}      (76,16,104,26),      {Proces,cislo}
        (108,16,118,26),  {Proces,+}      (129,16,139,26),     {Proces,Odstran}
        (62,29,72,39),    {Element,-}     (76,29,104,39),      {Element,cislo}
        (108,29,118,39),  {Element,+}     (129,29,139,39),     {Element,Odstran}
        (62,42,72,52),    {Font,-}        (76,42,104,52),      {Font,cislo}
        (108,42,118,52),  {Font,+}        (129,42,147,52),     {Font,Nahraj}
        (62,55,72,65),    {Bitmapa,-}     (76,55,104,65),      {Bitmapa,cislo}
        (108,55,118,65),  {Bitmapa,+}     (129,55,147,65),     {Bitmapa,Nahraj}
        (62,68,72,78),    {Paleta,-}      (76,68,104,78),      {Paleta,cislo}
        (108,68,118,78),  {Paleta,+}      (129,68,147,78),     {Paleta,Nahraj}
        (270,0,319,16),   {Koniec}
        (198,24,218,30),  {CiaraVodorovna}(190,27,196,42),      {CiaraZvisla}
        (200,32,206,38),  {PolozBod}      (224,27,239,42),      {VyplnPlochu}
        (245,27,260,42),  {Ramcek}        (265,27,280,42),      {Obdlznik}
        (285,27,300,42),  {Tlacidlo3D}    (196,47,218,55),      {Vypis}
        (196,58,218,66),  {VypisPO}       (237,47,253,55),      {PrilepBMP}
        (237,58,253,66),  {PrilepBMPPO}   (400,0,0,0));
     Klav:array[1..1] of char=#255;
     Pomoc:array[0..PocetOP]of string[40]=(
       ' ','Nahratie .MGP z disku','Ulo~zenie .MGP na disk','Predo~sl`y proces',
       '~C`islo aktu`alneho procesu','Nasleduj`uci proces','Odstr`a~n proces',
       'Predo~sl`y element','~C`islo elementu','Nasleduj`uci element',
       'Odstr`a~n element','Predo~sl`y font','~C`islo fontu','Nasleduj`uci font',
       'Nahratie .MSF z disku','Predo~sl`a bitmapa','~C`islo bitmapy',
       'Nasleduj`uca bitmapa','Nahratie .MB z disku','Predo~sl`a paleta',
       '~C`islo palety','Nasleduj`uca paleta','Nahratie .MP z disku',
       'Koniec programu','Vodorovn`a ~ciara','Zvisl`a ~ciara','Bod',
       'Vyplnenie plochy','R`am~cek','Obd`l~znik','Tla~cidlo s 3D efektom',
       'V`ypis textu','V`ypis textu prieh~ladne','Prilepenie bitmapy',
       'Prilepenie bitmapy prieh~ladne');
type PElement=^TElement;
     TElement=record
                PoziciaX,PoziciaY,RozmerX,RozmerY:word;
                Predosly,Dalsi:PElement;
                case Typ:byte of
                  1,2,4,5,10:(Farba:byte);
                  6:(FarbaObruby,FarbaVnutra:byte);
                  7,8:(CisloMSF:byte;Text:^string;Odtien:byte);
                  11:(CisloFontu:byte;Nadpis:^string;
                     OdtienTlacidla,OdtienTextu:byte;
                     Stlacene:boolean);
                  9,12:(CisloBMP:byte);
                end;
     PProces=^TProces;
     TProces=record
               PocetElementov,AktElement:word;
               PrvyElement,AktElementP:PElement;
             end;
     TMGP=record
               Dlzka:word;
               Data:array[0..MaxDlzkaProcesu-1] of byte;
             end;
{ ----- globalne premenne ----- }
var Proces:array[1..MaxProcesov] of PProces;
    AktProces,AktMB,AktMSF,AktMP,PocetMB,PocetMSF,PocetMP:word;
    i,j,Udalost,Err:integer;
    MGP:^TMGP;
    Pal,FP:pointer;
    BMP:array[1..PocetBMP] of pointer;
    MB:array[0..255] of ^BMPStruc;
    MSF:array[0..255] of ^FontStruc;
    MP:array[0..255] of pointer;
    EMGP:array[1..PocetMGP] of pointer;
    Hlavicka:array[1..16] of byte;
    f:file;
    s:string;
{ ----- procedury pre pracu s datovymi strukturami ----- }
procedure PridajProces;
var c1:word;
begin
  c1:=1;
  while Proces[c1]<>nil do Inc(c1);
  AktProces:=c1;
  New(Proces[AktProces]);
  with Proces[AktProces]^ do begin
    PocetElementov:=0;
    AktElement:=0;
    PrvyElement:=nil;
    AktElementP:=nil;
  end;
end;
procedure PridajElement;
var BunkaPred,BunkaAkt,BunkaPo:PElement;
    c1:word;
begin
  with Proces[AktProces]^ do begin
    BunkaPred:=PrvyElement;
    if AktElement>0 then
      for c1:=1 to AktElement-1 do BunkaPred:=BunkaPred^.Dalsi
    else begin { ak sa AktualnyElement=0, teda na zaciatok }
      BunkaPred:=nil;
      BunkaPo:=PrvyElement;
    end;
    if BunkaPred<>nil then BunkaPo:=BunkaPred^.Dalsi;
    New(BunkaAkt);
{ ----- pridanie na zaciatok zoznamu ----- }
    if BunkaPred=nil then begin
      PrvyElement:=BunkaAkt;
      if BunkaPo<>nil then BunkaPo^.Predosly:=BunkaAkt;
    end;
{ ----- pridanie na koniec zoznamu ----- }
    if (BunkaPred<>nil) and (BunkaPo=nil) then begin
      BunkaPred^.Dalsi:=BunkaAkt;
    end;
{ ----- pridanie do stredu zoznamu ----- }
    if (BunkaPred<>nil) and (BunkaPo<>nil) then begin
      BunkaPred^.Dalsi:=BunkaAkt;
      BunkaPo^.Predosly:=BunkaAkt;
    end;
    Inc(PocetElementov);
    BunkaAkt^.Dalsi:=BunkaPo;
    BunkaAkt^.Predosly:=BunkaPred;
  end; { with }

{!!!!!}  with BunkaAkt^ do begin
    Typ:=7;RozmerX:=2;RozmerY:=3;PoziciaX:=4;PoziciaY:=5;Odtien:=6;CisloMSF:=1;
    GetMem(Text,12);{!!!!! nezabudni pri praci s ElementySTlacidlom !!!!! }
    Text^:='Lubo Saloky';

  end;

end;
procedure OdstranElement;
var BunkaPred,BunkaPo:PElement;
begin
  with Proces[AktProces]^ do begin
    BunkaPred:=AktElementP^.Predosly;
    BunkaPo:=AktElementP^.Dalsi;
    if BunkaPred<>nil then BunkaPred^.Dalsi:=BunkaPo else PrvyElement:=BunkaPo;
    if BunkaPo<>nil then BunkaPo^.Predosly:=BunkaPred;
{ ----- praca s elementmi s ^string ----- }
    case AktElementP^.Typ of
      CVypis,CVypisPO:FreeMem(AktElementP^.Text,Length(AktElementP^.Text^)+1);
      CTlacidlo3D:FreeMem(AktElementP^.Nadpis,Length(AktElementP^.Nadpis^)+1);
    end;
    Dispose(AktElementP);
    AktElementP:=PrvyElement;
    AktElement:=1;
    Dec(PocetElementov);
  end;
end;
procedure OdstranProces;
var c1:word;
begin
  for c1:=1 to Proces[AktProces]^.PocetElementov do OdstranElement;
  Dispose(Proces[AktProces]);
  Proces[AktProces]:=nil;
end;
procedure GenerujMGP(CisloPr:word);
var p:PElement;
begin
  MGP^.Dlzka:=0;
  p:=Proces[CisloPr]^.PrvyElement;
  if p=nil Then MGP^.Dlzka:=0;
  while p<>nil do begin
    with MGP^ do begin
      Data[Dlzka]:=p^.Typ;           {toto je vzdy}
      Data[Dlzka+1]:=Lo(p^.PoziciaX);
      Data[Dlzka+2]:=Hi(p^.PoziciaX);
      Data[Dlzka+3]:=Lo(p^.PoziciaY);
      Data[Dlzka+4]:=Hi(p^.PoziciaY);
      case p^.Typ of
        CCiaraVodorovna:begin
          Data[Dlzka+5]:=Lo(p^.RozmerX);
          Data[Dlzka+6]:=Hi(p^.RozmerX);
          Data[Dlzka+7]:=p^.Farba;
        end;
        CCiaraZvisla:begin
          Data[Dlzka+5]:=Lo(p^.RozmerY);
          Data[Dlzka+6]:=Hi(p^.RozmerY);
          Data[Dlzka+7]:=p^.Farba;
        end;
        CPolozBod:Data[Dlzka+5]:=p^.Farba;
        CVyplnPlochu:begin
          Data[Dlzka+5]:=Lo(p^.RozmerX);
          Data[Dlzka+6]:=Hi(p^.RozmerX);
          Data[Dlzka+7]:=Lo(p^.RozmerY);
          Data[Dlzka+8]:=Hi(p^.RozmerY);
          Data[Dlzka+9]:=p^.Farba;
        end;
        CRamcek:begin
          Data[Dlzka+5]:=Lo(p^.RozmerX);
          Data[Dlzka+6]:=Hi(p^.RozmerX);
          Data[Dlzka+7]:=Lo(p^.RozmerY);
          Data[Dlzka+8]:=Hi(p^.RozmerY);
          Data[Dlzka+9]:=p^.FarbaObruby;
          Data[Dlzka+10]:=p^.FarbaVnutra;
        end;
        CVypis,CVypisPO:begin
          Data[Dlzka+5]:=p^.CisloMSF;
          Data[Dlzka+6]:=p^.Odtien;
          Move(p^.Text^,Data[Dlzka+7],Length(p^.Text^)+1);
        end;
        CPrilepBMP,CPrilepBMPPO:Data[Dlzka+5]:=p^.CisloBMP;
        CTlacidlo3D:begin
          Data[Dlzka+5]:=Lo(p^.RozmerX);
          Data[Dlzka+6]:=Hi(p^.RozmerX);
          Data[Dlzka+7]:=Lo(p^.RozmerY);
          Data[Dlzka+8]:=Hi(p^.RozmerY);
          Data[Dlzka+9]:=p^.CisloFontu;
          Data[Dlzka+10]:=p^.OdtienTextu;
          Data[Dlzka+11]:=p^.OdtienTlacidla;
          Data[Dlzka+12]:=byte(p^.Stlacene);
          Move(p^.Nadpis^,Data[Dlzka+13],Length(p^.Nadpis^)+1);
        end;
      end; { case }
      Inc(Dlzka,DlzElem[p^.Typ]);
{ ----- praca s elementmi s ^string ----- }
      case p^.Typ of
        CVypis,CVypisPO:Inc(Dlzka,Length(p^.Text^));
        CTlacidlo3D:Inc(Dlzka,Length(p^.Nadpis^));
      end;
    end; { with MGP^ }
    p:=p^.Dalsi;
  end; { while }
end;
procedure PrepisHodnoty;
var s:string;
    i:integer;
begin
  for i:=0 to 4 do PrilepBMP(76,16+13*i,BMP[7]);
  Str(AktProces,s);
  VypisPO(103-LengthPixel(FP,s),17,FP,s,Zlta);
  Str(Proces[AktProces]^.AktElement,s);
  VypisPO(103-LengthPixel(FP,s),30,FP,s,Zlta);
  Str(AktMSF,s);
  if PocetMSF>0 then VypisPO(103-LengthPixel(FP,s),43,FP,s,Zlta);
  Str(AktMB,s);
  if PocetMB>0 then VypisPO(103-LengthPixel(FP,s),56,FP,s,Zlta);
  Str(AktMP,s);
  if PocetMP>0 then VypisPO(103-LengthPixel(FP,s),69,FP,s,Zlta);
end;

procedure InicializujObrazovkuEditora;
begin
  ZmazObrazovku;
  VykresliMGP(EMGP[1],@BMP,@FP);
  PrepisHodnoty;
end;
procedure NahrajMGP(s:string);
var Dlzka,AktDlzka:word;
    DlzRet:byte;
    p,p2:^TElement;
begin
  Assign(f,s);
  Reset(f,1);
  BlockRead(f,Hlavicka,16);
  for i:=1 to MaxProcesov do
    if Proces[i]<>nil then begin
      AktProces:=i;
      OdstranProces;
    end;
  for i:=1 to Hlavicka[2] do begin {for - pre procesy}
    PridajProces;
    AktDlzka:=0;
    BlockRead(f,Dlzka,2);
    while AktDlzka<Dlzka do begin {while - pre elementy}
      New(p);
      with p^ do begin
        BlockRead(f,Typ,1);
        case Typ of
          CCiaraVodorovna:begin
            BlockRead(f,PoziciaX,2);
            BlockRead(f,PoziciaY,2);
            BlockRead(f,RozmerX,2);
            RozmerY:=1;
            BlockRead(f,Farba,1);
          end;
          CCiaraZvisla:begin
            BlockRead(f,PoziciaX,2);
            BlockRead(f,PoziciaY,2);
            RozmerX:=1;
            BlockRead(f,RozmerY,2);
            BlockRead(f,Farba,1);
          end;
          CPolozBod:begin
            BlockRead(f,PoziciaX,2);
            BlockRead(f,PoziciaY,2);
            RozmerX:=1;
            RozmerY:=1;
            BlockRead(f,Farba,1);
          end;
          CVyplnPlochu,CObdlznik:begin
            BlockRead(f,PoziciaX,2);
            BlockRead(f,PoziciaY,2);
            BlockRead(f,RozmerX,2);
            BlockRead(f,RozmerY,2);
            BlockRead(f,Farba,1);
          end;
          CRamcek:begin
            BlockRead(f,PoziciaX,2);
            BlockRead(f,PoziciaY,2);
            BlockRead(f,RozmerX,2);
            BlockRead(f,RozmerY,2);
            BlockRead(f,FarbaObruby,1);
            BlockRead(f,FarbaVnutra,1);
          end;
          CVypis,CVypisPO:begin
            BlockRead(f,PoziciaX,2);
            BlockRead(f,PoziciaY,2);
            BlockRead(f,CisloMSF,1);
            BlockRead(f,Odtien,1);
            BlockRead(f,DlzRet,1);
            GetMem(Text,DlzRet+1);
            Seek(f,FilePos(f)-1);
            BlockRead(f,Text^,DlzRet+1);
            Inc(AktDlzka,DlzRet);
            RozmerX:=LengthPixel(MSF[CisloMSF],Text^);
            RozmerY:=MSF[CisloMSF]^.Vyska+1;
          end;
          CPrilepBMP,CPrilepBMPPO:begin
            BlockRead(f,PoziciaX,2);
            BlockRead(f,PoziciaY,2);
            BlockRead(f,CisloBMP,1);
            RozmerX:=MB[CisloBMP]^.RozX;
            RozmerY:=MB[CisloBMP]^.RozY;
          end;
          CTlacidlo3D:begin
            BlockRead(f,PoziciaX,2);
            BlockRead(f,PoziciaY,2);
            BlockRead(f,RozmerX,2);
            BlockRead(f,RozmerY,2);
            BlockRead(f,CisloFontu,1);
            BlockRead(f,OdtienTlacidla,1);
            BlockRead(f,OdtienTextu,1);
            BlockRead(f,Stlacene,1);
            BlockRead(f,DlzRet,1);
            GetMem(Nadpis,DlzRet+1);
            Seek(f,FilePos(f)-1);
            BlockRead(f,Nadpis^,DlzRet+1);
            Inc(AktDlzka,DlzRet);
          end;
        end; { case }
{ ----- nadpojenie linearnych zoznamov ----- }
        if Proces[i]^.PrvyElement=nil then begin
          Proces[AktProces]^.PrvyElement:=p;
          p^.Predosly:=nil;
          p^.Dalsi:=nil;
        end else begin
          p2^.Dalsi:=p;
          p^.Predosly:=p2;
          p^.Dalsi:=nil;
        end; { if }
        p2:=p;
        Inc(AktDlzka,DlzElem[p^.Typ]);
        Proces[i]^.AktElement:=0;
        Proces[i]^.AktElementP:=Proces[i]^.PrvyElement;
      end; { with }
    end; { while }
  end; { for }
  Close(f);
  AktProces:=1;
  InicializujObrazovkuEditora;
end;
