program Editor_animacii;
uses MukoGr,MukoUtil,Myska,Crt,Dos;
const FontPath='d:\lubo\pascal\units\Prechod.mf';
      HMenuX=2;HMenuY=2;                                {pozicia hlavneho menu}
      HAnimX=75;                                        {pozicia zoznamu animacii v hlavnom menu}
      HPocetOP=7;                                       {pocet ovladacich prvkov v hlavnom menu}
      HAktiv:array[1..HPocetOP,1..4] of word=(          {hlavne menu - ovladacie prvky}
        (HAnimX,HMenuY,319,199),                        {vyber animacie}
        (HMenuX,HMenuY,HMenuX+64,HMenuY+16),            {Edituj}
        (HMenuX,HMenuY+20,HMenuX+64,HMenuY+36),         {Pridaj}
        (HMenuX,HMenuY+40,HMenuX+64,HMenuY+56),         {Odstran}
        (HMenuX,HMenuY+60,HMenuX+64,HMenuY+76),         {Subor}
        (HMenuX,HMenuY+80,HMenuX+64,HMenuY+96),         {Novy}
        (HMenuX,HMenuY+100,HMenuX+64,HMenuY+116));       {Koniec}
      HOLH:array[0..HPocetOP] of string[40]=(           {hlavne menu - help}
        '','Vyber si animaciu.','Edituj animaciu.','Pridaj novu animaciu.',
        'Zlikviduj animaciu.','Zadaj subor s animaciami.','Nova animacia.','Koniec programu.');
      HTexty:array[2..HPocetOP] of string[8]=('EDITUJ','PRIDAJ','ODSTRAN',' SUBOR',' NOVY','KONIEC');
      RozPal=5;RozBMP=10;                               {rozmer palety,rozmer bitmapy}
      SnimkyY=174;                                      {pozicia zoznamu snimkov}
      PrikX=185;PrikY=1;                                {blok prikazov v hlavnom menu}
      PalX=181;PalY=89;                                 {pozicia palety}
      PocetOP=11;                                       {pocet ovladacich prvkov v menu editacie}
{!!!!}DlzkaAnim=4096;                                   {VELKOST BUFFRA ANIMACIE}
      Aktiv:array[1..PocetOP,1..4] of word=(            {menu editacie - ovladacie prvky}
        (2,2,2,2),                                      {aktualny snimok}
        (PrikX,PrikY,PrikX+64,PrikY+16),                {prechod}
        (PrikX,PrikY+20,PrikX+64,PrikY+36),             {odstran}
        (PrikX,PrikY+40,PrikX+64,PrikY+56),             {kopiruj}
        (PrikX+72,PrikY,PrikX+112,PrikY+16),            {zmaz}
        (PrikX+72,PrikY+20,PrikX+112,PrikY+36),         {uloz}
        (PrikX+72,PrikY+40,PrikX+112,PrikY+56),         {pust}
        (PrikX,PrikY+60,PrikX+112,PrikY+76),            {naspat}
        (PalX,PalY,PalX+16*RozPal,PalY+16*RozPal),      {paleta}
        (PalX+16*RozPal,PalY,PalX+16*RozPal+40,PalY+16*RozPal),{aktualna farba}
        (0,SnimkyY,319,SnimkyY+20));                    {aktualny snimok}
      OLH:array[0..PocetOP] of string[40]=(             {menu editacie - help}
        '','Poloz bod.','Plynula animacia bodu.','',
        'Kopiruj snimok.','Premaz snimok.','Uloz animaciu.',
        'Spust animaciu.','Naspat do hlavneho menu.','Vyber si farbu.',
        'Aktualna farba.','Aktualny snimok.');
      Texty:array[2..8] of string[10]=(                 {menu editacie - tlacidla}
        'PRECHOD','','KOPIRUJ','ZMAZ','ULOZ','PUST','   NASPAT');
var PomX,PomY,x,y,z,Udalost,UStara,HUdalost,HUStara,Kolko,Err:word;
    ASubor:SearchRec;                  {pri volbe suboru}
    Odstr:longint;                     {Kolko a Odstr pri odstranovani}
    s,t:string;                        {pri vypise cisel ako retazcov}
    Subor:string;
    Cesta:DirStr;
    Meno:NameStr;
    Pripona:ExtStr;                    {pri volbe suboru - FSplit}
    PomZ:integer;
    Tlacidla,Color,PomB:byte;
    CZ,CK:byte;                        {zdrojova a cielova farba}
    Brzda:byte;                        {pocet vert. zatemneni pri animacii}
    Zdroj,Ciel:shortint;               {pri kopirovani zdrojova a cielova snimka}
    ZacX,ZacY,KonX,KonY:integer;       {pri prechode zdrojovy a cielovy bod}
    DeX,DeY,DeS,DeC:integer;           {a ich rozdiel suradnic, rozdiel snimkov, rozdiel farieb}
    RozX,RozY:byte;                    {rozmery snimku aktualnej animacie}
    PocAnim,AktAnim:byte;              {pocet animacii, aktualna animacia}
    PocSnim,AktSnim:byte;              {pocet snimkov v aktualnej animacii, aktualny snimok}
    Anim:array[0..DlzkaAnim-1] of byte;{tu je animacia}
    PosAktAnim:longint;                {pozicia zaciatku aktualnej animacie}
    ch:char;
    AnimInfo:array[1..255] of record   {informacie o vsetkych animaciach}
                                XRes,YRes,NumOfSnim:byte;
                                Poz:longint;
                              end;
    f:file;                            {Struktura suboru pre animaciu:
      Blok: 1 bajt  - pocet snimkov      |      768  bajtov - paleta
            2 bajty - rozlisenie x,y     |      1    bajt   - pocet animacii
            dalej snimky po poradi       |      Blok bajtov - jednotlive animacie}
procedure VykresliAktualnuSnimku;
begin
  Nastav(0,0,0);                       {cistenie}
  VyplnPlochu(16*RozBMP+4,16*RozBMP+4);
  Nastav(1,1,15);                      {obvodove ciary}
  CiaraVodorovna(RozX*RozBMP+1);
  CiaraZvisla(RozY*RozBMP+1);
  Nastav(1,RozY*RozBMP+2,15);
  CiaraVodorovna(RozX*RozBMP+1);
  Nastav(RozX*RozBMP+2,1,15);
  CiaraZvisla(RozY*RozBMP+2);
  for PomX:=0 to RozX do begin         {bodky dookola rastra}
    PolozBod(RozBMP*PomX+1,RozBMP*RozY+3,15);
    PolozBod(RozBMP*PomX+1,0,15);
  end;
  for PomY:=0 to RozY do begin
    PolozBod(RozBMP*RozX+3,RozBMP*PomY+1,15);
    PolozBod(0,RozBMP*PomY+1,15);
  end;
  Nastav(0,192,0);                     {vycisti riadok s helpom}
  VyplnPlochu(319,8);
  for PomY:=0 to RozY-1 do             {vypln raster snimkom}
    for PomX:=0 to RozX-1 do begin
      Nastav(PomX*RozBMP+2,PomY*RozBMP+2,Anim[AktSnim*RozX*RozY+PomY*RozX+PomX]);
      VyplnPlochu(RozBMP,RozBMP);
    end;{for 2}
end;{proc}
procedure ZobrazAnimaciu;
begin
  VykresliAktualnuSnimku;
  Nastav(0,SnimkyY-2,5);               {vykreslenie jednotlivych snimkov}
  VyplnPlochu(320,20);
  for PomZ:=0 to PocSnim-1 do begin
    Nastav(2+PomZ*(RozX+4),SnimkyY,0);
    PrilepBitmapu(RozX,RozY,Ofs(Anim[PomZ*RozX*RozY]));
  end;{for}
  Nastav(1,SnimkyY-1,15);              {obdlznik okolo aktualnej snimky}
  Obdlznik(RozX+2,RozY+2);
end;{proc}
function VyberMysou(Vyzva:string;Oblast:byte):byte;
var ppomx,ppomy:word;
begin
  VypniKurzorMysi;
  Nastav(0,192,0);
  VyplnPlochu(319,8);
  VypisPriehladne(Vyzva,SvetloModra);
  ZapniKurzorMysi;
  repeat
    ZistiPoziciu(x,y,Tlacidla);
    x:=x div 2;
    if KeyPressed then ch:=ReadKey;
    if ch=#27 then Tlacidla:=2;        {Escape a prave tlacidlo ukoncuje}
    if (Oblast=1) and(x<=RozX*RozBMP) and (y<=RozY*RozBMP+2) and (x>=2) and (y>=2) then begin
      ppomx:=x;ppomy:=y;x:=2;y:=2;     {oblbovak pre Aktiv[1, ]}
    end;{if}
  until ((x>=Aktiv[Oblast,1]) and
         (x<=Aktiv[Oblast,3]) and
         (y>=Aktiv[Oblast,2]) and
         (y<=Aktiv[Oblast,4]) and (Tlacidla=1)) or (Tlacidla=2);
  repeat ZistiPoziciu(PomX,PomY,PomB); until PomB=0;
  if Oblast=1 then begin               {obnov pre Aktiv[1, ]}
    x:=ppomx;y:=ppomy;
  end;{if}
  VypniKurzorMysi;
  Nastav(0,192,0);
  VyplnPlochu(319,8);
  ZapniKurzorMysi;
end;{func}
procedure ZmenAktualnuSnimku;
begin
 { BlockWrite(f,Anim[AktSnim*RozX*RozY],RozX*RozY);}
  PomZ:=(x-2) div (RozX+4);
  if PomZ<PocSnim then begin
    VypniKurzorMysi;
    Nastav(1+AktSnim*(RozX+4),SnimkyY-1,5);
    Obdlznik(RozX+2,RozY+2);
    Nastav(1+PomZ*(RozX+4),SnimkyY-1,15);
    Obdlznik(RozX+2,RozY+2);
    AktSnim:=PomZ;
    VykresliAktualnuSnimku;
    ZapniKurzorMysi;
  end;{if}
end;{proc}
procedure PolozBodDoRastra;
begin                          {poloz bod}
  PomX:=(x-2) div RozBMP;
  PomY:=(y-2) div RozBMP;
  if Anim[AktSnim*RozX*RozY+PomY*RozX+PomX]<>Color then begin
    VypniKurzorMysi;
    Anim[AktSnim*RozX*RozY+PomY*RozX+PomX]:=Color;
    Nastav(PomX*RozBMP+2,PomY*RozBMP+2,Color);
    VyplnPlochu(RozBMP,RozBMP);
    PolozBod(2+AktSnim*(RozX+4)+PomX,SnimkyY+PomY,Color);
    ZapniKurzorMysi;
  end;{if}
end;{proc}
procedure NastavFarbu;
begin                          {paleta}
  PomX:=(x-PalX) div RozPal;
  PomY:=(y-PalY) div RozPal;
  if PomX+16*PomY<>Color then begin
    Color:=PomX+16*PomY;
    VypniKurzorMysi;
    Nastav(PalX+16*RozPal+1,PalY,Color);
    VyplnPlochu(39,16*RozPal);
    ZapniKurzorMysi;
  end;{if}
end;{proc}
procedure NovaAnimacia;
const PosunX=80;PosunY=48;
begin
  VypniKurzorMysi;
  Nastav(PosunX,PosunY,0);
  VypisPriehladne('Pridanie animacie.'#13'Rozmery snimku:'#13'X-ovy:',HnedoCervena);
  Nastav(PosunX+52, PosunY+16,0);Citaj(2,Zlta);Val(Ret,RozX,Err);
  Nastav(PosunX,    PosunY+24,0);VypisPriehladne('Y-ovy:',HnedoCervena);
  Nastav(PosunX+52, PosunY+24,0);Citaj(2,Zlta);Val(Ret,RozY,Err);
  Nastav(PosunX,    PosunY+32,0);VypisPriehladne('Pocet snimkov:',HnedoCervena);
  Nastav(PosunX+112,PosunY+32,0);Citaj(2,Zlta);Val(Ret,PocSnim,Err);
  AnimInfo[AktAnim].XRes:=RozX;
  AnimInfo[AktAnim].YRes:=RozY;
  AnimInfo[AktAnim].NumOfSnim:=PocSnim;
  for x:=0 to DlzkaAnim-1 do Anim[x]:=0;
  AnimInfo[AktAnim].Poz:=FilePos(f);
  BlockWrite(f,PocSnim,1);
  BlockWrite(f,RozX,1);
  BlockWrite(f,RozY,1);
  BlockWrite(f,Anim,PocSnim*RozY*RozX);
  ZapniKurzorMysi;
end;{proc}

procedure VypisInfo(index:word);
begin
  Nastav(HMenuX,HMenuY+120,0);
  VyplnPlochu(56,64);
  VypisPriehladne('Rozmery:'#13#13#13#13'Pocet'#13'snimkov:',Zlta);
  Str(AnimInfo[index].XRes,s);
  Str(AnimInfo[index].YRes,t);
  s:=s+' x '+t;
  Nastav(HMenuX,HMenuY+136,0);
  VypisPriehladne(s,Zlta);
  Str(AnimInfo[index].NumOfSnim,s);
  Nastav(HMenuX+16,HMenuY+172,0);
  VypisPriehladne(s,Zlta);
end;{proc}
procedure InicializujHlavneMenu;
begin
  VypniKurzorMysi;
  AktAnim:=1;
  ZmazObrazovku;
  for PomX:=2 to HPocetOP do begin      {vykreslenie tlacidiel}
    Nastav(HAktiv[PomX,1],HAktiv[PomX,2],15);
    Ramcek(HAktiv[PomX,3]-HAktiv[PomX,1],HAktiv[PomX,4]-HAktiv[PomX,2],6);
    Nastav(HAktiv[PomX,1]+4,HAktiv[PomX,2]+4,0);
    VypisPriehladne(HTexty[PomX],Oranzova);
  end;{for}
  if Subor<>'' then begin
    Assign(f,Subor);                     {inicializacia suboru}
    {$I-}
    Reset(f,1);
    {$I+}
    if IOResult<>0 then begin            {neexistujuci subor automaticky vytvori}
      ReWrite(f,1);
      AktSnim:=0;AktAnim:=1;PocAnim:=1;
      BlockWrite(f,Paleta,768);
      BlockWrite(f,PocAnim,1);
      NovaAnimacia;
    end;
    Seek(f,768);
    BlockRead(f,PocAnim,1);
    Seek(f,768);
    BlockRead(f,PocAnim,1);
    for PomX:=1 to PocAnim do
      with AnimInfo[PomX] do begin
        Poz:=FilePos(f);
        BlockRead(f,NumOfSnim,1);
        BlockRead(f,XRes,1);
        BlockRead(f,YRes,1);
        BlockRead(f,Anim,XRes*YRes*NumOfSnim);{presun na dalsiu animaciu}
        Nastav(HAnimX+20*((PomX-1) mod 12),HMenuY+20*((PomX-1) div 12),10);
        Adresa:=Adresa-321;
        Obdlznik(XRes+2,YRes+2);
        Adresa:=Adresa+641;
        PrilepBitmapu(XRes,YRes,Ofs(Anim));
      end;{with}
    Nastav(HAnimX-1+20*((AktAnim-1) mod 12),HMenuY-1+20*((AktAnim-1) div 12),15);
    Obdlznik(AnimInfo[AktAnim].XRes+2,AnimInfo[AktAnim].YRes+2);{vykreslenie noveho}
    VypisInfo(AktAnim);
  end;
  ZapniKurzorMysi;
end;{proc}
procedure VyberAnimaciu;
begin
  PomY:=(x-HAnimX) div 20+1+((y-HMenuY) div 20)*12;
  if PomY<=PocAnim then begin
    VypniKurzorMysi;
    Nastav(HAnimX-1+20*((AktAnim-1) mod 12),HMenuY-1+20*((AktAnim-1) div 12),10);
    Obdlznik(AnimInfo[AktAnim].XRes+2,AnimInfo[AktAnim].YRes+2);{premazanie stareho obdlznika}
    AktAnim:=PomY;
    Nastav(HAnimX-1+20*((AktAnim-1) mod 12),HMenuY-1+20*((AktAnim-1) div 12),15);
    Obdlznik(AnimInfo[AktAnim].XRes+2,AnimInfo[AktAnim].YRes+2);{vykreslenie noveho}
    VypisInfo(AktAnim);
    ZapniKurzorMysi;
  end;{if}
end;{proc}
BEGIN
{ ----- inicializacia a vykreslenie ovladacich prvkov hlavneho menu ----- }
  InicializujGrafiku;
  AktAnim:=1;
  NacitajFontAPaletu(FontPath);
  InicializujHlavneMenu;
  AktAnim:=1;x:=HAnimX+1;y:=10;
  VyberAnimaciu;
  ZapniKurzorMysi;
{ ----- cakanie na udalost v hlavnom menu ----- }
  HUstara:=0;
  repeat
    repeat
      ZistiPoziciu(x,y,Tlacidla);
      x:=x div 2;
      HUdalost:=0;
      for z:=1 to HPocetOP do
        if (x>=HAktiv[z,1]) and (x<=HAktiv[z,3]) and (y>=HAktiv[z,2]) and (y<=HAktiv[z,4]) then HUdalost:=z;
      if HUdalost<>HUStara then begin
        VypniKurzorMysi;
        Nastav(0,192,0);
        VyplnPlochu(319,8);
        VypisPriehladne(HOLH[HUdalost],SvetloModra);
        HUStara:=HUdalost;
        ZapniKurzorMysi;
      end;{if}
    until Tlacidla=1;
    repeat ZistiPoziciu(PomX,PomY,Tlacidla); until Tlacidla=0;
{ ----- spracovanie udalosti v hlavnom menu ----- }
    case HUdalost of
      1:VyberAnimaciu;  {vyber animacie}
      2:begin           {editacia animacie}
        with AnimInfo[AktAnim] do begin
          PosAktAnim:=Poz;
          RozX:=XRes;
          RozY:=YRes;
          PocSnim:=NumOfSnim;
        end;{with}
{ ----- editacia animacie - inicializacia ----- }
        Seek(f,PosAktAnim);
        VypniKurzorMysi;
        AktSnim:=0;
        ZmazObrazovku;
        for PomX:=2 to 8 do begin            {vykreslenie tlacidiel}
          Nastav(Aktiv[PomX,1],Aktiv[PomX,2],15);
          Ramcek(Aktiv[PomX,3]-Aktiv[PomX,1],Aktiv[PomX,4]-Aktiv[PomX,2],6);
          Nastav(Aktiv[PomX,1]+4,Aktiv[PomX,2]+4,0);
          VypisPriehladne(Texty[PomX],Oranzova);
        end;{for}
        Nastav(PalX-1,PalY-1,15);            {vykreslenie ramceka okolo palety a akt. farby}
        Ramcek(16*RozPal+42,16*RozPal+2,0);
        Nastav(PalX+16*RozPal,PalY-1,15);
        CiaraZvisla(16*RozPal+2);
        Color:=25;                           {vykreslenie aktualnej farby a textu}
        Nastav(PalX+16*RozPal+1,PalY,Color);
        VyplnPlochu(39,16*RozPal);
        Nastav(PalX,PalY-10,0);
        VypisPriehladne('PALETA    FARBA',Hneda);
        for PomX:=0 to 15 do
          for PomY:=0 to 15 do begin         {vykreslenie palety}
            Nastav(PomX*RozPal+PalX,PomY*RozPal+PalY,PomX+16*PomY);
            VyplnPlochu(RozPal,RozPal);
          end;{for 2}
        BlockRead(f,PocSnim,1);{nacitanie animacie z disku}
        BlockRead(f,RozX,1);
        BlockRead(f,RozY,1);
        BlockRead(f,Anim[0],RozY*RozX*PocSnim);
        ZobrazAnimaciu;
        ZapniKurzorMysi;
{ ----- cakanie na udalost v menu editacie ----- }
        Ustara:=0;
        repeat
          repeat
            ZistiPoziciu(x,y,Tlacidla);
            x:=x div 2;
            Udalost:=0;
            for z:=1 to PocetOP do
              if (x>=Aktiv[z,1]) and (x<=Aktiv[z,3]) and (y>=Aktiv[z,2]) and (y<=Aktiv[z,4]) then Udalost:=z;
            if (x<RozBMP*RozX) and (y<RozBMP*RozY) then Udalost:=1;
            if (Udalost<>UStara) and (RozY<38) then begin
              VypniKurzorMysi;
              Nastav(0,192,0);
              VyplnPlochu(319,8);
              VypisPriehladne(OLH[Udalost],SvetloModra);
              UStara:=Udalost;
              ZapniKurzorMysi;
            end;{if}
          until Tlacidla=1;
{ ----- spracovanie udalosti v menu editacie ----- }
          if (Udalost<>9) and (Udalost<>1) and (Udalost<>0) then
            repeat ZistiPoziciu(PomX,PomY,Tlacidla); until Tlacidla=0;
          case Udalost of
            1:if (x>2) and (y>2) then PolozBodDoRastra;  {poloz bod}
            2:begin                          {prechod rovnomerny}
              VyberMysou('Klikni na zdrojovu snimku.',11);
              if Tlacidla=1 then begin
                ZmenAktualnuSnimku;
                Zdroj:=AktSnim;                          {aktualna snimka zdroja}
                VyberMysou('Klikni na bod v zdrojovom obrazku,',1);
                if Tlacidla=1 then begin
                  PolozBodDoRastra;
                  ZacX:=PomX;                             {aktualne suradnice zdroja}
                  ZacY:=PomY;
                  CZ:=Anim[Zdroj*RozX*RozY+ZacY*RozX+ZacX];{aktualna farba zdroja}
                  VyberMysou('Klikni na cielovu snimku.',11);
                  if Tlacidla=1 then begin
                    ZmenAktualnuSnimku;
                    Ciel:=AktSnim;                        {aktualna snimka ciela}
                    VyberMysou('Zvol farbu cieloveho snimku.',9);
                    if Tlacidla=1 then begin
                      NastavFarbu;
                      CK:=Color;{aktualna farba ciela}
                      VyberMysou('Klikni na bod v cielovom obrazku.',1);
                      if Tlacidla=1 then begin
                        PolozBodDoRastra;
                        KonX:=PomX;                          {aktualne suradnice ciela}
                        KonY:=PomY;
                        DeX:=KonX-ZacX;                       {aktualny rozdiel suradnic}
                        DeY:=KonY-ZacY;
                        DeS:=Ciel-Zdroj;                      {aktualny rozdiel snimkov}
                        DeC:=CK-CZ;                           {aktualny rozdiel farieb}
                        for PomZ:=0 to Ciel-Zdroj do begin
                          Anim[(PomZ+Zdroj)*RozX*RozY+   {PomZ-ta snimka}
                          (ZacY+(PomZ*DeY) div DeS)*RozX+{prebieha linearne ZacY -> KonY}
                          ZacX+(PomZ*DeX) div DeS]:=     {prebieha linearne ZacX -> KonX}
                          CZ+(PomZ*DeC) div DeS;         {prebieha linearne CZ -> CK}
                        end;{for}
                        ZobrazAnimaciu;
                        AktSnim:=0;
                        Nastav(1+Ciel*(RozX+4),SnimkyY-1,5);
                        Obdlznik(RozX+2,RozY+2);
                        Nastav(1+AktSnim*(RozX+4),SnimkyY-1,15);
                        Obdlznik(RozX+2,RozY+2);
                      end;{if}
                    end;{if}
                  end;{if}
                end;{if}
              end;{if}
            end;{case 2}
            4:begin                          {kopiruj animaciu}
              VyberMysou('Klikni na zdrojovu snimku.',11);
              if Tlacidla=1 then begin
                Zdroj:=(x-2) div (RozX+4);
                VyberMysou('Klikni na cielovu snimku.',11);
                Ciel:=(x-2) div (RozX+4);
                VypniKurzorMysi;
                Nastav(2+Ciel*(RozX+4),SnimkyY,0);
                PrilepBitmapu(RozX,RozY,Ofs(Anim[Zdroj*RozX*RozY]));
                Move(Anim[Zdroj*RozX*RozY],Anim[Ciel*RozX*RozY],RozX*RozY);
                ZapniKurzorMysi;
              end;{if}
            end;{case 4}
            5:begin                          {zacierni snimok}
              for PomZ:=0 to RozX*RozY-1 do Anim[AktSnim*RozX*RozY+PomZ]:=0;
              Nastav(2+AktSnim*(RozX+4),SnimkyY,0);
              VyplnPlochu(RozX,RozY);
              VykresliAktualnuSnimku;
            end;{case 5}
            6:begin                          {uloz animacia}
              Seek(f,PosAktAnim+3);
              BlockWrite(f,Anim,RozX*RozY*PocSnim);
            end;{case 6}
            7:begin                          {pustenie animacie}
              VypniKurzorMysi;
              Nastav(0,0,0);
              VyplnPlochu(16*RozBMP+4,16*RozBMP+4);
              VypisPriehladne('Spomalenie'#13'animacie (1-10):',Oranzova);
              Nastav(128,8,0);Citaj(2,Zlta);Val(Ret,Brzda,Err);
              Nastav(0,0,0);
              VyplnPlochu(16*RozBMP+2,16*RozBMP+2);
              for PomX:=1 to 5 do begin            {deliace ciary}
                Nastav(PomX*20-2,0,15);
                CiaraZvisla(120);
              end;
              for PomY:=1 to 5 do begin
                Nastav(0,PomY*20-2,15);
                CiaraVodorovna(120);
              end;
              Nastav(0,192,0);
              VyplnPlochu(319,8);
              VypisPriehladne('Kliknutim zastav animaciu.',SvetloModra);
              Nastav(0,0,0);
              repeat
                for PomZ:=0 to PocSnim-1 do begin
                   for PomY:=0 to 35 do begin
                     Nastav((PomY div 6)*20,(PomY mod 6)*20,0);
                     PrilepBitmapu(RozX,RozY,Ofs(Anim[(PomZ+PomY*17) mod PocSnim*RozX*RozY]));
                   end;{for 2}
                   for PomX:=1 to Brzda do begin
                     ZistiPoziciu(x,y,Tlacidla);
                     if Tlacidla=0 then CakajNaVOI;
                   end;{for 2}
                end;{for 1}
              until Tlacidla=1;
              VykresliAktualnuSnimku;
              ZapniKurzorMysi;
              repeat ZistiPoziciu(x,y,Tlacidla); until Tlacidla=0;
            end;{case 7}
            9:NastavFarbu;
            11:ZmenAktualnuSnimku;           {zmena aktualneho snimku}
          end;
        until Udalost=8;
{ ----- koniec editacie ----- }
        Seek(f,PosAktAnim+3);
        BlockWrite(f,Anim,RozX*RozY*PocSnim);
        InicializujHlavneMenu;
      end;{case 2}
      3:begin           {pridanie animacie}
        PocAnim:=PocAnim+1;
        AktAnim:=PocAnim;
        Seek(f,768);
        BlockWrite(f,PocAnim,1);
        Seek(f,FileSize(f));
        NovaAnimacia;
        Close(f);
        InicializujHlavneMenu;
      end;{case 3}
      4:begin           {odstranenie celej animacie}
        with AnimInfo[AktAnim] do begin
          Odstr:=Poz;
          Seek(f,Odstr);
          while not EOF(f) do begin
            Seek(f,Odstr+XRes*YRes*NumOfSnim+3);
            BlockRead(f,Anim,XRes*YRes*NumOfSnim+3,Kolko);
            Seek(f,Odstr);
            BlockWrite(f,Anim,Kolko);
            Odstr:=Odstr+XRes*YRes*NumOfSnim+3;
          end;{while}
          Seek(f,FileSize(f)-XRes*YRes*NumOfSnim-3);
          Truncate(f);
          Seek(f,768);
          BlockRead(f,PocAnim,1);
          PocAnim:=PocAnim-1;
          Seek(f,768);
          BlockWrite(f,PocAnim,1);
          InicializujHlavneMenu;
        end;{with}
      end;{case 4}
      5:begin
        SuboroveOkno(130,20,'Meno suboru:','ma',ASubor);
        FSplit(ASubor.Name,Cesta,Meno,Pripona);
        Subor:=Cesta+Meno+Pripona;
        InicializujHlavneMenu;
      end;{case 5}
      6:begin
        Nastav(80,0,0);VyplnPlochu(239,199);
        VypisPriehladne('Vytvorenie novej animacie.'#13#13'Zadaj nazov jej suboru:',Hneda);
        Nastav(80,32,0);
        Citaj(12,Hneda);
        Assign(f,Ret);
        ReWrite(f,1);
        AktSnim:=0;AktAnim:=1;PocAnim:=1;
        BlockWrite(f,Paleta,768);
        BlockWrite(f,PocAnim,1);
        Subor:=Ret;
        NovaAnimacia;
        Close(f);
        InicializujHlavneMenu;
      end;
    end;{case}
  until HUdalost=7;
  ZavriGrafiku;
  WriteLn('MukoSoft AnimEdit verzia 1.0'#13#10'Lubos Saloky, 1997');
END.