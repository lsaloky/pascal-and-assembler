program Praca_so_subormi_BMP;
uses MainGr;
var f:file;
    Paleta:array[0..768] of byte;
    i,j,x,Granul,AktStr,LastStr:word;
    b:byte;
{kazdu farbu v palete treba posunut o 2 bity dolava
 a zmenit poradie z BGR na RGB}
procedure NastavStranku;assembler;{DX=cislo stranky*Granul}
asm
             mov bx,0
             mov ax,4F05h
             int 10h                   {nastav 1.stranku}
             cld
end;
procedure ZmazObrazovku;assembler;
asm
             cld
             mov AktStr,0
             mov dx,0
             call NastavStranku
             mov ax,0A000h

             mov es,ax
{ ----- hlavny mazaci cyklus, 32 bitovy, len pre 386 a viac ----- }
@Dalsia:
      db 66h;mov ax,0F0Fh;dw 0F0Fh     {mov eax,0}
      db 66h;mov cx,16384;db 0;db 0    {mov ecx,16384}
      db 66h;mov di,0;db 0;db 0        {mov edi,0}
      db 66h;rep stosw                 {rep stosdw - aj tak ma rychlost ako stosw}
             mov dx,AktStr
             add dx,Granul
             mov AktStr,dx
             call NastavStranku
             mov ax,LastStr
             cmp AktStr,ax
             jbe @Dalsia
{ ----- 45056 pre 640 x 480, 21248 pre 800 x 600; pocet bajtov na posl. stranke ----- }
             mov dx,LastStr
             add dx,Granul
             call NastavStranku
      db 66h;mov ax,0F0Fh;dw 0F0Fh        {mov eax,0}
      db 66h;mov cx,11264{5312 pre 800 x 600};db 0;db 0     {mov ecx,5312}
      db 66h;mov di,0;db 0;db 0        {mov edi,0}
      db 66h;rep stosw                 {rep stosdw}
end;
BEGIN
{ ----- zobrazenie BMP 320 x 200 x 256 farieb, neskomprimovany ----- }
  InicializujGrafiku;
  Assign(f,'Cislopis.BMP');
  Reset(f,1);
  Seek(f,54);
  for i:=0 to 255 do BlockRead(f,Paleta[i*3],4);
  for i:=0 to 767 do Paleta[i]:=Paleta[i] shr 2;
  for i:=0 to 255 do begin
    j:=Paleta[i*3];
    Paleta[i*3]:=Paleta[i*3+2];
    Paleta[i*3+2]:=j;
  end;
  NastavPaletu(@Paleta);
  for i:=199 downto 0 do BlockRead(f,Mem[$A000:320*i],320);
  Close(f);
  Readln;
{ ----- pridanie tejto bitmapy do .MB suboru a vytvorenie .MP suboru ----- }
{  Assign(f,'3dklav.MP');
  ReWrite(f,768);
  BlockWrite(f,Paleta,1);
  Close(f);
  Assign(f,'Cislopis.MB');
  Reset(f,1);
  Seek(f,FileSize(f)-64000);
  BlockWrite(f,Mem[$A000:0000],64000);
  Close(f);}
(*{ ----- inicializacia SVGA ----- }
  asm
             mov ax,seg Paleta    {zistenie granularity}
             mov es,ax
             mov di,offset Paleta {pole Paleta sa vyuziva na na ulozenie}
             mov ax,4F01h         {struktury Vesa Info}
             mov cx,103h
             int 10h
             mov cx,word ptr Paleta+4
             mov ax,64
             div cl
             mov Granul,ax
             mov cx,3 {6 pre 800 x 600 }
             mul cx
             mov LastStr,ax       {cislo poslednej celej stranky}
             mov ax,4F02h         {nastavenie graf. modu}
             mov bx,101h{103h pre 800 x 600}
             int 10h
{             call ZmazObrazovku}
  end;
  Assign(f,'ChodbaHI.BMP');
  Reset(f,1);
  Seek(f,54);
  for i:=0 to 255 do BlockRead(f,Paleta[i*3],4);
  for i:=0 to 767 do Paleta[i]:=Paleta[i] shr 2;
  for i:=0 to 255 do begin
    j:=Paleta[i*3];
    Paleta[i*3]:=Paleta[i*3+2];
    Paleta[i*3+2]:=j;
  end;
  NastavPaletu(@Paleta);
  AktStr:=LastStr;
  asm
             mov dx,AktStr
             call NastavStranku
  end;
  for i:=479 downto 0 do begin
    j:=(longint(i)*640) mod 65536;
    if j>65536-640 then begin
      Dec(AktStr,Granul);
      asm
             mov dx,AktStr
             call NastavStranku
      end;
    end;
    BlockRead(f,Mem[$A000:j],640);
  end;
  Close(f);
  Readln; *)
END.