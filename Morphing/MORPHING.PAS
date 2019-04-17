program MORPHING;
Uses Graph,Crt;
const pocet=16;
      zdroj:array[1..pocet,1..4] of integer=((200,200,360,200),(360,200,400,240),(400,240,400,300),(400,300,360,340),
                                             (360,340,260,340),(260,340,260,440),(260,440,200,440),(200,440,200,200),
                                             (260,240,340,240),(340,240,360,260),(360,260,360,280),(360,280,340,300),
                                             (340,300,260,300),(260,300,260,280),(260,280,260,260),(260,260,260,240));
       ciel:array[1..pocet,1..4] of integer=((240,200,340,200),(340,200,380,240),(380,240,380,400),(380,400,340,440),
                                             (340,440,240,440),(240,440,200,400),(200,400,200,240),(200,240,240,200),
                                             (260,240,320,240),(320,240,340,260),(340,260,340,380),(340,380,320,400),
                                             (320,400,260,400),(260,400,240,380),(240,380,240,260),(240,260,260,240));
var x,y,gd,gm:integer;
    pomocne,pombak:array[1..pocet,1..4] of integer;
    kroky:word;
begin
  gd:=9;gm:=2;kroky:=60;
  initgraph(gd,gm,'d:\bp\bgi');ClearDevice;
  move(zdroj,pomocne,sizeof(pomocne));
  move(zdroj,pombak,sizeof(pombak));
  for x:=1 to kroky+1 do begin
    setcolor(0);
    for y:=1 to pocet do line(pombak[y,1],pombak[y,2],pombak[y,3],pombak[y,4]);
    setcolor(white);
    for y:=1 to pocet do line(pomocne[y,1],pomocne[y,2],pomocne[y,3],pomocne[y,4]);
    delay(20);
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