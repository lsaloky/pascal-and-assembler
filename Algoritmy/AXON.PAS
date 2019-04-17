program Axonometricke_zobrazovanie;
uses MainGr;
const KVrcholy:array[1..8,1..3] of byte=((0,0,0),(0,0,1),(0,1,0),(0,1,1),
                                         (1,0,0),(1,0,1),(1,1,0),(1,1,1));
      KHrany:array[1..12,1..2] of byte=((1,2),(2,4),(4,3),(3,1),
                                        (5,6),(6,8),(8,7),(7,5),
                                        (1,5),(2,6),(3,7),(4,8));
      Alfa:real=0;
      Beta:real=0;
var i,j,k:integer;
    x,y,x2,y2:integer;
procedure VycisliItyVrchol;
begin
  x:=Round((-cos(Alfa)*KVrcholy[i,1]
            +cos(Beta)*KVrcholy[i,2])*40+100);
  y:=Round(( sin(Alfa)*KVrcholy[i,1]
            +sin(Beta)*KVrcholy[i,2]
            -          Kvrcholy[i,3])*40+100);
end;
BEGIN
  InicializujGrafiku;
  for k:=0 to 359 do begin
    Color:=27;
    for j:=1 to 12 do begin
      i:=KHrany[j,1];
      VycisliItyVrchol;
      x2:=x;y2:=y;
      i:=KHrany[j,2];
      VycisliItyVrchol;
      Ciara(x,y,x2,y2);
    end;
    for i:=1 to 8 do begin
      VycisliItyVrchol;
      PolozBod(x,y,31);
    end;
    Color:=71;
    Ciara(100,100,100+Round(-cos(Alfa)*50),100-Round(-sin(Alfa)*50));
    Ciara(100,100,100+Round( cos(Beta)*50),100-Round(-sin(Beta)*50));
    Ciara(100,100,100,50);
    Color:=31;
    CitajZnak;
    Alfa:=Alfa+pi/180;
    CakajNaVOI;
    Color:=23;
    VyplnPlochu(50,20,140,140);
  end;
  ReadLn;
END.