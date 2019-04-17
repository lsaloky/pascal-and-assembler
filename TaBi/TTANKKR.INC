constructor TTank.Init;
var se,offs,se2,offs2,se3,offs3,se4,offs4,se5,offs5:word;
    hx,hy:integer;
    s,c:real;
begin
{ ----- bitmapy ----- }
  Assign(f,'TaBi.MB');
  Reset(f,1);
  Seek(f,769);
  for i:=1 to PocetMB do NacitajBMP(f,pointer(Menu.MBP[i]));
  Close(f);
  asm
             mov ax,word ptr RealTime.VVRam+2
             mov VSeg,ax
  end;
{ ----- animacie ----- }
  Assign(f,'TaBi.MA');
  Reset(f,1);
  Seek(f,769);
  NacitajAnimaciu(f,@Vyfuk);
  NacitajAnimaciu(f,@AnimVybuch);
  Close(f);
{ ----- rotacia tankov ----- }
  k:=0;
  repeat
    IUhol:=k;
    se:=Seg(Menu.MBP[9]^); { rotacia tanku - init }
    offs:=Ofs(Menu.MBP[9]^)+4;
    se2:=Seg(Menu.MBP[14]^); { rotacia veze - init }
    offs2:=Ofs(Menu.MBP[14]^)+4;
    se3:=Seg(Menu.MBP[15]^); { rotacia hlavne dlhej - init }
    offs3:=Ofs(Menu.MBP[15]^)+4;
    se4:=Seg(Menu.MBP[16]^); { rotacia hlavne strednej - init }
    offs4:=Ofs(Menu.MBP[16]^)+4;
    se5:=Seg(Menu.MBP[17]^); { rotacia hlavne kratkej - init }
    offs5:=Ofs(Menu.MBP[17]^)+4;
    s:=Sin(IUhol*pi/180);
    c:=Cos(IUhol*pi/180);
{ ----- podvozok ----- }
    for j:=-9 to 8 do
      for i:=-15 to 14 do begin
        hx:=Round(i*c-j*s);
        hy:=Round(i*s+j*c);
        PolozBod(hx+25,hy+19,Mem[se:offs]); { podvozok }
        Inc(Offs);
        if (i>=-6) and (i<=5) and (j>=-5) and (j<=4) then begin
          PolozBod(hx+64,hy+13,Mem[se2:offs2]); { veza }
          Inc(Offs2);
        end;
        if (i>=-6) and (i<=5) and (j>=-3) and (j<=2) then begin
          PolozBod(hx+116,hy+13,Mem[se3:offs3]); { hlaven dlha }
          Inc(Offs3);
        end;
        if (i>=-5) and (i<=4) and (j>=-3) and (j<=2) then begin
          PolozBod(hx+136,hy+13,Mem[se4:offs4]); { hlaven stredna }
          Inc(Offs4);
        end;
        if (i>=-4) and (i<=3) and (j>=-3) and (j<=2) then begin
          PolozBod(hx+156,hy+13,Mem[se5:offs5]); { hlaven mala }
          Inc(Offs5);
        end;
      end;
    if k mod 9=0 then begin { stiahnutie bitmapy }
      GetMem(Podvozok[k div 9],34*34+4);
      StiahniBMP(8,2,34,34,Podvozok[k div 9]);
      GetMem(Veza[k div 9],10*10+4);
      StiahniBMP(59,8,10,10,Veza[k div 9]);
      GetMem(Hlaven[1,k div 9],10*10+4);
      StiahniBMP(111,8,10,10,Hlaven[1,k div 9]);
      GetMem(Hlaven[2,k div 9],8*8+4);
      StiahniBMP(132,9,8,8,Hlaven[2,k div 9]);
      GetMem(Hlaven[3,k div 9],6*6+4);
      StiahniBMP(153,10,6,6,Hlaven[3,k div 9]);
    end;
    k:=k+3;
  until k=360;
  VSeg:=$A000;
end;
procedure TTank.KresliRadar;
begin
  if Menu.Hrac[PorCislo]>1 then begin
    PolozBod(120+Menu.PocX+x div 16,70+Menu.PocY+y div 16,Farba*16+12);
    for i:=1 to MaxPocetNab do
      if Naboj[i].Aktivny then
        with Naboj[i] do
          PolozBod(120+Menu.PocX+x div 16,70+Menu.PocY+y div 16,15);
  end;
end;
procedure TTank.KresliOkno;
var LHRX,LHRY:integer;
    LHRXMap,LHRYMap:word;
begin
  OknoXMin:=ObrX-76;
  OknoXMax:=ObrX+75;
  OknoYMin:=ObrY-40;
  OknoYMax:=ObrY+40;
{ ----- kreslenie mapy ----- }
  if Zivot>0 then begin
    LHRX:=x-76+ 0;
    LHRY:=y-40+14;
    LHRXMap:=LHRX div 16+Menu.PocX;
    LHRYMap:=LHRY div 16+Menu.PocY;
    for i:=0 to 10 do
      for j:=0 to 5 do
        PrilepBMPPO(ObrX - 76 + 16 * i - (x - 76) mod 16,
                    ObrY - 40 + 16 * j - (y - 40 + 14) mod 16,
                    Menu.MapMBP[Menu.Mapa[LHRXMap+i,LHRYMap+j]]);
  end;
{ ----- kreslenie zvyskov po vybuchu nabojov tanku 1 do aktualneho okna ----- }
  for i:=0 to 9 do
    if Tank1.Zvysok[i].Aktivny then
      PrilepBMPPO(Tank1.Zvysok[i].x0 - x + ObrX - 8,
                  Tank1.Zvysok[i].y0 - y + ObrY - 8,
                  Tank.AnimVybuch[15]);
{ ----- kreslenie zvyskov po vybuchu nabojov tanku 2 do aktualneho okna ----- }
  for i:=0 to 9 do
    if Tank2.Zvysok[i].Aktivny then
      PrilepBMPPO(Tank2.Zvysok[i].x0 - x + ObrX - 8,
                  Tank2.Zvysok[i].y0 - y + ObrY - 8,
                  Tank.AnimVybuch[15]);
{ ----- kreslenie zvyskov po vybuchu nabojov tanku 3 do aktualneho okna ----- }
  for i:=0 to 9 do
    if Tank3.Zvysok[i].Aktivny then
      PrilepBMPPO(Tank3.Zvysok[i].x0 - x + ObrX - 8,
                  Tank3.Zvysok[i].y0 - y + ObrY - 8,
                  Tank.AnimVybuch[15]);
{ ----- kreslenie zvyskov po vybuchu nabojov tanku 4 do aktualneho okna ----- }
  for i:=0 to 9 do
    if Tank4.Zvysok[i].Aktivny then
      PrilepBMPPO(Tank4.Zvysok[i].x0 - x + ObrX - 8,
                  Tank4.Zvysok[i].y0 - y + ObrY - 8,
                  Tank.AnimVybuch[15]);
{ ----- kreslenie tanku 1 do aktualneho okna ----- }
  if Menu.Hrac[1]>1 then begin
    i:=Tank1.IUhol;
    j:=Tank1.IUholNatocenia;
    k:=Trunc(Tank1.ElevacnyUhol*9/pi)+1;
    if k=4 then k:=3;
    PrilepBMPPOF(Tank1.x - x + ObrX - 17,
                 Tank1.y - y + ObrY - 17, Tank.Podvozok[i],Tank1.Farba);
    if Tank1.Zivot>0 then begin
      PrilepBMPPOF(Tank1.x - x + ObrX -  5,
                   Tank1.y - y + ObrY -  5, Tank.Veza[j mod 40],Tank1.Farba);
      PrilepBMPPOF(Round(Tank1.x - x + ObrX - 6 + k + (8 - k) * cos(j * pi / 20)),
                   Round(Tank1.y - y + ObrY - 6 + k + (8 - k) * sin(j * pi / 20)),
                   Tank.Hlaven[k,j mod 40],Tank1.Farba);
      if Tank1.AktSnimVyfuk>0 then
        PrilepBMPPO(Round(Tank1.x - x - 2 + ObrX - 13 * cos(i * pi / 20)),
                    Round(Tank1.y - y - 2 + ObrY - 13 * sin(i * pi / 20)),
                    Tank.Vyfuk[Tank1.AktSnimVyfuk]);
    end else begin
      if Tank1.CasSmrti>RealTime.AktCas-47 then begin
        k:=(RealTime.AktCas-Tank1.CasSmrti) div 3;
        PrilepBMPPO(Tank1.x - x + ObrX - 8,
                     Tank1.y - y + ObrY - 8, Tank.AnimVybuch[k]);
      end else PrilepBMPPOF(Tank1.x - x + ObrX - 8,
                            Tank1.y - y + ObrY - 8,Menu.MBP[30],Tank1.Farba);
    end;
  end;
{ ----- kreslenie tanku 2 do aktualneho okna ----- }
  if Menu.Hrac[2]>1 then begin
    i:=Tank2.IUhol;
    j:=Tank2.IUholNatocenia;
    k:=Trunc(Tank2.ElevacnyUhol*9/pi)+1;
    if k=4 then k:=3;
    PrilepBMPPOF(Tank2.x - x + ObrX - 17,
                 Tank2.y - y + ObrY - 17, Tank.Podvozok[i],Tank2.Farba);
    if Tank2.Zivot>0 then begin
      PrilepBMPPOF(Tank2.x - x + ObrX -  5,
                   Tank2.y - y + ObrY -  5, Tank.Veza[j mod 40],Tank2.Farba);
      PrilepBMPPOF(Round(Tank2.x - x + ObrX - 6 + k + (8 - k) * cos(j * pi / 20)),
                   Round(Tank2.y - y + ObrY - 6 + k + (8 - k) * sin(j * pi / 20)),
                   Tank.Hlaven[k,j mod 40],Tank2.Farba);
      if Tank2.AktSnimVyfuk>0 then
        PrilepBMPPO(Round(Tank2.x - x - 2 + ObrX - 13 * cos(i * pi / 20)),
                    Round(Tank2.y - y - 2 + ObrY - 13 * sin(i * pi / 20)),
                    Tank.Vyfuk[Tank2.AktSnimVyfuk]);
    end else begin
      if Tank2.CasSmrti>RealTime.AktCas-47 then begin
        k:=(RealTime.AktCas-Tank2.CasSmrti) div 3;
        PrilepBMPPO(Tank2.x - x + ObrX - 8,
                     Tank2.y - y + ObrY - 8, Tank.AnimVybuch[k]);
      end else PrilepBMPPOF(Tank2.x - x + ObrX - 8,
                            Tank2.y - y + ObrY - 8,Menu.MBP[30],Tank2.Farba);
    end;
  end;
{ ----- kreslenie tanku 3 do aktualneho okna ----- }
  if Menu.Hrac[3]>1 then begin
    i:=Tank3.IUhol;
    j:=Tank3.IUholNatocenia;
    k:=Trunc(Tank3.ElevacnyUhol*9/pi)+1;
    if k=4 then k:=3;
    PrilepBMPPOF(Tank3.x - x + ObrX - 17,
                 Tank3.y - y + ObrY - 17, Tank.Podvozok[i],Tank3.Farba);
    if Tank3.Zivot>0 then begin
      PrilepBMPPOF(Tank3.x - x + ObrX -  5,
                   Tank3.y - y + ObrY -  5, Tank.Veza[j mod 40],Tank3.Farba);
      PrilepBMPPOF(Round(Tank3.x - x + ObrX - 6 + k + (8 - k) * cos(j * pi / 20)),
                   Round(Tank3.y - y + ObrY - 6 + k + (8 - k) * sin(j * pi / 20)),
                   Tank.Hlaven[k,j mod 40],Tank3.Farba);
      if Tank3.AktSnimVyfuk>0 then
        PrilepBMPPO(Round(Tank3.x - x - 2 + ObrX - 13 * cos(i * pi / 20)),
                    Round(Tank3.y - y - 2 + ObrY - 13 * sin(i * pi / 20)),
                    Tank.Vyfuk[Tank3.AktSnimVyfuk]);
    end else begin
      if Tank3.CasSmrti>RealTime.AktCas-47 then begin
        k:=(RealTime.AktCas-Tank3.CasSmrti) div 3;
        PrilepBMPPO(Tank3.x - x + ObrX - 8,
                     Tank3.y - y + ObrY - 8, Tank.AnimVybuch[k]);
      end else PrilepBMPPOF(Tank3.x - x + ObrX - 8,
                            Tank3.y - y + ObrY - 8,Menu.MBP[30],Tank3.Farba);
    end;
  end;
{ ----- kreslenie tanku 4 do aktualneho okna ----- }
  if Menu.Hrac[4]>1 then begin
    i:=Tank4.IUhol;
    j:=Tank4.IUholNatocenia;
    k:=Trunc(Tank4.ElevacnyUhol*9/pi)+1;
    if k=4 then k:=3;
    PrilepBMPPOF(Tank4.x - x + ObrX - 17,
                 Tank4.y - y + ObrY - 17, Tank.Podvozok[i],Tank4.Farba);
    if Tank4.Zivot>0 then begin
      PrilepBMPPOF(Tank4.x - x + ObrX -  5,
                   Tank4.y - y + ObrY -  5, Tank.Veza[j mod 40],Tank4.Farba);
      PrilepBMPPOF(Round(Tank4.x - x + ObrX - 6 + k + (8 - k) * cos(j * pi / 20)),
                   Round(Tank4.y - y + ObrY - 6 + k + (8 - k) * sin(j * pi / 20)),
                   Tank.Hlaven[k,j mod 40],Tank4.Farba);
      if Tank4.AktSnimVyfuk>0 then
        PrilepBMPPO(Round(Tank4.x - x - 2 + ObrX - 13 * cos(i * pi / 20)),
                    Round(Tank4.y - y - 2 + ObrY - 13 * sin(i * pi / 20)),
                    Tank.Vyfuk[Tank4.AktSnimVyfuk]);
    end else begin
      if Tank4.CasSmrti>RealTime.AktCas-47 then begin
        k:=(RealTime.AktCas-Tank4.CasSmrti) div 3;
        PrilepBMPPO(Tank4.x - x + ObrX - 8,
                     Tank4.y - y + ObrY - 8, Tank.AnimVybuch[k]);
      end else PrilepBMPPOF(Tank4.x - x + ObrX - 8,
                            Tank4.y - y + ObrY - 8,Menu.MBP[30],Tank4.Farba);
    end;
  end;
{ ----- kreslenie nabojov tanku 1 do aktualneho okna ----- }
  for i:=1 to MaxPocetNab do
    if Tank1.Naboj[i].Aktivny then begin
      j:=Tank1.Naboj[i].z div 15;
      if j>5 then j:=5;
      PrilepBMPPO(Tank1.Naboj[i].x - x + ObrX - j div 2,
                  Tank1.Naboj[i].y - y + ObrY - j div 2,
                  Menu.MBP[22+j])
    end;
{ ----- kreslenie vybuchov tanku 1 do aktualneho okna ----- }
  for i:=1 to MaxPocetNab do begin
    if Tank1.Vybuch[i].Aktivny then begin
      j:=(RealTime.AktCas-Tank1.Vybuch[i].t0) div 3;
      if j>15 then j:=15;
      PrilepBMPPO(Tank1.Vybuch[i].x0 - x + ObrX - 8,
                  Tank1.Vybuch[i].y0 - y + ObrY - 8,
                  Tank.AnimVybuch[j]);
    end;
  end;
{ ----- kreslenie nabojov tanku 2 do aktualneho okna ----- }
  for i:=1 to MaxPocetNab do
    if Tank2.Naboj[i].Aktivny then begin
      j:=Tank2.Naboj[i].z div 15;
      if j>5 then j:=5;
      PrilepBMPPO(Tank2.Naboj[i].x - x + ObrX - j div 2,
                  Tank2.Naboj[i].y - y + ObrY - j div 2,
                  Menu.MBP[22+j])
    end;
{ ----- kreslenie vybuchov tanku 2 do aktualneho okna ----- }
  for i:=1 to MaxPocetNab do begin
    if Tank2.Vybuch[i].Aktivny then begin
      j:=(RealTime.AktCas-Tank2.Vybuch[i].t0) div 3;
      if j>15 then j:=15;
      PrilepBMPPO(Tank2.Vybuch[i].x0 - x + ObrX - 8,
                  Tank2.Vybuch[i].y0 - y + ObrY - 8,
                  Tank.AnimVybuch[j]);
    end;
  end;
{ ----- kreslenie nabojov tanku 3 do aktualneho okna ----- }
  for i:=1 to MaxPocetNab do
    if Tank3.Naboj[i].Aktivny then begin
      j:=Tank3.Naboj[i].z div 15;
      if j>5 then j:=5;
      PrilepBMPPO(Tank3.Naboj[i].x - x + ObrX - j div 2,
                  Tank3.Naboj[i].y - y + ObrY - j div 2,
                  Menu.MBP[22+j])
    end;
{ ----- kreslenie vybuchov tanku 3 do aktualneho okna ----- }
  for i:=1 to MaxPocetNab do begin
    if Tank3.Vybuch[i].Aktivny then begin
      j:=(RealTime.AktCas-Tank3.Vybuch[i].t0) div 3;
      if j>15 then j:=15;
      PrilepBMPPO(Tank3.Vybuch[i].x0 - x + ObrX - 8,
                  Tank3.Vybuch[i].y0 - y + ObrY - 8,
                  Tank.AnimVybuch[j]);
    end;
  end;
{ ----- kreslenie nabojov tanku 4 do aktualneho okna ----- }
  for i:=1 to MaxPocetNab do
    if Tank4.Naboj[i].Aktivny then begin
      j:=Tank4.Naboj[i].z div 15;
      if j>5 then j:=5;
      PrilepBMPPO(Tank4.Naboj[i].x - x + ObrX - j div 2,
                  Tank4.Naboj[i].y - y + ObrY - j div 2,
                  Menu.MBP[22+j])
    end;
{ ----- kreslenie vybuchov tanku 4 do aktualneho okna ----- }
  for i:=1 to MaxPocetNab do begin
    if Tank4.Vybuch[i].Aktivny then begin
      j:=(RealTime.AktCas-Tank4.Vybuch[i].t0) div 3;
      if j>15 then j:=15;
      PrilepBMPPO(Tank4.Vybuch[i].x0 - x + ObrX - 8,
                  Tank4.Vybuch[i].y0 - y + ObrY - 8,
                  Tank.AnimVybuch[j]);
    end;
  end;
{ ----- zacervenanie, ked je tank mrtvy ----- }
  if Zivot=0 then begin
    Color:=28;
    VyplnPlochu(ObrX - 76,ObrY - 40, 152,80);
  end;
  PolozBod(0,95,0);
  PolozBod(0,187,107);
  Color:=107;
  CiaraZvisla(151,14,55);
  CiaraZvisla(151,131,55);
  CiaraVodorovna(0,94,119);
  CiaraVodorovna(320-119,94,119);
  CiaraVodorovna(0,186,152);
  CiaraVodorovna(320-152,186,152);
end;
