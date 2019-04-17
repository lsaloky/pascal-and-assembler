program HTML_Viewer;
uses Myska,KeyBoard; { nie Mys, Myska !!! }
const NazovSub:string[13]='Test.HTM';
type PRiadok=^TRiadok;
     TRiadok=record
       PrvyZnak,DlzkaRiadka:word;
       Dalsi,Predosly:PRiadok;
       Text:pointer;
     end;
var PrvyRiadok,AktRiadok,HornyRiadok:PRiadok;
    PocetRiadkov,PocetStlpcov:word;
    PocetBajtov:longint;
    Jazyk:byte;    { 1 = anglictina, 2 = slovencina }
{$I ZobrDekl.INC}
{$I SprDekl.INC}
var Zobraz:TZobraz;
    Spracuj:TSpracuj;
{$I Zobraz.INC}
{$I Spracuj.INC}

BEGIN
  Jazyk:=2;
  PocetBajtov:=1222; { zmaz ma }
  New(PrvyRiadok);
  PrvyRiadok^.Predosly:=nil;
  PrvyRiadok^.Dalsi:=nil;
  AktRiadok:=PrvyRiadok;
  HornyRiadok:=PrvyRiadok;
  Spracuj.Init;
  Zobraz.Init;
{  Zobraz.EmulujPridajRiadok;}
  Spracuj.Dokument;
  Zobraz.Dokument;
  Spracuj.Koniec;
  Zobraz.Koniec;
END.