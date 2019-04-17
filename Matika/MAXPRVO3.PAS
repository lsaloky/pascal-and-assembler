program Najvacsie_prvocislo;{vypise 2^44497-1 do suboru za 180 sekund}
const presnost=13500;
var f:text;
    x,y,mocnina,index,zac,kon:word;
    op:array[1..presnost] of byte;
BEGIN
  Assign(f,'maxprvoc.txt');
  Rewrite(f);
  mocnina:=44497;
  for x:=1 to presnost do op[x]:=0;
  op[presnost]:=1;
  zac:=ofs(op[1])-ofs(x);
  kon:=zac+presnost;
  index:=kon-1;
  asm
    mov ax,1
  @fory:
    mov bx,index       {instrukcia sa vykonava 44497 krat}
  @forx:
    mov cx,[x+bx-1]    {44497*13395/2=298.018.657}
    shl ch,1           {298.018.657}
    cmp ch,9           {298.018.657}
    jbe @incx          {298.018.657}
    cmp bx,index       {149.009.328 - len pri preteceni, ktoreho pravdepodobnost je 50%}
    jne @nie           {149.009.328}
    dec index          {13.394 - ak sa zvysil pocet cislic}
  @nie:
    sub ch,10          {148.995.934 - ak sa nezvysil pocet cislic}
    inc cl             {148.995.934}
  @incx:
    mov [x+bx-1],cx    {298.018.657}
    inc bx             {298.018.657}
    cmp bx,kon         {298.018.657}
    jb @forx           {298.018.657}
    inc ax             {44.497}
    cmp ax,mocnina     {44.497}
    jbe @fory          {44.497}
  end;                 {spolu instrukcii:2.980.351.162, 16.557.506 instr. /s}
  op[presnost]:=op[presnost]-1;
  y:=1;
  while op[y]=0 do Inc(y);
  for x:=y to presnost do write(f,op[x]);
  Close(f);
END.