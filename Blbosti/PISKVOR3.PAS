program Piskvorky;
uses Crt;
var md,mt,sd,st:array[1..1000,1..4] of word; {xmin,ymin,xmax,ymax}
    virt:array[1..19,1..19] of byte;
    x,y,supr,sups,mojr,mojs,mdp,mtp,sdp,stp:integer;
    s:string;
    ch:char;
procedure VypisSup;
begin
  gotoxy(0,40);
  write('Zadaj svoj tah:');                                    {zadanie tahu}
  readln(s);
  supr:=ord(s[2])-96;
  sups:=ord(s[1])-96;
  gotoxy(3*sups,1+2*supr);
  write('* ');
  virt[sups,supr]:=100;
end;
procedure VypisMoj;
begin
  gotoxy(3*mojs,1+2*mojr);
  write(#14);
  ch:=readkey;
  virt[mojs,mojr]:=100;
end;


begin
  mdp:=0;mtp:=0;stp:=0;sdp:=0;
  Randomize;
  TextMode(C80 + Font8x8);                                         {tabulka}
  writeln('  a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s');
  write(' ÚÄÄ');
  for x:=1 to 18 do write('ÂÄÄ');
  writeln('¿');
  for x:=1 to 18 do begin
    write(chr(96+x));
    for y:=1 to 20 do write('³  ');
    writeln;
    write(' ÃÄÄ');
    for y:=1 to 18 do write('ÅÄÄ');
    writeln('´');
  end;
  write('s');
  for y:=1 to 20 do write('³  ');
  writeln;
  write(' ÀÄÄ');
  for x:=1 to 18 do write('ÁÄÄ');
  writeln('Ù');
  VypisSup;
  if (sups<19) and (supr<19) then begin
    mojs:=sups+1;
    mojr:=supr+1;
  end
  else begin
    mojs:=random(10)+4;
    mojr:=random(10)+4;
  end;
  VypisMoj;
  VypisSup;
  x:=0;
  while x<stp do begin
    x:=x+1;
    if (sups=st[x,2]-1) or (sups=st[x,4]) then writeln('Ma styri');

end.