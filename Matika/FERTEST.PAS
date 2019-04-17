program Testovanie_umocnovacej_rutiny;
var x,y:comp;
    c:word;
procedure Mocnina;assembler;
asm

             mov cx,0
             mov bx,0
             mov ax,c
             mul ax
             mov di,dx
             mul c
             mov si,ax
             mov cx,dx
             mov ax,di
             mul c
             add cx,ax
             adc bx,dx
end;
BEGIN
  write('Zaciatok ...');
  asm
             mov ax,0A000h
             mov es,ax
  end;
  for c:=41 to 65535 do begin
    x:=1.0*c*c*c;
    asm
      call Mocnina
      lea di,y
      mov word[di],si
      mov word[di+2],cx
      mov word[di+4],bx
      mov word[di+6],0
    end;
    if x<> y then begin
      writeln(c);
      readln;
    end;
  end;
  writeln('... Koniec');
END.