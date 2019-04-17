constructor TPocHrac.Init;
begin
  PocHrac[1].JeRozhodnute:=False;
  PocHrac[2].JeRozhodnute:=False;
  PocHrac[3].JeRozhodnute:=False;
  PocHrac[4].JeRozhodnute:=False;
  PocHrac[1].PorCislo:=1;
  PocHrac[2].PorCislo:=2;
  PocHrac[3].PorCislo:=3;
  PocHrac[4].PorCislo:=4;
  PocHrac[1].v0:=8; { musi sa zhodovat s TTank.INC, riadok 388 (pridavanie naboja) }
  PocHrac[2].v0:=8;
  PocHrac[3].v0:=8;
  PocHrac[4].v0:=8;
  PocHrac[1].Nepriatel:=0;
  PocHrac[2].Nepriatel:=0;
  PocHrac[3].Nepriatel:=0;
  PocHrac[4].Nepriatel:=0;
  PocHrac[1].MojTank:=Addr(Tank1);
  PocHrac[2].MojTank:=Addr(Tank2);
  PocHrac[3].MojTank:=Addr(Tank3);
  PocHrac[4].MojTank:=Addr(Tank4);
end;
function TPocHrac.ArcSin(x:real):real;
begin
  if x<-1 then ArcSin:=-pi/2
    else if x>1 then ArcSin:=pi/2
      else if x=0 then ArcSin:=0
        else ArcSin:=ArcTan(x/Sqrt(1-Sqr(x)));
end;
function TPocHrac.ArcCos(x:real):real;
begin
  if x<-1 then ArcCos:=pi
    else if x>1 then ArcCos:=0
      else if x=0 then ArcCos:=pi/2
        else ArcCos:=ArcTan(Sqrt(1-Sqr(x))/x);
end;
procedure TPocHrac.ZamerajStojaciCiel;
begin
  xc:=PocHrac[Nepriatel].MojTank^.x;
  yc:=PocHrac[Nepriatel].MojTank^.y;
  d:=Sqrt((xc-xz)*(xc-xz)+(yc-yz)*(yc-yz));
  UholE:=arcsin(RealTime.g*d/v0/v0)/2;
  UholN:=arccos(Abs((xc-xz))/d);
  if xc-xz<0 then UholN:=pi-UholN;
  if yc-yz<0 then UholN:=2*pi-UholN;
end;
procedure TPocHrac.ZamerajIduciCiel;
begin
end;
procedure TPocHrac.Konaj;
begin
  for i:=1 to 6 do MojTank^.AktPovel[i]:=False;
  if not JeRozhodnute then begin
    repeat
{      Nepriatel:=Random(4)+1;}
{!!!!!} Nepriatel:=1;
      i:=PocHrac[Nepriatel].MojTank^.Zivot;
    until (Nepriatel<>PorCislo) and (i>0) and (Menu.Hrac[Nepriatel]>1);
    xz:=MojTank^.x;yz:=MojTank^.y;
    ZamerajStojaciCiel;
  end;
  with MojTank^ do begin
    UholNS:=IUholNatocenia*pi/20;
{ ----- natocenie veze ----- }
    if UholNS+pi/20<UholN then begin
      AktPovel[6]:=True;
      AktPovel[4]:=True;
    end;
    if UholNS-pi/20>UholN then begin
      AktPovel[6]:=True;
      AktPovel[3]:=True;
    end;
{ pred tymto nesmie byt nastavovanie hlavne tanku !!!!! }
    if (UholNS>7*pi/4) and (UholN<pi/4) and (MojTank^.AktPovel[6]=True) then begin
      AktPovel[4]:=True;
      AktPovel[3]:=False;
    end;
    if (UholNS<pi/4) and (UholN>7*pi/4) and (MojTank^.AktPovel[6]=True) then begin
      AktPovel[4]:=False;
      AktPovel[3]:=True;
    end;
{ ----- elevacny uhol ----- }
    if MojTank^.ElevacnyUhol+pi/180<UholE then begin
      AktPovel[6]:=True;
      AktPovel[1]:=True;
    end;
    if MojTank^.ElevacnyUhol-pi/180>UholE then begin
      AktPovel[6]:=True;
      AktPovel[2]:=True;
    end;
  {!!!!!}   if (AktPovel[6]=False) and (x<200) then
              AktPovel[1]:=True;
  end;
end;