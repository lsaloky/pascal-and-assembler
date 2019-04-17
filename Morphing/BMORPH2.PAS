program Bezierove_krivky;
uses Graph,Crt;
const gd:integer=9;
      gm:integer=2;
      cesta='d:\bp\bgi';
      Stupen=10;           {maximalny stupen Bezierovej krivky}
      PocetBodov=5;        {stupen Bezierovej krivky. Nemen tuto konstantu!!!}
      PocetCiar=8;        {s kolkych ciar sa sklada Bezierova krivka}
      PocetSnimkov=10;     {pocet snimkov animacie}
      zdroj:array[1..PocetBodov,1..2]of integer=((300,100),(200,420),(20,220),(620,435),(190,225));
      ciel:array[1..PocetBodov,1..2] of integer=((200,20),(120,70),(420,330),(170,180),(190,225));
var x,y:integer;
    BK:array[0..PocetCiar,1..2]of integer;{pole s hodnotami bodov BK}
    Pohyb:array[1..PocetBodov,1..2] of integer;{o kolko sa pohnu body krivky pocas 1 snimku}
    KC:array[0..Stupen] of word; {kombinacne cisla}

procedure KresliKrivku(p:word);{poradie krivky:0=zdroj,PocetSnimkov=ciel}
var PD,PlusBX,nasm,PCW,BKKon,cin1,cin2:word;{pouziva ich assemblovska rutina.PD=pocet deleni}
    n,pom,pom2,c1,c2:word;{pouziva ich rutina pre vypocet riadka Pascalovho troj.}
begin
  for c1:=0 to PocetCiar do begin
    BK[c1,1]:=0;
    BK[c1,2]:=0;
  end;
  for c1:=1 to Stupen do KC[c1]:=0;
  KC[0]:=1;
  n:=PocetBodov-1;
  for c1:=1 to n do begin
    pom:=0;
    for c2:=0 to c1 do begin
      pom2:=KC[c2];
      if c2>0 then KC[c2]:=KC[c2]+pom;
      pom:=pom2;
    end;
  end;
  PlusBX:=0;
  for c1:=1 to 2 do begin
    PCW:=PocetCiar;
    BKKon:=Ofs(BK)+4*PocetCiar+PlusBX;
    cin1:=PCW;{PCW-x}
    cin2:=0;  {x}
    nasm:=n+1;
    asm {pri nasobeni sa pouziva aj register DX, ak je vysl. vacsi ako 65536}
      mov di,offset BK
      add di,PlusBX
    @DalsiBod:  {tu je navestie cyklu. Pocitame BK [x,1]}
      mov bx,0
    @DalsiClenSuctu:
      shl bx,1
      mov ax,word[offset kc+bx]
      shr bx,1
      mov cx,n  {stupen krivky v CX}
      mov PD,0
      cmp bx,n
      je @NasobCinitelom2
    @NasobCinitelom1:
      mul cin1                     {AX -> AX * (PC-x)}

      dec cx
      cmp cx,bx
      jne @NasobCinitelom1
      cmp cx,0
      je @NasobenieUkoncene
    @NasobCinitelom2:
      mul cin2
      dec cx
      jnz @NasobCinitelom2
    @NasobenieUkoncene:
      shl bx,2                     {v BX pocitame adresaciu}
      add bx,PlusBX
      push ax                      {uloz do stacku, AX potrebuje pre dalsie vypocty}
      mov ax,word[offset pohyb+bx]    {AX -> Pohyb[1,1]}
      imul p                       {AX -> AX * p (p je cislo snimku}
      add ax,word[offset zdroj+bx]    {AX -> AX * Zdroj[1,1]}
      pop dx                       {nahraj DX zo stacku}
      mul dx                       {DX:AX -> AX * DX}
      sub bx,PlusBX
      shr bx,2                     {vratit BX do pov. stavu}
      mov cx,n
    @Delenie: {nasleduje delenie}
{ ----- !!!!! tu je delenie nulou, alebo prilis malym cislom !!!!! -----}
      div PCW
      mov dx,0
      loop @Delenie
      add word[di],ax    {ulozena cast suctu do BK[x,1]}
      inc bx
      dec nasm
      jnz @DalsiClenSuctu
      mov ax,n
      inc ax
      mov nasm,ax
      dec cin1
      inc cin2
      add di,4
      cmp di,BkKon
      jle @DalsiBod
    end;
    PlusBX:=2;
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
  readln;
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