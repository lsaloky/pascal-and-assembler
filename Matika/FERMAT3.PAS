program Testovanie_ci_je_spravna_Velka_Fermatova_veta;
var a:array[0..24575] of word;{8192 6-bajtovych tretich mocnin}
    x,y,Stred,Posun:word;
procedure Zhodne;
begin
  writeln('Plati pre',x,',',y);
  readln;
end;
BEGIN
  asm
             pusha
             mov x,1
             lea bx,a
{ ----- vypocet tretich mocnin ----- }
@DalsiaMoc:  mov bp,0
             mov ax,x
             mul ax
             mov cx,dx
             mul x
             mov di,ax
             mov si,dx
             mov ax,cx
             mul x
             add si,ax
             adc bp,dx
             mov [bx],bp
             mov [bx+2],si
             mov [bx+4],di
             add bx,6
             inc x
             cmp x,8192
             jl @DalsiaMoc
{ ----- vypocet suctu tretich mocnin ----- }
             mov x,1
             mov y,1
@Sucet:      mov Stred,24576
             mov Posun,12288
             lea bx,a
             add bx,Stred
             mov bp,0{prva tretia mocnina}
             mov ax,x
             mul ax
             mov cx,dx
             mul x
             mov di,ax
             mov si,dx
             mov ax,cx
             mul x
             add si,ax
             adc bp,dx
             mov ax,y{druha tretia mocnina}
             mul ax
             mov cx,dx
             mul y
             add di,ax
             adc si,dx
             adc bp,0
             mov ax,cx
             mul y
             adc si,ax
             adc bp,dx
@Hladaj:     cmp bp,[bx]
             ja @Vacsie
             jb @Mensie
             cmp si,[bx+2]
             ja @Vacsie
             jb @Mensie
             cmp di,[bx+4]
             ja @Vacsie
             jb @Mensie
             call Zhodne
@Vacsie:     mov ax,Stred
             add ax,Posun
             mov Stred,ax
             add bx,Posun
             shr Posun,1
             cmp Posun,3
             jae @Hladaj
             jmp @ZvysX
@Mensie:     mov ax,Stred
             sub ax,Posun
             mov Stred,ax
             sub bx,Posun
             shr Posun,1
             cmp Posun,3
             jae @Hladaj
@ZvysX:      inc x
             cmp x,8192
             jb @Sucet
             mov x,1
             inc y
             cmp y,8192
             jb @Sucet
             popa
  end;
  writeln('OK');
END.