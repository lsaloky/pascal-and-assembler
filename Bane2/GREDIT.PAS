program Primitivny_graficky_editor;
uses Graph,Crt;
const r=5;{mierka zvacsenia}
var gd,gm,x,y:integer;
    color,pb,aktual,pocet:byte;
    sx,sy:byte;               {rozmery bitmapy}
    f:file;
    paleta:array[1..256*3] of byte;
    obr:array[0..39,0..39] of byte;
procedure ZmazAktivnuCast;
begin
  SetFillStyle(SolidFill,0);
  Bar(0,0,199,199);
  Bar(219,149,319,199);
end;
procedure ZapniKurzorMysi;assembler;
asm
             mov ax,1
             int 33h
end;
procedure ZistiPoziciuMysi;assembler;
asm
@Cakaj:      mov ax,3
             int 33h
             cmp bx,0
             je @Cakaj
             mov x,cx
             mov y,dx
             mov ax,2
             int 33h
end;
procedure CakajNaPustenie;assembler;
asm
@Cakaj2:     mov ax,3
             int 33h
             cmp bx,0
             jne @Cakaj2
end;
procedure NacitajAktualnuBitmapu;
begin
  for x:=0 to 39 do for y:=0 to 39 do obr[x,y]:=0;
  BlockRead(f,sx,1);
  BlockRead(f,sy,1);
  for y:=0 to sy-1 do
    for x:=0 to sx-1 do begin
      BlockRead(f,obr[x,y],1);
      SetFillStyle(SolidFill,obr[x,y]);
      Bar(x*r,y*r,(x+1)*r,(y+1)*r);
      PutPixel(220+x,150+y,Obr[x,y]);
    end;
  for x:=0 to sx-1 do
    for y:=0 to sy-1 do
      PutPixel(x*r,y*r,2);
{ ----- ciary okolo ----- }
  SetColor(3);
  Line(219,149,219,150+sy);
  Line(220+sx,149,220+sx,150+sy);
  Line(219,149,220+sx,149);
  Line(219,150+sy,220+sx,150+sy);
  Line(sx*r+1,0,sx*r+1,sy*r+1);
  Line(0,sy*r+1,sx*r+1,sy*r+1);
end;
BEGIN
  gd:=InstallUserDriver('svga256',nil);gm:=0;
  InitGraph(gd,gm,'d:\bp\bgi');
{ ----- spracovanie palety ----- }
  Assign(f,'bitmapy.dat');
  Reset(f,1);
{  Seek(f,4433);
  Truncate(f);
  Close(f);}
{  Seek(f,5203);
  BlockRead(f,obr,80*16+4);
  BlockWrite(f,obr,80*16+4);
  CLose(f);                 }

  color:=6;
  BlockRead(f,paleta,768);
  asm
             xor cx,cx
             lea di,paleta
@DalsiaFarba:mov dx,03C8h
             mov al,cl
             out dx,al
             mov dx,03C9h
             mov al,byte[di]
             out dx,al
             mov al,byte[di+1]
             out dx,al
             mov al,byte[di+2]
             out dx,al
             add di,3
             inc cx
             cmp cx,255
             jbe @DalsiaFarba
  end;
  BlockRead(f,pocet,1);{pocet bitmap}
  aktual:=1;
  NacitajAktualnuBitmapu;
{ ----- vykreslenie palety ----- }
  for x:=1 to 256 do begin
    SetFillStyle(SolidFill,x);
    Bar(200+(x mod 16)*5,20+(x div 16)*5,205+(x mod 16)*5,25+(x div 16)*5);
  end;
  SetColor(3);
  OutTextXY(200,0,'< >');
{ ----- mys ----- }
  ZapniKurzorMysi;
  repeat
    ZistiPoziciuMysi;
    SetFillStyle(SolidFill,Color);
    Bar(200,120,220,140);
{ ----- kreslenie obrazka ----- }
    if (x<sx*2*r) and (y<sy*r) then begin
      Bar((x div 2 div r)*r,(y div r)*r,(x div 2 div r+1)*r,(y div r+1)*r);
      obr[x div 2 div r,y div r]:=Color;
      PutPixel(220+x div 2 div r,150+y div r,Color);
    end;
{ ----- zmena farby ----- }
    if (x>399) and (x<561) and (y>19) and (y<101) then Color:=(x-400) div 10+((y-20) div 5)*16;
{ ----- o 1 dalej ----- }
    if (x>431) and (x<448) and (y<8) and (aktual<=pocet+1) then begin
      ZmazAktivnuCast;
      Seek(f,FilePos(f)-sx*sy);
      for y:=0 to sy-1 do for x:=0 to sx-1 do BlockWrite(f,obr[x,y],1);
      Inc(aktual);
{ ----- nie nova bitmapa ----- }
      if aktual<=pocet then begin
        Seek(f,769);
        x:=1;
        while x<aktual do begin
          Inc(x);
          BlockRead(f,sx,1);
          BlockRead(f,sy,1);
          Seek(f,FilePos(f)+sx*sy);
        end;
        NacitajAktualnuBitmapu;
        CakajNaPustenie;
      end else begin
{ ----- nova bitmapa ----- }
        Inc(pocet);
        CakajNaPustenie;
        ZapniKurzorMysi;
        ZistiPoziciuMysi;
        if x<16*r then sx:=8;
        if (x>16*r) and (x<32*r) then sx:=16;
        if (x>32*r) and (x<48*r) then sx:=24;
        if (x>48*r) and (x<64*r) then sx:=32;
        if x>64*r then sx:=40;
        if y<8*r then sy:=8;
        if (y>8*r) and (y<16*r) then sy:=16;
        if (y>16*r) and (y<24*r)then sy:=24;
        if (y>24*r) and (y<32*r) then sy:=32;
        if y>32*r then sy:=40;

        Seek(f,FileSize(f));
        x:=FilePos(f);
        BlockWrite(f,sx,1);
        BlockWrite(f,sy,1);
        for x:=0 to 39 do for y:=0 to 39 do obr[x,y]:=0;
        BlockWrite(f,obr,sx*sy);
        Seek(f,768);
        BlockWrite(f,pocet,1);
        Close(f);
      end;
    end;
{ ----- o 1 nazad ----- }
    if (x>399) and (x<416) and (y<8) and (aktual>1) then begin
      ZmazAktivnuCast;
      Seek(f,FilePos(f)-sx*sy);
      for y:=0 to sy-1 do for x:=0 to sx-1 do BlockWrite(f,obr[x,y],1);
      Dec(aktual);
      Seek(f,769);
      x:=1;
      while x<aktual do begin
        Inc(x);
        BlockRead(f,sx,1);
        BlockRead(f,sy,1);
        Seek(f,FilePos(f)+sx*sy);
      end;
      NacitajAktualnuBitmapu;
      CakajNaPustenie;
    end;
    ZapniKurzorMysi;
  until keypressed;
{ ----- ukoncenie programu ----- }
  asm
    mov ax,2
    int 33h
  end;
{  CloseGraph;}
  Close(f);
END.