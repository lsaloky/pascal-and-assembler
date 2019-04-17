program Sestuholnikova_siet;
uses Graph;
const SirkaMapy=20;VyskaMapy=20;
      DlzkaStrany=15;
      PrvyX=2;PoslX=9;PrvyY=1;PoslY=6;
      MinX:integer=0;MinY:integer=0;MaxX:integer=319;MaxY:integer=199;
      Sus:array[1..12,1..2]of shortint=((0,-1),(1,-1),(1,0),(0,1),(-1,0),(-1,-1),(0,-1),(1,0),(1,1),(0,1),(-1,1),(-1,0));
      Gd:integer=1;gm:integer=2;Cesta:string='d:\bp\bgi';
      {susedne policka pre parne xove suradnice =1.sestica, neparne 2.sestica}
type TMapa=array[0..SirkaMapy,0..VyskaMapy] of byte;
     TrueColor=record
       R,G,B:byte;{vyuziva sa len dolnych 6 bitov, celkove 262144 farieb}
     end;
var x,y,relx,rely:integer;
    V,Vp:TMapa;{index poli vo vyreze,0 znamena bez pristupu. Vp - pomocne pole pri fillovani}
    p:array[0..255] of TrueColor;                       {paleta}
    s,t,mapa:string;
    fmap:file;

{a$I rutiny.pas}
procedure KresliSiet;
var ic1,ic2,ic3:integer;
begin
  ic2:=0;
  while ic2<maxy+DlzkaStrany do begin
    for ic1:=1 to 2 do begin
      if ic1=1 then ic3:=relx
      else ic3:=-DlzkaStrany;
      SetColor(1);
      while ic3<maxx+DlzkaStrany do begin
        Line(ic3,ic2,ic3+DlzkaStrany,ic2);
        Line(ic3,ic2,ic3-relx,ic2+rely);
        Line(ic3+DlzkaStrany,ic2,ic3+DlzkaStrany+relx,ic2+rely);
        ic3:=ic3+3*DlzkaStrany;
      end;
      ic2:=ic2+rely;
    end;
  end;
end;

procedure KresliVyrez;
type THranicneBodyVyrezu=record
                     xmin,xmax,ymin,ymax:integer;
                   end;
var HBV:THranicneBodyVyrezu;
begin
  SetColor(2);
  HBV.xmin:=3*DlzkaStrany*PrvyX div 2-1;
  HBV.xmax:=3*DlzkaStrany*(PoslX+1) div 2+relx+1;
  HBV.ymin:=rely*(2*PrvyY+PrvyX mod 2)-1;
  HBV.ymax:=rely*(2*(PoslY+1)+(PoslX+1) mod 2)+rely+1;
  Line(HBV.xmin,HBV.ymin,HBV.xmax,HBV.ymin);
  Line(HBV.xmax,HBV.ymin,HBV.xmax,HBV.ymax);
  Line(HBV.xmax,HBV.ymax,HBV.xmin,HBV.ymax);
  Line(HBV.xmin,HBV.ymax,HBV.xmin,HBV.ymin);
end;

procedure VyznacSusednePolicka(vx,vy,vzdial:integer);{globalne premenne+: sus,Vp}
var ic1,ipomx,ipomy:integer;
begin
{  if Vp[vx,vy]=0 then FloodFill(3*DlzkaStrany*vx div 2+DlzkaStrany,rely*(2*vy+vx mod 2+1),2);
  vp[vx,vy]:=vzdial;
  for ic1:=1+6*(vx mod 2) to 6+6*(vx mod 2) do begin
    ipomx:=vx+sus[ic1,1];
    ipomy:=vy+sus[ic1,2];
    if (ipomx>=PrvyX) and (ipomx<=PoslX) and (ipomy>PrvyY) and (ipomy<PoslY)
    and (vzdial>V[ipomx,ipomy]) and (vp[ipomx,ipomy]<vzdial)
    then VyznacSusednePolicka(ipomx,ipomy,vzdial-V[ipomx,ipomy]);
  end;                                                           }
end;

BEGIN
  InitGraph(gd,gm,Cesta);
  mapa:='intro.map';
  Assign(fmap,mapa);
{  Reset(fmap);}
  relx:=DlzkaStrany div 2;
  rely:=Round((DlzkaStrany div 2)*Sqrt(3));
  for x:=0 to SirkaMapy do                {----- naplnenie pola V datami -----}
    for y:=0 to VyskaMapy do
      v[x,y]:=0;
  for x:=PrvyX to PoslX do
    for y:=PrvyY to PoslY do
      V[x,y]:=random(4)+1;
  KresliSiet;
  KresliVyrez;
(*  SetFillStyle(1,1);                {----- vyplnovanie aktivnych ploch -----}
  for x:=PrvyX to PoslX do
    for y:=PrvyY to PoslY do
      FloodFill(3*DlzkaStrany*x div 2+DlzkaStrany,rely*(2*y+x mod 2+1),2);
  SetColor(3);
  for x:=0 to (maxx div DlzkaStrany*2) div 3 do
    for y:=0 to maxy div rely div 2 do begin
      Str(x,s);
      Str(y,t);
      s:=s+','+t;
      OutTextXY((x*(3*DlzkaStrany)+DlzkaStrany*2-24) div 2,y*rely*2+rely*(x mod 2)+(rely*2-8) div 2,s);
    end;*)
  for x:=0 to 10 do
    for y:=0 to 10 do
      Vp[x,y]:=0;
  VyznacSusednePolicka(PrvyX+7,PrvyY+8,6);
  readln;
  CloseGraph;
END.
