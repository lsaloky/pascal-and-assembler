program Vytvorenie_farebnej_palety;
uses MainGr;
type TPaleta=array[0..767] of byte;
const RozX=19;RozY=12;
      Odt:array[0..11] of byte=(0,0,0,1,0,0,1,0,2,0,1,1);
{optimalne pridavanie farbovych zloziek pri emulacii 256 odtienov sivej}
      Rozkl:array[0..3,0..3] of byte=((0,2,1,3),(0,1,2,3),(0,1,3,2),(1,0,2,3));
{optimalne porozhadzovanie nepravych odtienov sivej}
      Nadpisy:array[1..4] of string[50]=(
        'Toto je paleta R-G-B v pomere 3-3-2.','Emul`acia 256 odtie~nov sivej.',
        'E~ste mal`e vylep~senie v realistickosti.','Paleta 6-2 pre Jas-Odtie~n.');
var Paleta,PaletaCB,PaletaCista:TPaleta;
    f:file of TPaleta;
    i,j,k,l,iPlus1,iPlus2:integer;
    FP:pointer;
BEGIN
{ ----- vytvorenie ciernobielej palety: CB.mp ----- }
  Assign(f,'CB.mp');
  ReWrite(f);
  for i:=0 to 63 do
    for j:=0 to 11 do
      if i+Odt[j]<64 then PaletaCB[i*12+j]:=i+Odt[j]
                     else PaletaCB[i*12+j]:=63;
  Write(f,PaletaCB);
  Close(f);
{ ----- paleta s 6 bitmi pre jas a 2 bity farba: 0=R,1=G,2=B,3=biela: Cista.mp ----- }
  Assign(f,'Cista.mp');
  ReWrite(f);
  FillChar(PaletaCista,768,#0);
  for i:=0 to 63 do PaletaCista[i*3]:=i;             {odtiene cervenej}
  for i:=64 to 127 do PaletaCista[i*3+1]:=i-64;      {zelenej}
  for i:=128 to 191 do PaletaCista[i*3+2]:=i-128;    {modrej}
  for i:=192 to 255 do begin                         {bielej}
    PaletaCista[i*3]:=i-192;
    PaletaCista[i*3+1]:=i-192;
    PaletaCista[i*3+2]:=i-192;
  end;
  Write(f,PaletaCista);
  Close(f);
{ ----- paleta s 3 bitmi pre R, 3 pre G a 2 pre B zlozku: 3-3-2.mp ----- }
  Assign(f,'3-3-2.mp');
  ReWrite(f);
  for i:=0 to 255 do begin
    Paleta[i*3]:=(i shr 5) * 255 div 28;                {R}
    Paleta[i*3+1]:=((i shr 2) and $07) * 255 div 28;    {G}
    Paleta[i*3+2]:=(i and $03) * 255 div 12;            {B}
  end;
  Write(f,Paleta);
  Close(f);
{ ----- demo s tymito paletami ----- }
  InicializujGrafiku;
  NacitajFont('Hlavny8.msf',FP);
  NastavPaletu(@Paleta);
  for k:=0 to 3 do
    for i:=0 to 7 do
      for j:=0 to 7 do begin
        Color:=i*32+j*4+k;
        VyplnPlochu(i*RozX+(k div 2)*160,j*RozY+(k mod 2)*100,RozX,RozY);
      end;
  VypisPO(160-LengthPixel(FP,Nadpisy[1]) div 2,3,FP,Nadpisy[1],15);
  ReadLn;
  ZmazObrazovku;
  NastavPaletu(@PaletaCB);
  for Color:=0 to 255 do CiaraZvisla(Color,0,200);
  VypisPO(160-LengthPixel(FP,Nadpisy[2]) div 2,3,FP,Nadpisy[2],11);
  ReadLn;
  for j:=0 to 63 do
    for i:=0 to 49 do
      for k:=0 to 3 do
        for l:=0 to 3 do
          PolozBod(j*4+k,i*4+l,j*4+Rozkl[l,k]);
  VypisPO(160-LengthPixel(FP,Nadpisy[3]) div 2,3,FP,Nadpisy[3],11);
  ReadLn;
  ZmazObrazovku;
  NastavPaletu(@PaletaCista);
  for i:=0 to 3 do
    for j:=0 to 63 do begin
      Color:=j+i*64;
      VyplnPlochu(j*5,i*50,5,50);
    end;
  VypisPO(160-LengthPixel(FP,Nadpisy[4]) div 2,3,FP,Nadpisy[4],15);
  ReadLn;
  ZavriGrafiku;
END.