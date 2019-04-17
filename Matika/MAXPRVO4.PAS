program Najvacsie_prvocislo;{vypise 2^216091-1 do suboru za asi 75 min}
uses Dos;
const presnost=65500;
      mocnina=216091;
var f:text;
    x,y,index,lh,ll,cmpax,cmpdx,hod,min,sec,s100:word;
      {mocnina:32 bitov v DX,DL,AH,AL}
    p:pointer;
    l:longint;
BEGIN
  for x:=1 to 24 do writeln;
  GetTime(hod,min,sec,s100);
  writeln('Zaciatok vypoctu o ',hod,':',min,':',sec,'.',s100);
  writeln('Cakaj, pocitam...');
  Assign(f,'maxprvoc.txt');
  Rewrite(f);
  GetMem(p,65500);
  l:=Longint(p);
  lh:=l div 65536;
  ll:=l mod 65536;
  for x:=1 to presnost-1 do Mem[lh:ll+x-1]:=0;
  Mem[lh:ll+presnost-1]:=1;
  cmpax:=mocnina mod 65536;
  cmpdx:=mocnina div 65536;
  index:=presnost-1;
  asm
    mov es,[lh]
    mov di,[ll]
    mov ax,1
    mov dx,0
  @fory:
    mov bx,index        {instrukcia sa vykona 216.091 krat}
  @forx:
    mov cx,[es:di+bx-1] {216091*65050/2=7.028.359.775}
    shl ch,1            {7.028.359.775}
    cmp ch,9            {7.028.359.775}
    jbe @incx           {7.028.359.775}
    cmp bx,index        {3.514.179.887 - len pri preteceni}
    jne @nie            {3.514.179.887}
    dec index           {65.050}
  @nie:
    sub ch,10           {3.514.114.837 - ak sa nezvysil pocet cislic}
    inc cl              {3.514.114.837}
  @incx:
    mov [es:di+bx-1],cx {7.028.359.775}
    inc bx              {7.028.359.775}
    cmp bx,presnost     {7.028.359.775}
    jb @forx            {7.028.359.775}
    inc ax              {216.091}
    cmp ax,0            {216.091}
    jne @NezvysujDX     {216.091}
    inc dx              {2}
  @NezvysujDX:
    cmp dx,cmpdx        {216.091}
    jb @fory            {216.091}
    cmp ax,cmpax        {19.483}
    jbe @fory           {19.483}
  end;         {70.284.868.222 instrukcii za 4811 sekund=14.609.201 instr./s}
  Dec(Mem[lh:ll+presnost-1]);
  y:=1;
  while Mem[lh:ll+y-1]=0 do Inc(y);
  for x:=y to presnost do write(f,Mem[lh:ll+x-1]);
  Close(f);
  FreeMem(p,65500);
  GetTime(hod,min,sec,s100);
  writeln('Koniec vypoctu o ',hod,':',min,':',sec,'.',s100);
END.