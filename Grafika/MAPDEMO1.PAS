program Mapa;
uses MukoGr;
const FontPath='d:\lubo\pascal\units\Classic.mf';
      MapFile='mapdemo1.mb';
      Poz:array[0..24]of byte=(6,8,5,1,1, 6,7,1,2,3, 6,7,4,2,3, 6,7,1,1,2 ,6,7,1,4,5);
var f:file;
    BMP:array[1..8,0..15,0..15]of byte;
    x:word;
BEGIN
  InicializujGrafiku;
  NacitajFontAPaletu(FontPath);
  Assign(f,MapFile);
  Reset(f,1);
  Seek(f,769);
  for x:=1 to 8 do begin
    Seek(f,FilePos(f)+2);   {preskoc rozmery bitmapy}
    BlockRead(f,BMP[x],256);
  end;
  for x:=0 to 24 do begin
    Nastav((x mod 5)*16,(x div 5)*16,0);
    PrilepBitmapu(16,16,Ofs(BMP[Poz[x]]));
  end;
  asm mov ax,0;int 16h;end;
  ZavriGrafiku;
END.

