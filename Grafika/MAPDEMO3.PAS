program Mapa_verzia_3_0;
uses MukoGr,Crt,Myska;
const Font='d:\lubo\pascal\units\Classic.mf';
      Bitmapy='mapdemo3.mb';
      Pocet=28;{pocet typov bitmap}
      RozmerX=19;{pocet bitmap vedla seba na obrazovke}
      RozmerY=12;{pod sebou}
      SkutocneX=60;{pocet bitmap vedla seba na mape}
      SkutocneY=40;{pod sebou}
      PocetZmien=500;{pocet zmien susedneho terenu na aktualny}
      Medza:array[1..7] of byte=(1,12,17,19,21,25,255);
var BMPs:array[1..Pocet,0..23,0..23] of byte;
    Pozicie:array[0..SkutocneX+1,0..SkutocneY+1] of byte;
    x,y,z,AktPoz,AktTyp,LavyX,LavyY,StaryX,StaryY:word;
    f:file;
    ch:char;
    Tlacidla:byte;
procedure NahodneGeneruj;{vygeneruje krajinu absolutne nahodne}
begin
  for y:=0 to SkutocneY+1 do
    for x:=0 to SkutocneX+1 do
      Pozicie[x,y]:=7;
  for y:=1 to SkutocneY do
    for x:=1 to SkutocneX do
      Pozicie[x,y]:=Random(23)+1;
end;
procedure Vykresli(InfoS:string);{vykresl¡ aktualnu krajinu}
begin
  if InfoS<>'' then begin
    ZmazObrazovku;
    Nastav(0,0,0);
    VypisPriehladne(InfoS,Hneda);
    ch:=ReadKey;
  end;
  ZmazObrazovku;
  for AktPoz:=1 to 24 do     {!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! len prvych 24 bitmap}
    for y:=1 to RozmerY do
      for x:=1 to RozmerX do begin
        Nastav((x-1)*16,(y-1)*16,0);
        if Pozicie[x+LavyX-1,y+LavyY-1]=AktPoz then PrilepPriehladnuBitmapu(24,24,Ofs(BMPs[Pozicie[x+LavyX-1,y+LavyY-1]]));
      end;{for}
    {for}
  {for}
  Nastav(0,0,0);
  VyplnPlochu(16*RozmerX+8,4);
  VyplnPlochu(4,16*RozmerY+8);
  Nastav(4+16*RozmerX,4,0);
  VyplnPlochu(4,16*RozmerY+4);
  Nastav(4,4+16*RozmerY,0);
  VyplnPlochu(16*RozmerX+4,4);
  if InfoS<>'' then ch:=ReadKey;
end;
{ ----- priemerovanie ----- }
procedure Priemeruj;
begin
  for y:=1 to SkutocneY do
    for x:=1 to SkutocneX do
      Pozicie[x,y]:=Round((Pozicie[x-1,y-1]+Pozicie[x,y-1]+Pozicie[x+1,y-1]
                          +Pozicie[x-1,y]                 +Pozicie[x+1,y]
                          +Pozicie[x-1,y+1]+Pozicie[x,y+1]+Pozicie[x+1,y+1])/8);
    {for}
  {for}
end;
BEGIN
{ ----- incializacia ----- }
  InicializujGrafiku;
  LavyX:=1;LavyY:=1;
  Randomize;
  NacitajFontAPaletu(font);
  Assign(f,Bitmapy);
  Reset(f,1);
  Seek(f,769);
  for x:=1 to Pocet do begin
    Seek(f,FilePos(f)+2);
    BlockRead(f,BMPs[x],24*24);
  end;
{ ----- pracuj ----- }
(*  NahodneGeneruj;
  Vykresli('Uplne nahodne rozlozenie terenu');
  Priemeruj;
  Vykresli('Spriemerovany teren');
{ ----- prepocet vnutri jednotlivych druhov terenu, kvoli roznorodosti ----- }
  for y:=1 to RozmerY do
    for x:=1 to RozmerX do begin
      AktTyp:=0;
      while Pozicie[x,y]>=Medza[AktTyp+1] do Inc(AktTyp);
      Pozicie[x,y]:=Random(Medza[AktTyp+1]-Medza[AktTyp])+Medza[AktTyp];
    end;{for}
  {for}
  Vykresli('Aby nebolo jednotvarne, v ramci'#13'jednotlivych druhov terenu'#13'nahodne rozmniestnenie');
{ ----- najprv vygeneruj a spriemeruj, kde budu kontinenty. Potom nahodne porozhadzuj teren ----- }
  ZmazObrazovku;     *)
  NahodneGeneruj;
  Priemeruj;
  for x:=1 to SkutocneX do
    for y:=1 to SkutocneY do
      if Pozicie[x,y]<12 then Pozicie[x,y]:=Random(11)+1
      else Pozicie[x,y]:=Random(12)+12;
    {for}
  {for}
(*  Vykresli('Po nahodnom generovani a priemerovani'#13'sa nahodne generuje zvlast sus'#13'a zvlast voda');
  *)
{ ----- pretvor suchy teren, aby nebol taky nahodny ----- }
  for z:=1 to PocetZmien do begin
    x:=0;y:=0;                       {hladaj suchy teren}
    while Pozicie[x,y]<12 do begin
      x:=Random(SkutocneX)+1;
      y:=Random(SkutocneY)+1;
    end;
    if (Pozicie[x+1,y]>11) and (Random(2)=0) then Pozicie[x+1,y]:=Pozicie[x,y];
    if (Pozicie[x-1,y]>11) and (Random(2)=0) then Pozicie[x-1,y]:=Pozicie[x,y];
    if (Pozicie[x,y-1]>11) and (Random(2)=0) then Pozicie[x,y-1]:=Pozicie[x,y];
    if (Pozicie[x,y+1]>11) and (Random(2)=0) then Pozicie[x,y+1]:=Pozicie[x,y];
    if (Pozicie[x+1,y+1]>11) and (Random(2)=0) then Pozicie[x+1,y+1]:=Pozicie[x,y];
    if (Pozicie[x+1,y-1]>11) and (Random(2)=0) then Pozicie[x+1,y-1]:=Pozicie[x,y];
    if (Pozicie[x-1,y+1]>11) and (Random(2)=0) then Pozicie[x-1,y+1]:=Pozicie[x,y];
    if (Pozicie[x-1,y+1]>11) and (Random(2)=0) then Pozicie[x-1,y+1]:=Pozicie[x,y];
  end;
{ ----- nahodne rozmiestnenie vnutri jednotlivych druhov terenu ----- }
  for x:=1 to SkutocneX do
    for y:=1 to SkutocneY do begin
      AktTyp:=1;
      while Pozicie[x,y]>=Medza[AktTyp] do Inc(AktTyp);
      repeat
        z:=Random(Medza[AktTyp]-Medza[AktTyp-1])+Medza[AktTyp-1];
      until (z<>Pozicie[x,y]) or (Random(2)=0);
      Pozicie[x,y]:=z;
    end;
  Vykresli('Teren sa specialnym sposobom'#13'zdruzuje a vznikaju suvisle'#13'pasy terenu rovnakeho druhu');
  repeat
    ZistiPoziciu(x,y,Tlacidla);
    if (x<>StaryX) or (y<>StaryY) then begin
      if x>StaryX then Inc(LavyX) else Dec(LavyX);
      if y>StaryY then Inc(LavyY) else Dec(LavyY);
      StaryX:=x;StaryY:=y;
      if LavyX=0 then LavyX:=1;
      if LavyY=0 then LavyY:=1;
      Vykresli('');
      CakajNaVOI;
    end;
  until Tlacidla=1;
{ ----- ukoncenie programu ----- }
  ZavriGrafiku;
END.