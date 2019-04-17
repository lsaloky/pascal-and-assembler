program Assemblovske_rutiny_pre_rychle_pocitanie_aritmetickych_vyrazov;
const dlzka:word=255;
type TPole=array[1..255] of byte;
var a,b,c:TPole;            {operatory}
    x:word;
    ch:char;
procedure NacitajCislo(var p1:TPole);
var ps:string;
    px:word;
begin
  readln(ps);
  for px:=1 to Length(ps) do p1[dlzka-Length(ps)+px]:=Ord(ps[px])-48;
end;
BEGIN
  writeln('Zadaj 1. cislo');
  NacitajCislo(a);
  writeln('Zadaj 2. cislo');
  NacitajCislo(b);
  writeln('Scitanie alebo Nasobenie? s/n');
  readln(ch);
  asm
{ ----- inicializacia registrov ----- }
             lea si,a      {SI 1. operand}
             add si,dlzka
             dec si        {posledny byte}
             lea bx,b      {BX 2.        }
             add bx,dlzka
             dec bx        {posledny byte}
             lea di,c      {DI vysledok  }
             add di,dlzka
             dec di        {posledny byte}
             mov cx,dlzka
             cmp ch,'n'    {co chces robit}
             je @Nasob
{ ----- scitanie ----- }
@Dalsi:      mov al,byte[si]
             add al,byte[bx]{pripocitaj 2. cislo}
             cmp al,10
             jb @Nepretec
             sub al,10
             mov byte[di-1],1{nastav pretecenie}
@Nepretec:   add byte[di],al
             dec si          {presun na dalsiu cislicu}
             dec di
             dec bx
             loop @Dalsi
             jmp @Koniec
@Nasob:
@Koniec:
  end;
END.