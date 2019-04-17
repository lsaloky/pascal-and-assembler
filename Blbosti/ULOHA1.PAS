program uloha1;
uses Crt;
const data:array[1..6,1..3] of integer=((1,1,60),(1,2,55),(1,3,70),(2,4,35),(3,4,33),(2,6,50));
var dvoj:array[1..100,1..2] of integer;
    pom:array[1..1000,1..3] of integer;
    x,q,y,z,t,u,v,min,index,pom1:integer;
    UzBolo:boolean;
begin
ClrScr;
for x:=1 to 30 do
  for y:=1 to 3 do
    pom[x,y]:=32000;

move(data,pom,sizeof(data));
z:=sizeof(data) div 6+1;
for x:=1 to z-1 do                      {prehladava vsetky trojice}
  if pom[x,3]>49 then                   {a vytvara nove trojice takym spo-}
    for y:=1 to z-1 do                  {sobom, ze to, co patri podniku B,}
      if pom[y,1]=pom[x,2] then         {patri aj podniku A,ak A kontro-}
                                        {luje B.          Dalsi cyklus}
        for t:=1 to z-1 do              {zistuje, ci A cez ine podniky}
                                        {nekontroluje to, co patri podniku}
          if (pom[t,1]=pom[x,1]) and (pom[t,2]=pom[y,2]) then pom[t,3]:=pom[t,3]+pom[y,3]
          else begin
            pom[z,1]:=pom[x,1];             {B, a ak ano, scita sa pocet per-}
            pom[z,2]:=pom[y,2];             {cent kontrolovanych cez B s poc-}
            pom[z,3]:=pom[y,3];             {tom percent doterajsieho vlast-}
            inc(z);                         {nictva}
          end;
u:=1;
for x:=1 to z-1 do                      {Horepopisanym algoritmom moze vzniknut}
  if pom[x,3]>49 then                   {viacero zhodnych trojic v poli POM,}
    begin
      UzBolo:=false;                    {preto sa teraz trojice, kazda v jed-}
      for v:=1 to x-1 do                {nom exemplari, presunu do pola DVOJ.}
        if (pom[x,1]=pom[v,1]) and (pom[x,2]=pom[v,2]) then UzBolo:=true;
      if UzBolo=false then
      begin
        dvoj[u,1]:=pom[x,1];
        dvoj[u,2]:=pom[x,2];
        inc(u);
      end;
    end;
min:=32100;q:=1;x:=1;
for q:=1 to u-2 do begin                      {triedenie}
  for x:=q to u-2 do begin
    if dvoj[x,1]>dvoj[x+1,1] then begin
      pom1:=dvoj[x+1,1];
      dvoj[x+1,1]:=dvoj[x,1];
      dvoj[x,1]:=pom1;
      pom1:=dvoj[x+1,2];
      dvoj[x+1,2]:=dvoj[x,2];
      dvoj[x,2]:=pom1;
    end;
  end;
end;
for x:=1 to u-1 do writeln(dvoj[x,1],' vlastn¡ ',dvoj[x,2]);
repeat until keypressed;
end.