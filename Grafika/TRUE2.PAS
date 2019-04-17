program SVGA_16_milionov_farieb;
{10f,112}
var vesainfo:array[0..255] of byte;
    granul,stranka:word;
    x,y:word;
BEGIN
  x:=100;y:=8;
  asm
    mov ax,seg vesainfo    {zistenie granularity}
    mov es,ax
    mov di,offset vesainfo
    mov ax,4f01h
    mov cx,10fh
    int 10h
    mov ax,word ptr vesainfo+4
    mov granul,ax
    mov ax,4f02h
    mov bx,10fh
    int 10h
  end;
  granul:=64 div granul;  {16}
  asm
        mov ax,$A000
        mov es,ax
        mov ax,y
        shl ax,2
        add ax,y
        shl ax,6
        add ax,x
        mov cx,3
        mul cx
        mov di,ax
        shl dx,4
        mov ax,4f05h
        mov bx,0
        int 10h
        mov bl,$3f
        mov [es:di],bl
  end;
  Mem[$00A0:0001]:=35;
  readln;
END.