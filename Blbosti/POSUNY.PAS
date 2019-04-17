program Posuny_vo_VideoRAM;
uses MukoGr;
var x,y:integer;
procedure PosunVRAMSpredu(StartX,StartY,RozX,RozY,KolkoX,KolkoY:word);assembler;
asm
             mov ax,0A000h
             mov es,ax       {ES - 0A000h, DS sa nemeni}
             mov cx,320
             mov ax,KolkoY
             mul cx
             add ax,KolkoX
             xor bx,bx
             sub bx,ax       {BX - relativny offset ciela vzhladom k zdroju}
             mov ax,StartY
             mul cx
             add ax,StartX
             mov si,ax       {SI - offset zdroja}
             mov di,si       {DI - offset nasledujuceho riadka}
             add di,320
             mov dx,RozY     {DX - pocet riadkov}
@DalsiRiadok:mov cx,RozX     {CX - pocet stlpcov}
@DalsiBod:   mov al,byte[es:si]
             mov byte[es:si+bx],al
             inc si
             loop @DalsiBod
             mov si,di
             add di,320
             dec dx
             jnz @DalsiRiadok
end;
procedure PosunVRAMZozadu(StartX,StartY,RozX,RozY,KolkoX,KolkoY:word);assembler;
asm
             mov ax,0A000h
             mov es,ax       {ES - 0A000h, DS sa nemeni}
             mov cx,320
             mov ax,KolkoY
             mul cx
             add ax,KolkoX
             mov bx,ax       {BX - relativny offset ciela vzhladom k zdroju}
             mov ax,StartY
             mul cx
             add ax,StartX
             mov si,ax       {SI - offset zaciatku presuvanej oblasti}
             mov ax,RozY
             mul cx
             add ax,RozX
             sub ax,321
             add si,ax       {SI - offset praveho dolneho rohu presuvanej oblasti}
             mov di,si       {DI - offset predchadzajuceho riadka}
             sub di,320
             mov dx,RozY     {DX - pocet riadkov}
@DalsiRiadok:mov cx,RozX     {CX - pocet stlpcov}
@DalsiBod:   mov al,byte[es:si]
             mov byte[es:si+bx],al
             dec si
             loop @DalsiBod
             mov si,di
             sub di,320
             dec dx
             jnz @DalsiRiadok
end;

BEGIN
  InicializujGrafiku;
  for x:=0 to 7 do
    for y:=0 to 15 do begin
      Nastav(20+x*8,y*8,x*16+y);
      VyplnPlochu(8,8);
    end;
  readln;
  PosunVRAMSpredu(20,40,40,40,10,3);
  PosunVRAMZozadu(40,80,30,30,10,20);
  Readln;
END.
