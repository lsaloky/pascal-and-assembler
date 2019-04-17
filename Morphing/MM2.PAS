program EditujMorphing;    {MukoSoft MorfEdit 2.0}
{obsah:const,type var...13   chyba      ...36                 Datovy subor:
       prekresli     ...43   init       ...58                 1.bajt pocet animacii
       bodkuj        ...81   kurzor     ...95                 2-256  pocet ciar v n-tej animacii
       spracuj       ...107  kresli     ...126                257-258 x-ova sur. 1. bodu 1. ciary na zac. animacie (integer)
       morphing      ...166  prepni     ...196                259-260 y-ova      1.
       uloz          ...217                                   261-262 x-ova      2.
       zmaz          ...229                                   263-264 y-ova      2.
                                                              265-272 analogicky sur. bodov 1. ciary na konci animacie
       hlavny program...269                                   273-... dalsie ciary
                                                              ...     na konci je #0 - info o verzii editora}

uses Graph,Crt;          {prva ciara: celk=0, pre c[i] i=1!!!}
const maxciar=1000;
      subor='lubo.dat';     {lubo.dat,hodiny.dat}
      kroky=50;          {pocet snimkov animacie}
      cesta='d:\bp\bgi';
type ciara=record
             x1z,y1z,x2z,y2z,x1k,y1k,x2k,y2k:integer; {z-vychozia poloha ciary}
           end;                                    {k-cielova poloha ciary}
     dynpam=array[1..16*maxciar+256] of byte;  {datovy subor v pamati-type}
     buffer=array[1..102] of byte; {obrazovka pod kurzorom-type}
var pa,akta:byte;                  {pocet animacii, max. 255; aktualna animacia}
    pciar:array[1..255] of byte;   {pocet ciar v n-tej animacii, max. 255}
    c:array[1..maxciar] of ciara;  {zoznam ciar}
    d:array[1..maxciar] of ciara;  {pomocne pole pri morphingu}
    celk:word;                     {celkovy pocet ciar}
    kx,ky:integer;                 {pozicia kurzora}
    f:file;                        {datovy subor}
    p:^dynpam;                     {datovy subor v pamati}
    r:^buffer;                     {obrazovka pod kurzorom}
    x,y,z:word;                    {pomocne premenne}
    ch:char;


procedure Chyba;
begin
  CloseGraph;
  writeln('Chyba: Datovy subor poskodeny alebo je z inej verzie programu !!!');
  Halt(1);
end;

procedure Prekresli;
begin
  y:=1;x:=1;
  while x<akta do begin
    y:=y+pciar[x];
    Inc(x);
  end;
  for x:=y to y+pciar[akta]-1 do begin
    SetColor(14);
    Line(c[x].x1z,c[x].y1z,c[x].x2z,c[x].y2z);
    SetColor(11);
    Line(c[x].x1k,c[x].y1k,c[x].x2k,c[x].y2k);
    PutPixel(c[x].x1z,c[x].y1z,0);
    PutPixel(c[x].x1k,c[x].y1k,0);
  end;
end;

procedure Init;
var gd,gm:integer;
begin
  celk:=0;pa:=0;akta:=1;gd:=9;gm:=2;kx:=5;ky:=25;
  GetMem(p,16*maxciar+256);
  GetMem(r,102);
  FillChar(pciar,SizeOf(pciar),#0);
  FillChar(c,SizeOf(c),#0);
  assign(f,subor);
  reset(f,1);
  BlockRead(f,p^,256);
  for x:=2 to 256 do celk:=celk+p^[x];
  BlockRead(f,p^[257],celk*16);
  Move(p^[2],pciar,255);
  Move(p^[257],c,16*celk);
  BlockRead(f,p^[257+16*celk],1);
  if p^[257+16*celk]>0 then Chyba;
  InitGraph(gd,gm,cesta);
  SetFillStyle(1,0);
  Prekresli;
  Close(f);
end;

procedure Bodkuj;
begin
  for x:=0 to 36 do
    for y:=1 to 23 do
      PutPixel(5+x*20,5+y*20,9);
  SetColor(7);
  Line(639,0,0,0);
  Line(0,0,0,18);
  Line(0,18,639,18);
  Line(639,18,639,0);
  Bar(1,1,638,17);
  OutTextXY(5,5,'aszwASZW:posun c[xxx]:prepni -:Zmaz Poloz Morphing Uloz Nahraj Koniec');
end;

procedure Kurzor;
begin
  repeat
    Getimage(kx-5,ky-5,kx+5,ky+5,r^);
    SetColor(15);
    Circle(kx,ky,5);
    Delay(40);
    PutImage(kx-5,ky-5,r^,NormalPut);
    Delay(40);
  until keypressed;
end;

procedure Spracuj;
begin
  ch:=ReadKey;
  case ch of
    'a':kx:=(kx-20) div 20*20+5;
    's':kx:=(kx+20) div 20*20+5;
    'w':ky:=(ky-20) div 20*20+5;
    'z':ky:=(ky+20) div 20*20+5;
    'A':kx:=kx-10;
    'S':kx:=kx+10;
    'W':ky:=ky-10;
    'Z':ky:=ky+10;
  end;
  if kx<5 then kx:=5;
  if kx>625 then kx:=625;
  if ky<25 then ky:=25;
  if ky>465 then ky:=465;
end;

procedure Kresli;
begin
  y:=1;x:=1;
  while x<=akta do begin
    y:=y+pciar[x];
    Inc(x);
  end;
  for z:=celk downto y do move(c[z],c[z+1],16);
  c[y].x1z:=kx;
  c[y].y1z:=ky;
  Bar(1,1,638,17);
  SetColor(7);
  OutTextXY(5,5,'Kresli koncovy bod ciary 1. snimku animacie, p - poloz bod');
  repeat
    Kurzor;
    Spracuj;
  until ch='p';
  c[y].x2z:=kx;
  c[y].y2z:=ky;
  SetColor(14);
  Line(c[y].x1z,c[y].y1z,c[y].x2z,c[y].y2z);
  Bar(1,1,638,17);
  SetColor(7);
  OutTextXY(5,5,'Kresli pociatocny bod ciary posl. snimku animacie, p - poloz bod');
  repeat
    Kurzor;
    Spracuj;
  until ch='p';
  c[y].x1k:=kx;
  c[y].y1k:=ky;
  Bar(1,1,638,17);
  SetColor(7);
  OutTextXY(5,5,'Kresli koncovy bod ciary posl. snimku animacie, p - poloz bod');
  repeat
    Kurzor;
    Spracuj;
  until ch='p';
  c[y].x2k:=kx;
  c[y].y2k:=ky;
  SetColor(11);
  Line(c[y].x1k,c[y].y1k,c[y].x2k,c[y].y2k);
  Inc(celk);
  Inc(pciar[akta]);
  Bodkuj;
end;

procedure Morphing;
begin
  z:=1;x:=1;
  while x<akta do begin
    z:=z+pciar[x];
    Inc(x);
  end;
  SetColor(0);
  for y:=z to z+pciar[akta]-1 do line(c[y].x1z,c[y].y1z,c[y].x2z,c[y].y2z);
  for y:=z to z+pciar[akta]-1 do line(c[y].x1k,c[y].y1k,c[y].x2k,c[y].y2k);
  for x:=1 to kroky+1 do begin
    setcolor(0);
    for y:=z to z+pciar[akta]-1 do line(d[y].x1k,d[y].y1k,d[y].x2k,d[y].y2k);
    setcolor(white);
    for y:=z to z+pciar[akta]-1 do line(d[y].x1z,d[y].y1z,d[y].x2z,d[y].y2z);
    delay(20);
    for y:=z to z+pciar[akta]-1 do begin
      d[y].x1k:=d[y].x1z;
      d[y].y1k:=d[y].y1z;
      d[y].x2k:=d[y].x2z;
      d[y].y2k:=d[y].y2z;
    end;
    for y:=z to z+pciar[akta]-1 do begin
      d[y].x1z:=c[y].x1z+((c[y].x1k-c[y].x1z)*x) div kroky;
      d[y].y1z:=c[y].y1z+((c[y].y1k-c[y].y1z)*x) div kroky;
      d[y].x2z:=c[y].x2z+((c[y].x2k-c[y].x2z)*x) div kroky;
      d[y].y2z:=c[y].y2z+((c[y].y2k-c[y].y2z)*x) div kroky;
    end;
  end;
  Bodkuj;
  Prekresli;
end;

procedure Prepni;
var pom1:integer;
begin
  ch:=ReadKey;
  pom1:=(Ord(ch)-48)*100;
  ch:=ReadKey;
  pom1:=pom1+(Ord(ch)-48)*10;
  ch:=ReadKey;
  pom1:=pom1+Ord(ch)-48;
  if (pom1>255) or (pom1=0) then begin
    Sound(1000);
    Delay(100);
    NoSound;
    Exit;
  end;
  akta:=pom1;
  ClearDevice;
  Bodkuj;
  Prekresli;
end;

procedure Uloz;
begin
  Move(pa,p^[1],1);
  Move(pciar,p^[2],255);
  Move(c,p^[257],16*celk);
  p^[257+16*celk]:=0;
  assign(f,subor);
  rewrite(f,1);
  BlockWrite(f,p^,16*celk+257);
  Close(f);
end;

procedure Zmaz;
var x1,y1,x2,y2:integer;
begin
  x1:=kx;
  y1:=ky;
  Bar(1,1,638,17);
  SetColor(7);
  OutTextXY(5,5,'Zadaj koncovy bod ciary, -: poloz bod');
  repeat
    Kurzor;
    Spracuj;
  until ch='-';
  x2:=kx;y2:=ky;
  y:=1;x:=1;
  while x<akta do begin
    y:=y+pciar[x];
    Inc(x);
  end;
  for x:=y to y+pciar[akta]-1 do
    if ((c[x].x1z=x1) and (c[x].y1z=y1) and (c[x].x2z=x2) and (c[x].y2z=y2)) or
       ((c[x].x1k=x1) and (c[x].y1k=y1) and (c[x].x2k=x2) and (c[x].y2k=y2)) or
       ((c[x].x2z=x1) and (c[x].y2z=y1) and (c[x].x1z=x2) and (c[x].y1z=y2)) or
       ((c[x].x2k=x1) and (c[x].y2k=y1) and (c[x].x1k=x2) and (c[x].y1k=y2)) then begin
      Sound(1000);
      Delay(100);
      NoSound;
      Move(c[x+1].x1z,c[x].x1z,16*(maxciar-x-1));
      pciar[akta]:=pciar[akta]-1;
    end;
  ClearDevice;
  Bodkuj;
  Prekresli;
end;

BEGIN
  Init;
  Bodkuj;
  repeat
    Kurzor;
    Spracuj;
    case ch of
      'p':Kresli;
      'm':Morphing;
      'c':Prepni;
      'u':Uloz;
      'n':begin
            FreeMem(p,16*maxciar+256);
            FreeMem(r,102);
            Init;
            Bodkuj;
          end;
      '-':Zmaz;
    end;
  until ch='k';
  CloseGraph;
  ClrScr;
  writeln('Editor pre morphing MukoSoft MorfEdit verzia 2.0');
  writeln('Lubos Saloky, 1996');
END.