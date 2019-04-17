program Odovzdavanie_parametrov_procedury_v_assembleri;
procedure Vyber;assembler;
asm
  mov bp,sp
  mov bx,[bp+2]
  mov ax,[bp+4]
end;
BEGIN
  asm
             mov ax,5
             mov bx,7
             push ax
             push bx
             call Vyber
             add sp,4

  end;
END.