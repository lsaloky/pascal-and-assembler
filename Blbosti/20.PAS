program Mnohoclen;
const polynom:array[0..5]of integer=(3,-1,2,-4,0,1);
var x,y,z,vysledok:longint;

function Mocnina(a,b:longint):longint;
begin
  Mocnina:=Round(Exp(b*ln(a)));
end;

function Derivacia(coho,ktora:longint):longint;
begin
  if ktora=0 then Derivacia:=polynom[coho]
  else Derivacia:=Derivacia(coho,ktora-1)*(coho-ktora+1);
end;

BEGIN
  writeln('V ktorom bode chces pocitat hodnotu mnohoclena a jeho derivacii?');
  readln(x);
  vysledok:=0;
  for y:=0 to 5 do vysledok:=vysledok+polynom[y]*Mocnina(x,y);
  writeln('Hodnota mnohoclena = ',vysledok);
  for z:=1 to 5 do begin
    vysledok:=0;
    for y:=0 to 5 do vysledok:=vysledok+Derivacia(y,z)*Mocnina(x,y-z);
    writeln('Hodnota ',z,'. derivacie = ',vysledok);
  end;
  readln;
END.




