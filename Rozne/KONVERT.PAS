program konvertuj602;
uses Printer;
const pocet=32;
      zdroj:string[pocet]=(#$8C#$A8#$87#$9F#$91#$98#$A0#$A1#$82#$84#$A3#$A4#$93#$83#$A2#$8D#$AA#$9C#$9B#$80#$86#$92#$9D#$8F+
        #$8B#$90#$97#$A5#$85#$95#$8A#$AB);
      ciel :string[pocet]=(#$7C#$7B#$5E#$5D#$5C#$5B#$3E#$3C#$82#$84#$24#$D3#$7E#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
        #$00#$00#$00#$00#$00#$00#$00#$00);
      exten:string       =(#$60#$08#$64#$7D#$08#$6F#$7D#$08#$6C#$7D#$08#$72#$60#$08#$4C#$60#$08#$53#$60#$08#$43#$60#$08#$54+
        #$60#$08#$5A#$7D#$08#$59#$7D#$08#$41#$7D#$08#$49#$7D#$08#$45#$40#$08#$41#$7D#$08#$55#$60#$08#$4E#$60#$08#$4F#$60#$08+
        #$44#$7D#08#$4F#$7D#$08#$4C#$7D#$08#$52);
var s:string;
    fi:file;
    Buf:array[1..128]of Char;
    buf2:array[1..384]of char;
    x,y,z,tamje,NumRead:word;
begin
  writeln('Zadaj subor');
  readln(s);
  Assign(fi,s);
  Reset(fi,1);
  z:=1;
  BlockRead(fi,s,100,NumRead);
  BlockRead(fi,s,SizeOf(s),NumRead);
  s[0]:=#128;
  writeln(s);
  tamje:=pos(#0#0#0#0,s);
  if tamje=0 then begin
    writeln('Chyba!!! nie je to dokument z T602!!!');
    Exit;
  end;
  Reset(fi,1);
  repeat
    BlockRead(fi,Buf,SizeOf(Buf),NumRead);
    for x:=1 to NumRead do begin
      for y:=1 to pocet do
        buf2[z]:=buf[z];
        if buf[x]=zdroj[y] then begin
          buf2[z]:=ciel[y];
          if y>13 then begin
            buf2[z]:=exten[(y-13)*3-2];
            buf2[z+1]:=exten[(y-13)*3-1];
            buf2[z+2]:=exten[(y-13)*3];
            z:=z+2;
          end;
          y:=pocet;
        end;
      Inc(z);
    end;
  until NumRead = 0;
  for x:=1 to z do write(lst,buf2[x]);
  writeln(lst,' ');
  Close(fi);
end.