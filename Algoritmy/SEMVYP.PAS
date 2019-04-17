program Semienkove_vyplnovanie; { obycajne aj riadkove }
uses MainGr;
procedure VyplnPrim(x,y:word;FVyplne:byte);
var FPom:byte;
begin
  CakajNaVOI;
  PolozBod(x,y,FVyplne);
  if ZistiBod(x+1,y) <>FVyplne then
    VyplnPrim(x+1,y,FVyplne);
  if ZistiBod(x,y+1) <>FVyplne then
    VyplnPrim(x,y+1,FVyplne);
  if ZistiBod(x-1,y) <>FVyplne then
    VyplnPrim(x-1,y,FVyplne);
  if ZistiBod(x,y-1) <>FVyplne then
    VyplnPrim(x,y-1,FVyplne);
end;
procedure Vypln(x,y:word;FVyplne:byte);
var Min,Max,i:word;
    Bolo:boolean;
begin
  Min:=x;
  while (ZistiBod(Min,y)<>FVyplne) and (Min>0) do Dec(Min);
  Max:=x;
  while (ZistiBod(Max,y)<>FVyplne) and (Max<319) do Inc(Max);
  Color:=FVyplne;
  CiaraVodorovna(Min+1,y,Max-Min-1);
  CakajNaVOI;
  Bolo:=False;
  for i:=Min+1 to Max-1 do begin
    if ZistiBod(i,y+1)<>FVyplne then
      Vypln(i,y+1,FVyplne);
    if ZistiBod(i,y-1)<>FVyplne then
      Vypln(i,y-1,FVyplne);
  end;
end;
BEGIN
  InicializujGrafiku;
  Color:=31;
  Ciara(10,40,110,45);
  Ciara(110,45,120,80);
  Ciara(120,80,40,60);
  Ciara(40,60,10,40);
  VyplnPrim(40,45,31);
  Ciara(210,20,260,40);
  Ciara(260,40,310,10);
  Ciara(310,10,280,90);
  Ciara(280,90,230,80);
  Ciara(230,80,200,100);
  Ciara(200,100,210,20);
  Vypln(240,50,31);
  ReadLn;
  ZavriGrafiku;
END.