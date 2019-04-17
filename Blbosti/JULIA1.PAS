program Julia_1;  {prvy pokus s Juliou}
uses MainGr;
const RMin=-2.0;  {okraje obrazovky}
      RMax=2.0;
      IMin=-1.5;
      IMax=1.5;
      CR=0.1;     {konstanta: realna a imaginarna cast}
      CI=-0.1;
var PalP:pointer;
    AbsR,AbsI:word; { aktualny pixel v mierke obrazovky }
    RelR,RelI:real; { prepocet fraktal -> obrazovka }
    R,I:real;       { aktualny pixel v mierke fraktalu }
    R2,I2:real;     { jeho druha mocnina }
    Dif,MaxDif:real;       { rozdiel medzi zý+c a z }
BEGIN
  NacitajPaletu('3-3-2.MP',PalP);
  InicializujGrafiku;
  NastavPaletu(PalP);
  Color:=15;

  MaxDif:=0;
  RelR:=(RMax-Rmin)/320;
  RelI:=(IMax-IMin)/200;
  for AbsI:=0 to 199 do
    for AbsR:=0 to 319 do begin
      R:=RMin+AbsR*RelR;
      I:=IMin+AbsI*RelI;
      R2:=(R*R+I*I)*cos(arctan(I/R)/2);
      I2:=(R*R+I*I)*sin(arctan(I/R)/2);
      R2:=R2+CR;
      I2:=I2+CI;
      Dif:=R2*R2+I2*I2;
      PolozBod(AbsR,AbsI,255-Round(Dif*6));
      if Dif>MaxDif then MaxDif:=Dif;
    end;
{  for AbsR:=0 to 319 do begin
    R:=RMin+AbsR*RelR;
    I:=IMin;
    R2:=(R*R+I*I)*cos(arctan(I/R)/2);
    I2:=(R*R+I*I)*sin(arctan(I/R)/2);
    R2:=R2+CR;
    I2:=I2+CI;
    PolozBod(Round((R2-RMin)/RelR),Round((I2-IMin)/RelI),15);
  end;  }
  CitajZnak;
END.