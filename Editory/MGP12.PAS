program MGP12;{editor grafickych procesov verzia 1.2 beta}
{$I d:\lubo\pascal\editory\Editory.Inc}
{spolu s unitmi to ma 4219 riadkov kodu k 20.12.1997, o 18:40
                       +84 riadkov (Tlac) k 21.7.1998 o 18:40 }
{ ----- interne premenne a konstanty editora grafickych procesov ----- }

const MaxProcesov=40;MaxByteNaProces=1200;MaxElementov=1000;
      MaXXPreElementy=200;InfoY=85;PocetSlotov=6;
      PocetOP=51;
      Aktiv:array[1..PocetOP+1,1..4] of word=(
{ ----- aktivne oblasti v hlavnom menu ----- }
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
{ ----- elementy, od 24 ----- }
        (198,24,218,30),  {CiaraVodorovna}(190,27,196,42),      {CiaraZvisla}
        (200,32,206,38),  {PolozBod}      (224,27,239,42),      {VyplnPlochu}
        (245,27,260,42),  {Ramcek}        (196,47,218,55),      {Vypis}
        (196,58,218,66),  {VypisPO}       (237,47,253,55),      {PrilepBMP}
        (265,27,280,42),  {Obdlznik}      (285,27,300,42),      {Tlacidlo3D}
        (237,58,253,66),  {PrilepBMPPO}
{ ----- oblasti v ramceku Info, od 35 ----- }
        (56,101,84,111),  {Pozicia X}     (89,101,117,111),     {Pozicia Y}
        (321,0,322,1),    {volny slot 1}  (321,0,322,1),        {volny slot 4}
        (321,0,322,1),    {volny slot 2}  (321,0,322,1),        {volny slot 5}
        (321,0,322,1),    {volny slot 3}  (321,0,322,1),        {volny slot 6}
        (201,90,245,134), {Bitmapa, Edit} (201,140,311,165),    {Font, Edit}
        (291,90,311,110), {Paleta, Edit}
{ ----- dalsie elementy, pridane pri revizii ----- }
        (208,32,222,45),  {Ciara}         (305,27,320,42),      {Bezierova krivka}
        (272,53,280,61),  {Zmazanie obr.} (289,53,297,61),      {Nastav Farbu}
        (167,16,185,26),  {vytlac proces} (167,29,185,39),      {vytlac element}
        (400,0,0,0));         {Koniec Aktiv}
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
        'Vyplnenie plochy','R`am~cek','V`ypis textu','V`ypis textu prieh~ladne',
        'Prilepenie bitmapy','Obd`l~znik','Tla~cidlo s 3D efektom',
        'Prilepenie bitmapy prieh~ladne','Nastavenie poz`icie elementu',
        'Nastavenie poz`icie elementu','Edit`acia parametrov elementu',
        'Edit`acia parametrov elementu','Edit`acia parametrov elementu',
        'Edit`acia parametrov elementu','Edit`acia parametrov elementu',
        'Edit`acia parametrov elementu','Edit`acia aktu`alnej bitmapy',
        'Edit`acia aktu`alneho fontu','Edit`acia aktu`alnej palety',
        '~Ciara v~seobecne','B`ezierova krivka','Zmazanie obrazovky',
        'Nastavenie farby','Vytla~cenie procesu','Vytla~cenie elementu');
{ ----- aktualne oblasti zavisle na prave spracuvanom elemente ----- }
      EnhAktiv:array[1..15,1..PocetSlotov,1..4]of word=(
        ((56,112,84,122),(321,0,322,1),(56,123,84,133),(321,0,322,1),(321,0,322,1),(321,0,322,1)),{Ciara Vodorovna}
        ((56,112,84,122),(321,0,322,1),(56,123,84,133),(321,0,322,1),(321,0,322,1),(321,0,322,1)),{Ciara Zvisla}
        ((56,112,84,122),(321,0,322,1),(321,0,322,1),(321,0,322,1),(321,0,322,1),(321,0,322,1)),{Bod}
        ((56,112,84,122),(89,112,117,122),(56,123,84,133),(321,0,322,1),(321,0,322,1),(321,0,322,1)),{VyplnPlochu}
        ((56,112,84,122),(89,112,117,122),(56,123,84,133),(321,0,322,1),(56,134,86,143),(321,0,322,1)),{Ramcek}
        ((56,112,84,122),(321,0,322,1),(56,123,84,133),(321,0,322,1),(321,0,322,1),(321,0,322,1)),{Vypis}
        ((56,112,84,122),(321,0,322,1),(56,123,84,133),(321,0,322,1),(321,0,322,1),(321,0,322,1)),{VypisPO}
        ((56,112,84,122),(321,0,322,1),(321,0,322,1),(321,0,322,1),(321,0,322,1),(321,0,322,1)),{PrilepBMP}
        ((56,112,84,122),(89,112,117,122),(56,123,84,133),(321,0,322,1),(321,0,322,1),(321,0,322,1)),{Obdlznik}
        ((56,112,84,122),(89,112,117,122),(56,123,84,133),(321,0,322,1),(56,134,86,143),(89,134,117,144)),{Tlacidlo3D}
        ((56,112,84,122),(321,0,322,1),(321,0,322,1),(321,0,322,1),(321,0,322,1),(321,0,322,1)),{PrilepBMPPO}
        ((56,112,84,122),(89,112,117,122),(56,123,84,133),(89,123,117,133),(56,134,86,143),(321,0,322,1)),{Ciara}
        ((56,112,84,122),(89,112,117,122),(56,123,84,133),(89,123,117,133),(56,134,86,143),(89,134,117,144)),{Bezierova krivka}
        ((321,0,322,1),(321,0,322,1),(321,0,322,1),(321,0,322,1),(321,0,322,1),(321,0,322,1)),{ZmazObrazovku}
        ((56,112,84,122),(321,0,322,1),(56,123,84,133),(89,123,117,133),(56,134,84,144),(321,0,322,1)));{NastavFarbu}
      DlzElem:array[1..16] of byte=(8,8,1,6,10,11,8,8,6,10,14,6,10,20,1,5); {pri 7,8,11 treba pripocitat dlzku retazca}
type TProces=record
       Dlzka:word;
       Data:array[1..MaxByteNaProces-2] of byte;
     end;
var Hlavicka:array[1..16] of byte;
    Proces:array[1..MaxProcesov]of ^TProces; {editovany subor, proces, pointer}
    PozElem:array[1..MaxElementov]of word;   {pozicie jednotlivych elementov}
    AktProces,PocetProcesov:integer;
    PosX,PosY,SPosX,SPosY,DlzkaX,DlzkaY,x,y:word;
    AktElement,PocetElementov:integer;
    BK3:array[1..4,1..2] of integer;         {Bezierova krivka}
    PCiar:word;                              {Bezierova krivka}
    r,g,b:byte;                              {Nastav Farbu}
    Color1,Color2:byte;                      {pri prilepovani elementov}
    Subor:string;

                    { ----- pomocne procedury ----- }

procedure NacitajMSF(Subor:string);
begin
  NacitajFont(Subor,pointer(MSFP[PocetMSF+1]));
  Inc(PocetMSF);
  NazovFNTSub[PocetMSF]:=Subor;
  Assign(f,Subor);
  Reset(f,1);
  DlzkaFNTSub[PocetMSF]:=FileSize(f);
  Close(f);
end;
procedure NacitajMB(Subor:string);
var PocetMBVSubore:byte;
begin
  Assign(f,Subor);
  Reset(f,1);
  Seek(f,768);
  BlockRead(f,PocetMBVSubore,1);
  for i:=1 to PocetMBVSubore do begin
    Inc(PocetMB);
    NacitajBMP(f,pointer(MBP[PocetMB]));
    NazovBMPSub[PocetMB]:=Subor;
    CisloBMPSub[PocetMB]:=i;
  end;
  Close(f);
end;
function Slovo(Pozicia:word):word;
begin
  with Proces[AktProces]^ do Slovo:=Data[Pozicia]+256*Data[Pozicia+1];
end;
function StrB(b:byte):string;
var s:string;
begin
  Str(b,s);
  StrB:=s;
end;
function StrW(w:word):string;
var s:string;
begin
  Str(w,s);
  StrW:=s;
end;
Procedure InicializujObrazovkuMGP;
begin
  VM;
  ZmazObrazovku;
  VykresliMGP(Proces[AktProces],@MBP,@MSFP);
  PosX:=0;PosY:=0;
  SPosX:=PosX;SPosY:=PosY;
  NastavKurzor(0,0);
  StiahniBMP(PosX,PosY,DlzkaX,DlzkaY,Podkl);
end;  { InicializujObrazovkuMGP }
Procedure InicializujObrazovkuEditora;
begin
  VM;
  ZmazObrazovku;
  VykresliMGP(EMGPP[1],@EMBP,@EFP);
  ZobrazVolnuPamat;
  ZM;
end;
procedure PrepisHodnoty;
var s:string;
begin
  VM;
  for i:=0 to 4 do PrilepBMP(76,16+13*i,EMBP[7]);
  Color:=0;
  VyplnPlochu(145,17,22,8);
  VyplnPlochu(145,30,22,8);
  Str(AktProces,s);
  VypisPO(103-LengthPixel(EFP,s),17,EFP,s,Zlta);
  Str(AktElement,s);
  VypisPO(103-LengthPixel(EFP,s),30,EFP,s,Zlta);
  Str(AktMSF,s);
  if PocetMSF>0 then VypisPO(103-LengthPixel(EFP,s),43,EFP,s,Zlta);
  Str(AktMB,s);
  if PocetMB>0 then VypisPO(103-LengthPixel(EFP,s),56,EFP,s,Zlta);
  Str(AktMP,s);
  if PocetMP>0 then VypisPO(103-LengthPixel(EFP,s),69,EFP,s,Zlta);
  Str(PocetProcesov,s);
  if PocetProcesov>0 then VypisPO(145,17,EFP,s,Zlta);
  Str(PocetElementov,s);
  if PocetElementov>0 then VypisPO(145,30,EFP,s,Zlta);
  ZM;
end;
procedure ZapisSlovo(Posun,Slovo:word);
begin
  with Proces[AktProces]^ do begin
    Data[PozElem[AktElement]+Posun]:=Lo(Slovo);
    Data[PozElem[AktElement]+Posun+1]:=Hi(Slovo);
  end;
end;
procedure ZapisBajt(Posun,Bajt:word);
begin
  Proces[AktProces]^.Data[PozElem[AktElement]+Posun]:=byte(Bajt);
end;
procedure PripravElementy;{ naplni pole PozElem a premennu PocetElementov}
var RiadiaciBajt:byte;
begin
  PocetElementov:=0;
  with Proces[AktProces]^ do begin
    i:=1;
    while i<=Dlzka do begin
      Inc(PocetElementov);
      PozElem[PocetElementov]:=i;
      RiadiaciBajt:=Data[i];
      case RiadiaciBajt of
        7,8:Inc(i,Data[i+7]);   {pridavame dlzku retazca}
        11:Inc(i,Data[i+13]);
      end;
      Inc(i,DlzElem[RiadiaciBajt]);
    end;
  end;
end;

           { ----- tu zacinaju seriozne hlavne procedury ----- }

procedure VytlacElement;
var RiadiaciBajt:byte;
    PozAktElem:word;
    s:string;
begin
  if PocetElementov>0 then
    with Proces[AktProces]^ do begin
      PozAktElem:=PozElem[AktElement];
      RiadiaciBajt:=Data[PozAktElem];
      case RiadiaciBajt of
        1:WriteLn(lst,'Ciara vodorovna ',
            StrW(Slovo(PozAktElem+1)),' ',StrW(Slovo(PozAktElem+3)),' ',
            StrW(Slovo(PozAktElem+5)),' '+StrB(Data[PozAktElem+7]));
        2:WriteLn(lst,'Ciara zvisla ',
            StrW(Slovo(PozAktElem+1)),' ',StrW(Slovo(PozAktElem+3)),' ',
            StrW(Slovo(PozAktElem+5)),' ',StrB(Data[PozAktElem+7]));
        4:WriteLn(lst,'Bod ',
            StrW(Slovo(PozAktElem+1)),' ',StrW(Slovo(PozAktElem+3)),' ',
            StrB(Data[PozAktElem+5]));
        5:WriteLn(lst,'Vypln plochu ',
            StrW(Slovo(PozAktElem+1)),' ',StrW(Slovo(PozAktElem+3)),' ',
            StrW(Slovo(PozAktElem+5)),' ',StrW(Slovo(PozAktElem+7)),' ',
            StrB(Data[PozAktElem+9]));
        6:WriteLn(lst,'Ramcek ',
            StrW(Slovo(PozAktElem+1)),' ',StrW(Slovo(PozAktElem+3)),' ',
            StrW(Slovo(PozAktElem+5)),' ',StrW(Slovo(PozAktElem+7)),' ',
            StrB(Data[PozAktElem+9]),' ',StrB(Data[PozAktElem+10]));
        7,8:begin {vypis}
          Write(lst,'Vypis ');
          Presun(@Data[PozAktElem+7],@s,Data[PozAktElem+7]+1);
          if RiadiaciBajt=8 then Write(lst,'priehladne ');
          WriteLn(lst,StrW(Slovo(PozAktElem+1)),' ',StrW(Slovo(PozAktElem+3)),' ',
            StrB(Data[PozAktElem+5]),' ',StrB(Data[PozAktElem+6]),' ',s);
        end;
        9,12:begin {prilep bitmapu}
          Write(lst,'Prilep bitmapu ');
          if RiadiaciBajt=12 then Write(lst,'priehladne ');
          WriteLn(lst,StrW(Slovo(PozAktElem+1)),' ',StrW(Slovo(PozAktElem+3)),' ',
            StrB(Data[PozAktElem+5]));
        end;
        10:WriteLn(lst,'Obdlznik ',
             StrW(Slovo(PozAktElem+1)),' ',StrW(Slovo(PozAktElem+3)),' ',
             StrW(Slovo(PozAktElem+5)),' ',StrW(Slovo(PozAktElem+7)),' ',
             StrB(Data[PozAktElem+9]));
        11:begin {Tlacidlo 3D}
          Write(lst,'Tlacidlo3D ');
          Presun(@Data[PozAktElem+13],@s,Data[PozAktElem+13]+1);
          WriteLn(lst,StrW(Slovo(PozAktElem+1)),' ',StrW(Slovo(PozAktElem+3)),' ',
            StrW(Slovo(PozAktElem+5)),' ',StrW(Slovo(PozAktElem+7)),' ',
            StrB(Data[PozAktElem+9]),' ',StrB(Data[PozAktElem+10]),' ',
            StrB(Data[PozAktElem+11]),' ',s);
        end;
        13:WriteLn(lst,'Ciara ',
            StrW(Slovo(PozAktElem+1)),' ',StrW(Slovo(PozAktElem+3)),' ',
            StrW(Slovo(PozAktElem+5)),' ',StrW(Slovo(PozAktElem+7)),' ',
            StrB(Data[PozAktElem+9]));
        14:WriteLn(lst,'Bezierova krivka ',
             StrW(Slovo(PozAktElem+1)),' ',StrW(Slovo(PozAktElem+3)),' ',
             StrW(Slovo(PozAktElem+5)),' ',StrW(Slovo(PozAktElem+7)),' ',
             StrW(Slovo(PozAktElem+9)),' ',StrW(Slovo(PozAktElem+11)),' ',
             StrW(Slovo(PozAktElem+13)),' ',StrW(Slovo(PozAktElem+15)),' ',
             StrW(Slovo(PozAktElem+17)),' ',StrB(Data[PozAktElem+19]));
        15:WriteLn(lst,'Zmazanie obrazovky');
        16:WriteLn(lst,'Nastavenie farby ',
            StrB(Data[PozAktElem+1]),' ',StrB(Data[PozAktElem+2]),' ',
            StrB(Data[PozAktElem+3]),' ',StrB(Data[PozAktElem+4]));
        else WriteLn(lst,'Takyto element neexistuje !!!');
      end; {case}
    end {with, if}
  else WriteLn(lst,'Elementy nie su ziadne.');
end;

procedure VytlacProces;
var TempAktElem:word;
begin
  TempAktElem:=AktElement;
  if PocetElementov>0 then
    for AktElement:=1 to PocetElementov do VytlacElement;
  AktElement:=TempAktElem;
end;
procedure VypisInfo;
var RiadiaciBajt:byte;
    PozAktElem:word;
    s:string;
begin
  VM;
  Color:=6;VyplnPlochu(1,83,MAXXPreElementy-1,106);
  if PocetMB>0 then begin
    Color:=0;VyplnPlochu(202,91,42,42);
    OknoXMax:=243;
    OknoYMax:=132;
    PrilepBMPPO(203,92,MBP[AktMB]);
    OknoXMax:=320;
    OknoYMax:=200;
  end;
  if PocetMSF>0 then begin
    Color:=0;VyplnPlochu(202,141,108,23);
    OknoXMax:=309;
    OknoYMax:=164;
    VypisPO(203,142,MSFP[AktMSF],'ABC a~s`e 123',Zelena);
    OknoXMax:=320;
    OknoYMax:=200;
  end;
  if PocetElementov>0 then
    with Proces[AktProces]^ do begin
      PozAktElem:=PozElem[AktElement];
      RiadiaciBajt:=Data[PozAktElem];
      case RiadiaciBajt of
        1:begin {ciara vodorovna}
          VykresliMGP(EMGPP[2],@EMBP,@EFP);
          VypisPO(57,102,EFP,StrW(Slovo(PozAktElem+1)),Oranzova);
          VypisPO(90,102,EFP,StrW(Slovo(PozAktElem+3)),Oranzova);
          VypisPO(57,113,EFP,StrW(Slovo(PozAktElem+5)),Oranzova);
          VypisPO(57,124,EFP,StrB(Data[PozAktElem+7]),Oranzova);
          Presun(@EnhAktiv[1],@Aktiv[37],8*PocetSlotov);
        end;
        2:begin {ciara zvisla}
          VykresliMGP(EMGPP[3],@EMBP,@EFP);
          VypisPO(57,102,EFP,StrW(Slovo(PozAktElem+1)),Oranzova);
          VypisPO(90,102,EFP,StrW(Slovo(PozAktElem+3)),Oranzova);
          VypisPO(57,113,EFP,StrW(Slovo(PozAktElem+5)),Oranzova);
          VypisPO(57,124,EFP,StrB(Data[PozAktElem+7]),Oranzova);
          Presun(@EnhAktiv[2],@Aktiv[37],8*PocetSlotov);
        end;
(*        3:begin {NastavPaletu}
          VykresliMGP(EMGPP[11],@EMBP,@EFP);
          VypisPO(57,102,EFP,StrB(Data[PozAktElem+1]),Oranzova);
          Move(EnhAktiv[3],Aktiv[37],8*PocetSlotov);
        end;*)
        4:begin {bod}
          VykresliMGP(EMGPP[4],@EMBP,@EFP);
          VypisPO(57,102,EFP,StrW(Slovo(PozAktElem+1)),Oranzova);
          VypisPO(90,102,EFP,StrW(Slovo(PozAktElem+3)),Oranzova);
          VypisPO(57,113,EFP,StrB(Data[PozAktElem+5]),Oranzova);
          Presun(@EnhAktiv[3],@Aktiv[37],8*PocetSlotov);
        end;
        5:begin {vypln plochu}
          VykresliMGP(EMGPP[5],@EMBP,@EFP);
          VypisPO(57,102,EFP,StrW(Slovo(PozAktElem+1)),Oranzova);
          VypisPO(90,102,EFP,StrW(Slovo(PozAktElem+3)),Oranzova);
          VypisPO(57,113,EFP,StrW(Slovo(PozAktElem+5)),Oranzova);
          VypisPO(90,113,EFP,StrW(Slovo(PozAktElem+7)),Oranzova);
          VypisPO(57,124,EFP,StrB(Data[PozAktElem+9]),Oranzova);
          Presun(@EnhAktiv[4],@Aktiv[37],8*PocetSlotov);
        end;
        6:begin {ramcek}
          VykresliMGP(EMGPP[6],@EMBP,@EFP);
          VypisPO(57,102,EFP,StrW(Slovo(PozAktElem+1)),Oranzova);
          VypisPO(90,102,EFP,StrW(Slovo(PozAktElem+3)),Oranzova);
          VypisPO(57,113,EFP,StrW(Slovo(PozAktElem+5)),Oranzova);
          VypisPO(90,113,EFP,StrW(Slovo(PozAktElem+7)),Oranzova);
          VypisPO(57,124,EFP,StrB(Data[PozAktElem+9]),Oranzova);
          VypisPO(57,135,EFP,StrB(Data[PozAktElem+10]),Oranzova);
          Presun(@EnhAktiv[5],@Aktiv[37],8*PocetSlotov);
        end;
        7,8:begin {vypis}
          VykresliMGP(EMGPP[7],@EMBP,@EFP);
          if RiadiaciBajt=8 then VypisPO(80,88,EFP,'prieh~ladne',3);
          VypisPO(57,102,EFP,StrW(Slovo(PozAktElem+1)),Oranzova);
          VypisPO(90,102,EFP,StrW(Slovo(PozAktElem+3)),Oranzova);
          VypisPO(57,113,EFP,StrB(Data[PozAktElem+5]),Oranzova);
          VypisPO(57,124,EFP,StrB(Data[PozAktElem+6]),Oranzova);
          Presun(@Data[PozAktElem+7],@s,Data[PozAktElem+7]+1);
          OknoXMax:=MaxXPreElementy-2;
          VypisPO(3,135,EFP,s,Oranzova);
          OknoXMax:=320;
          Presun(@EnhAktiv[RiadiaciBajt-1],@Aktiv[37],8*PocetSlotov);
        end;
        9,12:begin {prilep bitmapu}
          if RiadiaciBajt=12 then VypisPO(130,88,EFP,'prieh~ladne',3);
          VykresliMGP(EMGPP[8],@EMBP,@EFP);
          VypisPO(57,102,EFP,StrW(Slovo(PozAktElem+1)),Oranzova);
          VypisPO(90,102,EFP,StrW(Slovo(PozAktElem+3)),Oranzova);
          VypisPO(57,113,EFP,StrB(Data[PozAktElem+5]),Oranzova);
          Presun(@EnhAktiv[8],@Aktiv[37],8*PocetSlotov);
        end;
        10:begin {obdlznik}
          VykresliMGP(EMGPP[9],@EMBP,@EFP);
          VypisPO(57,102,EFP,StrW(Slovo(PozAktElem+1)),Oranzova);
          VypisPO(90,102,EFP,StrW(Slovo(PozAktElem+3)),Oranzova);
          VypisPO(57,113,EFP,StrW(Slovo(PozAktElem+5)),Oranzova);
          VypisPO(90,113,EFP,StrW(Slovo(PozAktElem+7)),Oranzova);
          VypisPO(57,124,EFP,StrB(Data[PozAktElem+9]),Oranzova);
          Presun(@EnhAktiv[9],@Aktiv[37],8*PocetSlotov);
        end;
        11:begin {Tlacidlo 3D}
          VykresliMGP(EMGPP[10],@EMBP,@EFP);
          VypisPO(57,102,EFP,StrW(Slovo(PozAktElem+1)),Oranzova);
          VypisPO(90,102,EFP,StrW(Slovo(PozAktElem+3)),Oranzova);
          VypisPO(57,113,EFP,StrW(Slovo(PozAktElem+5)),Oranzova);
          VypisPO(90,113,EFP,StrW(Slovo(PozAktElem+7)),Oranzova);
          VypisPO(57,124,EFP,StrB(Data[PozAktElem+9]),Oranzova);
          VypisPO(57,135,EFP,StrB(Data[PozAktElem+10]),Oranzova);
          VypisPO(90,135,EFP,StrB(Data[PozAktElem+11]),Oranzova);
          Presun(@Data[PozAktElem+13],@s,Data[PozAktElem+13]+1);
          OknoXMax:=MaxXPreElementy-2;
          VypisPO(57,146,EFP,s,Oranzova);
          OknoXMax:=320;
          Presun(@EnhAktiv[10],@Aktiv[37],8*PocetSlotov);
        end;
        13:begin {Ciara}
          VykresliMGP(EMGPP[12],@EMBP,@EFP);
          VypisPO(57,102,EFP,StrW(Slovo(PozAktElem+1)),Oranzova);
          VypisPO(90,102,EFP,StrW(Slovo(PozAktElem+3)),Oranzova);
          VypisPO(57,113,EFP,StrW(Slovo(PozAktElem+5)),Oranzova);
          VypisPO(90,113,EFP,StrW(Slovo(PozAktElem+7)),Oranzova);
          VypisPO(57,124,EFP,StrB(Data[PozAktElem+9]),Oranzova);
          Presun(@EnhAktiv[12],@Aktiv[37],8*PocetSlotov);
        end;
        14:begin {Bezierova krivka}
          VykresliMGP(EMGPP[13],@EMBP,@EFP);
          VypisPO(57,102,EFP,StrW(Slovo(PozAktElem+1)),Oranzova);
          VypisPO(90,102,EFP,StrW(Slovo(PozAktElem+3)),Oranzova);
          VypisPO(57,113,EFP,StrW(Slovo(PozAktElem+5)),Oranzova);
          VypisPO(90,113,EFP,StrW(Slovo(PozAktElem+7)),Oranzova);
          VypisPO(57,124,EFP,StrW(Slovo(PozAktElem+9)),Oranzova);
          VypisPO(90,124,EFP,StrW(Slovo(PozAktElem+11)),Oranzova);
          VypisPO(57,135,EFP,StrW(Slovo(PozAktElem+13)),Oranzova);
          VypisPO(90,135,EFP,StrW(Slovo(PozAktElem+15)),Oranzova);
          VypisPO(57,146,EFP,StrW(Slovo(PozAktElem+17)),Oranzova);
          VypisPO(57,157,EFP,StrB(Data[PozAktElem+19]),Oranzova);
          Presun(@EnhAktiv[13],@Aktiv[37],8*PocetSlotov);
        end;
        15:begin {Zmaz Obrazovku}
          VykresliMGP(EMGPP[14],@EMBP,@EFP);
          Presun(@EnhAktiv[14],@Aktiv[37],8*PocetSlotov);
        end;
        16:begin {Nastav Farbu}
          VykresliMGP(EMGPP[15],@EMBP,@EFP);
          VypisPO(57,113,EFP,StrB(Data[PozAktElem+1]),Oranzova);
          VypisPO(57,124,EFP,StrB(Data[PozAktElem+2]),Oranzova);
          VypisPO(90,124,EFP,StrB(Data[PozAktElem+3]),Oranzova);
          VypisPO(57,135,EFP,StrB(Data[PozAktElem+4]),Oranzova);
          Presun(@EnhAktiv[15],@Aktiv[37],8*PocetSlotov);
        end;
        else VypisPO(3,850,EFp,'Tak`yto element neexistuje !!!',Oranzova);
      end; {case}
    end {with, if}
  else VypisPO(3,85,EFP,'Elementy nie s`u ~ziadne.',Oranzova);
  ZM;
end;
Procedure PrilepElement;
var PomSeg,PomOfs:word;
begin
  repeat
    ZistiPoziciu(word(x),word(y),Tlacidla);
    x:=x div 2;
    if JeZnak then ch:=CitajZnak;
    case ch of
      '6':Inc(DlzkaX);
      '4':if DlzkaX>0 then Dec(DlzkaX);
      '2':Inc(DlzkaY);
      '8':if DlzkaY>0 then Dec(DlzkaY);
      '.':if Color<255 then Inc(Color);
      ',':if Color>0 then Dec(Color);
      '>':if Color2<255 then Inc(Color2);
      '<':if Color2>0 then Dec(Color2);
      '+':if Color1<15 then Inc(Color1);
      '-':if Color1>0 then Dec(Color1);
    end;
    if (X<>SPosX) or (Y<>SPosY) or (ch in ['2','4','6','8','.',',','<','>','+','-']) then begin
      ch:=' ';
      CakajNaVOI;
      PrilepBMP(SPosX,SPosY,Podkl);
      StiahniBMP(X,Y,DlzkaX,DlzkaY,Podkl);
      case Udalost of
        24:CiaraVodorovna(x,y,DlzkaX);
        25:CiaraZvisla(x,y,DlzkaY);
        26:PolozBod(x,y,Color);
        27:VyplnPlochu(x,y,DlzkaX,DlzkaY);
        28:Ramcek(x,y,DlzkaX,DlzkaY,Color2);
        29:Vypis(x,y+1,MSFP[AktMSF],s,Color1);
        30:VypisPO(x,y+1,MSFP[AktMSF],s,Color1);
        31:PrilepBMP(x,y,MBP[AktMB]);
        32:Obdlznik(x,y,DlzkaX,DlzkaY);
        33:Tlacidlo3D(x,y,DlzkaX,DlzkaY,MSFP[AktMSF],s,Color2,Color1,False);
        34:PrilepBMPPO(x,y,MBP[AktMB]);
        46:Ciara(x,y,x+DlzkaX,y+DlzkaY);
      end;
      SPosX:=x;SPosY:=y;
    end;
  until Tlacidla>0;
  pomSeg:=Seg(Proces[AktProces]^);
  pomOfs:=Ofs(Proces[AktProces]^)+Proces[AktProces]^.Dlzka+2;
  PozElem[PocetElementov+1]:=Proces[AktProces]^.Dlzka+1;
  case Udalost of
    24:begin { CiaraVodorovna }
      Mem[PomSeg:PomOfs]:=1;
      MemW[PomSeg:PomOfs+1]:=x;
      MemW[PomSeg:PomOfs+3]:=y;
      MemW[PomSeg:PomOfs+5]:=DlzkaX;
      Mem[PomSeg:PomOfs+7]:=Color;
      Inc(Proces[AktProces]^.Dlzka,8);
    end;
    25:begin { CiaraZvisla }
      Mem[PomSeg:PomOfs]:=2;
      MemW[PomSeg:PomOfs+1]:=x;
      MemW[PomSeg:PomOfs+3]:=y;
      MemW[PomSeg:PomOfs+5]:=DlzkaY;
      Mem[PomSeg:PomOfs+7]:=Color;
      Inc(Proces[AktProces]^.Dlzka,8);
    end;
    26:begin { PolozBod }
      Mem[PomSeg:PomOfs]:=4;
      MemW[PomSeg:PomOfs+1]:=x;
      MemW[PomSeg:PomOfs+3]:=y;
      Mem[PomSeg:PomOfs+5]:=Color;
      Inc(Proces[AktProces]^.Dlzka,6);
    end;
    27:begin { VyplnPlochu }
      Mem[PomSeg:PomOfs]:=5;
      MemW[PomSeg:PomOfs+1]:=x;
      MemW[PomSeg:PomOfs+3]:=y;
      MemW[PomSeg:PomOfs+5]:=DlzkaX;
      MemW[PomSeg:PomOfs+7]:=DlzkaY;
      Mem[PomSeg:PomOfs+9]:=Color;
      Inc(Proces[AktProces]^.Dlzka,10);
    end;
    28:begin { Ramcek }
      Mem[PomSeg:PomOfs]:=6;
      MemW[PomSeg:PomOfs+1]:=x;
      MemW[PomSeg:PomOfs+3]:=y;
      MemW[PomSeg:PomOfs+5]:=DlzkaX;
      MemW[PomSeg:PomOfs+7]:=DlzkaY;
      Mem[PomSeg:PomOfs+9]:=Color2;
      Mem[PomSeg:PomOfs+10]:=Color;
      Inc(Proces[AktProces]^.Dlzka,11);
    end;
    29,30:begin { Vypis, VypisPO }
      Mem[PomSeg:PomOfs]:=Udalost-22;
      MemW[PomSeg:PomOfs+1]:=x;
      MemW[PomSeg:PomOfs+3]:=y;
      Mem[PomSeg:PomOfs+5]:=AktMSF-1;
      Mem[PomSeg:PomOfs+6]:=Color1;
      Move(s,Mem[PomSeg:PomOfs+7],255);
      Inc(Proces[AktProces]^.Dlzka,Length(s)+8);
    end;
    31,34:begin {PrilepBMP, PrilepBMPPO }
      Mem[PomSeg:PomOfs]:=Udalost-22;
      MemW[PomSeg:PomOfs+1]:=x;
      MemW[PomSeg:PomOfs+3]:=y;
      Mem[PomSeg:PomOfs+5]:=AktMB-1;
      Inc(Proces[AktProces]^.Dlzka,6);
    end;
    32:begin { Obdlznik }
      Mem[PomSeg:PomOfs]:=10;
      MemW[PomSeg:PomOfs+1]:=x;
      MemW[PomSeg:PomOfs+3]:=y;
      MemW[PomSeg:PomOfs+5]:=DlzkaX;
      MemW[PomSeg:PomOfs+7]:=DlzkaY;
      Mem[PomSeg:PomOfs+9]:=Color;
      Inc(Proces[AktProces]^.Dlzka,10);
    end;
    33:begin { Tlacidlo 3D }
      Mem[PomSeg:PomOfs]:=11;
      MemW[PomSeg:PomOfs+1]:=x;
      MemW[PomSeg:PomOfs+3]:=y;
      MemW[PomSeg:PomOfs+5]:=DlzkaX;
      MemW[PomSeg:PomOfs+7]:=DlzkaY;
      Mem[PomSeg:PomOfs+9]:=AktMSF-1;
      Mem[PomSeg:PomOfs+10]:=Color2;
      Mem[PomSeg:PomOfs+11]:=Color1;
      Mem[PomSeg:PomOfs+12]:=0;
      Move(s,Mem[PomSeg:PomOfs+13],255);
      Inc(Proces[AktProces]^.Dlzka,Length(s)+14);
    end;
    46:begin { Ciara }
      Mem[PomSeg:PomOfs]:=13;
      MemW[PomSeg:PomOfs+1]:=x;
      MemW[PomSeg:PomOfs+3]:=y;
      MemW[PomSeg:PomOfs+5]:=x+DlzkaX;
      MemW[PomSeg:PomOfs+7]:=y+DlzkaY;
      Mem[PomSeg:PomOfs+9]:=Color1;
      Inc(Proces[AktProces]^.Dlzka,10);
    end;
    47:begin { Bezierova krivka 3. stupna }
      Mem[PomSeg:PomOfs]:=14;
      Move(BK3,Mem[PomSeg:PomOfs+1],SizeOf(BK3));
      MemW[PomSeg:PomOfs+17]:=PCiar;
      Mem[PomSeg:PomOfs+19]:=Color1;
      Inc(Proces[AktProces]^.Dlzka,20);
    end;
    48:begin { Zmaz Obrazovku }
      Mem[PomSeg:PomOfs]:=15;
      Inc(Proces[AktProces]^.Dlzka,1);
    end;
    49:begin { NastavFarbu }
      Mem[PomSeg:PomOfs]:=16;
      Mem[PomSeg:PomOfs+1]:=Color1;
      Mem[PomSeg:PomOfs+2]:=r;
      Mem[PomSeg:PomOfs+3]:=g;
      Mem[PomSeg:PomOfs+4]:=b;
      Inc(Proces[AktProces]^.Dlzka,5);
    end;
  end;
  ZM;
  Inc(PocetElementov);
  if AktProces>PocetProcesov then PocetProcesov:=AktProces;
end;  { PrilepElement }

                          { ----- hlavny program ----- }

BEGIN
{ ----- inicializacia ----- }
  AktProces:=1;AktElement:=1;AktMSF:=1;AktMB:=1;AktMP:=1;Editor:=2;{implicitny graficky editor}
  for i:=1 to MaxProcesov do begin       { sekcia GetMem }
    GetMem(Proces[i],MaxByteNaProces);
    Proces[i]^.Dlzka:=0;
  end;
  GetMem(Podkl,64000);
  NacitajFont('Hlavny8.MSF',EFP);       { nacitavanie suborov }
  AttrCitaj.Font:=EFP;
  NacitajPaletu('Prechody.MP',EPalP);
  Assign(f,Adresar+'Mgp12.MB');
  Reset(f,1);
  Seek(f,769);
  for i:=1 to PocetEMB do NacitajBMP(f,EMBP[i]);
  Close(f);
  Assign(f,Adresar+'Mgp12.MGP');
  Reset(f,1);
  Seek(f,16);
  for i:=1 to PocetEMGP do NacitajMGP(f,EMGPP[i]);
  Close(f);
  InicializujGrafiku;                   { uz bezi program }
  NastavPaletu(EPalP);
  VypinajMys:=True;
  VykresliMGP(EMGPP[1],@EMBP,@EFP);
  ZobrazVolnuPamat;
  ZM;
  PrepisHodnoty;
  VypisInfo;
{ ----- hlavny cyklus ----- }
  repeat
    Udalost:=ObsluzUdalostSHelpom(@Aktiv,@Klav,EFP,@Pomoc);
    case Udalost of
      0:begin { Proces, Zobraz }
        VM;
        ZmazObrazovku;
        VykresliMGP(Proces[AktProces],@MBP,@MSFP);
        CitajZnak;
        InicializujObrazovkuEditora;
        ZM;
      end;
      1:begin { MGP, Nahraj }
        CakajNaPustenie;
        SuboroveOkno(EFP,'Nahratie .MGP s`uboru','*.MGP',Subor);
        if Subor<>'' then begin
          for i:=1 to MaxProcesov do Proces[i]^.Dlzka:=0;
          Assign(f,Subor);
          Reset(f,1);
          BlockRead(f,Hlavicka,16);
          PocetProcesov:=Hlavicka[2];
          for AktProces:=1 to PocetProcesov do
            with Proces[AktProces]^ do begin
              BlockRead(f,Dlzka,2);
              BlockRead(f,Data,Dlzka);
            end;
          Close(f);
          AktProces:=1;
          PripravElementy;
          ZobrazVolnuPamat;
        end;
      end;
      2:begin { MGP, Uloz }
        CakajNaPustenie;
        SuboroveOkno(EFP,'Ulo~zenie .MGP s`uboru','*.MGP',Subor);
        Assign(f,Subor);
        ReWrite(f,1);
        Hlavicka[2]:=PocetProcesov;
        BlockWrite(f,Hlavicka,16);
        for i:=1 to PocetProcesov do with Proces[i]^ do BlockWrite(f,Dlzka,Dlzka+2);
        Close(f);
      end;
      3:if AktProces>1 then begin {Proces, Predosly }
          Dec(AktProces);
          AktElement:=1;
          PripravElementy;
      end;
      4:begin { Proces, Cislo procesu }
        VM;
        PrilepBMP(76,16,EMBP[7]);
        Citaj(77,17,3,s);
        Val(s,AktProces,Err);
        if (AktProces>MaxProcesov) or (AktProces=0) then AktProces:=1;
        AktElement:=1;
        PripravElementy;
        ZM;
      end;
      5:if AktProces<MaxProcesov then begin { Proces, Nasledujuci }
          Inc(AktProces);
          AktElement:=1;
          PripravElementy;
        end;
      6:begin { Proces, Odstran }
        Color:=0;VyplnPlochu(0,191,320,9);
        VypisPO(0,192,EFP,'Zru~si~t cel`y proces? A/N',Cervena);
        ch:=CitajZnak;
        if ch in ['A','a'] then begin
          Proces[AktProces]^.Dlzka:=0;
          Vypln(@PozElem,SizeOf(PozElem),0);
          PocetElementov:=0;
          AktElement:=1;
        end;
      end;
      7:if AktElement>1 then Dec(AktElement); { Element, Predosly }
      8:begin { Element, Cislo elementu }
        VM;
        PrilepBMP(76,29,EMBP[7]);
        Citaj(77,30,3,s);
        Val(s,AktElement,Err);
        if (AktElement>PocetElementov) or (AktElement=0) then AktElement:=1;
        ZM;
      end;
      9:if AktElement<PocetElementov then Inc(AktElement); { Element, Nasledujuci }
      10:begin { Element, Odstran }
        Color:=0;VyplnPlochu(0,191,320,9);
        VypisPO(0,192,EFP,'Zru~si~t aktu`alny element? A/N',Cervena);
        ch:=CitajZnak;
        if (ch in ['A','a']) and (PocetElementov>0) then begin
          with Proces[AktProces]^ do begin
            PozElem[PocetElementov+1]:=Dlzka+1;
            Dec(Dlzka,PozElem[AktElement+1]-PozElem[AktElement]);
            for i:=0 to MaxByteNaProces-PozElem[AktElement+1]-3 do
              Data[i+PozElem[AktElement]]:=Data[i+PozElem[AktElement+1]];
          end;
          if AktElement=PocetElementov then Dec(AktElement);
          if AktElement=0 then AktElement:=1;
          Dec(PocetElementov);
          PripravElementy;
        end;
      end;
      11:if AktMSF>1 then Dec(AktMSF); {Font, Predchadzajuci }
      12:begin { Font, Cislo fontu }
        VM;
        PrilepBMP(76,42,EMBP[7]);
        Citaj(77,43,3,s);
        Val(s,AktMSF,Err);
        if (AktMSF>PocetMSF) or (AktMSF=0) then AktMSF:=1;
        ZM;
      end;
      13:if AktMSF<PocetMSF then Inc(AktMSF); {Font, Nasledujuci }
      14:begin {Font, Nahraj}
        CakajNaPustenie;
        SuboroveOkno(EFP,'Nahratie .MSF s`uboru','*.MSF',Subor);
        if Subor<>'' then NacitajMSF(Subor);
        ZobrazVolnuPamat;
      end;
      15:if AktMB>1 then Dec(AktMB); {Bitmapa, Predchadzajuca }
      16:begin { Bitmapa, Cislo bitmapy }
        VM;
        PrilepBMP(76,55,EMBP[7]);
        Citaj(77,56,3,s);
        Val(s,AktMB,Err);
        if (AktMB>PocetMB) or (AktMB=0) then AktMB:=1;
        ZM;
      end;
      17:if AktMB<PocetMB then Inc(AktMB); {Bitmapa, Nasledujuca }
      18:begin {Bitmapa, Nahraj}
        CakajNaPustenie;
        SuboroveOkno(EFP,'Nahratie .MB s`uboru','*.MB',Subor);
        if Subor<>'' then NacitajMB(Subor);
        ZobrazVolnuPamat;
      end;
      19:if AktMP>1 then Dec(AktMP); { Paleta, Predchadzajuca }
      20:begin { Paleta, Cislo palety }
        VM;
        PrilepBMP(76,68,EMBP[7]);
        Citaj(77,69,3,s);
        Val(s,AktMP,Err);
        if (AktMP>PocetMP) or (AktMP=0) then AktMP:=1;
        ZM;
      end;
      21:if AktMP<PocetMP then Inc(AktMP); { Paleta, Nasledujuca }
      22:begin
        CakajNaPustenie;
        SuboroveOkno(EFP,'Nahratie .MP s`uboru','*.MP',Subor);
        if Subor<>'' then begin
          Inc(PocetMP);
          NacitajPaletu(Subor,MPP[PocetMP]);
          NazovMPSub[PocetMP]:=Subor;
        end;
        ZobrazVolnuPamat;
      end;
      24:begin { CiaraVodorovna }
        Color:=6;VyplnPlochu(1,InfoY-2,MAXXPreElementy-1,106);
        VypisPO(4,InfoY,EFP,'D`l~zka ~ciary:',Hneda);
        Citaj(100,InfoY,6,s);
        Val(s,DlzkaX,Err);
        VypisPO(4,InfoY+10,EFP,'Farba ~ciary:',Hneda);
        Citaj(100,InfoY+10,6,s);
        Val(s,Color1,Err);
        DlzkaY:=1;
        InicializujObrazovkuMGP;
        Color:=Color1;
        CiaraVodorovna(SPosX,SPosY,DlzkaX);
        PrilepElement;
        InicializujObrazovkuEditora;
      end;
      25:begin { CiaraZvisla }
        Color:=6;VyplnPlochu(1,InfoY-2,MAXXPreElementy-1,106);
        VypisPO(4,InfoY,EFP,'D`l~zka ~ciary:',Hneda);
        Citaj(100,InfoY,6,s);
        Val(s,DlzkaY,Err);
        VypisPO(4,InfoY+10,EFP,'Farba ~ciary:',Hneda);
        Citaj(100,InfoY+10,6,s);
        Val(s,Color1,Err);
        DlzkaX:=1;
        InicializujObrazovkuMGP;
        Color:=Color1;
        CiaraZvisla(SPosX,SPosY,DlzkaY);
        PrilepElement;
        InicializujObrazovkuEditora;
      end;
      26:begin {PolozBod}
        Color:=6;VyplnPlochu(1,InfoY-2,MaXXPreElementy-1,106);
        VypisPO(4,InfoY,EFP,'Farba bodu:',Hneda);
        Citaj(100,InfoY,6,s);
        Val(s,Color1,Err);
        DlzkaX:=1;DlzkaY:=1;
        InicializujObrazovkuMGP;
        Color:=Color1;
        PolozBod(SPosX,SPosY,Color);
        PrilepElement;
      end;
      27:begin {VyplnPlochu}
        Color:=6;VyplnPlochu(1,InfoY-2,MaXXPreElementy-1,106);
        VypisPO(4,InfoY,EFP,'~S`irka plochy:',Hneda);
        Citaj(100,InfoY,6,s);
        Val(s,DlzkaX,Err);
        VypisPO(4,InfoY+10,EFP,'V`y~ska plochy:',Hneda);
        Citaj(100,InfoY+10,6,s);
        Val(s,DlzkaY,Err);
        VypisPO(4,InfoY+20,EFP,'Farba plochy:',Hneda);
        Citaj(100,InfoY+20,6,s);
        Val(s,Color1,Err);
        InicializujObrazovkuMGP;
        Color:=Color1;
        VyplnPlochu(SPosX,SPosY,DlzkaX,DlzkaY);
        PrilepElement;
      end;
      28:begin {Ramcek}
        Color:=6;VyplnPlochu(1,InfoY-2,MaXXPreElementy-1,106);
        VypisPO(4,InfoY,EFP,'~S`irka r`am~ceka:',Hneda);
        Citaj(105,InfoY,6,s);
        Val(s,DlzkaX,Err);
        VypisPO(4,InfoY+10,EFP,'V`y~ska r`am~ceka:',Hneda);
        Citaj(105,InfoY+10,6,s);
        Val(s,DlzkaY,Err);
        VypisPO(4,InfoY+20,EFP,'Farba obruby r`am~ceka:',Hneda);
        Citaj(155,InfoY+20,6,s);
        Val(s,Color1,Err);
        VypisPO(4,InfoY+30,EFP,'Farba vn`utra r`am~ceka:',Hneda);
        Citaj(155,InfoY+30,6,s);
        Val(s,Color2,Err);
        InicializujObrazovkuMGP;
        Color:=Color1;
        Ramcek(SPosX,SPosY,DlzkaX,DlzkaY,Color2);
        PrilepElement;
      end;
      29:begin {Vypis}
        Color:=6;VyplnPlochu(1,InfoY-2,MaXXPreElementy-1,106);
        VypisPO(4,InfoY,EFP,'Odtie~n textu:',Hneda);
        Citaj(100,InfoY,6,s);
        Val(s,Color1,Err);
        VypisPO(4,InfoY+10,EFP,'Text:',Hneda);
        Citaj(4,InfoY+20,80,s);
        DlzkaX:=LengthPixel(MSFP[AktMSF],s)+1;
        DlzkaY:=MSFP[AktMSF]^.Vyska+1;
        InicializujObrazovkuMGP;
        Vypis(SPosX,SPosY,MSFP[AktMSF],s,Color1);
        PrilepElement;
      end;
      30:begin {VypisPO}
        Color:=6;VyplnPlochu(1,InfoY-2,MaXXPreElementy,106);
        VypisPO(4,InfoY,EFP,'Odtie~n textu:',Hneda);
        Citaj(100,InfoY,6,s);
        Val(s,Color1,Err);
        VypisPO(4,InfoY+10,EFP,'Text:',Hneda);
        Citaj(4,InfoY+20,80,s);
        DlzkaX:=LengthPixel(MSFP[AktMSF],s)+1;
        DlzkaY:=MSFP[AktMSF]^.Vyska+1;
        InicializujObrazovkuMGP;
        VypisPO(SPosX,SPosY,MSFP[AktMSF],s,Color1);
        PrilepElement;
      end;
      31:begin {PrilepBMP}
        CakajNaPustenie;
        DlzkaX:=MBP[AktMB]^.RozX;
        DlzkaY:=MBP[AktMB]^.RozY;
        InicializujObrazovkuMGP;
        PrilepBMP(SPosX,SPosY,MBP[AktMB]);
        PrilepElement;
      end;
      32:begin {Obdlznik}
        Color:=6;VyplnPlochu(1,InfoY-2,MaXXPreElementy,106);
        VypisPO(4,InfoY,EFP,'~S`irka obd`l~znika:',Hneda);
        Citaj(120,InfoY,6,s);
        Val(s,DlzkaX,Err);
        VypisPO(4,InfoY+10,EFP,'V`y~ska obd`l~znika:',Hneda);
        Citaj(120,InfoY+10,6,s);
        Val(s,DlzkaY,Err);
        VypisPO(4,InfoY+20,EFP,'Farba:',Hneda);
        Citaj(50,InfoY+20,6,s);
        Val(s,Color1,Err);
        InicializujObrazovkuMGP;
        Color:=Color1;
        Obdlznik(SPosX,SPosY,DlzkaX,DlzkaY);
        PrilepElement;
      end;
      33:begin {Tlacidlo3D}
        Color:=6;VyplnPlochu(1,InfoY-2,MaXXPreElementy-1,106);
        VypisPO(4,InfoY,EFP,'~S`irka tla~cidla:',Hneda);
        Citaj(150,InfoY,6,s);
        Val(s,DlzkaX,Err);
        VypisPO(4,InfoY+10,EFP,'V`y~ska tla~cidla:',Hneda);
        Citaj(150,InfoY+10,6,s);
        Val(s,DlzkaY,Err);
        VypisPO(4,InfoY+20,EFP,'Odtie~n textu (0-15):',Hneda);
        Citaj(150,InfoY+20,6,s);
        Val(s,Color1,Err);
        VypisPO(4,InfoY+30,EFP,'Odtie~n tla~cidla (0-15):',Hneda);
        Citaj(150,InfoY+30,6,s);
        Val(s,Color2,Err);
        VypisPO(4,InfoY+40,EFP,'Text:',Hneda);
        Citaj(4,InfoY+50,40,s);
        InicializujObrazovkuMGP;
        Tlacidlo3D(SPosX,SPosY,DlzkaX,DlzkaY,MSFP[AktMSF],s,Color2,Color1,False);
        PrilepElement;
      end;
      34:begin {PrilepBMPPO}
        CakajNaPustenie;
        DlzkaX:=MBP[AktMB]^.RozX;
        DlzkaY:=MBP[AktMB]^.RozY;
        InicializujObrazovkuMGP;
        PrilepBMPPO(SPosX,SPosY,MBP[AktMB]);
        PrilepElement;
      end;
      35:begin {zmena pozicie - os X}
        VM;
        PrilepBMP(56,101,EMBP[7]);
        Citaj(57,102,3,s);
        Val(s,y,Err);
        ZapisSlovo(1,y);
        ZM;
      end;
      36:begin {zmena pozicie - os Y}
        VM;
        PrilepBMP(89,101,EMBP[7]);
        Citaj(90,102,3,s);
        Val(s,y,Err);
        ZapisSlovo(3,y);
        ZM;
      end;
      37:begin { udalost volneho slotu 1 }
        VM;
        PrilepBMP(56,112,EMBP[7]);
        Citaj(57,113,3,s);
        Val(s,y,Err);
        case Proces[AktProces]^.Data[PozElem[AktElement]] of
          1,2,5,6,10,11,13,14:ZapisSlovo(5,y);
          4,7,8,9,12:ZapisBajt(5,y);
          16:ZapisBajt(1,y);
        end;
        ZM;
      end;
      38:begin { udalost volneho slotu 2 }
        VM;
        PrilepBMP(89,112,EMBP[7]);
        Citaj(90,113,3,s);
        Val(s,y,Err);
        case Proces[AktProces]^.Data[PozElem[AktElement]] of
          5,6,10,11,13,14:ZapisSlovo(7,y);
        end;
        ZM;
      end;
      39:begin { udalost volneho slotu 3 }
        VM;
        PrilepBMP(56,123,EMBP[7]);
        Citaj(57,124,3,s);
        Val(s,y,Err);
        case Proces[AktProces]^.Data[PozElem[AktElement]] of
          1,2:ZapisBajt(7,y);
          5,6,10,11,13:ZapisBajt(9,y);
          7,8:ZapisBajt(6,y);
          14:ZapisSlovo(9,y);
          16:ZapisBajt(2,y);
        end;
        ZM;
      end;
      40:begin { udalost volneho slotu 4 }
        VM;
        PrilepBMP(89,123,EMBP[7]);
        Citaj(90,124,3,s);
        Val(s,y,Err);
        case Proces[AktProces]^.Data[PozElem[AktElement]] of
          14:ZapisSlovo(11,y);
          16:ZapisBajt(3,y);
        end;
        ZM;
      end;
      41:begin { udalost volneho slotu 5 }
        VM;
        PrilepBMP(56,134,EMBP[7]);
        Citaj(57,135,3,s);
        Val(s,y,Err);
        case Proces[AktProces]^.Data[PozElem[AktElement]] of
          16:ZapisBajt(4,y);
          6,11:ZapisBajt(10,y);
        end;
        ZM;
      end;
      42:begin { udalost volneho slotu 6 }
        VM;
        PrilepBMP(89,134,EMBP[7]);
        Citaj(90,135,3,s);
        Val(s,y,Err);
        case Proces[AktProces]^.Data[PozElem[AktElement]] of
          11:ZapisBajt(11,y);
          14:ZapisSlovo(15,y);
        end;
        ZM;
      end;
      43:EditorMB(NazovBMPSub[AktMB],CisloBMPSub[AktMB]); { editor bitmap }
      44:EditorMSF(NazovFNTSub[AktMSF]);                  { editor fontov }
      45:EditorMP(NazovMPSub[AktMP]);                     { editor paliet }
      46:begin { Ciara }
        Color:=6;VyplnPlochu(1,InfoY-2,MaXXPreElementy-1,106);
        VypisPO(4,InfoY,EFP,'Delta X:',Hneda);
        Citaj(100,InfoY,6,s);
        Val(s,DlzkaX,Err);
        VypisPO(4,InfoY+10,EFP,'Delta Y:',Hneda);
        Citaj(100,InfoY+10,6,s);
        Val(s,DlzkaY,Err);
        VypisPO(4,InfoY+20,EFP,'Farba ~ciary:',Hneda);
        Citaj(100,InfoY+20,6,s);
        Val(s,Color1,Err);
        InicializujObrazovkuMGP;
        Color:=Color1;
        Ciara(SPosX,SPosY,SposX+DlzkaX,SPosX+DlzkaY);
        PrilepElement;
      end;
      47:begin { Bezierova krivka }
        Color:=6;VyplnPlochu(1,InfoY-2,MaXXPreElementy-1,106);
        for i:=1 to 4 do begin
          Str(i,s);
          VypisPO(4,InfoY+(i-1)*12,EFP,s+'. bod :',Hneda);
          Citaj(100,InfoY+(i-1)*12,6,s);
          Val(s,BK3[i,1],Err);
          Citaj(150,InfoY+(i-1)*12,6,s);
          Val(s,BK3[i,2],Err);
        end;
        VypisPO(4,InfoY+60,EFP,'Po~cet ~ciar:',Hneda);
        Citaj(100,InfoY+60,6,s);
        Val(s,PCiar,Err);
        VypisPO(4,InfoY+72,EFP,'Farba krivky:',Hneda);
        Citaj(100,InfoY+72,6,s);
        Val(s,Color1,Err);
        InicializujObrazovkuMGP;
        Bezier3(PBezier3Struc(@BK3),PCiar,Color1);
        PrilepElement;
      end;
      48:begin { Zmaz Obrazovku }
        InicializujObrazovkuMGP;
        PrilepElement;
      end;
      49:begin { Nastav Farbu }
        Color:=6;VyplnPlochu(1,InfoY-2,MaXXPreElementy-1,106);
        VypisPO(4,InfoY,EFP,'Farba ~c`islo:',Hneda);
        Citaj(120,InfoY,6,s);
        Val(s,Color1,Err);
        VypisPO(4,InfoY+10,EFP,'~Cerven`a zlo~zka:',Hneda);
        Citaj(120,InfoY+10,6,s);
        Val(s,r,Err);
        VypisPO(4,InfoY+20,EFP,'Zelen`a zlo~zka:',Hneda);
        Citaj(120,InfoY+20,6,s);
        Val(s,g,Err);
        VypisPO(4,InfoY+30,EFP,'Modr`a zlo~zka:',Hneda);
        Citaj(120,InfoY+30,6,s);
        Val(s,b,Err);
        InicializujObrazovkuMGP;
        NastavFarbu(Color1,r,g,b);
        PrilepElement;
      end;
      50: { Vytlac proces }
        VytlacProces;
      51: { Vytlac element }
        VytlacElement;
    end; { case }
    CakajNaPustenie;
    CakajNaVOI;
    if Udalost mod 256 in [24..34,43..49] then InicializujObrazovkuEditora;
    PrepisHodnoty;
    VypisInfo;
  until Udalost=23;
  ZavriGrafiku;
  writeln('MukoSoft editor grafickych procesov'#13#10'Lubos Saloky, 1997');
END.