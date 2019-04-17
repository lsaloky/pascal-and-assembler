program Demo;
uses Graph,Crt;
const pocet=11;
      kroky=90;
      zdroj:array[1..pocet,1..4] of integer=((30,0,50,0),(50,0,50,90),(50,90,50,110),(50,110,60,120),
                                             (60,120,20,120),(20,120,30,110),(30,110,30,40),(30,40,0,40),
                                             (0,40,0,30),(0,30,20,20),(20,20,30,0));
       ciel:array[1..pocet,1..4] of integer=((30,0,50,0),(50,0,50,100),(50,100,100,100),(100,100,100,120),
                                             (100,120,30,120),(30,120,30,110),(30,110,30,60),(30,60,30,40),
                                             (30,40,30,30),(30,30,30,20),(30,20,30,0));
var x,y,gd,gm:integer;
    pomocne,pombak:array[1..pocet,1..4] of integer;
begin
  gd:=9;gm:=2;
  initgraph(gd,gm,'d:\bp\bgi');ClearDevice;
  move(zdroj,pomocne,sizeof(pomocne));
  move(zdroj,pombak,sizeof(pombak));
  for x:=1 to kroky+1 do begin
    setcolor(0);
    for y:=1 to pocet do line(pombak[y,1]*2,pombak[y,2]*2,pombak[y,3]*2,pombak[y,4]*2);
    setcolor(white);
    for y:=1 to pocet do line(pomocne[y,1]*2,pomocne[y,2]*2,pomocne[y,3]*2,pomocne[y,4]*2);
    delay(10);
    move(pomocne,pombak,sizeof(pomocne));
    for y:=1 to pocet do begin
      pomocne[y,1]:=zdroj[y,1]+((ciel[y,1]-zdroj[y,1])*x) div kroky;
      pomocne[y,2]:=zdroj[y,2]+((ciel[y,2]-zdroj[y,2])*x) div kroky;
      pomocne[y,3]:=zdroj[y,3]+((ciel[y,3]-zdroj[y,3])*x) div kroky;
      pomocne[y,4]:=zdroj[y,4]+((ciel[y,4]-zdroj[y,4])*x) div kroky;
    end;
  end;
  readln;
  CloseGraph;
end.