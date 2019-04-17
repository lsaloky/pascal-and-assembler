program Polynomkreslenie; { prirastkovou metodou }
uses MainGr;
const Koef:array[0..3] of integer=(30000,-2,4,2);
      PocX:longint=-32;
      KonX:longint=27;
      PocY:longint=-350;
      KonY:longint=350;
var Prirastok:array[0..3] of longint;
    i,x:longint;
BEGIN
  InicializujGrafiku;
  x:=PocX;
  Prirastok[0]:=Koef[3]*x*x*x div 200
               +Koef[2]*x*x   div 200
               +Koef[1]*x     div 200
               +Koef[0]       div 200;
  Prirastok[1]:=x*x*3*Koef[3]             div 200
               +x*(3*Koef[3]+2*Koef[2])   div 200
               +(Koef[3]+Koef[2]+Koef[1]) div 200;
  Prirastok[2]:=x*Koef[3]*6           div 200
               +(6*Koef[3]+2*Koef[2]) div 200;
  Prirastok[3]:=6*Koef[3] div 200;
  repeat
    PolozBod(Round(((x-PocX)*320) / (KonX-PocX)),
             Round((Prirastok[0]-KonY) / (PocY-KonY) * 200),30);
    for i:=0 to 2 do Inc(Prirastok[i],Prirastok[i+1]);
    Inc(x);
  until x=KonX;
  ReadLn;
  ZavriGrafiku;
END.

