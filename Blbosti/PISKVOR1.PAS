program Piskvorky;
uses Crt;
type cudo=array[1..19,1..19] of word;
var pom1,pom2,x,y,decx,decy,decc:integer;
    s:string;
    plocha:array[1..19,1..19] of byte;    {skutocn  plocha}
    virt:cudo;                            {virtu lna plocha pouz¡van  pre}
    supr,sups:integer;                    {pozicn‚ koeficienty na pl ne}
    f:file of cudo;
    ch:char;

procedure Uprav;                          {upravuje pozicn‚ koeficienty}
begin
  pom1:=sups+decx*(5-decc);pom2:=supr+decy*(5-decc);
  while (decc>0) and (pom1<20) and (pom1>0) and (pom2<20) and (pom2>0) do begin
    virt[pom1,pom2]:=virt[pom1,pom2]-decc;
    if (pom1<6) and (pom2<=pom1) then virt[pom1,pom2]:=virt[pom1,pom2]-supr+decc;
    if (pom1>14) and (pom2>=pom1) then virt[pom1,pom2]:=virt[pom1,pom2]-supr+decc;
    if (pom2<6) and (pom1<pom2) then virt[pom1,pom2]:=virt[pom1,pom2]-sups+decc;
    if (pom2>14) and (pom1>pom2) then virt[pom1,pom2]:=virt[pom1,pom2]-sups+decc;
    dec(decc);
    pom1:=pom1+decx;pom2:=pom2+decy;
  end;
end;

BEGIN                                               {Zac¡na hlavny program}
  assign(f,'plocha.dat');
  reset(f);
  {for x:=1 to 19 do
    for y:=1 to 19 do begin
      plocha[x,y]:=0;
      virt[x,y]:=0;
    end;}
  seek(f,1);
  read(f,virt);
  {for y:=1 to 19 do
    for x:=1 to 19 do begin
      if virt[x,y]=5 then virt[x,y]:=8;
      if virt[x,y]=4 then virt[x,y]:=6;
      if virt[x,y]=3 then virt[x,y]:=5;
      if virt[x,y]=2 then virt[x,y]:=4;
    end;}
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
  gotoxy(0,40);
  write('Zadaj svoj tah:');                                    {zadanie tahu}
  readln(s);
  supr:=ord(s[2])-96;
  sups:=ord(s[1])-96;
  for y:=1 to 19 do                                             {vypis}
    for x:=1 to 19 do begin
      gotoxy(3*x,2*y+1);
      write(virt[x,y]);
    end;
  gotoxy(3*sups,1+2*supr);
  write('* ');
  ch:=readkey;
  plocha[sups,supr]:=128;                           { --- tabulka c. 2 --- }
  decx:=1;decy:=1;decc:=4;                          {  pozicny algiritmus  }
  Uprav;
  decx:=0;decy:=1;decc:=4;
  Uprav;
  decx:=-1;decy:=1;decc:=4;
  Uprav;
  decx:=-1;decy:=0;decc:=4;
  Uprav;
  decx:=-1;decy:=-1;decc:=4;
  Uprav;
  decx:=0;decy:=-1;decc:=4;
  Uprav;
  decx:=1;decy:=-1;decc:=4;
  Uprav;
  decx:=1;decy:=0;decc:=4;
  Uprav;
  for y:=1 to 19 do                                             {vypis}
    for x:=1 to 19 do begin
      gotoxy(3*x,2*y+1);
      write(virt[x,y]);
    end;
  gotoxy(3*sups,1+2*supr);
  write('* ');
  {seek(f,1);
  write(f,virt);}
  readln;
end.