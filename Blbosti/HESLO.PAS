program Cakanie_na_heslo;
const Heslo:array[1..5] of char=('l','a','l','l','a');
var Zadane:array[1..5] of char;
BEGIN
  asm
             mov cx,5
             lea di,Zadane
             mov ax,ds
             mov es,ax
@DalsiZnak:  mov ah,0
             int 16h
             stosb
             loop @DalsiZnak
             mov cx,5
             lea si,Heslo
             lea di,Zadane
        repe cmpsb
             jz @OK
             int 19h
@OK:
  end;
END.