unit BMPUtil;   {pomocne procedury pre bitmapy}
                                INTERFACE
uses MainGr;
     { ----- praca s bitmapami v halde ----- }
procedure NahodnaBMP(RozX,RozY:word;Farba:byte;var p:pointer);
procedure PriemerujBMP(p:pointer);
procedure PreklopBMP(p:pointer;Os:char);{os: -|/\ , po diagonalach LEN STVORCOVE BITMAPY}
procedure RotujBMP(p:pointer);{LEN STVORCOVE BITMAPY PARNEHO ROZMERU rotuje o 90ø v smere hod. ruc. okolo stredu}
procedure UpravJasBMP(p:pointer;Nas,Del:byte);{nasobok a delitel jasovej zlozky farby}
procedure KopirujBMP(Zdroj,Ciel:pointer;x,y,RozX,RozY:word);
procedure ZmenMierkuBMP(Zdroj,Ciel:pointer;XNas,XDel,YNas,YDel:byte);{rozmery nie nad 255, zatial LEN ZMENSOVANIE}
     { ----- praca s bitmapami priamo v obrazovej pamati ----- }
procedure PosunVRAMSpredu(StartX,StartY,RozX,RozY,KolkoX,KolkoY:integer);
procedure PosunVRAMZozadu(StartX,StartY,RozX,RozY,KolkoX,KolkoY:integer);

                               IMPLEMENTATION

procedure NahodnaBMP(RozX,RozY:word;Farba:byte;var p:pointer);
var OSeg,OOfs,p1:word;
    p2:pointer;
begin
  GetMem(p2,RozX*RozY+4);
  asm
             mov es,word ptr p2+2
             mov di,word ptr p2
             mov OSeg,es
             mov OOfs,di
             mov ax,RozX
             mov word[es:di],ax
             mov ax,RozY
             mov word[es:di+2],ax
  end;
  p:=p2;
  for p1:=4 to RozX*RozY+4 do Mem[OSeg:OOfs+p1]:=Random(16)+16*Farba;
end;
procedure PriemerujBMP(p:pointer);assembler;
asm
             cld
             push ds
             mov ds,word ptr p+2{DS - do segmentu BMP}
             mov es,word ptr p+2{ES - takisto}
             xor bx,bx          {BX - pocitadlo v riadku}
             mov si,word ptr p  {SI - ukazuje na rozmery BMP}
             mov di,si
             add di,[si]        {RozX}
             add di,5           {DI - ukazuje na [1,1] v BMP}
             mov cx,[si+2]
             cmp cx,3           {skontroluj vysku}
             jb @Hotovo
             sub cx,2           {CX - pocitadlo v stlpci}
             mov dx,[si]        {DX - pocet bajtov v riadku. Nemeni sa v hl. cykle}
             cmp dx,3
             jb @Hotovo         {skontroluj sirku}
             add si,4           {SI ukazuje na [0,0] v BMP}
@DalsiRiadok:
@DalsiBod:     xor ah,ah
               mov al,byte[si]
               add al,byte[si+1]
               adc ah,0
               add al,byte[si+2]
               adc ah,0
               add si,dx         {na dalsi riadok}
               add al,byte[si]
               adc ah,0
               add al,byte[si+2]
               adc ah,0
               add si,dx         {na dalsi riadok}
               add al,byte[si]
               adc ah,0
               add al,byte[si+1]
               adc ah,0
               add al,byte[si+2]
               adc ah,0
               shr ax,3          {uz je spriemerovane}
               adc al,0
               stosb
               sub si,dx         {£prava SI a smycka DalsiBod}
               sub si,dx
               inc si
               inc bx
               cmp bx,dx
               jb @DalsiBod
             xor bx,bx            {prechod na dalsi riadok}
             loop @DalsiRiadok
@Hotovo:     pop ds
end;
procedure PreklopBMP(p:pointer;Os:char);assembler;
var Pom:word;
asm
             cld
             push ds
             mov ds,word ptr p+2  {DS - segment BMP}
             mov es,word ptr p+2  {ES - takisto}
             mov bx,word ptr p    {BX - rozmery bitmapy}
             mov cx,[bx]          {CX - x-ovy rozmer}
             cmp cx,0
             je @Hotovo           {     musi byt nenulovy}
             mov dx,[bx+2]        {DX - y-ovy rozmer}
             cmp dx,0             {     tiez nenulovy}
             je @Hotovo
             mov si,bx
             add si,4             {SI - zaciatok bitmapy}
             mov di,bx
             add di,4             {DI - takisto}
             cmp Os,'-'
             jne @NieVodor
{----- preklapanie cez vodorovnu os ----- }
             mov ax,[bx]
             mul dx
             mov dx,[bx+2]        {obnov DX}
             sub ax,[bx]
             add di,ax            {offset ciela}
             shr dx,1             {y-ovy rozmer sa deli dvoma}
@DalsiBod1:  mov al,byte[di]
             movsb
             mov byte[si-1],al    {vymena a posun indexovych registrov}
             loop @DalsiBod1
             sub di,[bx]
             sub di,[bx]
             mov cx,[bx]
             dec dx
             jnz @DalsiBod1
             jmp @Hotovo
{ ----- preklapanie cez zvislu os ----- }
@NieVodor:   cmp Os,'|'
             jne @NieZvis
             add di,[bx]
             dec di
             shr cx,1             {pocet riadkov sa deli 2}
             mov Pom,cx
@DalsiBod3:  mov al,byte[di]
             movsb
             mov byte[si-1],al
             sub di,2
             loop @DalsiBod3
             add si,[bx]
             add di,[bx]
             sub si,Pom
             add di,Pom
             mov cx,Pom
             dec dx
             jnz @DalsiBod3
             jmp @Hotovo
{ ----- preklapanie cez hlavnu diagonalu ----- }
@NieZvis:    cmp Os,'\'
             jne @ProtiSmeru
             mov Pom,bx
             add Pom,4
@DalsiBod2:  mov al,byte[si]
             mov ah,byte[di]
             mov byte[si],ah
             mov byte[di],al
             inc si
             add di,[bx]
             loop @DalsiBod2
             mov ax,[bx]
             add Pom,ax
             inc Pom
             mov si,Pom           {nova adresa}
             mov di,Pom
             mov cx,dx            {presuvaj menej bajtov}
             dec cx
             dec dx
             jnz @DalsiBod2
             jmp @Hotovo
{ ----- preklapanie cez vedlajsiu diagonalu ----- }
@ProtiSmeru: cmp Os,'/'
             jne @Hotovo
             add si,[bx]          {priprava registrov}
             add di,[bx]
             dec si
             dec di
             mov Pom,di
@DalsiBod4:  mov al,byte[si]
             mov ah,byte[di]
             mov byte[si],ah
             mov byte[di],al
             dec si
             add di,[bx]
             loop @DalsiBod4
             dec dx
             add si,[bx]          {nova adresa SI}
             add si,dx
             mov di,si            {nova adresa DI}
             mov cx,dx            {presuvaj menej bajtov}
             cmp dx,0
             jne @DalsiBod4
@Hotovo:     pop ds
end;
procedure RotujBMP(p:pointer);assembler;
var RozX2,RozX,RozY2:word;    {polovica x-oveho rozmeru,polovica y-oveho*RozX}
asm
             push ds
             mov es,bp            {sem si odlozime BP}
             mov ds,word ptr p+2  {DS - segment BMP. NIE JE PRISTUP KU GLOBALNYM PREMENNYM}
             mov bx,word ptr p    {BX - zatial ukazuje na rozmery BMP}
             mov cx,[bx]          {CX - x-ovy rozmer}
             mov RozX2,cx
             mov RozX,cx
             shr RozX2,1          {polovica x-oveho roz.}
             mov dx,[bx+2]        {DX - y-ovy}
             mov si,bx
             add si,4             {SI - lavy horny roh}
             mov di,si
             add di,cx
             dec di               {DI - pravy horny roh}
             mov al,dl
             mul cl
             shr dx,1             {y-ovy rozmer tiez vydel 2}
             mov ax,[bx]
             mul dl               {AX - RozY}
             mov RozY2,ax
{!!!!!}      mov bx,si            {straca sa ukazatel na rozmery. Pristupne premenne su uz LEN V ZASOBNIKU}
             add bx,ax
             add bx,ax
             sub bx,cx            {BX - lavy dolny roh}
{!!!!!}      mov bp,bx            {bolo nastavene BP, UZ NIE JE PRISTUP K ZIADNYM PREMENNYM}
             add bp,cx            {vsetko sa bude diat len v procesore}
             dec bp               {BP - pravy dolny roh}
@DalsiRiadok:push bp
             mov bp,es
             mov cx,RozX2         {kv“li nacitaniu RozX2 potrebujem p“vodne BP}
             pop bp
@DalsiBod:   mov ah,byte[si]      {presuny}
             mov al,byte[bx]
             mov byte[si],al
             mov al,byte[ds:bp]
             mov byte[bx],al
             mov al,byte[di]
             mov byte[ds:bp],al
             mov byte[di],ah
             inc si               {zvysovanie indexovych registrov}
             push bp
             mov bp,es
             add di,RozX
             sub bx,RozX
             pop bp
             dec bp
             loop @DalsiBod
             push bp
             mov bp,es
             add si,RozX2         {pred prechodom na dalsi riadok uprav index. reg.}
             sub di,RozY2
             dec di
             add bx,RozY2
             inc bx
             mov ax,RozX2         {neskorsie odpocitame}
             pop bp
             sub bp,ax
             dec dx
             jnz @DalsiRiadok
             mov bp,es            {zachran d“lezite registre}
             pop ds
end;
procedure UpravJasBMP(p:pointer;Nas,Del:byte);assembler;
asm
             cld
             mov es,word ptr p+2  {ES - segment BMP}
             mov si,word ptr p    {SI - offset BMP}
             mov ax,[es:si]
             mul word ptr [es:si+2]
             mov cx,ax            {CX - pocet spracuvanych bajtov (RozX*RozY)}
             mov di,si
             add di,4             {DI - zaciatok bitmapy}
@DalsiBod:   mov al,byte[es:di]
             mov bl,al
             and al,00Fh          {rozdel byte na nibbly v AL,BL}
             and bl,0F0h
             mul Nas
             div Del              {v AL je upravena jasova zlozka farby}
             cmp al,15
             jbe @Nezaokruhli
             mov al,15
@Nezaokruhli:add al,bl
             stosb
             loop @DalsiBod
end;
procedure ZmenMierkuBMP(Zdroj,Ciel:pointer;XNas,XDel,YNas,YDel:byte);assembler;
var ZRozX,ZRozY,CRozX,CRozY,ZPosX,ZPosY,CPosX,CPosY,TempDI:word;
asm
             cld
             push ds              {DS:SI -> ES:DI}
             mov ds,word ptr Zdroj+2
             mov si,word ptr Zdroj
             mov es,word ptr Ciel+2
             mov di,word ptr Ciel
             mov ZPosX,0
             mov ZPosY,0
             mov CPosX,0
             mov CPosY,0
             mov ax,word [ds:si]  {nacitaj Zdroj,RozX}
             mov ZRozX,ax
             mul XNas
             div XDel
             xor ah,ah
             mov word [es:di],ax  {nastav Ciel,RozX}
             mov CRozX,ax
             mov ax,word [ds:si+2]{nacitaj Zdroj,RozY}
             mov ZRozY,ax
             mul YNas
             div YDel
             xor ah,ah
             mov word [es:di+2],ax{nastav Ciel,RozY}
             mov CRozY,ax
             add si,4             {nastav na zaciatky bitmap}
             add di,4
             mov TempDI,di
{ ----- zaciatok vonkajsieho aj vnutorneho cyklu ----- }
@DalsiBod:   mov ax,ZPosX
             mul XNas
             div XDel
             xor ah,ah
             mov bx,ax            {BX - x-ova sur. ciela}
             mov ax,ZPosY
             mul YNas
             div YDel
             xor ah,ah
             mov dx,CRozX
             mul dl               {8-bit nasobenie pre CRozX! }
             mov di,TempDI
             add di,ax            {DI - offset aj y-ova sur. nasobena CRozX}
             lodsb
             mov byte[es:di+bx],al
             inc CPosX
             inc ZPosX
             mov ax,ZPosX
             cmp ax,ZRozX
             jb @DalsiBod
{ ----- koniec vnutorneho cyklu ----- }
             mov ZPosX,0
             mov CPosX,0
             inc ZPosY
             inc CPosY
             mov ax,ZPosY
             cmp ax,ZRozY
             jbe @DalsiBod
{ ----- koniec vonkajsieho cyklu ----- }
             pop ds
end;
procedure KopirujBMP(Zdroj,Ciel:pointer;x,y,RozX,RozY:word);assembler;
asm
             cld
             push ds
             mov ds,word ptr Zdroj+2   {inicializacia premennych}
             mov bx,word ptr Zdroj
             mov es,word ptr Ciel+2
             mov di,word ptr Ciel
             mov ax,RozX               {nastavenie rozmerov v cielovej bitmape}
             mov word[es:di],ax
             mov ax,RozY
             mov word[es:di+2],ax
             add di,4
             mov ax,word[bx]           {relativny offset v zdrojovej bitmape}
             mul y
             add ax,x
             mov si,bx
             add si,4
             add si,ax                 {kopirovanie DS:SI -> ES:DI}
             mov dx,RozY
@DalsiRiadok:mov cx,RozX
         rep movsb
             add si,word[bx]
             sub si,RozX               {uprav zdrojovy offset}
             dec dx
             jnz @DalsiRiadok
             pop ds
end;
procedure PosunVRAMSpredu(StartX,StartY,RozX,RozY,KolkoX,KolkoY:integer);assembler;
asm
             call AkTrebaVypniMys
             mov es,VSeg     {ES - 0A000h, DS sa nemeni}
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
             call AkTrebaZapniMys
end;
procedure PosunVRAMZozadu(StartX,StartY,RozX,RozY,KolkoX,KolkoY:integer);assembler;
asm
             call AkTrebaVypniMys
             mov es,VSeg     {ES - 0A000h, DS sa nemeni}
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
             call AkTrebaZapniMys
end;
BEGIN
END.