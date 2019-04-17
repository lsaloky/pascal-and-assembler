program Vypocet_Cisla_pi;
{ pi=3.14159 26535 89763 23846 26433 83279 50288 41971 }
var x:longint;
    y,t:real;
    ch:char;
    a,b:word;
begin
  writeln(501*65536);
  writeln('1 - Vypocet c¡sla ã');
  writeln('2 - Test na for longint');
  writeln('3 - Test na for word');
  readln(ch);
  case ch of
    '1':begin
        y:=1;x:=3;
        repeat
          y:=y-1/x;
          Inc(x,2);
          t:=1/x;
          if (x-1) mod 50000=0 then writeln(4*y);
          y:=y+1/x;
          Inc(x,2);
        until t<0.000001;             {pre t<0.000001 cas 31 sek£nd}
        writeln(4*y);                 {4*y= 3.14159465}
      end;                            {of case 1}
  '2':begin
        for x:=1 to 20000000 do       {8 sekund pre x longint}
        begin end;
      end;                            {of case 2}
  '3':begin
        for a:=0 to 500 do begin      {11 sekund bez asm nop}
          asm                  {asm zvysuje £cinnost cache,pretoze tieto}
            nop                {dva cykly sa asi navz jom z cache vyraduj£}
          end;                 {s asm len 9 sek£nd}
          for b:=0 to 65535 do {mimochodom 501*65516=32833536}
            begin end;{pri vypnutej externej cache je cas 9 sek£nd bez aj s NOP}
        end;             {po vypnut¡ vsetkych kes¡ neuveritelnych 49 sek£nd}
      end;                     {of case 3}
  end;                         {of case total}
end.
{----------------------------------------------------------------------------}
{             Z ver: medzi kazd‚ dva pr¡kazy vetvenia d vaj NOP              }
{----------------------------------------------------------------------------}
