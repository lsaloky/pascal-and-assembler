unit Util386;   {rychle procedury pre 386 a vyssie}
                      INTERFACE
var VSeg:word;
procedure ZmazObrazovku386;
procedure KopirujObrazovku386(VSeg1,VSeg2:word);
Function Sin387(Arg:extended):extended;{asi 2 x rychlejsie ako v Pascale}
Function Cos387(Arg:extended):extended;{pri zapnutom koprocesore 80287}

                    IMPLEMENTATION

procedure ZmazObrazovku386;assembler;
asm
             cld
             mov es,VSeg
 db 66h;     mov cx,16000;        dw 0
 db 66h;     mov di,0;            dw 0
 db 66h;     mov ax,0;            dw 0
 db 66h; rep stosw
end; { ZmazObrazovku386 }
procedure KopirujObrazovku386(VSeg1,VSeg2:word);assembler;
asm
             cld
             push ds
             mov ds,VSeg1
             mov es,VSeg2
 db 66h;     mov si,0;     dw 0
 db 66h;     mov di,0;     dw 0
 db 66h;     mov cx,16000; dw 0
 db 66h; rep movsw
             pop ds
end; { KopirujObrazovku }
Function Sin387(Arg:extended):extended;
var Vysl:extended;
begin
  asm
             fld Arg
             dw 0FED9h
             fstp Vysl
  end;
  Sin387:=Vysl;
end;
Function Cos387(Arg:extended):extended;
var Vysl:extended;
begin
  asm
             fld Arg
             dw 0FFD9h
             fstp Vysl
  end;
  Cos387:=Vysl;
end;

BEGIN
  VSeg:=$A000;
END.