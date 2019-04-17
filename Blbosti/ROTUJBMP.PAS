program Rotacia_bitovej_mapy;{nefunguje}
uses Graph;
type TRotuj=array[1..200,1..200]of byte;
     BitMap=array[0..79,0..479]of byte;
const gd:integer=1;
      gm:integer=2;
      cesta='d:\bp\bgi';
      sx=100;
      sy=100;     {suradnice stredu otacania}
      moc:array[0..7] of byte=(1,2,4,8,16,32,64,128);
var x,y,z,surx,sury:integer;
    bytex,bytey:byte;
    px,py:^TRotuj;
    r,fi:real;
    f:file of BitMap;
    Pfile:file of TRotuj;
    a:BitMap;
    a2:^BitMap;
procedure Nakresli(pom1:word);
begin
  if a[x div 8,y]>=moc[pom1] then begin
    PutPixel(x+pom1,y,2);
    a[x div 8,y]:=a[x div 8,y]-moc[pom1];
  end;
end;

BEGIN
  GetMem(px,SizeOf(TRotuj));
  GetMem(py,SizeOf(TRotuj));
  GetMem(a2,SizeOf(BitMap));
  readln;
  InitGraph(gd,gm,cesta);
  assign(f,'c:\subory\efekty\vision16.dat');
  reset(f);
  read(f,a);
  Close(f);
  for x:=0 to 79 do
    for y:=0 to 479 do
      a2^[x,y]:=a[x,y];
  {for x:=1 to 200 do
    for y:=1 to 200 do
      px^[x,y]:=0;
  for x:=1 to 200 do
    for y:=1 to 200 do
      py^[x,y]:=0; }
  Assign(Pfile,'otacaj.dat');
  reset(Pfile);
  read(Pfile,px^);
  read(Pfile,py^);
  Close(Pfile);
{  for x:=1 to 200 do begin
    if x mod 10=0 then write('.');
    for y:=1 to 200 do begin
      r:=Sqrt((sx-x)*(sx-x)+(sy-y)*(sy-y));
      if sx-x<>0 then fi:=ArcTan((sy-y)/(sx-x));
      fi:=fi+0.05;
      surx:=round(sx-r*sin(fi));
      sury:=round(sy-r*cos(fi));
      if sx-x=0 then begin
        surx:=sx;
        sury:=sy;
      end;
      if (surx>0) and (surx<201) and (sury>0) and (sury<201) then begin
        bytex:=surx;
        bytey:=sury;
        px^[x,y]:=bytex;
        py^[x,y]:=bytey;
      end
    end;
  end;    }

  for y:=1 to 200 do begin
    for x:=1 to 200 do begin
      for z:=7 downto 0 do
        Nakresli(z);
    end;
  end;
  for x:=0 to 79 do
    for y:=0 to 479 do
      a[x,y]:=a2^[x,y];
  for x:=100 downto 1 do
    for y:=100 downto 1 do
      if (px^[x,y]>0) and (a[x div 8,y]>=Moc[x mod 8]) then begin
        PutPixel(px^[x,y],py^[x,y],1);
        a[x div 8,y]:=a[x div 8,y]-moc[x mod 8];
      end;




  write('end');
  readln;
  FreeMem(px,SizeOf(TRotuj));
  FreeMem(py,SizeOf(TRotuj));
END.
