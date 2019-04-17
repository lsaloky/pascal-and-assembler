program Vypocet_cisla_pi; {verzia 2.0}
{$M 1024,0,0}
{  moderne cez arkustangensy, nie len tak ledabolo ...
   vzorec: Pi = 48*arctg(1/18)+32*arctg(1/57)-20*arctg(1/239)  }

const a:array[1..8] of byte=(0,0,0,0,$12,$34,$56,$78);
      b:array[1..8] of byte=(0,0,0,0,$21,$43,$88,$99);
      Dlzka:word=4;
var ASeg,BSeg:word;

(*function ArkusTangens(x:real):real;
var Pom,XNaI:real;
    i:integer;
begin
  Pom:=x;
  XNaI:=x;
  for i:=2 to 3 do begin {do 11}
    XNaI:=XNaI*x*x;
    if i mod 2 = 1 then Pom:=Pom+XNaI/(2*i-1)
                   else Pom:=Pom-XNaI/(2*i-1);
  end;
  ArkusTangens:=Pom;
end; *)
{ ----- Scitanie; 2 operandy s mojim formatom ----- }
procedure Plus(Seg1,Seg2:word);assembler;{vysledok v Seg2}
asm
            std
            push ds
            mov ds,ASeg           {DS:SI - 1. cislo}
          {  mov es,BSeg  }         {ES:DI - 2. cislo a vysledok}
            mov si,word ptr Dlzka
            add si,4
            mov di,si             {DI aj SI na poslednu cislicu}
            mov cx,Dlzka
@Dalsia:    lodsb
            add al,byte[es:di]
            daa
            stosb
            loop @Dalsia
            pop ds
end;
{ ----- HLAVNY PROGRAM ----- }
BEGIN
  asm
             mov ah,48h
             mov bx,1
             int 21h              {alokacia ASeg}
             mov ASeg,ax
             mov ah,48h
             mov bx,1
             int 21h              {alokacia BSeg}
             mov BSeg,ax

             mov si,offset a
             mov es,ASeg
             xor di,di
             mov cx,4
         rep movsw
             mov si,offset b
             mov es,BSeg
             xor di,di
             mov cx,4
         rep movsw
  end;
  Plus(Seg(a),Seg(b));
{ ----- koniec programu ----- }
  asm
             mov es,ASeg
             mov ah,49h
             int 21h              {dealokacia ASeg}
             mov es,BSeg
             mov ah,49h
             int 21h              {dealokacia BSeg}
  end;
(*  writeln(-1000*ln(10)/ln(1/239):0:20); { vypocet, dokedy treba pocitat pri presnosti 1000 miest}
  { 2n-1 = 795 pre 1/18, 571 pre 1/57, 421 pre 1/239}
  writeln(ArcTan(1/18):0:10,' ; ',ArkusTangens(1/18):0:10);*)
  readln;
END.
