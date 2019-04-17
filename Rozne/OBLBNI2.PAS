program Oblbovak_na_hry; { podsunie programu iny subor, ako on chce }
uses Dos;                { vyvojovy smer -> Keep }
{$M 1024,0,0}
{const Pokus:string='text1.txt'#0;}
{var StaryInt:pointer;}
var Straz0,Nahrad0:string[80];

{    Buffer:array[0..5] of char;
    f:file;    }
{ ----- HLAVNY PROGRAM ----- }
BEGIN
  if ParamCount=0 then WriteLn('Nezadal si parametre - hladany a nahradzany subor.')
  else begin
    Straz0:=ParamStr(1)+#0;
    Nahrad0:=ParamStr(2)+#0;
    asm
{             mov di,offset @StaryInt
             mov word ptr[cs:di],offset @Koniec
             mov word ptr [cs:di+2],cs
             jmp dword ptr cs:@staryint}
             jmp @Program
@StaryInt:   dd 0
@Straz:      dd 0; dd 0; dd 0; dd 0; dd 0; dd 0; dd 0; dd 0; dd 0; dd 0;
             dd 0; dd 0; dd 0; dd 0; dd 0; dd 0; dd 0; dd 0; dd 0; dd 0;
@Nahrad:     dd 0; dd 0; dd 0; dd 0; dd 0; dd 0; dd 0; dd 0; dd 0; dd 0;
             dd 0; dd 0; dd 0; dd 0; dd 0; dd 0; dd 0; dd 0; dd 0; dd 0;
{ ----- cast programu zavesena na preruseni 21h ----- }
@Up21h:      pusha
             cmp ah,3Dh
             jne @NicPreMna
             mov si,dx             { DS:SI - adresa nazvu otvaraneho suboru }
             mov ax,cs{seg Straz}
             mov es,ax
             mov di,offset @Straz  { ES:DI+1 - adresa nazvu strazeneho suboru }
             mov cl,byte ptr [es:di]
             xor ch,ch             { dlzka pripravena }
             inc di                { ES:DI }
        repe cmpsb
             jne @NicPreMna        { skok po porovnani }
             popa
             mov dx,offset @Nahrad { nahradenie mena suboru }
             inc dx
             jmp dword ptr cs:@StaryInt {StaryInt}        { skok po nahradeni }
@NicPreMna:  popa
             jmp dword ptr cs:@StaryInt {StaryInt}        { skok, ak nie je pre mna }
{ ----- obsadenie prerusenia 21h ----- }
@Program:    cld
             mov ax,ds
             mov es,ax
             mov si,offset Straz0
             mov di,offset @Straz
             mov cx,81
         rep movsb
             mov si,offset Nahrad0
             mov di,offset @Nahrad
             mov cx,81
         rep movsb                 { nakopirovane Straz0 a Nahrad0 }
             mov ah,02h
             mov dl,251
             int 21h               { vypis informaciu o nainstalovani }
             mov ax,0
             mov es,ax
             mov bx,word ptr es:132
             mov cx,word ptr es:134

             mov di,offset @StaryInt
             mov word ptr [cs:di],bx
             mov word ptr [cs:di+2],cx
{ netreba    mov word ptr StaryInt,bx
             mov word ptr StaryInt+2,cx  }  { adresa skopirovana do StaryInt }
             cli
             mov bx,offset @Up21h
             mov cx,seg @Up21h
             {mov word ptr es:132,bx
             mov word ptr es:134,cx}         { prepisane prerusenie }
             sti
{ ----- zrezidentnenie programu ----- }
             mov ax,0
             mov dx,8192   {offset @Program+1}
             int 27h
    end;
{ ----- cast programu pracujuca s novym prerusenim ----- }
  {  Assign(f,Pokus);
    Reset(f,1);
    BlockRead(f,Buffer,3);
    Close(f);  }
{ ----- Uvolnenie prerusenia 21h ----- }
 (*   asm
             mov ax,0
             mov es,ax
             cli
             mov bx,word ptr StaryInt
             mov cx,word ptr StaryInt+2
             mov word ptr es:132,bx
             mov word ptr es:134,cx      { prepisane prerusenie }
             sti
    end;  *)
  end;
END.