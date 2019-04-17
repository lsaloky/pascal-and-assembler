program Bezierove_krivky;
uses Graph,Crt;
const gd:integer=9;
      gm:integer=2;
      cesta='d:\bp\bgi';
      Stupen=10;           {maximalny stupen Bezierovej krivky}
      PocetBodov=4;        {stupen Bezierovej krivky. Nemen tuto konstantu!!!}
      PocetCiar=20;        {s kolkych ciar sa sklada Bezierova krivka}
      PocetSnimkov=50;     {pocet snimkov animacie}
      zdroj:array[1..PocetBodov,1..2]of integer=((300,100),(200,420),(20,220),(620,435));
      ciel:array[1..PocetBodov,1..2] of integer=((200,20),(120,70),(420,330),(170,180));
var x,y:integer;
    BK:array[0..PocetCiar,1..2]of integer;{pole s hodnotami bodov BK}
    Pohyb:array[1..PocetBodov,1..2] of integer;{o kolko sa pohnu body krivky pocas 1 snimku}

procedure KresliKrivku(p:word);{poradie krivky:0=zdroj,PocetSnimkov=ciel}
var PCW,PCW3,BKKon:word;{pouziva ich assemblovska rutina}
    n,pom,pom2,c1,c2:word;{pouziva ich rutina pre vypocet riadka Pascalovho troj.}
    KC:array[0..Stupen] of word; {kombinacne cisla}
begin
  KC[0]:=1;
  n:=7;
  for c1:=1 to n do begin
    pom:=0;
    for c2:=0 to x do begin
      pom2:=KC[c2];
      if y>0 then KC[c2]:=KC[c2]+pom;
      pom:=pom2;
    end;
  end;
  PCW:=PocetCiar;
  PCW3:=PCW*PCW*PCW;  {PocetCiar^3}
  BKKon:=Ofs(BK)+4*PocetCiar;
  asm {pri nasobeni sa pouziva aj register DX, ak je vysl. vacsi ako 65536}
    mov di,offset BK
    mov bx,PCW        {  BX - 2. cinitel sa rovna PC-x}
    mov cx,0          {  CX - 2. cinitel sa rovna x}
  @DalsiBod:  {tu je navestie cyklu. Pocitame BK [x,1]}
    mov ax,bx                    {PC-x -> AX}
    mul bx                       {AX -> AX * (PC-x)}
    mul bx                       {AX -> AX * (PC-x)}
    push ax                      {uloz do stacku, AX potrebuje pre dalsie vypocty}
    mov ax,word[offset pohyb]    {AX -> Pohyb[1,1]}
    imul p                       {AX -> AX * p (p je cislo snimku}
    add ax,word[offset zdroj]    {AX -> AX * Zdroj[1,1]}
    pop dx                       {nahraj DX zo stacku}
    mul dx                       {DX:AX -> AX * DX}
    div PCW3                     {DX:AX -> DX:AX / PCW3}
    mov dx,0                     {zlikviduj zvysok po deleni}
{v Pascale: ((PC-x)*(PC-x)*(PC-x)*(Pohyb[1,1]*p+Zdroj[1,1])) div PCW3}
    mov word[di],ax    {ulozena cast suctu do BK[x,1]}
    mov ax,bx
    mul bx
    mul cx
    mul word ptr KC
    push ax
    mov ax,word[offset pohyb+4]
    imul p
    add ax,word[offset zdroj+4]
    pop dx
    mul dx
    div PCW3
    mov dx,0
    add word[di],ax     {pripocitana 2. cast suctu k BK[x,1]}
    mov ax,bx
    mul cx
    mul cx
    mul word ptr KC
    push ax
    mov ax,word[offset pohyb+8]
    imul p
    add ax,word[offset zdroj+8]
    pop dx
    mul dx
    div PCW3
    mov dx,0
    add word[di],ax      {pripocitana 3. cast suctu k BK[x,1]}
    mov ax,cx
    mul cx
    mul cx
    push ax
    mov ax,word[offset pohyb+12]
    imul p
    add ax,word[offset zdroj+12]
    pop dx
    mul dx
    div PCW3
    mov dx,0
    add word[di],ax       {huh, uz je spravny vysledok v BK[x,1]}
    add di,2              {pocitame BK[x,2]}
    mov ax,bx
    mul bx
    mul bx
    push ax
    mov ax,word[offset pohyb+2]
    imul p
    add ax,word[offset zdroj+2]
    pop dx
    mul dx
    div PCW3
    mov dx,0
    mov word[di],ax        {ulozena cast suctu do BK[x,2]}
    mov ax,bx
    mul bx
    mul cx
    mul word ptr KC
    push ax
    mov ax,word[offset pohyb+6]
    imul p
    add ax,word[offset zdroj+6]
    pop dx
    mul dx
    div PCW3
    mov dx,0
    add word[di],ax         {pripocitana 2. cast suctu k BK[x,2]}
    mov ax,bx
    mul cx
    mul cx
    mul word ptr KC
    push ax
    mov ax,word[offset pohyb+10]
    imul p
    add ax,word[offset zdroj+10]
    pop dx
    mul dx
    div PCW3
    mov dx,0
    add word[di],ax          {pripocitana 3. cast suctu k BK[x,2]}
    mov ax,cx
    mul cx
    mul cx
    push ax
    mov ax,word[offset pohyb+14]
    imul p
    add ax,word[offset zdroj+14]
    pop dx
    mul dx
    div PCW3
    mov dx,0
    add word[di],ax           {huh, uz je spravny vysledok v BK[x,2]}
    inc cx
    dec bx
    add di,2
    cmp di,BKKon
    jle @DalsiBod
  end;
  for x:=2 to PocetCiar do LineTo(BK[x,1],BK[x,2]);
end;
BEGIN
  for x:=1 to PocetBodov do begin
    Pohyb[x,1]:=(ciel[x,1]-zdroj[x,1]) div PocetSnimkov;
    Pohyb[x,2]:=(ciel[x,2]-zdroj[x,2]) div PocetSnimkov;
  end;
  initgraph(gd,gm,'d:\bp\bgi');
  SetColor(15);
  MoveTo(zdroj[1,1],zdroj[1,2]);
  KresliKrivku(0);
  for y:=1 to PocetSnimkov do begin
    SetColor(0);
    MoveTo(zdroj[1,1]+(y-1)*Pohyb[1,1],zdroj[1,2]+(y-1)*Pohyb[1,2]);
    KresliKrivku(y-1);
    MoveTo(zdroj[1,1]+y*Pohyb[1,1],zdroj[1,2]+y*Pohyb[1,2]);
    SetColor(15);
    KresliKrivku(y);
    Delay(50);
  end;
  readln;
END.