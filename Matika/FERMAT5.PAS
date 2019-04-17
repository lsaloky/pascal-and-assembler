program Testovanie_ci_je_platna_Velka_Fermatova_veta;
{pozor,ostra verzia!!! Spustaj len pri QEMM !!!'}
{rychlost overovania: 1..1000 3s,do 2000 11s,do 4000 41s,do 8000 170s}
{$M 1024,0,0}
const s:string='Inicializovane...$';
procedure Chyba;
begin
  writeln('Plati pre ',MemW[$1900:68],',',MemW[$1900:70]);
end;
procedure Mocnina;assembler;{pouziva DX,CX,AX,SI,DI,BP}
asm
             mov cx,0
             mov bp,0
             mov ax,word[es:18]
             mul ax
             mov di,dx
             mul word[es:18]
             mov si,ax
             mov cx,dx
             mov ax,di
             mul word[es:18]
             add cx,ax
             adc bp,dx
end;
BEGIN
  asm
             push ds
             mov ax,1900h
             mov es,ax
             mov ds,ax
             mov word[0],2000h
             mov word[2],3000h
             mov word[4],4000h
             mov word[6],5000h
             mov word[8],6000h
             mov word[10],7000h
             mov word[12],8000h
             mov word[14],9000h
             mov word[16],2{index hodnot pre DS}
             mov word[18],1{cinitel pri vypocte mocnin}
             mov word[20],128{8192^3 div 65536 div 65536}
             mov word[22],1024{16384^3}
             mov word[24],3456{24576^3}
             mov word[26],8192{32768^3}
             mov word[28],16000{40960^3}
             mov word[30],27648{49152^3}
             mov word[32],43904{57344^3}
             mov word[34],65535{65536^3-1}
             mov word[68],1{jeden zo scitancov}
             mov word[70],1{druhy}
             mov word[72],0
             mov ds,[es:0]
             mov bx,0
@Dalsia:     call Mocnina
             mov [bx],bp
             mov [bx+2],cx
             mov [bx+4],si
             add bx,6
             test word[es:18],0001111111111111b
             jnz @Nezvysuj
             mov di,word[es:16]
             add word[es:16],2
             mov ds,word[es:di]
             xor bx,bx
@Nezvysuj:   inc word[es:18]
             cmp word[es:18],63000    { !!!!!!!!!!!!!! }
             jbe @Dalsia
{ ----- kontrolny vypis ----- }
             pop ds
             lea dx,s
             inc dx
             mov ah,09h
             int 21h
             push ds
{ ----- sucet tretich mocnin ----- }
             mov ds,[es:0]
@Sucet:      mov ax,word[es:68]{vypocet segmentu}
             shr ax,13
             add ax,ax
             mov di,ax
             mov ds,[es:di]
             mov ax,word[es:68]{vypocet offsetu}
             mov dl,6
             mul dl
             sub ax,6
             mov si,ax
             mov bx,[si]{prve cislo}
             mov cx,[si+2]
             mov bp,[si+4]
             mov ax,word[es:70]{vypocet segmentu 2. cisla}
             shr ax,13
             add ax,ax
             mov di,ax
             mov ds,[es:di]
             mov ax,word[es:70]{vypocet offsetu 2. cisla}
             mul dl
             sub ax,6
             mov si,ax
             add bp,[si+4]{pricitanie druheho}
             adc cx,0
             adc bx,0
             jc @NerobDalej
             add cx,[si+2]
             adc bx,0
             jc @NerobDalej
             add bx,[si]
             jc @NerobDalej
             mov di,20{linearne medzisegmentove vyhladavanie suctu}
@ZvysSeg:    cmp bx,[es:di]
             jb @NastavSeg
             add di,2
             jmp @ZvysSeg
@NastavSeg:  sub di,20
             mov ds,[es:di]
             mov di,24576{binarne vnutrosegmentove vyhladavanie}
             mov dx,12288
@BinarJMP:   cmp [di],bx
             jb @Zvys
             ja @Zniz
             cmp [di+2],cx
             jb @Zvys
             ja @Zniz
             cmp [di+4],bp
             jb @Zvys
             ja @Zniz
             pop ds
             pusha
             call Chyba
             mov ax,1900h
             mov es,ax
             popa
             jmp @NerobDalej
@Zvys:       add di,dx
             jmp @NastavPosun
@Zniz:       sub di,dx
@NastavPosun:shr dx,1
             cmp dx,3
             jae @BinarJMP
@NerobDalej: inc word[es:68]
             cmp word[es:68],50000{ !!!!!!!!!!! }
             jb @Sucet
             inc word[es:70]
             mov ax,word[es:70]
             mov word[es:68],ax
             cmp word[es:70],50000{ !!!!!!!!!!! }
             jb @Sucet
             pop ds
  end;
  writeln('OK');
END.
