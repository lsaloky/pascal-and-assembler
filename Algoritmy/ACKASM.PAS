program Aproximacia_Coonsovou_kubikou; { v assembleri }
uses MainGr;
const RB:array[1..10,1..2] of longint=({ riadiace body, koniec (321,0)}
        (20,20),(50,80),(160,30),(290,90),(200,110),(160,190),(80,160),(60,120),(100,110),(321,0));
      Mat:array[1..4,1..4] of integer=((1,4,1,0),(-3,0,3,0),(3,-6,3,0),(-1,3,-3,1));
var SumaX,SumaY:longint;
    AktBod:byte;    { ktory riadiaci bod je prvy na danom useku}
    j:integer;      { prve volne miesto v poli Krivka }
    i,k:word;       { pomocne }
    Koef:longint;
    Param:array[0..3] of word; { MUSI byt globalna premenna! (v unite)}
    Log2PocetB:array[0..3] of byte;
    Krivka:array[1..200,1..2] of integer; { vystupne pole }

function Vypocet:word;
begin
  Log2PocetB[0]:=0;
  Log2PocetB[2]:=2*Log2PocetB[1];
  Log2PocetB[3]:=3*Log2PocetB[1];
  Param[0]:=1;
  Param[1]:=0;
  AktBod:=1;
  j:=1;
  repeat
    Param[2]:=Param[1]*Param[1];  {na druhu}
    Param[3]:=Param[2]*Param[1];
    SumaX:=0;SumaY:=0;
    for i:=0 to 3 do begin
{      Koef:=0;
      for k:=1 to 4 do
        Inc(Koef,(Mat[k,i+1] shl Log2PocetB[4-k])*Param[k-1]);}
      asm
             pusha
             push ds
             push es
             mov ax,seg Mat
             mov es,ax
{!!!!!             mov i,0     }            {i:=0}

@CyklusI:    mov word ptr Koef,0     {Koef:=0}
             mov word ptr Koef+2,0
             mov k,1                 {k:=1}

@CyklusK:    mov bx,offset Mat
             mov ax,k                {ax <- Matica[k,i+1] cez ES:BX}
             dec ax                   {je to [k-1,i], lebo od nuly index Mat}
             shl ax,3
             add bx,ax
             add bx,i
             add bx,i

             mov ax,word ptr [es:bx]

             mov bx,offset Log2PocetB {cl <- Log2PocetB[4-k] cez ES:BX}
             add bx,4
             sub bx,k
             mov cl,byte ptr [es:bx]

             cmp ax,0                 {vynasob AX cislom 2^CL}
             jl @Zaporne
             shl ax,cl                {kladne cislo - jednoduche}
             jmp @OK1
@Zaporne:    neg ax
             shl ax,cl
             neg ax

@OK1:        mov bx,offset Param
             add bx,k
             add bx,k
             sub bx,2
             mov bx,word ptr [es:bx]  {BX <- Param[k-1]}

             imul bx                  {vynasob}
             add word ptr Koef,ax
             adc word ptr Koef+2,dx   {pripocitaj ku Koef}

             inc k
             cmp k,4
             jbe @CyklusK

             pop es
             pop ds
             popa
      end;
      SumaX:=SumaX+RB[AktBod+i,1]*Koef;
      SumaY:=SumaY+RB[AktBod+i,2]*Koef;
    end;
    SumaX:=SumaX div 6 div (1 shl Log2PocetB[3]);
    SumaY:=SumaY div 6 div (1 shl Log2PocetB[3]);
    Krivka[j,1]:=SumaX;
    Krivka[j,2]:=SumaY;
    Inc(j);
    Inc(Param[1]);
    if Param[1]>=(1 shl Log2PocetB[1]) then begin
      Param[1]:=0;
      Inc(AktBod);
    end;
  until RB[AktBod+3,1]=321;
  Vypocet:=j;
end;
BEGIN
  InicializujGrafiku;
  Log2PocetB[1]:=4; { 2^4 = 16 bodov na 1 usek krivky }
  j:=Vypocet;
  for i:=1 to j-1 do PolozBod(Krivka[i,1],Krivka[i,2],15);
  ReadLn;
  ZavriGrafiku;
END.