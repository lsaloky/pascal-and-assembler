program Bezierove_krivky;
uses Graph;
const gd:integer=9;
      gm:integer=2;
      cesta='d:\bp\bgi';
      PocetBodov=4;
      PocetCiar=20;   {pocet ciar z intervalu 0,40}
      zdroj:array[1..PocetBodov,1..2]of word=((300,100),(200,420),(20,220),(620,435));
var x:word;
    BK:array[0..PocetCiar,1..2] of word; {body krivky}
    PCW,PCW3,BKKon,KC:word;  {KC bude kombinacne cislo}

BEGIN
  PCW:=PocetCiar;
  PCW3:=PCW*PCW*PCW;
  BKKon:=Ofs(BK)+4*PocetCiar;
  KC:=3;
  InitGraph(gd,gm,cesta);
  MoveTo(zdroj[1,1],zdroj[1,2]);
  asm {pri nasobeni sa pouziva aj register DX, ak je vysl. vacsi ako 65536}
    mov di,offset BK
    mov bx,PCW        {  BX - 2. cinitel sa rovna PC-x}
    mov cx,0          {  CX - 2. cinitel sa rovna x}
  @DalsiBod:  {tu je navestie cyklu. Pocitame BK [x,1]}
    mov ax,bx
    mul bx
    mul bx
    mul word[offset zdroj]
    div PCW3
    mov dx,0           {zlikviduj zvysok po deleni}
    mov word[di],ax    {ulozena cast suctu do BK[x,1]}
    mov ax,bx
    mul bx
    mul cx
    mul KC
    mul word[offset zdroj+4]
    div PCW3
    mov dx,0
    add word[di],ax     {pripocitana 2. cast suctu k BK[x,1]}
    mov ax,bx
    mul cx
    mul cx
    mul KC
    mul word[offset zdroj+8]
    div PCW3
    mov dx,0
    add word[di],ax      {pripocitana 3. cast suctu k BK[x,1]}
    mov ax,cx
    mul cx
    mul cx
    mul word[offset zdroj+12]
    div PCW3
    mov dx,0
    add word[di],ax       {huh, uz je spravny vysledok v BK[x,1]}
    add di,2              {pocitame BK[x,2]}
    mov ax,bx
    mul bx
    mul bx
    mul word[offset zdroj+2]
    div PCW3
    mov dx,0
    mov word[di],ax        {ulozena cast suctu do BK[x,2]}
    mov ax,bx
    mul bx
    mul cx
    mul KC
    mul word[offset zdroj+6]
    div PCW3
    mov dx,0
    add word[di],ax         {pripocitana 2. cast suctu k BK[x,2]}
    mov ax,bx
    mul cx
    mul cx
    mul KC
    mul word[offset zdroj+10]
    div PCW3
    mov dx,0
    add word[di],ax          {pripocitana 3. cast suctu k BK[x,2]}
    mov ax,cx
    mul cx
    mul cx
    mul word[offset zdroj+14]
    div PCW3
    mov dx,0
    add word[di],ax           {huh, uz je spravny vysledok v BK[x,2]}
    inc cx
    dec bx
    add di,2
    cmp di,BKKon
    jle @DalsiBod
  end;

  { ----- toto bolo nahradene assemblovskou rutinou -----
  for x:=0 to PC do begin
    BK[x,1]:=(((PC-x)*(PC-x)*(PC-x) div PC)*zdroj[1,1]) div PC div PC
     +3*(((PC-x)*(PC-x)*x) div PC*zdroj[2,1]) div PC div PC
     +3*(((PC-x)*x*x) div PC*zdroj[3,1]) div PC div PC
     +((x*x*x) div PC*zdroj[4,1]) div PC div PC;
    BK[x,2]:=(((PC-x)*(PC-x)*(PC-x) div PC)*zdroj[1,2]) div PC div PC
     +3*(((PC-x)*(PC-x)*x) div PC*zdroj[2,2]) div PC div PC
     +3*(((PC-x)*x*x) div PC*zdroj[3,2]) div PC div PC
     +((x*x*x) div PC*zdroj[4,2]) div PC div PC;
  end;}
  for x:=0 to PCW do LineTo(BK[x,1],BK[x,2]);
  readln;
  CloseGraph;
  WriteLn('MukoSoft B‚zierove krivky'#13#10'Lubos Saloky, 1996');
END.
