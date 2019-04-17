unit Myska;
                                INTERFACE
const Lave:byte=1;
      Prave:byte=2;
      Stredne:byte=4; {len pre PC AT}
procedure StavMysi(var JeInstalovany:boolean;var PocetTlacidiel:byte);
function JeMys:boolean; { jednoduchsia verzia Stav-u Mysi }
procedure ZapniKurzorMysi;
procedure VypniKurzorMysi;
procedure OknoKurzora(x1,x2,y1,y2:word);
procedure ZistiPoziciu(var x,y:word;var Tlacidla:byte);
procedure NastavKurzor(x,y:word);
procedure CakajNaPustenie;
                             IMPLEMENTATION
procedure StavMysi(var JeInstalovany:boolean;var PocetTlacidiel:byte);
var pom1,pom2:integer;
begin
  asm
             mov ax,0
             int 33h
             mov pom1,ax
             mov pom2,bx
  end;
  if pom1=0 then JeInstalovany:=False
  else JeInstalovany:=True;
  case pom2 of
    -1:PocetTlacidiel:=0;
     0:PocetTlacidiel:=2; {MS AT}
     3:PocetTlacidiel:=3; {PC AT}
  end;
end;
function JeMys:boolean;assembler;
asm
             xor ax,ax
             int 33h
end;
procedure ZapniKurzorMysi;assembler;
asm
             mov ax,1
             int 33h
end;
procedure VypniKurzorMysi;assembler;
asm
             mov ax,2
             int 33h
end;
procedure OknoKurzora(x1,x2,y1,y2:word);assembler;
asm
             mov ax,7
             mov cx,x1
             mov dx,x2
             int 33h
             mov ax,8
             mov cx,y1
             mov dx,y2
             int 33h
end;
procedure ZistiPoziciu(var x,y:word;var Tlacidla:byte);
var px,py:word;Ptlacidla:byte;
begin
  asm
             mov ax,3
             int $33
             mov px,cx
             mov py,dx
             mov pTlacidla,bl
  end;
  x:=px;y:=py;tlacidla:=ptlacidla;
end;
procedure NastavKurzor(x,y:word);assembler;
asm
             mov ax,4
             mov cx,x
             mov dx,y
             int 33h
end;
procedure CakajNaPustenie;assembler;
asm
@Cakaj:      mov ax,3
             int 33h
             cmp bx,0
             jne @Cakaj
end;
BEGIN
END.