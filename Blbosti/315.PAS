program O_ekvivalenciach;
{grafovy algoritmus - hladanie cesty v neorientovanom neohodnotenom grafe
reprezentovanom maticou susednosti}
const MaxNum=10;PocetVstupov=5;
      Vstup:array[1..PocetVstupov,1..2] of 1..Maxnum=((1,2),(2,3),(2,5),(7,5),(8,8));
      Dnu=1;Von=7;
type TPouzity=array[1..MaxNum] of boolean;
var Graf:array[1..MaxNum,1..MaxNum] of byte;
    x,y:word;
    Najdeny:boolean;
    Cesta:array[1..MaxNum] of byte;
    Pouzity:TPouzity;
{ ----- prehladavanie do hlbky ----- }
procedure Dalsi(px,Ktory:byte;Pouzity:TPouzity);
var py:word;
begin
  Inc(Ktory);
  if px=Von then Najdeny:=true
  else for py:=1 to MaxNum do
    if (Graf[px,py]=1) and (not Pouzity[py]) and (not Najdeny) then begin
      Pouzity[px]:=true;
      Cesta[Ktory]:=px;
      Dalsi(py,Ktory,Pouzity);
    end;{if}
  {if else}
end;{proc}
BEGIN
  WriteLn;
  for x:=1 to MaxNum do Pouzity[x]:=false;
  for x:=1 to PocetVstupov do begin
    Graf[Vstup[x,1],Vstup[x,2]]:=1;
    Graf[Vstup[x,2],Vstup[x,1]]:=1;
  end;
  Dalsi(Dnu,0,Pouzity);
  x:=1;
  while Cesta[x]<>0 do begin
    write(Cesta[x],' ');
    Inc(x);
  end;
  WriteLn(Von);
END.