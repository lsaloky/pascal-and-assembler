program Magicky_stvorec;{priklad cislo 42}
var a:array[0..99,0..99] of word;
    rad,x,y,sx,sy,tx,ty:integer;
{pre nep�rne n je mozn� pouzit met�du n�stavieb: nech n=7,
c�sla vpisujeme od jednotky smerom vpravo dole:
                   1
                8  .  2
tu bude 15 -> .  .  9  .  3
          ��������������������Ŀ
          �.  .  .  .  10 .  4 �
        . �.  .  .  .  .  11 . � 5
     .  . �.  .  .  .  .  .  12� .  6
  .  .  . �.  .  .  .  .  .  . � 13 .  7 -> teraz pride osmicka,
     .  . �.  a tak dalej .  . � .  14      uz nie je mozne ist sikmo dole,
        . �.  .  .  .  .  .  . � .          tak sa presunieme hore
          �.  .  .  .  .  .  . �
          ����������������������
              .  .  .  .  .
                 .  .  .
                    .  <- na konci je 49

Teraz presunieme vycnievajuce bloky dovnutra magickeho stvorca:
                    1���ͻ
                �8  .  2 �    horna cast sa presuva  o 7 miest dole
              15�.  9  . � 3
o 7 miest �����ĺ�������ĺ����Ŀ
vpravo    �22 . �16 .  10�.  4 �
        29�.  23�.  17 . �11 . � 5
     36 . �30 . �24 .  18�.  12� .  6    toto sa presuva o 7 miest vlavo
  43 .  37�.  31�.  25 . �19 . � 13 .  7
     44 . �38 . �32 1<�26�.  20� .  14
        45�.  39�>8 33 2  27 . � 21
          �46 15 40 9  34 3  28�
          ����������������������
              47  . 41  . 35
                 48 .  42      o 7 miest hore
                    49                              }

BEGIN
  writeln('Zadaj r�d magick�ho stvorca (nep�rne cislo):');
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