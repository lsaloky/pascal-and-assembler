program Pokusy_s_procedurami_Vypis;
uses MainGr;
var PalP,FontP:pointer;
    BMP:array[1..12] of ^BMPStruc;
    f:file;
    i:integer;{longint}
BEGIN
  InicializujGrafiku;
  NacitajPaletu('Prechody.MP',PalP);
  NacitajFont('19.msf',FontP);
  NastavPaletu(PalP);
  Assign(f,'d:\lubo\pascal\hry\balley.MB');
  Reset(f,1);
  Seek(f,769);
  for i:=1 to 12 do NacitajBMP(f,pointer(BMP[i]));
  Close(f);
  Color:=4;VyplnPlochu(0,0,100,100);
  Vypis(0,0,FontP,'AAA',0);
  ReadLn;
{  Color:=15;
  CiaraZvisla(19,0,100);
  OknoXMin:=20;
  CiaraZvisla(61,0,100);
  OknoXMax:=60;
  CiaraVodorovna(0,19,100);
  OknoYMin:=20;
  CiaraVodorovna(0,61,100);
  OknoYMax:=60;}

{  for i:=1 to 20000 do PrilepBMPPO(10,10,BMP[11]);}
{  for i:=1 to 5000000 do PolozBod(0,0,31);}
END.