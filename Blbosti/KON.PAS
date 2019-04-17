program Graficky_efekt_skoku_kona;
const Posuny:array[1..8] of integer=(-326,-639,958,317,642,-963,1282,-1281);
procedure Efekt1(Farba:byte);assembler;
asm
             dec Farba
             cmp Farba,22
             jb @Koniec
             cmp byte[es:di],0
             jne @Koniec
             mov byte[es:di],cl
             sub di,639
             mov cl,Farba
             push cx
             call Efekt1
             mov cl,Farba
             push cx
             add di,321
             call Efekt1
             mov cl,Farba
             push cx
             add di,640
             call Efekt1
             mov cl,Farba
             push cx
             add di,319
             call Efekt1
             mov cl,Farba
             push cx
             sub di,2
             call Efekt1
             mov cl,Farba
             push cx
             sub di,321
             call Efekt1
             mov cl,Farba
             push cx
             sub di,640
             call Efekt1
             mov cl,Farba
             push cx
             sub di,319
             call Efekt1

@Koniec:
end;
procedure Efekt2(Farba,Offs:word);assembler;
var Index:word;
asm
             dec Farba
             mov cx,Farba
             cmp cx,22
             jbe @Koniec
             mov Index,18
             mov di,Offs
             mov byte[es:di],cl
@Dalsi:      sub Index,2
             mov bx,Index
             mov di,Offs
             add di,[si+bx]
             cmp byte[es:di],0
             jne @Nekresli
             push Farba
             push di
             call Efekt2
@Nekresli:   cmp Index,0
             jnz @Dalsi
@Koniec:
end;
BEGIN
  asm
             mov ax,0013h
             int 10h                 {InitGraph}
             mov ax,0A000h
             mov es,ax
(*             mov di,320*100+160      {stred obrazovky}
             push 31                 {farba}
             call Efekt1
             mov ax,1
             int 16h                 {repeat until keypressed}
             mov ax,0013h
             int 10h          *)       {InitGraph v zmysle ZmazObrazovku}
             lea si,Posuny
             push 31
             push 32160
             call Efekt2
             mov ax,1
             int 16h                 {repeat until keypressed}
             mov ax,0003h
             int 10h                 {CloseGraph}
  end; { asm }
END.