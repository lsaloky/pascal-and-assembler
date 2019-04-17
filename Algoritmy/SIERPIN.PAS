program Kreslenie_Sierpinskeho_koberca;
uses MainGr;
procedure Sierpinskeho_koberec(MinX,MaxX,MinY,MaxY:word);
var StredX,StredY,StvrtX,TristvrtX:word;
    V1,V2,V3:byte;
begin
  if MinX<MaxX-1 then begin
    StredX:=(MinX+MaxX) shr 1;
    StredY:=(MinY+MaxY) shr 1;
    StvrtX:=(MinX+StredX) shr 1;
    TristvrtX:=(StredX+MaxX) shr 1;
    V1:=ZistiBod(StredX,MinY);
    V2:=ZistiBod(MinX,MaxY);
    V3:=ZistiBod(MaxX,MaxY);
    PolozBod(StvrtX,StredY,(V1+V2) shr 1);
    PolozBod(TristvrtX,StredY,(V1+V3) shr 1);
    PolozBod(StredX,MaxY,(V3+V2) shr 1);
    Sierpinskeho_koberec(StvrtX,TristvrtX,MinY,StredY);
    Sierpinskeho_koberec(MinX,StredX,StredY,MaxY);
    Sierpinskeho_koberec(StredX,MaxX,StredY,MaxY);
  end;
end;
var p:pointer;
BEGIN
  InicializujGrafiku;
  NacitajPaletu('Prechody.MP',p);
  NastavPaletu(p);
  PolozBod(161,0,15);
  PolozBod(61,199,169);
  PolozBod(261,199,91);
  Sierpinskeho_koberec(61,261,0,199);
  ReadLn;
  ZavriGrafiku;
END.