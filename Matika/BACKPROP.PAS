program Backpropagation_algoritmus;
uses Crt,MainGr;
var Vaha:array[2..3,0..2,0..2] of real; { vrstva, zdroj. por., ciel. por. }
    Hodnota:array[1..3,0..2] of real;   { vrstva, por. cislo vo vrstve }
    Chyba:array[1..3,0..2] of real;     { sp„tne propagovanie chyby }
    i,j,k:integer;
    Vystup,x:real;

procedure Ucenie;
begin
{ ----- aplikacia vzoru ----- }
  for i:=0 to 2 do begin
    x:=Hodnota[1,0]*Vaha[2,i,0]+ { i,0 / 0,i }
       Hodnota[1,1]*Vaha[2,i,1]+
       Hodnota[1,2]*Vaha[2,i,2];
    Hodnota[2,i]:=1/(1+Exp(-x));
  end;
  x:=Hodnota[2,0]*Vaha[3,i,0]+
     Hodnota[2,1]*Vaha[3,i,1]+
     Hodnota[2,2]*Vaha[3,i,2];
  Hodnota[3,0]:=1/(1+Exp(-x));
{ ----- chyba ----- }
  Chyba[3,0]:=(Vystup-Hodnota[3,0]) * Exp(-x) / (1+Exp(-x)) / (1+Exp(-x));
  for i:=0 to 2 do
    Vaha[3,i,0]:=Vaha[3,i,0] + Chyba[3,0] * Hodnota[3,0];
  for i:=0 to 2 do begin
    x:=Hodnota[2,0]*Vaha[3,i,0]+
       Hodnota[2,1]*Vaha[3,i,1]+
       Hodnota[2,2]*Vaha[3,i,2];
    Chyba[2,i]:=Chyba[3,0] * Vaha[3,i,0] * Exp(-x) / (1+Exp(-x)) / (1+Exp(-x));
  end;
  for i:=0 to 2 do
    for j:=0 to 2 do
      Vaha[2,i,j]:=Vaha[2,i,j] + Chyba[2,j] * Hodnota[2,j]; {!!!!!}
  WriteLn(#13#10#13#10'----- Vahy od vstupu do skrytej vrstvy: -----');
  for i:=0 to 2 do begin
    for j:=0 to 2 do Write(Vaha[2,i,j]:0:5,'  ');
    WriteLn;
  end;
  WriteLn('----- Vahy zo skrytej vrstvy do vystupu: -----');
  for i:=0 to 2 do Write(Vaha[3,i,0]:0:5,'  ');
  WriteLn(#13#10'----- Vystup -----'#13#10,Hodnota[3,0]:0:5);
end;
BEGIN
  for i:=2 to 3 do
    for j:=0 to 2 do
      for k:=0 to 2 do
        Vaha[i,j,k]:=Random(100)/30;
  for k:=0 to 599 do begin { 100 iteracii pre kazdu vzorku }
    CakajNaVOI;
    ClrScr;
    case k div 100 of
      0:begin
        Hodnota[1,0]:=1; Hodnota[1,1]:=-1;Hodnota[1,2]:=1; Vystup:=1; Ucenie;
      end;
      1:begin
        Hodnota[1,0]:=-1;Hodnota[1,1]:=-1;Hodnota[1,2]:=1; Vystup:=-1;Ucenie;
      end;
      2:begin
        Hodnota[1,0]:=1; Hodnota[1,1]:=1; Hodnota[1,2]:=-1;Vystup:=1; Ucenie;
      end;
      3:begin
        Hodnota[1,0]:=-1;Hodnota[1,1]:=1; Hodnota[1,2]:=-1;Vystup:=-1;Ucenie;
      end;
      4:begin
        Hodnota[1,0]:=1; Hodnota[1,1]:=-1;Hodnota[1,2]:=-1;Vystup:=1; Ucenie;
      end;
      5:begin
        Hodnota[1,0]:=-1;Hodnota[1,1]:=-1;Hodnota[1,2]:=-1;Vystup:=1; Ucenie;
      end;
    end;
  end;
END.
