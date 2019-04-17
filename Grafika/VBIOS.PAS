program Pokusy_s_VideoBiosom_SVGA;
uses Dos,Crt;
{PC Revue 5/1996, str. 76}
{pozor na $4F01}
type TInformationBuffer=record
       Znacka:array[1..4] of char;
       Verzia,OEMLo,OEMHi:word;{pointer na meno OEM}
       Capabilities:array[1..4] of char;
       VMLo,VMHi:word;   {pointer na vsetky podporovane mody}
       Rezerva:array[1..238] of char;
     end;
     TVideoModeBuffer=record
       Atribut:word;
       OknoA,OknoB:byte;
       Gran:word;   {window granularity in K}
       Size:word;   {window size in K}
       SSA:word;    {start segment of window A}
       SSB:word;    {start segment of window B}
       NeviemCo:pointer;
       PB:word;     {pocet bytov na scan line}
          {----- dalej je povinne len pre OEM mody}
       Sirka,Vyska:word;
       SirkaZnaku,VyskaZnaku:byte;{len pre textove mody}
       Planes:byte;  {number of memory planes}
       Hlbka:byte;   {pocet bitov na pixel}
       PocetBaniek,PM:byte;{pamatovy model}
       Bank:byte;    {size of bank in K}
       IP:byte;      {number of image pages}
       rezerva:byte; {malo by byt 0}
          {----- dalej len VBE v1.2+}
       RS,RP,GS,GP,BS,BP,RsS,RsP:byte;{Red|Green|Blue|Reserved mask Size|Position}
       rezerva2:array[0..255] of byte;
     end;
var Info:TInformationBuffer;
    MInfo:TVideoModeBuffer;
    x,y:word;
    r:registers;
    ch:char;
procedure Podpora;
begin
  writeln('Graficka karta podporuje tuto funkciu.');
  if r.AH=0 then writeln('Funkcia uspesne vyvolana');
  if r.AH=1 then writeln('!!! Neuspesne volanie funkcie !!!');
end;

BEGIN
  ClrScr;
  writeln;
  writeln('Funkcia $4F00 - Get SuperVGA Information');
  r.AX:=$4F00;
  r.ES:=Seg(Info);{ES:DI je pointer na 256-bajtovy buffer pre informacie}
  r.DI:=Ofs(Info);
  Intr($10,r);
  if r.AL=$4F then begin
    Podpora;
    writeln('Verzia VESA adaptera: ',Hi(Info.Verzia),'.',Lo(Info.Verzia));
    y:=0;
    write('Meno vyrobcu: '); {pozor, 24 znakovy OEM partner nemusi byt vzdy}
    for x:=0 to 23 do write(Chr(Mem[Info.OEMHi:Info.OEMLo+x]));
    writeln;
    ch:=ReadKey;

{    write('Podporovane mody: ');
    y:=0;
    repeat
      x:=MemW[Info.VMHi:Info.VMLo+y];
      write(x,',');
      Inc(y);
    until x=$FFFF; }
  end;
  writeln;
  writeln('Funkcia $4F01 - Get SuperVGA Mode Information');
  r.AX:=$4F01;
  r.ES:=Seg(MInfo);{ES:DI je pointer na 256-bajtovy buffer pre informacie}
  r.DI:=Ofs(MInfo);
  Intr($10,r);   {volanie tejto funkcie sposobi problemy s Pascalom}
  if r.AL=$4F then Podpora;
  ch:=readkey;

  r.AX:=$4F02;
  r.BX:=$0112;    {640 x 480 x 256}
  Intr($10,r);
  TextMode(3);
  writeln;
  writeln('Funkcia $4F02 - Set SuperVGA Video Mode');
  writeln('Stlac Enter');
  ch:=ReadKey;
  if r.AL=$4F then Podpora;
  r.AX:=$4F03;
  Intr($10,r);
  TextMode(3);
  writeln;
  writeln('Funkcia $4F03 - Get Current Video Mode');
  if r.AL=$4F then begin
    Podpora;
    writeln('Aktualny mod: ',r.BX);
  end;
  ch:=ReadKey;

END.
