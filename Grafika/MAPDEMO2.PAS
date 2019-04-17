program Mapa_verzia_2_0;
uses MukoGr;
const Font='d:\lubo\pascal\units\Classic.mf';
      Bitmapy='mapdemo2.mb';
      Pocet=4; {pocet typov bitmap}
      Rozmer=7;{pocet bitmap vedla seba aj pod sebou}
      Poz:array[0..Rozmer*Rozmer-1] of byte=
      (2,3,3,1,1,3,4, 2,2,3,1,3,4,4, 2,2,3,1,1,2,1, 2,2,2,1,1,2,2,
       2,1,2,3,3,3,4, 2,2,2,1,3,4,4, 2,3,2,3,4,1,1);
      Priorita:array[1..Pocet] of byte=(2,3,4,1);
var BMPs:array[1..Pocet,0..23,0..23] of byte;
    x,y,AktPrior:word;
    f:file;
BEGIN
  InicializujGrafiku;
  NacitajFontAPaletu(font);
  Assign(f,Bitmapy);
  Reset(f,1);
  Seek(f,769);
  for x:=1 to Pocet do begin
    Seek(f,FilePos(f)+2);
    BlockRead(f,BMPs[x],24*24);
  end;
  for y:=1 to Pocet do begin
    AktPrior:=Priorita[y];
    for x:=0 to Rozmer*Rozmer-1 do
      if Poz[x]=AktPrior then begin
        Nastav((x mod Rozmer)*16,(x div Rozmer)*16,0);
        PrilepPriehladnuBitmapu(24,24,Ofs(BMPs[Poz[x]]));
      end;{if}
    {for}
  end;{for}
  Nastav(0,0,0);
  VyplnPlochu(16*Rozmer+8,4);
  VyplnPlochu(4,16*Rozmer+8);
  Nastav(4+16*Rozmer,4,0);
  VyplnPlochu(4,16*Rozmer+4);
  Nastav(4,4+16*Rozmer,0);
  VyplnPlochu(16*Rozmer+4,4);
  asm mov ax,0;int 16h;end;
  ZavriGrafiku;
END.