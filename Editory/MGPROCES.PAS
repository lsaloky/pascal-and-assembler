program Editor_MGP;{MukoSoft graficky proces}
uses MainGr,PomGr,Mys,BMPUtil,Crt;
{Retazce v procedure Vypis maju 40 znakov}
const StandardFont:string[12]='Hlavny8.MSF';
      StandardBMP:string[12]='MGP12.MB';
      PocetOP=12;InfoY=124;
      MaxByteNaProces=2000;
      MaxProcesov=30;          {procesy zaberaju 30*(2000+2) bajtov }
      MaxFontov=10;
      MaxBitmap=255;
      MaxPaliet=10;            {palety zaberaju najviac 7680 bajtov}
      DlzElem:array[1..12] of byte=(8,8,1,6,10,11,0,0,6,10,0,6);{retazcove udalosti nastav dlzky na 0}
      HM:array[1..6] of string[7]=(                       {hlavne menu}
    'MGP','PROCES','ELEMENT','BITMAPA','FONT','PALETA');
      DM:array[1..6,1..6] of string[9]=(                  {dynamicke menu}
    ('Nahraj','Nov`y','Ulo~z','Koniec','',''),            {MGP}
    ('Pridaj','Odstr`a~n','<','>','Zobraz',''),           {Proces}
    ('Nastav','Odstr`a~n','<','>','<<<','>>>'),           {Element}
    ('Nahraj','','<','>','<<<','>>>'),                    {Bitmapa}
    ('Nahraj','','<','>','',''),                          {Font}
    ('Nahraj','Odstr`a~n','<','>','Nastav',''));          {Paleta}
      MHelp:array[7..48] of string[40]=(                  {help pre hlavne aj dynamicke menu}
    'MukoSoft grafick`y procesor','Na~c`itanie MGP z disku','Vytvorenie nov`eho MGP',
    'Ulo~zenie MGP','Koniec programu','','','Obrazovka vytvoren`a MGP-~ckom',
    'Pridanie procesu','Odstr`anenie procesu','Predo~sl`y proces','Nasleduj`uci proces',
    'Uk`a~z v`ysledn`u podobu procesu','','Obrazov`y prvok procesu','Nastav atrib`uty elementu',
    'Odstr`a~n aktu`alny element','Predo~sl`y element','Nasleduj`uci element',
    'O 10 nasp|a~t','O 10 ~dalej','Obr`azky pou~z`ivan`e ako elementy',
    'Nahraj z disku .MB s`ubor','','Predo~sl`a bitmapa',
    'Nasleduj`uca bitmapa','O 10 nasp|a~t','O 10 ~dalej','P`isma pou~z`ivan`e ako elementy',
    'Nahraj z disku .MSF s`ubor','','Predo~sl`y font',
    '~Dal~s`i font','','','Palety pou~z`ivan`e ako elementy','Nahraj z disku .MP s`ubor',
    'Odstr`a~n nepou~z`ivan`u paletu','Predo~sl`a paleta','Nasleduj`uca paleta',
    'Nastav aktu`alnu paletu v editore','');
      ElAktiv:array[1..PocetOP,1..4] of word=(            {LEN pre graficke prikazy v ELEMENT}
    (130,0,170,10),   {CiaraVodorovna}   (310,0,320,40),  {CiaraZvisla}
    (170,0,190,20),   {paleta}           (190,0,200,10),  {PolozBod}
    (200,0,245,30),   {VyplnPlochu}      (245,0,290,30),  {Ramcek}
    (130,10,160,25),  {Vypis}            (130,25,160,40), {VypisPO}
    (130,40,170,70),  {PrilepBMP}        (200,30,245,60), {Obdlznik}
    (245,30,290,60),  {Tlacidlo3D}       (130,70,170,100));{PrilepBMPPO}
      ElHelp:array[1..PocetOP] of string[40]=(
    'Vodorovn`a ~ciara.','Zvisl`a ~ciara.','Nastavenie palety.',
    'Kreslenie bodu.','Vyplnenie obd`l~znikovej plochy','R`am~cek.',
    'V`ypis textu.','V`ypis textu prieh~ladne a s diakritikou.',
    'Prilepenie bitmapy.','Obd`l~znik nevyplnen`y.','Tla~cidlo s 3D efektom.',
    'Prilepenie bitmapy prieh~ladne.');
      Fajocka:array[1..68] of byte=(8 ,0 ,8 ,0 ,          {bitmapa fajocky}
                                    0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,
                                    0 ,0 ,0 ,0 ,0 ,0 ,0 ,14,
                                    0 ,0 ,0 ,0 ,0 ,0 ,14,14,
                                    0 ,0 ,0 ,0 ,0 ,14,14,0 ,
                                    14,0 ,0 ,0 ,14,14,0 ,0 ,
                                    14,14,0 ,14,14,0 ,0 ,0 ,
                                    0 ,14,14,14,0 ,0 ,0 ,0 ,
                                    0 ,0 ,14,0 ,0 ,0 ,0 ,0 );
type TProces=record
       Dlzka:word;
       q:array[1..MaxByteNaProces] of byte;
     end;
     TBMP=record
       RozX,RozY:word;
       BMP:array[0..39999] of byte;
     end;
     TFNT=record
       OfsTab:array[0..255] of word;
       Verzia,Vyska,PPismen,Posun,PMedzier,SMedzer:byte;
       Rezerva:array[1..10] of byte;
       FOnt:array[1..40000] of byte;
     end;
var f,fpom:file;
    fp,pp,poz,pozm,Podkl:pointer;           {font,paleta,pozadia,podklad}
    Proces:array[1..MaxProcesov] of ^TProces;
    AEl,PEl:array[1..MaxProcesov] of integer;     {aktualne elementy a pocet elementov jednotlivych procesov - od 0}
    BMP:array[0..MaxBitmap] of ^TBMP;
    Pisma:array[0..MaxFontov] of ^TFNT;
    Palety:array[0..MaxPaliet] of pointer;
    Hlavicka:array[1..16] of byte;
    UHM,UDM,Udalost,UStara:integer;               {udalosti}
    PosX,PosY,DlzkaX,DlzkaY,SPosX,SPosY:integer;  {pre MGP}
    PocetBMP,AktBMP,PocetFNT,AktFNT,PocetPal,AktPal:integer;{bitmapy,fonty,palety}
    NazovBMPSub:array[0..MaxBitmap] of string[12];
    CisloBMPSub:array[0..MaxBitmap] of integer;
    NazovFNTSub:array[0..MaxFontov] of string[12];
    i,j,x,y,Err:integer;                          {pomocne}
    pomSeg,pomOfs:word;
    PPr,APr:integer;                              {pocet procesov, aktualny proces}
    Tlacidla,Color1,Color2,PomB:byte;
    ch:char;
    Nazov,s,s2,PomNazov:string;
    Nastavovanie:boolean;
function Ukaz:word;
var Pozicia,pom:word;
    pom2:byte;
begin
  Pozicia:=0;
  if AEl[APr]>0 then
    for pom:=1 to AEl[APr] do begin
      Pom2:=Proces[APr]^.q[Pozicia+1];
      Pozicia:=Pozicia+DlzElem[Pom2];
      case Pom2 of
        7,8:Pozicia:=Pozicia+Proces[APr]^.q[Pozicia+8]+8;
        11:Pozicia:=Pozicia+Proces[APr]^.q[Pozicia+14]+14;
      end;
    end;
  Ukaz:=Pozicia+1;
end;
function StrB(b:byte):string;
var s:string;
begin
  Str(b,s);
  StrB:=s;
end;
function StrI(i:integer):string;
var s:string;
begin
  Str(i,s);
  StrI:=s;
end;
procedure VypisInfo;
begin
  CakajNaVOI;
  Color:=169;
  Ramcek(0,115,320,74,3);
  Ramcek(140,109,40,14,3);
  VypisPO(147,112,fp,'Info',Oranzova);
  case Udalost of
    7:if Nazov<>'' then begin
      VypisPO(4,InfoY,fp,'Edituje~s s`ubor       '+Nazov,Oranzova);
      VypisPO(4,InfoY+10,fp,'D`l~zka s`uboru MGP:    '+StrI(FileSize(f)),Oranzova);
      VypisPO(4,InfoY+20,fp,'Po~cet procesov:       '+StrB(PPr),Oranzova);
      VypisPO(4,InfoY+30,fp,'Po~cet bitm`ap:         '+StrI(PocetBMP),Oranzova);
      VypisPO(4,InfoY+40,fp,'Po~cet fontov:         '+StrI(PocetFNT),Oranzova);
    end;
    8:if Nazov<>'' then begin
      VypisPO(4,InfoY,fp,'Bol nahrat`y s`ubor    '+Nazov,Oranzova);
      VypisPO(4,InfoY+10,fp,'D`l~zka s`uboru MGP:    '+StrI(FileSize(f)),Oranzova);
      VypisPO(4,InfoY+20,fp,'Po~cet procesov:       '+StrB(PPr),Oranzova);
      VypisPO(4,InfoY+30,fp,'Po~cet bitm`ap:         '+StrI(PocetBMP),Oranzova);
      VypisPO(4,InfoY+40,fp,'Po~cet fontov:         '+StrI(PocetFNT),Oranzova);
    end else VypisPO(4,InfoY,fp,'V editore sa nenach`adza ~ziaden s`ubor',Oranzova);
    9:VypisPO(4,InfoY,fp,'Bol vytvoren`y pr`azdny nepomenovan`y MGP s`ubor.',Oranzova);
    10:if Nazov<>'' then VypisPO(4,InfoY,fp,'Bol ulo~zen`y s`ubor '+Nazov,Oranzova);
    14..20:begin
      VypisPO(4,InfoY,fp,'Po~cet procesov: '+StrI(PPr),Oranzova);
      VypisPO(4,InfoY+10,fp,'Aktu`alny proces: '+StrI(APr),Oranzova);
      VypisPO(4,InfoY+20,fp,'Po~cet elementov aktu`alneho procesu: '+StrI(PEl[APr]),Oranzova);
      VypisPO(4,InfoY+30,fp,'D`l~zka aktu`alneho procesu: '+StrI(Proces[APr]^.Dlzka),Oranzova);
    end;
    28..34:begin
      VypisPO(4,InfoY,fp,'Po~cet bitm`ap: '+StrI(PocetBMP),Oranzova);
      if PocetBMP>0 then begin
        VypisPO(4,InfoY+10,fp,'Aktu`alna bitmapa: '+StrI(AktBMP),Oranzova);
        VypisPO(4,InfoY+20,fp,'Je to '+StrI(CisloBMPSub[AktBMP])+'. bitmapa',Oranzova);
        VypisPO(4,InfoY+30,fp,'zo s`uboru '+NazovBMPSub[AktBMP],Oranzova);
        PrilepBMPPO(204,InfoY,BMP[AktBMP]);
      end;
    end;
    35..41:begin
      VypisPO(4,InfoY,fp,'Po~cet fontov: '+StrI(PocetFNT),Oranzova);
      if PocetFNT>0 then begin
        VypisPO(4,InfoY+10,fp,'Aktu`alne p`ismo: '+StrI(AktFNT),Oranzova);
        VypisPO(4,InfoY+20,fp,'Je zo s`uboru '+NazovFNTSub[AktBMP],Oranzova);
        VypisPO(4,InfoY+34,Pisma[AktFNT],'ABC abc 012 -:) !*? ~c^o`i',SvetloModra);
      end;
    end;
    42..48:begin
      VypisPO(4,InfoY,fp,'Zatia~l pr`aca s paletou nie je naprogramovan`a.',Oranzova);
      VypisPO(4,InfoY+10,fp,'(a vo verzii 1 asi ani nebude)',Oranzova);
    end;
    21..27,100..200:if PEl[Apr]>0 then begin
      i:=Ukaz;
      PomB:=Proces[APr]^.q[i];
      VypisPO(4,InfoY,fp,'Aktu`alny element m`a ~c`islo '+StrI(AEl[APr]),Oranzova);
      with Proces[APr]^ do begin
        case PomB of
          1:begin
            VypisPO(4,InfoY+10,fp,'Akcia: Vodorovn`a ~ciara',Oranzova);
            VypisPO(4,InfoY+20,fp,'Poz`icia: '+StrI(q[i+1])+' '+StrI(q[i+3]),Oranzova);
            VypisPO(4,InfoY+30,fp,'D`l~zka: '+StrI(q[i+5]),Oranzova);
            VypisPO(4,InfoY+40,fp,'Farba: '+StrB(q[i+7]),Oranzova);
          end;
          2:begin
            VypisPO(4,InfoY+10,fp,'Akcia: Zvisl`a ~ciara',Oranzova);
            VypisPO(4,InfoY+20,fp,'Poz`icia: '+StrI(q[i+1])+' '+StrI(q[i+3]),Oranzova);
            VypisPO(4,InfoY+30,fp,'D`l~zka: '+StrI(q[i+5]),Oranzova);
            VypisPO(4,InfoY+40,fp,'Farba: '+StrB(q[i+7]),Oranzova);
          end;
          4:begin
            VypisPO(4,InfoY+10,fp,'Akcia: Bod',Oranzova);
            VypisPO(4,InfoY+20,fp,'Poz`icia: '+StrI(q[i+1])+' '+StrI(q[i+3]),Oranzova);
            VypisPO(4,InfoY+30,fp,'Farba: '+StrB(q[i+5]),Oranzova);
          end;
          5:begin
            VypisPO(4,InfoY+10,fp,'Akcia: Vyplnenie plochy',Oranzova);
            VypisPO(4,InfoY+20,fp,'Poz`icia: '+StrI(q[i+1])+' '+StrI(q[i+3]),Oranzova);
            VypisPO(4,InfoY+30,fp,'Rozmery: '+StrI(q[i+5])+' '+StrI(q[i+7]),Oranzova);
            VypisPO(4,InfoY+40,fp,'Farba: '+StrB(q[i+9]),Oranzova);
          end;
          6:begin
            VypisPO(4,InfoY+10,fp,'Akcia: R`am~cek',Oranzova);
            VypisPO(4,InfoY+20,fp,'Poz`icia: '+StrI(q[i+1])+' '+StrI(q[i+3]),Oranzova);
            VypisPO(4,InfoY+30,fp,'Rozmery: '+StrI(q[i+5])+' '+StrI(q[i+7]),Oranzova);
            VypisPO(4,InfoY+40,fp,'Farba vn`utra: '+StrB(q[i+9]),Oranzova);
            VypisPO(4,InfoY+50,fp,'Farba obruby: '+StrB(q[i+10]),Oranzova);
          end;
          7:begin
            VypisPO(4,InfoY+10,fp,'Akcia: V`ypis textu',Oranzova);
            VypisPO(4,InfoY+20,fp,'Poz`icia: '+StrI(q[i+1])+' '+StrI(q[i+3]),Oranzova);
            VypisPO(4,InfoY+30,fp,'~C`islo fontu: '+StrB(q[i+5]),Oranzova);
            Move(q[i+7],s,41);
            VypisPO(4,InfoY+40,fp,'Odtie~n textu: '+StrB(q[i+6]),Oranzova);
            VypisPO(4,InfoY+50,fp,'Text: '+s,Oranzova);
          end;
          8:begin
            VypisPO(4,InfoY+10,fp,'Akcia: V`ypis textu prieh~ladne',Oranzova);
            VypisPO(4,InfoY+20,fp,'Poz`icia: '+StrI(q[i+1])+' '+StrI(q[i+3]),Oranzova);
            VypisPO(4,InfoY+30,fp,'~C`islo fontu: '+StrB(q[i+5]),Oranzova);
            Move(q[i+7],s,41);
            VypisPO(4,InfoY+40,fp,'Odtien textu: '+StrB(q[i+6]),Oranzova);
            VypisPO(4,InfoY+50,fp,'Text: '+s,Oranzova);
          end;
          9:begin
            VypisPO(4,InfoY+10,fp,'Bitmapa ~c`islo '+StrB(q[i+5]),Oranzova);
            VypisPO(4,InfoY+20,fp,'Poz`icia: '+StrI(q[i+1])+' '+StrI(q[i+3]),Oranzova);
            with BMP[q[i+5]]^ do VypisPO(4,InfoY+30,fp,'Rozmery: '+StrI(RozX)+' '+StrI(RozY),Oranzova);
          end;
          10:begin
            VypisPO(4,InfoY+10,fp,'Akcia: Obd`l~znik',Oranzova);
            VypisPO(4,InfoY+20,fp,'Poz`icia: '+StrI(q[i+1])+' '+StrI(q[i+3]),Oranzova);
            VypisPO(4,InfoY+30,fp,'Rozmery: '+StrI(q[i+5])+' '+StrI(q[i+7]),Oranzova);
            VypisPO(4,InfoY+40,fp,'Farba: '+StrB(q[i+9]),Oranzova);
          end;
          11:begin
            VypisPO(4,InfoY+10,fp,'Akcia: Tla~cidlo s 3D efektom',Oranzova);
            VypisPO(4,InfoY+20,fp,'Poz`icia: '+StrI(q[i+1])+' '+StrI(q[i+3]),Oranzova);
            VypisPO(4,InfoY+30,fp,'Rozmery: '+StrI(q[i+5])+' '+StrI(q[i+7]),Oranzova);
            Move(q[i+13],s,41);
            VypisPO(4,InfoY+40,fp,'Odtie~n textu a tla~cidla: '+StrB(q[i+11])+' '+StrB(q[i+10]),Oranzova);
            VypisPO(4,InfoY+50,fp,'Nadpis fontom '+StrB(q[i+9])+' : '+s,Oranzova);
          end;
          12:begin
            VypisPO(4,InfoY+10,fp,'Prieh~ladn`a bitmapa ~c`islo '+StrB(q[i+5]),Oranzova);
            VypisPO(4,InfoY+20,fp,'Poz`icia: '+StrI(q[i+1])+' '+StrI(q[i+3]),Oranzova);
            with BMP[q[i+5]]^ do VypisPO(4,InfoY+30,fp,'Rozmery: '+StrI(RozX)+' '+StrI(RozY),Oranzova);
          end;
        end;
      end;
    end else VypisPO(4,InfoY,fp,'Elementy nie s`u ~ziadne.',Oranzova);
  end;
end;
procedure VypisDynamickeMenu;
var i:integer;
begin
  Color:=0;
  VyplnPlochu(0,0,9,75);
  VyplnPlochu(70,0,56,108);
  PrilepBMP(0,6+12*(UHM-1),@Fajocka);
  for i:=0 to 5 do
    if DM[UHM,i+1]<>'' then
      Tlacidlo3D(70,2+18*i,56,16,fp,DM[UHM,i+1],Hneda,Modra,False);
end;
Procedure VykresliElementy;
begin
  VypinajMys:=False;
  VM;
  Color:=15;
  CiaraVodorovna(135,5,30);
  CiaraZvisla(315,5,30);
  for i:=0 to 15 do
    for j:=0 to 15 do
      PolozBod(172+i,j+2,j*16+i);
  PolozBod(195,5,15);
  VyplnPlochu(205,5,35,20);
  Ramcek(250,5,35,20,3);
  Vypis(134,12,fp,'ABC',Oranzova);
  VypisPO(134,27,fp,'~c^o`i',Oranzova);
  PrilepBMP(135,45,poz);
  PrilepBMP(135,75,poz);
  PrilepBMPPO(140,80,pozm);
  Obdlznik(205,35,35,20);
  Tlacidlo3D(250,35,35,20,fp,'',SvetloModra,SvetloModra,False);
  VypinajMys:=True;
  ZM;
end;  { VykresliElementy }

procedure InicializujObrazovkuEditora;
begin
  ZmazObrazovku;
  NastavPaletu(pp);
  for i:=0 to 5 do Vypis(10,6+12*i,fp,HM[i+1],Zlta);
  VypisDynamickeMenu;
  VypisInfo;
  ZM;
end;
Procedure InicializujObrazovkuMGP;
begin
  VM;
  ZmazObrazovku;
  VykresliMGP(Proces[APr],@BMP,@Pisma);
  PosX:=0;PosY:=0;
  SPosX:=PosX;SPosY:=PosY;
  NastavKurzor(0,0);
  StiahniBMP(PosX,PosY,DlzkaX,DlzkaY,Podkl);
end;  { InicializujObrazovkuMGP }
Procedure PrilepElement;
begin
  repeat
    ZistiPoziciu(word(x),word(y),Tlacidla);
    x:=x div 2;
    if KeyPressed then ch:=ReadKey;
    case ch of
      '6':Inc(DlzkaX);
      '4':if DlzkaX>0 then Dec(DlzkaX);
      '2':Inc(DlzkaY);
      '8':if DlzkaY>0 then Dec(DlzkaY);
      '.':if Color<255 then Inc(Color);
      ',':if Color>0 then Dec(Color);
      '>':if Color2<255 then Inc(Color2);
      '<':if Color2>0 then Dec(Color2);
      '+':if Color1<15 then Inc(Color1);
      '-':if Color1>0 then Dec(Color1);
    end;
    if (X<>SPosX) or (Y<>SPosY) or (ch in ['2','4','6','8','.',',','<','>','+','-']) then begin
      ch:=' ';
      CakajNaVOI;
      PrilepBMP(SPosX,SPosY,Podkl);
      StiahniBMP(X,Y,DlzkaX,DlzkaY,Podkl);
      case Udalost of
        101:CiaraVodorovna(x,y,DlzkaX);
        102:CiaraZvisla(x,y,DlzkaY);
        104:PolozBod(x,y,Color);
        105:VyplnPlochu(x,y,DlzkaX,DlzkaY);
        106:Ramcek(x,y,DlzkaX,DlzkaY,Color2);
        107:Vypis(x,y+1,Pisma[AktFNT],s,Color1);
        108:VypisPO(x,y+1,Pisma[AktFNT],s,Color1);
        109:PrilepBMP(x,y,BMP[AktBMP]);
        110:Obdlznik(x,y,DlzkaX,DlzkaY);
        111:Tlacidlo3D(x,y,DlzkaX,DlzkaY,Pisma[AktFNT],s,Color2,Color1,False);
        112:PrilepBMPPO(x,y,BMP[AktBMP]);
      end;
      SPosX:=x;SPosY:=y;
    end;
  until Tlacidla>0;
  pomSeg:=Seg(Proces[APr]^);
  pomOfs:=Ofs(Proces[APr]^)+1+Ukaz;
  Mem[PomSeg:PomOfs]:=Udalost-100;
  case Udalost of
    101:begin
      MemW[PomSeg:PomOfs+1]:=x;
      MemW[PomSeg:PomOfs+3]:=y;
      MemW[PomSeg:PomOfs+5]:=DlzkaX;
      Mem[PomSeg:PomOfs+7]:=Color;
    end;
    102:begin
      MemW[PomSeg:PomOfs+1]:=x;
      MemW[PomSeg:PomOfs+3]:=y;
      MemW[PomSeg:PomOfs+5]:=DlzkaY;
      Mem[PomSeg:PomOfs+7]:=Color;
    end;
    104:begin
      MemW[PomSeg:PomOfs+1]:=x;
      MemW[PomSeg:PomOfs+3]:=y;
      Mem[PomSeg:PomOfs+5]:=Color;
    end;
    105:begin
      MemW[PomSeg:PomOfs+1]:=x;
      MemW[PomSeg:PomOfs+3]:=y;
      MemW[PomSeg:PomOfs+5]:=DlzkaX;
      MemW[PomSeg:PomOfs+7]:=DlzkaY;
      Mem[PomSeg:PomOfs+9]:=Color;
    end;
    106:begin
      MemW[PomSeg:PomOfs+1]:=x;
      MemW[PomSeg:PomOfs+3]:=y;
      MemW[PomSeg:PomOfs+5]:=DlzkaX;
      MemW[PomSeg:PomOfs+7]:=DlzkaY;
      Mem[PomSeg:PomOfs+9]:=Color2;
      Mem[PomSeg:PomOfs+10]:=Color;
    end;
    107,108:begin
      MemW[PomSeg:PomOfs+1]:=x;
      MemW[PomSeg:PomOfs+3]:=y;
      Mem[PomSeg:PomOfs+5]:=AktFNT;
      Mem[PomSeg:PomOfs+6]:=Color1;
      Move(s,Mem[PomSeg:PomOfs+7],41);
      Proces[APr]^.Dlzka:=Proces[APr]^.Dlzka+Length(s)+8;
    end;
    109,112:begin
      MemW[PomSeg:PomOfs+1]:=x;
      MemW[PomSeg:PomOfs+3]:=y;
      Mem[PomSeg:PomOfs+5]:=AktBMP;
    end;
    110:begin
      MemW[PomSeg:PomOfs+1]:=x;
      MemW[PomSeg:PomOfs+3]:=y;
      MemW[PomSeg:PomOfs+5]:=DlzkaX;
      MemW[PomSeg:PomOfs+7]:=DlzkaY;
      Mem[PomSeg:PomOfs+9]:=Color;
    end;
    111:begin
      MemW[PomSeg:PomOfs+1]:=x;
      MemW[PomSeg:PomOfs+3]:=y;
      MemW[PomSeg:PomOfs+5]:=DlzkaX;
      MemW[PomSeg:PomOfs+7]:=DlzkaY;
      Mem[PomSeg:PomOfs+9]:=AktFNT;
      Mem[PomSeg:PomOfs+10]:=Color2;
      Mem[PomSeg:PomOfs+11]:=Color1;
      Mem[PomSeg:PomOfs+12]:=0;
      Move(s,Mem[PomSeg:PomOfs+13],41);
      Proces[APr]^.Dlzka:=Proces[APr]^.Dlzka+Length(s)+14;
    end;
  end;
  if not Nastavovanie then begin
    Proces[APr]^.Dlzka:=Proces[APr]^.Dlzka+DlzElem[Udalost-100];
    Inc(PEl[APr]);
  end;
end;  { PrilepElement }BEGIN
{ ----- inicializacia ----- }
  if StandardFont<>'' then begin
    NacitajFont(StandardFont,pointer(Pisma[0]));
    NazovFNTSub[0]:=StandardFont;
    PocetFNT:=1;
{    NacitajFont('d:\lubo\pascal\units\Hlavny11.MSF',pointer(Pisma[1]));
    NazovFNTSub[1]:='Hlavny11.MSF';
    PocetFNT:=2;    }
  end;
  if StandardBMP<>'' then begin
    Assign(fpom,StandardBMP);
    Reset(fpom,1);
    Seek(fpom,768);
    BlockRead(fpom,PomB,1);
    for i:=1 to PomB do begin
      NacitajBMP(fpom,pointer(BMP[i-1]));
      NazovBMPSub[i-1]:=StandardBMP;
      CisloBMPSub[i-1]:=i;
    end;
    PocetBMP:=PomB;
    Close(fpom);
  end;
  NacitajFont('Hlavny8.Msf',fp);
  NacitajPaletu('Prechody.Mp',pp);
  NahodnaBMP(30,20,Zelena,poz);
  PriemerujBMP(Poz);
  NahodnaBMP(20,10,Cierna,pozm);
  PriemerujBMP(Pozm);
  UpravJasBMP(Pozm,1,6);
  UHM:=1;         {Udalost v hlavnom menu - MGP}
  PPr:=1;APr:=1;  {aktualny proces}
  Nastavovanie:=False;
  AttrCitaj.Font:=fp;
  InicializujGrafiku;
  InicializujObrazovkuEditora;
  FillChar(Hlavicka,SizeOf(Hlavicka),#0);
  Hlavicka[1]:=1;   {verzia MGP}
  for i:=1 to MaxProcesov do GetMem(Proces[i],MaxByteNaProces);
  for i:=1 to MaxProcesov do Proces[i]^.Dlzka:=0;
  GetMem(Podkl,64000);
  VypinajMys:=True;
  repeat
{ ----- cakanie na udalost ----- }
    UStara:=0;
    repeat
      ZistiPoziciu(word(x),word(y),Tlacidla);
      x:=x div 2;
      if (x>70) and (x<126) and (y>2) and (y<107) then UDM:=(y-2) div 18+1;
      Udalost:=UHM*7+UDM;
      if (x<70) and (y<74) and (y>3) then Udalost:=((y-3) div 12+1)*7;
      if not ((x<126) and (y<107)) then Udalost:=0;
      if UHM=3 then for i:=1 to PocetOP do
        if (x>ElAktiv[i,1]) and (y>ElAktiv[i,2]) and (x<ElAktiv[i,3]) and (y<ElAktiv[i,4])
        then Udalost:=i+100;
      if Udalost<>UStara then begin
        Color:=0;
        VyplnPlochu(0,191,320,9);
        If (Udalost>0) and (Udalost<100) then VypisPO(0,192,fp,MHelp[Udalost],SvetloModra);
        if Udalost>100 then VypisPO(0,192,fp,ElHelp[Udalost-100],SvetloModra);
        UStara:=Udalost;
      end;
    until (Tlacidla>0) or (KeyPressed);
    if (x<70) and (y<74) and (y>3) then begin{kliknute na hlavne menu}
      UHM:=(y-3) div 12+1;
      UDM:=0;
      Udalost:=UHM*7;
      VypisInfo;
    end;
    if UDM=0 then VypisDynamickeMenu;{prepnutie inej polozky v hlavnom menu}
    {tlacidlo po kliknuti}
    if (UDM>0) and (Udalost<100) then Tlacidlo3D(70,2+18*(UDM-1),56,16,fp,DM[UHM,UDM],Hneda,Modra,True);
    if UHM=3 then VykresliElementy  {menu Element - ikonky}
    else begin                      {inak to tam vycisti}
      Color:=0;
      VyplnPlochu(130,0,190,108);
    end;
{ ----- spracovanie udalosti ----- }
    if Udalost>100 then AEl[APr]:=PEl[APr];
    ch:=#0;
    while KeyPressed do ch:=ReadKey;
    if ch=' ' then Udalost:=19;            {Proces,Zobraz}
    case Udalost of
      8:begin
        SuboroveOkno(fp,'Nahratie .MGP s`uboru:','*.MGP',Nazov);
        Color:=0;VyplnPlochu(0,191,320,9);
        if Nazov<>'' then begin
          Assign(f,Nazov);
          Reset(f,1);
          BlockRead(f,Hlavicka,16);
          PPr:=Hlavicka[2];
          if PPr>0 then
            for i:=1 to PPr do begin
              with Proces[i]^ do begin
                BlockRead(f,Dlzka,2);
                if Dlzka>0 then BlockRead(f,q,Dlzka);
                AEl[i]:=0;PEl[i]:=0;
                j:=1;
                while j<Dlzka do begin
                  Inc(PEl[i]);
                  case q[j] of
                    7,8:j:=j+q[j+7]+8;
                    11:j:=j+q[j+13]+14;
                    else j:=j+DlzElem[q[j]];
                  end; {case}
                end; {while}
              end; {with}
            end; {for}
        end; {if, 2. if bez end}
      end; {case 1,1 - MGP,Nahraj }
      9:begin
        PPr:=1;
        for i:=1 to MaxProcesov do begin
          Proces[i]^.Dlzka:=0;
          AEl[i]:=0;
          PEl[i]:=0;
        end;
        PocetFNT:=0;
        PocetBMP:=0;
      end; {case 1,2 - MGP,Novy }
      10:begin
        SuboroveOkno(fp,'Ulo~zenie .MGP s`uboru','*.MGP',Nazov);
        Color:=0;VyplnPlochu(0,191,320,9);
        if Nazov<>'' then begin
          Assign(f,Nazov);
          ReWrite(f,1);
          Hlavicka[2]:=PPr;
          BlockWrite(f,Hlavicka,16);
          if PPr>0 then
            for i:=1 to PPr do BlockWrite(f,Proces[i]^,Proces[i]^.Dlzka+2);
        end;
      end; {case 1,3 - MGP,Uloz }
      15:Inc(PPr);{case 2,1 - Proces,Pridaj }
      16:begin
        if Apr<PPr then
          for i:=APr to PPr-1 do Move(Proces[i+1]^,Proces[i]^,MaxByteNaProces+2)
        else Dec(APr);
        Dec(PPr);
      end; {case 2,2 - Proces, Odstran }
      17:if APr>1 then Dec(APr); {case 2,3 - Proces,Predosly }
      18:if APr<PPr then Inc(APr); {case 2,4 - Proces,Dalsi }
      19:begin
        VM;
        if KeyPressed then ch:=Readkey;
        ZmazObrazovku;
        VykresliMGP(Proces[APr],@BMP,@Pisma);
        CakajNaPustenie;
        repeat ZistiPoziciu(word(x),word(y),Tlacidla); until (Tlacidla>0) or (KeyPressed);
        while KeyPressed do ch:=Readkey;
        InicializujObrazovkuEditora;
        ZM;
      end; {case 2,5 - Proces, Zobraz }
      22:begin
        CakajNaPustenie;
        pomSeg:=Seg(Proces[APr]^);
        pomOfs:=Ofs(Proces[APr]^)+1+Ukaz;
        i:=Ukaz;
{ ----- Element, Nastav ----- }
        case Proces[APr]^.q[i] of
          1:begin
            x:=MemW[PomSeg:PomOfs+1];
            y:=MemW[PomSeg:PomOfs+3];
            DlzkaX:=MemW[PomSeg:PomOfs+5];
            DlzkaY:=1;
            Color:=Mem[PomSeg:PomOfs+7];
          end;
          2:begin
            x:=MemW[PomSeg:PomOfs+1];
            y:=MemW[PomSeg:PomOfs+3];
            DlzkaY:=MemW[PomSeg:PomOfs+5];
            DlzkaX:=1;
            Color:=Mem[PomSeg:PomOfs+7];
          end;
          4:begin
            x:=MemW[PomSeg:PomOfs+1];
            y:=MemW[PomSeg:PomOfs+3];
            DlzkaX:=1;
            DlzkaY:=1;
            Color:=Mem[PomSeg:PomOfs+5];
          end;
          5:begin
            x:=MemW[PomSeg:PomOfs+1];
            y:=MemW[PomSeg:PomOfs+3];
            DlzkaX:=MemW[PomSeg:PomOfs+5];
            DlzkaY:=MemW[PomSeg:PomOfs+7];
            Color:=Mem[PomSeg:PomOfs+9];
          end;
          6:begin
            x:=MemW[PomSeg:PomOfs+1];
            y:=MemW[PomSeg:PomOfs+3];
            DlzkaX:=MemW[PomSeg:PomOfs+5];
            DlzkaY:=MemW[PomSeg:PomOfs+7];
            Color2:=Mem[PomSeg:PomOfs+9];
            Color:=Mem[PomSeg:PomOfs+10];
          end;
          7,8:begin
            x:=MemW[PomSeg:PomOfs+1];
            y:=MemW[PomSeg:PomOfs+3];
            AktFNT:=Mem[PomSeg:PomOfs+5];
            Color1:=Mem[PomSeg:PomOfs+6];
            Move(Mem[PomSeg:PomOfs+7],s,41);
            DlzkaX:=LengthPixel(Pisma[AktFNT],s)+1;
            DlzkaY:=Pisma[AktFNT]^.Vyska+1;
          end;
          9,12:begin
            x:=MemW[PomSeg:PomOfs+1];
            y:=MemW[PomSeg:PomOfs+3];
            AktBMP:=Mem[PomSeg:PomOfs+5];
            DlzkaX:=BMP[AktBMP]^.RozX;
            DlzkaY:=BMP[AktBMP]^.RozY;
          end;
          10:begin
            x:=MemW[PomSeg:PomOfs+1];
            y:=MemW[PomSeg:PomOfs+3];
            DlzkaX:=MemW[PomSeg:PomOfs+5];
            DlzkaY:=MemW[PomSeg:PomOfs+7];
            Color:=Mem[PomSeg:PomOfs+9];
          end;
          11:begin
            x:=MemW[PomSeg:PomOfs+1];
            y:=MemW[PomSeg:PomOfs+3];
            DlzkaX:=MemW[PomSeg:PomOfs+5];
            DlzkaY:=MemW[PomSeg:PomOfs+7];
            AktFNT:=Mem[PomSeg:PomOfs+9];
            Color2:=Mem[PomSeg:PomOfs+10];
            Color1:=Mem[PomSeg:PomOfs+11]; {na ofs. 12 je, ci je stlacene}
            Move(Mem[PomSeg:PomOfs+13],s,41);
          end;
        end;
        VM;{InicializujObrazovkuMGP}
        ZmazObrazovku;
        VykresliMGP(Proces[APr],@BMP,@Pisma);
        PosX:=x;PosY:=y;
        SPosX:=PosX;SPosY:=PosY;
        NastavKurzor(x*2,y);
        StiahniBMP(PosX,PosY,DlzkaX,DlzkaY,Podkl);
        Udalost:=Mem[PomSeg:PomOfs]+100;
        case Udalost of
          101:CiaraVodorovna(x,y,DlzkaX);
          102:CiaraZvisla(x,y,DlzkaY);
          104:PolozBod(x,y,Color);
          105:VyplnPlochu(x,y,DlzkaX,DlzkaY);
          106:Ramcek(x,y,DlzkaX,DlzkaY,Color2);
          107:Vypis(x,y+1,Pisma[AktFNT],s,Color1);
          108:VypisPO(x,y+1,Pisma[AktFNT],s,Color1);
          109:PrilepBMP(x,y,BMP[AktBMP]);
          110:Obdlznik(x,y,DlzkaX,DlzkaY);
          111:Tlacidlo3D(x,y,DlzkaX,DlzkaY,Pisma[AktFNT],s,Color2,Color1,False);
          112:PrilepBMPPO(x,y,BMP[AktBMP]);
        end;
        Nastavovanie:=True;
        PrilepElement;
        Nastavovanie:=False;
        ZM;
        Udalost:=22;
      end; {case 3,1 - Element, Nastav }
      23:begin
        i:=Proces[APr]^.q[Ukaz]; {i je prikaz, j je dlzka mazaneho prikazu}
        with Proces[APr]^ do
          case i of
            7,8:j:=q[Ukaz+7]+8;
            11:j:=q[Ukaz+13]+14;
            else j:=DlzElem[i];
          end; {case}
        if AEl[APr]<PEl[APr] then
          with Proces[APr]^ do begin
            Dec(Dlzka,j);
            Move(q[Ukaz+j],q[Ukaz],MaxByteNaProces-Ukaz-1);
          end else Dec(AEl[APr]);
        Dec(PEl[APr]);
      end; {case 3,2 - Element, Odstran}
      24:if AEl[APr]>0 then Dec(AEl[APr]); {case 3,3 - Element,Predosly }
      25:if AEl[APr]<PEl[APr]-1 then Inc(AEl[APr]); {case 3,4 - Element, Dalsi }
      26:if AEl[APr]>9 then Dec(AEl[APr],10); {case 3,5 - Element, o 10 naspat}
      27:if AEl[APr]<PEl[APr]-10 then Inc(AEl[APr],10); {case 3,6 - Element, o 10 dalej}
      29:begin
        SuboroveOkno(fp,'Nahratie .MB s`uboru:','*.MB',PomNazov);
        Assign(fpom,PomNazov);
        Reset(fpom,1);
        Seek(fpom,768);
        BlockRead(fpom,PomB,1);
        for i:=1 to PomB do begin
          NacitajBMP(fpom,pointer(BMP[PocetBMP+i-1]));
          NazovBMPSub[PocetBMP+i-1]:=PomNazov;
          CisloBMPSub[PocetBMP+i-1]:=i;
        end;
        PocetBMP:=PocetBMP+PomB;
        Close(fpom);
      end; {case 4,1 - Bitmapa, Nahraj}
      31:if AktBMP>0 then Dec(AktBMP); {case 4,3 - Bitmapa, Predosla}
      32:if AktBMP<PocetBMP-1 then Inc(AktBMP);{case 4,4 - Bitmapa,Dalsia}
      33:if AktBMP>9 then Dec(AktBMP,10);{case 4,5 - Bitmapa, o 10 naspat}
      34:if AktBMP<PocetBMP-10 then Inc(AktBMP,10);{case 4,6 - Bitmapa, o 10 dalej}
      36:begin
        SuboroveOkno(fp,'Nahratie .MSF s`uboru:','*.MSF',PomNazov);
        NacitajFont(PomNazov,pointer(Pisma[PocetFnt]));
        NazovFNTSub[PocetFNT]:=PomNazov;
        Inc(PocetFNT);
      end; {case 4,1 - Font, Nahraj}
      38:If AktFNT>0 then Dec(AktFNT);{case 4,3 - Font, Predosly}
      39:If AktFnt<PocetFNT-1 then Inc(AktFNT);{case 4,4 - Font,Dalsi}
      101:begin
        Color:=3;VyplnPlochu(1,InfoY-1,318,65);
        VypisPO(4,InfoY,fp,'D`l~zka ~ciary:',Hneda);
        Citaj(100,InfoY,6,s);
        Val(s,DlzkaX,Err);
        VypisPO(4,InfoY+10,fp,'Farba ~ciary:',Hneda);
        Citaj(100,InfoY+10,6,s);
        Val(s,Color1,Err);
        DlzkaY:=1;
        InicializujObrazovkuMGP;
        Color:=Color1;
        CiaraVodorovna(SPosX,SPosY,DlzkaX);
        PrilepElement;
      end; {case 3 - Element, Ciara Vodorovna}
      102:begin
        Color:=3;VyplnPlochu(1,InfoY-1,318,65);
        VypisPO(4,InfoY,fp,'D`l~zka ~ciary:',Hneda);
        Citaj(100,InfoY,6,s);
        Val(s,DlzkaY,Err);
        VypisPO(4,InfoY+10,fp,'Farba ~ciary:',Hneda);
        Citaj(100,InfoY+10,6,s);
        Val(s,Color1,Err);
        DlzkaX:=1;
        InicializujObrazovkuMGP;
        Color:=Color1;
        CiaraZvisla(SPosX,SPosY,DlzkaY);
        PrilepElement;
      end; {case 3 - Element, CiaraZvisla }
      104:begin
        Color:=3;VyplnPlochu(1,InfoY-1,318,65);
        VypisPO(4,InfoY,fp,'Farba bodu:',Hneda);
        Citaj(100,InfoY,6,s);
        Val(s,Color1,Err);
        DlzkaX:=1;DlzkaY:=1;
        InicializujObrazovkuMGP;
        Color:=Color1;
        PolozBod(SPosX,SPosY,Color);
        PrilepElement;
      end; {case 3 - Element, PolozBod }
      105:begin
        Color:=3;VyplnPlochu(1,InfoY-1,318,65);
        VypisPO(4,InfoY,fp,'~S`irka plochy:',Hneda);
        Citaj(100,InfoY,6,s);
        Val(s,DlzkaX,Err);
        VypisPO(4,InfoY+10,fp,'V`y~ska plochy:',Hneda);
        Citaj(100,InfoY+10,6,s);
        Val(s,DlzkaY,Err);
        VypisPO(4,InfoY+20,fp,'Farba plochy:',Hneda);
        Citaj(100,InfoY+20,6,s);
        Val(s,Color1,Err);
        InicializujObrazovkuMGP;
        Color:=Color1;
        VyplnPlochu(SPosX,SPosY,DlzkaX,DlzkaY);
        PrilepElement;
      end; {case 3 - Element, VyplnPlochu }
      106:begin
        Color:=3;VyplnPlochu(1,InfoY-1,318,65);
        VypisPO(4,InfoY,fp,'~S`irka r`am~ceka:',Hneda);
        Citaj(105,InfoY,6,s);
        Val(s,DlzkaX,Err);
        VypisPO(4,InfoY+10,fp,'V`y~ska r`am~ceka:',Hneda);
        Citaj(105,InfoY+10,6,s);
        Val(s,DlzkaY,Err);
        VypisPO(4,InfoY+20,fp,'Farba obruby r`am~ceka:',Hneda);
        Citaj(155,InfoY+20,6,s);
        Val(s,Color1,Err);
        VypisPO(4,InfoY+30,fp,'Farba vn`utra r`am~ceka:',Hneda);
        Citaj(155,InfoY+30,6,s);
        Val(s,Color2,Err);
        InicializujObrazovkuMGP;
        Color:=Color1;
        Ramcek(SPosX,SPosY,DlzkaX,DlzkaY,Color2);
        PrilepElement;
      end; {case 3 - Element, Ramcek}
      107:begin
        Color:=3;VyplnPlochu(1,InfoY-1,318,65);
        VypisPO(4,InfoY,fp,'Odtie~n textu:',Hneda);
        Citaj(100,InfoY,6,s);
        Val(s,Color1,Err);
        VypisPO(4,InfoY+10,fp,'Text:',Hneda);
        Citaj(4,InfoY+20,40,s);
        DlzkaX:=LengthPixel(Pisma[AktFNT],s)+1;
        DlzkaY:=Pisma[AktFNT]^.Vyska+1;
        InicializujObrazovkuMGP;
        Vypis(SPosX,SPosY,Pisma[AktFNT],s,Color1);
        PrilepElement;
      end; { case 3 - Element, Vypis }
      108:begin
        Color:=3;VyplnPlochu(1,InfoY-1,318,65);
        VypisPO(4,InfoY,fp,'Odtie~n textu:',Hneda);
        Citaj(100,InfoY,6,s);
        Val(s,Color1,Err);
        VypisPO(4,InfoY+10,fp,'Text:',Hneda);
        Citaj(4,InfoY+20,40,s);
        DlzkaX:=LengthPixel(Pisma[AktFNT],s)+1;
        DlzkaY:=Pisma[AktFNT]^.Vyska+1;
        InicializujObrazovkuMGP;
        VypisPO(SPosX,SPosY,Pisma[AktFNT],s,Color1);
        PrilepElement;
      end; { case 3 - Element, VypisPO }
      109:begin
        CakajNaPustenie;
        DlzkaX:=BMP[AktBMP]^.RozX;
        DlzkaY:=BMP[AktBMP]^.RozY;
        InicializujObrazovkuMGP;
        PrilepBMP(SPosX,SPosY,BMP[AktBMP]);
        PrilepElement;
      end; { case 3 - Element, PrilepBMP }
      110:begin
        Color:=3;VyplnPlochu(1,InfoY-1,318,65);
        VypisPO(4,InfoY,fp,'~S`irka obd`l~znika:',Hneda);
        Citaj(120,InfoY,6,s);
        Val(s,DlzkaX,Err);
        VypisPO(4,InfoY+10,fp,'V`y~ska obd`l~znika:',Hneda);
        Citaj(120,InfoY+10,6,s);
        Val(s,DlzkaY,Err);
        VypisPO(4,InfoY+20,fp,'Farba:',Hneda);
        Citaj(50,InfoY+20,6,s);
        Val(s,Color1,Err);
        InicializujObrazovkuMGP;
        Color:=Color1;
        Obdlznik(SPosX,SPosY,DlzkaX,DlzkaY);
        PrilepElement;
      end; { case 3 - Element, Obdlznik }
      111:begin
        Color:=3;VyplnPlochu(1,InfoY-1,318,65);
        VypisPO(4,InfoY,fp,'~S`irka tla~cidla:',Hneda);
        Citaj(150,InfoY,6,s);
        Val(s,DlzkaX,Err);
        VypisPO(4,InfoY+10,fp,'V`y~ska tla~cidla:',Hneda);
        Citaj(150,InfoY+10,6,s);
        Val(s,DlzkaY,Err);
        VypisPO(4,InfoY+20,fp,'Odtie~n textu (0-15):',Hneda);
        Citaj(150,InfoY+20,6,s);
        Val(s,Color1,Err);
        VypisPO(4,InfoY+30,fp,'Odtie~n tla~cidla (0-15):',Hneda);
        Citaj(150,InfoY+30,6,s);
        Val(s,Color2,Err);
        VypisPO(4,InfoY+40,fp,'Text:',Hneda);
        Citaj(4,InfoY+50,40,s);
        InicializujObrazovkuMGP;
        Tlacidlo3D(SPosX,SPosY,DlzkaX,DlzkaY,Pisma[AktFNT],s,Color2,Color1,False);
        PrilepElement;
      end; { case 3 - Element, Tlacidlo3D }
      112:begin
        CakajNaPustenie;
        DlzkaX:=BMP[AktBMP]^.RozX;
        DlzkaY:=BMP[AktBMP]^.RozY;
        InicializujObrazovkuMGP;
        PrilepBMPPO(SPosX,SPosY,BMP[AktBMP]);
        PrilepElement;
      end; { case 3 - Element, PrilepBMPPO }
    end; { case velky }
    if (Udalost>100) or (Udalost=22) then begin
      InicializujObrazovkuEditora;
      VykresliElementy;
    end;
    VypisInfo;
    CakajNaPustenie;
    VM;
    if UDM>0 then Tlacidlo3D(70,2+18*(UDM-1),56,16,fp,DM[UHM,UDM],Hneda,Modra,False);
    ZM;
  until Udalost=11;
{ ----- ukoncenie programu ----- }
  ZavriGrafiku;
{  FreeMem(Podkl,64000);
  FreeMem(pp,768);
  FreeMem(Poz,604);
  FreeMem(Pozm,204);
  for i:=1 to MaxProcesov do FreeMem(Proces[i],MaxByteNaProces);}
  if Nazov<>'' then Close(f);
  writeln('MukoSoft editor grafickych procesov'#13#10'Lubos Saloky, 1997');
END.