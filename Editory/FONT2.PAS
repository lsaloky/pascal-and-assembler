program Editor_fontov_verzia_2;
{ vyska pismena je max. 40 pixelov (pole Akt)}
uses MukoGr,MukoUtil,Myska,Dos;
const FontPath='d:\lubo\pascal\units\Prechod.mf';
      MenuX=240;
      PocetOP=12;
      RozPismeno=5;
      Aktiv:array[1..PocetOP,1..4] of word=(
        (0,0,0,0),                                         {pismeno}
        (MenuX,2,MenuX+64,14),                             {novy}
        (MenuX,18,MenuX+64,30),                            {subor}
        (MenuX,34,MenuX+64,46),                            {pridaj}
        (MenuX,50,MenuX+64,62),                            {odstran}
        (MenuX,66,MenuX+64,78),                            {zmaz}
        (MenuX,82,MenuX+30,94),                            {predosly}
        (MenuX+34,82,MenuX+64,94),                         {dalsi}
        (MenuX,98,MenuX+30,110),                           {o 10 naspat}
        (MenuX+34,98,MenuX+64,110),                        {o 10 dalej}
        (MenuX,114,MenuX+64,126),                          {koniec}
        (MenuX,130,MenuX+64,142));                         {paleta}
      Texty:array[2..PocetOP-1] of string[10]=(
        ' Nov`y',' S`ubor','Pridaj','Odstr`a~n',' Zma~z',' <',' >','<<<','>>>','Koniec');
      OLH:array[0..PocetOP] of string[40]=(
        '','Kresli p`ismeno.','Vytvorenie nov`eho p`isma.','Otvorenie s`uboru s p`ismom.',
        'Pridanie p`ismena.','Odstr`anenie pismena.','Zmazanie p`ismena.','Predo~sl`e p`ismeno.',
        'Nasleduj`uce p`ismeno.','O 10 p`ismen nasp|a~t.','O 10 p`ismen ~dalej.',
        'Koniec programu.','Vyber si farbu.');
var f:file;
    ASubor:SearchRec;
    Pismo:array[0..40000] of byte;{buffer pre pismo, neskomprimovane}
    Akt:array[0..1599] of byte;   {aktualne pismeno, sirka je 40}
    i,j,k,l,x,y,z,nx,ny,Udalost,UStara,RozX,RozY,AktPism:word;
    Tlacidla,Farba:byte;
    Subor:string[12];
    Hl:record                        {hlavicka datoveho suboru}
      Verzia,Vyska,PPismen,Posun,PMedzier,SMedzer:byte;
      Rezerva:array[1..10] of byte;
    end;
    Adresa:array[0..255] of word;    {offsety pismen v poli Pismo}
    UBlok:array[0..255] of record    {hlavicka kazdeho pismena}
      Ascii,Sirka,PozDlz,PozMak,Rezerva1,Rezerva2:byte;{ !!! sirka je neskomprimovana !!! }
    end;

Procedure ZobrazAktualnuFarbu;
begin
  VypniKurzorMysi;
  Nastav(MenuX,142,Farba);
  VyplnPlochu(64,10);
  ZapniKurzorMysi;
end;  { ZobrazAktualnuFarbu }
Procedure UlozAktualnePismeno;{do pola Pismo}
var MaxJ,OfsDPov,OfsD,PPres:word;{p“vodny a novy offset dalsieho pismena; pocet presuvanych bajtov}
begin
  MaxJ:=0;
  for i:=0 to 39 do                {hladanie minimalnej sirky pismena}
    for j:=0 to 39 do
      if (Akt[i*40+j]>0) and (j>MaxJ) then MaxJ:=j;
  Inc(MaxJ);                       {max. pocet pixelov v riadku}
  OfsD:=Adresa[AktPism]+Hl.Vyska*MaxJ;
  OfsDPov:=Adresa[AktPism+1];
  PPres:=Adresa[Hl.PPismen]-Adresa[AktPism+1];
    {teraz presuny, ak sa zmenila sirka uz editovaneho pismena}
  if (OfsDPov>0) and (OfsDPov<>OfsD) then begin
    if OfsDPov>OfsD then {schudlo pismeno}
      for i:=1 to PPres do Pismo[OfsD+i-1]:=Pismo[OfsDPov+i-1];
    if OfsDPov<OfsD then {stucnelo pismeno}
      for i:=PPres downto 1 do Pismo[OfsD+i-1]:=Pismo[OfsDPov+i-1];
    for i:=AktPism+1 to Hl.PPismen do Adresa[i]:=Adresa[i]+integer((integer(OfsD)-integer(OfsDPov)));
  end;
  Adresa[AktPism+1]:=OfsD;      {dalsia adresa je adresa+vyska*sirka}
  UBlok[AktPism].Sirka:=MaxJ;
  for i:=0 to Hl.Vyska-1 do     {prekopirovanie do pola Pismo}
    Move(Akt[i*40],Pismo[Adresa[AktPism]+i*MaxJ],MaxJ);
end;  { UlozAktualnePismeno }
Procedure ZobrazAktualnePismeno;
var AktSirka:word;
begin
  nx:=4892;
  Nastav(0,0,0);VyplnPlochu(200,190);
  AktSirka:=UBlok[AktPism].Sirka;
  for i:=0 to Hl.Vyska-1 do      {prekopirovanie do pola Akt}
    Move(Pismo[Adresa[AktPism]+AktSirka*i],Akt[40*i],AktSirka);
  for i:=0 to 1599 do begin
    Nastav((i mod 40)*RozPismeno,(i div 40)*RozPismeno,Akt[i]);
    VyplnPlochu(RozPismeno,RozPismeno);
  end; { for }
  Nastav(MenuX+20,155,0);VyplnPlochu(48,35);
  VypisPriehladne(Chr(UBlok[AktPism].Ascii),SvetloModra);
  Nastav(MenuX+28,155,0);PrilepBitmapu(40,Hl.Vyska,Ofs(Akt));
  for i:=0 to 39 do
    for j:=0 to Hl.Vyska do
      PolozBod(i*RozPismeno,j*RozPismeno,38);
end;  { ZobrazAktualnePismeno }
Procedure PridajPismeno;
begin
  UlozAktualnePismeno;
  AktPism:=Hl.PPismen;
  Inc(Hl.PPismen);
  Nastav(0,0,0);VyplnPlochu(220,190);Nastav(0,1,0);
  VypisPriehladne('ASCII k`od nov`eho p`ismena:',Oranzova);
  Nastav(0,11,0);Citaj(3,Zelena);
  Val(Ret,UBlok[AktPism].Ascii,j);
  FillChar(Akt,SizeOf(Akt),#0);
  ZobrazAktualnePismeno;
end;  { PridajPismeno }
BEGIN
{ ----- inicializacia ----- }
{!!!!!}Hl.Vyska:=5;UBlok[0].Ascii:=65;
  RozX:=40;Farba:=7;nx:=4892;
  InicializujGrafiku;
  NacitajFontAPaletu(FontPath);
  for i:=2 to PocetOP-1 do begin
    Nastav(Aktiv[i,1],Aktiv[i,2],15);
    Ramcek(Aktiv[i,3]-Aktiv[i,1],Aktiv[i,4]-Aktiv[i,2],5);
    Nastav(Aktiv[i,1]+3,Aktiv[i,2]+3,0);
    VypisPriehladne(Texty[i],Zlta);
  end; { for }
  Nastav(MenuX-1,129,26);Obdlznik(66,24);
  for i:=0 to 15 do begin
    Nastav(MenuX+4*i,130,i);
    VyplnPlochu(4,12);
  end; { for }
  ZobrazAktualnuFarbu;
  ZobrazAktualnePismeno;
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
      if (x<RozPismeno*RozX) and (y<RozPismeno*Hl.Vyska) then Udalost:=1;
      if Udalost<>UStara then begin
        VypniKurzorMysi;
        Nastav(0,191,0);
        VyplnPlochu(320,9);
        Nastav(0,192,0);
        VypisPriehladne(OLH[Udalost],SvetloModra);
        UStara:=Udalost;
        ZapniKurzorMysi;
      end; { if }
    until Tlacidla>0;
{ ----- spracovanie udalosti ----- }
    if not (Udalost in [1,3,12]) then VypniKurzorMysi;
    case Udalost of
      1:if Tlacidla=Lave then begin
          if (x div RozPismeno<>nx) or (y div RozPismeno<>ny) then begin
            nx:=x div RozPismeno;
            ny:=y div RozPismeno;
            VypniKurzorMysi;
            Akt[ny*40+nx]:=Farba;
            Nastav(nx*RozPismeno,ny*RozPismeno,Farba);
            VyplnPlochu(RozPismeno,RozPismeno);
            PolozBod(MenuX+28+nx,155+ny,Farba);
            ZapniKurzorMysi;
          end; { if }
        end else begin
          nx:=x div RozPismeno;
          ny:=y div RozPismeno;
          Farba:=Akt[nx+40*ny];
          ZobrazAktualnuFarbu;
        end; {if & case 1 - kreslenie }
      2:begin
        Nastav(0,0,0);VyplnPlochu(220,190);Nastav(0,1,0);
        VypisPriehladne('Zadaj n`azov nov`eho s`uboru:',Oranzova);
        Nastav(0,11,0);Citaj(12,Zelena);Subor:=Ret;
        Nastav(0,21,0);VypisPriehladne('V`y~ska p`ismen:',Oranzova);
        Nastav(0,31,0);Citaj(2,Zelena);
        Val(Ret,Hl.Vyska,j);               {vyska fontu}
        Nastav(0,41,0);VypisPriehladne('Po~cet pixelov medzi'#13'dvoma p`ismenami:',Oranzova);
        Nastav(0,61,0);Citaj(2,Zelena);
        Val(Ret,Hl.PMedzier,j);            {pocet medzier medzi dvoma pismenami}
        Nastav(0,71,0);VypisPriehladne('~S`irka klasickej medzery:',Oranzova);
        Nastav(0,81,0);Citaj(2,Zelena);
        Val(Ret,Hl.SMedzer,j);             {sirka medzerovnika}
        Hl.Verzia:=2;                      {verzia fontu}
        Hl.PPismen:=0;                     {pocet pismen}
        Hl.Posun:=Hl.Vyska+2;              {posun pri #13, zatial sa nastavuje automaticky}
        AktPism:=0;
        PridajPismeno;
      end; { case 2 - novy }
      3:begin
        AktPism:=0;
        SuboroveOkno(20,20,'S`ubory:','msf',ASubor);
        Subor:=ASubor.Name;
        if Subor<>'' then begin
          Assign(f,ASubor.Name);
          Reset(f,1);
          BlockRead(f,Hl,16);  {dekomprimacny algoritmus}
          for i:=0 to Hl.PPismen-1 do begin   {i je aktualne pismeno}
            BlockRead(f,UBlok[i],6);
            l:=(UBlok[i].Sirka) div 2+1;      {l je skomprimovana sirka pismena}
            BlockRead(f,Akt,Hl.Vyska*l);
            for j:=0 to Hl.Vyska-1 do         {j je cyklus pre zvisly rozmer}
              for k:=0 to UBlok[i].Sirka-1 do {k je cyklus pre vodor. rozmer}
                if k mod 2=1 then Pismo[Adresa[i]+j*UBlok[i].Sirka+k]:=Akt[j*l+k div 2] shr 4
                             else Pismo[Adresa[i]+j*UBlok[i].Sirka+k]:=Akt[j*l+k div 2] and $0F;
            Adresa[i+1]:=Adresa[i]+UBlok[i].Sirka*Hl.Vyska;
          end; { for }
          Close(f);
          FillChar(Akt,SizeOf(Akt),#0);
          VypniKurzorMysi;
          ZobrazAktualnePismeno;
          ZapniKurzorMysi;
        end else begin
          VypniKurzorMysi;
          Nastav(0,0,0);
          VyplnPlochu(200,180);
          ZobrazAktualnePismeno;
          ZapniKurzorMysi;
        end; { if }
      end; { case 3 }
      4:PridajPismeno;
      5:begin
        UlozAktualnePismeno;
        Move(Pismo[Adresa[AktPism+1]],Pismo[Adresa[AktPism]],SizeOf(Pismo)-Adresa[AktPism+1]);
        k:=Adresa[AktPism+1]-Adresa[AktPism];
        for i:=AktPism+1 to Hl.PPismen do Adresa[i-1]:=Adresa[i]-k;
        Adresa[Hl.PPismen]:=0;
        Move(UBlok[AktPism+1],UBlok[AktPism],SizeOf(UBlok)-6*(AktPism+1));
        Dec(Hl.PPismen);
        if AktPism=Hl.PPismen then Dec(AktPism);{ak nie je na konci, zobrazuje sa nasledujuce}
        ZobrazAktualnePismeno;
      end; { case 5 - odstr n }
      6:begin
        UlozAktualnePismeno;
        FillChar(Pismo[Adresa[AktPism]],Adresa[AktPism+1]-Adresa[AktPism],Chr(Farba));
        ZobrazAktualnePismeno;
      end; {case 6 - zmaz}
      7:if AktPism>0 then begin
          UlozAktualnePismeno;
          Dec(AktPism);
          FillChar(Akt,SizeOf(Akt),#0);
          ZobrazAktualnePismeno;
        end; { if & case 7 - o 1 nasp„t}
      8:if AktPism<Hl.PPismen-1 then begin
          UlozAktualnePismeno;
          Inc(AktPism);
          FillChar(Akt,SizeOf(Akt),#0);
          ZobrazAktualnePismeno;
        end; { if & case 8 - o 1 dalej}
      9:if AktPism>9 then begin
          UlozAktualnePismeno;
          AktPism:=AktPism-10;
          FillChar(Akt,SizeOf(Akt),#0);
          ZobrazAktualnePismeno;
        end; { if & case 9 - o 10 nasp„t}
      10:if AktPism<Hl.PPismen-10 then begin
          UlozAktualnePismeno;
          AktPism:=AktPism+10;
          FillChar(Akt,SizeOf(Akt),#0);
          ZobrazAktualnePismeno;
        end; { if & case 10 - o 10 dalej}
      12:if (x-MenuX) shr 2<>Farba then begin
          Farba:=(x-MenuX) shr 2;
          ZobrazAktualnuFarbu;
        end; { if & case 12 - paleta}
    end; { case }
    case Udalost of
      5,6,7,8,9,10:CakajNaPustenie;
    end; { case }
    if not (Udalost in [1,3,12]) then ZapniKurzorMysi;
  until Udalost=11;
{ ----- komprimacia, ulozenie suboru s fontom a ukoncenie programu ----- }
  if Subor<>'' then begin
    UlozAktualnePismeno;
    Assign(f,Subor);
    ReWrite(f,1);
    BlockWrite(f,Hl,SizeOf(Hl));
    for i:=0 to Hl.PPismen-1 do begin   {i je aktualne pismeno}
      BlockWrite(f,UBlok[i],6);
      FillChar(Akt,40,#0);
      l:=(UBlok[i].Sirka) div 2+1;      {l je vysledna skomprimovana sirka pismena}
      for j:=0 to Hl.Vyska-1 do         {j je cyklus pre zvisly rozmer}
        for k:=0 to UBlok[i].Sirka-1 do {k je cyklus pre vodor. rozmer}
          if k mod 2=1 then Akt[j*l+k div 2]:=Akt[j*l+k div 2]+Pismo[Adresa[i]+j*UBlok[i].Sirka+k]*16
                       else Akt[j*l+k div 2]:=Pismo[Adresa[i]+j*UBlok[i].Sirka+k];
      BlockWrite(f,Akt,Hl.Vyska*l);
    end;
    Close(f);
  end;
  VypniKurzorMysi;
  ZavriGrafiku;
  Writeln('MukoSoft editor fontov verzia 2.0'#13#10'Programoval Lubos Saloky, 1997');
END.