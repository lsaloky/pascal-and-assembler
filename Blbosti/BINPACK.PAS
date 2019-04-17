program BBNLuba_BINPACK;
var fin,fout:text;
    limit,pocet,k1,k2,pockrab,x,y:word;
    {vahovy limit,pocet vyrobkov,krabice,pocet krabic,pomocne premenne}
BEGIN
  Assign(fin,'binpack.in');
  Reset(fin);
  Assign(fout,'binpack.out');
  ReWrite(fout);
  k1:=0;k2:=0;pockrab:=0;
  read(fin,limit,pocet);
  for x:=1 to pocet do begin
    read(fin,y);
    if k1+y=limit then begin  {akurat pasuje do 1. krabice}
      k1:=0;
      y:=0;
      Inc(pockrab);
    end;
    if k2+y=limit then begin {akurat do 2.}
      k2:=0;
      y:=0;
      Inc(pockrab);
    end;
    if k1<=k2 then begin         {k1 je prazdnejsia}
      if k1+y<limit then k1:=k1+y{prida do nej, ak vojde}
      else begin
        k2:=y;                   {odosle plnsiu krabicu, ak nema kam vlozit}
        Inc(pockrab);
      end;
    end else begin               {k2 je prazdnejsia}
      if k2+y<limit then k2:=k2+y{prida do nej, ak vojde}
      else begin
        k1:=y;                   {odosle plnsiu krabicu, ak nema kam vlozit}
        Inc(pockrab);
      end;
    end;
  end;
  if k1>0 then Inc(pockrab);
  if k2>0 then Inc(pockrab);
  writeln(fout,pockrab);
  Close(fin);
  Close(fout);
end.