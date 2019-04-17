program Cislopis;
uses MainGr;

{$DEFINE DEMO}
{$DEFINE xxxOSTRA}

{ ----- S£bory pouz¡van‚ tymto programom: -----
Palety:        Prechody.MP, 3DKlav.MP
Fonty:         Hlavny8.MSF, Hlavny15.MSF, Hlavny11.MSF
Bitmapy:       Cislopis.MB
Procesy:       Cislopis.MGP
In‚ d ta:      Cisla.TXT, CislaDem.TXT - podla toho, ci ide o demo alebo nie
Dokumentacia:  Citajma.TXT
}
{ ----- staticke premenne ----- }
const PocetMB=3;PocetMGP=22;
      Maly=1;Stredny=3;Velky=2;                  {velkosti fontov v poli - 8,15,11}
var MSFP:array[1..3] of ^FontStruc;              {fonty}
    MBP:array[1..PocetMB] of ^BMPStruc;          {bitmapy}
    MGPP:array[1..PocetMGP] of pointer;          {procesy}
{ ----- premenne na volne pouzitie ----- }
var f:file;
    i,j:integer;
    s:string;
    ch:char;
{ ----- deklaracia TRIED objektov ----- }
type
     THlavnyProgram=object                       {HLAVNY PROGRAM}
       MPP,ExtraP:pointer;                       {paleta}
       constructor Init;
       procedure Run;
       destructor Done;
         private
       ftxt:text;
     end;

     PCislo=^TCislo;                             {TU SU CISLA}
     TCislo=object
       Hodnota:string[10];
       Dalsi:PCislo;
     end;

     TLekcia=object                              {VSEOBECNY OBJEKT LEKCIA}
       constructor Init(var ftxt:text;PocetCisel:word;ACisloLekcie:byte);
       procedure CitajCisla;                     {citaci algoritmus}
       procedure VypisInfo;                      {pise na dolny riadok}
       procedure Vyhodnotenie;                   {na konci lekcie}
       procedure Cakaj(Sekund:byte);             {pri vyhodnoteni, aby clovek hned nestlacil Enter}
       destructor Done;                          {zrusi LZ cisel}
         private
       AktCislo:string;
       PocetChyb,PCisel,EsteCisel:word;          {dolny riadok}
       PrveCislo,PosledneCislo,Pom:PCislo;       {pri prechadzani LZ cisel}
       Koniec:boolean;
       PocetBkSp:word;                           {pocet stlaceni BackSpace}
       PocetNapisanychZnakov:word;
{!}    CisloLekcie:byte;                         {dolny riadok; ak nema cislo je tam 100}
       Cas:longint;                              {cas pisania lekcie}
       Rychlost:word;                            {rychlost blikania kurzora}
       MusiBytBezChyby:boolean;
       function PocetZnakovLekcie:word;
     end;

     TUvodna=object(TLekcia)                     {UVODNA LEKCIA}
       procedure Cvicenie;                       {obsahuje iny algoritmus pre uvodny vypis pred cvicenim}
     end;

     TObycajna=object(TLekcia)                   {vacsina ostatnych lekcii}
       procedure Cvicenie;                       {obsahuje uvodny vypis a cvicenie}
     end;

     TZaverecna=object(TLekcia)
       procedure Cvicenie;
       procedure Vyhodnotenie;                   {musi byt bez chyby}
     end;

     TRT=object(TLekcia)                         {Typ Rozcvicka a Test}
       AktualnyMGP:byte;
       procedure Cvicenie;
     end;
{ ----- deklaracia SAMOTNYCH objektov ----- }
var HlavnyProgram:THlavnyProgram;
    Uvodna:TUvodna;
    Prva,Druha,Tretia,Stvrta,Piata,Siesta:TObycajna;
    Zaverecna:TZaverecna;
    Rozcvicka,Test:TRT;
{$I Lekcie.INC}
{$I Hlavny.INC}
{ ----- hlavny program ----- }
BEGIN
  HlavnyProgram.Init;
  HlavnyProgram.Run;
  HlavnyProgram.Done;
END.