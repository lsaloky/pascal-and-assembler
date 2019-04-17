program Primitivny_editor_fontov;
uses Graph,Crt;
type pismeno=array[0..63] of byte;
var gd,gm,x,y,pos,c1:integer;
    color,pb:byte;
    font:pismeno;
    ch:char;
    f:file of pismeno;
    f2:file;
    paleta:array[1..256*3] of byte;
procedure NacitajFont;
var s:string;
begin
  for c1:=0 to 63 do font[c1]:=0;
  Seek(f,pos);
  if pos<filesize(f) then Read(f,font);
  for c1:=0 to 63 do begin
    SetFillStyle(SolidFill,font[c1]);
    Bar((c1 mod 8)*10,(c1 div 8)*10,(c1 mod 8+1)*10-1,(c1 div 8+1)*10-1);
    PutPixel(10+c1 mod 8,180+c1 div 8,font[c1]);
  end;
  SetFillStyle(solidfill,0);
  Bar(100,0,124,8);
  Str(pos,s);
  OuttextXY(100,0,s);
  for x:=0 to 7 do
    for y:=0 to 7 do
      PutPixel(x*10,y*10,2);
end;
BEGIN
  gd:=InstallUserDriver('svga256',nil);gm:=0;
  InitGraph(gd,gm,'d:\bp\bgi');
  Assign(f2,'paleta.dat');
  Reset(f2,256*3);
  for x:=0 to 63 do font[x]:=0;
  color:=6;
  BlockRead(f2,paleta,1);
{ ----- nastavenie palety ----- }
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
  Close(f2);
  Assign(f,'font.dat');
  Reset(f);
  pos:=0;
  NacitajFont;
{ ----- vykreslenie palety ----- }
  for x:=1 to 256 do begin
    SetFillStyle(SolidFill,x);
    Bar(200+(x mod 16)*5,20+(x div 16)*5,205+(x mod 16)*5,25+(x div 16)*5);
  end;
{ ----- siet a ciary ----- }
  for x:=0 to 7 do
    for y:=0 to 7 do
      PutPixel(x*10,y*10,2);
  SetColor(3);
  Line(80,0,80,80);
  Line(0,80,80,80);
  Line(9,179,18,179);
  Line(18,179,18,188);
  Line(18,188,9,188);
  Line(9,188,9,179);
  asm
    mov ax,1
    int 33h
  end;
  repeat
{ ----- obsluha mysi ----- }

    asm
@Cakaj:      mov ax,0003h
             int 33h
             cmp bx,0
             jne @OK
             jmp @Cakaj
@OK:         mov x,cx
             mov y,dx
             mov ax,2
             int 33h
    end;
    SetFillStyle(SolidFill,Color);
    Bar(200,120,220,140);
{ ----- editacia pismenka ----- }
    if (x<160) and (y<80) then begin
      Bar((x div 20)*10,(y div 10)*10,(x div 20+1)*10,(y div 10+1)*10);
      font[(y div 10)*8+x div 20]:=Color;
      PutPixel(10+x div 20,180+y div 10,Color);
    end;
{ ----- prepnutie na predosle pismenko ----- }
    if (x<18) and (y>178) and (pos>0) then begin
      asm
        mov ax,0
        int 16h
      end;
      seek(f,pos);
      write(f,font);
      pos:=pos-1;
      NacitajFont;
    end;
{ ----- prepnutie na dalsie pismeno ----- }
    if (x>36) and (x<200) and (y>178)  then begin
      asm
        mov ax,0
        int 16h
      end;
      seek(f,pos);
      write(f,font);
      pos:=pos+1;
      NacitajFont;
    end;
{ ----- prepnutie o 10 dalej ----- }
    if (x>200) and (y>178) then begin
      asm
        mov ax,0
        int 16h
      end;
      seek(f,pos);
      write(f,font);
      pos:=pos+10;
      NacitajFont;
    end;

{ ----- volba farby ----- }
    if (x>399) and (x<561) and (y>19) and (y<101) then Color:=(x-400) div 10+((y-20) div 5)*16;
    asm
             mov ax,1
             int 33h
    end;
  until keypressed;
{ ----- ukoncenie programu ----- }
  asm
    mov ax,2
    int 33h
  end;
  CloseGraph;
  seek(f,pos);
  write(f,font);
  Close(f);
END.