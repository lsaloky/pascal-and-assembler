program Efektivita;
{$M 16384,0,32768}
uses Dos,Crt;
const cluster=8192;








type Parametry=record
                 CisloDisku,OvladacDisku          :byte;
                 ByteNaSektor                     :word;
                 SektoruNaJednotku,ShiftFaktor    :byte;
                 RezervovaneSektoryProBoot        :word;
                 KopieFAT                         :byte;
                 RootZaznamy,PrvniDatovySektor    :word;
                 NejvyssiAlokJednotka             :word;
                 SektoruProFAT                    :word;
                 PrvniSektorProRoot               :word;
                 AdresaOvladace                   :pointer;
                 IDMedia2a3                       :byte;
                 IDMedia4a5                       :byte;
                 NasledujiciBlokParametru         :pointer;
               end;
     InfoBlok=record
                DiskJednotka:byte;
                VolneAlokJednotky:word;
                CelkemAlokJednotek:word;
                ByteSektor:word;
                SektorAlok:word;
              end;
     parametryPTR=^parametry;
var a:array[1..16000] of longint;
    r:registers;
    f:file;
    s,s2:string;
    pom,err,err2:word;
    d,suc,sc512b,sc1kb,sc2kb,sc4kb,sc8kb,sc16kb:longint;
    reg:registers;
    info:infoblok;
    data:parametry;

Function PocetDiskov:byte;
begin
  r.ah:=$19;
  MsDos(r);
  r.DL:=r.AL;
  r.AH:=$0E;
  MsDos(r);
  PocetDiskov:=r.AL;
end;

Procedure NastavDisk(Disk:char);
begin
  r.DL:=ord(Disk)-65;
  r.AH:=$0E;
  MsDos(r);
end;

Function PracovnyDisk:Char;
begin
  r.AH:=$19;
  MsDos(r);
  PracovnyDisk:=Chr(r.AL+Ord('A'));
end;

Procedure InfoDisk(Disk:char);
begin
  with r do begin
    DL:=Ord(Disk)-64;
    Info.DiskJednotka:=DL;
    AH:=$36;
    MsDos(r);
    if AX=$0FFF then begin
      Info.DiskJednotka      :=0;
      Info.VolneAlokJednotky :=0;
      Info.CelkemAlokJednotek:=0;
      Info.ByteSektor        :=0;
      Info.SektorAlok       :=0;
      Exit;
    end;
    Info.VolneAlokJednotky:=BX;
    Info.CelkemAlokJednotek:=DX;
    Info.ByteSektor:=CX;
    Info.SektorAlok:=AX;
  end;
end;

Function TypDisku(Disk:char):string;
var CisloDisku,MediaDeskriptor:byte;
begin
  TypDisku:='NeznamyDisk';
  CisloDisku:=Ord(Disk)-64;
  with R do begin
    AH:=$1C;
    DL:=CisloDisku;
    MsDos(r);
    MediaDeskriptor:=Mem[DS:BX];
    AH:=$32;
    DL:=CisloDisku;
    MsDos(r);
    if AL=$FF then Exit;
    TypDisku:='NeznamyDisk';
    move(ParametryPTR(PTR(DS,BX))^,data,sizeof(data));
    with ParametryPTR(PTR(DS,BX))^ do begin
      if KopieFAT=1 then Typdisku:='RamDisk';
      if MediaDeskriptor=$F8 then TypDisku:='HardDisk';
      if (MediaDeskriptor=$F0) and (NejvyssiAlokJednotka=2848) then TypDisku:='FD1440KB';
      if MediaDeskriptor>=$F9 then
        case NejvyssiAlokJednotka of
             355:TypDisku:='FD360KB';
        714,1423:TypDisku:='FD720KB';
            2372:TypDisku:='FD1200KB';
        end;
     end;
  end;
end;

procedure UmiestniCiarky(x,y:integer;a:longint);
var pom:string;
    l:integer;
begin
  Str(a,pom);
  l:=length(pom)-2;
  while l>1 do begin
    Insert('.',pom,l);
    l:=l-3;
  end;
  GotoXY(x,y);
  write(pom);
end;

function TypMonitora:string;
begin
  r.AH:=$12;
  r.BL:=$10;
  Intr($10,r);
  case r.CL of
    $0B:TypMonitora:='Mono';
    $08:TypMonitora:='Farebny';
    $09:TypMonitora:='EGA';
  end;
end;

function Adapter:string;
begin
  Adapter:='Neznamy';
  r.AX:=$1A00;
  Intr($10,r);
  if r.AL=$1A then
    case r.BL of
      $01:Adapter:='Hercules';
      $02:Adapter:='CGA';
      $04..$05:Adapter:='EGA';
      $07..$08:Adapter:='VGA';
      $0A..$0C:Adapter:='MCGA';
    end;
end;

procedure Umiestni(x,y:integer;l:longint);
var s:string;
begin
  GotoXY(x,y);
  Str(l,s);
  write(s);
end;
                          {hlavny program}

BEGIN
  suc:=0;sc512b:=0;sc1kb:=0;sc2kb:=0;sc4kb:=0;sc8kb:=0;sc16kb:=0;
  writeln('Cakaj chvilu, pracujem...');
  exec('c:\command.com','/c dir c:\ /s >c:\c.txt');
  Assign(f,'c:\c.txt');
  Reset(f,1);
  BlockRead(f,s,255);
  s[0]:=#255;
{  repeat
    if (s[14]=' ') and (s[1]<>#13) then begin
      pom:=pos(#13#10,s);
      if pom<>40 then writeln('Chyba 1: Nerozpoznanie, ci ide o subor alebo nie.');
      s2:=copy(s,13,10);
      Val(s2,d,err2);
      if err2<>0 then writeln('Chyba 2: Zle prevedena dlzka suboru na cislo.');
      suc:=suc+d;
      sc512b:=sc512b+(d div 512+1)*512;
      sc1kb:=sc1kb+(d div 1024+1)*1024;
      sc2kb:=sc2kb+(d div 2048+1)*2048;
      sc4kb:=sc4kb+(d div 4096+1)*4096;
      sc8kb:=sc8kb+(d div 8192+1)*8192;
      sc16kb:=sc16kb+(d div 16384+1)*16384;
      Delete(s,1,pom+1);
      s[0]:=#255;
      BlockRead(f,s[254-pom],pom+1,err);
    end
    else begin
      pom:=pos(#13#10,s);
      Delete(s,1,pom+1);
      s[0]:=#255;
      BlockRead(f,s[254-pom],pom+1,err);
    end;
  until err=0;}
  Close(f);
  clrscr;
  writeln('ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
  writeln('³ Disk C:\            ³ Nazov disku ___________ ³ Verzia MS-DOSu             ³');
  writeln('ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´');
  writeln('³  Kapacita             B =     MB  ³  Volne miesto             B =     MB   ³');
  writeln('ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´');
  writeln('³Strata sposobena velkostou clusterov: ³Charakteristika disku:               ³');
  writeln('³   Pri 512B clustroch             B   ³Cislo disku:     Ovladac disku:      ³');
  writeln('³   Pri 1KB clustroch              B   ³Pocet bajtov na sektor:              ³');
  writeln('³   Pri 2KB clustroch              B   ³Pocet sektorov na cluster:           ³');
  writeln('³   Pri 4KB clustroch              B   ³Pocet clustrov:                      ³');
  writeln('³   Pri 8KB clustroch              B   ³Shift faktor:     Pocet kopii FAT:   ³');
  writeln('³   Pri 16KB clustroch             B   ³Rezervovane sektory pre BOOT:        ³');
  writeln('ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´Zaznamy v hlavnom adresari:          ³');
  writeln('³Typ monitora:                         ³Prvy datovy sektor:                  ³');
  writeln('³Graficky adapt‚r:                     ³Pocet sektorov pre FAT:              ³');
  writeln('³                                      ³Prvy sektor hlavneho adresara:       ³');
  writeln('³                                      ³Volne clustery:                      ³');
  InfoDisk('C');
  s:=TypDisku('C');
  GotoXY(12,2);
  writeln(s);
  Gotoxy(66,2);
  write(Lo(DosVersion),'.',Hi(DosVersion));
  UmiestniCiarky(13,4,DiskSize(3));
  Gotoxy(29,4);
  write(DiskSize(3) div 1048576);
  UmiestniCiarky(53,4,DiskFree(3));
  Gotoxy(69,4);
  write(DiskFree(3) div 1048576);
  UmiestniCiarky(24,7,sc512b-suc);
  UmiestniCiarky(24,8,sc1kb-suc);
  UmiestniCiarky(24,9,sc2kb-suc);
  UmiestniCiarky(24,10,sc4kb-suc);
  UmiestniCiarky(24,11,sc8kb-suc);
  UmiestniCiarky(24,12,sc16kb-suc);
  Umiestni(54,7,data.cislodisku);
  Umiestni(73,7,data.ovladacdisku);
  Umiestni(65,8,Info.Bytesektor);
  Umiestni(68,9,Info.SektorAlok);
  Umiestni(57,10,data.nejvyssialokjednotka);
  Umiestni(55,11,data.shiftfaktor);
  Umiestni(76,11,data.kopiefat);
  Umiestni(71,12,data.rezervovanesektoryproboot);
  Umiestni(69,13,data.rootzaznamy);
  Umiestni(61,14,data.prvnidatovysektor);
  Umiestni(65,15,data.sektoruprofat);
  Umiestni(72,16,data.prvnisektorproroot);
  GotoXY(16,14);
  write(TypMonitora);
  GotoXY(20,15);
  write(Adapter);
  Umiestni(57,17,Info.VolneAlokJednotky);
  readln;
END.
