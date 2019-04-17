program Najvacsie_prvocislo;{vypise 2^44497-1 do suboru za 59 sekund na DX2/66}
uses Dos;
const presnost=13500;
type TStruktura=record
       op:array[0..presnost] of byte;
       mocnina:word;
     end;
var p:^TStruktura;
    f:text;
    x,y,hod,min,sec,s100:word;
    time:real;
BEGIN
  GetMem(p,65528);
  Assign(f,'maxprvo3.txt');
  Rewrite(f);
  p^.mocnina:=44497;
  GetTime(hod,min,sec,s100);
  time:=hod*3600.0+min*60+sec+s100/100;
  asm        {cislice sa spracuvaju po dvojiciach}
    push ds
    mov ax,word ptr p+2
    mov ds,ax
    mov bx,presnost
    mov di,bx
    mov byte [di],$01
    dec di
  @vyplnuj:
    mov byte [di],$00  {instrukcia sa vykonava 13500 krat}
    dec di             {13.500}
    cmp di,0           {13.500}
    jge @vyplnuj       {13.500}
    mov ax,1
    dec bx
  @fory:
    mov di,bx          {44.497}
  @forx:
    mov cx,[di]        {44497*13395/2/2=149.009.328}
    shl cl,1           {149.009.328}
    cmp cl,9           {149.009.328}
    jbe @incx          {149.009.328}
    sub cl,10          {74.604.664 - len pri preteceni, ktoreho pravdepodobnost je 50%}
    inc byte[di-1]     {74.604.664}
    cmp di,bx          {74.604.664}
    jne @incx          {74.604.664}
    sub bx,2           {6.697 - ak sa zvysil pocet cislic o cislicu s nep rnym r dom}
  @incx:
    shl ch,1           {149.009.328}
    cmp ch,9           {149.009.328}
    jbe @incx2         {149.009.328}
    sub ch,10          {74.604.664 - len pri preteceni, ktoreho pravdepodobnost je 50%}
    inc cl             {74.604.664}
  @incx2:
    mov [di],cx        {149.009.328}
    add di,2           {149.009.328}
    cmp di,presnost    {149.009.328}
    jb @forx           {149.009.328}
    inc ax             {44.497}
    cmp ax,word[presnost+1]{44.497}
    jbe @fory          {44.497}
    pop ds
  end;                 {spolu instrukcii:2.086.969.277, 35.211.224 instr. /s}
  GetTime(hod,min,sec,s100);
  time:=hod*3600.0+min*60+sec+s100/100-time;
  writeln('Cas vypoctu: ',time:0:5);
  p^.op[presnost]:=p^.op[presnost]-1;
  y:=1;
  while p^.op[y]=0 do Inc(y);
  for x:=y to presnost do write(f,p^.op[x]);
  Close(f);
  FreeMem(p,65528);
END.