uses MainGr,Mys,BMPUtil,PomGr;
const PocetMB=4;PocetMGP=6;
      Path='d:\games\traxdata\panzer\';
           { hlavne menu }
      HlKlav:array[1..5] of char=('1','2','3','4',#255);
      HlAktiv:array[1..5,1..4] of word=(
        (24,54,134,104),(165,54,275,104),(24,134,134,184),(165,134,275,184),
        (400,0,0,0));
           { globalne nastavenia }
      P1Klav:array[1..17] of char=('p','+','-','s','h','a','n','g','d','c','i','r','t','m','f','o',#255);
      P1Aktiv:array[1..17,1..4] of word=(
        (128,33,156,45),(160,33,172,45),(112,33,124,45),(112,67,140,79),
        (112,81,140,93),(112,95,140,107),(112,109,140,121),(113,148,141,160),
        (113,162,141,174),(113,176,141,188),(273,67,301,79),(273,81,301,93),
        (273,95,301,107),(273,109,301,121),(274,148,302,160),(274,162,302,174),
        (400,0,0,0));
           { lokalne nastavenia - len NAHRAJ/ULOZ }
      P2Klav:array[1..3] of char=('n','u',#255);
      P2Aktiv:array[1..3,1..4] of word=(
        (14,67,74,83),(82,67,142,83),(400,0,0,0));
           { lokalne nastavenia }
      P3Klav:array[1..18] of char=('n','u','h','p','c','+','-','x','y','s','a','k','e','r','t','v','m',#255);
      P3Aktiv:array[1..18,1..4] of word=(
        (14,67,74,83),(82,67,142,83),(280,31,308,43),(280,57,308,69),
        (253,82,281,94),(285,82,297,94),(237,82,249,94),(87,97,115,109),
        (87,111,115,123),(55,127,83,139),(55,142,83,156),(55,157,83,169),
        (226,97,254,109),(226,112,254,124),(55,177,83,189),(151,128,179,140),
        (140,148,300,164),(400,0,0,0));
           { ukladanie - dialogove okno }
      UlozAktiv:array[1..3,1..4] of word=(
        (116,113,151,129),(168,113,203,129),(400,0,0,0));
      UlozKlav:array[1..3] of char=('a','n',#255);

      Vlajka:array[1..24] of string[15]=(
        'Rak`usko','Belgicko','Bulharsko','Luxembursko','D`ansko','F`insko',
        'Franc`uzsko','Nemecko','Gr`ecko','USA','Ma~darsko','Turecko',
        'Taliansko','Holandsko','N`orsko','Po~lsko','Portugalsko','Romunsko',
        '~Spanielsko','Rusko','~Sv`edsko','~Svaj~ciarsko','Brit`ania',
        'Juhosl`avia');
{ ----- premenne pre obsluhu programu ----- }
var PalP,PozP:pointer;                       {paleta,pozadie}
    MSFP:array[1..2] of pointer;             {fonty}
    MGPP:array[1..PocetMGP] of pointer;      {procesy}
    MBP:array[1..PocetMB] of ^BMPStruc;      {bitmapy}
    Udalost,Udalost2,UdalostUloz:word;       {ovladanie: hlavna udalost a pomocna pri lok. nast.}
    Nazov:string;                            {subor}
{ ----- premenne pre samotnu pracu ----- }
    CisloZbrane,MaxZbrani,CisloDivizie,ZacDivizie,KonDivizie:word;
    Zmeneny:boolean;
    Zbran:record    {NU = neznamy udaj}
      Nazov:array[1..20] of char;
      NU1,SoftA,HardA,AirA,NavA,GrD,AirD,ClD,Typ,NU2,NU3,Ini,Range,Spot,NU4,
      NU5,Mov,MaxFuel,MaxAmmo:byte;
      NU:array[1..11] of byte;
    end;
    Divizia:record
      Nazov:array[1..20] of char;
      Stat:byte;
      Typ:word;
      NU2,NU3,NU4,NU5,PosX,NU6,PosY,NU7,Strn,NU8,NU9,NU10,NU11,Ammo,Ent,NU12,
      Exper,Hviezd,NU13,NU14,NU15,Velenie,NU17,Kills,NU18,NU19:byte;
    end;
    KompZbran:array[4..16] of byte;
    KompDivizia:array[8..17] of byte;
    FZbran,FDivizia:file;
    NazovZbrane:array[0..499] of string[20];
{ ----- pomocne premenne ----- }
    f:file;
    i,j,Err:integer;
    x,y:word;
    s:string;
procedure InitHl;                            {inicializuj pozadie}
begin
  PrilepBMP(0,0,PozP);
  Color:=0;
  CiaraVodorovna(0,0,320);
  CiaraVodorovna(0,199,320);
end;

procedure InitP1;                            {inicializuj globalne nastavenia}
begin
  Seek(FZbran,2+CisloZbrane*50);
  BlockRead(FZbran,Zbran,50);
  KompZbran[4]:=Zbran.SoftA;
  KompZbran[5]:=Zbran.HardA;
  KompZbran[6]:=Zbran.AirA;
  KompZbran[7]:=Zbran.NavA;
  KompZbran[8]:=Zbran.GrD;
  KompZbran[9]:=Zbran.AirD;
  KompZbran[10]:=Zbran.ClD;
  KompZbran[11]:=Zbran.Ini;
  KompZbran[12]:=Zbran.Range;
  KompZbran[13]:=Zbran.Spot;
  KompZbran[14]:=Zbran.Mov;
  KompZbran[15]:=Zbran.MaxFuel;
  KompZbran[16]:=Zbran.MaxAmmo;
  PrilepBMP(P1Aktiv[1,1],P1Aktiv[1,2],MBP[2]);
  Color:=149;
  VyplnPlochu(191,42,114,12);
  for i:=4 to 16 do begin
    PrilepBMP(P1Aktiv[i,1],P1Aktiv[i,2],MBP[2]);
    Str(KompZbran[i],s);
    VypisPO(P1Aktiv[i,1]+3,P1Aktiv[i,2]+2,MSFP[1],s,Zlta);
  end;
  Str(CisloZbrane,s);
  VypisPO(P1Aktiv[1,1]+3,P1Aktiv[1,2]+2,MSFP[1],s,Zlta);
  for i:=1 to 20 do if Zbran.Nazov[i]>#0 then s[i]:=Zbran.Nazov[i] else s[i]:=' ';
  s[0]:=#20;
  VypisPO(193,43,MSFP[1],s,Cervena);
end;

procedure KompToZbran;                       {prevedie data z KompZbran do Zbran}
begin
  Zbran.SoftA:=KompZbran[4];
  Zbran.HardA:=KompZbran[5];
  Zbran.AirA:=KompZbran[6];
  Zbran.NavA:=KompZbran[7];
  Zbran.GrD:=KompZbran[8];
  Zbran.AirD:=KompZbran[9];
  Zbran.ClD:=KompZbran[10];
  Zbran.Ini:=KompZbran[11];
  Zbran.Range:=KompZbran[12];
  Zbran.Spot:=KompZbran[13];
  Zbran.Mov:=KompZbran[14];
  Zbran.MaxFuel:=KompZbran[15];
  Zbran.MaxAmmo:=KompZbran[16];
end;
procedure UlozZbran;
begin
  if Zmeneny then begin
    VykresliMGP(MGPP[6],@MBP,@MSFP);
    UdalostUloz:=ObsluzUdalost(@UlozAktiv,@UlozKlav);
    if UdalostUloz=1 then begin
      Zmeneny:=False;
      Seek(FZbran,2+CisloZbrane*50);
      BlockWrite(FZbran,Zbran,50);
    end;
    InitHl;
    VykresliMGP(MGPP[2],@MBP,@MSFP);
    InitP1;
  end;
end;
procedure InitP3;
begin
  Seek(FDivizia,ZacDivizie+49*CisloDivizie);
  BlockRead(FDivizia,Divizia,49);
  KompDivizia[8]:=Divizia.PosX;
  KompDivizia[9]:=Divizia.PosY;
  KompDivizia[10]:=Divizia.Strn;
  KompDivizia[11]:=Divizia.Ammo;
  KompDivizia[12]:=Divizia.Kills;
  KompDivizia[13]:=Divizia.Ent;
  KompDivizia[14]:=Divizia.Exper;
  KompDivizia[15]:=Divizia.Typ;
  KompDivizia[16]:=Divizia.Velenie;
  KompDivizia[17]:=Divizia.Hviezd;
  for i:=8 to 16 do begin
    PrilepBMP(P3Aktiv[i,1],P3Aktiv[i,2],MBP[2]);
    if i<>14 then Str(KompDivizia[i],s) else Str(KompDivizia[14]+100*KompDivizia[17],s);
    VypisPO(P3Aktiv[i,1]+3,P3Aktiv[i,2]+2,MSFP[1],s,Zlta);
  end;
  VypisPO(100,179,MSFP[1],NazovZbrane[Divizia.Typ],Zlta);
  VypisPO(195,130,MSFP[1],Vlajka[Divizia.Velenie],Zlta);
  s[0]:=#20;
  for j:=1 to 20 do
    if Divizia.Nazov[j]=#0
      then s[j]:=' '
      else s[j]:=Divizia.Nazov[j];
  VypisPO(143,152,MSFP[1],s,Zlta);
end;