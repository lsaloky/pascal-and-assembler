program Setup;
uses Crt;
var f:file;
    Subor:array[0..5] of byte;
    ch:char;
    s:string;
BEGIN
  WriteLn('Mas zvukovu kartu Sound Blaster? A/N');
  ch:=ReadKey;
  if UpCase(ch)='A' then begin
    Subor[0]:=1; { True }
    WriteLn('Jeho prerusenie (interrupt): ');
    Readln(s);
    if s='' then s:='5';
    Subor[1]:=Ord(s[1])-48;
    WriteLn('Jeho DMA kanal (DMA Channel): ');
    Readln(s);
    if s='' then s:='1';
    Subor[2]:=Ord(s[1])-48;
  end;
  Subor[3]:=12;
  Subor[4]:=12;
  WriteLn('Mas joystick? A/N');
  ch:=ReadKey;
  if UpCase(ch)='A' then Subor[5]:=1; { True }
  Assign(f,'Setup.DAT');
  ReWrite(f,6);
  BlockWrite(f,Subor,1);
  Close(f);
END.



