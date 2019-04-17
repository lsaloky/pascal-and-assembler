program Konverzia_fontu;
const FontPath='d:\lubo\pascal\units\Prechod.mf';
      VyslPath='d:\lubo\pascal\units\Prechod.mf';
var Font:array[0..255,0..7,0..7] of byte;
    f:file;
    Pism,x,y:word;
BEGIN
  Assign(f,FontPath);
  Reset(f,16384);
  BlockRead(f,Font,1);
  Close(f);
  for Pism:=0 to 255 do
    for y:=0 to 7 do
      for x:=0 to 7 do
        if Font[Pism,x,y]>0 then Font[Pism,x,y]:=x+6;
  Assign(f,VyslPath);
  ReWrite(f,16384);
  BlockWrite(f,Font,1);
  Close(f);
END.

