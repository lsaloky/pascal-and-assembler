program Prve_pokusy_so_Sound_Blastrom;
var x:word;
BEGIN
  {Nastavovanie registrov mixera}
  Port[$220+4]:=$00;  {sluzba - reset mixer settings - zadaj to vzdy na zaciatku}
  Port[$220+5]:=$00;  {data}
  {Citanie hodnot mixera}
  Port[$220+4]:=$22;
  x:=Port[$220+5];
  writeln(x);
  Port[$224]:=$22;
  Port[$225]:=$FF;
  for x:=1 to 50000 do Port[$225]:=x mod 256;
  {sluzba popis
   $0C    nahravanie zvuku
          [00xxxyy0] xxx=000 - filter na basy,001 na vysky,010 bez filtra
          yy=00 - nahrava mikrofon 1, 01 - CD, 10 - mic. 2, 11 - Line In
   $0E    zvukovy vystup
          [00x000y0] x=0 - pouzi O/P filter, 1 nepouzi. y=0 - mono, 1 stereo
   $22    Master volume
          [xxxxyyyy] xxxx=0..15 - lavy kanal, yyyy pravy
   $04    Voice volume - ako Master
   $26    FM volume - ako Master
   $28    CD volume - ako Master
   $2E    Line volume - ako Master
   $0A    Mic mixing
          [00000xxx] xxx=microphone volume}

end.
