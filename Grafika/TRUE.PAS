program Konecne_uz_bez_ty_cudna_SVGA;
{ ----- konecne to bezi ----- }
var vesainf:array[0..255] of byte;
    granul,actstr:word;
    f:integer;
(*procedure PolozBod(x,y:word;r,g,b:byte);assembler;
{ ----- funguje LEN PRE TRUECOLOR ----- }
asm
             mov ax,y      {y-ova v DX:AX}
             mov cx,2048
             mul cx
             mov cx,x      {x-ova v CX}
             add cx,x
             add cx,x
             add ax,cx     {scitanie}
             adc dx,0
             mov di,ax     {vysl. v DX:DI}
             mov ax,Granul {nasobenie granularitou}
             mul dl
             mov dx,ax
             mov bx,0
             mov ax,4F05h
             int 10h       {nastav stranku}
             mov ax,0A000h
             mov es,ax     {nastav segment VideoRAM}
             mov al,r
             mov byte[es:di],al
             mov al,g
             mov byte[es:di+1],al
             mov al,b
             mov byte[es:di+2],al
end;  *)
procedure VyplnStranku;assembler;
asm
             mov ax,0A000h
             mov es,ax
             mov cx,32768
             mov ax,0409h
             xor di,di
         rep stosw
end;
BEGIN
  asm
             mov ax,seg VesaInf        {zistenie granularity}
             mov es,ax
             mov di,offset vesainf
             mov ax,4F01h
             mov cx,101h
             int 10h
             mov ax,word ptr VesaInf+4
             mov Granul,ax
  end;
  Granul:=64 div Granul;               {toto pripocitavame medzi strankami}
  asm
             mov ax,4F02h              {nastavenie graf. modu}
             mov bx,101h
             int 10h
             mov dx,0
             mov bx,0
             mov ax,4F05h
             int 10h
             call VyplnStranku
             mov dx,Granul
             mov bx,0
             mov ax,4F05h
             int 10h
             call VyplnStranku
             mov ax,0
             int 16h
  end;
END.