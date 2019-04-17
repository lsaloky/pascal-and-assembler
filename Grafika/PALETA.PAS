program Priamy_pristup_k_palete_VGA;
uses Dos,Farby;         {PC revue 1/96}
var v:array[0..199,0..319] of byte absolute $A000:$0000;{video RAM 320x200}
    reg:registers;
    r,g,b:byte;
    x,y,count,hod,min,sec,s100:word;
    time:real;
BEGIN
  reg.AX:=$0013;
  Intr($10,reg);
  FillChar(v,SizeOf(v),1);
  readln;
  NastavFarbu(1,0,0,0);    {nastavi farbu 1 na ciernu}
  ZistiFarbu(2,r,g,b);     {precita farbu 2 do premennych r,g,b}
  FillChar(v,SizeOf(v),2);
  VypniZobrazovanie;
  readln;
  ZapniZobrazovanie;
  readln;
  for x:=0 to 319 do
    for y:=0 to 199 do
      v[y,x]:=random(256);
  GetTime(hod,min,sec,s100);
  time:=hod*3600+min*60+sec+s100/100;
  for count:=1 to 1000 do RotujPaletu(0,255,1);
  GetTime(hod,min,sec,s100);
  time:=hod*3600+min*60+sec+s100/100-time;
  reg.AX:=$0002;
  Intr($10,reg);
  writeln('1000 rotacii cez DAC (v sekundach): ',time);
  writeln('Stlac Enter');
  readln;
END.