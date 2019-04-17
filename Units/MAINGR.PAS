unit MainGr;   {nasledovn¡k MukoGr, hlavny graficky unit}
{VypisPO v MGP som zmenil na Vypis}
                              INTERFACE

type FontStruc=record
       OfsTab:array[0..255] of word;              {tabulka offsetov pismen}
       Verzia,Vyska,PPismen,Posun,PMedzier,SMedzer:byte;  {hlavicka}
       Rezerva:array[1..10] of byte;
       Pismo:array[0..63999] of byte;             {font}
     end;
     BMPStruc=record
       RozX,RozY:word;
       BMP:array[0..63999] of byte;
     end;
     Bezier3Struc=array[1..4,1..2] of integer;    {4 riadiace body}
     PBezier3Struc=^Bezier3Struc;
                { ----- globalne premenne unitu ----- }
const DataPath='d:\lubo\pascal\units\';
      Cierna=0;Cervena=1;Oranzova=2;Zlta=3;Zelena=4;Svetlomodra=5;Modra=6;
      Ruzova=7;Bordova=8;Hneda=9;Hnedocervena=10;
var OknoXMin,OknoXMax,OknoYMin,OknoYMax:word; {okraje okna do ktoreho sa kresli}
    VSeg:word;                                {segment VideoRAM}
    Color:byte;                               {aktualna farba}
    VypinajMys:boolean;                       {ci kazda procedura autom. vypne pri kresleni mys.}

            { ----- zakladne procedury a funkcie ----- }
Procedure InicializujGrafiku;
Procedure ZavriGrafiku;
Procedure ZmazObrazovku;
Procedure PolozBod(px,py:word;pColor:byte);                {TURBO (nespracuva MYS)}
Function ZistiBod(px,py:word):byte;
Procedure CiaraVodorovna(px,py,Dlzka:integer);             {TURBO, nema vyznam pri STOSW}
Procedure CiaraZvisla(px,py,Dlzka:integer);
Procedure Ciara(x1,y1,x2,y2:integer);
Procedure Bezier3(p:PBezier3Struc;PC:word;ColB:byte);
Procedure VyplnPlochu(px,py,DeltaX,DeltaY:integer);        {TURBO, nema vyznam pri STOSW}
            { ----- praca s bitmapami ----- }
Procedure NacitajBMP(var f:file;var p:pointer);            {subor musi byt otvoreny a nastaveny na spravnej pozicii}
Procedure NacitajAnimaciu(var f:file;Vstup:pointer);       {adresa na pole pointrov - jednotlive snimky animacie}
Procedure PrilepBMP(px,py:integer;p:pointer);              {TURBO}
Procedure PrilepBMPP(px,py:word;Zdroj:pointer);            {TURBO priehladne}
Procedure PrilepBMPPO(px,py:integer;Zdroj:pointer);        {TURBO priehladne, okno}
Procedure PrilepBMPPF(px,py:integer;p:pointer;Odtien:byte);{priehladne, odtien}
Procedure PrilepBMPPOF(px,py:integer;Zdroj:pointer;Odtien:byte);
Procedure StiahniBMP(px,py,RozX,RozY:integer;p:pointer);   {!!!!! najprv musi byt GetMem !!!!!}
            { ----- praca s fontmi ----- }
Procedure NacitajFont(Subor:string;var p:pointer);
Procedure Vypis(PosX,PosY:integer;p:pointer;Textik:string;Odtien:byte);{bez diakritiky}
Procedure VypisP(PosX,PosY:word;MSFP:pointer;Text:string;Odtien:byte);
Procedure VypisPO(PosX,PosY:integer;p:pointer;Textik:string;Odtien:byte);
Function LengthDiak(Textik:string):byte;
Function LengthPixel(p:pointer;Textik:string):word;
            { ----- praca s farbami a paletou ----- }
Procedure NastavFarbu(cislo,r,g,b:byte);
Procedure ZistiFarbu(cislo:byte;var r,g,b:byte);
Procedure NacitajPaletu(Subor:string;var p:pointer);
Procedure NastavPaletu(p:pointer);
            { ----- dalsie procedury a funkcie ----- }
Procedure Obdlznik(px,py,DeltaX,DeltaY:integer);
Procedure Ramcek(px,py,DeltaX,DeltaY,FarbaVnutra:integer);
Procedure Kruznica(sx,sy,r:integer;Col:byte);         { len 640.000 bodov /s }
Procedure CakajNaVOI;                                 {vertikalne zatemnenie}
Procedure Tlacidlo3D(px,py,RozX,RozY:word;Pismo:pointer;Napis:string;Odtien,ONadpisu:byte;Stlacene:boolean);
Procedure NacitajMGP(var f:file;var Kam:pointer);
Procedure VykresliMGP(p1,PoleBMP,PolePisma:pointer);   {sama si vypne mys}
Procedure KopirujObrazovku(VSeg1,VSeg2:word);
            { ----- procedury a funkcie nie priamo suvisiace s grafikou ----- }
Function CitajZnak:char;
Function JeZnak:boolean;
Procedure Presun(Zdroj,Ciel:pointer;Pocet:word);       {presun casti pamate - Move}
Procedure Vypln(Ciel:pointer;Pocet:word;Hodnota:byte); {vypln pamate - FillChar. Nahradza (ne)fungujuce Move a FillChar}
             { ----- nepouzitelne pre uzivatela, len pre dalsie unity ----- }
Procedure AkTrebaVypniMys;
Procedure AkTrebaZapniMys;

{Rychlost:           486 DX2/66, VESA CL 5428
  ZmazObrazovku                               166 krat    / s (10.624.000 pixelov / s)
  PolozBod                                625.000 bodov   / s
  CiaraVodorovna                        5.400.000 pixelov / s
  Ciara (Bresenham)                     2.800.000 pixelov / s
  Bezierova krivka 3. st.   1.120.000 - 2.270.000 pixelov / s (podla kvality, pouziva Ciara-u)
  Kruznica				  640.000 pixelov / s (pomale, vyuziva PolozBod)
  VyplnPlochu                           6.400.000 pixelov / s
  PrilepBMP                            11.200.000 pixelov / s
  PrilepBMPP                            5.800.000 pixelov / s
  PrilepBMPPO                           5.700.000 pixelov / s
  Vypis                                    60.000 znakov  / s (asi 4.000.000 pixelov / s)
  VypisPO                                  43.000 znakov  / s
  NastavPaletu                                800         / s
}

                         IMPLEMENTATION

       { ----- int¡mnosti, pre uz¡vatela nepr¡stupn‚ strukt£ry ----- }
const DlzElem:array[1..16] of byte=(8,8,5,6,10,11,0,0,6,10,0,6,10,20,1,5);
type pp=array[0..100] of ^FontStruc;
     TPP=^pp;
var JeMysM:boolean; { verejne je v Mys.TPU }
function IOMM:boolean;assembler; { neverejna procedura - z MYS.TPU }
asm
             mov ax,0
             int 33h
end;
procedure AkTrebaVypniMys;assembler;{neverejna procedura}
asm
             cmp JeMysM,False
             je @Koniec
             cmp VypinajMys,False
             je @Koniec
             mov ax,2
             int 33h
@Koniec:
end;
procedure AkTrebaZapniMys;assembler;{neverejna procedura}
asm
             cmp JeMysM,False
             je @Koniec
             cmp VypinajMys,False
             je @Koniec
             mov ax,1
             int 33h
@Koniec:
end;
procedure InicializujGrafiku;
begin
  asm
             mov ax,0013h
             int 10h
  end;
end; { InicializujGrafiku }
procedure ZavriGrafiku;
begin
  asm
             mov ax,3
             int 10h
  end;
end; { ZavriGrafiku }
procedure ZmazObrazovku;assembler;
asm
             call AkTrebaVypniMys
             cld
             mov es,VSeg
             mov cx,32000
             xor di,di
             xor ax,ax
         rep stosw
             call AkTrebaZapniMys
end; { ZmazObrazovku }
procedure PolozBod(px,py:word;pColor:byte);assembler;
asm
             mov es,VSeg
             mov ax,320
             mul py
             add ax,px
             mov di,ax
             mov al,pColor
             mov byte[es:di],al
end; { PolozBod }
function ZistiBod(px,py:word):byte;assembler;
asm
             call AkTrebaVypniMys
             mov es,VSeg
             mov ax,320
             mul py
             add ax,px
             mov di,ax
             mov al,byte[es:di]
             call AkTrebaZapniMys
end; { ZistiBod }
procedure CiaraVodorovna(px,py,Dlzka:integer);assembler;
asm
             call AkTrebaVypniMys
             mov cx,Dlzka
             jcxz @Koniec
             cmp cx,320
             ja @Koniec
             cld
             mov es,VSeg
             mov ax,320
             mul py
             add ax,px
             mov di,ax
             mov al,Color
             mov ah,al
             shr cx,1
             jnc @Parny
             stosb
@Parny:  rep stosw
@Koniec:     call AkTrebaZapniMys
end; { CiaraVodorovna }
procedure CiaraZvisla(px,py,Dlzka:integer);assembler;
asm
             call AkTrebaVypniMys
             mov es,VSeg
             mov ax,320
             mul py
             add ax,px
             mov di,ax
             mov al,Color
             mov cx,Dlzka
             jcxz @Koniec
             cmp cx,320
             ja @Koniec
@DalsiBod:   stosb
             add di,319
             loop @DalsiBod
@Koniec:     call AkTrebaZapniMys
end; { CiaraZvisla }
Procedure Ciara(x1,y1,x2,y2:integer);assembler;
var SmerX,SmerY:integer;
asm
             call AkTrebaVypniMys
             mov SmerX,1
             mov SmerY,320
             mov es,VSeg
{ ----- vypocet DI - pociatocny offset ----- }
             mov ax,320
             mul y1
             add ax,x1
             mov di,ax        {DI = offset pociatocneho bodu}
{ ----- vypocet SI = Abs(2 * DeltaY) a SmerY ----- }
             mov si,y2
             sub si,y1
             cmp si,0
             jg @DeltaYOK
             neg si
             mov SmerY,-320
@DeltaYOK:   add si,si
{ ----- vypocet BX = 2 * Abs(DeltaX) a SmerX ----- }
             mov bx,x2
             sub bx,x1
             cmp bx,0
             jg @DeltaXOK
             neg bx
             mov SmerX,-1
@DeltaXOK:   mov cx,bx        {CX = Delta na riadiacej osi}
             add bx,bx
{ ----- vymena smerov pri smernici >1 ----- }
             cmp bx,si
             ja @Nevymen
             mov ax,SmerX
             xchg SmerY,ax
             mov SmerX,ax
             mov cx,si        {zmen aj pocet kreslenych bodov}
             shr cx,1
             xchg si,bx
@Nevymen:    jcxz @Koniec     {je to ciara nulovej dlzky?}
             cmp cx,320
             ja @Koniec
             mov dx,bx        {DX = predikcia. Ak je >=0, ide sa dalej na nie riadiacej osi}
             shr dx,1
             neg dx           {predikcia sa inicializuje na -Delta na riadiacej osi }
             inc cx           {kresli o 1 bod viac (lebo kreslis od 0)}
{ ----- hlavny cyklus ----- }
             mov al,Color     {AL = farba ciary}
@DalsiBod:   mov byte[es:di],al
             add di,SmerX
             add dx,si        {pripocitaj 2*DeltaY}
             cmp dx,0
             jl @Neodcitaj
             add di,SmerY
             sub dx,bx        {ak treba, odpocitaj 2*DeltaX}
@Neodcitaj:  loop @DalsiBod
@Koniec:     call AkTrebaZapniMys
end;  { Ciara }
procedure Bezier3(p:PBezier3Struc;PC:word;ColB:byte);assembler;
var OldX,OldY,NewX,NewY,t:integer;
    TempColor:byte;
asm
             call AkTrebaVypniMys
             mov al,Color
             mov TempColor,al
             mov al,ColB
             mov Color,al
             mov t,0
             mov es,word ptr p+2
             mov si,word ptr p    {ES:SI ukazuje na riadiace body}
             mov ax,word ptr [es:si]
             mov OldX,ax
             mov ax,word ptr [es:si+2]
             mov OldY,ax
             mov ax,PC
             mov cx,PC
             mul cx
             mul cx
             mov di,ax            {DI = PC^3}
@For:        mov bx,t             {BX = t}
             mov cx,PC
             sub cx,bx            {CX = PC-t}
{ ----- vypocet x-ovej suradnice ----- }
             mov ax,cx
             mul cx
             mul cx
             mul word ptr [es:si]
             div di
             mov NewX,ax          {1. riadok je hotovy}
             mov ax,3
             mul cx
             mul cx
             mul bx
             mul word ptr [es:si+4]
             div di
             add NewX,ax          {2. riadok je hotovy}
             mov ax,3
             mul cx
             mul bx
             mul bx
             mul word ptr [es:si+8]
             div di
             add NewX,ax          {3. riadok je hotovy}
             mov ax,bx
             mul bx
             mul bx
             mul word ptr [es:si+12]
             div di
             add NewX,ax          {4. riadok je hotovy}
{ ----- vypocet y-ovej suradnice ----- }
             mov ax,cx
             mul cx
             mul cx
             mul word ptr [es:si+2]
             div di
             mov NewY,ax          {1. riadok je hotovy}
             mov ax,3
             mul cx
             mul cx
             mul bx
             mul word ptr [es:si+6]
             div di
             add NewY,ax          {2. riadok je hotovy}
             mov ax,3
             mul cx
             mul bx
             mul bx
             mul word ptr [es:si+10]
             div di
             add NewY,ax          {3. riadok je hotovy}
             mov ax,bx
             mul bx
             mul bx
             mul word ptr [es:si+14]
             div di
             add NewY,ax          {4. riadok je hotovy}
{ ----- hotovo, ide kreslenie ----- }
             pusha
             push OldX
             push OldY
             push NewX
             push NewY
             call Ciara
             popa
             mov es,word ptr p+2  {NEZABUDAJ, ze PUSHA neodklada segmentove registre!!!!!}
             mov ax,NewX
             mov OldX,ax
             mov ax,NewY
             mov OldY,ax
             inc t
             mov ax,t
             cmp ax,PC
             jbe @For
             mov al,TempColor
             mov Color,al
             call AkTrebaZapniMys
end;
procedure VyplnPlochu(px,py,DeltaX,DeltaY:integer);assembler;
asm
             call AkTrebaVypniMys
             cmp DeltaX,0
             je @Koniec
             cmp DeltaX,320
             ja @Koniec
             cmp DeltaY,0
             je @Koniec
             cmp DeltaY,200
             ja @Koniec
             cld
             mov es,VSeg
             mov ax,320
             mul py
             add ax,px
             mov di,ax
             mov bx,DeltaY
             mov dx,320
             sub dx,DeltaX  {v DX je 320-DeltaX}
             mov al,Color
             mov ah,al
@DalsiRiadok:mov cx,DeltaX
             shr cx,1
             jnc @Parny
             stosb
@Parny:  rep stosw
             add di,dx
             dec bx
             jnz @DalsiRiadok
@Koniec:     call AkTrebaZapniMys
end; { VyplnPlochu }
Procedure NacitajBMP(var f:file;var p:pointer);
var RozX,RozY:word;
    pomp:^BMPStruc;
begin
  RozX:=0;RozY:=0;
  BlockRead(f,RozX,1);
  BlockRead(f,RozY,1);
  if (RozX=64) and (RozY=200) then RozX:=320;{!!!!!}
  GetMem(p,RozX*RozY+4);
  pomp:=p;
  pomp^.RozX:=RozX;
  pomp^.RozY:=RozY;
  BlockRead(f,pomp^.BMP,RozX*RozY);
end;  { NacitajBitmapu }
Procedure NacitajAnimaciu(var f:file;Vstup:pointer);
type PP=array[1..100] of ^BMP;
     BMP=record
           RozX,RozY:word;
           Mapa:array[1..10000] of byte;
         end;
var p:^PP;
    PocSnim,RozX,RozY:byte;
    i:word;
begin
  p:=Vstup;
  BlockRead(f,PocSnim,1);
  BlockRead(f,RozX,1);
  BlockRead(f,RozY,1);
  for i:=1 to PocSnim do begin
    GetMem(p^[i],RozX*RozY+4);
    p^[i]^.RozX:=RozX;
    p^[i]^.RozY:=RozY;
    BlockRead(f,p^[i]^.Mapa,word(RozX)*word(RozY));
  end;
end;
Procedure PrilepBMP(px,py:integer;p:pointer);assembler;
asm
             call AkTrebaVypniMys
             cld
             push ds
             mov es,VSeg     {ES do videoram}
             lds bx,[p]      {DS:BX na rozmery bitmapy}
             cmp word ptr [bx],0
             je @Koniec
             cmp word ptr [bx],320
             ja @Koniec
             cmp word ptr [bx+2],0
             je @Koniec
             cmp word ptr [bx+2],200
             ja @Koniec
             mov si,bx
             add si,4        {DS:SI na zaciatok bitmapy}
             mov ax,320
             mul py
             add ax,px
             mov di,ax       {DI na lavy horny roh bitmapy}
             mov dx,[bx+2]   {RozY}
@DalsiRiadok:mov cx,[bx]     {RozX}
             shr cx,1
             jnc @Parny
             movsb
@Parny:  rep movsw
             add di,320
             sub di,[bx]
             dec dx
             jnz @DalsiRiadok
@Koniec:     pop ds
             call AkTrebaZapniMys
end;  { PrilepBMP }
procedure PrilepBMPP(px,py:word;Zdroj:pointer);assembler;
asm
             call AkTrebaVypniMys
             cld
             mov es,VSeg
             push ds
             lds bx,[Zdroj]       {DS:BX -> rozmery zdrojovej bitmapy}
             cmp word ptr [bx],0  {kontrola suradnic}
             je @Koniec
             cmp word ptr [bx],320
             ja @Koniec
             cmp word ptr [bx+2],0
             je @Koniec
             cmp word ptr [bx+2],200
             ja @Koniec
             mov si,bx
             add si,4             {DS:SI -> zaciatok bitmapy}
             mov ax,320
             mul py
             add ax,px
             mov di,ax            {ES:DI -> ciel vo VRAM}
             mov dx,[bx+2]        {DX = RozY}

@DalsiRiadok:mov cx,[bx]          {CX = pocet prilep. bajtov}
             shr cx,1
             jnc @Parne
             lodsb                {prilep 1. bajt}
             cmp al,0
             je @Nekresli1
             mov byte[es:di],al
@Nekresli1:  inc di
@Parne:      lodsw                {prilepuj po slovach}
             cmp al,0
             je @Nekresli2
             mov byte[es:di],al
@Nekresli2:  cmp ah,0
             je @Nekresli3
             mov byte[es:di+1],ah
@Nekresli3:  add di,2
             loop @Parne
             add di,320           {nastav sa na novu poziciu na dalsom riadku}
             sub di,[bx]
             dec dx
             cmp dx,0
             jne @DalsiRiadok
@Koniec:     pop ds
             call AkTrebaZapniMys
end;
procedure PrilepBMPPO(px,py:integer;Zdroj:pointer);assembler;
var DeltaSI,DeltaDI:word;  {kolko treba pripocitat k SI a DI pri prechode na dalsi riadok}
    InitSI,InitDI:word;    {o kolko treba posunut zaciatok prilepovania bitmapy}
    AktRozX,AktRozY:word;  {aktualne rozmery vyseku ktory sa prilepuje}
asm
{ ----- inicializacia a vypocet rozmerov a pozicie prilepovanej bitmapy ----- }
             call AkTrebaVypniMys
             cld
             les bx,[Zdroj]       {ES:BX -> zatial je bitmapa v ES}
             mov ax,OknoXMax      {kontrola suradnic}
             cmp px,ax
             jge @Koniec

             mov ax,OknoYMax
             cmp py,ax
             jge @Koniec

             mov ax,OknoXMin
             sub ax,word ptr [es:bx]
             cmp px,ax
             jle @Koniec

             mov ax,OknoYMin
             sub ax,word ptr [es:bx+2]
             cmp py,ax
             jle @Koniec

             mov ax,320
             sub ax,[es:bx]
             mov DeltaDI,ax       {inicializujem premenne, ako keby nebolo treba orezavat}
             mov DeltaSI,0
             mov InitSI,0
             mov InitDI,0
             mov ax,[es:bx]
             mov AktRozX,ax
             mov ax,[es:bx+2]
             mov AktRozY,ax

{Lavy}       mov ax,OknoXMin
             sub ax,px
             js @LavyOK
             add DeltaSI,ax       {upravy pri orezavani laveho okraja}
             add InitSI,ax
             add InitDI,ax
             add DeltaDI,ax
             sub AktRozX,ax
@LavyOK:     mov ax,px
{Pravy}      add ax,[es:bx]
             sub ax,OknoXMax
             js @PravyOK
             dec ax
             add DeltaSI,ax       {upravy pri orezavani praveho okraja}
             add DeltaDI,ax
             sub AktRozX,ax
@PravyOK:    mov cx,OknoYMin
{Horny}      sub cx,py
             js @HornyOK
             sub AktRozY,cx       {upravy pri orezavani horneho okraja}
             mov ax,320
             mul cx
             add InitDI,ax
             mov ax,[es:bx]
             mul cx
             add InitSI,ax
@HornyOK:    mov cx,py
             add cx,[es:bx+2]
             sub cx,OknoYMax
             js @DolnyOK
             dec cx
             sub AktRozY,cx

@DolnyOK:    mov es,VSeg
             push ds
{!!!!!}      lds bx,[Zdroj]       {DS:BX -> rozmery zdrojovej bitmapy}
             mov si,bx
             add si,4
             add si,InitSI        {DS:SI -> zaciatok bitmapy}
             mov ax,320
             mul py
             add ax,px
             add ax,InitDI
             mov di,ax            {ES:DI -> ciel vo VRAM}
             mov dx,AktRozY       {DX = RozY}

@DalsiRiadok:mov cx,AktRozX       {CX = pocet prilep. bajtov}
             shr cx,1
             jnc @Parne
             lodsb                {prilep 1. bajt}
             cmp al,0
             je @Nekresli1
             mov byte[es:di],al
@Nekresli1:  inc di
             cmp cx,0
             je @RiadokOK
@Parne:      lodsw                {prilepuj po slovach}
             cmp al,0
             je @Nekresli2
             mov byte[es:di],al
@Nekresli2:  cmp ah,0
             je @Nekresli3
             mov byte[es:di+1],ah
@Nekresli3:  add di,2
             loop @Parne
@RiadokOK:   add si,DeltaSI
             add di,DeltaDI
             dec dx
             cmp dx,0
             jne @DalsiRiadok
             pop ds
@koniec:     call AkTrebaZapniMys
end;
Procedure PrilepBMPPOF(px,py:integer;Zdroj:pointer;Odtien:byte);assembler;
var DeltaSI,DeltaDI:word;  {kolko treba pripocitat k SI a DI pri prechode na dalsi riadok}
    InitSI,InitDI:word;    {o kolko treba posunut zaciatok prilepovania bitmapy}
    AktRozX,AktRozY:word;  {aktualne rozmery vyseku ktory sa prilepuje}
asm
{ ----- inicializacia a vypocet rozmerov a pozicie prilepovanej bitmapy ----- }
             call AkTrebaVypniMys
             cld
             shl Odtien,4
             les bx,[Zdroj]       {ES:BX -> zatial je bitmapa v ES}
             mov ax,OknoXMax      {kontrola suradnic}
             cmp px,ax
             jge @Koniec

             mov ax,OknoYMax
             cmp py,ax
             jge @Koniec

             mov ax,OknoXMin
             sub ax,word ptr [es:bx]
             cmp px,ax
             jle @Koniec

             mov ax,OknoYMin
             sub ax,word ptr [es:bx+2]
             cmp py,ax
             jle @Koniec

             mov ax,320
             sub ax,[es:bx]
             mov DeltaDI,ax       {inicializujem premenne, ako keby nebolo treba orezavat}
             mov DeltaSI,0
             mov InitSI,0
             mov InitDI,0
             mov ax,[es:bx]
             mov AktRozX,ax
             mov ax,[es:bx+2]
             mov AktRozY,ax

{Lavy}       mov ax,OknoXMin
             sub ax,px
             js @LavyOK
             add DeltaSI,ax       {upravy pri orezavani laveho okraja}
             add InitSI,ax
             add InitDI,ax
             add DeltaDI,ax
             sub AktRozX,ax
@LavyOK:     mov ax,px
{Pravy}      add ax,[es:bx]
             sub ax,OknoXMax
             js @PravyOK
             dec ax
             add DeltaSI,ax       {upravy pri orezavani praveho okraja}
             add DeltaDI,ax
             sub AktRozX,ax
@PravyOK:    mov cx,OknoYMin
{Horny}      sub cx,py
             js @HornyOK
             sub AktRozY,cx       {upravy pri orezavani horneho okraja}
             mov ax,320
             mul cx
             add InitDI,ax
             mov ax,[es:bx]
             mul cx
             add InitSI,ax
@HornyOK:    mov cx,py
             add cx,[es:bx+2]
             sub cx,OknoYMax
             js @DolnyOK
             dec cx
             sub AktRozY,cx

@DolnyOK:    mov es,VSeg
             push ds
{!!!!!}      lds bx,[Zdroj]       {DS:BX -> rozmery zdrojovej bitmapy}
             mov si,bx
             add si,4
             add si,InitSI        {DS:SI -> zaciatok bitmapy}
             mov ax,320
             mul py
             add ax,px
             add ax,InitDI
             mov di,ax            {ES:DI -> ciel vo VRAM}
             mov dx,AktRozY       {DX = RozY}

@DalsiRiadok:mov cx,AktRozX       {CX = pocet prilep. bajtov}
             shr cx,1
             jnc @Parne
             lodsb                {prilep 1. bajt}
             and al,0Fh
             cmp al,0
             je @Nekresli1
             add al,Odtien
             mov byte[es:di],al
@Nekresli1:  inc di
             cmp cx,0
             je @RiadokOK
@Parne:      lodsw                {prilepuj po slovach}
             and al,0Fh
             cmp al,0
             je @Nekresli2
             add al,Odtien
             mov byte[es:di],al
@Nekresli2:  and ah,0Fh
             cmp ah,0
             je @Nekresli3
             add ah,Odtien
             mov byte[es:di+1],ah
@Nekresli3:  add di,2
             loop @Parne
@RiadokOK:   add si,DeltaSI
             add di,DeltaDI
             dec dx
             cmp dx,0
             jne @DalsiRiadok
             pop ds
@koniec:     call AkTrebaZapniMys
end;
Procedure PrilepBMPPF(px,py:integer;p:pointer;Odtien:byte);assembler;
var PridajX:word;
asm
             cld
             push ds
             mov es,VSeg      {ES do videoram}
             mov ds,word ptr p+2
             mov bx,word ptr p{DS:BX na rozmery bitmapy}
             mov si,bx
             add si,4         {DS:SI na zaciatok bitmapy}
             mov ax,320
             sub ax,[bx]
             mov PridajX,ax  {PridajX:=320-RozX}
             mov cx,320
             mov ax,py
             mul cx
             add ax,px
             mov di,ax       {DI na lavy horny roh bitmapy na obr.}
             mov dx,[bx+2]   {RozY}
             shl Odtien,4
@DalsiRiadok:mov cx,[bx]     {RozX}
@DalsiBod:   lodsb
             and al,0Fh
             cmp al,0
             je @Nekresli
             add al,Odtien
             mov byte[es:di],al
@Nekresli:   inc di
             loop @DalsiBod
             add di,PridajX
             dec dx
             jnz @DalsiRiadok
             pop ds
end;  { PrilepBMPPF }
Procedure StiahniBMP(px,py,RozX,RozY:integer;p:pointer);assembler;
var PridajX:word;
asm
             call AkTrebaVypniMys
             cld
             mov es,word ptr p+2
             mov bx,word ptr p
             mov ax,RozX     {do ES:BX daj rozmery}
             mov [es:bx],ax
             mov ax,RozY
             mov [es:bx+2],ax
             push ds
             mov ds,VSeg     {DS do videoram, uz nie su pristupne globalne premenne}
             mov di,bx
             add di,4        {ES:DI na zaciatok bitmapy v RAM}
             mov ax,320
             sub ax,[es:bx]
             mov PridajX,ax  {PridajX:=320-RozX}
             mov cx,320
             mov ax,py
             mul cx
             add ax,px
             mov si,ax       {DS:SI na lavy horny roh bitmapy vo VideoRAM}
             mov dx,[es:bx+2]{RozY}
@DalsiRiadok:mov cx,[es:bx]  {RozX}
         rep movsb
             add si,PridajX
             dec dx
             jnz @DalsiRiadok
             pop ds
             call AkTrebaZapniMys
end;  { StiahniBMP }
Procedure NacitajFont(Subor:string;var p:pointer);
var f:file;
    fp:^FontStruc;
    ii,ij:integer;
    ik:byte;
begin
  Assign(f,Subor);
  {$I-}Reset(f,1);{$I+}
  if IOResult>0 then begin
    Assign(f,DataPath+Subor);
    Reset(f,1);
  end;
  GetMem(p,FileSize(f)+512);
  fp:=p;
  for ii:=0 to 255 do fp^.OfsTab[ii]:=0;
  BlockRead(f,fp^.Verzia,FileSize(f));
  Close(f);
{ ----- vytvorenie tabulky offsetov pismen ----- }
  ij:=0;                              {ij je pozicia v poli Pismo}
  for ii:=1 to fp^.PPismen do begin
    ik:=fp^.Pismo[ij];                {ascii kod ii-teho pismena}
    fp^.OfsTab[ik]:=Ofs(fp^.Pismo)+ij;{ulozime do struktury OfsTab}
    ij:=ij+fp^.Vyska*((fp^.Pismo[ij+1])div 2+1)+6; {novy offset je stary+vyska*skomprimovana sirka+hlavicka pismena}
  end; { for }
end;  { NacitajFont }
Procedure Vypis(PosX,PosY:integer;p:pointer;Textik:string;Odtien:byte);
var CielOfs:word;                   {cielovy offset na obrazovke}
    AktPism:word;                   {index aktualneho pismena}
    Sirka,Vyska:byte;               {sirka a vyska aktualneho neskomprimovaneho pismena}
    PridajX:word;                   {o kolko sa zmeni DI pri prechode na dalsi riadok}
    DlzRet:byte;                    {dlzka vypisovaneho retazca}
begin
  if Textik<>'' then begin
    asm
             call AkTrebaVypniMys
             push ds
             shl Odtien,4           {priprav odtien}
             mov ax,PosY
             mov cx,320
             mul cx
             add ax,PosX
             mov CielOfs,ax
             mov di,ax              {DI - cielovy offset}
             mov es,VSeg            {ES - cielovy segment}
             mov ds,word ptr p+2    {DS - fontovy segment}
             mov bx,word ptr p      {BX - zaciatok struktury fontu}
             mov al,byte[bx+513]
             mov Vyska,al           {nastav vysku}
             mov AktPism,1
{ ----- hlavny cyklus pre retazec ----- }
@DalsiePism: lea si,Textik
             mov al,byte[ss:si]
             mov DlzRet,al          {priprav premennu DlzRet}
             add si,AktPism
             mov bx,word ptr p      {BX - zaciatok struktury fontu}
             xor dh,dh
             mov dl,byte[ss:si]     {DL - prave vypisovane pismeno}
             cmp dl,' '
             je @Medzera
             add bx,dx
             add bx,dx              {BX - OfsTab[DL]}
             mov si,[bx]
             mov al,byte[si+1]
             xor ah,ah
             mov Sirka,al           {nastav sirku}
             mov dx,318             {straca sa informacia o aktualnom pismene z DL}
             sub dx,ax
             and al,01h
             add dl,al
             mov PridajX,dx         {nastav PridajX}
             add si,6               {SI - pociatocny offset bitmapy pismena}
{ ----- zapisovanie pismena ----- }
             mov dl,Vyska
@DalsiRiadok:xor ch,ch
             mov cl,Sirka
             shr cl,1
             inc cl                 {CX - sirka skomprimovanych udajov}
@DalsiBod:   xor ah,ah
             lodsb
             shl ax,4
             shr al,4               {presun horny nibble do AH}
             cmp al,0
             je @Netienuj1
             add al,Odtien
@Netienuj1:  cmp ah,0
             je @Netienuj2
             add ah,Odtien
@Netienuj2:  stosw                  {body sa zapisuju po dvojiciach}
             loop @DalsiBod
             add di,PridajX
             dec dl
             jnz @DalsiRiadok
{ ----- ide dalsie pismeno ----- }
             jmp @NieMedzera
@Medzera:    mov bx,word ptr p      {BX - zaciatok struktury fontu}
             mov al,byte[bx+517]    {pripocitaj medzeru medzi pismenami}
             mov Sirka,al
@NieMedzera: inc AktPism
             mov ax,CielOfs
             add al,Sirka
             adc ah,0
             mov bx,word ptr p      {BX - zaciatok struktury fontu}
             add al,byte[bx+516]    {pripocitaj medzeru medzi pismenami}
             adc ah,0
             mov CielOfs,ax         {nastav CielOfs}
             mov di,CielOfs
             mov ax,AktPism
             cmp al,DlzRet
             jbe @DalsiePism
             pop ds
             call AkTrebaZapniMys
    end; { asm }
  end; { if }
end;  { Vypis }
procedure VypisP(PosX,PosY:word;MSFP:pointer;Text:string;Odtien:byte);
var AktPismeno:word;              {prave vypisovane pismeno, cislujeme od 1}
    OffsetCiela,OffsetAktPism:word;
    Dlzka:word;                   {dlzka retazca}
    Sirka:byte;                   {sirka akt. pismena}
    Vyska:byte;                   {vyska pismena}
    PMedzier:byte;                {pocet medzier medzi dvoma pismenami}
    Diak:boolean;
begin
  asm
             call AkTrebaVypniMys
             push ds
{ ----- inicializacia ----- }
             mov es,VSeg
             mov ax,320
             mul PosY
             add ax,PosX
             mov di,ax            {ES:DI je adresa, kam zapisujeme}
             lea bx,Text          {SS:BX je adresa retazca}
             lds si,[MSFP]        {DS:SI je adresa fontu}

             mov al,byte[si+516]
             mov PMedzier,al      {nastav PMedzier}
             shl Odtien,4         {Odtien}
             mov AktPismeno,1     {AktPismeno}
             mov OffsetCiela,di   {OffsetCiela - pre pripocitavanie 320 pri prechode na dalsi riadok}
             mov OffsetAktPism,di {OffsetAktPism - pre pripocitavanie sirky pri prechode na dalsie pismeno}
             mov al,byte[si+513]
             mov Vyska,al         {Vyska}
             mov al,byte[ss:bx]
             xor ah,ah
             mov Dlzka,ax         {Dlzka}
             mov Diak,False       {Diak}
{ ----- kontrola, ci sa ma vypisovat ----- }
             cmp Dlzka,0          {nulova dlzka}
             je @Koniec
             mov ax,ds
             cmp ax,0             {MSFP je nil}
             je @Koniec
{ ----- hlavny algoritmus - 3 vnorene cykly: Pismeno, Riadok, Bod ----- }
@DalsiePism: lea bx,Text
             add bx,AktPismeno
             mov cl,byte[ss:bx]   {CL je aktualne pismeno}
             cmp cl,'`'           {testuj pritomnost diakritiky}
             je @Diak
             cmp cl,'~'
             je @Diak
             cmp cl,'^'
             je @Diak
             cmp cl,'|'
             je @Diak
             cmp cl,' '           {testuj pritomnost medzery}
             jne @VypisHO
             mov si,word ptr MSFP {spracuj medzeru}
             mov cl,byte[si+517]
             mov Sirka,cl         {nastav sirku medzery do premennej Sirka a nekresli pismeno}
             jmp @PismOK
@Diak:       sub OffsetCiela,320  {spracuj diakritiku}
             mov Diak,True
@VypisHO:    xor ch,ch
             shl cx,1
             mov si,word ptr MSFP
             add si,cx            {DS:SI -> OfsTab[CL]}
             mov si,word[si]      {DS:SI -> pismeno CL}
             mov al,byte[si+1]
             mov Sirka,al         {Sirka je neskomprimovana sirka pismena}
             mov dl,Vyska         {DL - vyska pismena}
             add si,6             {SI - bitmapa pismena}

@DalsiRiadok:mov di,OffsetCiela   {priprav DI}
             xor cx,cx            {CX - pocet opakovani}
             mov cl,Sirka
             shr cl,1
             inc cl

@DalsiBod:   lodsb
             xor ah,ah
             shl ax,4
             shr al,4
             cmp ah,0
             je @Nekresli
             add ah,Odtien        {v AH je farba urcena na prilepenie}
             mov byte[es:di+1],ah
@Nekresli:   cmp al,0
             je @Nekresli2
             add al,Odtien        {v AL je - || - }
             mov byte[es:di],al
@Nekresli2:  add di,2
             loop @DalsiBod       {koniec 1. cyklu}

             add OffsetCiela,320
             dec dl
             cmp dl,0
             jne @DalsiRiadok     {koniec 2. cyklu}

@PismOK:     mov ax,OffsetAktPism
             cmp Diak,True
             je @NezvysujOfs
             add al,Sirka
             adc ah,0
             add al,PMedzier
             adc ah,0
@NezvysujOfs:mov Diak,False
             mov OffsetAktPism,ax {uprav offset nasledujuceho pismena}
             mov OffsetCiela,ax
             inc AktPismeno
             mov ax,AktPismeno
             cmp ax,Dlzka
             jbe @DalsiePism
{ ----- hotovo ----- }
@Koniec:     pop ds
             call AkTrebaZapniMys
  end;
end;
Procedure VypisPO(PosX,PosY:integer;p:pointer;Textik:string;Odtien:byte);
var CielOfs:word;                   {cielovy offset na obrazovke}
    AktPism:word;                   {index aktualneho pismena}
    KonX,KonY,Sirka:word;           {sur. praveho dolneho rohu pismena; neskomprimovana sirka}
    PridajX:word;                   {o kolko sa zmeni DI pri prechode na dalsi riadok}
    DlzRet:byte;                    {dlzka vypisovaneho retazca}
    pXMin,pXMax,pYMin,pYMax:integer;{suradnice okrajov okna}
    DDiak:boolean;
begin
  if Textik<>'' then begin
    asm
             call AkTrebaVypniMys
             mov ax,OknoXMin {presun suradnic okrajov okna}
             mov pXMin,ax    {kedze nebude pristupny datovy segment}
             mov ax,OknoXMax
             mov pXMax,ax
             mov ax,OknoYMin
             mov pYMin,ax
             mov ax,OknoYMax
             mov pYMax,ax
             push ds
             shl Odtien,4           {priprav odtien}
             mov ax,PosY
             mov cx,320
             mul cx
             add ax,PosX            {vypocitaj poziciu na obrazovke}
             mov CielOfs,ax
             mov es,VSeg            {ES - cielovy segment}
             mov ds,word ptr p+2    {DS - fontovy segment}
             mov AktPism,1
{ ----- hlavny cyklus pre retazec ----- }
@DalsiePism: lea si,Textik
             mov al,byte[ss:si]
             mov DlzRet,al          {priprav premennu DlzRet}
             add si,AktPism
             mov bx,word ptr p      {BX - zaciatok struktury fontu}
             xor dh,dh
             mov dl,byte[ss:si]     {DL - prave vypisovane pismeno}
             mov DDiak,False
             cmp dl,' '
             je @Medzera
{ ----- obycajne pismeno - inicializacia premennych ----- }
             cmp dl,'~'
             je @Diak
             cmp dl,'`'
             je @Diak
             cmp dl,'|'
             je @Diak
             cmp dl,'^'
             je @Diak
             jmp @Normalne
@Diak:       sub CielOfs,320
             mov DDiak,True
@Normalne:   mov di,dx
             add di,dx              {DI - OfsTab[DL]}
             mov si,[bx+di]         {SI - zaciatok udajoveho bloku pismena}
             xor ah,ah
             mov al,byte[bx+513]    {AX - vyska}
             add ax,PosY            {AX - KonY}
             mov KonY,ax
             mov al,byte[si+1]
             xor ah,ah              {AX - sirka}
             mov Sirka,ax
             add ax,PosX            {AX - KonX}
             mov KonX,ax
             mov ax,Sirka
             mov dx,318             {v DL sa straca informacia o aktualnom pismene}
             sub dx,ax
          {   and al,01h
             add dl,al}
            { add dx,2}
             mov PridajX,dx         {nastav PridajX}
             add si,6               {SI - pociatocny offset bitmapy pismena}
             mov di,CielOfs         {DI - pociatocny offset na obrazovke}
{ ----- zapisovanie pismena ----- }
             mov dx,PosY            {DX - y-ova suradnica}
@DalsiRiadok:mov cx,PosX            {CX - x-ova suradnica}
@DalsiBod:   xor ah,ah
             lodsb
             shl ax,4
             shr al,4               {presun horny nibble do AH}
             cmp al,0               {priehladnost}
             je @Nekresli1
             add al,Odtien
             cmp dx,pYMin           {kontrola suradnic okna pre 1. bod}
             jl @Nekresli1
             cmp dx,pYMax
             jg @Nekresli1
             cmp cx,pXMin
             jl @Nekresli1
             cmp cx,pXMax
             jg @Nekresli1
             mov byte[es:di],al
@Nekresli1:  inc cx
             inc di
             cmp cx,KonX
             jg @KonRiadka
             cmp ah,0              {priehladnost}
             je @Nekresli2
             add ah,Odtien
             cmp dx,pYMin          {kontrola suradnic okna pre 2. bod}
             jl @Nekresli2
             cmp dx,pYMax
             jg @Nekresli2
             cmp cx,pXMin
             jl @Nekresli2
             cmp cx,pXMax
             jg @Nekresli2
             mov byte[es:di],ah
@Nekresli2:  add di,1
             add cx,1
             cmp cx,KonX
             jle @DalsiBod
@KonRiadka:  add di,PridajX
             add di,1
             inc dx
             cmp dx,KonY
             jl @DalsiRiadok
{ ----- ide dalsie pismeno ----- }
             jmp @NieMedzera
@Medzera:    xor ah,ah
             mov al,byte[bx+517]    {pripocitaj medzeru medzi pismenami}
             mov Sirka,ax
@NieMedzera: inc AktPism
             cmp DDiak,True
             je @NezvysujOfs
             mov ax,Sirka
             add al,byte[bx+516]    {pripocitaj medzeru medzi pismenami}
             add CielOfs,ax         {nastav CielOfs}
             add PosX,ax
             sub CielOfs,320
@NezvysujOfs:add CielOfs,320
             mov ax,AktPism
             cmp al,DlzRet
             jbe @DalsiePism
             pop ds
             call AkTrebaZapniMys
    end; { asm }
  end; { if }
end;  { VypisPO }
Function LengthDiak(Textik:string):byte;
var i,l:integer;
begin
  l:=0;
  for i:=1 to Length(Textik) do
    if not (Textik[i] in ['`','~','^','|']) then Inc(l);
  LengthDiak:=l;
end;  { LengthDiak }
Function LengthPixel(p:pointer;Textik:string):word;
var l:word;
begin
  if Textik<>'' then begin
    asm
             mov l,0
             mov es,word ptr p+2
             mov bx,word ptr p     {ES:BX ukazatel na zaciatok fontu}
             lea si,Textik         {SS:SI ukazatel na retazec}
             xor ch,ch
             mov cl,byte[ss:si]    {CX dlzka retazca}
             inc si                {SI na prvy znak retazca}
             xor ah,ah
@DalsiZnak:  mov al,byte[ss:si]    {AL znak}
             inc si
             cmp al,'~'
             je @Diak
             cmp al,'`'
             je @Diak
             cmp al,'|'
             je @Diak
             cmp al,'^'
             je @Diak
             cmp al,' '
             je @Medzera
             mov di,bx
             add di,ax
             add di,ax             {ES:DI ukazuje na p^.OfsTab[AL]}
             mov di,word[es:di]    {ES:DI ukazuje na aktualne pismeno}
             mov dl,byte[es:di+1]  {DL obsahuje sirku pismena}
             add dl,byte[es:bx+516]{aj s mikromedzerou za nim}
             jmp @NieMedzera
@Medzera:    mov dl,byte[es:bx+517]{DL obsahuje sirku medzery}
             add dl,byte[es:bx+516]{aj s mikromedzerou za nou}
@NieMedzera: xor dh,dh
             add l,dx
@Diak:       loop @DalsiZnak
    end;
    LengthPixel:=l;
  end else LengthPixel:=0;
end;  { LengthPixel }
procedure NacitajPaletu(Subor:string;var p:pointer);
var f:file;
begin
  GetMem(p,768);
  Assign(f,Subor);
  {$I-}Reset(f,768);{$I+}
  if IOResult>0 then begin
    Assign(f,DataPath+Subor);
    Reset(f,768);
  end;
  BlockRead(f,p^,1);
  Close(f);
end; { NacitajPaletu }
procedure NastavPaletu(p:pointer);assembler;
asm
             cld
             push ds
             lds si,p
             xor cx,cx
@DalsiaFarba:mov dx,03C8h
             mov al,cl
             out dx,al
             mov dx,03C9h
             lodsb
             out dx,al
             lodsb
             out dx,al
             lodsb
             out dx,al
             inc cx
             cmp cx,256
             jb @DalsiaFarba
             pop ds
end; { NastavPaletu }
procedure NastavFarbu(cislo,r,g,b:byte);assembler;
asm
             mov dx,03C8h
             mov al,cislo
             out dx,al
             mov dx,03C9h
             mov al,r
             out dx,al
             mov al,g
             out dx,al
             mov al,b
             out dx,al
end; { NastavFarbu }
procedure ZistiFarbu(cislo:byte;var r,g,b:byte);
begin
  port[$3C7]:=cislo;
  r:=port[$3C9];
  g:=port[$3C9];
  b:=port[$3C9];
end; { ZistiFarbu }
procedure Tlacidlo3D(px,py,RozX,RozY:word;Pismo:pointer;Napis:string;Odtien,ONadpisu:byte;Stlacene:boolean);
var Vyska:byte;
    LavyHor,PravyDol:word;
begin
  Odtien:=Odtien shl 4;
  Color:=Odtien+12;
  if Stlacene then Color:=Color-3;
  VyplnPlochu(px+3,py+3,RozX-6,RozY-6);
  asm
             call AkTrebaVypniMys
             cld
             mov es,VSeg
             mov ax,320
             mul py
             add ax,px
             mov di,ax            {ES:DI ukazuje na lavy horny roh tlacidla}
             mov LavyHor,ax
             mov PravyDol,ax
             mov ax,RozY
             dec ax
             mov cx,320
             mul cx
             add ax,RozX
             dec ax
             add PravyDol,ax
{ ----- tri vodorovne ciary hore ----- }
             mov ah,3
             mov al,8             {jas hornych ciar}
             cmp Stlacene,False
             je @Nezmen1
             xchg ah,al
@Nezmen1:    add al,Odtien
             mov cx,RozX
         rep stosb
             mov di,LavyHor
             add di,321
             mov cx,RozX
             sub cx,2
         rep stosb
             mov di,LavyHor
             add di,642
             mov cx,RozX
             sub cx,4
         rep stosb
{ ----- tri zvisle ciary zlava ----- }
             mov di,LavyHor
             mov cx,RozY
@DalsiBod1:  stosb
             add di,319
             loop @DalsiBod1
             mov di,LavyHor
             add di,321
             mov cx,RozY
             sub cx,2
@DalsiBod2:  stosb
             add di,319
             loop @DalsiBod2
             mov di,LavyHor
             add di,642
             mov cx,RozY
             sub cx,4
@DalsiBod3:  stosb
             add di,319
             loop @DalsiBod3
{ ----- tri vodorovne ciary dole ----- }
             std
             mov ah,8
             mov al,3             {jas ciar dole}
             cmp Stlacene,False
             je @Nezmen2
             xchg al,ah
@Nezmen2:    add al,Odtien
             mov di,PravyDol
             mov cx,RozX
             dec cx
         rep stosb
             mov di,PravyDol
             sub di,321
             mov cx,RozX
             sub cx,3
         rep stosb
             mov di,PravyDol
             sub di,642
             mov cx,RozX
             sub cx,5
         rep stosb
{ ----- tri zvisle ciary sprava ----- }
             mov di,PravyDol
             mov cx,RozY
             dec cx
@DalsiBod4:  stosb
             sub di,319
             loop @DalsiBod4
             mov di,PravyDol
             sub di,321
             mov cx,RozY
             sub cx,3
@DalsiBod5:  stosb
             sub di,319
             loop @DalsiBod5
             mov di,PravyDol
             sub di,642
             mov cx,RozY
             sub cx,5
@DalsiBod6:  stosb
             sub di,319
             loop @DalsiBod6
             cld
{ ----- dve trojice bodov ----- }
             mov di,LavyHor
             mov cl,12            {jas tych trojic bodov}
             add cl,Odtien
             mov byte[es:di],cl   {3 x PutPixel na sikmu ciaru vlavo hore}
             mov byte[es:di+321],cl
             mov byte[es:di+642],cl
             mov di,PravyDol
             mov byte[es:di],cl   {3 x PutPixel na sikmu ciaru vpravo dole}
             mov byte[es:di-321],cl
             mov byte[es:di-642],cl
{ ----- urcenie vysky fontu ----- }
             mov es,word ptr Pismo+2
             mov bx,word ptr Pismo    {ES:BX ukazuje na zaciatok fontu}
             mov al,byte[es:bx+1]
             mov Vyska,al
             call AkTrebaZapniMys
  end;
  if RozX>LengthPixel(Pismo,Napis) then
    VypisPO(px+(RozX-LengthPixel(Pismo,Napis)) div 2+1,py+(RozY-6-Vyska) div 2,Pismo,Napis,ONadpisu);
end;
procedure Obdlznik(px,py,DeltaX,DeltaY:integer);assembler;
asm
             call AkTrebaVypniMys
             cmp DeltaX,0
             je @Koniec
             cmp DeltaY,0
             je @Koniec
             push px
             push py
             push DeltaX
             call CiaraVodorovna     {horna}
             push px
             push py
             push DeltaY
             call CiaraZvisla        {lava}
             mov ax,py
             add ax,DeltaY
             dec ax
             push px
             push ax
             push DeltaX
             call CiaraVodorovna      {dolna}
             mov ax,px
             add ax,DeltaX
             dec ax
             push ax
             push py
             push DeltaY
             call CiaraZvisla          {prava}
@Koniec:     call AkTrebaZapniMys

end; { Obdlznik }
procedure Ramcek(px,py,DeltaX,DeltaY,FarbaVnutra:integer);assembler;
asm
             call AkTrebaVypniMys
             cld
             cmp DeltaX,0
             je @Koniec
             cmp DeltaY,0
             je @Koniec
             mov es,VSeg
             mov cx,320
             mov ax,py
             mul cx
             add ax,px
             mov di,ax
             mov bp,sp
             mov bx,DeltaY
             sub bx,2          {v BX pocet riadkov vnutra}
             mov cx,DeltaX
             mov dx,320
             sub dx,cx         {v DX je 320-DeltaX}
             mov al,Color
         rep stosb             {1. riadok}
@DalsiRiadok:add di,dx
             stosb             {1. bod}
             mov ax,FarbaVnutra
             mov cx,DeltaX
             sub cx,2
         rep stosb             {vnutro}
             mov al,Color
             stosb             {posledny bod}
             dec bx
             jnz @DalsiRiadok
             add di,dx
             mov al,Color
             mov cx,DeltaX
         rep stosb
@Koniec:     call AkTrebaZapniMys

end; { Ramcek }
procedure CakajNaVOI;assembler;
asm
             mov dx,03DAh
@vz1:        in al,dx
             and al,08h
             jnz @vz1
@vz2:        in al,dx
             and al,08h
             jz @vz2
end; { CakajNaVOI }
procedure NacitajMGP(var f:file;var Kam:pointer);
var i:word;
begin
  BlockRead(f,i,2);
  GetMem(Kam,i+2);
  Seek(f,FilePos(f)-2);
  BlockRead(f,Kam^,i+2);
end;

procedure AsmVypis(pSeg,pOfs:word;PolePisma:TPP);
var s2:string;
begin
  Move(Mem[pSeg:pOfs+7],s2,255);
  Vypis(MemW[pSeg:pOfs+1],MemW[pSeg:pOfs+3],PolePisma^[Mem[pSeg:pOfs+5]],s2,Mem[pSeg:pOfs+6]);
end;
procedure AsmVypisPO(pSeg,pOfs:word;PolePisma:TPP);
var s2:string;
begin
  Move(Mem[pSeg:pOfs+7],s2,255);
  VypisP(MemW[pSeg:pOfs+1],MemW[pSeg:pOfs+3],PolePisma^[Mem[pSeg:pOfs+5]],s2,Mem[pSeg:pOfs+6]);
end;
procedure AsmTlacidlo3D(pSeg,pOfs:word;PolePisma:TPP);
var s2:string;
begin
  Move(Mem[pSeg:pOfs+13],s2,255);
  Tlacidlo3D(MemW[pSeg:pOfs+1],MemW[pSeg:pOfs+3],MemW[pSeg:pOfs+5],MemW[pSeg:pOfs+7],
  PolePisma^[Mem[pSeg:pOfs+8]],s2,Mem[pSeg:pOfs+10],Mem[pSeg:pOfs+11],boolean(Mem[pSeg:pOfs+12]));
end;

procedure VykresliMGP(p1,PoleBMP,PolePisma:pointer);assembler;
var Pozicia,StaSI:word;
    Prikaz:byte;
asm
             cmp JeMysM,False
             je @Nevypni
             mov ax,2
             int 33h
@Nevypni:    mov Pozicia,0
@While:      mov es,word ptr ss:p1+2
             mov bx,word ptr ss:p1      {BX - zaciatok struktury MGP}
             mov si,bx                  {SI - ukazatel pozicie}
             add si,2
             add si,Pozicia
{While je tu}mov ax,Pozicia
             mov StaSI,si
             cmp ax,word [es:bx]
             jae @Koniec
             xor ah,ah
             mov al,[es:si]
             mov Prikaz,al
             cmp al,1
             jne @Case2

{case 1}     mov al,byte[es:si+7]
             mov Color,al
             push word[es:si+1]
             push word[es:si+3]
             push word[es:si+5]
             call CiaraVodorovna
             jmp @ZvysujOfs

@Case2:      cmp al,2
             jne @Case3
             mov al,byte[es:si+7]
             mov Color,al
             push word[es:si+1]
             push word[es:si+3]
             push word[es:si+5]
             call CiaraZvisla
             jmp @ZvysujOfs

@Case3:  (*    cmp al,3
             jne @Case4
             push word[es:si+1]
             push word[es:si+3]
             call NastavPaletu
             jmp @ZvysujOfs
                                *)
@Case4:      cmp al,4
             jne @Case5
             push word[es:si+1]
             push word[es:si+3]
             mov al,byte[es:si+5]
             push ax
             call PolozBod
             jmp @ZvysujOfs

@Case5:      cmp al,5
             jne @Case6
             mov al,byte[es:si+9]
             mov Color,al
             push word[es:si+1]
             push word[es:si+3]
             push word[es:si+5]
             push word[es:si+7]
             call VyplnPlochu
             jmp @ZvysujOfs

@Case6:      cmp al,6
             jne @Case7
             mov al,byte[es:si+10]
             mov Color,al
             push word[es:si+1]
             push word[es:si+3]
             push word[es:si+5]
             push word[es:si+7]
             mov al,byte[es:si+9]
             push ax
             call Ramcek
             jmp @ZvysujOfs

@Case7:      cmp al,7
             jne @Case8
             push es
             push si
             push word ptr PolePisma+2
             push word ptr PolePisma
             call AsmVypis
             jmp @ZvysujOfs

@Case8:      cmp al,8
             jne @Case9
             push es
             push si
             push word ptr PolePisma+2
             push word ptr PolePisma
             call AsmVypisPO
             jmp @ZvysujOfs

@Case9:      cmp al,9
             jne @Case10
             push word[es:si+1]
             push word[es:si+3]
             mov al,byte[es:si+5]
             xor ah,ah
             shl ax,2
             mov di,word ptr PoleBMP
             add di,ax
             push word [di+2]
             push word [di]
             call PrilepBMP
             jmp @ZvysujOfs

@Case10:     cmp al,10
             jne @Case11
             mov al,byte[es:si+9]
             mov Color,al
             push word[es:si+1]
             push word[es:si+3]
             push word[es:si+5]
             push word[es:si+7]
             call Obdlznik
             jmp @ZvysujOfs

@Case11:     cmp al,11
             jne @Case12
             push es
             push si
             push word ptr PolePisma+2
             push word ptr PolePisma
             call AsmTlacidlo3D
             jmp @ZvysujOfs

@Case12:     cmp al,12
             jne @Case13
             push word[es:si+1]
             push word[es:si+3]
             mov al,byte[es:si+5]
             xor ah,ah
             shl ax,2
             mov di,word ptr PoleBMP
             add di,ax
             push word [di+2]
             push word [di]
             call PrilepBMPPO
             jmp @ZvysujOfs

@Case13:     cmp al,13
             jne @Case14
             push word[es:si+1]
             push word[es:si+3]
             push word[es:si+5]
             push word[es:si+7]
             mov al,byte[es:si+9]
             mov Color,al
             call Ciara
             jmp @ZvysujOfs

@Case14:     cmp al,14
             jne @Case15
             inc si
             push es
             push si
             dec si
             push word[es:si+17]
             mov al,byte[es:si+19]
             xor ah,ah
             push ax
             call Bezier3
             jmp @ZvysujOfs

@Case15:     cmp al,15
             jne @Case16
             call ZmazObrazovku
             jmp @ZvysujOfs

@Case16:     cmp al,16
             jne @Case17
             xor ah,ah
             mov al,byte[es:si+1]
             push ax
             mov al,byte[es:si+2]
             push ax
             mov al,byte[es:si+3]
             push ax
             mov al,byte[es:si+4]
             push ax
             call NastavFarbu
             jmp @ZvysujOfs

@Case17:

@ZvysujOfs:  lea di,DlzElem
             xor ah,ah
             mov al,Prikaz
             dec al
             add di,ax
             mov al,byte[di]
             mov si,StaSI
             mov es,word ptr ss:p1+2
             cmp al,0
             jne @KludneZvys

{cas7}       cmp Prikaz,7{Vypis}
             jne @Cas8
             mov al,byte[es:si+7]
             add al,8
             add Pozicia,ax
             jmp @While

@Cas8:       cmp Prikaz,8{VypisPO}
             jne @Cas11
             mov al,byte[es:si+7]
             add al,8
             add Pozicia,ax
             jmp @While

@Cas11:      cmp Prikaz,11{Tlacidlo3D}
             jne @CasEnd
             mov al,byte[es:si+13]
             add al,14
             add Pozicia,ax
             jmp @While

@CasEnd:     jmp @Koniec
@KludneZvys: add Pozicia,ax
             jmp @While
@Koniec:     cmp JeMysM,False
             je @Nezapni
             mov ax,1
             int 33h
@Nezapni:
end;

Function CitajZnak:char;assembler;
asm
             mov ah,10h
             int 16h
end;
Function JeZnak:boolean;assembler;
asm
             mov ah,11h
             int 16h
             mov al,1
             jnz @Koniec
             xor al,al
@Koniec:
end;
Procedure Presun(Zdroj,Ciel:pointer;Pocet:word);assembler;
asm
             push ds
             lds si,[Zdroj]       {klasicky cez MOVS -B a -W}
             les di,[Ciel]
             mov cx,Pocet
             jcxz @Koniec
             shr cx,1
             jnc @Parny
             movsb
@Parny:  rep movsw
@koniec:     pop ds
end;
Procedure Vypln(Ciel:pointer;Pocet:word;Hodnota:byte);assembler;
asm
             les di,[Ciel]
             mov al,Hodnota
             mov ah,al
             mov cx,Pocet
             jcxz @Koniec
             shr cx,1
             jnc @Parny
             stosb
@Parny:  rep stosw
@Koniec:
end;
procedure Kruznica(sx,sy,r:integer;Col:byte);assembler;
var x,y,pred,Farba:integer; {suradnice, predikcia}
    sxpx,sxmx,sypy,symy,sxpy,sxmy,sypx,symx:integer; {sx plus x, ...}
asm
             mov ah,0
             mov al,Col
             mov Farba,ax
             mov x,0              { x:=0 }
             mov ax,r
             mov y,ax             { y:=r }
             add ax,ax
             mov pred,0
             sub pred,ax
             add pred,3           { pred:=3-2*r }
{ ----- pomocne vypocty ----- }
@Znova:      mov ax,sx
             add ax,x
             mov sxpx,ax
             mov bx,sx
             sub bx,x
             mov sxmx,bx
             mov cx,sy
             add cx,y
             mov sypy,cx
             mov dx,sy
             sub dx,y
             mov symy,dx
             mov ax,sx
             add ax,y
             mov sxpy,ax
             mov bx,sx
             sub bx,y
             mov sxmy,bx
             mov cx,sy
             add cx,x
             mov sypx,cx
             mov dx,sy
             sub dx,x
             mov symx,dx
{ ----- kreslenie bodov ----- }
             push sxpx
             push sypy
             push Farba
             call PolozBod
             push sxpx
             push symy
             push Farba
             call PolozBod
             push sxmx
             push sypy
             push Farba
             call PolozBod
             push sxmx
             push symy
             push Farba
             call PolozBod
             push sxpy
             push symx
             push Farba
             call PolozBod
             push sxpy
             push sypx
             push Farba
             call PolozBod
             push sxmy
             push sypx
             push Farba
             call PolozBod
             push sxmy
             push symx
             push Farba
             call PolozBod
{ ----- vypocitanie nasl. suradnic ----- }
             mov ax,x             { Pred:=Pred+4*x - vzdy}
             shl ax,2
             add Pred,ax

             cmp Pred,0
             jge @Vacsie
             add Pred,6           { Pred:=Pred+6 pre Pred<0 }
             jmp @Dalej1

@Vacsie:     mov ax,y
             shl ax,2
             sub Pred,ax          { Pred:=Pred-4*y+10 pre Pred>0 }
             add Pred,10
             dec y                { a zniz ypsilon }

@Dalej1:     inc x
             mov ax,x
             cmp ax,y
             jle @Znova
end;
procedure KopirujObrazovku(VSeg1,VSeg2:word);assembler;
asm
             cld
             push ds
             mov ds,VSeg1
             mov es,VSeg2
             mov si,0
             mov di,0
             mov cx,32000
         rep movsw
             pop ds
end; { KopirujObrazovku }
BEGIN
  asm
             mov OknoXMin,0
             mov OknoXMax,319
             mov OknoYMin,0
             mov OknoYMax,199
             mov VSeg,0A000h
             mov Color,0
             mov VypinajMys,False
  end;
  JeMysM:=IOMM;
END.