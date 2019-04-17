uses MainGr,PomGr,Mys,Printer;
{ ----- premenne a konstanty pristupne externym editorom ----- }

const PocetEMB=10;PocetEMGP=19;
      MaxMB=256;MaxMSF=16;MaxMP=16;
      Adresar='d:\lubo\pascal\editory\';
var EMBP:array[1..PocetEMB]of pointer;       {Editor, .MB, pointer}
    EMGPP:array[1..PocetEMGP]of pointer;     {Editor, .MGP, pointer}
    EFP,EPalP:pointer;                       {Editor, Font, pointer; Editor, Paleta, pointer}
    MBP:array[1..MaxMB]of ^BMPStruc;         {editovany subor, .MB,  pointer}
    MSFP:array[1..MaxMSF]of ^FontStruc;      {editovany subor, .MSF, pointer}
    MPP:array[1..MaxMP]of pointer;           {editovany subor, .MP,  pointer}
    NazovBMPSub:array[1..MaxMB] of string[12];
    CisloBMPSub:array[1..MaxMB] of integer;
    NazovFNTSub:array[1..MaxMSF] of string[12];
    DlzkaFNTSub:array[1..MaxMSF] of word;
    NazovMPSub:array[1..MaxMP] of string[12];
    PocetMB,PocetMSF,PocetMP,AktMB,AktMSF,AktMP:integer;
    Udalost,Err,Editor:word;
{ ----- pomocne premenne na volne pouzitie ----- }
    Podkl:pointer;                           {podklad pri prilepovani elementov}
    f:file;
    i,j:integer;
    Tlacidla,PomB:byte;
    ch:char;
    s:string;
{ je to cudne, ale TOTO JE (asi) HLAVNY ZDROJ NESTABILITY PROGRAMU !!! }
{ asi nie, to len FontEdit prepisuje prve procedury v kodovom segmente }
procedure ZobrazVolnuPamat;
var PomS:string;
begin
{  Color:=0;VyplnPlochu(243,177,55,10);
  Str(MemAvail,PomS);
  if MemAvail<100000 then Color:=1 else Color:=3;
  Vypis(246,178,EFP,PomS,Color);}
end;
                      { ----- editor bitmap ----- }
procedure EditorMB(Subor:string;Index:word);
{ zatial nebola implementovana funkcia Odstran bitmapu}
const PocetOP=14;
      Aktiv:array[1..2,1..PocetOP+1,1..4] of word=(
       ((0,0,60,16),(0,20,60,36),(0,40,60,56),(0,60,24,76),
        (36,60,60,76),(0,80,60,96),(1,102,81,192),(110,30,320,200),
        (66,44,94,53),(66,54,94,63),(66,77,94,86),(66,87,94,96),
        (66,18,94,27),(230,0,320,16),(400,0,0,0)),
       ((129,16,139,26),(129,3,147,13),(152,3,170,13),(62,16,72,26),
        (108,16,118,26),(270,0,320,16),(1,125,65,189),(70,40,320,200),
        (5,50,33,60),(35,50,63,60),(5,84,33,94),(35,84,63,94),
        (5,106,33,116),(230,20,320,36),(400,0,0,0)));
      Klav:array[1..PocetOP+1] of Char=('z','n','u',',','.','k',#0,#0,'1','2','3','4','m',#0,#255);
      Pomoc:array[0..PocetOP] of string[40]=(
        ' ','Zmazanie obrazovky','Nahratie .MB s`uboru','Ulo~zenie .MB s`uboru',
        'Predo~sla bitmapa','Nasleduj`uca bitmapa','Koniec','Vyber si farbu','Polo~z bod',
        'Zmena poz`icie zv|a~c~seniny','Zmena poz`icie zv|a~c~seniny',
        'Zmena poz`icie skuto~cnej bitmapy','Zmena poz`icie skuto~cnej bitmapy',
        'Zmena koeficientu zv|a~c~senia','Zmena vzh~ladu editora');
var EMB:^BMPStruc;
    EditX,EditY,MiniX,MiniY,Mierka:word;
    RozX,RozY,Farba:byte;
    BolaZmenena:boolean;

{ ----- interne procedury grafickeho editora ----- }

procedure PrepisHodnoty(EditX,EditY,MiniX,MiniY,Mierka:word);
var s:string;
begin
  Str(EditX,s);
  VypisPO(Aktiv[Editor,9,1]+1,Aktiv[Editor,9,2]+1,EFP,s,Oranzova);
  Str(EditY,s);
  VypisPO(Aktiv[Editor,10,1]+1,Aktiv[Editor,10,2]+1,EFP,s,Oranzova);
  Str(MiniX,s);
  VypisPO(Aktiv[Editor,11,1]+1,Aktiv[Editor,11,2]+1,EFP,s,Oranzova);
  Str(MiniY,s);
  VypisPO(Aktiv[Editor,12,1]+1,Aktiv[Editor,12,2]+1,EFP,s,Oranzova);
  Str(Mierka,s);
  VypisPO(Aktiv[Editor,13,1]+1,Aktiv[Editor,13,2]+1,EFP,s,Oranzova);
  ZobrazVolnuPamat;
end;

procedure ZmazAktualnuBitmapu;
begin
  Color:=0;
  VyplnPlochu(EditX-2,EditY-2,Mierka*EMB^.RozX+4,Mierka*EMB^.RozY+4);
  VyplnPlochu(MiniX,MiniY,EMB^.RozX,EMB^.RozY);
end;

procedure InicializujAktualnuBitmapu; { zobrazi ju }
begin
  VM;
  VypinajMys:=False;
  ZmazAktualnuBitmapu;
  with EMB^ do begin                             {velka bitmapa}
    for i:=0 to RozX-1 do
      for j:=0 to RozY-1 do begin
        Color:=BMP[i+RozX*j];
        VyplnPlochu(EditX+i*Mierka,EditY+j*Mierka,Mierka,Mierka);
      end;
    Color:=15;
    CiaraVodorovna(EditX-2,EditY-2,RozX*Mierka+4);
    CiaraVodorovna(EditX-2,EditY+RozY*Mierka+1,RozX*Mierka+4);
    CiaraZvisla(EditX-2,EditY-2,RozY*Mierka+4);
    CiaraZvisla(EditX+Mierka*RozX+1,EditY-2,RozY*Mierka+4);
  end;
  PrilepBMP(MiniX,MiniY,EMB);
  ZM;
  VypinajMys:=True;
end;

function NacitajAktualnuBitmapu(Subor:string;Index:word):boolean;
begin
  Seek(f,768);
  BlockRead(f,PomB,1);
  if Index>PomB then NacitajAktualnuBitmapu:=False
  else begin
    for i:=1 to Index-1 do begin
      BlockRead(f,RozX,1);
      BlockRead(f,RozY,1);
      Seek(f,FilePos(f)+word(RozX)*RozY);
    end;
    BlockRead(f,RozX,1);
    BlockRead(f,RozY,1);
    Seek(f,Filepos(f)-2);
    if EMB<>nil then FreeMem(EMB,EMB^.RozX*EMB^.RozY+4);
    NacitajBMP(f,pointer(EMB));
    EMB^.RozX:=word(RozX);
    EMB^.RozY:=word(RozY);
    Aktiv[Editor,8,3]:=EditX+EMB^.RozX*Mierka;
    Aktiv[Editor,8,4]:=EditY+EMB^.RozY*Mierka;
    InicializujAktualnuBitmapu;
    NacitajAktualnuBitmapu:=True;
  end;
end;

procedure PridajBitmapu;
begin
  Color:=0;VyplnPlochu(EditX,EditY,100,30);
  VypisPO(EditX,EditY,EFP,'Rozmer X:',8);
  Citaj(EditX+70,EditY,3,s);
  Val(s,RozX,Err);
  VypisPO(EditX,EditY+10,EFP,'Rozmer Y:',8);
  Citaj(EditX+70,EditY+10,3,s);
  Val(s,RozY,Err);
  if EMB<>nil then FreeMem(EMB,EMB^.RozX*EMB^.RozY+4);
  GetMem(EMB,word(RozX)*RozY+4);
  EMB^.RozX:=RozX;
  EMB^.RozY:=RozY;
  for i:=0 to EMB^.RozX*EMB^.RozY do EMB^.BMP[i]:=0;
  Seek(f,768);
  BlockRead(f,PomB,1);
  Inc(PomB);
  Seek(f,768);
  BlockWrite(f,PomB,1);
  Aktiv[Editor,8,3]:=EditX+Mierka*EMB^.RozX; { uprava rozmerov aktivnej oblasti }
  Aktiv[Editor,8,4]:=EditY+Mierka*EMB^.RozY;
  Color:=0;VyplnPlochu(EditX,EditY,100,30);
  Inc(PocetMB);
  GetMem(MBP[PocetMB],EMB^.RozX+EMB^.RozY+4);
  NazovBMPSub[PocetMB]:=Subor;
  if PocetMB>1 then CisloBMPSub[PocetMB]:=CisloBMPSub[PocetMB-1]+1
               else CisloBMPSub[PocetMB]:=1;

  BolaZmenena:=True;
end;

procedure UlozAktualnuBitmapu(Subor:string;Index:word);
begin
  Seek(f,769);
  for i:=1 to Index-1 do begin
    BlockRead(f,RozX,1);
    BlockRead(f,RozY,1);
    Seek(f,FilePos(f)+word(RozX)*RozY);
  end;
  with EMB^ do begin
    BlockWrite(f,byte(RozX),1);
    BlockWrite(f,byte(RozY),1);
    BlockWrite(f,BMP,RozX*RozY);
  end;
end;
procedure InicializujEditor; { vykresli editor - pouzivane pri prepinani }
begin
  VM;
  VypinajMys:=False;
  ZmazObrazovku;
  if Editor=1 then begin
    VykresliMGP(EMGPP[11],@EMBP,@EFP);
    Color:=Farba;
    VyplnPlochu(83,102,15,80);
  end else begin
    VykresliMGP(EMGPP[18],@EMBP,@EFP);
    Color:=Farba;
    VyplnPlochu(42,106,23,18);
  end;
  for i:=0 to 15 do for j:=0 to 15 do begin      {paleta}
    Color:=j+16*i;
    if Editor=1 then VyplnPlochu(1+5*j,102+5*i,5,5)
                else VyplnPlochu(1+4*j,125+4*i,4,4);
  end;
  VypinajMys:=True;
  ZM;
end;
BEGIN
{ ----- inicializacia ----- }
  CakajNaPustenie;
  GetMem(EMB,5);                   {inicializacia editovanej bitmapy}
  EMB^.RozX:=1;                    {MUSI SA FREEMEMovat pred pouzitim}
  EMB^.RozY:=1;
  BolaZmenena:=False;
  Farba:=5;
  if Editor=1 then begin
    MiniX:=100;MiniY:=0;EditX:=110;EditY:=30;
  end else begin
    MiniX:=175;MiniY:=5;EditX:=80;EditY:=40;
  end;
  Mierka:=3;
  InicializujEditor;
{ ----- pridanie noveho suboru ----- }
  if Subor='' then begin
    Color:=0;VyplnPlochu(EditX,EditY,140,30);
    VypisPO(EditX+1,EditY+1,EFP,'Meno nov`eho s`uboru:',SvetloModra);
    Citaj(EditX+1,EditY+11,12,Subor);
    Assign(f,Subor);
    ReWrite(f,1);
    BlockWrite(f,EPalP^,768);
    PomB:=0;
    BlockWrite(f,PomB,1);
    Color:=0;VyplnPlochu(EditX,EditY,140,30);
    PridajBitmapu;
    Index:=1;
    UlozAktualnuBitmapu(Subor,1);
    Close(f);
  end;
  Assign(f,Subor);
  Reset(f,1);
  NacitajAktualnuBitmapu(Subor,Index);
{ ----- zobrazenie bitmapy a dalsich udajov ----- }
  PrilepBMP(MiniX,MiniY,EMB);                    {mala bitmapa}
  PrepisHodnoty(EditX,EditY,MiniX,MiniY,Mierka);
{ ----- hlavny cyklus ----- }
  repeat
    Udalost:=ObsluzUdalostSHelpom(@Aktiv[Editor],@Klav,EFP,@Pomoc);
    CakajNaVOI;
    case Udalost of
      1:begin { zmazanie }
        ZmazAktualnuBitmapu;
        Color:=0;VyplnPlochu(MiniX,MiniY,EMB^.RozX,EMB^.RozY);
        with EMB^ do
          for i:=0 to RozX*RozY-1 do BMP[i]:=Farba;
        InicializujAktualnuBitmapu;
        BolaZmenena:=True;
      end;
      2:begin { nahraj }
        ZmazAktualnuBitmapu;
        CakajNaPustenie;
        SuboroveOkno(EFP,'Nahratie .MB s`uboru','*.MB',Subor);
        if Subor<>'' then NacitajAktualnuBitmapu(Subor,1);
        ZobrazVolnuPamat;
      end;
      3:begin
        UlozAktualnuBitmapu(Subor,Index);  { uloz }
        BolaZmenena:=False;
      end;
      4:if Index>1 then begin { predosly }
        if BolaZmenena then UlozAktualnuBitmapu(Subor,Index);
        Dec(Index);
        ZmazAktualnuBitmapu;
        NacitajAktualnuBitmapu(Subor,Index);
      end;
      5:begin { dalsi }
        if BolaZmenena then UlozAktualnuBitmapu(Subor,Index);
        Inc(Index);
        ZmazAktualnuBitmapu;
        if not NacitajAktualnuBitmapu(Subor,Index) then begin { dalsia? }
          Color:=0;VyplnPlochu(EditX,EditY,100,30);
          VypisPO(EditX,EditY,EFP,'Dalsia? A/N',Cervena);
          ch:=CitajZnak;
          if ch in ['a','A'] then begin                       { dalsia. }
            PridajBitmapu;
            UlozAktualnuBitmapu(Subor,Index);
            BolaZmenena:=False;
            InicializujAktualnuBitmapu;
          end else begin                                      { nie dalsia }
            InicializujAktualnuBitmapu;
            Dec(Index);
          end;
        end;
      end;
     {6 je koniec}
      7:begin { zmena aktualnej farby }
        if Editor=1 then Farba:=(MysX-1) div 5+16*((MysY-102) div 5)
                    else Farba:=(MysX-1) div 4+16*((MysY-125) div 4);
        Color:=Farba;
        if Editor=1 then VyplnPlochu(83,102,15,80)
                    else VyplnPlochu(42,106,23,18);
      end;
      8:begin { polozenie bodu }
        i:=(integer(MysX)-integer(EditX)) div Mierka; {relativne suradnice v poli bitmapy}
        j:=(MysY-EditY) div Mierka;
        if (i<EMB^.RozX) and (j<EMB^.RozY) and (i>=0) and (j>=0) then begin
          with EMB^ do BMP[i+RozX*j]:=Farba;
          Color:=Farba;
          VyplnPlochu(EditX+i*Mierka,EditY+j*Mierka,Mierka,Mierka);
          PolozBod(MiniX+i,MiniY+j,Farba);
          BolaZmenena:=True;
        end;
      end;
      9:begin { zmena EditX }
        ZmazAktualnuBitmapu;
        PrilepBMP(Aktiv[Editor,Udalost,1],Aktiv[Editor,Udalost,2],EMBP[7]);
        Citaj(Aktiv[Editor,Udalost,1]+1,Aktiv[Editor,Udalost,2]+1,3,s);
        Val(s,EditX,Err);
        Aktiv[Editor,8,1]:=EditX;
        Aktiv[Editor,8,3]:=EditX+Mierka*EMB^.RozX;
        InicializujAktualnuBitmapu;
        PrepisHodnoty(EditX,EditY,MiniX,MiniY,Mierka);
      end;
      10:begin { zmena EditY }
        ZmazAktualnuBitmapu;
        PrilepBMP(Aktiv[Editor,Udalost,1],Aktiv[Editor,Udalost,2],EMBP[7]);
        Citaj(Aktiv[Editor,Udalost,1]+1,Aktiv[Editor,Udalost,2]+1,3,s);
        Val(s,EditY,Err);
        Aktiv[Editor,8,2]:=EditY;
        Aktiv[Editor,8,4]:=EditY+Mierka*EMB^.RozY;
        InicializujAktualnuBitmapu;
        PrepisHodnoty(EditX,EditY,MiniX,MiniY,Mierka);
      end;
      11:begin { zmena MiniX }
        ZmazAktualnuBitmapu;
        PrilepBMP(Aktiv[Editor,Udalost,1],Aktiv[Editor,Udalost,2],EMBP[7]);
        Citaj(Aktiv[Editor,Udalost,1]+1,Aktiv[Editor,Udalost,2]+1,3,s);
        Color:=0;VyplnPlochu(MiniX,MiniY,EMB^.RozX,EMB^.RozY);
        Val(s,MiniX,Err);
        InicializujAktualnuBitmapu;
        PrepisHodnoty(EditX,EditY,MiniX,MiniY,Mierka);
      end;
      12:begin { zmena MiniY }
        ZmazAktualnuBitmapu;
        PrilepBMP(Aktiv[Editor,Udalost,1],Aktiv[Editor,Udalost,2],EMBP[7]);
        Citaj(Aktiv[Editor,Udalost,1]+1,Aktiv[Editor,Udalost,2]+1,3,s);
        Color:=0;VyplnPlochu(MiniX,MiniY,EMB^.RozX,EMB^.RozY);
        Val(s,MiniY,Err);
        InicializujAktualnuBitmapu;
        PrepisHodnoty(EditX,EditY,MiniX,MiniY,Mierka);
      end;
      13:begin { zmena mierky }
        ZmazAktualnuBitmapu;
        PrilepBMP(Aktiv[Editor,Udalost,1],Aktiv[Editor,Udalost,2],EMBP[7]);
        Citaj(Aktiv[Editor,Udalost,1]+1,Aktiv[Editor,Udalost,2]+1,3,s);
        Val(s,Mierka,Err);
        InicializujAktualnuBitmapu;
        PrepisHodnoty(EditX,EditY,MiniX,MiniY,Mierka);
        Aktiv[Editor,8,3]:=EditX+Mierka*EMB^.RozX; { uprava rozmerov aktivnej oblasti }
        Aktiv[Editor,8,4]:=EditY+Mierka*EMB^.RozY;
      end;
      14:begin
        if Editor=2 then Editor:=1 else Editor:=2;
        if Editor=1 then begin
          MiniX:=100;MiniY:=0;EditX:=110;EditY:=30;
        end else begin
          MiniX:=175;MiniY:=5;EditX:=80;EditY:=40;
        end;
        InicializujEditor;
        PrepisHodnoty(EditX,EditY,MiniX,MiniY,Mierka);
        InicializujAktualnuBitmapu;
      end;
    end;
    if not (Udalost mod 256 in [7,8]) then CakajNaPustenie;
  until Udalost mod 256 in [0,6];
  UlozAktualnuBitmapu(Subor,Index);
{ ----- aktualizuj MBP - bitmapy v editore MGP ----- }
  i:=1;
  while NazovBMPSub[i]<>Subor do Inc(i);
  Seek(f,768);
  BlockRead(f,PomB,1);
  for j:=1 to PomB do begin
    if MBP[j+i-1]<>nil then FreeMem(MBP[j+i-1],MBP[j+i-1]^.RozX*MBP[j+i-1]^.RozY+4);
    NacitajBMP(f,pointer(MBP[j+i-1]));
  end;
  if EMB<>nil then FreeMem(EMB,EMB^.RozX*EMB^.RozY+4);
  Close(f);
  Udalost:=43;{je to globalna premenna, nech MGP vie, ze bol v editore bitmap}
END;


                       { ----- editor paliet ----- }

procedure EditorMP(Subor:string);
type TPaleta=array[0..255,0..2] of byte;
const PocetOP=10;
      Aktiv:array[1..PocetOP+1,1..4] of word=(
        (65,3,83,13),(88,3,106,13),(71,20,99,29),(115,20,143,29),
        (159,20,187,29),(94,36,122,45),(147,36,175,45),(89,51,169,67),
        (270,0,320,16),(106,71,214,179),(400,0,0,0));
      Klav:array[1..PocetOP+1] of Char=(#0,#0,'r','g','b',',','.','k',#27,#0,#255);
      Pomoc:array[0..PocetOP] of string[40]=(
        ' ','Nahratie .MP s`uboru','Ulo~zenie .MP s`uboru',
        '~Cerven`a zlo~zka','Zelen`a zlo~zka','Modr`a zlo~zka',
        'Prv`a farba farebn`eho prechodu','Posledn`a farba farebn`eho prechodu',
        'Kalkul`acia farebn`eho prechodu','Koniec','Vyber si farbu');
var AktFarba,ZacFarba,KonFarba:byte;
    p:^TPaleta;
BEGIN
{ ----- inicializacia ----- }
  CakajNaPustenie;
  AktFarba:=0;ZacFarba:=176;KonFarba:=191;
  if Subor='' then begin   {nainicializuj standardnu paletu, ak ziadna nie je}
    GetMem(MPP[AktMP],768);
    Presun(EPalP,MPP[AktMP],768);
    ZobrazVolnuPamat;
  end;
  p:=MPP[AktMP];
  NastavPaletu(p);
  VM;VypinajMys:=False;
  ZmazObrazovku;
  VykresliMGP(EMGPP[17],@EMBP,@EFP);
  Str(ZacFarba,s);
  VypisPO(95,37,EFP,s,Zlta);
  Str(KonFarba,s);
  VypisPO(148,37,EFP,s,Zlta);
  for i:=0 to 15 do
    for j:=0 to 15 do begin
      Color:=i+16*j;
      VyplnPlochu(106+7*i,71+7*j,7,7);
    end;
  ZobrazVolnuPamat;
  ZM;VypinajMys:=True;
{ ----- cakanie na udalost ----- }
  repeat
    Udalost:=ObsluzUdalostSHelpom(@Aktiv,@Klav,EFP,@Pomoc);
    case Udalost of
      1:begin { nahraj }
        CakajNaPustenie;
        SuboroveOkno(EFP,'Nahratie .MP s`uboru','*.MP',Subor);
        if Subor<>'' then begin
          if MPP[AktMP]<>nil then FreeMem(MPP[AktMP],768);
          NacitajPaletu(Subor,MPP[AktMP]);
          NastavPaletu(MPP[AktMP]);
          ZobrazVolnuPamat;
        end;
        p:=MPP[AktMP];
      end;
      2:begin { uloz }
        CakajNaPustenie;
        SuboroveOkno(EFP,'Ulo~zenie .MP s`uboru','*.MP',Subor);
        if Subor<>'' then begin
          Assign(f,Subor);
          ReWrite(f,768);
          BlockWrite(f,MPP[AktMP]^,1);
          Close(f);
          NazovMPSub[AktMP]:=Subor;
        end;
      end;
      3..5:begin { nastav farbovu zlozku }
        PrilepBMP(71+(Udalost-3)*44,20,EMBP[7]);
        VM;
        Citaj(72+(Udalost-3)*44,21,3,s);
        ZM;
        Val(s,PomB,Err);
        TPaleta(MPP[AktMP]^)[AktFarba,Udalost-3]:=PomB and $3F;
        NastavPaletu(MPP[AktMP]);
      end;
      6:begin { zaciatok farebneho prechodu }
        PrilepBMP(94,36,EMBP[7]);
        VM;
        Citaj(95,37,3,s);
        ZM;
        Val(s,ZacFarba,Err);
      end;
      7:begin { koniec farebneho prechodu }
        PrilepBMP(147,36,EMBP[7]);
        VM;
        Citaj(148,37,3,s);
        ZM;
        Val(s,KonFarba,Err);
      end;
      8:if ZacFarba<KonFarba then begin { kalkulacia farebneho prechodu }
          for i:=0 to KonFarba-ZacFarba do begin
            p^[ZacFarba+i,0]:=Round(p^[ZacFarba,0]+
              (p^[KonFarba,0]-p^[ZacFarba,0])*i/(KonFarba-ZacFarba));
            p^[ZacFarba+i,1]:=Round(p^[ZacFarba,1]+
              (p^[KonFarba,1]-p^[ZacFarba,1])*i/(KonFarba-ZacFarba));
            p^[ZacFarba+i,2]:=Round(p^[ZacFarba,2]+
              (p^[KonFarba,2]-p^[ZacFarba,1])*i/(KonFarba-ZacFarba));
          end;
          NastavPaletu(MPP[AktMP]);
        end;
     {9 je koniec}
      10:begin { volba aktualnej farby }
        AktFarba:=(MysX-106) div 7+16*((MysY-71) div 7);
        Color:=AktFarba;
        VyplnPlochu(17,104,78,78);
        for i:=0 to 2 do begin
          PrilepBMP(71+i*44,20,EMBP[7]);
          Str(p^[AktFarba,i],s);
          VypisPO(72+i*44,21,EFP,s,Zlta);
        end;
        CakajNaVOI;
      end;
    end;
    if Udalost<>10 then CakajNaPustenie;
  until Udalost=9;
  Udalost:=45;              {je to globalna premenna, nech MGP vie, ze bol v editore paliet}
  NastavPaletu(EPalP);      {vrat paletu do normalneho stavu}
END;

                   { ----- editor fontov ----- }
procedure EditorMSF(Subor:string);
type PFontStruc=^FontStruc;
const PocetOP=10;
      PismSize=800;
      PismSirka=40;
      EditY=100;
      Aktiv:array[1..PocetOP+1,1..4] of word=(
        (129,3,147,13),(152,3,170,13),(62,16,72,26),(76,16,104,25),
        (108,16,118,26),(129,16,139,26),(270,0,320,16),(280,39,308,49),
        (0,EditY,320,192),(0,43,162,63),(400,0,0,0));
      Klav:array[1..PocetOP+1] of Char=(#0,#0,'-',' ','+','x',#27,'m',#0,#0,#255);
      Pomoc:array[0..PocetOP] of string[40]=(
        ' ','Nahratie .MSF s`uboru','Ulo~zenie .MSF s`uboru',
        'Predo~sl`e p`ismeno','Poradov`e ~c`islo p`ismena',
        'Nasleduj`uce p`ismeno','Odstr`a~n p`ismeno','Koniec',
        'Zmena koeficientu zv|a~c~senia','Polo~z bod','Vyber si farbu');
var Hlavicka:array[1..16] of byte;
    Pismeno:array[0..PismSize-1] of byte;
    Index,DlzkaFontu:word;        {aktualne pismeno; dlzka potrebna pre FreeMem}
    OfsAktPism,Mierka:word;
    Sirka:integer;                {musi byt so znamienkom}
    Farba:byte;
    Font,PPom:PFontStruc;
{ ----- pomocne procedury ----- }
procedure ZobrazPismeno;
begin
  VypinajMys:=False;
  VM;Color:=0;
  VyplnPlochu(0,EditY,200,191-EditY);
  VyplnPlochu(150,16,10,10);
  Vypis(151,17,EFP,Chr(Index),Zlta);
  if Sirka>0 then begin
    with Font^ do begin
      for i:=0 to Vyska-1 do
        for j:=0 to Sirka-1 do begin
          Color:=Pismeno[i*PismSirka+j];
          VyplnPlochu(j*Mierka,EditY+i*Mierka,Mierka,Mierka);
        end;
    end;
  end;
  Color:=25;
  CiaraVodorovna(0,EditY-1,200);
  CiaraVodorovna(0,EditY+Font^.Vyska*Mierka,200);
  if Mierka>2 then
    for i:=0 to Font^.Vyska-1 do
      for j:=0 to Font^.Vyska-1 do
        PolozBod(i*Mierka,EditY+j*Mierka,25);
{  Str(DlzkaFontu,s);
  VypisPO(240,EditY+12,EFP,s,SvetloModra);}
  ZobrazVolnuPamat;
  ZM;VypinajMys:=True;
end;
procedure ZmenaPismena;           {nastavi udajove struktury pre nove pismeno}
begin
  if Font^.OfsTab[Index]=0
  then begin
    OfsAktPism:=32000;
    Sirka:=0;
  end else begin
    OfsAktPism:=Font^.OfsTab[Index]-528;{offset v poli PISMO}
    Sirka:=Font^.Pismo[OfsAktPism+1];
  end;
  PrilepBMP(76,16,EMBP[7]);
  Str(Index,s);
  VypisPO(79,17,EFP,s,SvetloModra);
  PrilepBMP(280,39,EMBP[7]);
  Str(Mierka,s);
  VypisPO(283,40,EFP,s,SvetloModra);
  Aktiv[9,4]:=EditY+Mierka*Font^.Vyska-1;
end;
{ ----- prevedenie skomprimovaneho pismena na neskomprimovane ----- }
procedure FontNaPismeno;
begin
  Vypln(@Pismeno,PismSize,0);
  if OfsAktPism<>32000 then
  with Font^ do
    for i:=0 to Vyska-1 do
      for j:=0 to Sirka-1 do
        if j mod 2=0 then
          Pismeno[i*PismSirka+j]:=Pismo[OfsAktPism+6+i*(Sirka div 2+1)+j div 2] and $0F   {horne 4 bity}
                     else
          Pismeno[i*PismSirka+j]:=Pismo[OfsAktPism+6+i*(Sirka div 2+1)+j div 2] shr 4;  {dolne 4 bity}
end;
{ ----- Getmem s tym, ze Ofs(p^) je vzdy 0 ----- }
procedure GetMem0(var p:PFontStruc;Pocet:word);
begin
  if ppom<>nil then begin
    FreeMem(ppom,8);
    ppom:=nil;
  end;
  GetMem(p,Pocet);
  if Ofs(p^)=8 then begin
    FreeMem(p,Pocet);
    GetMem(ppom,8);
    GetMem(p,Pocet);
  end;
end;
{ ----- prevedenie neskomprimovaneho pismena na skomprimovane ----- }
procedure PismenoNaFont;
var KompNovaSirka,KompStaraSirka,NovaSirka:integer;
    NovyFont:PFontStruc;
    Aktualizacia:boolean;
begin
{ ----- hladanie maximalnej sirky ----- }
  Aktualizacia:=False;    {zatial nebola zmena}
  NovaSirka:=0;
  for j:=0 to Font^.Vyska do begin
    i:=PismSirka;
    while (i>0) and (Pismeno[PismSirka*j+i-1]=0) do Dec(i);
    if NovaSirka<i then NovaSirka:=i;
  end;
  if NovaSirka=0 then KompNovaSirka:=0
                 else KompNovaSirka:=(NovaSirka shr 1)+1;
{ ----- pridanie noveho pismena na koniec ----- }
  if (OfsAktPism=32000) and (NovaSirka>0) then begin
    Aktualizacia:=True;
    KompStaraSirka:=0;
    OfsAktPism:=DlzkaFontu-528;
    GetMem0(NovyFont,DlzkaFontu+Font^.Vyska*KompNovaSirka+6);
    Presun(Font,NovyFont,DlzkaFontu);
    Vypln(@NovyFont^.Pismo[OfsAktPism],Font^.Vyska*KompNovaSirka+6,0);
    NovyFont^.OfsTab[Index]:=DlzkaFontu;
    with NovyFont^ do begin              {napln udajovy blok}
      Pismo[OfsAktPism]:=Index;
      Pismo[OfsAktPism+1]:=NovaSirka;
      Inc(PPismen);                      { pozor na tento udaj ! }
    end;
  end;
{ ----- pismeno bolo zuzene alebo predlzene ----- }
  if (OfsAktPism<32000) and (Sirka<>NovaSirka) and (not Aktualizacia) then begin
    Aktualizacia:=True;
    KompStaraSirka:=(Sirka shr 1)+1;
    GetMem0(NovyFont,DlzkaFontu+Font^.Vyska*(KompNovaSirka-KompStaraSirka));
    Presun(@Font^.Verzia,pointer(longint(@NovyFont^.Verzia)+Font^.Vyska*(KompNovaSirka-KompStaraSirka)),DlzkaFontu-512);
    Presun(Font,NovyFont,Font^.OfsTab[Index]+6);
    Vypln(@NovyFont^.Pismo[OfsAktPism+6],Font^.Vyska*KompNovaSirka,0);
    NovyFont^.Pismo[OfsAktPism+1]:=NovaSirka;
    for i:=0 to 255 do { uprav tabulku ofsetov }
      with NovyFont^ do
        if OfsTab[i]>OfsAktPism+528 then
          Inc(OfsTab[i],Vyska*(KompNovaSirka-KompStaraSirka));
  end;
{ ----- pismeno bolo zmenene, ale nezmenila sa sirka ----- }
  if (NovaSirka=Sirka) and (Sirka>0) and (not Aktualizacia) then begin
    Aktualizacia:=True;
    GetMem0(NovyFont,DlzkaFontu);
    Presun(Font,NovyFont,DlzkaFontu);
    KompStaraSirka:=KompNovaSirka;
  end;
{ ----- prepisovanie pismena ----- }
  if Aktualizacia then begin
    with NovyFont^ do begin
      Pismo[OfsAktPism+1]:=NovaSirka;
      for j:=0 to Vyska-1 do begin
        for i:=0 to NovaSirka-1 do begin
          if i and $01=0
          then Pismo[OfsAktPism+6+j*KompNovaSirka+i shr 1]:=Pismeno[i+PismSirka*j]
          else Inc(Pismo[OfsAktPism+6+j*KompNovaSirka+i shr 1],Pismeno[i+PismSirka*j] shl 4);
        end;
      end;
    end;
    FreeMem(Font,DlzkaFontu);
    Font:=NovyFont;
    Inc(DlzkaFontu,NovyFont^.Vyska*(KompNovaSirka-KompStaraSirka));
    if (Sirka=0) and (NovaSirka>0) then Inc(DlzkaFontu,6);{pri pridani noveho pismena priestor pre udajovy blok}
    ZmenaPismena;
  end;
end;

BEGIN
  VypinajMys:=True;
  CakajNaPustenie;
  ppom:=nil;
  Index:=65;
  Mierka:=5;
  Farba:=11;
{ ----- novy subor s fontom ----- }
  if PocetMSF=0 then begin
    for i:=1 to 16 do Hlavicka[i]:=0;
    Hlavicka[1]:=2;               {verzia}
    VykresliMGP(EMGPP[19],@EMBP,@EFP);
    PocetMSF:=1;
    AktMSF:=1;
    Citaj(168,75,12,NazovFNTSub[1]);
    Citaj(234,94,3,s);
    Val(s,Hlavicka[2],Err);       {vyska}
    Citaj(234,114,3,s);
    Val(s,Hlavicka[6],Err);       {sirka medzery}
    Citaj(234,134,3,s);
    Val(s,Hlavicka[5],Err);       {vzdialenost pismen}
    Assign(f,NazovFNTSub[1]);
    ReWrite(f,16);
    BlockWrite(f,Hlavicka,1);
    Close(f);
  end;
  Assign(f,NazovFNTSub[AktMSF]);
  Reset(f,1);
  BlockRead(f,Hlavicka,16);
  DlzkaFontu:=FileSize(f)+512;
  Close(f);
  NacitajFont(NazovFNTSub[AktMSF],pointer(Font));
{ ----- uprava na offset 0 ----- }
  if Ofs(Font^)=8 then begin
    GetMem0(PPom,DlzkaFontu);
    Presun(Font,PPom,DlzkaFontu);
    FreeMem(Font,DlzkaFontu);
    Font:=PPom;
    PPom:=nil;
    for i:=0 to 255 do if Font^.OfsTab[i]>0 then Dec(Font^.OfsTab[i],8);
  end;
  VM;ZmazObrazovku;ZM;
  VykresliMGP(EMGPP[16],@EMBP,@EFP);
  ZmenaPismena;
  FontNaPismeno;
  ZobrazPismeno;
  repeat
    Udalost:=ObsluzUdalostSHelpom(@Aktiv,@Klav,EFP,@Pomoc);
    CakajNaVOI;
    case Udalost of
      1:begin
        SuboroveOkno(EFP,'Nahratie .MSF s`uboru','*.MSF',Subor);
        if Subor<>'' then begin
          Assign(f,Subor);
          Reset(f,1);
          BlockRead(f,Hlavicka,16);
          DlzkaFontu:=FileSize(f)+512;
          Close(f);
          if Font<>nil then FreeMem(Font,DlzkaFontu);
          NacitajFont(Subor,pointer(Font));
          Index:=65;
          ZmenaPismena;
          FontNaPismeno;
          ZobrazPismeno;
          ZobrazVolnuPamat;
        end;
      end;
      2:begin
        SuboroveOkno(EFP,'Ulo~zenie .MSF s`uboru','*.MSF',Subor);
        if Subor<>'' then begin
          PismenoNaFont;
          Assign(f,Subor);
          ReWrite(f,DlzkaFontu-512);
          BlockWrite(f,Font^.Verzia,1);
          Close(f);
        end;
      end;
      3:if Index>0 then begin {Pismeno, Predchadzajuce}
        PismenoNaFont;
        Dec(Index);
        ZmenaPismena;
        FontNaPismeno;
        ZobrazPismeno;
      end;
      4:begin                     {Pismeno, Cislo pismena}
        PismenoNaFont;
        VM;
        PrilepBMP(76,16,EMBP[7]);
        Citaj(78,17,3,s);
        Val(s,Index,Err);
        if Index>255 then Index:=65;
        ZmenaPismena;
        FontNaPismeno;
        ZobrazPismeno;
        ZM;
      end;
      5:if Index<255 then begin   {Pismeno, Nasledujuce}
        PismenoNaFont;
        Inc(Index);
        ZmenaPismena;
        FontNaPismeno;
        ZobrazPismeno;
      end;
     {6 - odstran pismeno}
     {7 je Koniec}
      8:begin                     {Zmena mierky}
        VM;
        PrilepBMP(280,39,EMBP[7]);
        Citaj(282,40,3,s);
        Val(s,Mierka,Err);
        ZmenaPismena;
        ZobrazPismeno;
        ZM;
      end;
      9:begin                     {kreslenie bodu}
        i:=(MysX-Aktiv[9,1]) div Mierka;
        j:=(MysY-Aktiv[9,2]) div Mierka;
        Color:=Farba;
        VyplnPlochu(Aktiv[9,1]+i*Mierka,Aktiv[9,2]+j*Mierka,Mierka,Mierka);
        Pismeno[i+PismSirka*j]:=Farba;
      end;
      9+256:begin                 {zmazanie bodu}
        i:=(MysX-Aktiv[9,1]) div Mierka;
        j:=(MysY-Aktiv[9,2]) div Mierka;
        Color:=0;
        VyplnPlochu(Aktiv[9,1]+i*Mierka,Aktiv[9,2]+j*Mierka,Mierka,Mierka);
        Pismeno[i+PismSirka*j]:=0;
      end;
      10:begin                    {paleta}
        Farba:=(MysX-1) div 10;
        Color:=Farba;
        VyplnPlochu(62,29,99,14);
      end;
    end;
    if (Udalost>0) and (Udalost<9) then CakajNaPustenie;
  until Udalost=7;
{ ----- koniec, vycisti po sebe ----- }
  if ppom<>nil then begin
    FreeMem(ppom,8);
    ppom:=nil;
  end;
  if Subor=NazovFNTSub[AktMSF] then begin
    PismenoNaFont;
    FreeMem(MSFP[AktMSF],DlzkaFNTSub[AktMSF]+512);
    MSFP[AktMSF]:=Font;
    DlzkaFNTSub[AktMSF]:=DlzkaFontu-512;
  end else FreeMem(Font,DlzkaFontu);
  Udalost:=44;{je to globalna premenna, nech MGP vie, ze bol v editore fontov}
END;
