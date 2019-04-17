uses Farby;
procedure a;
begin
readln;
end;

procedure Line320(X1,Y1,X2,Y2,Color:integer);
var I,D,x,y,IncX,IncY,IncA,IncB:integer;
    M:word;
    colbyte:byte;
const
  MinX:integer=0;   MinY:integer=0;
  MaxX:integer=320; MaxY:integer=200;
begin
  colbyte:=Color;
  if ((Y1<MinY) and (Y2<MinY)) or ((Y1>MaxY) and (Y2>MaxY))
    or ((X1<MinX) and (X2<MinX)) or ((X1>MaxX) and (X2>MaxX)) then Exit;
  if X1<MinX then X1:=MinX; if X1>MaxX then X1:=MaxX;
  if X2<MinX then X2:=MinX; if X2>MaxX then X2:=MaxX;
  if Y1<MinY then Y1:=MinY; if Y1>MaxY then Y1:=MaxY;
  if Y2<MinY then Y2:=MinY; if Y2>MaxY then Y2:=MaxY;
  x:=Abs(X2-X1); y:=Abs(Y2-Y1);
  if x>=y then begin
    if X2>X1 then IncX:=1 else IncX:=-1;
    if Y2>Y1 then IncY:=320 else IncY:=-320;
  end else begin
    D:=x; x:=y; y:=D;
    if X2>X1 then IncY:=1 else IncY:=-1;
    if Y2>Y1 then IncX:=320 else IncX:=-320;
  end;
  asm
    les di,
    mov byte[$A0000000],5
    call a
    mov ax,Y1    {M je v DI, M:=320*Y1+X1, na nasobenie potrebujem AX}
    mov bx,320
    mul bx
    add ax,X1
    mov di,ax
    mov ax,y     {D je v AX, D:=y*2-x}
    shl ax,1
    sub ax,x
    mov bx,ax    {IncA je v BX, Inca:=D-x}
    sub bx,x
    mov dx,ax    {IncB je v DX, IncB:=D+x}
    add dx,x
    mov cx,x     {pocitadlo cyklu}
    push es
    mov es,color {do ES dame farbu - inde nie je miesto}
  @CyklusCX:
    mov [$A0000000+di],es
    add di,IncX
    cmp ax,0
    js @MensieAkoNula
    add ax,bx           {ak je vacsie ako nula}
    add di,incy
    loop @CyklusCX
  @MensieAkoNula:
    add ax,cx
    loop @CyklusCX
    pop es       {zachranime obsah ES}
  end;
  {D:=Dy shl 1-Dx; IncA:=D-Dx; IncB:=D+Dx;
  M:=320*Y1+X1;
  for I:=0 to Dx do begin
    Mem[$A000:M]:=Color;
    Inc(M,IncX);
    if D>=0 then begin Inc(D,IncA); Inc(M,IncY); end
      else Inc(D,IncB);
  end;      }
end;
var x:integer;
begin
  asm
   mov ax,$0013
   Int $10
  end;
  NastavFarbu(5,63,63,63);
  Line320(0,3,115,0,5);
  reaDLN;
  asm
   mov ax,$0003
   Int $10
  end;
end.
