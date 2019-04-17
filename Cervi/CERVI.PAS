program Hra_Cervi;
{$DEFINE LOCAL}
uses Graph,Crt,KeyBoard;
const ObrX:word=550;
      ObrY:word=479;
type TVymenaDat=array[1..4] of record
       BPozX,BPozY:word;
       BHavaria:boolean;
     end;
{ ----- jednotlive cervy ----- }
type TCerv = object
         private
       Cislo:word;
       Farba:byte;
       Rychlost:real;
       Vlavo,Vpravo:byte; { ovladanie }
       PozX,PozY:real;
       SPozX,SPozY:real;  { pozicia o 1 predtym }
       Uhol:real;
       Havaria:boolean;
         public
       procedure Init(Ktory:word;FarbaP:byte);
       procedure SpracujPouzivatela;
       procedure KresliPoziciu;
       procedure PosunPoziciu(Koef:integer); { kolkokrat pri strate prilis vela casu }
       procedure ZapisPoziciu;
       procedure CitajPoziciu;
     end;
{ ----- zastresuje vsetkych cervov ----- }
type THmyz = object
         private
       FWrite, FRead:file of TVymenaDat;
       Buffer:TVymenaDat;
       PCerv:array[1..8] of ^TCerv; { 1-4 lok. zapis, 5-8 siet. zapis }
         public
       constructor Init;
       procedure NastavOvladanie;
       procedure SpracujPouzivatelov;
       function VsetciHavarovali:boolean;
       procedure KresliPozicie; { len vzdialene pozicie }
       procedure PosunPozicie(Koef:integer); { odtial sa vola kreslenie lokalnych }
       procedure ZapisPozicie;
       procedure CitajPozicie;
       destructor Done;
     end;
{ ----- chybove hlasenia ----- }
type TChyba = object
       public procedure Cislo(Ktore:word);
     end;
{ ----- obrazovka a metody hry ----- }
type THra = object
         private
       GD,GM:integer;
       CPartie:word;
       Cas,SCas:longint; { 2 posledne okamihy }
       procedure CakajChvilu;
         public
       constructor Init;
       procedure Partia;
       destructor Done;
     end;
{ ----- pomocne premenne ----- }
var i,j:integer;
    s:string;
{ ----- instancie objektov ----- }
var Hmyz:THmyz;
    Cerv:array[1..8] of TCerv;
    Chyba:TChyba;
    Hra:THra;
    Lokalny:boolean;
{ ----- pomocne subory ----- }
{$I THmyz.INC}
{$I TCerv.INC}
{$I TChyba.INC}
{$I THra.INC}
{ ----- HLAVNY PROGRAM ----- }
BEGIN
{$IFDEF LOCAL}
  Lokalny:=True;
{$ELSE}
  Lokalny:=False;
{$ENDIF}
  InicializujZoznam;
  Hmyz.Init;
  Hra.Init;
  Hmyz.NastavOvladanie;
  Hra.Partia;
  Hra.Done;
{  repeat
    Hmyz.ZapisPozicie;
    Hmyz.CitajPozicie;
  until KeyPressed;}
  Hmyz.Done;
  ZavriZoznam;
  WriteLn(#13#10'Cervi pre siet dvoch poc¡tacov.'#13#10'Lubos Saloky, m j 2000');
  ReadLn;
END.