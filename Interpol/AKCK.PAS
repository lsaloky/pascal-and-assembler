program Aproximacia_Coonsovymi_kubikami;
uses Graph,Crt;
{ ----- konstanty zobr. sys. ----- }
const Cesta:string[10]='d:\bp\bgi';
      gd:integer=9;
      gm:integer=2;
type TKrivka=object
       PocetHodnot:word;
       tk:real;           { parameter pre pocitanie bodov na krivke }
       tmin,tmax:real;    { pociatocna a koncova hodnota parametra na krivke }
       tkrel:real;        { delta t pri tabelovani na jednotku v poli HodnX }
       AktX,AktY:real;    { bod na krivke }
       HodnX,HodnY:array[0..1000] of real; { po PocetHodnot; pole pre tabelovanie }
         { suradnice su dane vo vlastnej SS; musi sa aplikovat [x/y]m[in/ax] }
       constructor Init;
       procedure SpracujZadanie;
     end;
     TSpline=object
       ts:real;            { parameter pre pocitanie bodov na spline }
       tsrel:real;         { delta t medzi dvoma skutocnymi bodmi splajnu }
       Presnost:real;      { v pixeloch }
       MaxBodov:word;      { kolko je riadiacich bodov }
       SumaX,SumaY:real;   { bod na splajne }
       Cyklus:integer;     { aktualny segment je [Cyklus-3 .. Cyklus] }
       TestMin,TestMax:integer; { indexy v Hodn[X/Y]: hranice testovanej casti krivky }
       DostPresne:boolean;
       RBX,RBY:array[0..50] of real;        { po MaxBodov; riadiace body }
         { suradnice su dane vo vlastnej SS; musi sa aplikovat [x/y]m[in/ax] }
       constructor Init;
       procedure SpracujZadanie;
       procedure Metoda1;
     end;
     TUI=object { User Interface }
       t:real; { na kreslenie krivky / splajnu }
       x,y,xmin,xmax,ymin,ymax,xrel,yrel:real;
       constructor Init;
       procedure KresliSpline(Pocet,Multi:word);
       procedure KresliKrivku;
       destructor Koniec;
     end;
var Spline:TSpline;
    Krivka:TKrivka;
    UI:TUI;

var i,j:integer;
    ch:char;

{$I TKrivka.INC}
{$I TSpline.INC}
{$I TUI.INC}
BEGIN
  Spline.Init;
  Krivka.Init;
  UI.Init;

  Krivka.SpracujZadanie; { tabeluj }
  Spline.SpracujZadanie; { nastav jeho presnost }
  UI.KresliKrivku;
  Spline.Metoda1;

  UI.Koniec;
END.

