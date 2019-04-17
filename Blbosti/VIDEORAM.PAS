program Priamy_pristup_do_videoram;
uses Graph;
var b:array[0..319,0..99]of byte absolute $00B8:0000;
    gd,gm:integer;
begin
gd:=9;gm:=2;initgraph(gd,gm,'c:\bp\bgi');
for gd:=0 to 319 do
  for gm:=0 to 99 do
    b[gd,gm]:=$77;
readln;
end.