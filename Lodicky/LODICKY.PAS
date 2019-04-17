program Lodicky;
{ovladanie klavenicou, tabulka najlepsich}
uses MukoGr,Myska,MukoUtil,Crt{,Zvuk1};
const FontPath={'d:\lubo\pascal\units\Prechod.mf'}'Prechod.mf';
      Predok=0;Stred=1;Zadok=2;
      Prazdne=0;Zasiahnute=1;Vedla=2;
      PocetPozadi=4;
      Pol:array [1..9,1..4] of word=(           {aktivne oblasti v hlavnom menu}
        (20,60,50,90),(170,60,200,90),(170,160,200,230),
        (20,110,50,140),(20,160,50,190),(170,110,200,140),
        (215,14,245,44),(62,76,156,88),(62,126,156,138));
      RozPoz:array[1..PocetPozadi,1..3] of word={rozmery pozadi generovanych programom}
        ((320,203,Zelena),(200,64,Bordova),(136,184,Ruzova),(200,174,Hnedocervena));
      RozLodi:array[1..3,1..6] of byte=         {rozmery lodi pre jednotlive obtiaznosti}
        ((2,2,1,0,0,0),(3,2,2,1,0,0),(4,3,3,2,1,0));
      Chyba:array[1..5] of string[40]=(
        'S£bor LODICKY.MB nen jdeny.','S£bor LOD2.MB nen jdeny','S£bor PRECHOD.MF nen jdeny','','');
label Von,Dnu;
var f:file;
    InfoBuf:array[0..3839] of byte;        {buffer pre prekreslovanu grafiku}
    Meno:array[1..2]of string[15];         {mena hracov}
    Lod:array[1..4,0..2,0..255]of byte;    {1. rozmer natocenie; 2. cast lode:0 predok,1 stred,2 zadok; 3. buffer}
    More:array[0..2,0..255]of byte;        {more 16*16 stred:0 otaznik,1 zasah,2 vodna plocha}
    MoreOkraj:array[0..3,0..127]of byte;   {more okraje 16*8 alebo 8*16: horny, pravy, dolny, lavy}
    MoreRoh:array[0..3,0..63] of byte;     {more roh 8*8}
    LodMala:array[1..4,0..255] of byte;    {1. rozmer natocenie, 2. buffer}
    Pozadie:array[1..8] of pointer;        {tu su priemerovane pozadia}
    PPlocha:array[1..2,0..10,0..10]of byte;{hracie plany - tu sa schovavaju lode}
    Pismeno:array [1..7,0..599] of byte;   {text LODICKY}
    Kocka:array [1..6,0..63] of byte;      {malicka kococka}
    Pocitac,Stupne,Stop,Clovek,Cinka,Kniha,Start:array [0..899] of byte;
    PPoloha:array[1..2,1..5]of record      {tu su lode ulozene v inej strukture}
              PozX,PozY,Natoc,Dlzka,ObrX,ObrY,Horiz,Vert:word;  {natocenie:1 vlavo,2 hore,3 vpravo,4 dole}
              Znicena:boolean;             {PozX,PozY je sur. LH rohu na hracom plane;ObrX,ObrY LH rohu na obrazovke.}
              Zasahy:array[1..4] of boolean;
            end;
    ObrazUkaz,ObrazUkaz2:pointer;          {SD - pozadia}
    sx,sy:integer;                         {stare suradnice lode - pouzivane pri presune lode}
    AbsX,AbsY,klavx,klavy:integer;         {suradnice lode na hracom plane}
    DlzMena:array[1..2] of byte;           {dlzka mena bez diakritiky}
    ZacX:array[1..2] of word;              {suradnice hracieho planu na obrazovke}
    Hrac:array[1..2] of boolean;           {true=clovek, false=pocitac}
    ZacY:word;
    Rozmer,TypPlanu,AktTah,AktHrac,Druhy,PocetLodi,RozX,RozY,xm,ym:word;
    Volny,Koniec,BoloX,BoloY,PovStav,Hrac1,Hrac2,Dvaja:boolean;
    meno1,meno2,s1,stri:string;            {SD}
    MX,MY:set of char;                     {mnoziny pripustnych znakov}
    Lode:set of byte;                      {pripustne hodnoty znamenajuce lod}
    ch:char;                               {odtial uz len pomocne premenne}
    x,y,i,j,k:integer;
    Tlacidla,PomB,obt,yps,Tlacidlo:byte;
    pom:word;
{ ----- vypis chyboveho hlasenia ----- }
procedure Error(Cislo:byte);
begin
  Writeln(#13#10,Chyba[Cislo],#13#10);
  Halt;
end;
{ ----- vstupne demo ----- }
                          PROCEDURE Intro;
Begin
  s1:='predstavuje';
  for i:=1 to 80 do begin
  nastav (i-10,109-i,0);
  ramcek (75,10,0);
  nastav (i,110-i,0);
  vypispriehladne ('MUKOSOFT',2);
  nastav (248-(i),109-i,0);
  ramcek (75,10,0);
  nastav (248-i,110-i,0);
  vypispriehladne ('ASTROSOFT',2);
  cakajnavoi;
  end;
 for i:=1 to 11 do begin
      randomize;
      for j:=1 to 4 do begin
      nastav (107+8*i,60,0);
      prilepbitmapu (8,8,ofs(Kocka[random(6)+1]));
      cakajnavoi;
      end;
      ramcek (8,8,0);
      vypispriehladne (s1[i],1);
 end;
 for i:=1 to 7 do begin
  for j:=300 downto (60+22*i) do begin
      if (j mod 3)=0 then begin
        Nastav (j-3,100,0);
        ramcek (30,30,0);
        Nastav (j,100,0);
        Prilepbitmapu (20,30,ofs(pismeno[i]));
        cakajnavoi;
      end;
  end;
 end;
 for i:=1 to 170 do begin
  posunvramdole (1);
  CakajNaVoi;
 end;
End;
{ ----- naprazdno caka na stlacenie klavesy alebo kliknutie mysou ----- }
procedure CakajNaOdozvu;
begin
  repeat
    ZistiPoziciu(word(x),word(y),Tlacidla);
  until (Tlacidla=1) or KeyPressed;
  if KeyPressed then ch:=ReadKey;
  CakajNaPustenie;
end;
{ ----- pomocne procedury pre hlavne menu ----- }
                        PROCEDURE Ramcek1;
Begin
  Vypnikurzormysi;   Nastav (62,76,0);  Ramcek (94,12,0);
  Nastav (58,72,98); Ramcek (94,12,98); Zapnikurzormysi;
End;
                        PROCEDURE Ramcek2;
Begin
  Vypnikurzormysi;    Nastav (62,126,0); Ramcek (94,12,0);
  Nastav (58,122,98); Ramcek (94,12,98); Zapnikurzormysi;
End;
                        PROCEDURE Ikonka (x1,y1:word);
Begin
  Nastav (x1,y1,0);
  Ramcek (30,30,0);
  Nastav (x1-4,y1-4,0);
  PrilepBitmapu (30,30,pom);
End;
{ ----- vypisanie mena pri nacitavani ----- }
                        PROCEDURE VypisMeno (men:string;DlzX:byte;kubik:boolean);
Begin
  nastav (62,yps,0);
  VypisPriehladne (men,5);
  If kubik then begin Nastav (62+DlzX*8,yps,0);
                             PrilepPriehladnuBitmapu (8,8,ofs(Kocka[Random(6)+1]));
                       end;
End;
{ ----- prepinanie obtiaznosti ----- }
                        PROCEDURE Obtiaznost (prip:boolean);
Begin
CakajNaPustenie;
  if prip then If obt<3 then obt:=obt+1
                        else obt:=1;
  Vypnikurzormysi;
  Nastav (62,176,0); Ramcek (94,12,0);
  Nastav (58,172,98); Ramcek (94,12,98);
  Nastav (60,173,68); Ramcek (30,10,68);
  if obt>=2 then begin Nastav (90,173,52); Ramcek (30,10,52);end;
  if obt=3 then begin Nastav (120,173,20); Ramcek (30,10,20);end;
  Zapnikurzormysi;
End;
{ ----- hlavne menu ----- }
                        PROCEDURE HlavnyPanel;{alebo HladnyPanel}
Begin
  Nastav(0,0,0);
  PrilepDynamickuBitmapu(320,200,ObrazUkaz);
  CiaraVodorovna (320);
  Nastav (0,199,0);
  Ciaravodorovna (320);
  if not hrac1 then Pom:=ofs(Pocitac) else  Pom:=ofs(Clovek);
                     Ikonka (Pol[1,1],Pol[1,2]);
  Pom:=ofs(Stupne);  Ikonka (Pol[2,1],Pol[2,2]);
  Pom:=ofs(Stop);    Ikonka (Pol[3,1],Pol[3,2]);
  if not hrac2 then Pom:=ofs(Pocitac) else  Pom:=ofs(Clovek);
                     Ikonka (Pol[4,1],Pol[4,2]);
  Pom:=ofs(Cinka);   Ikonka (Pol[5,1],Pol[5,2]);
  Pom:=ofs(Kniha);   Ikonka (Pol[6,1],Pol[6,2]);
  Pom:=ofs(Start);   Ikonka (Pol[7,1],Pol[7,2]);
  Nastav (19,11,0); Ramcek (170,35,0);
  Nastav (15,7,98); Ramcek (170,35,98);
  for i:=1 to 7 do begin
    Nastav (22*i,10,0);
    PrilepPriehladnuBitmapu (20,30,ofs(Pismeno[i]));
  end;
  Nastav (60,60,0);   VypisPriehladne ('Prv`y hr`a~c',11);
  Nastav (60,110,0);  VypisPriehladne ('Druh`y hr`a~c',11);
  Nastav (60,160,0);  VypisPriehladne ('Obtia~znos~t',11);
  Nastav (210,60,0);  VypisPriehladne ('Najlep~s`i',11);
  Nastav (210,73,0);  VypisPriehladne ('hr`a~ci',11);
  Nastav (210,110,0); VypisPriehladne ('Inform`acie',11);
  Nastav (210,123,0); VypisPriehladne ('o hre',11);
  Nastav (210,160,0); VypisPriehladne ('Koniec',11);
  Nastav (210,173,0); VypisPriehladne ('hry',11);
  Nastav (255,20,0);  VypisPriehladne ('~Start',3);
  Obtiaznost (false);
  Zapnikurzormysi;Ramcek1; Ramcek2;Vypnikurzormysi;
  yps:=74;if hrac1 then VypisMeno (meno1,DlzMena[1],false)
                   else VypisMeno ('Po~c`ita~c',7,false);
  yps:=124;if hrac2 then VypisMeno (meno2,DlzMena[2],false)
                    else VypisMeno ('Po~c`ita~c',7,false);
  Zapnikurzormysi;
End;
{ ----- editacia mena v hla[v/d]nom paneli ----- }
                        PROCEDURE EditujMeno (cislo:byte);
var menoX:string;
Begin
  CakajNaPustenie;
  VypniKurzorMysi;
  if cislo=1 then Begin MenoX:=meno1;yps:=74;Ramcek1;end
             else Begin MenoX:=meno2;yps:=124;Ramcek2;end;
  VypisMeno (MenoX,DlzMena[Cislo],true);
  repeat
  ch:=readkey;
  if (ord(ch)>30) and (DlzMena[Cislo]<10) then begin
                  Nastav (62+(DlzMena[Cislo])*8,yps-1,98);
                  Ramcek (8,9,98);
                  MenoX:=MenoX+ch;
                  if not (ch in ['`','~','^','|']) then Inc(DlzMena[Cislo]);
                  VypisMeno (MenoX,DlzMena[Cislo],true);
                  end;
  if (ord(ch)=8) and (DlzMena[Cislo]>0) then begin
                  Nastav (62+(DlzMena[Cislo]-1)*8,yps-1,98);
                  Ramcek (16,9,98);
                  while MenoX[Length(MenoX)] in ['`','~','^','|'] do begin
                    MenoX:=copy (MenoX,1,Length(MenoX)-1);
                  end;
                  MenoX:=copy (MenoX,1,Length(MenoX)-1);
                  Dec(DlzMena[Cislo]);
                  VypisMeno (MenoX,DlzMena[Cislo],true);
                  end;
  until ord(ch)=13;
  Nastav (62+(DlzMena[Cislo])*8,yps,98);
                  Ramcek (8,8,98);
  if cislo=1 then Meno1:=menoX
             else Meno2:=menoX;
  Zapnikurzormysi;
End;
{ ----- prepinanie medzi hracom a pocitacom ----- }
                        PROCEDURE Hraci;
Begin
  VypniKurzorMysi;
  if i=1 then begin case hrac1 of
                    false : begin Hrac1:=true;Pom:=ofs(Clovek);yps:=74;
                           Ikonka (Pol[1,1],Pol[1,2]);Ramcek1;VypisMeno (meno1,DlzMena[1],false);end;
                    true  : begin Hrac1:=false;Pom:=ofs(Pocitac);yps:=74;
                           Ikonka (Pol[1,1],Pol[1,2]);Ramcek1;VypisMeno ('Po~c`ita~c',7,false);end;
                    end;
              end
         else begin case hrac2 of
                    false : begin Hrac2:=true;Pom:=ofs(Clovek);yps:=124;
                           Ikonka (Pol[4,1],Pol[4,2]);Ramcek2;VypisMeno (meno2,DlzMena[2],false);end;
                    true  : begin Hrac2:=false;Pom:=ofs(Pocitac);yps:=124;
                           Ikonka (Pol[4,1],Pol[4,2]);Ramcek2;VypisMeno ('Po~c`ita~c',7,false);end;
                    end;
              end;
   Zapnikurzormysi;
   CakajNaPustenie;
End;
{ ----- tabulka najlepsich hracov ----- }
                        PROCEDURE Tabulka;
Begin
  VypniKurzorMysi;
  Nastav(60,20,0);
  PrilepDynamickuBitmapu(200,150,ObrazUkaz2);
  Nastav (60,20,15);
  Obdlznik (200,150);
  Nastav (100,35,0); VypisPriehladne ('Tabu~lka',3);
  Nastav (90,48,0); VypisPriehladne ('Najlep~s`ich',3);
  Nastav (200,30,0);PrilepBitmapu (30,30,ofs(Stupne));
  Nastav (199,29,15);Obdlznik (32,32);
  for i:=1 to 5 do begin
   Nastav (75,60+15*i,0);
   str (i,stri);
   VypisPriehladne (stri,5);
   Nastav (90,60+15*i,0);
   VypisPriehladne ('.....',5);
  end;
  ZapniKurzorMysi;
  CakajNaPustenie;
  CakajNaOdozvu;
  VypniKurzorMysi;
  HlavnyPanel;
End;
{ ----- informacie o programe ----- }
                        PROCEDURE Info;
Begin
VypniKurzorMysi;
  Nastav(60,20,0);
  PrilepDynamickuBitmapu(200,150,ObrazUkaz2);
  Nastav (60,20,15);
  Obdlznik (200,150);
  Nastav (87,35,0); VypisPriehladne ('Inform`acie',zlta);
  Nastav (105,48,0); VypisPriehladne ('o hre',zlta);
  Nastav (200,30,0);PrilepBitmapu (30,30,ofs(Kniha));
  Nastav (199,29,15);Obdlznik (32,32);
  Posun:=10*320;
  Nastav (67,65,0);VypisPriehladne ('Lodi~cky je (ne)logick`a'#13+
  'hra pre jedn`eho alebo '#13'dvoch hr`a~cov.',svetlomodra);

  Nastav (100,100,0);VypisPriehladne ('Programovali : ',zelena);
  Nastav (100,115,0);VypisPriehladne ('~Lubo~s Saloky'#13'~Stefan Du~s`ik',zlta);
  Nastav (67,150,0);VypisPriehladne ('Ko~sice             1997',svetlomodra);
  Posun:=8*320;
  ZapniKurzorMysi;
  CakajNaPustenie;
  CakajNaOdozvu;
  VypniKurzorMysi;
  HlavnyPanel;
End;
{ ----- nakresli hraci plan ----- }
procedure ZobrazHraciPlan(PosX,PosY:word);
var pomi:integer;
begin
  for pomi:=0 to Rozmer-1 do begin{horny okraj}
    Nastav(PosX+16*pomi,PosY-8,0);
    PrilepPriehladnuBitmapu(16,8,Ofs(MoreOkraj[0]));
  end;
  for pomi:=0 to Rozmer-1 do begin {dolny okraj}
    Nastav(PosX+16*pomi,PosY+16*Rozmer,0);
    PrilepPriehladnuBitmapu(16,8,Ofs(MoreOkraj[2]));
  end;
  for pomi:=0 to Rozmer-1 do begin {pravy okraj}
    Nastav(PosX-8,PosY+16*pomi,0);
    PrilepPriehladnuBitmapu(8,16,Ofs(MoreOkraj[1]));
  end;
  for pomi:=0 to Rozmer-1 do begin {lavy okraj}
    Nastav(PosX+16*Rozmer,PosY+16*pomi,0);
    PrilepPriehladnuBitmapu(8,16,Ofs(MoreOkraj[3]));
  end;                             {teraz rohy}
  Nastav(PosX-8,PosY-8,0);PrilepPriehladnuBitmapu(8,8,Ofs(MoreRoh[0]));
  Nastav(PosX-8,PosY+16*Rozmer,0);PrilepPriehladnuBitmapu(8,8,Ofs(MoreRoh[1]));
  Nastav(PosX+16*Rozmer,PosY+16*Rozmer,0);PrilepPriehladnuBitmapu(8,8,Ofs(MoreRoh[2]));
  Nastav(PosX+16*Rozmer,PosY-8,0);PrilepPriehladnuBitmapu(8,8,Ofs(MoreRoh[3]));
  for i:=0 to Rozmer-1 do    {hraci plan}
    for j:=0 to Rozmer-1 do begin
      Nastav(PosX+16*i,PosY+16*j,0);
      PrilepBitmapu(16,16,Ofs(More[2]));
  end;
  for i:=1 to Rozmer do begin {cisla na okraji}
    Nastav(PosX+16*i-12,PosY-8,0);
    VypisPriehladne(Chr(i+48),Cervena);
  end;
  for i:=1 to Rozmer do begin  {pismena na okraji}
    Nastav(PosX-8,PosY-12+16*i,0);
    VypisPriehladne(Chr(i+64),Cervena);
  end;
end;
{ ----- Na hraci plan prilepi lod ----- }
procedure PrilepLod(px,py,j,Horiz,Vert:word);
var PomZdroj,Vnutro:word;
begin
  Nastav(px,py,0);
  if Horiz+Vert=2 then PrilepPriehladnuBitmapu(16,16,Ofs(LodMala[j]))
  else begin
    if (j=1) or (j=4) then PomZdroj:=Ofs(Lod[j,0]);
    if (j=2) or (j=3) then PomZdroj:=Ofs(Lod[j,2]);
    PrilepPriehladnuBitmapu(16,16,PomZdroj);
    Vnutro:=2;
    while Vnutro<Horiz do begin
      Nastav(kx+16,ky,0);PrilepPriehladnuBitmapu(16,16,Ofs(Lod[j,1]));
      Inc(Vnutro);
    end;
    while Vnutro<Vert do begin
      Nastav(kx,ky+16,0);PrilepPriehladnuBitmapu(16,16,Ofs(Lod[j,1]));
      Inc(Vnutro);
    end;
    if Horiz=1 then Nastav(kx,ky+16,0)
               else Nastav(kx+16,ky,0);
    if (j=1) or (j=4) then PomZdroj:=Ofs(Lod[j,2]);
    if (j=2) or (j=3) then PomZdroj:=Ofs(Lod[j,0]);
    PrilepPriehladnuBitmapu(16,16,PomZdroj);
  end;
end;
{ ----- zisti, ci je koniec hry ----- }
procedure ZistiCiJeKoniec;
begin
  Koniec:=True;
  for i:=1 to PocetLodi do
    if not PPoloha[1,i].Znicena then Koniec:=False;
  if not Koniec then begin
    Koniec:=True;
    for i:=1 to PocetLodi do
      if not PPoloha[2,i].Znicena then Koniec:=False;
  end;
end;
{ ----- kontrola rozsahu suradnic a ich uprava pri rozmiestnovani lodiciek ----- }
procedure KontrolaSuradnic;
begin
  with PPoloha[Druhy,i] do begin
    if (Natoc=1) and (x>232+8*Rozmer-16*Horiz) then x:=232+8*Rozmer-16*Horiz;
    if (Natoc=2) and (y<102-8*Rozmer+16*Vert) then y:=102-8*Rozmer+16*Vert;
    if (Natoc=3) and (x<230-8*Rozmer+16*Horiz) then x:=230-8*Rozmer+16*Horiz;
    if (Natoc=4) and (y>104+8*Rozmer-16*Vert) then y:=104+8*Rozmer-16*Vert;
  end;
end;
{ ----- vypis mena nad hraci plan ----- }
procedure VypisMenoLubo;
begin
  if AktHrac=1 then begin  {vypis mien}
    Nastav(80-4*DlzMena[1]-4,22,27);Ramcek(8*Length(Meno[1])+8,16,88);
    Nastav(80-4*DlzMena[1],26,0);VypisPriehladne(Meno[1],Cervena);
    Nastav(240-4*DlzMena[2]-4,22,74);Ramcek(8*Length(Meno[2])+8,16,0);
    Nastav(240-4*DlzMena[2],26,0);VypisPriehladne(Meno[2],Ruzova);
  end else begin
    Nastav(80-4*DlzMena[1]-4,22,74);Ramcek(8*Length(Meno[1])+8,16,0);
    Nastav(80-4*DlzMena[1],26,0);VypisPriehladne(Meno[1],Ruzova);
    Nastav(240-4*DlzMena[2]-4,22,27);Ramcek(8*Length(Meno[2])+8,16,88);
    Nastav(240-4*DlzMena[1],26,0);VypisPriehladne(Meno[2],Cervena);
  end;
end;



       { --------------------- hlavny program ------------------------ }



BEGIN
{ ----- inicializacia grafiky a suboru ----- }
  Write('Inicializ cia ');
  Assign(f,'lodicky.mb');
  Reset(f,1);
  if IOResult>0 then Error(1);
  Seek(f,769);
  for x:=1 to 10 do begin
    Seek(f,FilePos(f)+2);
    case x of
      1:BlockRead(f,Lod[1,0],256);
      2:BlockRead(f,Lod[1,1],256);
      3:BlockRead(f,Lod[1,2],256);
      4:BlockRead(f,LodMala[1],256);
      5:BlockRead(f,More[0],256);
      6:BlockRead(f,More[1],256);
      7:BlockRead(f,More[2],256);
      8:BlockRead(f,MoreOkraj[0],128);
      9:BlockRead(f,MoreOkraj[1],128);
      10:BlockRead(f,MoreRoh,64);
    end;
  end;
  Write('.');
  FillChar(PPlocha,SizeOf(PPlocha),#0);
{ ----- priprava okrajov mora a otocenych lodi ----- }
  Move(MoreOkraj[0],MoreOkraj[2],128);
  PreklopBitmapu(16,8,Ofs(MoreOkraj[2]),-2);
  Move(MoreOkraj[1],MoreOkraj[3],128);
  PreklopBitmapu(8,16,Ofs(MoreOkraj[3]),2);
  for i:=1 to 3 do Move(MoreRoh[0],MoreRoh[i],64);
  PreklopBitmapu(8,8,Ofs(MoreRoh[1]),-2);
  PreklopBitmapu(8,8,Ofs(MoreRoh[2]),1);
  PreklopBitmapu(8,8,Ofs(MoreRoh[3]),2);
  for i:=2 to 4 do Move(LodMala[1],LodMala[i],256);
  PreklopBitmapu(16,16,Ofs(LodMala[2]),1);
  PreklopBitmapu(16,16,Ofs(LodMala[3]),2);
  PreklopBitmapu(16,16,Ofs(LodMala[4]),-1);
  for i:=2 to 4 do
    for j:=0 to 2 do
      Move(Lod[1,j],Lod[i,j],256);
  for j:=0 to 2 do PreklopBitmapu(16,16,Ofs(Lod[2,j]),1);
  for j:=0 to 2 do PreklopBitmapu(16,16,Ofs(Lod[3,j]),2);
  for j:=0 to 2 do PreklopBitmapu(16,16,Ofs(Lod[4,j]),-1);
  Write('.');
{ ----- priprava pozadi ----- }
  for i:=1 to PocetPozadi do PripravPozadie(RozPoz[i,1],RozPoz[i,2],RozPoz[i,3],Pozadie[i]);
  for j:=1 to PocetPozadi do begin
    for i:=1 to 2 do
      PriemerujBitmapu(Pozadie[j]);
    Write('.');
    StmavBitmapu(Pozadie[j]);
  end;
{ ----- inicializacia suborov SDsoftu ----- }
  Hrac1:=true;Hrac2:=false;obt:=3;
  meno1:='Muko';DlzMena[1]:=4;
  meno2:='Duko';DlzMena[2]:=4;
  PripravPozadie(320,200,0,ObrazUkaz);
  for x:=1 to 2 do PriemerujBitmapu(ObrazUkaz);
  PripravPozadie(200,150,2,ObrazUkaz2);
  for x:=1 to 2 do PriemerujBitmapu(ObrazUkaz2);
  Write('.');
  Assign(f,'lod2.mb');
  Reset(f,1);
  if IOResult>0 then Error(2);
  Seek(f,769);
  for i:=1 to 7 do begin
    Seek(f,FilePos(f)+2);
    BlockRead (f,Pismeno[i],600);
  end;
  for i:=1 to 6 do begin
    Seek(f,FilePos(f)+2);
    BlockRead (f,Kocka[i],64);
  end;
  for i:=1 to 8 do begin
    Seek(f,FilePos(f)+2);
    case i of
         1 : BlockRead (f,Pocitac,900);
         2 : Blockread (f,Stupne,900);
         3 : Blockread (f,Stop,900);
         4 : Blockread (f,Clovek,900);
         5 : Blockread (f,Cinka,900);
         6 : Blockread (f,Kniha,900);
         7 : Blockread (f,Start,900);
    end;
  end;
  InicializujGrafiku;
  NacitajFontAPaletu(FontPath);
  if IOResult>0 then Error(3);
  NastavTvarKurzora (ofs(Terc));
  {If SB then play ('sound','UVOD');}
{  Intro;}
{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
  Dnu:
  OknoKurzora(1,640,1,200);
  FillChar(PPlocha,SizeOf(PPlocha),#0);
  FillChar(PPoloha,SizeOf(PPoloha),#0);
  VypniKurzorMysi;
  ZmazObrazovku;
  Koniec:=false;
  HlavnyPanel;
  ZapniKurzorMysi;
  {If SB then wait;}

  repeat
    ZistiPoziciu (xm,ym,tlacidlo);
    xm:=xm div 2;
    for i:=1 to 9 do begin
      if (xm>pol[i,1]-8) and (xm<pol[i,3]-8) and (ym<pol[i,4]-4) and (ym>pol[i,2]-4)
                   and (tlacidlo=lave) then
                       begin
                        case i of
                        1 : Hraci;
                        4 : Hraci;
                        2 : Tabulka;
                        3 : goto Von;
                        5 : Obtiaznost (true);
                        6 : Info;
                        7 : Koniec:=True;
                        8 : if hrac1 then EditujMeno (1);
                        9 : if hrac2 then EditujMeno (2);
                        end;
                        i:=9;
                       end;
    end;
  until Koniec;
  CakajNaPustenie;
  VypniKurzorMysi;
{ ----- konverzia udajovych formatov pre LS ----- }
  Rozmer:=3+Obt*2;
  Meno[1]:=Meno1;Hrac[1]:=Hrac1;
  Meno[2]:=Meno2;Hrac[2]:=Hrac2;
  if (Hrac1) and (Hrac2) then Dvaja:=True else Dvaja:=False;
{ ----- priprava zoznamu povolenych klaves ----- }
  case Rozmer of
    5:begin
      TypPlanu:=1;
      MY:=['A'..'E','a'..'e'];
      MX:=['1'..'5'];
    end;
    7:begin
      TypPlanu:=2;
      MY:=['A'..'G','a'..'g'];
      MX:=['1'..'7'];
    end;
    9:begin
      TypPlanu:=3;
      MY:=['A'..'I','a'..'i'];
      MX:=['1'..'9'];
    end;
  end;
  Lode:=[1..5];
  Posun:=10*320;
{ ----- rozmiestnovanie lodiciek ----- }
  for AktHrac:=2 downto 1 do begin
    if AktHrac=1 then Druhy:=2 else Druhy:=1;
    if Hrac[AktHrac] then begin
      ZacX[1]:=232-8*Rozmer;
      ZacY:=104-8*Rozmer;
      Nastav(0,0,0);PrilepDynamickuBitmapu(320,200,Pozadie[1]);
      CiaraVodorovna(320);
      Nastav(60,68,15);PrilepDynamickuBitmapu(RozPoz[2,1],RozPoz[2,2],Pozadie[2]);
      Obdlznik(200,64);
      Nastav(66,78,0);
      if Dvaja then VypisPriehladne(Meno[Druhy]+','#13'Teraz sa nepozeraj.',SvetloModra);
      Nastav(66,102,0);VypisPriehladne(Meno[AktHrac]+','#13'Rozmiestni svoje lode.',SvetloModra);
      ZapniKurzorMysi;
      CakajNaOdozvu;
      VypniKurzorMysi;
      Nastav(0,0,0);PrilepDynamickuBitmapu(320,200,Pozadie[1]);
      CiaraVodorovna(320);
      Nastav(5,10,15);PrilepDynamickuBitmapu(RozPoz[3,1],RozPoz[3,2],Pozadie[3]);
      Obdlznik(RozPoz[3,1],RozPoz[3,2]);
      Nastav(9,13,0);
      VypisPriehladne('Rozmiest~novanie'#13'lodi~ciek.'#13'   MY~SOU:'#13'~Lav`ym tla~cidlom'#13'polo~z lo~d,'#13'prav`ym '+
      'ot`a~caj.'#13#13'   KL`AVESNICOU:'#13'Zadaj s`uradnice,'#13'medzerou ot`a~caj,'#13'Enterom polo~z.'#13#13'Polo~zi~t '+
      'lo~d'#13'mo~ze~s len vtedy,'#13'ak sa nedot`yka'#13'inej lode bokom'#13'ani rohom'#13'pol`i~cka.',SvetloModra);
      Nastav(5,129,15);CiaraVodorovna(136);
      ZobrazHraciPlan(232-8*Rozmer,104-8*Rozmer);
      OknoKurzora(466-16*Rozmer,462+16*Rozmer,106-8*Rozmer,102+8*Rozmer);
      OknoXMin:=232-8*Rozmer;
      OknoXMax:=232+8*Rozmer;
      OknoYMin:=104-8*Rozmer;
      OknoYMax:=104+8*Rozmer;
{ ----- spracovanie ukladania lodi ----- }
      i:=1;j:=1;       {j: 1 vpravo, 2 dole, 3 vlavo, 4 hore }
      while RozLodi[TypPlanu,i]>0 do begin
        with PPoloha[Druhy,i] do begin
          Dlzka:=RozLodi[TypPlanu,i];
          Znicena:=False;
          for k:=1 to 4 do Zasahy[k]:=False;
          Natoc:=1;
          Horiz:=Dlzka;
          Vert:=1;
          sx:=ZacX[1]; {stare suradnice predku lode}
          sy:=ZacY;
          x:=sx;       {nove suradnice predku lode}
          y:=sy;
          ObrX:=x;     {suradnice laveho horneho rohu lode}
          ObrY:=y;
          NastavKurzor(sx*2,sy);
          Nastav(ObrX,ObrY,0);
          StiahniBitmapu(Horiz*16,Vert*16,Ofs(InfoBuf));
          PrilepLod(ObrX,ObrY,Natoc,Horiz,Vert);
          PozX:=1;PozY:=1;Volny:=False;
          BoloX:=False;BoloY:=False;
          repeat
            ZistiPoziciu(word(x),word(y),Tlacidla);
            x:=x div 2;
{ ----- obsluha klavesnice ----- }
            ch:=#0;
            if KeyPressed then begin
              ch:=ReadKey;
              if ch in MX then x:=ZacX[1]+16*(byte(ch)-byte('1'));
              if ch in MY then y:=ZacY+16*(byte(UpCase(ch))-byte('A'));
              NastavKurzor(x*2,y);
              if ch=' ' then Tlacidla:=Prave;
              if ch=#13 then Tlacidla:=Lave;
            end;
            KontrolaSuradnic;
            x:=x and $FFF0;
            y:=y and $FFF0;
{ ----- otocenie lode ----- }
            if Tlacidla=Prave then begin
              Inc(Natoc);
              if Natoc=5 then Natoc:=1;
              Nastav(ObrX,ObrY,0);           {obnov podklad}
              PrilepBitmapu(Horiz*16,Vert*16,Ofs(InfoBuf));
              if Horiz=1 then begin
                Horiz:=Dlzka;
                Vert:=1;
              end else begin
                Vert:=Dlzka;
                Horiz:=1;
              end;
              KontrolaSuradnic;
              ObrX:=x;
              ObrY:=y;
              if Natoc=3 then ObrX:=ObrX-16*Dlzka+16;
              if Natoc=2 then ObrY:=ObrY-16*Dlzka+16;
              Nastav(ObrX,ObrY,0);           {uchovaj podklad}
              StiahniBitmapu(Horiz*16,Vert*16,Ofs(InfoBuf));
              PrilepLod(ObrX,ObrY,Natoc,Horiz,Vert);
              CakajNaPustenie;
            end;
{ ----- presun lode ----- }
            if (x<>sx) or (y<>sy) then begin
              Nastav(ObrX,ObrY,0);
              PrilepBitmapu(Horiz*16,Vert*16,Ofs(InfoBuf));
              ObrX:=x;
              ObrY:=y;
              if Natoc=3 then ObrX:=ObrX-16*Dlzka+16;
              if Natoc=2 then ObrY:=ObrY-16*Dlzka+16;
              Nastav(ObrX,ObrY,0);
              StiahniBitmapu(Horiz*16,Vert*16,Ofs(InfoBuf));
              sx:=x;
              sy:=y;
              PrilepLod(ObrX,ObrY,Natoc,Horiz,Vert);
            end;
{ ----- polozenie lode ----- }
            if Tlacidla=Lave then begin
              PozX:=(ObrX-ZacX[1]) div 16+1;
              PozY:=(ObrY-ZacY) div 16+1;   {suradnice na hracom plane - PPlocha}
              Volny:=True;                  {kontrola, ci tam uz nie je lod}
              if PPlocha[Druhy,PozX,PozY]>0 then Volny:=False;
              if Horiz>1 then for k:=0 to Dlzka-1 do if PPlocha[Druhy,PozX+k,PozY]>0 then Volny:=False;
              if Vert>1 then for k:=0 to Dlzka-1 do if PPlocha[Druhy,PozX,PozY+k]>0 then Volny:=False;
            end;
          until Volny;
{ ----- bola polozena lod ----- }
          for x:=PozX-1 to PozX+Horiz do{vypln okolie lode 255-kami}
            for y:=PozY-1 to PozY+Vert do
              if (x>0) and (x<=Rozmer) and (y>0) and (y<=Rozmer) then
                PPlocha[Druhy,x,y]:=255;
          PPlocha[Druhy,PozX,PozY]:=i;{pre LodMala}
          if Horiz>1 then for x:=PozX to PozX+Dlzka-1 do PPlocha[Druhy,x,PozY]:=i;
          if Vert>1 then for y:=PozY to PozY+Dlzka-1 do PPlocha[Druhy,PozX,y]:=i;
          ObrX:=ObrX-152;
          if AktHrac=1 then ObrX:=ObrX+160;
          ObrY:=ObrY+16;
          if KeyPressed then ch:=ReadKey;
          CakajNaPustenie;
          Inc(i);
        end;{with}
      end;{while}
      PocetLodi:=i-1;
      OknoKurzora(0,638,0,199);
      OknoXMin:=0;
      OknoXMax:=319;
      OknoYMin:=0;
      OknoYMax:=199;
    end else begin
{ ----- nahodne generovanie pre jedneho hraca ----- }
      Randomize;
      ZacY:=120-8*Rozmer;
      ZacX[1]:=80-8*Rozmer;
      ZacX[2]:=240-8*Rozmer;
      PocetLodi:=1;
      while RozLodi[TypPlanu,PocetLodi]<>0 do inc(PocetLodi);
      Dec(PocetLodi);
      for i:=1 to PocetLodi do begin
        with PPoloha[Druhy,i] do begin   {naplnenie udajovej struktury PPoloha}
          Znicena:=False;
          for j:=1 to 4 do Zasahy[j]:=False;
          Dlzka:=RozLodi[TypPlanu,i];
          Natoc:=Random(4)+1;
          Horiz:=1;
          Vert:=1;
          if (Natoc=1) or (Natoc=3) then Horiz:=Dlzka else Vert:=Dlzka;
          repeat
            PozX:=Random(Rozmer-Dlzka+1)+1;
            PozY:=Random(Rozmer-Dlzka+1)+1;
            ObrX:=ZacX[Druhy]+16*PozX-16;
            ObrY:=ZacY+16*PozY-16;
            Volny:=True;                  {kontrola, ci tam uz nie je lod}
            if PPlocha[Druhy,PozX,PozY]>0 then Volny:=False;
            if Horiz>1 then for k:=0 to Dlzka-1 do if PPlocha[Druhy,PozX+k,PozY]>0 then Volny:=False;
            if Vert>1 then for k:=0 to Dlzka-1 do if PPlocha[Druhy,PozX,PozY+k]>0 then Volny:=False;
          until Volny;
          for x:=PozX-1 to PozX+Horiz do  {vypln okolie lode 255-kami}
            for y:=PozY-1 to PozY+Vert do
              if (x>0) and (x<=Rozmer) and (y>0) and (y<=Rozmer) then
                PPlocha[Druhy,x,y]:=255;
          PPlocha[Druhy,PozX,PozY]:=i; {naplnenie udajovej struktury PPlocha}
          if Horiz>1 then for x:=PozX to PozX+Dlzka-1 do PPlocha[Druhy,x,PozY]:=i;
          if Vert>1 then for y:=PozY to PozY+Dlzka-1 do PPlocha[Druhy,PozX,y]:=i;
        end; {with}
      end; {for pre lode}
    end; {if}
  end; {for pre hracov}
{ ----- obrazovka s informacnym helpom ----- }
  Nastav(0,0,0);   PrilepDynamickuBitmapu(320,200,Pozadie[1]);
                   CiaraVodorovna(320);
  Nastav(60,10,74);PrilepDynamickuBitmapu(200,173,Pozadie[4]);
                   Obdlznik(200,173);
  Nastav(64,14,0); VypisPriehladne('    Ovlad`anie hry:',Zlta);
  Nastav(104,26,0);VypisPriehladne('MY~SOU:',Zlta);
  Nastav(64,38,0);
  if Dvaja then
    VypisPriehladne('Hr`a~c, ktor`y je na ~tahu,'#13'klikne ~lav`ym tla~cidlom'#13'my~si na ~zelan`e pol`i~cko.',Hneda)
  else VypisPriehladne('Klikni ~lav`ym tla~cidlom'#13'my~si na ~zelan`e pol`i~cko.',Hneda);
  Nastav(64,70,0); VypisPriehladne('     KL`AVESNICOU:',Zlta);
  Nastav(64,80,0);
  if Dvaja then VypisPriehladne('Hr`a~c zad`a s`uradnice'#13'~zelan`eho pol`i~cka.',Hneda)
  else VypisPriehladne('Zadaj s`uradnice'#13'~zelan`eho pol`i~cka.',Hneda);
  Nastav(70,102,0);PrilepBitmapu(16,16,Ofs(More[2]));
                   PrilepPriehladnuBitmapu(16,16,Ofs(More[0]));
  Nastav(90,106,0);VypisPriehladne('Nepresk`uman`e pol`i~cko.',Hneda);
  Nastav(70,122,0);PrilepBitmapu(16,16,Ofs(More[2]));
  Nastav(90,126,0);VypisPriehladne('Voda.',Hneda);
  Nastav(70,142,0);PrilepBitmapu(16,16,Ofs(More[Vedla]));
                   PrilepPriehladnuBitmapu(16,16,Ofs(More[Zasiahnute]));
  Nastav(90,146,0);VypisPriehladne('Z`asah.',Hneda);
  Nastav(64,162,0);
  if Dvaja then VypisPriehladne('Po potopen`i celej lode'#13'ide hr`a~c znova.',Hneda)
  else  VypisPriehladne('Po potopen`i celej lode'#13'ide~s znova.',Hneda);
  ZapniKurzorMysi;
  CakajNaOdozvu;
{ ----- uvodne vypisy ----- }
  VypniKurzorMysi;
  AktTah:=1;AktHrac:=1;BoloX:=False;BoloY:=False;
  ZacY:=120-8*Rozmer;
  ZacX[1]:=80-8*Rozmer;
  ZacX[2]:=240-8*Rozmer;
  Nastav(0,0,0);   PrilepDynamickuBitmapu(320,200,Pozadie[1]);
                   CiaraVodorovna(320);
  if Dvaja then begin
    Nastav(110,2,74);Ramcek(100,18,0);
    Nastav(116,7,0); VypisPriehladne('NA ~TAHU JE:',Zlta);
    VypisMenoLubo;
  end;
  for k:=1 to 2 do ZobrazHraciPlan(ZacX[k],ZacY);
  for k:=1 to 2 do
    for x:=0 to Rozmer-1 do
      for y:=0 to Rozmer-1 do begin
        Nastav(ZacX[k]+16*x,ZacY+16*y,0);
        PrilepPriehladnuBitmapu(16,16,Ofs(More[Prazdne]));
      end;
  NastavTvarKurzora(Ofs(Terc));
  ZapniKurzorMysi;
{ ----- hlavny cyklus hry ----- }
  repeat
    VypisMenoLubo;
    OknoKurzora(AktHrac*320-152-16*Rozmer,AktHrac*320-168+16*Rozmer,124-8*Rozmer,116+8*Rozmer);
    NastavKurzor(AktHrac*320-80,120);
    if Hrac[AktHrac] then begin{aktualny hrac je clovek}
      repeat
        ZistiPoziciu(word(x),word(y),Tlacidla);
        x:=x div 2;
{ ----- obsluha klavesnice ----- }
      if KeyPressed then begin
        ch:=ReadKey;
        if ch in MY then begin
          KlavY:=Ord(UpCase(ch))-64;
          BoloY:=True;
        end;
        if ch in MX then begin
          KlavX:=Ord(ch)-48;
          BoloX:=True;
        end;
        if ch=#27 then goto Dnu;
      end;
      until (Tlacidla=1) or ((BoloX) and (BoloY));
      CakajNaPustenie;
      Delay(100);
      {Off;}
{ ----- uz mame suradnice,vypocitame sur. vzhladom na hraci plan ----- }
      if Tlacidla=1 then AbsX:=(x-ZacX[AktHrac]) div 16+1;
      AbsY:=(y-ZacY) div 16+1;
      if (BoloX) and (BoloY) then begin
        AbsX:=KlavX;
        AbsY:=KlavY;
        BoloX:=False;
        BoloY:=False;
      end;
    end else begin
{ ----- rozmyslaci algoritmus pocitaca ----- }
      repeat
        AbsX:=Random(Rozmer)+1;
        AbsY:=Random(Rozmer)+1;
      until not (PPlocha[AktHrac,AbsX,AbsY] in [253,254]);{aby netrafil dvakrat na to iste miesto}
      {254 je zasah, 253 je vedla}
    end;
{ ----- VEDLA. Bitmapa sa prilepuje VZDY, aj ked je zasah. ----- }
    {if (SB) and (PPlocha[AktHrac,AbsX,AbsY] in [0,253,255]) then Play('zvuklod','BUBLE');}
    if not Hrac[AktHrac] then Delay(100);
    VypniKurzorMysi;
    if PPlocha[AktHrac,AbsX,AbsY] in [0,255] then PPlocha[AktHrac,AbsX,AbsY]:=253;
    Nastav(ZacX[AktHrac]+16*(AbsX-1),ZacY+16*(AbsY-1),0);
    if PPlocha[AktHrac,AbsX,AbsY]<>254 then PrilepBitmapu(16,16,Ofs(More[Vedla]));
    ZapniKurzorMysi;
{ ----- ZASAH ----- }
    if PPlocha[AktHrac,AbsX,AbsY] in Lode then begin
      PomB:=PPlocha[AktHRac,AbsX,AbsY];
      PPlocha[AktHrac,AbsX,AbsY]:=254;
      VypniKurzorMysi;
      Nastav(ZacX[AktHrac]+16*(AbsX-1),ZacY+16*(AbsY-1),0);
      PrilepBitmapu(16,16,Ofs(More[Vedla]));
      PrilepPriehladnuBitmapu(16,16,Ofs(More[Zasiahnute]));
      with PPoloha[AktHrac,PomB] do begin
{ ----- ci je znicena cela lod ----- }
        if (Natoc=1) or (Natoc=3) then Zasahy[AbsX-PozX+1]:=True
                                  else Zasahy[AbsY-PozY+1]:=True;
        Znicena:=True;
        for j:=1 to Dlzka do
            if Zasahy[j]=False then Znicena:=False;
        if Znicena then begin{je znicena}
         { if SB then Play('zvuklod','VYKRIK');}
          if Hrac[AktHrac] then begin{ak ju znicil clovek, vypis to}
            Nastav(100,84,74);
            StiahniBitmapu(120,32,Ofs(InfoBuf));
            Ramcek(120,32,0);
            Nastav(104,87,0);
            if not Koniec then VypisPriehladne('Bola zni~cen`a'#13'  cel`a lo~d.'#13'Ide~s e~ste raz.',Cervena)
                          else VypisPriehladne('Bola zni~cen`a'#13'  cel`a lo~d.'#13'Koniec hry.',Cervena);
            CakajNaOdozvu;
            Nastav(100,84,0);
            PrilepBitmapu(120,32,Ofs(InfoBuf));
          end;
          ZistiCiJeKoniec;
{ ----- susedne policka vynuluj ----- }
          for x:=PozX-1 to PozX+Horiz do
            for y:=PozY-1 to PozY+Vert do
              if (x>0) and (x<=Rozmer) and (y>0) and (y<=Rozmer) then begin
                Nastav(ZacX[AktHrac]+16*(x-1),ZacY+16*(y-1),0);
                PrilepBitmapu(16,16,Ofs(More[Vedla]));
                PPlocha[AktHrac,x,y]:=253;{pre pocitac, aby tam netriafal}
              end;
{ ----- znicenu lod tam nakresli a prelep zasahmi ----- }
          PrilepLod(ObrX,ObrY,Natoc,Horiz,Vert);
          for k:=0 to Dlzka-1 do begin
            Nastav(ObrX+16*k*(Natoc mod 2),ObrY+16*k*((Natoc+1) mod 2),0);
            PrilepPriehladnuBitmapu(16,16,Ofs(More[Zasiahnute]));
          end;
          if AktHrac=1 then AktHrac:=2 else AktHrac:=1;{ide este raz}
        end{ else if SB then Play('zvuklod','KLIK')};
      end;
      ZapniKurzorMysi;
    end;
    if AktHrac=1 then AktHrac:=2 else AktHrac:=1;   {ide dalsi hrac}
{ ----- ci je koniec hry ----- }
    CakajNaPustenie;
    if AktHrac=1 then Inc(AktTah);{zvysuje a len na zaciatku tahu a vzdy pre jedneho hraca}
    ZistiCiJeKoniec;
  until Koniec;
  VypniKurzorMysi;
{ ----- zaverecne vypisy ----- }
  Nastav(26,2,74);Ramcek(268,18,0);
  Nastav(32,7,0);VypisPriehladne('TAKTO BOLI ROZMIESTNEN`E LODI~CKY:',Zlta);
  for k:=1 to 2 do
    for i:=1 to PocetLodi do
      with PPoloha[k,i] do
        PrilepLod(ObrX,ObrY,Natoc,Horiz,Vert);
  Nastav(10+160*(AktHrac-1),40,74);Ramcek(140,16,0);
  Nastav(14+160*(AktHrac-1),44,0);VypisPriehladne('sa st`ava v`i~tazom',Ruzova);
  ZapniKurzorMysi;
  CakajNaOdozvu;
  goto Dnu;
  Von:     {navestie}
{vitaz je Meno[AktHrac],pocet tahov je AktTah}
{ ----- ukoncenie programu ----- }
  for i:=1 to PocetPozadi do ZlikvidujPozadie(Pozadie[i]);
  ZlikvidujPozadie(ObrazUkaz);
  ZlikvidujPozadie(ObrazUkaz2);
  Close(f);
  ZavriGrafiku;
  writeln('Lodicky verzia 1.0'#13#10'MukoSoft, 1997'#13#10);
  writeln('Lubos Saloky');
  writeln('Slovensk‚ho 26');
  writeln('04001 Kosice'#13#10);
  writeln('095/63 381 34');
  writeln('SALOKY@DURO.UPJS.SK');
END.