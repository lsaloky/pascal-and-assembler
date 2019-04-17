program TS_20;{Turingove stroje}
uses MainGr,Mys;
type TInstrukcia=record
                   StavStary,PismenoStare,PismenoNove,StavNovy:byte;
                   Smer:char;
                 end;
{ ----- konstanty integrovaneho vyvojoveho prostredia ----- }
const PocetMB=9;
      PocetMGP=1;
      Aktiv:array[0..12,1..4] of word=(
        (260,60,319,76),(260,80,319,96),(260,100,319,116),(260,120,319,136),
        (280,38,290,48),(260,140,319,156),(60,144,83,160),(89,148,109,160),
        (114,144,138,160),(253,8,269,32),(254,38,274,50),(274,8,290,32),
        (400,0,0,0));
      Klav:array[0..12] of char=('S',#0,'N','U','O','K','-',#0,'+',',',#0,'.',#255);
      Pomoc:array[0..12] of string[40]=(
        ' ','Spustenie Turingovho stroja','R^ozne nastavenia','Nahraj stroj',
        'Ulo~z stroj','Odstr`a~n in~strukciu','Koniec programu TS 2.0',
        'P`aska o 1 v~lavo','Zadaj nov`u poz`iciu p`asky','P`aska o 1 vpravo',
        'Predo~sl`a in~strukcia','Zadaj ~c`islo in~strukcie',
        'Nasleduj`uca in~strukcia');
{ ----- konstanty aplikacie ----- }
const Stlpce:array[1..5] of word=(25,65,100,155,210);
      MaxPaska=100;
      MaxInstrukcii=120;
{ ----- premenne integrovaneho vyvojoveho prostredia ----- }
var FP,PalP:pointer;
    MGPP:array[1..PocetMGP] of pointer;
    MBP:array[1..PocetMB] of pointer;
    Udalost:word;
{ ----- premenne pre aplikaciu ----- }
var Paska:array[-MaxPaska..MaxPaska] of byte;              {data}
    Stroj:array[1..MaxInstrukcii] of TInstrukcia;          {program}
    PocInstrukcia:integer;                                 {cislo instrukcie umiestmenej uplne hore}
    PocPismeno:integer;                                    {index pismena umiestneneho uplne vlavo}
    Hlavicka:record                                        {hlavicka suboru}
               Verzia:byte;
               PocetInstrukcii,ZacPasky,DlzkaPasky:word;
               Rezerva:array[1..9] of byte;
             end;
{ ----- pomocne premenne na volne pouzitie ----- }
var i,j:integer;
    s:string;
    f:file;

procedure ZobrazProgram;
begin
  VM;
  for i:=0 to 6 do begin
    Str(PocInstrukcia+i,s);
    Vypis(3,i*14+29,FP,s,SvetloModra);
    for j:=1 to 5 do
      PrilepBMP(Stlpce[j],i*14+28,MBP[7]);
  end;
  ZM;
end;
procedure ZobrazPasku;
begin
  VM;
  for i:=0 to 12 do begin
    Str(PocPismeno+i,s);
    Vypis(3+24*i,167,FP,s,SvetloModra);
    PrilepBMP(3+24*i,176,MBP[7]);
  end;
  ZM;
end;


{ ----- ----- ----- ----- ----- TU JE BEGIN ----- ----- ----- ----- ----- }


BEGIN
{ ----- inicializacia ----- }
  PocInstrukcia:=1;
  PocPismeno:=-6;
  NacitajPaletu('Prechody.MP',PalP);
  NacitajFont('Hlavny8.MSF',FP);
  Assign(f,'ts20.mb');
  Reset(f,1);
  Seek(f,769);
  for i:=1 to PocetMB do NacitajBMP(f,MBP[i]);
  Close(f);
  Assign(f,'ts20.mgp');
  Reset(f,1);
  Seek(f,16);
  for i:=1 to PocetMGP do NacitajMGP(f,MGPP[i]);
  Close(f);
  InicializujGrafiku;
  NastavPaletu(PalP);
  VykresliMGP(MGPP[1],@MBP,@FP);
  ZobrazProgram;
  ZobrazPasku;
  ZM;
{ ----- hlavny program ----- }
  repeat
    Udalost:=ObsluzUdalostSHelpom(@Aktiv,@Klav,FP,@Pomoc);
    VM;
    case Udalost of
      1:Tlacidlo3D(260,60,60,16,FP,'Spus~t',6,5,True);
      2:Tlacidlo3D(260,80,60,16,FP,'Nastav',10,3,True);
      3:Tlacidlo3D(260,100,60,16,FP,'Nahraj',10,3,True);
      4:Tlacidlo3D(260,120,60,16,FP,'Ulo~z',10,3,True);
      6:Tlacidlo3D(260,140,60,16,FP,'Koniec',10,3,True);
      7:begin
        Tlacidlo3D(61,144,24,16,FP,'',9,3,True);
        PrilepBMPP(67,148,MBP[4]);
      end;
      9:begin
        Tlacidlo3D(114,144,24,16,FP,'',9,3,True);
        PrilepBMPP(120,148,MBP[3]);
      end;
      10:begin
        Tlacidlo3D(253,8,16,24,FP,'',9,3,True);
        PrilepBMPP(257,14,MBP[6]);
      end;
      12:begin
        Tlacidlo3D(274,8,16,24,FP,'',9,3,True);
        PrilepBMPP(278,14,MBP[6]);
      end;
    end;
    ZM;
    for i:=1 to 5 do CakajNaVOI;
    CakajNaPustenie;
    VM;
    case Udalost of
      1:Tlacidlo3D(260,60,60,16,FP,'Spus~t',6,5,False);
      2:Tlacidlo3D(260,80,60,16,FP,'Nastav',10,3,False);
      3:Tlacidlo3D(260,100,60,16,FP,'Nahraj',10,3,False);
      4:Tlacidlo3D(260,120,60,16,FP,'Ulo~z',10,3,False);
      6:Tlacidlo3D(260,140,60,16,FP,'Koniec',10,3,False);
      7:begin
        Tlacidlo3D(61,144,24,16,FP,'',9,3,False);
        PrilepBMPP(67,148,MBP[4]);
      end;
      9:begin
        Tlacidlo3D(114,144,24,16,FP,'',9,3,False);
        PrilepBMPP(120,148,MBP[3]);
      end;
      10:begin
        Tlacidlo3D(253,8,16,24,FP,'',9,3,False);
        PrilepBMPP(257,14,MBP[6]);
      end;
      12:begin
        Tlacidlo3D(274,8,16,24,FP,'',9,3,False);
        PrilepBMPP(278,14,MBP[6]);
      end;
    end;
    ZM;
  until Udalost=6;
{ ----- ukoncenie programu ----- }
  ZavriGrafiku;
  WriteLn('MukoSoft interpreter jazyka Turingovych strojov verzia 2.0'#13#10'Lubos Saloky, februar 1998');
END.