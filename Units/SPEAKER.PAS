unit Speaker;{$S-,R-,D-,L-}
{ ----- unit pre pracu s PC Speakrom ----- }
                       INTERFACE
procedure Sound(Hz:word);
procedure NoSound;
procedure Delay(MS:word);
procedure Beep(Hz,Ms:word);
procedure BoundsBeep;
procedure ErrorBeep;
procedure AttentionBeep;
                       IMPLEMENTATION
var OneMS:word;
procedure Beep(Hz,Ms:word);assembler;
asm
             mov bx,Hz
             mov ax,34DDh
             mov dx,0012h
             cmp dx,bx
             jnc @Stop
             div bx
             mov bx,ax
             in al,61h
             test al,3
             jnz @Preskoc
             or al,3
             out 61h,al
             mov al,0B6h
             out 43h,al
@Preskoc:    mov al,bl
             out 42h,al
             mov al,bh
             out 42h,al
@Stop:       push Ms
             call Delay
             in al,61h
             and al,0FCh
             out 61h,al
end;
procedure BoundsBeep;assembler;
asm
             push 1234
             push 10
             call Beep
end;
procedure ErrorBeep;assembler;
asm
             push 800
             push 75
             call Beep
end;
procedure AttentionBeep;assembler;
asm
             push 660
             push 50
             call Beep
end;
procedure Sound(Hz:word);assembler;
asm
             mov bx,Hz
             mov ax,34DDh
             mov dx,0012h
             cmp dx,bx
             jnc @Done
             div bx
             mov bx,ax
             in al,61h
             test al,3
             jnz @Preskoc
             or al,3
             out 61h,al
             mov al,0B6h
             out 43h,al
@Preskoc:    mov al,bl
             out 42h,al
             mov al,bh
             out 42h,al
@Done:
end;
procedure NoSound;assembler;
asm
             in al,61h
             and al,0FCh
             out 61h,al
end;
procedure DelayOneMS;assembler;
asm
             push cx
             mov cx,OneMS
@1:          loop @1
             pop cx
end;
procedure Delay(Ms:word);assembler;
asm
             mov cx,Ms
             jcxz @Koniec
@1:          call DelayOneMS
             loop @1
@Koniec:
end;
procedure CalibrateDelay;assembler;
asm
             mov ax,0040h
             mov es,ax
             mov di,006Ch    {BIOS casovac}
             mov OneMS,55
             xor dx,dx
             mov ax,[es:di]
@1:          cmp ax,[es:di]
             je @1
             mov ax,[es:di]
@2:          call DelayOneMS
             inc dx
             cmp ax,[es:di]
             je @2
             mov OneMS,dx
end;
BEGIN
  CalibrateDelay;
END.
