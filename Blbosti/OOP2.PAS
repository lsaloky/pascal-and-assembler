program OOP_2;{obalenie, polymorfizmus a virtualne metody}
uses Graph;
type
  TLokace=object                  {najabstraktnejsi objekt obaleny metodami}
    Viditelnost:boolean;
    x,y:integer;                  {priamy pristup k datovym polozkam nie je nutny,}
    procedure Init(sx,sy:integer);{lebo objekt je dostatocne obaleny}
    function CitajX:integer;      {metodami pre pracu s datami}
    function CitajY:integer;
  end;
  TBod=object(TLokace)                     {potomok TLokace}
    Constructor Init(sx,sy:integer);
{konstruktor musi byt vsade tam, kde je virtualna metoda a musi sa volat pred nou}
    procedure Zobraz;virtual;{musi byt virtualna, aby procedura Pohyb vedela,}
    procedure Zhasni;virtual;{co ma zobrazit alebo zhasnut. }
    procedure Pohyb(sx,sy:integer);virtual;
{Ak zadas prikaz Kruh.Pohyb, tak sa pohne kruh. Podobne hybes aj bodom a stvorcom.
Procedura Pohyb nemusi byt zadefinovana zvlast pre kazdy objekt, ale vsetci
potomkovia (Kruh, Stvorec) ju dedia}
  end;
  TKruh=object(TBod)
    r:integer;
    Constructor Init(sx,sy,polomer:integer);
    procedure Zobraz;virtual;
    procedure Zhasni;virtual;
  end;
  TStvorec=object(TBod)
    strana:integer;
    constructor Init(xi,yi,stranai:integer);
    procedure Zobraz;virtual;
    procedure Zhasni;virtual;
    destructor Done;virtual;{Momentalne nema zmysel. Pouziva sa, ak objekt
    pouzival dynamicke premenne. Procedura Dispose by z pamate uvolnila len
    objekt, ale nie jeho DP. Mal by byt virtualny, aby sa z pamate mohli
    dealokovat aj potomkovia, ktori zabrali ine mnozstvo dynamickej pamate}
  end;
  Siet=array[1..10,1..10] of byte;
  TDynStvorec=object(TStvorec)
    p:^Siet;     {objekt pouziva dynamicke premenne}
    constructor Init(xi,yi,stranai:integer);
    destructor Done;virtual;
  end;
{ ------------------ Deklaracia procedur TLokace -------------------- }
procedure TLokace.Init;
begin
  x:=sx;
  y:=sy;
end;
function TLokace.CitajX:integer;
begin
  CitajX:=x;
end;
function TLokace.CitajY:integer;
begin
  CitajY:=y;
end;
{ ------------------ Deklaracia procedur TBod -------------------- }
constructor TBod.Init(sx,sy:integer);
begin
  TLokace.Init(sx,sy);
  Viditelnost:=false;
end;
procedure TBod.Zobraz;
begin
  Viditelnost:=true;
  PutPixel(x,y,15);
end;
procedure TBod.Zhasni;
begin
  Viditelnost:=false;
  PutPixel(x,y,0);
end;
procedure TBod.Pohyb(sx,sy:integer);
begin
  Zhasni;
  x:=sx;
  y:=sy;
  Zobraz;
end;
{ ------------------ Deklaracia procedur TKruh -------------------- }
constructor TKruh.Init(sx,sy,polomer:integer);
begin
  TLokace.Init(sx,sy);
  Viditelnost:=false;
  r:=polomer;
end;
procedure TKruh.Zobraz;
begin
  SetColor(15);
  Viditelnost:=true;
  Circle(x,y,r);
end;
procedure TKruh.Zhasni;
begin
  SetColor(0);
  Viditelnost:=false;
  Circle(x,y,r);
end;
{ ------------------ Deklaracia procedur TStvorec -------------------- }
constructor TStvorec.Init(xi,yi,stranai:integer);
begin
  TLokace.Init(xi,yi);
  strana:=stranai;
end;
procedure TStvorec.Zobraz;
begin
  Viditelnost:=true;
  SetColor(15);
  Rectangle(x,y,x+strana,y+strana);
end;
procedure TStvorec.Zhasni;
begin
  Viditelnost:=false;
  SetColor(0);
  Rectangle(x,y,x+strana,y+strana);
end;
destructor TStvorec.Done;
begin
end;
{ ------------------ Deklaracia procedur TDynStvorec -------------------- }
constructor TDynStvorec.Init(xi,yi,stranai:integer);
begin
  TLokace.Init(xi,yi);
  strana:=stranai;
  New(p);
end;
destructor TDynStvorec.Done;
begin
  Dispose(p);
end;
{ ------------------ Deklaracia premennych a objektov -------------------- }
var Bod:TBod;
    Kruh:TKruh;           {kruh je v datovom segmente}
    Stvorec:^TStvorec;    {stvorec je v halde}
    DynStvorec:^TDynStvorec;
    gd,gm:integer;
{ ------------------ samotny program -------------------- }
BEGIN
  gd:=9;gm:=2;InitGraph(gd,gm,'d:\bp\bgi');
  Bod.Init(100,100);             {inicializacia objektov}
  Kruh.Init(200,100,50);
  New(Stvorec,Init(10,200,30));
  New(DynStvorec,Init(20,220,30));
  Bod.Zobraz;                     {praca s objektami}
  Kruh.Zobraz;
  Stvorec^.Zobraz;
  DynStvorec^.Zobraz;
  readln;
  Kruh.Pohyb(220,100);
  Stvorec^.Pohyb(420,100);
  readln;
  Dispose(Stvorec,Done);
  writeln(maxavail);
  Dispose(DynStvorec,Done);
  writeln(maxavail);
  readln;
END.
