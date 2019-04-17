{$DEFINE PlnaVerzia} {je nutne pripisat na koniec END.}
{$IFDEF PlnaVerzia}
program Editor_fontov_cez_Coonsove_kubiky; { verzia 1.1 }
uses MainGr,PomGr,Mys;
{$ENDIF}
{ Subory: MTFEdit.PAS, TBod.INC, TKrivka.INC, TPismeno.INC, TFont.INC,
          TMenu.INC, MTFEdit.MGP, MTFEdit.MB, Prechody.MP, Hlavny8.MSF}
{ ----- konstanty pre graficke rozhranie ----- }
const PocetMSF=1;
      PocetMB=14;
      PocetMGP=12;
      PocetOP=13;
      Aktiv:array[1..PocetOP+1,1..4] of word=( { hlavne menu }
        (0,0,239,192), { oblast kreslenia }
        (283,121,315,145), { akcia copy - vloz (c) }
        (242,18,319,28),(242,29,319,39),
        (242,40,319,50),(242,51,319,61), { volba objektu }
        (246,65,278,89),(283,65,315,89),(246,93,278,117),
        (283,93,315,117),(246,121,278,145), { volba akcie }
        (241,149,319,188), { test }
        (321,100,322,101), { copy  - prilep (y) }
        (400,0,0,0));
      Klav:array[1..PocetOP+1] of char=(#0,'c','m','p','k','b','n',#0,'-','+','s','t','y',#255);
      Aktiv3:array[1..7,1..4] of word=( { pismo }
        (96,81,124,93),(49,107,77,119),(49,120,77,132),
        (119,107,147,119),(119,120,147,132),(175,126,215,142),(400,0,0,0));
      Klav3:char=#255;
      Aktiv4:array[1..6,1..4] of word=( { pismeno }
        (64,94,92,106),(99,99,147,115),(64,107,92,119),(101,128,129,140),
        (175,126,215,142),(400,0,0,0));
      Klav4:char=#255;
      Aktiv5:array[1..3,1..4] of word=( { krivka }
        (126,81,154,93),(175,126,215,142),(400,0,0,0));
      Klav5:char=#255;
      Aktiv6:array[1..4,1..4] of word=( { bod }
        (43,81,71,93),(43,94,71,106),(175,126,215,142),(400,0,0,0));
      Klav6:char=#255;
      AktivTest:array[1..3,1..4] of word=( { testovanie }
        (63,129,133,139),(175,126,215,142),(400,0,0,0));
      KlavTest:char=#255;
      AktivAnoNie:array[1..3,1..4] of word=( { dialog na konci a pri Pismo / Novy}
        (55,108,103,124),(135,108,183,124),(400,0,0,0));
      KlavAnoNie:array[1..3] of char=('a','n',#255);
      AktivOznam:array[1..2,1..4] of word=( { oznam o nefungovani }
        (175,126,215,142),(400,0,0,0));
      KlavOznam:char=#255;
{ ----- deklaracie objektov ----- }
type PPismeno=^TPismeno;
     PKrivka=^TKrivka;
     PBod=^TBod;
     TFont=object
       PocetPismen:byte;
       Y1,Y2,Y3,Y4:byte;          { suradnice pomocnych ciar }
       Medzera:byte;              { medzera medzi pismenami }
       Akt:PPismeno;              { aktualne pismeno }
       PPrve:PPismeno;            { prve pismeno }
       Nazov:string[12];
       constructor Init;
       procedure PridajPismeno;
       function OdoberPismeno:boolean;
       procedure DalsiePismeno;
       procedure PredoslePismeno;
       procedure NastavFont;
       procedure PrepisUdajeOFonte;
       procedure UlozFont;
       procedure NahrajFont;
     end;
     TPismeno=object
       PocetKriviek:byte;
       XMin,XMax:byte;            { odkial pokial ide pismeno }
       Ascii:byte;
       KAkt:PKrivka;               { aktualna krivka }
       KPrva:PKrivka;             { prva krivka daneho pismena }
       PPred,PDal:PPismeno;       { predosle a dalsie pismeno }
       constructor Init;
       procedure PridajKrivku;
       function OdoberKrivku:boolean;
       procedure DalsiaKrivka;
       procedure PredoslaKrivka;
       procedure KresliPismeno(PosX,PosY:word;Koef,Farba:byte);
       procedure NastavPismeno;
       procedure PrepisUdajeOPismene;
     end;
     TKrivka=object
       PocetB:byte;
       Presnost:byte;             { kolko bodov sa vykresli na 1 usek krivky }
       BPrvy:PBod;                { prvy bod tejto krivky }
       BAkt:PBod;                 { aktualny bod tejto krivky }
       KDal:PKrivka;              { nasledujuca krivka }
       constructor Init;
       procedure PridajBod(x,y:byte);
       procedure DalsiBod;
       procedure PredoslyBod;
       function OdoberBod:boolean;
       procedure KresliKrivku(PosX,PosY:word;Koef,Farba:byte);
       procedure NastavKrivku;
       procedure PrepisUdajeOKrivke;
     end;
     TBod=object
       X,Y:byte;
       BDal:PBod;
       procedure RucneNastavenie;
       procedure NastavBod;
       procedure PrepisUdajeOBode;
     end;
     TMenu=object
       PalP:pointer;
       MSFP:Array[1..PocetMSF] of pointer;
       MBP:Array[1..PocetMB] of pointer;
       MGPP:Array[1..PocetMGP] of pointer;
       constructor Init;
       procedure Novy;
       procedure Odstran;
       procedure Predosly;
       procedure Dalsi;
       procedure Nastav;
       procedure Kopiruj;
       procedure Prilep;
       procedure Testuj;
       procedure Chyba(Cislo:byte);           { fatalne chyby, cez WriteLn (!!!) }
       procedure KresliOstatne;               { pomocne ciary }
       procedure VypisPamat;                  { volnu }
       procedure ZmazPlochu;                  { na kreslenie }
       procedure StavOK(Stlaceny:boolean);    { tlacidlo OK pri "SET" }
       procedure VypisText(PosX,PosY:word;Koef:byte;Slovo:string);
       procedure Oznam;                       { o nefungovani danej funkcie }
     end;
{ ----- deklaracie premennych jadra ----- }
var Font:TFont;
    PPom,PZas:PPismeno; { pomocna premenna a zasobnik }
    KPom,KZas:PKrivka;
    BPom,BZas:PBod;
    Menu:TMenu;
{ ----- premenne na volne pouzitie ----- }
var f:file;
    ch:char;
    s:string;
    i,j,k:integer;
    b,c:byte;
    w:word;
{ ----- deklaracia premennych programu ----- }
var Udalost,Udalost2,Objekt:word; { ovladanie menu }
    Najdeny:boolean;  { ci bol najdeny bod na mieste kliknutia pravym tlacidlom }
    BNajdeny:PBod;    { to je ten bod }
    Koniec:boolean;   { potvrdenie konca programu }
{$I tfont.inc}
{$I tkrivka.inc}
{$I tpismeno.inc}
{$I tmenu.inc}
{$I tbod.inc}
        { ----- HLAVNY PROGRAM ----- }
{$IFDEF PlnaVerzia}
BEGIN
  WriteLn('Inicializacia ...');
  Font.Init;
  Menu.Init;
{ ----- hlavny cyklus ----- }
  repeat
    Udalost:=ObsluzUdalost(@Aktiv,@Klav);
    case Udalost of
      1:begin { pridanie bodu }
        VM;
        Font.Akt^.KAkt^.KresliKrivku(0,0,1,0);
        if MysX<3 then MysX:=3;
        if MysY<3 then MysY:=3;
        if MysY>189 then MysY:=189;
        if MysX>236 then MysX:=236;
        Font.Akt^.KAkt^.PridajBod(MysX,MysY);
        Font.Akt^.KAkt^.KresliKrivku(0,0,1,15);
        Menu.VypisPamat;
        ZM;
      end;
      2:Menu.Kopiruj;
      3..6:begin { zmena objektu, s ktorym sa pracuje }
        if ((Udalost=3) and (Objekt<>3)) then VykresliMGP(Menu.MGPP[2],@Menu.MBP,@Menu.MSFP);
        if ((Udalost<>3) and (Objekt=3)) then VykresliMGP(Menu.MGPP[1],@Menu.MBP,@Menu.MSFP);
        Menu.VypisPamat;
        Menu.KresliOstatne;
        Color:=8;
        VyplnPlochu(248,(Objekt-2)*11+6,10,10);
        Objekt:=Udalost;
        PrilepBMPP(248,(Objekt-2)*11+6,Menu.MBP[11]);
      end;
      7:Menu.Novy; { prikazy menu }
      8:Menu.Odstran;
      9:Menu.Predosly;
      10:Menu.Dalsi;
      11:Menu.Nastav;
      12:Menu.Testuj;
      13:Menu.Prilep; { klavesnicou }
      257:Font.Akt^.KAkt^.BAkt^.RucneNastavenie; { bodu - pravym tlacidlom }
      258:Menu.Prilep; { mysou }
    end; { case }
    if Udalost<>257 then CakajNaPustenie;
    VM;
    if Objekt=3 then VykresliMGP(Menu.MGPP[9],@Menu.MBP,@Menu.MSFP)
                else VykresliMGP(Menu.MGPP[10],@Menu.MBP,@Menu.MSFP);
    ZM;
  until (Objekt=3) and (Udalost=8) and Koniec;
{ ----- ukoncenie programu ----- }
  ZavriGrafiku;
  WriteLn('MukoSoft editor fontov pomocou Coonsovych kubik, verzia 1.1.'#13#10'Lubos Saloky, 1999');
{$ENDIF}
END.