program Tri_prasiatka_a_assembler;
const nc:array[1..10,1..20] of byte=  {nahodne cisla}
     ((8,5,1,4,9,5,7,5,0,4,1,5,0,5,9,3,6,8,4,9),
      (3,5,2,2,9,7,2,8,3,7,3,6,7,5,2,7,1,6,5,5),
      (4,0,1,1,7,2,4,3,4,6,3,2,1,8,9,8,7,0,7,4),
      (6,0,8,7,5,9,7,5,4,5,6,8,6,5,2,9,2,1,6,0),
      (0,3,7,6,9,3,2,5,5,1,7,4,8,0,1,4,1,6,9,2),
      (9,4,0,7,7,9,2,2,0,9,3,1,5,0,6,6,9,6,0,6),
      (8,4,3,7,6,0,0,6,6,6,9,4,1,4,5,2,2,3,9,9),
      (2,4,3,5,4,1,1,3,4,7,9,0,9,2,0,0,3,8,6,4),
      (8,1,1,4,9,4,3,2,9,1,1,0,8,1,7,4,4,3,4,8),
      (1,0,6,3,1,7,8,2,3,8,0,0,1,5,7,4,6,2,5,9));
var ncOfs,tpOfs,x:word;
    tp:array[1..300] of word;  {tabulka pocetnosti}
    suc:longint;
BEGIN  {012=1. prasa, 345=2., 678=3., 9 ignoruj}
  FillChar(tp[1],SizeOf(tp),#0);
  ncOfs:=Ofs(nc)+200;
  tpOfs:=Ofs(tp);
  asm
    mov di,ncOfs        {indexovanie v poli nc}
    sub di,200
    mov cx,10000            {pocet pokusov}
  @DalsiPokus:
    mov bx,0            {indexovanie v poli tp a pocet minut}
    mov al,00000111b    {tri jednotky su tri prasiatka}
  @Znova:
    cmp al,0
    je @Hotovo
    mov ah,[di]
    inc di
    cmp di,ncOfs
    jl @Dalej
    sub di,200          {ak je koniec tabulky}
  @Dalej:
    cmp ah,9
    je @Znova           {pre ah=9 ignoruj}
    cmp ah,6
    jl @NieTretie
    xor al,00000001b     {tretie prasa}
    add bx,2
    jmp @Znova
  @NieTretie:
    cmp ah,3
    jl @NieDruhe
    xor al,00000010b      {druhe prasa}
    add bx,2
    jmp @Znova
  @NieDruhe:
    xor al,00000100b
    add bx,2
    jmp @Znova
  @Hotovo:
    inc word[tpOfs+bx]
    loopne @DalsiPokus
  end;
  suc:=0;
  for x:=1 to 300 do suc:=suc+x*tp[x];
  writeln('Priemerny cas: ',suc/10000:2:2);
END.