program Testovanie_rychlosti_priameho_zapisu_do_VideoRAM;
{1000 zapisov po 64000 bajtov}
uses Dos;
var hod,min,sec,stot:word;
    time:real;
BEGIN
  asm
    mov ax,0013h
    int 10h
  end;
  GetTime(hod,min,sec,stot);
  time:=hod*3600.0+min*60+sec+stot/100;
  asm
    mov ax,$a000
    mov es,ax
    mov ax,1313h
    cld
    mov bx,0
  @Znova:
    mov di,0
    mov cx,32000d
    rep stosw
    inc bx
    cmp bx,1000
    jl @Znova
  end;
  GetTime(hod,min,sec,stot);
  time:=hod*3600.0+min*60+sec+stot/100-time;
  asm
    mov ax,0003h
    int 10h
  end;
  writeln('MukoSoft testovac¡ program'#13#10'Lubos Saloky, 1996');
  writeln('Cas: ',time:0:2);
  writeln('Rychlost zapisu: ',64/time:0:2,' MB za sekundu pri sirke dat 16 bitov');
END.