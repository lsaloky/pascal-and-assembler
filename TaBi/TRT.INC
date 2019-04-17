constructor TRealTime.Init;
begin
  {AktNaboj:=nil;
  PrvyNaboj:=nil;}
  g:=0.16;{0.08}
  GetMem(VVRam,64016);
  asm
             mov word ptr VVRam,0
             inc word ptr VVRam+2
             mov ax,word ptr RealTime.VVRam+2
             mov i,ax
  end;
  VVRamSeg:=i;
  FillChar(VVRam^,64000,0);
end;
procedure TRealTime.SpracujUdalosti;
var PomCas:longint;
begin
  VykresliMGP(Menu.MGPP[5],@Menu.MBP,@menu.MSFP);
  PomCas:=MemL[$0040:$006C];
  repeat
    repeat until MemL[$0040:$006C]>PomCas;
    AktCas:=MemL[$0040:$006C];
    DeltaT:=AktCas-PomCas;
    PomCas:=AktCas;
    DeltaT:=1;
    CakajNaVOI;
    KopirujObrazovku(VVRamSeg,$A000);

    Tank1.VratStavOvladania;
    Tank2.VratStavOvladania;
    Tank3.VratStavOvladania;
    Tank4.VratStavOvladania;

    if Menu.Hrac[1] > 2 then PocHrac[1].Konaj;
    if Menu.Hrac[2] > 2 then PocHrac[2].Konaj;
    if Menu.Hrac[3] > 2 then PocHrac[3].Konaj;
    if Menu.Hrac[4] > 2 then PocHrac[4].Konaj;

    Tank1.SpracujOvladanie;
    Tank2.SpracujOvladanie;
    Tank3.SpracujOvladanie;
    Tank4.SpracujOvladanie;

    Tank1.VycisliDrahyNabojov;
    Tank2.VycisliDrahyNabojov;
    Tank3.VycisliDrahyNabojov;
    Tank4.VycisliDrahyNabojov;

    Tank1.ZistiDopadNabojov;
    Tank2.ZistiDopadNabojov;
    Tank3.ZistiDopadNabojov;
    Tank4.ZistiDopadNabojov;

    Tank2.KresliOkno;
    Tank4.KresliOkno;
    Tank1.KresliOkno;
    Tank3.KresliOkno;

    Menu.KresliMapuVStrede;

    Tank1.KresliRadar;
    Tank2.KresliRadar;
    Tank3.KresliRadar;
    Tank4.KresliRadar;
    Menu.VypisElevacnyUhol;
{    for j:=1 to 10 do CakajNaVOI;}
  until (Zoznam^[1]>0) or (Tank.PocetMrtvychTankov=3);
  if Tank.PocetMrtvychTankov=3 then begin
    if Tank1.Zivot>0 then Inc(Tank1.Body,3);
    if Tank2.Zivot>0 then Inc(Tank2.Body,3);
    if Tank3.Zivot>0 then Inc(Tank3.Body,3);
    if Tank4.Zivot>0 then Inc(Tank4.Body,3);
    Menu.KoniecPartie:=True;
  end;
end;