program Prepinane_intenzity_a_blikania;{8 alebo 16 farieb pozadia}
uses Crt;
var x,y:word;
BEGIN
  TextBackGround(0);
  ClrScr;
  asm
             mov ax,1003h
             mov bx,1
             int 10h
  end;
  for y:=0 to 15 do begin
    for x:=0 to 15 do begin
      TextAttr:=(x+16*y);
      write(x);
      if x<10 then write(' ');
      write('   ');
    end;
  end;
  readln;
  asm
             mov ax,1003h
             mov bx,0
             int 10h
  end;
  readln;
END.