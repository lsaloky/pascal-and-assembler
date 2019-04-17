program Testovanie_ci_je_platna_Velka_Fermatova_veta;
{nedokonceny, nie najrychlejsi algoritmus}
var x,y:comp;
{$M 1024,0,8192}
{ES:offset                        Registre:
   0 - word - 2000h               6n+6 ...... 24 bitov ... AL:SP
   2 - word - 3000h               ný+3n+1 ... 40 bitov ... AH:SI:DI
   4 - word - 4000h               n^3 ....... 48 bitov ... BX:CX:DX
   6 - word - 5000h
   8 - word - 6000h               indexovanie v pamati ... BP
   10- word - 7000h
   12- word - 8000h
   14- word - 9000h
   16- word - X
   18- word - Y
   20- word - reg. SP
   22-3word - jeden zo scitancov - nepouzite
   28- word - Stred
   30- word - Posun
   32- 24bit- inicializacna hodnota 6n+6
   35- 40bit- inicializacna hodnota 3ný+3n+1
   40- 48bit- inicializacna hodnota prveho scitanca
   46- word - pomocne slovo
   48-
   }
procedure Kontrola;
var z:comp;
begin
  z:=MemW[$1F00:0016];
  x:=z*z*z;
  z:=MemW[$1F00:0018];
  x:=x+z*z*z;
  if x<>y then writeln('Chyba pre ',x:0:0,',',y:0:0)
end;
procedure Mocnina;assembler;
asm
             mov cx,0
             mov ax,word[es:18]
             mul ax
             mov si,ax
             mov di,dx
             mul word[es:18]
             add si,ax
             adc cx,dx
             mov ax,di
             mul word[es:18]
             add cx,ax
             adc bx,dx
end;
BEGIN
  asm
{ ----- inicializacia pamate ----- }
             mov ax,1F00h
             mov es,ax
             mov word[es:0],2000h
             mov word[es:2],3000h
             mov word[es:4],4000h
             mov word[es:6],5000h
             mov word[es:8],6000h
             mov word[es:10],7000h
             mov word[es:12],8000h
             mov word[es:14],9000h
             mov word[es:16],1
             mov word[es:18],1
             mov word[es:20],sp
             mov word[es:22],0
             mov word[es:24],0
             mov word[es:26],1
             mov byte[es:32],0
             mov word[es:33],12
             mov byte[es:35],0
             mov word[es:36],0
             mov word[es:38],7
             mov word[es:40],0
             mov word[es:42],0
             mov word[es:44],1
{ ----- inicializacia registrov ----- }
@DalsieY:    mov al,0
             mov sp,0 {12}
             mov ah,0
             mov dx,0
             mov di,0   {7}
             mov bx,0
             mov cx,0
             mov si,1
             add al,byte[es:32]
             add sp,word[es:33]
             add ah,byte[es:35]
             add dx,word[es:36]
             add di,word[es:38]
             add bx,word[es:40]
             add cx,word[es:42]
             add si,word[es:44]
{ ----- vypocet suctu tretich mocnin ----- }
@Dalsia:     add si,di   {+3ný+3n+1 v BX:CX:SI}
             adc cx,0
             adc bx,0
             add cx,dx
             adc bx,0
             add bl,ah
             adc bh,0
             add di,sp   {+6n+6 v AH:DX:DI}
             adc dx,0
             adc ah,0
             add dl,al
             adc dh,0
             adc ah,0
             add sp,6    {+6 v AL:SP}
             adc al,0
             inc word[es:16]{x}


             xchg sp,word[es:20]
             pusha
             lea di,y
             mov word[di],si
             mov [di+2],cx
             mov [di+4],bx
             mov word[di+6],0
             call Kontrola
             mov ax,1F00h
             mov es,ax
             popa
             xchg sp,word[es:20]


             cmp word[es:16],65535
             jb @Dalsia
             inc word[es:18]
             mov word[es:46],ax
             mov ax,word[es:16]
             mov word[es:18],ax
             mov ax,word[es:44]
             add ax,word[es:38]
             mov word[es:44],ax
             adc word[es:42],0
             adc word[es:40],0
             mov ax,word[es:42]
             add ax,word[es:36]
             mov word[es:42],ax
             adc word[es:40],0
             mov al,byte[es:40]
             add al,byte[es:35]
             mov byte[es:40],al
             adc byte[es:41],0
             {daj do AX}
             add word[es:38],word[es:33]
             adc word[es:36],0
             adc byte[es:35],0
             add byte[es:36],byte[es:32]
             adc byte[es:37],0
             adc byte[es:35],0
             add word[es:34],6
             adc byte[es:32],0
             mov ax,word[es:46]
(*
             add si,di   {+3ný+3n+1 v BX:CX:SI}
             adc cx,0
             adc bx,0
             add cx,dx
             adc bx,0
             add bl,ah
             adc bh,0
             add di,sp   {+6n+6 v AH:DX:DI}
             adc dx,0
             adc ah,0
             add dl,al
             adc dh,0
             adc ah,0
             add sp,6    {+6 v AL:SP}
             adc al,0*)
             cmp word[es:18],10
             jb @DalsieY

{ ----- ukoncenie programu ----- }
             mov sp,word[es:20]
  end;
END.