program Priklad_3;
uses Graph;
const Cesta='d:\bp\bgi';
      mierka=10;
var s,t:string;
    x,Gd,Gm,pocet,dlzka,uhol,opakuj,pomocne,AktUhol,PosX,PosY:integer;

function Vyber:integer;
var pom,pom2,pom3,znam:integer;
begin
  Delete(s,1,1);
  znam:=1;
  if s[1]='-' then begin
    Delete(s,1,1);
    znam:=-1;
  end;
  pom:=1;
  while ('0'<=s[pom]) and ('9' >=s[pom]) do Inc(pom);
  t:=copy(s,1,pom-1);
  Val(t,pom3,pom2);
  Delete(s,1,pom-1);
  Vyber:=pom3*znam;
end;

BEGIN
  DetectGraph(Gd,Gm);
  InitGraph(Gd,Gm,Cesta);
  SetColor(15);
  MoveTo(320,240);PosX:=320;PosY:=240;AktUhol:=0;
  s:='[2[-7 30] 3[2 90]]';
  pocet:=1;opakuj:=1;
  while pocet>0 do begin
    pomocne:=Vyber;
    if s[1]='[' then begin
      opakuj:=opakuj*pomocne;
      Inc(pocet);
    end;
    if (s[1]=' ') and (pocet<>1) then begin
      dlzka:=pomocne;
      uhol:=Vyber;
    end;
    if s[1]=']' then Dec(pocet);
    if pocet=1 then begin
      for x:=1 to opakuj do begin
        PosX:=Round(Posx+dlzka*mierka*sin(AktUhol*Pi/180));
        PosY:=Round(PosY-dlzka*mierka*cos(AktUhol*Pi/180));
        AktUhol:=AktUhol+uhol;
        if AktUhol>359 then AktUhol:=AktUhol mod 360;
        LineTo(PosX,PosY);
      end;
      opakuj:=1;
      Delete(s,1,1);
    end;
  end;
  readln;
END.