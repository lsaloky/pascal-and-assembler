procedure TPovel.JoyStickDemo;
begin
  i:=Povel.JXAkt;j:=Povel.JYAkt;
  repeat
    i:=i div 3;j:=j div 5;
    PolozBod(i,j,15);
    Joystick.ZistiPoziciu(word(i),word(j),b);
    if b=2 then begin
      ZmazObrazovku;
      b:=0;
    end;
  until b>0;
end;
procedure TPovel.OvladanieDemo;
begin
  Mys.NastavKurzor(160,100);
  Povel.MysXStare:=160;
  Povel.MysYStare:=100;
  repeat
    Color:=0;
    for i:=1 to 4 do
      for j:=1 to 6 do
        VyplnPlochu(6+150*((i-1) mod 2)+70*((j-1) mod 2),65+75*((i-1) div 2)+17*((j-1) div 2),14,14);
    Color:=12;
    Tank1.VratStavOvladania;
    for j:=1 to 6 do
      if Tank1.AktPovel[j] then
        VyplnPlochu(6+150*((1-1) mod 2)+70*((j-1) mod 2),65+75*((1-1) div 2)+17*((j-1) div 2),14,14);
    Tank2.VratStavOvladania;
    for j:=1 to 6 do
      if Tank2.AktPovel[j] then
        VyplnPlochu(6+150*((2-1) mod 2)+70*((j-1) mod 2),65+75*((2-1) div 2)+17*((j-1) div 2),14,14);
    Tank3.VratStavOvladania;
    for j:=1 to 6 do
      if Tank3.AktPovel[j] then
        VyplnPlochu(6+150*((3-1) mod 2)+70*((j-1) mod 2),65+75*((3-1) div 2)+17*((j-1) div 2),14,14);
    Tank4.VratStavOvladania;
    for j:=1 to 6 do
      if Tank4.AktPovel[j] then
        VyplnPlochu(6+150*((4-1) mod 2)+70*((j-1) mod 2),65+75*((4-1) div 2)+17*((j-1) div 2),14,14);
    CakajNaVOI;
    MysXStare:=MysX;
    MysYStare:=MysY;
  until (MysX=0) and (MTlac=Lave);
end;
procedure TPovel.ZistiKlavesy;
begin
  repeat
    for i:=0 to 127 do
      if Zoznam^[i]>0 then Write(i,',');
  until False;
end;
procedure TMenu.KlavesnicoveDemo;
var Posl:byte;
begin
  Posl:=0;
  repeat
    for i:=0 to 127 do
      if (Zoznam^[i]>0) and (i<>Posl) then begin
        Write(Chr(KodNaZnak(i)));
        Posl:=i;
      end;
  until Zoznam^[$1C]=1;
end;
procedure TMenu.HerneDemo;
var ai:word;
begin
  VM;
  VykresliMGP(MGPP[5],@MBP,@MSFP);
  Tank1.IUhol:=5;
  Tank1.IUholNatocenia:=5;
  Tank1.KresliOkno;
  Tank2.IUhol:=15;
  Tank2.IUholNatocenia:=15;
  Tank2.KresliOkno;
  Tank3.IUhol:=35;
  Tank3.IUholNatocenia:=35;
  Tank3.KresliOkno;
  Tank4.IUhol:=25;
  Tank4.IUholNatocenia:=25;
  Tank4.KresliOkno;
  for ai:=1 to 40 do begin
    Tank1.PosunTank(1,1);
    KresliMapuVStrede;
    for j:=1 to 5 do CakajNaVOI;
  end;
  for ai:=5 to 30 do begin
    Tank1.IUhol:=ai;
    Tank1.IUholNatocenia:=ai+5;
    Tank1.KresliOkno;
    KresliMapuVStrede;
    for j:=1 to 5 do CakajNaVOI;
  end;
  for ai:=1 to 30 do begin
    Tank1.PosunTank(0,-1);
    KresliMapuVStrede;
    for j:=1 to 5 do CakajNaVOI;
  end;
  for ai:=35 downto 25 do begin
    Tank1.IUholNatocenia:=ai;
    Tank1.KresliOkno;
    KresliMapuVStrede;
    for j:=1 to 5 do CakajNaVOI;
  end;
  for ai:=25 to 45 do begin
    Tank1.IUholNatocenia:=ai;
    Tank1.KresliOkno;
    KresliMapuVStrede;
    for j:=1 to 5 do CakajNaVOI;
  end;
  for ai:=1 to 80 do begin
    Tank4.PosunTank(-1,-1);
    KresliMapuVStrede;
    for j:=1 to 5 do CakajNaVOI;
  end;
  ReadLn;
end;
procedure TTank.Demo2;
begin
  Color:=0;
  repeat
    for i:=0 to 39 do begin
      VyplnPlochu(0,0,50,50);
      PrilepBMPP(10,10,Tank.Podvozok[i]);
      PrilepBMPP(10+17-5,10+17-5,Tank.Veza[(i*2) mod 40]);
      PrilepBMPP(Round(10+17-5+7*cos(i*9*2*pi/180)),
                 Round(10+17-5+7*sin(i*9*2*pi/180)),
                 Tank.Hlaven[1,(i*2) mod 40]);
      for j:=1 to 10 do CakajNaVOI;
    end;
  until JeZnak;
end;
procedure TTank.Demo;
begin
  VM;
  Color:=12;
  VyplnPlochu(0,0,320,200);
  for i:=1 to 10 do begin
    j:=10+((i-1) mod 2)*100;
    k:=10+((i-1) div 2)*30;
    PrilepBMPPF(j,k,Menu.MBP[9],i);
    PrilepBMPPF(j+11,k+6,Menu.MBP[10],i);
    PrilepBMPPF(j+19,k+8,Menu.MBP[11],i);
  end;
  k:=0;
  repeat
    k:=(k+9) mod 360;
    IUhol:=k;
    RotujTank;
    Color:=15;
    Obdlznik(8,2,34,34);
    Obdlznik(8,62,34,34);
    PrilepBMPPF(21,16,Menu.MBP[10],0);
    PrilepBMPPF(29,18,Menu.MBP[11],0);
    CakajNaVOI;CakajNaVOI;CakajNaVOI;CakajNaVOI;CakajNaVOI;CakajNaVOI;
  until JeZnak;
  ZM;
end;
procedure TTank.RotujTank;
var se,offs:word;
    hx,hy:integer;
begin
  se:=Seg(Menu.MBP[9]^);
  offs:=Ofs(Menu.MBP[9]^)+4;
  for j:=-9 to 8 do
    for i:=-15 to 14 do begin
      hx:=Round(i*cos(IUhol*pi/20)-j*sin(IUhol*pi/20));
      hy:=Round(i*sin(IUhol*pi/20)+j*cos(iUhol*pi/20));
      PolozBod(hx+25,hy+19,Mem[se:offs]);
      PolozBod(hx+125,hy+19,Mem[se:offs]+16);
      PolozBod(hx+25,hy+49,Mem[se:offs]+32);
      Inc(Offs);
    end;
end;
procedure TRealTime.Demo;
var xs,ys,zs:array[1..100] of integer;
    t:longint;
begin
  for i:=1 to 100 do begin
    xs[i]:=0;ys[i]:=0;zs[i]:=0;
  end;
  Tank1.IUholNatocenia:=4;
  PridajNaboj(3.2,MemL[$0040:$006C],1,0,0,pi/6);
  PridajNaboj(4.2,MemL[$0040:$006C],1,0,0,pi/8);
  PridajNaboj(5.2,MemL[$0040:$006C],1,0,0,pi/4);
  i:=1;
{  with AktNaboj^ do
    repeat
      VypocitajPoziciuNaboja;
      xs[i]:=x;ys[i]:=y;zs[i]:=z;
      Inc(i);
      t:=MemL[$0040:$006C];
      repeat until MemL[$0040:$006C]>t;
    until (i=100) or (z<0);}

  { sem musi prist breakpoint , daj si zobrazovat xs,ys,zs }
  OdoberNaboj;
end;
procedure TRealTime.PridajNaboj(Rychlost:real;t0:longint;Vlastnik,x,y:word;Uhol:real);
begin
(*  New(PomNaboj);
  PomNaboj^.NDal:=nil; { pridavanie na koniec zoznamu }
  PomNaboj^.Rychlost:=Rychlost;
  PomNaboj^.t0:=t0;
  PomNaboj^.x0:=x;
  PomNaboj^.y0:=y;
  PomNaboj^.Vlastnik:=Vlastnik;
  PomNaboj^.ElevacnyUhol:=Uhol;
  if PrvyNaboj<>nil then begin
    AktNaboj:=PrvyNaboj;
    while AktNaboj^.NDal<>nil do AktNaboj:=AktNaboj^.NDal;
    AktNaboj^.NDal:=PomNaboj;
  end else begin
    PrvyNaboj:=PomNaboj;
    AktNaboj:=PomNaboj;
  end; *)
end;
procedure TRealTime.OdoberNaboj;
begin
(*  if AktNaboj=PrvyNaboj then begin
    PrvyNaboj:=PrvyNaboj^.NDal;
    Dispose(AktNaboj);
    AktNaboj:=PrvyNaboj;
  end else begin
    PomNaboj:=PrvyNaboj;
    while (PomNaboj^.NDal<>AktNaboj)
      and (PomNaboj^.NDal<>nil) do PomNaboj:=PomNaboj^.NDal;
{ !!!!! ak najde nil, v rade je chyba, ale program nepoda hlasenie !!!!! }
    if PomNaboj^.NDal<>nil then begin
      PomNaboj^.NDal:=PomNaboj^.NDal^.NDal;
      Dispose(AktNaboj);
      AktNaboj:=PomNaboj;
    end;
  end;  *)
end;
procedure TRealTime.VypocitajPoziciuNaboja;
var t:longint;
    u:real;
begin
(*  with AktNaboj^ do begin
    case Vlastnik of
      1:u:=Tank1.IUholNatocenia*pi/20;
      2:u:=Tank2.IUholNatocenia*pi/20;
      3:u:=Tank3.IUholNatocenia*pi/20;
      4:u:=Tank4.IUholNatocenia*pi/20;
    end;
    t:=MemL[$0040:$006C]-t0;
    x:=Round(x0 + cos(u) * cos(ElevacnyUhol) * t * Rychlost);
    y:=Round(y0 + sin(u) * cos(ElevacnyUhol) * t * Rychlost);
    z:=Round(Rychlost * t * sin(ElevacnyUhol) - t * t * g / 2);
  end;    *)
end;
procedure TPocHrac.Demo;
begin
  Tank1.x:=80;
  Tank1.y:=40;
  Tank2.x:=20*16-80;
  Tank2.y:=40;
  Tank3.x:=80;
  Tank3.y:=20*16-60;
  Tank4.x:=20*16-80;
  Tank4.y:=20*16-60;
  for i:=1 to 4 do Menu.Hrac[1]:=2;
  PocHrac[1].Init;
  PocHrac[4].Konaj;
end;
