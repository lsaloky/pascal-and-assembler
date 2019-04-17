program Generovanie_nahodnych_cisel_pre_assembler;
uses Graph;
const gd:integer=1;
      gm:integer=2;
      cesta='d:\bp\bgi';
var nc:word;                    {nahodne cislo}
    h:array[0..255] of byte;    {pocetnost nahodnych cisel}
    min:byte;
    x,y:word;
procedure Metoda1;
begin
  nc:=253;             {druha mocnina cisla [byte] sa rozlozi:}
                       {dolny byte Lo(x) sluzi na dalsie generovanie}
  repeat               {horny byte Hi(x) je vysledne nahodne cislo}
    nc:=nc*nc;
    Dec(h[Hi(nc)]);
    if h[Hi(nc)]<min then Dec(min);
    PutPixel(Hi(nc),h[Hi(nc)],1);
    {tu je este zachovale Hi(nc)}
    if Lo(nc)<16 then nc:=Hi(nc)*3+13;
    nc:=nc and $00FF;
  until min=0;
  readln;
end;
procedure Metoda2;
const tab:array[1..10,1..20] of byte=
     ((8,5,1,4,9,5,7,5,0,4,1,5,0,5,9,3,6,8,4,9),
      (3,5,2,2,9,7,2,8,3,7,3,6,7,5,2,7,1,6,5,5),
      (4,0,1,1,7,2,4,3,4,6,3,2,1,8,9,8,7,0,7,4),
      (6,0,8,7,5,9,7,5,4,5,6,8,6,5,2,9,2,1,6,0),
      (0,3,7,6,9,3,2,5,5,1,7,4,8,0,1,4,1,6,9,2),
      (9,4,0,7,7,9,2,2,0,9,3,1,5,0,6,6,9,6,0,6),
      (8,4,3,7,6,0,0,6,6,6,9,4,1,4,5,2,2,3,9,9),
      (2,4,3,5,4,1,1,3,4,7,9,0,9,2,0,0,3,8,6,4),
      (8,1,1,4,9,4,3,2,9,1,1,0,8,1,7,4,4,3,4,8),
      (1,0,6,3,1,7,8,2,3,8,0,0,1,5,7,4,6,2,5,9));
begin
  x:=1;y:=1;
  repeat
    nc:=tab[x,y]*10+tab[x+1,y];
    Dec(h[nc]);
    if h[nc]<min then Dec(min);
    PutPixel(nc,h[nc],1);
    Inc(y);
    if y=20 then begin
      y:=1;
      Inc(x);
    end;
    if x=10 then x:=1;
  until min=0;
end;

BEGIN
  InitGraph(gd,gm,cesta);
  for x:=0 to 255 do h[x]:=199;
  min:=199;
 {Metoda1;}
  Metoda2;
END.



