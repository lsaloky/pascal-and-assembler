unit JoyStick;
                                INTERFACE
procedure ZistiPoziciu(var x,y:word;var tlac:byte);
procedure CakajNaPustenie;
                              IMPLEMENTATION
{ ----- ovladanie joysticka ----- }
procedure ZistiPoziciu(var x,y:word;var tlac:byte);
var OsX,OsY:word;
    Tlacidla:byte;
begin
  asm
             cli                  { !!!!! vypnutie preruseni !!!!! }
{ ----- kontrola stlacenia tlacidiel ----- }
             mov Tlacidla,0
             mov dx,$201
             in al,dx
             not al
             shr al,4
             mov Tlacidla,al
             and Tlacidla,$03
{ ----- meranie pozicie na osiach ----- }
             out dx,al            {zapis lubovolny bajt na zaciatok merania}
             mov OsX,0
             mov OsY,0
@Cyklus:     in al,dx
             test al,$01          { $01 - os X}
             jz @NezvysujX
             inc OsX
@NezvysujX:  test al,$02          { $02 - os Y}
             jz @NezvysujY
             inc OsY
@NezvysujY:  test al,$03
             jnz @Cyklus
             sti                  { zapnutie preruseni }
  end;
  x:=OsX;y:=OsY;tlac:=Tlacidla;
end;
procedure CakajNaPustenie;assembler;
asm
             mov dx,$201
@Cakaj:      in al,dx
             not al
             and al,30h
             jnz @Cakaj
end;
BEGIN
END.