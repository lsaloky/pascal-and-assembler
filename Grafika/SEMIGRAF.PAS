program Kreslenie_podla_semigrafiky;
const odtien:array[1..23] of byte=(16,31,20,25,28,30,28,29,23,27,26,27,25,26,27,25,26,24,27,21,26,27,25);
var f:text;
    s:string[80];
    x,y,z,ofs:word;
    pouzite:array[1..50] of char;
BEGIN
  Assign(f,'obrazok.txt');
  Reset(f);
  asm
             mov ax,13h
             int 10h
  end;
  ofs:=0;
  repeat
    readln(f,s);
    for x:=1 to Length(s) do begin
      y:=1;
      while (s[x]<>pouzite[y]) and (pouzite[y]<>#0) do Inc(y);
      if pouzite[y]=#0 then pouzite[y]:=s[x];
      asm
             mov ax,0A000h
             mov es,ax
             mov di,ofs
             lea si,odtien
             add si,y
             sub si,1
             mov al,byte[si]
             mov byte[es:di],al
             inc ofs
      end;
    end;
    ofs:=ofs+320-Length(s);
  until EOF(f);
  Close(f);
  readln;
  asm
             mov ax,3
             int 10h
  end;  
  WriteLn('MukoSoft TextDoObrazka'#13#10'Lubos Saloky, 1996');
END.
