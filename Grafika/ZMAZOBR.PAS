program Rychlost_SVGA;
{zmazanie obrazovky: 23 x za sekundu}
var VesaInf:array[0..255] of byte;
    x,Granul,AktStr,LastStr:word;
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
      db 66h;mov ax,0;db 0;db 0        {mov eax,0}
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
{ ----- 21248 bajtov na posl. stranke ----- }
             mov dx,LastStr
             add dx,Granul
             call NastavStranku
      db 66h;mov ax,0;db 0;db 0        {mov eax,0}
      db 66h;mov cx,5312;db 0;db 0     {mov ecx,5312}
      db 66h;mov di,0;db 0;db 0        {mov edi,0}
      db 66h;rep stosw                 {rep stosdw}
end;
BEGIN
  asm
             mov ax,seg VesaInf        {zistenie granularity}
             mov es,ax
             mov di,offset vesainf
             mov ax,4F01h
             mov cx,103h
             int 10h
             mov cx,word ptr VesaInf+4
             mov ax,64
             div cl
             mov Granul,ax
             mov cx,6
             mul cx
             mov LastStr,ax            {cislo poslednej celej stranky}
             mov ax,4F02h              {nastavenie graf. modu}
             mov bx,103h
             int 10h
             call ZmazObrazovku
             mov ax,0
             int 16h

  end;
END.