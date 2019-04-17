program Interpolacia_Fergussonovou_kubikou;
uses MainGr;
const Udaje:array[1..4,1..2] of integer=((20,180),(290,80),(-225,-230),(-147,-172));
                                   {2 body a 2 vektory (po 2 suradnice)}
var i,j:integer;
    t,SumaX,SumaY:real;
    Koef:array[1..4] of real;
    PalP,MSFP:pointer;
    Krivka:array[1..100,1..2] of word;
procedure Vypocet;
begin
  t:=0;
  j:=1;
  repeat
    Koef[1]:=1+t*t*(2*t-3);
    Koef[2]:=t*t*(3-2*t);
    Koef[3]:=t+t*t*(t-2);
    Koef[4]:=t*t*(t-1);
    SumaX:=0;
    SumaY:=0;
    for i:=1 to 4 do begin
      SumaX:=SumaX+Koef[i]*Udaje[i,1];
      SumaY:=SumaY+Koef[i]*Udaje[i,2];
    end;
{    PolozBod(Round(SumaX)+5,Round(SumaY)+5,31);
    SumaX:=Udaje[1,1]
          +t*Udaje[3,1]
          +t*t*(-3*Udaje[1,1]-2*Udaje[3,1]+3*Udaje[2,1]-Udaje[4,1])
          +t*t*t*(2*Udaje[1,1]+Udaje[3,1]-2*Udaje[2,1]+Udaje[4,1]);
    SumaY:=Udaje[1,2]
          +t*Udaje[3,2]
          +t*t*(-3*Udaje[1,2]-2*Udaje[3,2]+3*Udaje[2,2]-Udaje[4,2])
          +t*t*t*(2*Udaje[1,2]+Udaje[3,2]-2*Udaje[2,2]+Udaje[4,2]);}
    PolozBod(Round(SumaX),Round(SumaY),31);
    Krivka[j,1]:=Round(SumaX);
    Krivka[j,2]:=Round(SumaY);
    t:=t+0.02;
    Inc(j);
  until t>=1;
end;
BEGIN
  InicializujGrafiku;
  Vypocet;
{  for i:=1 to 100 do PolozBod(Krivka[i,1],Krivka[i,2],0);}
  ReadLn;
  ZavriGrafiku;
END.