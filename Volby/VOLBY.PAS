program Hor_sa_do_sutaze_o_kresla;
{potrebne subory: HLAVNY8.MSF, HLAVNY11.MSF,
                  SYMBOLY.MB,VELKA.MB,
                  VOLPROG.MGP,LSPOM.MGP
                  PRECHODY.MP
                  UDAJE.DAT}
uses MainGr, Mys;

type TDatum=record
       Den:string[2];
       Mesiac:string[2];
       Rok:string[4]; { riesi problem roku 2000 :-) }
     end;
const MaxStran=16;  {maximalny pocet politickych stran}
      MaxAkcii=15;  {maximalny pocet typov spolocenskych akcii}
      MaxUrazok=30; {maximalny pocet slovnych invektiv}
      MaxKauz=30;   {maximalny pocet vykonstruovanych politickych obvineni}
      PocetDni:array[1..12] of byte=(31,28,31,30,31,30,31,31,30,31,30,31);    {pocet dni v mesiaci}
      DVT:array[1..7] of string[10]=('Pondelok','Utorok','Streda','Stvrtok','Piatok','Sobota','Nede~la');
      Agentura:array[1..5] of string[10]=('MVK','IVO','NCMK','Markant','N`azory');{prieskumy verejnej mienky - agentury}
      PVM:array[1..15,1..4] of word=(  {prieskumy verejnej mienky - datumy a cislo agentury}
        (30,6,1998,4),(13,7,1998,1),(15,7,1998,2),(19,7,1998,3),(25,7,1998,5),
        (7,8,1998,4),(15,8,1998,1),(17,8,1998,2),(23,8,1998,5),(29,8,1998,3),
        (3,9,1998,4),(5,9,1998,5),(8,9,1998,3),(10,9,1998,1),(11,9,1998,2));

const PocetMGPVP=16;PocetMGPPom=20;
      PocetMB=9;
{ ----- pomocne premenne, globalne ----- }
var f:file;
    ftxt:text;
    i,j:integer;
    x,y:word;
    b:byte;
    ch:char;
    s:string;
    AktStrana:word;                   {len pomocna premenna}
    HracovaStrana:word;              {tychto hras}
{ ----- globalne premenne ----- }
var MSFP:array[1..2] of pointer;
    MGPVPP:array[1..PocetMGPVP] of pointer;
    MGPPomP:array[1..PocetMGPPom] of pointer;
    MBP:array[1..PocetMB] of pointer;
    PalP:pointer;
    Mapa:^BMPStruc;{mapa Slovenska}
    Den,Mesiac,Rok:word;
    Obtiaznost:byte;
    PocetStran:word;
    NazovStrany:array[1..MaxStran] of string[10];
    KrajPref:array[1..MaxStran,1..8] of real;       {krajske preferencie}
        { 1.index pol. strana, 2. kraj: BA, Trn, Tre, Ni, Zi, BB, PO, KE}
    Pref:array[1..MaxStran] of real;                {celoslovenske pref.}
    Politik:array[1..MaxStran,1..3] of string[20];  {1. index pol. strana}
    VolProgram:array[1..MaxStran,1..15] of byte;    {pociatocne nastavenia}
    PPosl:array[1..MaxStran] of byte;               {pocet poslancov strany po volbach}

    PocetSpolAkcii:word;                            {spolocenske akcie,}
    SpolAkcia:array[1..MaxAkcii] of record          {  na ktore mozu byt}
      Co:string[40];                                {  pozvani politici}
      DVT:byte;
      Pouzita:byte;
    end;

    PocetUrazok:word;                               {slovne invektivy,}
    Urazka:array[1..MaxUrazok] of record            {  ktorymi sa mozu}
      Sila:byte;                                    {  politici castovat}
      Znenie:string[100];
      Pouzita:byte;                                 {0 = nepouzita}
    end;

    PocetKauz:word;                                 {kauzy, ktore si}
    Kauza:array[1..MaxKauz] of record               {  na seba politici}
      StrataPref:real;                              {  mozu vymyslat}
      Znenie:string[100];
      Pouzita:byte;
    end;

    Koal:array[1..MaxStran,1..MaxStran]of byte;     {chut ist do koalicie - 1. index, kto oslovuje.}
    Datum:TDatum;
    DostKauz:boolean;                               {max. 1 kauza denne}
    DostOhovarani:boolean;                          {max. 1 ohov. denne}
    DostVyhlaseni:boolean;                          {max. 1 vyhlasenie k inej strane denne}
    DebugMode:boolean;                              {TRUE pri odladovani}


{ ----- toto potom zmaz ----- }
procedure InitDocasneUdaje;
begin
  HracovaStrana:=2; {SDK}
end;
{ ----- inicializacia zo suboru UDAJE.DAT. Menit len po dohode ----- }

procedure InitUdaje;
begin
  Den:=26;Mesiac:=6;Rok:=1998;
  Assign(ftxt,'Udaje.DAT');
  Reset(ftxt);
  ReadLn(ftxt);
  ReadLn(ftxt);
  ReadLn(ftxt,PocetStran);                              {pocet stran}
  ReadLn(ftxt);
  for i:=1 to PocetStran do ReadLn(ftxt,NazovStrany[i]);{nazvy stran}
  ReadLn(ftxt);
  for i:=1 to PocetStran do begin
    for j:=1 to 8 do Read(ftxt,KrajPref[i,j]);          {krajske pref.}
    ReadLn(ftxt);
  end;
  ReadLn(ftxt);
  for i:=1 to PocetStran do                             {politici}
    for j:=1 to 3 do ReadLn(ftxt,Politik[i,j]);
  ReadLn(ftxt);
  for i:=1 to 15 do begin                       {volebne programy}
    for j:=1 to PocetStran do Read(ftxt,VolProgram[j,i]);
    ReadLn(ftxt);
  end;
  ReadLn(ftxt);
  ReadLn(ftxt,PocetSpolAkcii);                  {spolocenske akcie}
  ReadLn(ftxt);
  for i:=1 to PocetSpolAkcii do ReadLn(ftxt,SpolAkcia[i].Co,SpolAkcia[i].DVT);
  ReadLn(ftxt);
  ReadLn(ftxt,PocetUrazok);                     {invektivy}
  ReadLn(ftxt);
  for i:=1 to PocetUrazok do ReadLn(ftxt,Urazka[i].Sila,Urazka[i].Znenie);
  ReadLn(ftxt);
  ReadLn(ftxt,PocetKauz);                       {kauzy}
  ReadLn(ftxt);
  for i:=1 to PocetKauz do ReadLn(ftxt,Kauza[i].StrataPref,Kauza[i].Znenie);
  ReadLn(ftxt);
  for i:=1 to PocetStran do begin        {povolebne koalicie}
    ReadLn(ftxt);
    for j:=1 to PocetStran do begin
      Read(ftxt,Koal[i,j]);
    end;
    ReadLn(ftxt);
  end;
  Close(ftxt);
  {!!!!!}
end;
{ ----- prilinkuj dalsie subory s hrou ----- }
{$I SYSTEM.PAS}
{$I VOLPROG.PAS}
{$I TL.PAS}
{$I TELEFON.PAS}
{$I KANCEL.PAS}
BEGIN
{ ----- inicializacia suborov, mysi a klavesnice ----- }
  NacitajFont('Hlavny8.MSF',MSFP[1]);
  NacitajFont('Hlavny11.MSF',MSFP[2]);
  NacitajPaletu('Prechody.MP',PalP);
  Assign(f,'Velka.MB');
  Reset(f,1);
  Seek(f,771);
  GetMem(Mapa,320*200+4);
  Mapa^.RozX:=320;Mapa^.RozY:=199;
  BlockRead(f,Mapa^.BMP,320*199);
  InitLS;
  InitUdaje;
  InitDocasneUdaje;
  InitKancelaria;
  InicializujGrafiku;
  NastavPaletu(PalP);
  ZM;
  VypinajMys:=True;
{ ----- hra ----- }
{  HlavneMenu;}
  Kancelaria;
{  VysledkyVolieb;}
{ ----- ukoncenie programu ----- }
  ZavriGrafiku;
END.