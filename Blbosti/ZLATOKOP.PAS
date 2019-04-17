program Zlatokop;
var fin,fout:text;
    x,y,n:word;
    p:array[1..2,1..4,0..1] of word;
 {p[1,x,y]=1. obdlznik, p[x,1,y]=1. roh obdlznika,p[x,y,1]=x-ova suradnica}
procedure Kontroluj(co,i1,i2,sur:word);{ak patri roh s i1 na miesto i2, tak vymen}
var pom1:word;
begin
  if p[co,i1,sur]<p[co,i2,sur] then begin
    pom1:=p[co,i1,sur];
    p[co,i1,sur]:=p[co,i2,sur];
    p[co,i2,sur]:=pom1;
    pom1:=p[co,i1,1-sur];
    p[co,i1,1-sur]:=p[co,i2,1-sur];
    p[co,i2,1-sur]:=pom1;
  end;
end;
procedure Nastav(co,i1,i2,toto:word);{toto je vrchol, z ktoreho treba zobrat sur. pre 4. vrchol}
begin
  if p[co,i1,0]=p[co,i2,0] then p[co,4,0]:=p[co,toto,0];
  if p[co,i1,1]=p[co,i2,1] then p[co,4,1]:=p[co,toto,1];
end;
function PrekryvX:boolean;
begin
  if (p[1,2,0]<=p[2,1,0]) or (p[2,2,0]<=p[1,1,0]) then PrekryvX:=false
  else PrekryvX:=true;
end;
function PrekryvY:boolean;
begin
  if (p[1,3,1]<=p[2,1,1]) or (p[2,3,1]<=p[1,1,1]) then PrekryvY:=false
  else PrekryvY:=true;
end;

BEGIN
  Assign(fin,'zlatokop.in');
  Reset(fin);
  Assign(fout,'zlatokop.out');
  Rewrite(fout);
  Read(fin,n);
  for y:=1 to n do begin
    Read(fin,p[1,1,0],p[1,1,1],p[1,2,0],p[1,2,1],p[1,3,0],p[1,3,1]);
    Read(fin,p[2,1,0],p[2,1,1],p[2,2,0],p[2,2,1],p[2,3,0],p[2,3,1]);
    for x:=1 to 2 do begin
      Nastav(x,1,2,3);
      Nastav(x,2,3,1);
      Nastav(x,1,3,2);
      Kontroluj(x,2,1,1);    {usporiadaj vrcholy takto:}
      Kontroluj(x,3,1,1);    {1.     2.}
      Kontroluj(x,4,1,1);    {3.     4.}
      Kontroluj(x,3,2,1);
      Kontroluj(x,4,2,1);   {teraz su uz usporiadane y-ove suradnice}
      Kontroluj(x,2,1,0);
      Kontroluj(x,4,3,0);
    end;
    if PrekryvX and PrekryvY then writeln(fout,'ano')
    else writeln(fout,'nie');
  end;
  Close(fin);
  Close(fout);
END.