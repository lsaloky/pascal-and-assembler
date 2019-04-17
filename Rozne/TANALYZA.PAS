program Analyza_textu;
const pripustne:set of char=(['a'..'z','A'..'Z',#39]);{z tychto znakov je slovo}
      maxLen=16;                                      {max. dlzka slova}
      maxPocet=3000;
type TPolozka=record
                 slovo:string[MaxLen];
                 pocet:word;
               end;
var f:file;
    ftab:file of TPolozka;
    buf:array[1..1024] of char;
    slovo:string;
    x,y,z,c1,NumRead,pozicia,najdeny,max,maxindex:word;
    tabulka:array[1..maxPocet]of TPolozka;
BEGIN
  writeln;
  Assign(f,'e:\readme.txt');
  Reset(f,1024);
  Assign(ftab,'panzslov.dat');
{ ----- odtialto pre (2),(3) ----- }
  Reset(ftab);
  y:=1;
  while not EOF(ftab) do begin
    Read(ftab,tabulka[y]);
    Inc(y);
  end;
{ ----- triedenie podla dlzky (2) ----- }
  for z:=MaxLen downto 1 do begin
    c1:=0;
    writeln;
    writeln(z,': ');
    for x:=1 to y do
      if Length(tabulka[x].slovo)=z then begin
        c1:=c1+z+1;
        if c1>79 then begin
          readln;
          c1:=z+1;
        end;
        write(tabulka[x].slovo,' ');
      end;
  end;
{ ----- triedenie podla poctu slov (3) ----- }
(*  for z:=1 to y do begin
    max:=0;
    for x:=1 to y do
      if tabulka[x].pocet>max then begin
        max:=tabulka[x].pocet;
        maxindex:=x;
      end;
      writeln(tabulka[maxindex].slovo,' ',tabulka[maxindex].pocet);
      tabulka[maxindex].pocet:=0;
      max:=0;
      if z mod 23=0 then readln;
  end;*)
{ ----- vytvorenie zoznamu (1) ----- }
(*  ReWrite(ftab);
  slovo:='';pozicia:=1;
  for x:=1 to MaxPocet do begin
    tabulka[x].slovo:='';
    tabulka[x].pocet:=0;
  end;
  repeat
    for c1:=1 to 1024 do buf[c1]:=#0;
    BlockRead(f,buf,1,NumRead);
    for x:=1 to 1024 do begin
      if buf[x] in pripustne then slovo:=slovo+UpCase(buf[x])
      else if slovo>'' then begin
        najdeny:=0;
        for y:=1 to pozicia do if tabulka[y].slovo=slovo then najdeny:=y;
        if najdeny>0 then inc(tabulka[najdeny].pocet)
        else begin
          Inc(pozicia);
          if pozicia>MaxPocet then Halt;
          tabulka[pozicia].slovo:=slovo;
          tabulka[pozicia].pocet:=1;
        end;
        slovo:='';
      end;
    end;
    write('*');
  until NumRead=0;
  y:=2;
  while tabulka[y].pocet>0 do begin
    write(ftab,tabulka[y]);
    Inc(y);
  end;*)
  Close(ftab);
  Close(f);
END.