constructor TTank1.Init;
begin
  ObnovNastavenia;
  PorCislo:=1;
  Farba:=8;
  Body:=0;
  DefPovel[1]:=#19;
  DefPovel[2]:=#46;
  DefPovel[3]:=#32;
  DefPovel[4]:=#33;
  DefPovel[5]:=#30;
  DefPovel[6]:=#130;
end;
constructor TTank2.Init;
begin
  ObnovNastavenia;
  Body:=0;
  PorCislo:=2;
  Farba:=2;
  DefPovel[1]:=#72;
  DefPovel[2]:=#80;
  DefPovel[3]:=#75;
  DefPovel[4]:=#77;
  DefPovel[5]:=#28;
  DefPovel[6]:=#131;
end;
constructor TTank3.Init;
begin
  ObnovNastavenia;
  PorCislo:=3;
  Farba:=5;
  Body:=0;
  for j:=1 to 6 do DefPovel[j]:=#254;
end;
constructor TTank4.Init;
begin
  ObnovNastavenia;
  PorCislo:=4;
  Farba:=9;
  Body:=0;
  Assign(f,'Setup.DAT');
  Reset(f,1);
  Seek(f,5);
  BlockRead(f,bool,1);
  if bool then for i:=1 to 6 do DefPovel[i]:=#255
  else begin
    DefPovel[1]:=#$17;
    DefPovel[2]:=#$32;
    DefPovel[3]:=#$24;
    DefPovel[4]:=#$25;
    DefPovel[5]:=#$39;
    DefPovel[6]:=#132;
  end;
end;
procedure TTank1.ObnovNastavenia;
begin
  ObrX:=76;
  ObrY:=54;
  IUhol:=5;
  IUholNatocenia:=5;
  ElevacnyUhol:=pi/12;
  DejRot.Aktivny:=False;
  AktSnimVyfuk:=5;
  for i:=1 to MaxPocetNab do begin
    Naboj[i].Aktivny:=False;
    Vybuch[i].Aktivny:=False;
    Naboj[i].t0:=0;
  end;
  PoZvysok:=0;
  for i:=0 to 9 do Zvysok[i].Aktivny:=False;
  Zivot:=60;
end;
procedure TTank2.ObnovNastavenia;
begin
  ObrX:=321-76;
  ObrY:=54;
  IUhol:=15;
  IUholNatocenia:=15;
  ElevacnyUhol:=pi/12;
  DejRot.Aktivny:=False;
  AktSnimVyfuk:=10;
  for i:=1 to MaxPocetNab do begin
    Naboj[i].Aktivny:=False;
    Vybuch[i].Aktivny:=False;
    Naboj[i].t0:=0;
  end;
  PoZvysok:=0;
  for i:=0 to 9 do Zvysok[i].Aktivny:=False;
  Zivot:=60;
end;
procedure TTank3.ObnovNastavenia;
begin
  ObrX:=76;
  ObrY:=200-54;
  IUhol:=35;
  IUholNatocenia:=35;
  ElevacnyUhol:=pi/12;
  DejRot.Aktivny:=False;
  AktSnimVyfuk:=15;
  for i:=1 to MaxPocetNab do begin
    Naboj[i].Aktivny:=False;
    Vybuch[i].Aktivny:=False;
    Naboj[i].t0:=0;
  end;
  PoZvysok:=0;
  for i:=0 to 9 do Zvysok[i].Aktivny:=False;
  Zivot:=60;
end;
procedure TTank4.ObnovNastavenia;
begin
  ObrX:=321-76;
  ObrY:=200-54;
  IUhol:=25;
  IUholNatocenia:=25;
  ElevacnyUhol:=pi/12;
  DejRot.Aktivny:=False;
  AktSnimVyfuk:=20;
  for i:=1 to MaxPocetNab do begin
    Naboj[i].Aktivny:=False;
    Vybuch[i].Aktivny:=False;
    Naboj[i].t0:=0;
  end;
  PoZvysok:=0;
  for i:=0 to 9 do Zvysok[i].Aktivny:=False;
  Zivot:=60;
end;
procedure TTank.VycisliDrahyNabojov;
var u:real;
    t:longint;
begin
{ max. vyska je Rychlostý * siný(ElevacnyUhol) / 2 / g ( somarina) }
  for i:=1 to MaxPocetNab do
    if Naboj[i].Aktivny then begin
      u:=Naboj[i].Smer*pi/20;
      t:=RealTime.AktCas-Naboj[i].t0;
      Naboj[i].x:=Round(Naboj[i].x0 + cos(u) *
                  cos(Naboj[i].ElevacnyUhol) * t * Naboj[i].Rychlost);
      Naboj[i].y:=Round(Naboj[i].y0 + sin(u) *
                  cos(Naboj[i].ElevacnyUhol) * t * Naboj[i].Rychlost);
      Naboj[i].z:=Round(Naboj[i].Rychlost *
                  t * sin(Naboj[i].ElevacnyUhol) - t * t * RealTime.g / 2);
    end;
end;
procedure TTank.ZistiDopadNabojov;
begin
  for i:=1 to MaxPocetNab do begin
    if (Naboj[i].Aktivny) and
       (Naboj[i].z<0) and
       (not Vybuch[i].Aktivny) then begin
      Vybuch[i].Aktivny:=True; { pridanie vybuchu }
      Vybuch[i].x0:=Naboj[i].x;
      Vybuch[i].y0:=Naboj[i].y;
      Vybuch[i].t0:=RealTime.AktCas;
      Naboj[i].Aktivny:=False; { zrusenie naboja }
      if (Abs(Tank1.x-Vybuch[i].x0)<25) and
         (Abs(Tank1.y-Vybuch[i].y0)<25) and
         (Menu.Hrac[1]>1) then begin
           j:=Tank1.Zivot;
           Dec(Tank1.Zivot,Random(6)+8);
           if Tank1.Zivot<=0 then begin
             Tank1.Zivot:=0;
             if j>0 then begin
               Inc(Tank1.Body,PocetMrtvychTankov-1);
               Tank1.CasSmrti:=RealTime.AktCas;
               Inc(Body);
             end;
           end;
         end;
      if (Abs(Tank2.x-Vybuch[i].x0)<25) and
         (Abs(Tank2.y-Vybuch[i].y0)<25) and
         (Menu.Hrac[2]>1) then begin
           j:=Tank2.Zivot;
           Dec(Tank2.Zivot,Random(6)+8);
           if Tank2.Zivot<=0 then begin
             Tank2.Zivot:=0;
             if j>0 then begin
               Inc(Tank2.Body,PocetMrtvychTankov-1);
               Tank2.CasSmrti:=RealTime.AktCas;
               Inc(Body);
             end;
           end;
         end;
      if (Abs(Tank3.x-Vybuch[i].x0)<25) and
         (Abs(Tank3.y-Vybuch[i].y0)<25) and
         (Menu.Hrac[3]>1) then begin
           j:=Tank3.Zivot;
           Dec(Tank3.Zivot,Random(6)+8);
           if Tank3.Zivot<=0 then begin
             Tank3.Zivot:=0;
             if j>0 then begin
               Inc(Tank3.Body,PocetMrtvychTankov-1);
               Tank3.CasSmrti:=RealTime.AktCas;
               Inc(Body);
             end;
           end;
         end;
      if (Abs(Tank4.x-Vybuch[i].x0)<25) and
         (Abs(Tank4.y-Vybuch[i].y0)<25) and
         (Menu.Hrac[4]>1) then begin
           j:=Tank4.Zivot;
           Dec(Tank4.Zivot,Random(6)+8);
           if Tank4.Zivot<=0 then begin
             Tank4.Zivot:=0;
             if j>0 then begin
               Inc(Tank4.Body,PocetMrtvychTankov-1);
               Tank4.CasSmrti:=RealTime.AktCas;
               Inc(Body);
             end;
           end;
         end;
    end;
    if (Vybuch[i].t0<RealTime.AktCas-16*3) and
       (Vybuch[i].Aktivny) then begin{ ukoncenie vybuchu }
      Vybuch[i].Aktivny:=False;
      bool:=False; { ci uz je na zozname }
      for j:=0 to 9 do
        if (Zvysok[j].Aktivny) and
           (Zvysok[j].x0=Vybuch[i].x0) and (Zvysok[j].y0=Vybuch[i].y0) then bool:=True;
      if not bool then begin
        Zvysok[PoZvysok].x0:=Vybuch[i].x0;
        Zvysok[PoZvysok].y0:=Vybuch[i].y0;
        Zvysok[PoZvysok].Aktivny:=True;
        PoZvysok:=(PoZvysok+1) mod 10;
      end;
    end;
    if (Naboj[i].x<0) or (Naboj[i].x>Menu.RozX*16-22) or { vyletenie mimo obr.}
       (Naboj[i].y<0) or (Naboj[i].y>Menu.RozY*16-22) then begin
      Naboj[i].Aktivny:=False;
      Vybuch[i].Aktivny:=False;
    end;
  end;
end;
procedure TTank.VratStavOvladania;
var DeltaXM,DeltaYM,DeltaXJ,DeltaYJ:integer;
begin
  for j:=1 to 6 do Self.AktPovel[j]:=False;
  if Menu.Hrac[PorCislo]=2 then begin { ked je to clovek }

    for j:=1 to 6 do { klavesnica }
      case Self.DefPovel[j] of
        #0..#127:if Zoznam^[byte(Self.DefPovel[j])]>0 then
                   Self.AktPovel[j]:=True; { je v zozname klaves}
        #129:if StavLock and KPShift>0 then Self.AktPovel[j]:=True;
        #130:if StavLock and KLShift>0 then Self.AktPovel[j]:=True;
        #131:if StavLock and KCtrl>0 then Self.AktPovel[j]:=True;
        #132:if StavLock and KAlt>0 then Self.AktPovel[j]:=True;
      end; { case }

    if Self.DefPovel[1]=#254 then begin { mys }
      Mys.ZistiPoziciu(word(Povel.MysX),word(Povel.MysY),Povel.MTlac);
      Povel.MysX:=Povel.MysX div 2;
      DeltaXM:=Povel.MysX-Povel.MysXStare;
      DeltaYM:=Povel.MysY-Povel.MysYStare;
      if (Abs(DeltaXM)<Abs(DeltaYM)) and (DeltaYM< 0) then Self.AktPovel[1]:=True;
      if (Abs(DeltaXM)<Abs(DeltaYM)) and (DeltaYM> 0) then Self.AktPovel[2]:=True;
      if (Abs(DeltaXM)>Abs(DeltaYM)) and (DeltaXM> 5) then Self.AktPovel[3]:=True;
      if (Abs(DeltaXM)>Abs(DeltaYM)) and (DeltaXM<-5) then Self.AktPovel[4]:=True;
      if Povel.MTlac=Lave then Self.AktPovel[5]:=True;
      if Povel.MTlac=Prave then Self.AktPovel[6]:=True;
      Povel.MysXStare:=160;
      Povel.MysYStare:=100;
      Mys.NastavKurzor(320,100);
    end;

    if Self.DefPovel[1]=#255 then begin { joystick }
      Joystick.ZistiPoziciu(word(Povel.JXAkt),word(Povel.JYAkt),Povel.JTlac);
      if Povel.JYAkt<(Povel.JYStred*8) div 10 then Self.AktPovel[1]:=True;
      if Povel.JYAkt>(Povel.JYStred*12) div 10 then Self.AktPovel[2]:=True;
      if Povel.JXAkt<(Povel.JXStred*8) div 10 then Self.AktPovel[3]:=True;
      if Povel.JXAkt>(Povel.JXStred*12) div 10 then Self.AktPovel[4]:=True;
      if Povel.JTlac=Lave then Self.AktPovel[5]:=True;
      if Povel.JTlac=Prave then Self.AktPovel[6]:=True;
    end;
  end;
end;
function TTank.TestVzdialenosti(Ktory:integer;TestX,TestY:real):boolean;
var TestVzdialenost:boolean;             {TestX/Y bolo integer}
begin
  TestVzdialenost:=True;
  if Ktory in [2,3,4] then begin
    if (Menu.Hrac[1]>1) and (Abs(Tank1.x-TestX)<25) and (Abs(Tank1.y-TestY)<25) then TestVzdialenost:=False;
  end;
  if Ktory in [1,3,4] then begin
    if (Menu.Hrac[2]>1) and (Abs(Tank2.x-TestX)<25) and (Abs(Tank2.y-TestY)<25) then TestVzdialenost:=False;
  end;
  if Ktory in [1,2,4] then begin
    if (Menu.Hrac[3]>1) and (Abs(Tank3.x-TestX)<25) and (Abs(Tank3.y-TestY)<25) then TestVzdialenost:=False;
  end;
  if Ktory in [1,2,3] then begin
    if (Menu.Hrac[4]>1) and (Abs(Tank4.x-TestX)<25) and (Abs(Tank4.y-TestY)<25) then TestVzdialenost:=False;
  end;
  TestVzdialenosti:=TestVzdialenost;
end;

procedure TTank.PosunTank(DeltaX,DeltaY:real);
begin
  case PorCislo of
    1:if (TestVzdialenosti(1,Tank1.x+DeltaX,Tank1.y+DeltaY)) and
         (Tank1.x+DeltaX<Menu.RozX*16-76) and (Tank1.y+DeltaY<Menu.RozY*16-56) and
         (Tank1.x+DeltaX>             76) and (Tank1.y+DeltaY>             20) then begin
      Tank1.xr:=Tank1.xr+DeltaX;   { bolo Tank1.x:= ... }
      Tank1.yr:=Tank1.yr+DeltaY;
      Tank1.x:=Round(Tank1.xr);    { nebolo to tu }
      Tank1.y:=Round(Tank1.yr);
    end;
    2:if TestVzdialenosti(2,Tank2.x+DeltaX,Tank2.y+DeltaY) and
         (Tank2.x+DeltaX<Menu.RozX*16-76) and (Tank2.y+DeltaY<Menu.RozY*16-56) and
         (Tank2.x+DeltaX>             76) and (Tank2.y+DeltaY>             20) then begin
      Tank2.xr:=Tank2.xr+DeltaX;
      Tank2.yr:=Tank2.yr+DeltaY;
      Tank2.x:=Round(Tank2.xr);
      Tank2.y:=Round(Tank2.yr);
    end;
    3:if TestVzdialenosti(3,Tank3.x+DeltaX,Tank3.y+DeltaY) and
         (Tank3.x+DeltaX<Menu.RozX*16-76) and (Tank3.y+DeltaY<Menu.RozY*16-56) and
         (Tank3.x+DeltaX>             76) and (Tank3.y+DeltaY>             20) then begin
      Tank3.xr:=Tank3.xr+DeltaX;
      Tank3.yr:=Tank3.yr+DeltaY;
      Tank3.x:=Round(Tank3.xr);
      Tank3.y:=Round(Tank3.yr);
    end;
    4:if TestVzdialenosti(4,Tank4.x+DeltaX,Tank4.y+DeltaY) and
         (Tank4.x+DeltaX<Menu.RozX*16-76) and (Tank4.y+DeltaY<Menu.RozY*16-56) and
         (Tank4.x+DeltaX>             76) and (Tank4.y+DeltaY>             20) then begin
      Tank4.xr:=Tank4.xr+DeltaX;
      Tank4.yr:=Tank4.yr+DeltaY;
      Tank4.x:=Round(Tank4.xr);
      Tank4.y:=Round(Tank4.yr);
    end;
  end;
end;
procedure TTank.SpracujOvladanie;
  function KalkSmerX(param:integer):shortint;{ bolo shortint }
  begin
{    KalkSmerX:=Cos(param*pi/20);}
    case Param of
      15,20,25:KalkSmerX:=-1;
      35,0,5:KalkSmerX:=1;
      else KalkSmerX:=0;
    end;
  end;
  function KalkSmerY(param:integer):shortint;
  begin
{   KalkSmerY:=Sin(param*pi/20);}
    case param of
      5,10,15:KalkSmerY:=1;
      25,30,35:KalkSmerY:=-1;
      else KalkSmerY:=0;
    end;
  end;
  function Vzdialenost(c1,c2:integer):integer; { vzdialenost dvoch cisel na mnozine 0..39 }
  var pom:integer;
  begin
    if c1>c2 then pom:=c1-c2 else pom:=c2-c1;
    if pom>19 then pom:=39-pom;
    Vzdialenost:=pom;
  end;
begin
  if not((DefPovel[1]=#255) and (Povel.Kalibrovany=False)) then
    if Zivot>0 then begin { toto vsetko mozes robit, ak zijes }
      if (AktPovel[1]) and not(AktPovel[6]) and not(DejRot.Aktivny) then { dopredu }
        PosunTank(KalkSmerX(IUhol)*RealTime.DeltaT,KalksmerY(IUhol)*RealTime.DeltaT);
      if (AktPovel[2]) and not(AktPovel[6]) and not(DejRot.Aktivny) then { dozadu }
        PosunTank(-KalkSmerX(IUhol)*RealTime.DeltaT,-KalksmerY(IUhol)*RealTime.DeltaT);
      if (AktPovel[3]) and not(AktPovel[6]) then begin { vlavo }
{odtial Dec(IUhol,RealTime.DeltaT);
        Dec(IUholNatocenia,RealTime.DeltaT);
        if IUhol<0 then IUhol:=IUhol+40;
        if IUholNatocenia<0 then IUholNatocenia:=IUholNatocenia+40; potial pridane }
        if not DejRot.Aktivny then begin
          DejRot.t0:=RealTime.AktCas;
          DejRot.StaraPos:=IUhol;
          DejRot.DeltaPos:=-1;
        end;
        DejRot.Aktivny:=True;
      end;
      if AktPovel[4] and not(AktPovel[6]) then begin { vpravo }
{odtial Inc(IUhol,RealTime.DeltaT);
        Inc(IUholNatocenia,RealTime.DeltaT);
        if IUhol>39 then IUhol:=IUhol-40;
        if IUholNatocenia>39 then IUholNatocenia:=IUholNatocenia-40; potial pridane }
        if not DejRot.Aktivny then begin
          DejRot.t0:=RealTime.AktCas;
          DejRot.StaraPos:=IUhol;
          DejRot.DeltaPos:=1;
        end;
        DejRot.Aktivny:=True;
      end;
      if (AktPovel[3]) and (AktPovel[6]) then begin { hlaven vlavo }
        Dec(IUholNatocenia,RealTime.DeltaT);
        if IUholNatocenia<0 then IUholNatocenia:=39;
      end;
      if (AktPovel[4]) and (AktPovel[6]) then begin { hlaven vpravo }
        Inc(IUholNatocenia,RealTime.DeltaT);
        if IUholNatocenia>39 then IUholNatocenia:=0;
      end;
      if (AktPovel[1]) and (AktPovel[6]) then { hlaven dole }
        if ElevacnyUhol<pi/3 then begin
          ElevacnyUhol:=ElevacnyUhol+pi/180*RealTime.DeltaT;
          Menu.VypisElevacnyUhol;
        end;
      if (AktPovel[2]) and (AktPovel[6]) then { hlaven hore }
        if ElevacnyUhol>0 then begin
          ElevacnyUhol:=ElevacnyUhol-pi/180*RealTime.DeltaT;
          Menu.VypisElevacnyUhol;
        end;
      if AktPovel[5] then begin
        j:=-1; { kam ho zaradit }
        for i:=1 to MaxPocetNab do { skontroluj casy vystrelenia }
          if (Naboj[i].t0>RealTime.AktCas-30) or (j=0) then j:=0;
        if j=-1 then begin
          for i:=1 to MaxPocetNab do begin
          if (not Naboj[i].Aktivny) and
             (not Vybuch[i].Aktivny) then j:=i;
          if j>0 then begin { pridaj k nabojom }
              Naboj[j].Aktivny:=True;
              Naboj[j].Rychlost:=8;
              Naboj[j].t0:=RealTime.AktCas;
              Naboj[j].ElevacnyUhol:=ElevacnyUhol;
              Naboj[j].Smer:=IUholNatocenia;
              k:= 12 - 2 * Trunc(ElevacnyUhol*9/pi);
              Naboj[j].x0:=Round(x + k * cos(pi / 20 * IUholNatocenia));
              Naboj[j].y0:=Round(y + k * sin(pi / 20 * IUholNatocenia));
              Break;
            end;
          end;
        end;
      end;
      if DejRot.Aktivny then begin { spracovanie rotacie tanku }
        IUhol         :=IUhol         +RealTime.DeltaT*DejRot.DeltaPos;
        IUholNatocenia:=IUholNatocenia+RealTime.DeltaT*DejRot.DeltaPos;
        if Vzdialenost(IUhol,DejRot.StaraPos)>=5 then begin
          i:=IUhol-IUholNatocenia;
          IUhol:=DejRot.StaraPos+5*DejRot.DeltaPos;
          IUholNatocenia:=IUhol-i;
          DejRot.Aktivny:=False;
        end;
        if IUhol<0 then IUhol:=IUhol+40;
        if IUhol>39 then IUhol:=IUhol-40;
        if IUholNatocenia<0 then IUholNatocenia:=IUholNatocenia+40;
        if IUholNatocenia>39 then IUholNatocenia:=IUholNatocenia-40;
      end;
      if RealTime.AktCas mod 3 = 0 then AktSnimVyfuk:=AktSnimVyfuk+1; { vyfuk }
      if AktSnimVyfuk>20 then AktSnimVyfuk:=1;
    end;
end;
function TTank.PocetMrtvychTankov:shortint;
var ii:shortint;
begin
  ii:=4;
  if Tank1.Zivot>0 then Dec(ii);
  if Tank2.Zivot>0 then Dec(ii);
  if Tank3.Zivot>0 then Dec(ii);
  if Tank4.Zivot>0 then Dec(ii);
  PocetMrtvychTankov:=ii;
end;
procedure TTank.VypisStavOvladania;
begin
  for i:=0 to 5 do begin
    s:='';
    if DefPovel[i+1]<#128 then s:=s+Chr(KodNaZnak(Ord(DefPovel[i+1])));
    if s=#0 then s:='';
    case DefPovel[i+1] of
      #$01:s:='Esc';
      #$0E:s:='BkSp';
      #$0F:s:='Tab';
      #$1C:s:='Enter';
      #$39:s:='Space';
      #$47:s:='Home';
      #$48:s:='Hore';
      #$49:s:='PgUp';
      #$4B:s:='Vlavo';
      #$4D:s:='Vpra..';
      #$4F:s:='End';
      #$50:s:='Dole';
      #$51:s:='PgDn';
      #$52:s:='Ins';
      #$53:s:='Del';
      #$3B:s:='F1';
      #$3C:s:='F2';
      #$3D:s:='F3';
      #$3E:s:='F4';
      #$3F:s:='F5';
      #$40:s:='F6';
      #$41:s:='F7';
      #$42:s:='F8';
      #$43:s:='F9';
      #$44:s:='F10';
      #129:s:='PShift';
      #130:s:='LShift';
      #131:s:='Ctrl';
      #132:s:='Alt';
      #254:s:='Mys';
      #255:s:='Joy..';
    end; { case }
    case i+1 of
      1:begin j:=37;  k:=83;  end;
      2:begin j:=107; k:=83;  end;
      3:begin j:=37;  k:=66;  end;
      4:begin j:=107; k:=66;  end;
      5:begin j:=37;  k:=100; end;
      6:begin j:=107; k:=100; end;
    end;
    if PorCislo in [2,4] then Inc(j,150);
    if PorCislo in [3,4] then Inc(k,75);
    PrilepBMP(j,k,Menu.MBP[29]);
    VypisP(j+3,k+2,Menu.MSFP[1],s,Zlta);
  end; { for }
end;

