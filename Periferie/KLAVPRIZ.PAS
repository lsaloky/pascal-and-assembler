program Testovanie_klavesnice;
uses Dos,Crt;
var Reg:registers;
    ch:char;
BEGIN
  repeat
    reg.AH:=$02;        {testovanie stavu Num, Caps a Scroll Lock}
    Intr($16,reg);
    with reg do begin
      if AL and $10>0 then writeln('ScrollLock');
      if AL and $20>0 then writeln('NumLock');
      if AL and $40>0 then writeln('CapsLock');
      if AL and $01>0 then writeln('Pravy Shift');
      if AL and $02>0 then writeln('Lavy Shift');
      if AL and $04>0 then writeln('Ctrl');
      if AL and $08>0 then writeln('Alt');
    end;
    Delay(100);
    ClrScr;
  until keypressed;
  ClrScr;
  ch:=ReadKey;
  writeln('Nastavovanie priznakovych klaves:');
  repeat
    Mem[$0040:$0017]:=$70;   { $10+$20+$40}
    reg.AH:=$01;{Potom musis precitat znak z klavesnice, aby sa nastavili priznaky}
    Intr($16,reg);
    Delay(300);
    Mem[$0040:$0017]:=$00;
    reg.AH:=$01;
    Intr($16,reg);
    Delay(300);
  until keypressed;
END.