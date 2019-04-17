program Magicky_stvorec;{priklad cislo 42}
var a:array[0..99,0..99] of word;
    rad,x,y,sx,sy,tx,ty:integer;
{pre nep rne n je mozn‚ pouzit met¢du n stavieb: nech n=7,
c¡sla vpisujeme od jednotky smerom vpravo dole:
                   1
                8  .  2
tu bude 15 -> .  .  9  .  3
          ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          ³.  .  .  .  10 .  4 ³
        . ³.  .  .  .  .  11 . ³ 5
     .  . ³.  .  .  .  .  .  12³ .  6
  .  .  . ³.  .  .  .  .  .  . ³ 13 .  7 -> teraz pride osmicka,
     .  . ³.  a tak dalej .  . ³ .  14      uz nie je mozne ist sikmo dole,
        . ³.  .  .  .  .  .  . ³ .          tak sa presunieme hore
          ³.  .  .  .  .  .  . ³
          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
              .  .  .  .  .
                 .  .  .
                    .  <- na konci je 49

Teraz presunieme vycnievajuce bloky dovnutra magickeho stvorca:
                    1ÍÍÍÍ»
                É8  .  2 º    horna cast sa presuva  o 7 miest dole
              15º.  9  . º 3
o 7 miest ÚÄÄÄÄÄºÄÄÄÄÄÄÄÄºÄÄÄÄÄ¿
vpravo    ³22 . º16 .  10º.  4 ³
        29³.  23º.  17 . º11 . ³ 5
     36 . ³30 . º24 .  18º.  12³ .  6    toto sa presuva o 7 miest vlavo
  43 .  37³.  31º.  25 . º19 . ³ 13 .  7
     44 . ³38 . º32 1<Í26¼.  20³ .  14
        45³.  39È>8 33 2  27 . ³ 21
          ³46 15 40 9  34 3  28³
          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
              47  . 41  . 35
                 48 .  42      o 7 miest hore
                    49                              }

BEGIN
  writeln('Zadaj r d magick‚ho stvorca (nep rne cislo):');
  readln(rad);
  sy:=-rad div 2;
  sx:=rad div 2;
  for x:=0 to rad-1 do begin
    tx:=sx-x;
    ty:=sy+x;
    for y:=0 to rad-1 do begin
      if tx<0 then tx:=rad+tx;
      if tx>=rad then tx:=tx-rad;
      if ty<0 then ty:=rad+ty;
      if ty>=rad then ty:=ty-rad;
      a[ty,tx]:=x*rad+y+1;
      Inc(tx);
      Inc(ty);
    end;
  end;
  for x:=0 to rad-1 do begin
    for y:=0 to rad-1 do write(a[x,y]:3,' ');
    writeln;
  end;
  readln;
END.