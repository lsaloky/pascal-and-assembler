program Editor_bitmapovych_obrazkov;
uses MukoGr,MukoUtil,Myska,Crt,Dos;
{$DEFINE _______MAPEDIT}
const PrikX=205;PrikY=10;
      MiniX=205;MiniY=140;   {160,0}
      Font='d:\lubo\pascal\units\Prechod.mf';
      RozPaleta=4;
      RozBitmapa=4;
      PocetOP=10;
      Aktiv:array[1..PocetOP,1..4] of word=(
        (0,0,0,0),                                         {bitmapa - spracovane zvlast}
        (PrikX,PrikY,PrikX+16,PrikY+16),                   {<}
        (PrikX+20,PrikY,PrikX+36,PrikY+16),                {>}
        (PrikX+40,PrikY,PrikX+80,PrikY+16),                {novy}
        (PrikX,PrikY+20,PrikX+40,PrikY+36),                {zmaz}
        (PrikX+45,PrikY+20,PrikX+109,PrikY+36),            {odstran}
        (PrikX,PrikY+40,PrikX+56,PrikY+56),                {koniec}
        (PrikX,PrikY+60,PrikX+16*RozPaleta,PrikY+60+16*RozPaleta),
        (PrikX+16*RozPaleta+2,PrikY+60,PrikX+22+RozPaleta*16,PrikY+60+16*RozPaleta),
        (PrikX+64,PrikY+40,PrikX+48+64,PrikY+56));          {subor}
      OLH:array[0..PocetOP]of string[40]=(
        '','Kliknutim poloz bod.','Predosla bitmapa.','Dalsia bitmapa.',
        'Pridaj novu bitmapu.','Zmazanie bitmapy.','Odstranenie bitmapy.',
        'Koniec programu.','Vyber si farbu.','Aktualna farba.','Subor s bitmapami');
      Texty:array[2..10] of string[7]=('<','>','NOVA','ZMAZ','ODSTRAN','KONIEC','','','SUBOR');
var Udalost,UStara:integer;
    x,y,z,PomX,PomY,Kolko,Err:word; {kolko bajtov bolo nacitanych pri odstranovani}
    RozX,RozY,Color:byte;           {rozmery aktualnej bitmapy a aktualna farba}
    AktBMP,Tlacidla:byte;           {pocet a aktualna bitmapa}
    BMP:array[0..3601] of byte;     {bitmapy max. 40*40}
    ASubor:SearchRec;
{$IFDEF MAPEDIT}
    VsetkyBMP:array[0..28*24*24] of byte;{vsetky bitmapy}
{$ENDIF}
    s,Subor:string;
    f:file;
    Odstr:longint;                  {pozicia 1. odstranovaneho bajtu}
{$IFDEF MAPEDIT}
procedure ZobrazSusedneBitmapy;
const PosAktX=40;PosAktY=150;
begin
  Nastav(PosAktX-16,PosAktY-16,0);
  VyplnPlochu(56,56);
  PrilepPriehladnuBitmapu(24,24,Ofs(VsetkyBMP)+((AktBMP+19) mod 24)*576);
  Nastav(PosAktX,PosAktY-16,0);
  PrilepPriehladnuBitmapu(24,24,Ofs(VsetkyBMP)+((AktBMP+20) mod 24)*576);
  Nastav(PosAktX+16,PosAktY-16,0);
  PrilepPriehladnuBitmapu(24,24,Ofs(VsetkyBMP)+((AktBMP+21) mod 24)*576);
  Nastav(PosAktX-16,PosAktY,0);
  PrilepPriehladnuBitmapu(24,24,Ofs(VsetkyBMP)+((AktBMP+22) mod 24)*576);
  Nastav(PosAktX,PosAktY,0);
  PrilepPriehladnuBitmapu(24,24,Ofs(VsetkyBMP)+((AktBMP+23) mod 24)*576);
  Nastav(PosAktX+16,PosAktY,0);
  PrilepPriehladnuBitmapu(24,24,Ofs(VsetkyBMP)+((AktBMP+24) mod 24)*576);
  Nastav(PosAktX-16,PosAktY+16,0);
  PrilepPriehladnuBitmapu(24,24,Ofs(VsetkyBMP)+((AktBMP+25) mod 24)*576);
  Nastav(PosAktX,PosAktY+16,0);
  PrilepPriehladnuBitmapu(24,24,Ofs(VsetkyBMP)+((AktBMP+26) mod 24)*576);
  Nastav(PosAktX+16,PosAktY+16,0);
  PrilepPriehladnuBitmapu(24,24,Ofs(VsetkyBMP)+((AktBMP+27) mod 24)*576);
end;
{$ENDIF}
procedure NacitajBitmapu;
begin
  BlockRead(f,RozX,1);
  BlockRead(f,RozY,1);
  BlockRead(f,BMP,RozX*RozY);
end;
procedure ZobrazBitmapu;
var px,py:word;
begin
  Nastav(0,0,0);
  VyplnPlochu(202,200);
  Nastav(MiniX-1,MiniY-1,0);
  VyplnPlochu(42,42);
  Nastav(MiniX-1,MiniY-1,15);
  Ramcek(RozX+2,RozY+2,0);
  for px:=0 to RozX-1 do
    for py:=0 to RozY-1 do begin
      Nastav(RozBitmapa*px,RozBitmapa*py,BMP[py*RozX+px]);
      VyplnPlochu(RozBitmapa,RozBitmapa);
      PolozBod(MiniX+px,MiniY+py,BMP[px+RozX*py]);
    end;
  for px:=0 to RozX do PolozBod(RozBitmapa*px,RozBitmapa*RozY+1,15);
  for py:=0 to RozY do PolozBod(RozBitmapa*RozX+1,RozBitmapa*py,15);
  Nastav(0,RozY*RozBitmapa,15);
  if RozY<>40 then CiaraVodorovna(RozX*RozBitmapa+1);
  Nastav(RozX*RozBitmapa,0,15);
  CiaraZvisla(RozY*RozBitmapa+1);
end;
procedure NovaBitmapa;
begin
  VypniKurzorMysi;
  if Subor='' then begin
    Nastav(0,0,0);
    VyplnPlochu(201,200);
    VypisPriehladne('Nebol zvoleny subor.'#13'Bude vytvoreny novy.'#13#13'Meno suboru:',Hneda);
    Nastav(0,32,0);
    Citaj(12,Hneda);
    Subor:=Ret;
    Assign(f,Subor);
    ReWrite(f,1);
    BlockWrite(f,paleta,768);
    AktBMP:=0;RozX:=0;RozY:=0;
    BlockWrite(f,AktBMP,1);
    ZapniKurzorMysi;
  end;
  Seek(f,FilePos(f)-RozY*RozX);
  BlockWrite(f,BMP,RozY*RozX);
  Seek(f,768);
  BlockRead(f,AktBMP,1);
  Seek(f,768);
  Inc(AktBMP);
  BlockWrite(f,AktBMP,1);
  Seek(f,FileSize(f));
  Nastav(0,0,0);          {vyber rozmerov bitmapy}
  VyplnPlochu(201,200);
  VypisPriehladne('Zvol si velkost bitmapy.',SvetloModra);
  Nastav(0,16,0);
  VypisPriehladne('X-ova:',Hneda);
  Nastav(48,16,0);
  Citaj(3,Bordova);
  Val(Ret,RozX,Err);
  Nastav(0,24,0);
  VypisPriehladne('Y-ova:',Hneda);
  Nastav(48,24,0);
  Citaj(3,Bordova);
  Val(Ret,RozY,Err);
  BlockWrite(f,RozX,1);
  BlockWrite(f,RozY,1);
  for PomX:=0 to 3599 do BMP[PomX]:=0;
  BlockWrite(f,BMP,RozX*RozY);
  ZobrazBitmapu;
  ZapniKurzorMysi;
end;
procedure InicializujSubor;
begin
  if Subor<>'' then begin
    Assign(f,Subor);              {inicializacia suboru}
    {$I-}
    Reset(f,1);
    {$I+}
    if IOResult<>0 then begin
      ReWrite(f,1);
      BlockWrite(f,paleta,768);
      AktBMP:=0;RozX:=0;RozY:=0;
      BlockWrite(f,AktBMP,1);
      ZapniKurzorMysi;
      NovaBitmapa;
    end;
{$IFDEF MAPEDIT}
    Seek(f,771);
    for x:=0 to 24 do begin
      BlockRead(f,VsetkyBMP[x*576],24*24);
      Seek(f,Filepos(f)+2);
    end;
    ZobrazSusedneBitmapy;
{$ENDIF}
    Seek(f,769);
    NacitajBitmapu;
    ZobrazBitmapu;
  end;
end;
procedure InicializujPracovnuPlochu;
begin
  VypniKurzorMysi;
  ZmazObrazovku;
  Nastav(Aktiv[8,1]-1,Aktiv[8,2]-1,15);{kreslenie obvodovych ciar okolo palety}
  Ramcek(16*RozPaleta+23,16*RozPaleta+2,0);
  Nastav(Aktiv[8,3],Aktiv[8,2],15);
  CiaraZvisla(16*RozPaleta+1);
  for x:=0 to 15 do                    {vykreslenie palety}
    for y:=0 to 15 do begin
      Nastav(PrikX+x*RozPaleta,PrikY+60+y*RozPaleta,x+16*y);
      VyplnPlochu(RozPaleta,RozPaleta);
    end;
  for x:=2 to 7 do begin                {vykreslenie tlacidiel}
    Nastav(Aktiv[x,1],Aktiv[x,2],14);
    Ramcek(Aktiv[x,3]-Aktiv[x,1],Aktiv[x,4]-Aktiv[x,2],0);
    Nastav(Aktiv[x,1]+4,Aktiv[x,2]+4,0);
    VypisPriehladne(Texty[x],SvetloModra);
  end;
  Nastav(Aktiv[10,1],Aktiv[10,2],14);
  Ramcek(Aktiv[10,3]-Aktiv[10,1],Aktiv[10,4]-Aktiv[10,2],0);
  Nastav(Aktiv[10,1]+4,Aktiv[10,2]+4,0);
  VypisPriehladne(Texty[10],SvetloModra);
  AktBMP:=1;Color:=25;
  Nastav(Aktiv[8,3]+1,Aktiv[8,2],Color);
  VyplnPlochu(20,16*RozPaleta);
  ZapniKurzorMysi;
end;
BEGIN
{ ----- inicializacia ----- }
  Subor:='';
  InicializujGrafiku;
  NacitajFontAPaletu(Font);
  InicializujPracovnuPlochu;
  InicializujSubor;
  ZapniKurzorMysi;
{ ----- cakanie na udalost ----- }
  UStara:=0;
  repeat
    repeat
      ZistiPoziciu(x,y,Tlacidla);
      x:=x div 2;
      Udalost:=0;
      for z:=1 to PocetOP do
        if (x>=Aktiv[z,1]) and (x<=Aktiv[z,3]) and (y>=Aktiv[z,2]) and (y<=Aktiv[z,4]) then Udalost:=z;
      if (x<RozBitmapa*RozX) and (y<RozBitmapa*RozY) then Udalost:=1;
      if (Udalost<>UStara) and (RozY<38) then begin
        VypniKurzorMysi;
        Nastav(0,192,0);
        VyplnPlochu(201,8);
        VypisPriehladne(OLH[Udalost],SvetloModra);
        UStara:=Udalost;
        ZapniKurzorMysi;
      end;
    until Tlacidla>0;
    if (Udalost<>8) and (Udalost<>1) then
      repeat ZistiPoziciu(PomX,PomY,Tlacidla); until Tlacidla=0;
{ ----- spracovanie udalosti ----- }
    case Udalost of
      1:begin{kreslenie bitmapy}
        PomX:=x div RozBitmapa;
        PomY:=y div RozBitmapa;
        if BMP[PomX+PomY*RozX]<>Color then begin
          VypniKurzorMysi;
          Nastav(PomX*RozBitmapa,PomY*RozBitmapa,Color);
          VyplnPlochu(RozBitmapa,RozBitmapa);
          BMP[PomX+PomY*RozX]:=Color;
          PolozBod(MiniX+PomX,MiniY+PomY,Color);
{$IFDEF MAPEDIT}
          VsetkyBMP[AktBMP*576+PomY*24+PomX]:=Color;
          PolozBod(40+PomX,150+PomY,Color);
{$ENDIF}
          ZapniKurzorMysi;
        end;
      end;
      2:begin{predosla bitmapa}
        Seek(f,FilePos(f)-RozY*RozX);
        BlockWrite(f,BMP,RozY*RozX);
        if AktBMP>1 then begin
          Seek(f,769);
          for PomX:=1 to AktBMP-1 do NacitajBitmapu;
          Dec(AktBMP);
          ZobrazBitmapu;
          UStara:=0;
        end;
      end;
      3:begin{dalsia bitmapa}
        Seek(f,FilePos(f)-RozY*RozX);
        BlockWrite(f,BMP,RozY*RozX);
        if not EOF(f) then begin
          NacitajBitmapu;
          ZobrazBitmapu;
          UStara:=0;
          Inc(AktBMP);
        end;
      end;
      4:NovaBitmapa;{nova bitmapa}
      5:begin{zmazanie bitmapy}
        for PomX:=0 to 3599 do BMP[PomX]:=Color;
        ZobrazBitmapu;
      end;
      6:begin{odstranenie bitmapy}
        Odstr:=FilePos(f)-RozX*RozY-2;
        Seek(f,Odstr);
        while not EOF(f) do begin
          Seek(f,Odstr+RozX*RozY+2);
          BlockRead(f,BMP,RozX*RozY+2,Kolko);
          Seek(f,Odstr);
          BlockWrite(f,BMP,Kolko);
          Odstr:=Odstr+RozX*RozY+2;
        end;
        Seek(f,FileSize(f)-RozX*RozY-2);
        Truncate(f);
        Seek(f,768);
        BlockRead(f,AktBMP,1);
        Dec(AktBMP);
        Seek(f,768);
        BlockWrite(f,AktBMP,1);
        AktBMP:=1;
        NacitajBitmapu;
        ZobrazBitmapu;
      end;
      8:begin{vyber farby}
        PomX:=(x-Aktiv[8,1]) div RozPaleta;
        PomY:=(y-Aktiv[8,2]) div RozPaleta;
        if 16*PomY+PomX<>Color then begin
          Color:=16*PomY+PomX;
          VypniKurzorMysi;
          Nastav(Aktiv[8,3]+1,Aktiv[8,2],Color);
          VyplnPlochu(20,16*RozPaleta);
          ZapniKurzorMysi;
        end;
      end;
      10:begin
        SuboroveOkno(80,20,'Subory:','mb',ASubor);
        CakajNaPustenie;
        Subor:=ASubor.Name;
        VypniKurzorMysi;
        InicializujPracovnuPlochu;
        if Subor<>'' then begin
          InicializujSubor;
        end else if RozX>0 then ZobrazBitmapu;
        ZapniKurzorMysi;
      end;
    end;
{$IFDEF MAPEDIT}
    if (Udalost<>8) and (Udalost<>1) then ZobrazSusedneBitmapy;
{$ENDIF}
  until Udalost=7;
{ ----- ukoncenie programu ----- }
  if Subor<>'' then begin
    Seek(f,FilePos(f)-RozY*RozX);
    BlockWrite(f,BMP,RozY*RozX);
    Close(f);
  end;
  VypniKurzorMysi;
END.