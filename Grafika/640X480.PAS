program Praca_v_640x480;
uses Graph;
{$I 640x480.inc}
const gd:integer=9;gm:integer=2;
var i:longint;
begin
  InicializujGrafiku;
  NastavCiernoBielu;
  InitGraph(gd,gm,'d:\bp\bgi');
{  Ciara(7,0,407,350,1);
  Ciara(17,0,417,350,1);
  Ciara(27,0,427,350,1);
  Ciara(37,0,437,350,1);
  Ciara(47,0,447,350,1);
  Ciara(57,0,457,350,1);
  Ciara(67,0,467,350,1);
  Ciara(77,0,477,350,1);
  Ciara(577,0,427,150,1);
  Ciara(437,150,587,0,1);
  BielyBod(332,150);
  BielyBod(328,150);
  BielyBod(330,148);
  BielyBod(330,152);}
{  for i:=0 to 299 do BielyBod(i+25,220+i div 2);}
{  for i:=0 to 63 do Ciara(320,240,i*10,470,1);
  for i:=0 to 63 do Ciara(320,240,i*10,0,1);
  for i:=1 to 46 do Ciara(320,240,630,i*10,1);
  for i:=1 to 46 do Ciara(320,240,0,i*10,1);
  ZmazOkno(10,80,60,480-160);}
{  for i:=0 to 479 do BielyBod(i+32,i div 2);
  for i:=0 to 479 do CiernyBod(i+33,i div 2);
  for i:=0 to 479 do CiernyBod(i,i div 2);}
  For i:=1 to 8000000 do BielyBod(123,258);
{  for i:=1 to 300000 do Ciara(0,0,20,14,1);}
{  for i:=1 to 2000 do ClearDevice;}
{  for i:=1 to 2000 do ZmazOkno(0,0,80,480);}
{  ReadLn;}
{  SetColor(15);
  for i:=1 to 300000 do Line(0,0,20,14);}
{  ReadLn;}
end.