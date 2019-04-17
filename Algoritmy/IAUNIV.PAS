program Interpolacie_a_aproximacie; { vsetky druhy kubickych, univerzalne }
uses MainGr;
const Bezier:byte=1;
      RiadiaceBody:array[1..10,1..2] of word=({ riadiace body, koniec (321,0) }
        (20,20),(50,80),(160,30),(290,90),(200,110),(160,190),(80,160),(60,120),(100,110),(321,0));
      Mat:array[1..1,1..4,1..4] of integer=( { matice pre kreslenie kriviek }
        ((1,0,0,0),(-3,3,0,0),(3,-6,3,0),(-1,3,-3,1)));
type TRB=array[1..100,1..2] of word;
     PRB=^TRB;
     TK=array[1..4000,1..2] of word;
     PK=^TK;
{ Vstup: typ krivky, smernik na riadiace body, krok vypoctu.
  Vystup: smernik na vypocitane body, pocet vypocitanych bodov }
function Vypocet(Co:byte;RB:PRB;Presnost:real;K:PK):word;
var t,SumaX,SumaY:real;
    i,j:integer;
begin
  j:=1;t:=0;
  repeat
    SumaX:=0;SumaY:=0;
    for i:=1 to 4 do begin
      SumaX:=SumaX+RB^[i,1]*
                   (Mat[Co,1,i]
                   +Mat[Co,2,i]*t
                   +Mat[Co,3,i]*t*t
                   +Mat[Co,4,i]*t*t*t);
      SumaY:=SumaY+RB^[i,2]*
                   (Mat[Co,1,i]
                   +Mat[Co,2,i]*t
                   +Mat[Co,3,i]*t*t
                   +Mat[Co,4,i]*t*t*t);
    end;
    if SumaX>0 then K^[j,1]:=Round(SumaX);
    if SumaY>0 then K^[j,2]:=Round(SumaY);
    Inc(j);
    t:=t+Presnost;
  until t>=1;
  Vypocet:=j-1;
end;
var PalP,MSFP:pointer;
    Krivka:array[1..200,1..2] of word;
    i,PocetBodov:word;
BEGIN
  InicializujGrafiku;
  NacitajPaletu('Prechody.MP',PalP);
  NacitajFont('Hlavny8.MSF',MSFP);
  NastavPaletu(PalP);
  for i:=1 to 1000 do PocetBodov:=Vypocet(Bezier,PRB(@RiadiaceBody),0.05,PK(@Krivka));
  for i:=1 to PocetBodov do PolozBod(Krivka[i,1],Krivka[i,2],31);
END.