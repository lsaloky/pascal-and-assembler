program Pokus;
uses Dos;
var hod,min,sec,s100:word;
    cas:real;
begin
  writeln('Stlac Enter');
  readln;
  GetTime(hod,min,sec,s100);
  cas:=hod*3600+min*60+sec+s100*0.01;
  asm
    mov ax,0
    mov bx,$ff00
  @for:
    inc ax        {16.777.216}
    jnz @for      {16.777.216}
    mov ax,1      {256}
    inc bx        {256}
    jnz @for      {256, 33555200 instrukcii spolu}
  end;
  GetTime(hod,min,sec,s100);
  cas:=hod*3600+min*60+sec+s100*0.01-cas;
  writeln('Vypocet trval: ',cas:1:2,'s');
  readln;
end.
   {386 sx/16  za 26 s
    486 dx4/75 za 4.3 s (notebook)
    486 sx/33  za 2.03 s
    486 dx2/66 za 1.23 s
    386 /?     za 16.5 s}