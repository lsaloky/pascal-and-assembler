program SVGA;{inicializacia SVGA rezimov}
uses Dos;
type TrueColor=record
       R,G,B:byte;{vyuziva sa len dolnych 6 bitov, celkove 262144 farieb}
     end;
var v:array[0..199,0..319] of byte absolute $A000:$0000;{video RAM 320x200}
    w:array[0..101,0..639] of byte absolute $A000:$0000;{          640x480}
    t:array[0..67,0..319,0..2] of byte absolute $B000:$0000;{320x200 16M farieb}
    r:registers;
    p:array[0..255] of TrueColor;                       {paleta}
    x,y,z:word;
    ch:char;
    pom:byte;
procedure NastavPaletu;
begin
  r.AX:=$1012;
  r.BX:=$0000;
  r.CX:=$0100;
  r.DX:=ofs(p);
  r.ES:=seg(p);
  Intr($10,r);
end;
procedure NacitajPaletu;
begin
  r.AX:=$1017;     {nacitanie palety do p}
  r.BX:=$0000;
  r.CX:=$0100;
  r.DX:=ofs(p);
  r.ES:=seg(p);
  Intr($10,r);
end;
BEGIN
  r.AX:=$0013;     {nastavenie graf. modu 320 x 200, 256 farieb}
  Intr($10,r);
  for x:=0 to 319 do
    for y:=0 to 199 do
      v[y,x]:=random(256);
  NacitajPaletu;
  for x:=0 to 63 do begin
    for y:=0 to 255 do begin
      if p[y].R>0 then Dec(p[y].R);
      if p[y].G>0 then Dec(p[y].G);
      if p[y].B>0 then Dec(p[y].B);
    end;
    NastavPaletu;
  end;
  FillChar(v,SizeOf(v),1);
  for x:=1 to 255 do begin
    p[x].B:=0;
    p[x].G:=0;
    p[x].B:=x;
  end;
  p[0].r:=63;p[0].g:=0;p[0].b:=0;
  NastavPaletu;
  for x:=1 to 63 do
    for y:=0 to 199 do begin
      v[y,x*5]:=x;
      v[y,x*5+1]:=x;
      v[y,x*5+2]:=x;
      v[y,x*5+3]:=x;
      v[y,x*5+4]:=x;
    end;
  readln;
  r.AX:=$005f;     {nastavenie graf. modu 640 x 480, 256 farieb}
  Intr($10,r);
  for x:=0 to 639 do
    w[17,x]:=2;
  readln;
  r.AX:=$0070;     {nastavenie graf. modu 320 x 200, 16.776.216 farieb}
  Intr($10,r);
  for z:=0 to 2 do
    for x:=0 to 319 do
      for y:=0 to 67 do begin
        t[y,x,z]:=y*3;
      end;
  readln;
  r.AX:=$0013;     {nastavenie graf. modu 320 x 200, 256 farieb}
  Intr($10,r);
  for x:=0 to 319 do
    for y:=0 to 199 do
      v[y,x]:=random(256);
  for x:=0 to 200 do
    for y:=0 to 199 do begin
      pom:=v[y,0];
      Move(v[y,1],v[y,0],319);
      v[y,319]:=pom;
    end;
  r.AX:=$005f;      {nastavenie 640 x 480, 256 farieb}
  Intr($10,r);
  for x:=0 to 639 do
    for y:=0 to 479 do begin
      r.AX:=$0cff;
      r.CX:=x;
      r.DX:=y;
      Intr($10,r);
    end;
  readln;
  r.AX:=$0003;      {nastavenie textoveho modu}
  Intr($10,r);
END.
{                  320 x 200      640 x 480       800 x 600     1024 x 768}
{256 farieb          $0013          $005F           $005C         $0060   }
{65536 farieb                       $0064           $0065}
{16776216 farieb     $0070          $0071}

