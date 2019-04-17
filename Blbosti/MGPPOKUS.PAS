uses MainGr;
var p:array[1..2] of pointer;
    f:file;
    i:word;
    pBMP:array[1..24] of pointer;
    pFonty,Paleta:pointer;
BEGIN
  NacitajFont('Hlavny8.MSF',pFonty);
  NacitajPaletu('Prechody.MP',Paleta);
  Assign(f,'MapDemo3.MB');
  Reset(f,1);
  Seek(f,769);
  for i:=1 to 24 do NacitajBMP(f,pBMP[i]);
  Close(f);
  Assign(f,'Demo.MGP');
  Reset(f,1);
  Seek(f,16);
  for i:=1 to 2 do NacitajMGP(f,p[i]);
  Close(f);
  InicializujGrafiku;
  NastavPaletu(Paleta);

  VykresliMGP(p[1],@pBMP,@pFonty);
  readln;
  ZmazObrazovku;
  VykresliMGP(p[2],@pBMP,@pFonty);
  readln;
END.