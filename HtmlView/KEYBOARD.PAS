unit Keyboard;
                            INTERFACE
uses Dos;
{ ----- konstanty pre pracu s procedurou KodNaZnak, nie so zoznamom! ----- }
const { nad sipkami (+NumPad) }
      KIns=$E0;KHome=$E1;KPgUp=$E2;KDel=$E3;KEnd=$E4;KPgDn=$E5;
      KUp=$E6;KLeft=$E7;KDn=$E8;KRight=$E9;  { sipky }
      { F1 .. F9 sa koduje ako $F1 ..$F9, F10 je $F0 }
{ ----- konstanty premennej StavLock ----- }
      KCaps=$40;KNum=$20;KScroll=$10;KAlt=$8;KCtrl=$4;KLShift=$2;KPShift=$1;
type TKlavesy=array[0..127] of byte;
     PKlavesy=^TKlavesy;
var StavLock:byte absolute $0000:$0417;
    Zoznam:PKlavesy;
    kb:procedure;
{ ----- procedury jednotky KeyBoard ----- }
function KodNaZnak(KKod:byte):byte;
procedure ReadLn2(pocet:byte;var s:string);
procedure NastavLock(stav:byte);
function JeStlaceny:boolean;
procedure InicializujZoznam; { musi byt pred zacatim prace }
procedure ZavriZoznam;       { MUSI byt po skonceni prace }
                        IMPLEMENTATION
const KonvTab:array[0..143] of byte=(
        $00,$1B,$31,$32,$33,$34,$35,$36,$37,$38,$39,$30,$2D,$3D,$08,$09,
        $71,$77,$65,$72,$74,$79,$75,$69,$6F,$70,$5B,$5D,$0D,$00,$61,$73,
        $64,$66,$67,$68,$6A,$6B,$6C,$3B,$27,$60,$00,$5C,$7A,$78,$63,$76,
        $62,$6E,$6D,$2C,$2E,$2F,$00,$2A,$00,$20,$00,$F1,$F2,$F3,$F4,$F5,
        $F6,$F7,$F8,$F9,$F0,$00,$00,$E1,$E6,$E2,$2D,$E7,$00,$E9,$2B,$E4,
        $E8,$E5,$E0,$E3,$00,$00,$5C,$00,$00,$00,$00,$00,$00,$00,$00,$00,
        $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
        $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
        $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00);
function KodNaZnak(KKod:byte):byte;assembler;
asm
             lea bx,KonvTab
             mov al,KKod
             xlat
end;
function JeStlaceny:boolean;assembler;
asm
             mov ah,11h
             int 16h
             jz @NieJe
             mov ah,10h
             int 16h
             mov al,True
             jmp @Von
@NieJe:      mov al,False
@Von:
end;
procedure ReadLn2(pocet:byte;var s:string);
var SSeg,SOfs:word;
begin
  pocet:=pocet+1;
  move(pocet,s[1],1);
  pocet:=pocet-1;
  SSeg:=Seg(s);
  SOfs:=Ofs(s);
  asm
    mov AH,$0A
    mov DS,SSeg
    mov DX,SOfs
    inc DX
    int $21
  end;
  Move(s[3],s[1],pocet);
  move(pocet,s[0],1);
end;
procedure NastavLock(stav:byte);assembler;
asm
    mov ax,$0040
    mov es,ax
    mov al,Stav
    mov byte[es:17],al
    mov AH,$01
    Int $16
end;
procedure Up9;interrupt;
var a:byte;
begin
  asm
@JeDalsi:    mov ah,1             {While KeyPressed do ReadKey;}
             int 16h
             jz @Nic
             mov ah,0
             int 16h
             jmp @JeDalsi
@Nic:        mov es,word ptr Zoznam+2
             mov di,word ptr Zoznam
             in al,60H
             xor ah,ah
             cmp al,128
             jb @Pridaj
             sub al,128
             add di,ax
             mov al,0
             stosb
             jmp @Koniec
@Pridaj:     add di,ax
             mov al,1
             stosb
@Koniec:
  end;
  inline($9C);
  kb;
end;
procedure InicializujZoznam;
begin
  GetMem(Zoznam,128);
  FillChar(Zoznam^,SizeOf(TKlavesy),#0);
  GetIntVec($9,@kb);
  SetIntVec($9,Addr(Up9));
end;
procedure ZavriZoznam;
begin
  SetIntVec($9,@kb);
  FreeMem(Zoznam,SizeOf(TKlavesy));
end;
BEGIN
END.