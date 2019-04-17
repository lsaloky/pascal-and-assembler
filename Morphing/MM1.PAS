program EditujMorphing;
uses Graph,Crt;
const gd:integer=9;    {graficky driver a mod}
      gm:integer=2;
      mrx=35;          {konstanty mriezky}
      mry=35;
      zacx=120;
      zacy=10;
      pocx=10;
      pocy=12;
      pocciar=35;       {maximalny pocet ciar na jeden objekt}
      kroky=100;         {pocet snimkov v morfingu}
      rychlost=40;      {rychlost morphingu}
type pole=array[1..pocciar,1..4] of integer;
var x,y,x1,y1,x2,y2:word;   {kreslenie v editore}
    index:word;             {aktualny index pola}
    p:pointer;              {kurzor - ukazatel na dynamicku pamat}
    ch:char;                {obsluha klavesnice}
    a1,a2,pom1,pom2:pole;   {morfujuce objekty v pamati}
    subor:file of pole;     {morfujuce objekty na disku}

procedure Prepocitaj;        {Prepocitaj suradnice pri pohybe kurzora}
begin
  if ch='1' then begin
    x:=x-mrx;
    y:=y+mrx;
  end;
  if ch='2' then y:=y+mry;
  if ch='3' then begin
    x:=x+mrx;
    y:=y+mry;
  end;
  if ch='4' then x:=x-mrx;
  if ch='6' then x:=x+mrx;
  if ch='7' then begin
    x:=x-mrx;
    y:=y-mry;
  end;
  if ch='8' then y:=y-mry;
  if ch='9' then begin
    x:=x+mrx;
    y:=y-mry;
  end;
end;

procedure Error(a:word);          {zoznam chybovych hlaseni}
begin
  case a of
    1:begin
        Writeln('Prekrocil si maximalny povoleny pocet ciar!!!');
        Readln;
      end;
  end;
end;

procedure Presun;                {presuvaj kurzor}
begin
  repeat
    repeat
      PutImage(x-5,y-5,p^,XORPut);
      Delay(30);
      PutImage(x-5,y-5,p^,XORPut);
      Delay(30);
    until keypressed;
    ch:=ReadKey;
    Prepocitaj;
  until (ch='5') or (ch='q');
  Sound(2750);
  Delay(200);
  NoSound;
end;

BEGIN
  InitGraph(gd,gm,'d:\bp\bgi');        {inicializacia grafiky}
  Circle(5,5,5);
  GetMem(p,ImageSize(0,0,10,10));
  GetImage(0,0,10,10,p^);
  SetColor(0);Circle(5,5,5);
  SetColor(7);                         {mriezka}
  for y:=0 to pocy do Line(zacx,y*mry+zacy,zacx+pocx*mrx,y*mry+zacy);
  for x:=0 to pocx do Line(x*mrx+zacx,zacy,x*mrx+zacx,zacy+pocy*mry);
  Assign(subor,'morph.dat');           {inicializacia suboru}
  Rewrite(subor);    {pozor na Rewrite}
 { read(subor,a1);
  read(subor,a2);  }
  MoveTo(zacx,zacy);
  x:=zacx;                             {inicializacia premennych}
  y:=zacy;
  x1:=zacx;
  y1:=zacy;
  index:=1;
  repeat                               {editor}
    Presun;                            {prva ciara}
    x1:=x;y1:=y;
    SetColor(9);
    Presun;
    a1[index,1]:=x1;
    a1[index,2]:=y1;
    a1[index,3]:=x;
    a1[index,4]:=y;
    Line(x1,y1,x,y);
    SetColor(10);                       {druha ciara}
    Presun;
    x2:=x;y2:=y;
    Presun;
    a2[index,1]:=x2;
    a2[index,2]:=y2;
    a2[index,3]:=x;
    a2[index,4]:=y;
    Line(x2,y2,x,y);
    ch:=readkey;
    if ch='.' then Dec(index);           {mazanie poslednej ciary}
    if index<pocciar then Inc(index)     {zmazana ciara zostava na obrazovke}
                     else Error(1);
  until ch='q';
  write(subor,a1);
  write(subor,a2);
(*  index:=4;     {pozor!!!}
  Line(a1[1,1],a1[1,2],a1[1,3],a1[1,4]);
  SetColor(10);
  Line(a2[1,1],a2[1,2],a2[1,3],a1[1,4]);*)
  repeat
    for x:=1 to kroky+1 do begin          {morfovaci algoritmus}
      setcolor(0);
      for y:=1 to index-1 do line(pom2[y,1],pom2[y,2],pom2[y,3],pom2[y,4]);
      setcolor(magenta);
      for y:=1 to index-1 do line(pom1[y,1],pom1[y,2],pom1[y,3],pom1[y,4]);
      Delay(rychlost);
      move(pom1,pom2,sizeof(pom1));
      for y:=1 to index-1 do begin
        pom1[y,1]:=a1[y,1]+((a2[y,1]-a1[y,1])*x) div kroky;
        pom1[y,2]:=a1[y,2]+((a2[y,2]-a1[y,2])*x) div kroky;
        pom1[y,3]:=a1[y,3]+((a2[y,3]-a1[y,3])*x) div kroky;
        pom1[y,4]:=a1[y,4]+((a2[y,4]-a1[y,4])*x) div kroky;
      end;
    end;
  until keypressed;
  CloseGraph;
  Writeln('Mukosoft MorfEdit verzia 1.0');
  Writeln('Lubos Saloky, 1995');
END.