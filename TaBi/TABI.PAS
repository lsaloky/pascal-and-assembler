{$A+,B-,D+,E-,F-,G+,I-,L+,N+,O-,P-,Q+,R+,S+,T+,V-,X+,Y+}
{$M 65500,0,655360}
program Tankove_bitky;
uses MainGr,PomGr,Mys,Joystick,Keyboard,SBlaster;
{ pouziva Prechody.MP, Hlavny8.MSF, TaBi.*, Planina.*, PoloPust.* , Krajina.* }
{ ----- deklaracia konstant ----- }
const PocetMB=30;
      PocetMGP=10;
      MaxPocetNab=3; { pocet nabojov sucasne vystrelenych pre 1 tank }
    { pri zmene je nutne prerabat TTank.SpracujOvladanie}

{ ----- deklaracia objektov ----- }

{ TPovel neobsahuje nic uzitocne ohladom ovladania, len premenne pre mys
  a joystick. }
type TPovel=object
       Kalibrovany:boolean; { joystick }
       JXMin,JXStred,JXMax,JYMin,JYStred,JYMax,JXAkt,JYAkt:integer; { joystick }
       JTlac:byte; { joystick }
       MysX,MysY,MysXStare,MysYStare:integer; { mys }
       MTlac:byte; { mys }
       constructor Init;
       procedure CNPTJ; { CakajNaPustenieTlacidlaJoysticka}
       procedure JoyStickDemo; { vyhod ju vo finalnej verzii }
       procedure OvladanieDemo; { vyhod ju }
       procedure ZistiKlavesy;  { vyhod ju }
     end;
{ TDejRot obsahuje informacie o tom, kedy sa zacalo otacanie tanku a ci je
  mozne robit pohyb dopredu (pocas otacania nie) }
     TDejRot=record
       Aktivny:boolean;
       t0:longint;
       StaraPos,DeltaPos:integer;
     end;
{ vsetko o naboji. Nabojov je MaxPocetNab }
     TNaboj=record
       Aktivny:boolean;
       Rychlost:real;     { pociatocna rychlost, v pixeloch za 1/18 sekundy }
       t0:longint;        { pociatocny cas (BIOS Timer) }
       ElevacnyUhol:real; { uhol strelby v radianoch }
       Smer:integer;      { uhol smeru natocenia pri strelbe v nasobkoch 9ø }
       x0,y0:integer;     { pociatocne sur. v pixeloch }
       x,y,z:integer;     { suradnice v case t }
     end;
{ vsetko o vybuchu. Vybuchov je MaxPocetNab. Naboj s cislom MaxPocetNab+1
  sa da vystrelit az potom, ked jeden z nabojov dovybuchuje. }
     TVybuch=record       { naboja }
       Aktivny:boolean;
       x0,y0:integer;
       t0:longint;
     end;
{ zvysok po vybuchu. Pre jeden tank je ich 10, pri prichode 11-teho sa maze
  prvy. }
     TZvysok=record
       Aktivny:boolean;
       x0,y0:integer;
     end;
{ obhospodaruje system menu. Jeden z najdolezitejsich objektov.}
     TMenu=object
       PocetPartii,AktPartia:word;
       KoniecPartie:boolean;
       PalP:pointer; { paleta (Prechody.MP) }
       MSFP:array[1..2] of pointer; { font (Hlavny8.MSF, 2. polozka prazdna)}
       MGPP:array[1..PocetMGP] of pointer; { procesy }
       MBP:array[1..PocetMB] of pointer; { bitmapy pre hru (nie pre mapy!) }
       MapMBP:array[0..255] of pointer; { bitmapy aktualnej mapy }
       HlavickaMAP:array[0..7] of word; { popis v Vyvojar.DOC }
       Mapa:array[0..79,0..59] of byte; { predimenzovane pole, pouziva sa cast
                                          v strede }
       PocX,PocY,RozX,RozY:integer; { pouzita oblast mapy }
       HlUdalost:word; { cislo udalosti v hlavnom menu. Popis v Vyvojar.DOC }
       AktMapa:shortint; {1..3, 1 = mala, 2 = stredna, 3 = velka }
       Hrac:array[1..4] of byte; {1 = nikto, 2 = clovek, 3 = p.amater, 4 = priemer, 5 = profik }
       SBVoiceInt,SBMasterInt:byte; { hlasitost Voice, Master }
       constructor Init;
       procedure Kalibracia; { joysticka }
       procedure KlavesnicoveDemo; { vyhod ju vo fin. verzii }
       procedure NastavenieOvladania; { samostatne menu }
       procedure HerneDemo; { vyhod ju vo fin. verzii }
       procedure KresliMapuVStrede; { + zivoty }
       procedure VypisElevacnyUhol; { pocas hry }
       procedure HlavneMenu;
       procedure HerneMenu;
       procedure Hra; { HLAVNA PROCEDURA }
       procedure VyhodnoteniePartie;
       procedure NacitajMapu;
       procedure NastavPoziciuTankov; { na zaciatku partie }
       destructor Done;
     end;
{ vsetko o tanku. Jeden z najdolezitejsich objektov. }
     PTank=^TTank;
     TTank=object
       PorCislo:byte;                   { jeho poradove cislo }
       x,y:integer;                     { pozicia stredu tanku na mape}
       xr,yr:real;                      { pozicia stredu tanku, ale v realnych cislach}
       ObrX,ObrY:integer;               {                         obrazovke}
       Body:word;                       { za vitazstva }
       Farba:byte;                      { nastavuje sa v Init }
       IUholNatocenia:integer;          { HLAVEN - s kladnou polosou osi x, v nasobkoch 9ø }
       IUhol:integer;                   { TANK. Pozri Vyvojar.DOC }
       ElevacnyUhol:real;               { zdvih hlavne, v radianoch }
       Zivot:integer;                   { 60 je maximum, 0 mrtvy }
       DejRot:TDejRot;                  { ci sa tank prave otaca }
       { dalsie 2 premenne pozri Vyvojar.DOC }
       DefPovel:array[1..6] of char;    {1 = vpred, 2 = vzad, 3 = vlavo, }
       AktPovel:array[1..6] of boolean; {4 = vpravo, 5 = strelba, 6 = nastav}

       Veza,Podvozok:array[0..39] of pointer; { bitmapy - 40 poloh po 9 stupnov }
       Hlaven:array[1..3,0..39] of pointer; { bitmapy }
       AktSnimVyfuk:integer;            { kreslenie vyfuku: 0 = nekresli, obs. hodnoty 1..20 }
       Vyfuk:array[1..20] of pointer;  { animacia - pole bitmap }
       Naboj:array[1..MaxPocetNab] of TNaboj;     { naboje }
       Vybuch:array[1..MaxPocetNab] of TVybuch;   { ich vybuchy }
       AnimVybuch:array[0..15] of pointer; { animacia - pole bitmap }
       Zvysok:array[0..9] of TZvysok; { zvysky po vybuchu }
       PoZvysok:word; { posledny zvysok (bude prvy prepisany novym )}
       CasSmrti:longint; { kedy vybuchol }
       constructor Init;
       procedure KresliOkno; { aktualneho tanku "se vsim vsudy" - naboje,
                               vybuchy, tank(y), mapa, ...}
       procedure KresliRadar; { v strede obr. }
       procedure Demo;                  { vyhod ju vo finalnej verzii }
       procedure Demo2;                 { vyhod ju vo finalnej verzii }
       procedure RotujTank;             { vyhod ju vo finalnej verzii }
       procedure VratStavOvladania; { vrati, co hrac stlacil }
       procedure SpracujOvladanie; { vykona prikazy hraca }
       procedure PosunTank(DeltaX,DeltaY:real); { vykona prikaz posunu }
       procedure VycisliDrahyNabojov;
       procedure ZistiDopadNabojov; { pridava do zoznamu vybuchov, odobera zivot }
       function TestVzdialenosti(Ktory:integer;TestX,TestY:real):boolean; { tanku
                  od zadanych suradnic - ohladom vybuchov a kolizii tankov. }
       function PocetMrtvychTankov:shortint; { >= 3 pre koniec hry }
       procedure VypisStavOvladania; { pre Menu.NastavenieOvladania }
     end;
{ samotne tanky sa od rodicovskeho objektu lisia niektorymi nastaveniami
  (farba, pozicia na mape, obrazovke, ... Pozor, smerniky na animacie a
  bitmapy su v TTank1..4 nil, vsetko kresli cez objekt TTank! }
     TTank1=object(TTank)
       constructor Init;
       procedure ObnovNastavenia;
     end;
     TTank2=object(TTank)
       constructor Init;
       procedure ObnovNastavenia;
     end;
     TTank3=object(TTank)
       constructor Init;
       procedure ObnovNastavenia;
     end;
     TTank4=object(TTank)
       constructor Init;
       procedure ObnovNastavenia;
     end;
     TDej=record { vyhod ho vo finalnej verzii }
       Aktivny:boolean; { ci bezi }
       t0:longint;      { BIOS Timer }
       x,y:word;        { v pixeloch }
       Typ:byte;
     end;
{ synchronizacia dejov (SpracujUdalosti) , osetrenie dejov pre pomalsie
  pocitace. Pouziva Bios Timer (1/18 sekundy na 1 tik). }
     TRealTime=object
       VVRam:pointer;
       VVRamSeg:word;
       {PomNaboj,AktNaboj,PrvyNaboj:PNaboj;}
       g:real; { tiazove zrychlenie }
       AktCas:longint;
       DeltaT:integer; { kolko tikov preslo od podledneho spracovania dejov }
       constructor Init;
       procedure PridajNaboj(Rychlost:real;t0:longint;Vlastnik,x,y:word;Uhol:real);
         { na koniec; vyhod ju }
       procedure OdoberNaboj; { vyhod ju; aktualny }
       procedure VypocitajPoziciuNaboja; { vyhod ju; aktualneho - x,y,z }
       procedure SpracujUdalosti; { !!!!! najdolezitejsia procedura !!!!! }
       procedure Demo; { vyhod ju vo finalnej verzii }
     end;
{ tanky ovladane pocitacom }
     TPocHrac=object
       JeRozhodnute:boolean; {proti komu a ako }
       UholE,UholN:real; { elevacny, natocenia - plan po zamerani }
       PorCislo,Nepriatel:byte; { moje cislo, cislo ciela }
       xz,xc,yz,yc:real; {XZdroj, ... }
       d:real; { vzdialenost od terca v pixeloch }
       td:real; { cas letu naboja v pixeloch / tik }
       v0:real; { rychlost naboja }
       UholNS:real; { skutocny uhol natocenia veze p. hraca. Duplicitna
                      informacia s MojTank^.IUholNatocenia, len v Mojtank
                      je to v nasobkoch 9 stupnov. }
       MojTank:PTank; {ukazuje na data tanku, ktory je ovladany poc. hracom.
                       Tam je pozicia, uhly, ... }
       constructor Init;
       function ArcSin(x:real):real;
       function ArcCos(x:real):real;
       procedure ZamerajStojaciCiel;
       procedure ZamerajIduciCiel;
       procedure Konaj;
       procedure Demo; { vyhod ju vo finalnej verzii }
     end;
{ ----- premenne na volne pouzitie ----- }
var i,j,k:integer;
    ch:char;
    f:file;
    b:byte;
    s:string;
    r:real;
    bool:boolean;
{ ----- premenne na deklaraciu objektov ----- }
var Povel:TPovel;
    Menu:TMenu;
    Tank:TTank;
    Tank1:TTank1;
    Tank2:TTank2;
    Tank3:TTank3;
    Tank4:TTank4;
    RealTime:TRealTime;
    PocHrac:array[1..4] of TPocHRac;
{$I TPovel.INC}
{$I TMenu.INC}
{$I TTank.INC}
{$I TTankKr.INC} { kresliac procedury }
{$I TRT.INC}
{$I Zbytocne.INC}
{$I TPocHrac.INC}
{ ----- hlavny program ----- }
BEGIN
  WriteLn('Inicializacia ... ');
  RealTime.Init;
  Tank.Init;     { musi ist po RealTime.Init }
  Tank1.Init;
  Tank2.Init;
  Tank3.Init;
  Tank4.Init;
  Povel.Init;   { tu sa inicializuje zoznam klaves }
  PocHrac[1].Init; { tam sa inicializuju aj ostatni }
{  PocHrac[4].Demo;}
{  Povel.ZistiKlavesy; }
{  Menu.KlavesnicoveDemo;}
  Menu.Init;     { musi ist po RealTime.Init}
{  Menu.Kalibracia;}
{  Povel.JoystickDemo;}
{  Menu.NastavenieOvladania;}
{  Povel.OvladanieDemo;}
{  RealTime.Demo;}     { vyzaduje breakpoint }
{  Tank1.Demo;}
{  Tank1.Demo2;}
{  Menu.HerneDemo;}
  Menu.HlavneMenu;
{  RealTime.AktCas:=MemAvail;}
  Menu.Done;
END.