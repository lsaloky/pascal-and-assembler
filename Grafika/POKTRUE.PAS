program Buduci_unit_pre_truecolor;
{ 10Fh = 320 x 200, 112h = 640 x 480}
uses MainGr;
type TFarba=record
             r,g,b:byte;
           end;
const Biela:TFarba=    (r:255;  g:255;  b:255);
      Cervena:TFarba=  (r:255;  g:100;  b:100);
      Zlta:TFarba=     (r:255;  g:255;  b:100);
      Cierna:TFarba=   (r:0;    g:0;    b:0);
var Granul,VSeg,AktStr:word;
    VesaInfo:pointer;
    Farba:TFarba;
{ ----- intimne procedury a funkcie ----- }
procedure NastavStrankuAOffset(x,y:word);assembler;
asm
{ ----- nastavenie aktualnej stranky ----- }
             mov ax,y
             shr ax,5
             cmp ax,AktStr
             je @Hotovo           {ak sedi aktualna stranka, nenastavuj ju}
             mov AktStr,ax
             mul Granul
             mov bx,0
             mov dx,ax
             mov ax,4F05h
             int 10h
{ ----- nastavenie offsetu na aktualnej stranke ----- }
@Hotovo:     mov ax,y
             mov ah,al
             xor al,al
             shl ah,3
             add ax,x
             add ax,x
             add ax,x
             mov es,VSeg          {ES = segment VideoRAM}
             mov di,ax            {DI = (Y MOD 32) * 2048 + X * 3 }

end;
procedure FarbaInterna;assembler; {farba je AL:AH:BL}
asm
             mov al,Farba.b
             mov ah,Farba.g
             mov bl,Farba.r
end;
procedure CiaraInterna;assembler; {CX - dlzka, AL:AH:BL farba}
asm
@DalsiBod:   mov byte[es:di],al
             mov byte[es:di+1],ah
             mov byte[es:di+2],bl
             add di,3
             loop @DalsiBod
end;
procedure InicializujGrafiku(Rezim:word);
begin
  GetMem(VesaInfo,256);
  asm
{ ----- naplnenie informacnej struktury VesaInfo ----- }
             mov es,word ptr VesaInfo+2
             mov di,word ptr VesaInfo
             mov ax,4F01h
             mov cx,Rezim
             int 10h
{ ----- zistenie granularity ----- }
             mov es,word ptr VesaInfo+2
             mov di,word ptr VesaInfo
             mov cx,word ptr [es:di+4]
             mov ax,64
             div cl
             mov Granul,ax
{ ----- samotna inicializacia ----- }
             mov ax,4F02h
             mov bx,Rezim
             int 10h
             mov AktStr,0
             mov VSeg,0A000h
  end;
end;
procedure ZavriGrafiku;
begin
  asm
             mov ax,3
             int 10h
  end;
  FreeMem(VesaInfo,256);
end;
procedure PolozBod(x,y:word);assembler;
asm
             push x
             push y
             call NastavStrankuAOffset
             call FarbaInterna
             mov byte[es:di],al
             mov byte[es:di+1],ah
             mov byte[es:di+2],bl
end;
procedure ZistiBod(x,y:word);assembler;{vrati farbu vo Farba}
asm
             push x
             push y
             call NastavStrankuAOffset
             mov al,byte[es:di]
             mov Farba.b,al
             mov al,byte[es:di+1]
             mov Farba.g,al
             mov al,byte[es:di+2]
             mov Farba.r,al
end;
procedure CiaraVodorovna(x,y,Dlzka:word);assembler;
asm
             cmp Dlzka,0
             je @Koniec
             push x
             push y
             call NastavStrankuAOffset
             call FarbaInterna
             mov cx,Dlzka
             call CiaraInterna
@Koniec:
end;
procedure CiaraZvisla(x,y,Dlzka:word);assembler;
var AktY:word;    {y-ova mod 32}
asm
             cmp Dlzka,0
             je @Koniec
{ ----- inicializacia premennych ----- }
             push x
             push y
             call NastavStrankuAOffset
             mov ax,y
             and ax,0000000000011111b
             mov AktY,ax
{ ----- kreslenie ciary ----- }
             call FarbaInterna
@DalsiBod:   cmp Dlzka,0
             je @Koniec
             mov byte[es:di],al
             mov byte[es:di+1],ah
             mov byte[es:di+2],bl
             add di,2048
             inc AktY
             dec Dlzka
             cmp AktY,32
             jb @DalsiBod
{ ----- prechod cez stranku ----- }
             mov AktY,0
             inc AktStr
             mov ax,AktStr
             mul Granul
             mov bx,0
             mov dx,ax
             mov ax,4F05h
             int 10h
             call FarbaInterna
             jmp @DalsiBod
@Koniec:
end;
procedure VyplnPlochu(x,y,DlzkaX,DlzkaY:word);assembler;
var AktY,ZacOfs:word;
asm
             cmp DlzkaX,0
             je @Koniec
             cmp DlzkaY,0
             je @Koniec
{ ----- inicializacia premennych ----- }
             push x
             push y
             call NastavStrankuAOffset
             mov ax,y
             and ax,0000000000011111b
             mov AktY,ax
             mov ZacOfs,di
{ ----- kreslenie plochy ----- }
@DalsiRiadok:cmp DlzkaY,0
             je @Koniec
             mov al,Farba.b {farba je AL:AH:BL}
             mov ah,Farba.g
             mov bl,Farba.r
             mov cx,DlzkaX
             call CiaraInterna
             dec DlzkaY{dalsi riadok}
             inc AktY
             add ZacOfs,2048
             mov di,ZacOfs
             cmp AktY,32
             jb @DalsiRiadok
{ ----- prechod cez stranku ----- }
             mov AktY,0
             inc AktStr
             mov ax,AktStr
             mul Granul
             mov bx,0
             mov dx,ax
             mov ax,4F05h
             int 10h
             jmp @DalsiRiadok
@Koniec:
end;
var i,j,k,Riadok:word;
    Snimka,Posun:byte;
BEGIN
  InicializujGrafiku($112);
  asm
{!}          mov Posun,3
             mov es,VSeg
@DalsiObraz: xor ah,ah
             mov al,Snimka
             xor di,di
             add di,ax
             add di,ax
             add di,ax
@DalsiRiadok:mov ah,byte ptr Riadok{AH - zelena suradnica rastie v riadku}
{!}          mov cx,127{255}{127}
             cmp Riadok,255
             jbe @DalsiBod     {pre viac ako 255 riadkov iny efekt}
             not ah
@DalsiBod:   mov bl,cl         {BL - cervena suradnica rastie v stlpci}
             mov bh,al         {AX:BX:DX su dve farby za sebou}
             mov dl,ah
             inc dl
             jnz @Nechaj
             mov dl,255
@Nechaj:     mov dh,bl
             mov word[es:di],ax
             mov word[es:di+2],bx
             mov word[es:di+4],dx
             add di,6
             loop @DalsiBod    {-> DalsiBod - cyklus pre 1 riadok}
{!}          add di,2048-6*127
             inc Riadok
{!}          cmp Riadok,480{255}{480}{200}
             ja @Hotovo
             test Riadok,00011111b
             jnz @DalsiRiadok  {-> DalsiRiadok - ak nie je prechod cez stranku}
             inc AktStr
             pusha
             mov ax,AktStr
             mul Granul
             mov bx,0
             mov dx,ax
             mov ax,4F05h
             int 10h           {prechod cez stranku}
             popa
             jmp @DalsiRiadok
@Hotovo:     mov al,Posun
             add Snimka,al
             mov Riadok,0
             mov AktStr,0
             xor bx,bx
             xor dx,dx
             mov ax,4F05h
             int 10h           {na 0. stranku}
             xor ax,ax
{!}          cmp Snimka,252
             jb @DalsiObraz
{!}          cmp Posun,-3
             je @Koniec
{!}          mov Posun,-3
             jmp @DalsiObraz
@Koniec:
  end;
  Farba:=Cervena;
  PolozBod(260,100);
  Farba:=Zlta;
  CiaraVodorovna(10,69,300);
  Farba:=Biela;
  CiaraZvisla(6,11,159);
  VyplnPlochu(10,10,100,50);
  ReadLn;
  ZavriGrafiku;
END.