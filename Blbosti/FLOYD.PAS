program Floyd_Steinberg;
uses Graph;
const gd:integer=9;
      gm:integer=2;
      DvaNa:array[0..7] of byte=(1,2,4,8,16,32,64,128);
var bod:real;
    x,y:word;
    BodL:Longint;
    VRAM:array[0..479,0..79] of byte absolute $A000:$0000;
begin
  bod:=0;BodL:=0;
  InitGraph(gd,gm,'d:\bp\bgi');
  PortW[$3C4]:=$0102;  {do bitovej roviny modrej farby}
  for y:=0 to 479 do begin
    for x:=0 to 639 do begin
      bod:=bod+sqrt(sqr(x)+sqr(y))/800;
      if bod>=1 then begin
        VRAM[y,x shr 3]:=VRAM[y,x shr 3]+DvaNa[x and $0007];
        bod:=bod-1;
      end;
    end;
    bod:=0;
  end;
  ReadLn;
  ClearDevice;
  PortW[$3C4]:=$0902;  {do bitovej roviny modrej farby}
  for y:=0 to 479 do begin
    for x:=0 to 639 do begin
      bod:=bod+sqrt(x*x+y*y)/800;
      if bod>=1 then begin
        VRAM[y,x shr 3]:=VRAM[y,x shr 3]+DvaNa[x and $0007];
        bod:=bod-1;
      end;
    end;
    bod:=0;
  end;
  Readln;
  ClearDevice;
  PortW[$3C4]:=$0902;  {do bitovej roviny modrej farby}
  for y:=0 to 479 do
    for x:=0 to 639 do begin
      BodL:=BodL+round(sqrt(x*x+y*y));
      if BodL>=800 then begin
        VRAM[y,x shr 3]:=VRAM[y,x shr 3]+DvaNa[x and $0007];
        BodL:=BodL-800;
      end;
    end;
  Readln;
  CloseGraph;
  Writeln('MukoSoft graficky efekt'#13#10'Lubos Saloky,1995');
end.
