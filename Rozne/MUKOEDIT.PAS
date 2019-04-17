program Najkratsi_editor_textov;
{$M 16784,0,65536}
var Data0:word;
    Data:array[0..59999] of char;
    Subor:array[0..14] of char;
    TempBP,FHandle:word;
    Dlzka:word;                   {dlzka suboru a struktury Data}
    AktPos:word;                  {aktualna pozicia laveho horneho rohu obrazovky v strukture Data}
    ObrPos:word;                  {obrazova pozicia kurzora - offset v strukture Data od zaciatku obrazovky}
    PosKurz:word;                 {pozicia textoveho kurzora - x-ova sur. je Byte Ptr PosKurz}
    IndexZac,IndexKon:word;       {index pociatocnej a koncovej pozicie v akt. riadku}
const VSeg:word=$B800;
      Intro:array[1..16] of char=(#0,#0,#13,'N',' ','z','o','v',' ','s','£','b','o','r','u',':');
{$I mukoedit.inc}
BEGIN
  asm
{ ----- INICIALIZACIA ----- }
             mov byte ptr Subor,13      {maximalny pocet znakov pre nazov suboru + #0}
             mov word ptr AktPos,0      {aktualny riadok v poli Data }
             mov word ptr PosKurz,0     {aktualna pozicia kurzora}
             mov word ptr ObrPos,0      {aktualne pismeno v riadku v poli Data}
             mov word ptr Data0,0A0Ah   {!!!!!}
             call ZmazObrazovku
{ ----- UVODNA OBRAZOVKA ----- }
             lea si,Intro
             call VypisRetazca    {vypis uvodneho textu}
             mov dx,000Eh
             call NastavKurzor    {nastavenie kurzora}
             mov ah,0Ah
             lea dx,Subor
             int 21h              {nacitanie nazvu suboru}
{ ----- UPRAVA NAZVU SUBORU ----- }
             lea si,Subor         {pridanie #0 na koniec nazvu}
             xor bh,bh
             mov bl,byte ptr [si+1]
             add bx,si
             mov byte ptr[bx+2],0
{ ----- NACITANIE SUBORU ----- }
             mov ax,3D02h
             lea dx,Subor
             add dx,2
             int 21h              {otvorenie READ/WRITE}
             mov FHandle,ax
             mov bx,ax
             mov ah,3Fh
             lea dx,Data
             mov cx,60000
             int 21h              {nacitanie}
             mov Dlzka,ax
{ ----- PRIPRAVA NA EDITACIU ----- }
             call ZmazObrazovku
             call VypisSubor
             call NastavIndexy
{ ----- HLAVNY CYKLUS ----- }
@DalsiZnak:  mov ah,0
             int 16h              {citanie znaku}
             cmp al,27            {Esc}
             je @Koniec

             cmp ah,3Ch           {F2}
             je @Uloz
{ ----- SIPKA VPRAVO ----- }
             cmp ah,4Dh
             jne @Dalej1
             mov ax,AktPos
             add ax,ObrPos
             cmp ax,IndexKon      {len ak je to pripustne}
             jae @DalsiZnak
             inc PosKurz
             mov dx,PosKurz
             call NastavKurzor
             inc ObrPos
             jmp @DalsiZnak
{ ----- SIPKA VLAVO ----- }
@Dalej1:     cmp ah,4Bh
             jne @Dalej2
             mov ax,AktPos
             add ax,ObrPos
             cmp ax,IndexZac      {len ak je to pripustne}
             jbe @DalsiZnak
             dec PosKurz
             mov dx,PosKurz
             call NastavKurzor
             dec ObrPos
             jmp @DalsiZnak
{ ----- SIPKA DOLE ----- }
@Dalej2:     cmp ah,50h
             jne @Dalej3
             inc byte ptr PosKurz+1
             mov dx,PosKurz
             call NastavKurzor
             mov ax,IndexKon
             sub ax,IndexZac
             add ax,2
             add ObrPos,ax        {uprav ObrPos}
             call NastavIndexy
             jmp @DalsiZnak
{ ----- SIPKA HORE ----- }
@Dalej3:     cmp ah,48h
             jne @Dalej4
             dec byte ptr PosKurz+1
             mov dx,PosKurz
             call NastavKurzor
             mov ax,ds
             mov es,ax
             std
             mov cx,60000
             mov al,10
             lea di,Data
             add di,AktPos
             add di,ObrPos
       repne scasb
             mov bx,di
       repne scasb
             sub bx,di
             sub ObrPos,bx        {uprav ObrPos}
             call NastavIndexy
             jmp @DalsiZnak
{ ----- TU JE SAMOTNE PRIDANIE OBYCAJNEHO PISMENA ----- }
@Dalej4:     lea di,Data
             add di,AktPos
             add di,ObrPos
             mov byte[ds:di],al   {ulozenie znaku}
             inc ObrPos
             inc byte ptr PosKurz
             mov ah,02h
             mov dl,al
             int 21h              {vypisanie znaku}
             jmp @DalsiZnak
{ ----- ULOZENIE SUBORU ----- }
@Uloz:       mov ax,4200h         {nastavenie na zaciatok}
             mov bx,FHandle
             xor cx,cx
             xor dx,dx
             int 21h
             mov ah,40h           {zapis}
             mov bx,FHandle
             mov cx,Dlzka
             lea dx,Data
             int 21h
{ ----- KONIEC PRACE ----- }
@Koniec:     mov ah,3Eh           {zavretie suboru}
             mov bx,FHandle
             int 21h
             call ZmazObrazovku
             mov dx,0
             call NastavKurzor    {kurzor daj vlavo hore}
  end;
END.