program Scrolling_plynuly;
var ikona:array[1..50,1..50] of byte;
    x,y:word;
BEGIN
  asm
         cld
         mov di,offset ikona  {generovanie pseudonahodnych cisel}
         mov cx,1250
         mov ax,03A71h
@Nahoda: stosw
         add ax,01752h
         loop @Nahoda

         mov di,offset ikona  {vyplnenie 1. stlpca nulami}
         mov cx,50
         mov al,0
@Stlpec1:mov [di],al
         add di,50
         loop @Stlpec1

         mov ax,0013h         {inicializacia grafiky}
         int 10h
         mov ax,0A000h        {inicializacia registrov}
         mov es,ax
@Znova:  mov di,0
         mov cx,50*160
         mov ax,0
     rep stosw
         mov di,0

@Posun:  mov si,offset ikona
         mov bx,50
@Riadok: mov cx,25            {presun 1 riadka}
     rep movsw
         add di,270
         dec bx
         jnz @Riadok          {dalsi riadok}

         mov dx,03DAh         {tu zacina cakanie na VOI}
@vz1:    in al,dx
         and al,08h
         jnz @vz1
@vz2:    in al,dx
         and al,08h
         jz @vz2              {koniec cakania}

         sub di,15999
         cmp di,270
         jb @Posun
         mov ah,1
         int 16h
         jz @Znova

         mov ax,0003h         {textovy mod}
         int 10h
  end;
END.