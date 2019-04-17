unit disky;
{$s-,r-,v-,i-,b-,f+}
interface
Uses Dos;
type InfoBlok=record
                DiskJednotka:byte;
                VolneAlokJednotky:word;
                CelkemAlokJednotek:word;
                ByteSektor:word;
                SektorAlok:word;
              end;
     TypyDisku=(fd360kb,fd720kb,fd1200kb,fd1440kb,NestandardFd,Harddisk,Ramdisk,NeznamyDisk);
Function PocetDisku:byte;
Procedure NastavDisk(Disk:char);
Function PracovniDisk:char;
Procedure InfoDisk(Disk:char;var Info:InfoBlok);
Function TypDisku(Disk:char):TypyDisku;

implementation
var reg:registers;
Function PocetDisku:byte;
begin
  reg.ah:=$19;
  MsDos(reg);
  reg.DL:=reg.AL;
  reg.AH:=$0E;
  MsDos(reg);
  PocetDisku:=reg.AL;
end;
Procedure NastavDisk(Disk:char);
begin
  Disk:=UpCase(Disk);
  if Disk in ['A'..'Z'] then reg.DL:=ord(Disk)-65
                        else Exit;
  reg.AH:=$0E;
  MsDos(reg);
end;
Function PracovniDisk:Char;
begin
  reg.AH:=$19;
  MsDos(reg);
  PracovniDisk:=Chr(reg.AL+Ord('A'));
end;
Procedure InfoDisk(Disk:char;var Info:InfoBlok);
begin
  Disk:=UpCase(Disk);
  with reg do begin
    if Disk=' ' then begin
      DL:=0;
      Info.DiskJednotka:=0;
    end
    else begin
      if Disk in['A'..'Z'] then begin
        DL:=Ord(Disk)-64;
        Info.DiskJednotka:=DL;
      end
      else begin
        Info.DiskJednotka      :=0;
        Info.VolneAlokJednotky :=0;
        Info.CelkemAlokJednotek:=0;
        Info.ByteSektor        :=0;
        Info.SektorAlok        :=0;
        Exit;
      end;
    end;
    AH:=$36;
    MsDos(reg);
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
Function TypDisku(Disk:char):TypyDisku;
type Parametry=record
                 CisloDisku,OvladacDisku          :byte;
                 ByteNaSektor                     :word;
                 SektoruNaJednotku,ShiftFaktor    :byte;
                 RezervovaneSektoryProBoot        :word;
                 KopieFAT                         :byte;
                 RootZaznamy,PrvniDatovySektor    :word;
                 NejvyssiAlokJednotka             :word;
                 SektoruProFAT                    :byte;
                 PrvniSektorProRoot               :word;
                 AdresaOvladace                   :pointer;
                 IDMedia2a3                       :byte;
                 IDMedia4a5                       :byte;
                 NasledujiciBlokParametru         :pointer;
               end;
     ParametryPTR=^Parametry;
var CisloDisku,MediaDeskriptor:byte;
begin
  TypDisku:=NeznamyDisk;
  Disk:=UpCase(Disk);
  if Disk in ['A'..'Z'] then CisloDisku:=Ord(Disk)-64
                        else Exit;
  with Reg do begin
    AH:=$1C;
    DL:=CisloDisku;
    MsDos(reg);
    MediaDeskriptor:=Mem[DS:BX];
    AH:=32;
    DL:=CisloDisku;
    MsDos(reg);
    if AL=$FF then Exit;
    TypDisku:=NeznamyDisk;
    with ParametryPTR(PTR(DS,BX))^ do begin
      if KopieFAT=1 then Typdisku:=RamDisk;
      if MediaDeskriptor=$F8 then TypDisku:=HardDisk;
      if (MediaDeskriptor=$F0) and (NejvyssiAlokJednotka=2848) then TypDisku:=FD1440KB;
      if MediaDeskriptor>=$F9 then
        case NejvyssiAlokJednotka of
             355:TypDisku:=FD360KB;
        714,1423:TypDisku:=FD720KB;
            2372:TypDisku:=FD1200KB;
        end;
     end;
  end;
end;
end.