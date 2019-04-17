program PrezerajMorphing;
uses Graph,Crt,Dos;
const gd:integer=9;      {graficky driver a mod}
      gm:integer=2;
      kroky=50;          {pocet snimkov v morfingu}
      rychlost=10;       {rychlost morphingu}
      pocciar=35;
      pomer=2;           {ak vacsi ako 1, tak sa zmensi obrazok}
type pole=array[1..pocciar,1..4] of integer;
     anim=array[1..kroky,1..pocciar,1..4] of integer;
var x,y:word;            {pomocne premenne}
    size:longint;        {dlzka datoveho suboru}
    p:^anim;             {uvolni sa dynamicka pamat pre animaciu}
    a1,a2:pole;          {morfujuce objekty v pamati}
    s:string;
    subor:file of pole;  {morfujuce objekty na disku}
    DirInfo:SearchRec;

BEGIN
  if kroky*pocciar*8>65528 then begin
    writeln('Nie je dostatok pamate!!!');
    exit;
  end;
  GetMem(p,kroky*pocciar*8);              {vezmi pamat}
  writeln('Pocet ciar je nastaveny na ',pocciar);
  writeln('Pripustna dlzka datoveho suboru:',pocciar*16);
  writeln('Mas tieto datove subory:');
  FindFirst('*.dat',AnyFile,DirInfo);
  Writeln(DirInfo.Name,' dlzka: ',Dirinfo.Size);
  while DosError=0 do begin
    FindNext(DirInfo);
    Writeln(DirInfo.Name,' dlzka: ',Dirinfo.Size);
  end;
  write('Zadaj nazov:');
  readln(s);
  Assign(subor,s);           {inicializacia suboru}
  Reset(subor);
  read(subor,a1);
  read(subor,a2);
  Close(subor);
  InitGraph(gd,gm,'d:\bp\bgi');          {inicializacia grafiky}
  for x:=1 to kroky do begin             {vypocet morphingu}
    for y:=1 to pocciar do begin
      p^[x,y,1]:=(a1[y,1]+((a2[y,1]-a1[y,1])*x) div kroky) div pomer;
      p^[x,y,2]:=(a1[y,2]+((a2[y,2]-a1[y,2])*x) div kroky) div pomer;
      p^[x,y,3]:=(a1[y,3]+((a2[y,3]-a1[y,3])*x) div kroky) div pomer;
      p^[x,y,4]:=(a1[y,4]+((a2[y,4]-a1[y,4])*x) div kroky) div pomer;
    end;
  end;
  repeat
    for x:=1 to kroky do begin          {morfovaci algoritmus}
      setcolor(black);
      if x>1 then for y:=1 to pocciar do line(p^[x-1,y,1],p^[x-1,y,2],p^[x-1,y,3],p^[x-1,y,4]);
      setcolor(white);
      for y:=1 to pocciar do line(p^[x,y,1],p^[x,y,2],p^[x,y,3],p^[x,y,4]);
      Delay(rychlost);
    end;
    for x:=kroky downto 1 do begin
      setcolor(black);
      if x<kroky then for y:=1 to pocciar do line(p^[x+1,y,1],p^[x+1,y,2],p^[x+1,y,3],p^[x+1,y,4]);
      setcolor(white);
      for y:=1 to pocciar do line(p^[x,y,1],p^[x,y,2],p^[x,y,3],p^[x,y,4]);
      Delay(rychlost);
    end;
  until keypressed;
END.