program aaa;
uses Crt,BaneTpu;
var a:array[0..3999] of byte absolute $B800:$0000;
    b:array[1..80,1..25] of word;
    fout:file;
    x,y,sx,sy:word;
    tlacidlo:byte;
    ch:char;
begin
  ZapniKurzor;
  assign(fout,'bane.scr');
  reset(fout,1);
  BlockRead(fout,a[0],4000);
  BlockRead(fout,b[1,1],4000);
{  GotoXY(1,25);
  TextColor(7);TextBackGround(0);
  write(' Ulo§iœ   Nahraœ   Pomoc                                    Koniec hry');}

  {a[161]:=11;}
{  for x:=1 to 80 do
    for y:=1 to 25 do
      if b[x,y]<13 then b[x,y]:=0;}
  for x:=53 to 70 do b[x,21]:=12;
{  for x:=10 to 17 do b[x,25]:=14;
  for x:=19 to 25 do b[x,25]:=15;
  for x:=59 to 70 do b[x,25]:=16;}
  repeat
    repeat
      StavMysi(sx,sy,tlacidlo);
    until (b[sx div 8+1,sy div 8+1]>0) or (keypressed);
    Sound(1000);
    Delay(100);
    NoSound;
  until keypressed;

{  GotoXY(60,25);write('Koniec hry ');
  for x:=58 to 69 do a[x*2+24*160+1]:=80;}

  ch:=ReadKey;
  VypniKurzor;
  if ch='y' then begin
    Seek(fout,0);
    BlockWrite(fout,a[0],4000);
    BlockWrite(fout,b[1,1],4000);
  end;
  Close(fout);
END.

