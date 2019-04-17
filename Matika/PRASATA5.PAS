program Tri_prasiatka_a_assembler_a_velke_prvocislo;
uses Dos;
const PocetPokusov:word=100;
var ncOfs,tpOfs:word;
    tp:array[1..300] of word;  {tabulka pocetnosti}
    suc,x:longint;
    nc:array[1..13395] of byte;
    f:file;
    hod,min,sec,stot:word;
    time:real;

BEGIN  {012=1. prasa, 345=2., 678=3., 9 ignoruj}
  Assign(f,'prv13395.txt');
  Reset(f,13395);
  BlockRead(f,nc,1);
  Close(f);
  for x:=1 to 13395 do nc[x]:=nc[x]-48;
  for x:=1 to 300 do tp[x]:=0;
  ncOfs:=Ofs(nc)+13395;
  tpOfs:=Ofs(tp);
  GetTime(hod,min,sec,stot);
  time:=hod*3600+min*60+sec+stot/100;
  asm
    mov di,ncOfs        {indexovanie v poli nc}
    sub di,13395
    mov cx,PocetPokusov            {pocet pokusov}
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
    sub di,13395          {ak je koniec tabulky}
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
  GetTime(hod,min,sec,stot);
  time:=hod*3600+min*60+sec+stot/100-time;
  writeln('Pocet pokusov ',PocetPokusov);
  writeln('Prasata pobehovali ',suc,' minut.');
  writeln('Priemerny cas: ',suc/PocetPokusov:2:2);
  writeln('Cas vypoctu: ',time:0:2,' sekundy.');
  readln;
END.