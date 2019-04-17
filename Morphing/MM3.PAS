program MukoSoft_MorfEdit;    {verzia 3.0}
uses Graph,Dos,Crt,MM3TPU,Myska;
const PPM=9;    {pocet povelov mysi}
      PPK=8;    {pocet povelov klavesnice}
      maxciar=1000;
      mys:array[1..PPM,1..4]of word=((0,0,117,18),(118,0,165,18),(166,0,245,18),
      (246,0,293,18),(294,0,357,18),(358,0,405,18),(406,0,477,18),(478,0,541,18),(0,19,639,479));
      klav:array[101..100+PPK] of char=('p','z','m','u','n','i','v','k');
type ciara=record
             x1z,y1z,x2z,y2z,x1k,y1k,x2k,y2k:integer; {z-vychozia poloha ciary}
           end;                                    {k-cielova poloha ciary}
     dynpam=array[1..16*maxciar+256] of byte;  {datovy subor v pamati-type}
var reg:registers;
    x,y,kx,ky,skx,sky,rob:word;    {kx,ky - pozicia kurzora mysi}
    akta:integer;                {cislo animacie}
    pciar:array[0..255] of byte; {pocet ciar v n-tej animacii, max. 255}
    c:array[1..maxciar] of ciara;{zoznam ciar}
    d:array[1..maxciar] of ciara;{pomocne pole pri morphingu}
    f:file;                      {datovy subor}
    p:^dynpam;                   {datovy subor v pamati}
    tlacidlo,verzia:byte;        {verzia datoveho suboru}
    paa:word;                    {ukazatel za poslednu ciaru aktualnej animacie:c[paa].}
    celk:word;                   {celkovy pocet animacii}
    long:longint;
    ch:char;

procedure Prekresli;
begin
  VypniKurzorMysi;
  for x:=0 to 36 do
    for y:=1 to 23 do
      PutPixel(5+x*20,5+y*20,9);
  for x:=paa-pciar[akta] to paa-1 do begin
    SetColor(14);
    Line(c[x].x1z,c[x].y1z,c[x].x2z,c[x].y2z);
    SetColor(11);
    Line(c[x].x1k,c[x].y1k,c[x].x2k,c[x].y2k);
    PutPixel(c[x].x1z,c[x].y1z,0);
    PutPixel(c[x].x1k,c[x].y1k,0);
  end;
  SetColor(7);
  ZapniKurzorMysi;
end;

procedure Inicializacia;      {------------- inicializacia  ------------ }
const gd:integer=9;
      gm:integer=2;
      cesta='d:\bp\bgi';
begin
  akta:=1;
  GetMem(p,16*maxciar+256);
  FillChar(pciar,SizeOf(pciar),#0);
  FillChar(c,SizeOf(c),#0);
  Assign(f,'prazdny.dat');
  reset(f,1);
  BlockRead(f,p^,256);
  for x:=2 to 256 do celk:=celk+p^[x];
  BlockRead(f,p^[257],celk*16);
  Move(p^[2],pciar,255);
  Move(p^[257],c,16*celk);
  BlockRead(f,verzia,1);
  Close(f);
  InitGraph(gd,gm,cesta);
  ZapniKurzorMysi;
  SetFillStyle(1,0);
  SetColor(7);
  HorneMenu;
  paa:=pciar[1]+1;
  Prekresli;
end;

function ObsluzUdalost:word;  { ------ obsluha klavesnice a mysi ------- }
var akcia:word;
begin
  akcia:=0;
  ch:=' ';
  repeat
    ZistiPoziciu(kx,ky,tlacidlo);
    if keypressed then ch:=ReadKey;
    VypisPoziciuKurzora(kx,ky);
    if tlacidlo=1 then
      for x:=1 to PPM do
        if (kx>=mys[x,1]) and (ky>=mys[x,2]) and (kx<=mys[x,3]) and (ky<=mys[x,4]) then akcia:=x;
    if ch<>' ' then
      for x:=101 to 100+PPK do
        if ch=klav[x] then akcia:=x;
  until akcia>0;
  ObsluzUdalost:=akcia;
end;

BEGIN                         { ------------ hlavny program ------------ }
  Inicializacia;
  repeat
    rob:=ObsluzUdalost;
    case rob of
      1,101:begin
        VypniKurzorMysi;
        akta:=SpytajSa('Zadaj cislo animacie:',0,255);
        paa:=1;x:=1;
        while x<=akta do begin
          paa:=paa+pciar[x];
          Inc(x);
        end;
        Bar(0,19,639,479);
        Prekresli;
        Informuj('');
        ZapniKurzorMysi;
      end;
      6,106:begin
        VypniKurzorMysi;
        Informuj('MukoSoft MorfEdit verzia 3.0, (c) Lubos Saloky, 1996. Stlac klaves.');
        ch:=Readkey;
        Informuj('');
        ZapniKurzorMysi;
      end;
      7,107:begin
        VypniKurzorMysi;
        Informuj('Bodkuj  B‚zierove krivky  Prilinkuj anim ciu  Rychlost  Prekresli');
        ch:=ReadKey;
        Informuj('');
        ZapniKurzorMysi;
      end;
      9:begin
        Sound(1000);
        Delay(10);
        NoSound;
        long:=TestujCtrl(kx,ky);
        if long>0 then begin
          kx:=long div 65536;
          ky:=long mod 65536;
          NastavKurzor(kx,ky);
        end;
        for x:=celk downto paa do move(c[x],c[x+1],16);
        c[paa].x1z:=kx;
        c[paa].y1z:=ky;
        Informuj('Zadaj koncovy bod ciary 1. snimku animacie');
        long:=KresliCiaru(14,kx,ky);
        c[paa].x2z:=long div 65536;
        c[paa].y2z:=long mod 65536;
        Informuj('Presun sa na pociatocny bod ciary posledneho snimku animacie');
        repeat
          ZistiPoziciu(kx,ky,tlacidlo);
        until tlacidlo=1;
        long:=TestujCtrl(kx,ky);
        if long>0 then begin
          kx:=long div 65536;
          ky:=long mod 65536;
          NastavKurzor(kx,ky);
        end;
        c[paa].x1k:=kx;
        c[paa].y1k:=ky;
        Informuj('Zadaj koncovy bod ciary posledneho snimku animacie');
        long:=KresliCiaru(11,kx,ky);
        c[paa].x2k:=long div 65536;
        c[paa].y2k:=long mod 65536;
        Informuj('');
        Inc(paa);
        Inc(celk);
        Inc(pciar[akta]);
      end;
    end;
  until (rob=108) or (rob=8);
  {CloseGraph;}
END.




