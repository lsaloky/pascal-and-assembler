unit MukoXMS;
                                INTERFACE
var XMSDriver:pointer;
function Volne:word;
procedure Rezervuj(var Handle:word;Kolko:word);
procedure Uvolni(Handle,Kolko:word);
procedure PresunBlok(pDlzka,pSourceHandle:word;pSourceOffset:pointer;pDestHandle:word;pDestOffset:pointer);
                                IMPLEMENTATION
{ ----- funkcia vrati pocet volnych KB ----- }
function Volne:word;assembler;
asm
             mov ah,08h
             call [XMSDriver]
             mov ax,dx
end;
{ ----- rezervovanie XMS ----- }
procedure Rezervuj(var Handle:word;Kolko:word);
var pHandle:word;
begin
  asm
             mov ah,09h
             mov dx,Kolko
             call [XMSDriver]
             mov pHandle,dx
  end;
  Handle:=pHandle;
end;
{ ----- uvolnenie XMS ----- }
procedure Uvolni(Handle,Kolko:word);assembler;
asm
             mov ah,0Ah
             mov dx,Handle
             call [XMSDriver]
end;
procedure PresunBlok(pDlzka,pSourceHandle:word;pSourceOffset:pointer;pDestHandle:word;pDestOffset:pointer);
var PresunStruc:record
      D:longint;
      SH:word;
      SO:pointer;
      DH:word;
      DOf:pointer;
    end;
begin
  with PresunStruc do begin
    D:=pDlzka;
    SH:=pSourceHandle;
    SO:=pSourceOffset;
    DH:=pDestHandle;
    DOf:=pDestOffset;
  end;
  asm
             push ds
             mov ax,seg PresunStruc
             mov ds,ax
             lea si,PresunStruc
             mov ah,0Bh
             call [XMSDriver]
             pop ds
  end;
end;
BEGIN
  asm
             mov word ptr [XMSDriver],0
             mov word ptr [XMSDriver+2],0
             mov ax,4310h
             int 2Fh
             mov word ptr[XMSDriver],bx
             mov word ptr[XMSDriver+2],es
  end;
END.