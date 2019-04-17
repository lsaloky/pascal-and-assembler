uses MainGr;
var f:file;
    PalP,ObrP:pointer;
BEGIN
  ObrP:=pointer(longint($A0000));
  InicializujGrafiku;
  NacitajPaletu('MapDemo1.MP',PalP);
  NastavPaletu(PalP);
  Assign(f,'MapDemo1.MB');
  Reset(f,1);
  Seek(f,FileSize(f)-64000);
  BlockRead(f,Mem[$A000:0],64000);
  Close(f);
  ReadLn;
END.