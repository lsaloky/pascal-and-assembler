program Graficky_efekt;
uses Farby,Crt;
const Rohy:array[1..4] of byte=(242,21,200,75);
var x,pom,xplus1,xplus2:integer;
    y:byte;
    v:array[0..199,0..319] of byte absolute $A000:$0000;{video RAM 320x200}
    ch:char;

procedure PriemerujFarby;assembler;
asm
  mov ax,$A000
  mov es,ax
  mov bx,1    {os X}
  mov cl,1    {os Y}
  mov ch,5    {pomocne pre nasobenie 320}
@cyklus:
  mov al,cl   {offset v[x,y] -> AX -> DI}
  mul ch
  shl ax,6
  add ax,bx
  mov dx,0
  mov di,ax
  mov dl,byte[es:di-321] {v DX prebieha scitanie}
  mov ax,0
  mov al,byte[es:di-320]
  add dx,ax
  mov al,byte[es:di-319]
  add dx,ax
  mov al,byte[es:di-1]
  add dx,ax
  mov al,byte[es:di+1]
  add dx,ax
  mov al,byte[es:di+319]
  add dx,ax
  mov al,byte[es:di+320]
  add dx,ax
  mov al,byte[es:di+321]
  add dx,ax
  shr dx,3
  adc dx,0
  mov byte[es:di],dl
  inc cl
  cmp cl,199d
  jb @cyklus
  mov cl,1
  inc bx
  cmp bx,319d
  jb @cyklus
end;

procedure Nakresli(xz,xk:word;yz,yk:byte);
var xp:integer;
    yp:byte;
begin
  xp:=(xz+xk) div 2;
  yp:=(yz+yk) div 2;
  asm
    mov ax,$A000
    mov es,ax
    mov cl,5
    mov bx,0
    mov dx,0
    mov al,yz  { ----- 1. riadok -----, v[yz,xz]}
    mul cl
    shl ax,6
    add ax,xz
    mov di,ax
    mov bl,[es:di]
    mov al,yz     {v[yz,xk]}
    mul cl
    shl ax,6
    add ax,xk
    mov di,ax
    mov dl,[es:di]
    add bx,dx      {vypocet}
    shr bx,1
    mov al,yz      {v[yz,xp]}
    mul cl
    shl ax,6
    add ax,xp
    mov di,ax
    mov [es:di],bl
    mov al,yk    { ----- 2. riadok -----, v[yk,xz]}
    mul cl
    shl ax,6
    add ax,xz
    mov di,ax
    mov bl,[es:di]
    mov al,yk     {v[yk,xk]}
    mul cl
    shl ax,6
    add ax,xk
    mov di,ax
    mov dl,[es:di]
    add bx,dx      {vypocet}
    shr bx,1
    mov al,yk      {v[yk,xp]}
    mul cl
    shl ax,6
    add ax,xp
    mov di,ax
    mov [es:di],bl
    mov al,yz    { ----- 3. riadok -----, v[yz,xz]}
    mul cl
    shl ax,6
    add ax,xz
    mov di,ax
    mov bl,[es:di]
    mov al,yk     {v[yk,xz]}
    mul cl
    shl ax,6
    add ax,xz
    mov di,ax
    mov dl,[es:di]
    add bx,dx      {vypocet}
    shr bx,1
    mov al,yp      {v[yp,xz]}
    mul cl
    shl ax,6
    add ax,xz
    mov di,ax
    mov [es:di],bl
    mov al,yz    { ----- 4. riadok -----, v[yz,xk]}
    mul cl
    shl ax,6
    add ax,xk
    mov di,ax
    mov bl,[es:di]
    mov al,yk     {v[yk,xk]}
    mul cl
    shl ax,6
    add ax,xk
    mov di,ax
    mov dl,[es:di]
    add bx,dx      {vypocet}
    shr bx,1
    mov al,yp      {v[yp,xk]}
    mul cl
    shl ax,6
    add ax,xk
    mov di,ax
    mov [es:di],bl
  end;
{  v[yz,xp]:=(v[yz,xz]+v[yz,xk]) div 2;
  v[yk,xp]:=(v[yk,xz]+v[yk,xk]) div 2;
  v[yp,xk]:=(v[yz,xk]+v[yk,xk]) div 2;
  v[yp,xz]:=(v[yz,xz]+v[yk,xz]) div 2; }
  v[yp,xp]:=(v[yz,xz]+v[yk,xz]+v[yz,xk]+v[yz,xz]) div 4;
  if xk-xz>2 then begin
    Nakresli(xz,xp,yz,yp);
    Nakresli(xp,xk,yz,yp);
    Nakresli(xz,xp,yp,yk);
    Nakresli(xp,xk,yp,yk);
  end;
end;
BEGIN   { -------------------- hlavny program ------------------- }
  writeln('Program najprv vykresli graficky efekt a caka na Enter. Potom priemeruje');
  writeln('farby [Enter], urobi dalsiu upravu [Enter] a priemeruje farby az do stla-');
  writeln('cenia klavesy.');
  readln;
  asm
    mov ax,$0013
    int $10
  end;
  for x:=0 to 63 do begin
    xplus1:=x+1;
    xplus2:=x+2;
    if xplus1>63 then xplus1:=63;
    if xplus2>63 then xplus2:=63;
    NastavFarbu(x*4,x,x,x);
    NastavFarbu(x*4+1,xplus1,x,x);
    NastavFarbu(x*4+2,xplus1,x,xplus2);
    NastavFarbu(x*4+3,x,xplus1,xplus1);
  end;
  for y:=1 to 198 do for x:=1 to 318 do v[y,x]:=random(255);
  readln;
  repeat
    PriemerujFarby;
  until KeyPressed;
  v[0,0]:=Rohy[1];
  v[0,319]:=Rohy[2];
  v[199,0]:=Rohy[3];
  v[199,319]:=Rohy[4];
  Nakresli(0,319,0,199);
  Readln;
  PriemerujFarby;
  Readln;
  for x:=1 to 159 do
    for y:=1 to 198 do begin
      if (v[y,x]=v[y-1,x]) and (v[y,x]=v[y+1,x]) then begin
        pom:=v[y,x];
        v[y,x]:=v[200-y,320-x];
        v[200-y,320-x]:=pom;
      end;
      if (v[y+1,x]=v[y,x]) and (v[y-1,x]=v[y,x]) then Inc(v[y,x]);
    end ;
  Readln;
  repeat
    PriemerujFarby;
  until keypressed;
  asm
    mov ax,$0003
    int $10
  end;
END.