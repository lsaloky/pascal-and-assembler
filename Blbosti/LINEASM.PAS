program Kreslenie_ciary_v_assembleri;
var minx,maxx,miny,maxy:integer;
procedure Nasob320;assembler;
asm
             mov dx,ax
             mov ah,al
             xor al,al
             shl dx,6
             add ax,dx
end;
BEGIN
  asm
             mov minx,0
             mov maxx,319
             mov miny,0
             mov maxy,199
             mov ax,0A000h
             mov es,ax
             mov ax,0013h
             int 10h

             mov ax,miny
             call Nasob320
             add ax,minx
             mov di,ax
             mov byte[es:di],100
             mov bx,maxx
             sub bx,minx
             mov dx,maxy
             sub dx,miny
             inc dx
             mov cx,bx{pozor}
             xor ax,ax
@DalsiBod:   inc di
             add ax,dx
@NovyRiadok: cmp ax,bx
             jbe @StaryRiadok
             add di,320
             mov byte[es:di],100
             sub ax,bx
             jmp @NovyRiadok
@StaryRiadok:mov byte[es:di],100
             loop @DalsiBod
             mov ah,0
             int 16h
  end;
END
.
