{ZOZNAM PROCEDUR:
  VypniKurzorMysi;assembler;
  ZapniKurzorMysi;assembler;
  ZistiPoziciu;assembler;         tlacidlo,x,y
  CakajNaPustenie;assembler;
  NastavRozsahSuradnic;assembler; sx1,sx2,sy1,sy2
  UmiestniKurzor;assembler;       x,y}

procedure VypniKurzorMysi;assembler;
asm
             mov ax,2
             int 33h
end;
procedure ZapniKurzorMysi;assembler;
asm
             mov ax,1
             int 33h
end;
procedure ZistiPoziciu;assembler;
asm
           mov ax,3
           int 33h
           mov tlacidlo,bx
           mov x,cx
           mov y,dx
end;
procedure CakajNaPustenie;assembler;
asm
@repeat:     mov ax,3
             int 33h
             cmp bx,0
             jne @repeat
end;
procedure NastavRozsahSuradnic;assembler;
asm
             mov cx,sx1
             mov dx,sx2
             mov ax,7
             int 33h
             mov cx,sy1
             mov dx,sy2
             mov ax,8
             int 33h
end;
procedure UmiestniKurzor;assembler;
asm
             mov ax,4
             mov cx,x
             mov dx,y
             int 33h
end;