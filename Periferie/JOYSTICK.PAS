program Skuska_programovania_joysticka_v_Pascale;
uses Crt;
var OsX,OsY:word;
    Tlacidla:byte;
procedure Vypis(text,surX,surY:word);
begin
  GotoXY(surx,sury);
  write('     ');
  GotoXY(surx,sury);
  write(text);
end;
BEGIN
  ClrScr;
  writeln('Tlacidlo 1:..... 2:..... X-ova pozicia:..... Y-ova pozicia:.....|');
  repeat
    asm
             cli
             mov Tlacidla,0
             mov dx,$201
             in al,dx
             test al,$10
             jnz @DalsieTlac
             mov Tlacidla,1
@DalsieTlac: test al,$20
             jnz @ZiadneTlac
             add Tlacidla,2
{ ----- meranie pozicie na osi X ----- }
@ZiadneTlac: xor cx,cx
             out dx,al            {zapis lubovolny bajt na zaciatok merania}
@CyklusX:    inc cx
             cmp cx,$FFFF
             je @HotovoX
             in al,dx
             and al,1             { $01 - os X}
             jne @CyklusX
@HotovoX:    mov OsX,cx
{ ----- meranie pozicie na osi Y ----- }
             xor cx,cx
             out dx,al            {zapis lubovolny bajt}
@CyklusY:    inc cx
             cmp cx,$FFFF
             je @HotovoY
             in al,dx
             and al,2             { $02 - os X}
             jne @CyklusY
@HotovoY:    mov OsY,cx
             sti
    end;
    Vypis(OsX,40,1);
    Vypis(OsY,60,1);
    if Tlacidla=1 then Vypis(1,12,1) else Vypis(0,12,1);
    if Tlacidla=2 then Vypis(1,20,1) else Vypis(0,20,1);
  until KeyPressed;
END.