program Eratostenovo_sito;
{uses MukoXMS;}
{$DEFINE ASM}
{$DEFINE aVYPIS}
const Velkost:longint=500000;
type Buf=array[0..63999] of byte;
var a:Buf;
    i,MaxI:word;
    k,j,MaxJ:longint;
    f:file of Buf;

procedure NastavBit(Ktory:longint);
begin
  a[Ktory div 8]:=a[Ktory div 8] or (1 shl (7-Ktory mod 8));
end;

function JePrvocislo(Ktory:longint):boolean;
begin
  if a[Ktory div 8] and (1 shl (7-Ktory mod 8))=0
  then JePrvocislo:=True
  else JePrvocislo:=False;
end;

procedure NastavMaxJ;
begin
  MaxJ:=Velkost div i;
end;

BEGIN { ----- HLAVNY PROGRAM ----- }
  Assign(f,'eratost.dat');
  ReWrite(f);
  {NastavBit(1);}
  MaxI:=Trunc(Sqrt(Velkost));
{$IFNDEF ASM}
  for i:=2 to Trunc(Sqrt(Velkost)) do
    for j:=2 to Velkost div i do
      NastavBit(longint(i)*longint(j));
{$ELSE}
  asm
             mov word ptr i,2         {i:=2}
@Fori:
             mov word ptr j,1         {j:=1}
             mov ax,word ptr i        {k:=i}
             mov word ptr k+2,0
             mov word ptr k,ax
             call NastavMaxJ
@Forj:
             mov ax, word ptr i       {k:=k+i}
             add word ptr k,ax
             adc word ptr k+2,0
{ ----- nastav k-ty bit ----- }
             mov ax,word ptr k        {k v registroch del 8}
             mov dx,word ptr k+2
             shr dx,1
             rcr ax,1
             shr dx,1
             rcr ax,1
             shr dx,1
             rcr ax,1
             mov si,ax                {nastav SI na a}
             add si,offset a
             mov cx,word ptr k
             and cx,0007h             {zvysok po deleni k/8 v CX}
             neg cx
             add cx,7                 {CX = 7 - zvysok}
             mov ax,1
             shl al,cl                {AL = 2 na CL}
             or byte ptr [si],al

             inc word ptr j           {j:=j+1, !longint!}
             adc word ptr j+2,0
             mov ax,word ptr MaxJ
             cmp word ptr j,ax
             jne @ForJ
             mov ax,word ptr MaxJ+2
             cmp word ptr j+2,ax
             ja @ForJ                 {if j<=MaxJ then goto ForJ}

             inc word ptr i           {i:=i+1}
             mov ax,MaxI
             cmp i,ax
             jbe @ForI                {if i<=MaxI then goto ForI}
  end;
{$ENDIF}
  write(f,a);
  Close(f);
{$IFDEF VYPIS}
  for j:=2 to Velkost do
    if JePrvocislo(j) then write(j,', ');
  WriteLn;
{$ENDIF}
END.