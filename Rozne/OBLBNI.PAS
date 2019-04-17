program Oblbovak_na_hry; { podsunie programu iny subor, ako on chce }
uses Dos;                { vyvojovy smer -> assembler }
const Pokus:string='text1.txt'#0;
{$M 1024,0,0}
var StaryInt:pointer;
var Straz,Nahrad:string[80];
    Buffer:array[1..5] of char;
    f:file;
{ ----- HLAVNY PROGRAM ----- }
BEGIN
  if ParamCount=0 then WriteLn('Nezadal si parametre - hladany a nahradzany subor.')
  else begin
    Straz:=ParamStr(1)+#0;
    Nahrad:=ParamStr(2)+#0;
    asm
{            mov ah,3Dh
            mov dx,offset Pokus
            inc dx}
             jmp @Program
{ ----- cast programu zavesena na preruseni 21h ----- }
@Up21h:      pusha
             cmp ah,3Dh
             jne @NicPreMna
             mov si,dx             { DS:SI - adresa nazvu otvaraneho suboru }
             mov ax,seg Straz
             mov es,ax
             mov di,offset Straz   { ES:DI+1 - adresa nazvu strazeneho suboru }
             mov cl,byte ptr [es:di]
             xor ch,ch             { dlzka pripravena }
             inc di                { ES:DI }
        repe cmpsb
             jne @NicPreMna        { skok po porovnani }
             popa
             mov dx,offset Nahrad  { nahradenie mena suboru }
             inc dx
             jmp StaryInt          { skok po nahradeni }
@NicPreMna:  popa
             jmp StaryInt          { skok, ak nie je pre mna }
{ ----- obsadenie prerusenia 21h ----- }
@Program:    mov ah,02h
             mov dl,251
             int 21h               { vypis informaciu o nainstalovani }
             mov ax,0
             mov es,ax
             mov bx,word ptr es:132
             mov cx,word ptr es:134
             mov word ptr StaryInt,bx
             mov word ptr StaryInt+2,cx    { adresa skopirovana do StaryInt }
             cli
             mov bx,offset @Up21h
             mov cx,seg @Up21h
             mov word ptr es:132,bx
             mov word ptr es:134,cx       { prepisane prerusenie }
             sti
{ ----- zrezidentnenie programu ----- }
(*             mov ax,0
             mov dx,8192   {offset @Program+1}
             int 27h*)
    end;
{ ----- cast programu pracujuca s novym prerusenim ----- }
    Assign(f,'text1.txt');
    Reset(f,1);
    BlockRead(f,Buffer,5);
    Write(buffer[1],buffer[2],buffer[3]);
    Close(f);
{ ----- Uvolnenie prerusenia 21h ----- }
    asm
             mov ax,0
             mov es,ax
             cli
             mov bx,word ptr StaryInt
             mov cx,word ptr StaryInt+2
             mov word ptr es:132,bx
             mov word ptr es:134,cx      { prepisane prerusenie }
             sti
    end;
 {   Keep(0);}
  end;
END.