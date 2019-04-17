program Spracovanie_rozsirenej_klavesnice;
uses Keyboard;
{Kb - predpona. N-num. blok S-sipka}
var Pismeno:char;
    Rozsireny:word;
{ ----- demo ----- }
BEGIN
  writeln;
  repeat
    If JeStlaceny then begin
      CitajZnak(Pismeno,Rozsireny);
      if Pismeno>#0 then writeln(Pismeno,': Obycajny znak, ktory spracuje aj ReadKey.');
      if Rozsireny>0 then writeln('Rozsireny znak=',Rozsireny);
      case Rozsireny of
        KbEsc+KbShift:writeln('Takto spracuje Shift+Esc');
        KbF1+KbAlt:   writeln('Toto bol Alt+F1.');
        KbN5:         writeln('Z hadn  kl vesa N5.');
        KbCenterKey:  writeln('Z hadn  kl vesa Center Key');
      end;
    end;
  until Rozsireny=KbEnter;
END.