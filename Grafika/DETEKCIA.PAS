program Praca_s_SVGA_grafickymi_modmi_a_VESA_BIOSom;
const Hex:array[0..15] of char=('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
type TBufferFunkcie00=record
       Signature:array[1..4] of char;
       Version:word;
       OEMNameOfs,OEMNameSeg:word;  {toto je pointer}
       Capabilities:array[1..4] of byte;
       ModesOfs,ModesSeg:word;      {tiez pointer}
       Reserved:array[1..238] of byte;
     end;
     TBufferFunkcie01=record
       ModeAttr:word;
       WindowAAttr,WindowBAttr:byte;
       Granularity,Size,StartSegA,StartSegB:word;
       WPF:pointer;
       BytesPerLine,Width,Height:word;
       CharWidth,CHarHeight,NumOfPlanes,BytesPerPixel,NumOfBanks,MemoryModel,SizeOfBank,NumOfImagePages,Reserved:byte;
       {VBE Vesa 1.2+}
       RedMaskSize,RedMaskPos,GreenMaskSize,GreenMaskPos,BlueMaskSize,BlueMaskPos,MaskSize,MaskPos,DSMI,Res2:byte;
     end;
var b00:TBufferFunkcie00;
    b01:TBufferFunkcie01;
    navrat00,navrat01,c1,pom2:word;
    pom:byte;
    MOdy:array[1..15] of word absolute 3002:118;
procedure TestujUspesnost(navrat:word);
begin
  write('Funkcia ');
  if Lo(navrat)<>$4F then write('nie ');
  write('je podporovan  a ');
  if Hi(navrat)=$01 then write('ne');
  writeln('£spesne vykonan .');
end;
BEGIN
  writeln;
  writeln;
  asm
    mov ax,seg b00
    mov es,ax
    mov di,offset b00
    mov ax,$4F00
    int $10
    mov navrat00,ax
    mov ax,seg b01
    mov es,ax
    mov di,offset b01
    mov ax,$4F01
    mov cx,$101
    int $10
    mov navrat01,ax
  end;
  write('Get SuperVGA Information. ');
  TestujUspesnost(navrat00);
  writeln('Verzia VESA: ',Hi(b00.Version),'.',Lo(b00.Version));
  write('Meno vyrobcu: ');
  pom:=1;c1:=0;
  while pom<>0 do begin
    pom:=Mem[b00.OEMNameSeg:b00.OEMNameOfs+c1];
    write(Chr(pom));
    Inc(c1);
  end;
  writeln;
  writeln('Zoznam podporovanych VESA modov: ');
  pom2:=MemW[b00.ModesSeg:b00.ModesOfs];c1:=2;
  while pom2<>$FFFF do begin
    case pom2 of
      $100:writeln('640 x 400, 256 farieb');
      $101:writeln('640 x 480, 256 farieb');
      $102:writeln('800 x 600, 16 farieb');
      $103:writeln('800 x 600, 256 farieb');
      $104:writeln('1024 x 768, 16 farieb');
      $105:writeln('1024 x 768, 256 farieb');
      $106:writeln('1280 x 1024, 16 farieb');
      $107:writeln('1280 x 1024, 256 farieb');
    {VBE Vesa 1.2+}
      $10D:writeln('320 x 200, 32768 farieb');
      $10E:writeln('320 x 200, 65536 farieb');
      $10F:writeln('320 x 200, 16776216 farieb');
      $110:writeln('640 x 480, 32768 farieb');
      $111:writeln('640 x 480, 65536 farieb');
      $112:writeln('640 x 480, 16776216 farieb');
      $113:writeln('800 x 600, 32768 farieb');
      $114:writeln('800 x 600, 65536 farieb');
      $115:writeln('800 x 600, 16776216 farieb');
      $116:writeln('1024 x 768, 32768 farieb');
      $117:writeln('1024 x 768, 65536 farieb');
      $118:writeln('1024 x 768, 16776216 farieb');
      $119:writeln('1280 x 1024, 32768 farieb');
      $11A:writeln('1280 x 1024, 65536 farieb');
      $11B:writeln('1280 x 1024, 16776216 farieb');
      $108:writeln('80 x 60 text');
      $109:writeln('132 x 25 text');
      $10A:writeln('132 x 43 text');
      $10B:writeln('132 x 50 text');
      $10C:writeln('132 x 60 text');
    end;
    pom2:=MemW[b00.ModesSeg:b00.ModesOfs+c1];
    c1:=c1+2;
  end;
  writeln;
  writeln('Get SuperVGA mode information - 640 x 480,256 farieb');
  TestujUspesnost(Navrat01);
END.
