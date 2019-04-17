program Kurzor_joysticka;
var surx,sury:word;
procedure Cakaj;
begin
  readln;
end;
BEGIN
  asm
    mov ax,$0013
    int $10
    mov ax,$A000
    mov es,ax
    mov bl,117d
    mov [es:0000],117d

    mov ax,$0003
    int $10
  end;
     asm
        mov word ptr count, 0
        cli          { Disable interrupts so they don't interfere with timing }
        mov dx, $201 { Write dummy byte to joystick port }
        out dx, al
        @joystickloop:
        inc count              { Add one to count }
        cmp count, $FFFF       { Check for time out }
        je @done
        in al, dx              { Get joystick port value }
        and al, cisloosi       { Test the appropriate bit }
        jne @joystickloop
        @done:
        sti                    { Enable interrupts again }
      end;
END.