program Hornerova_schema;
var polynom:array[0..10]of integer;
    x,y,cislo:integer;
    hodnota:longint;
BEGIN
  writeln('Zadavaj koeficienty mnohoclena od absolutneho vyssie, ukonci 0');
  x:=0;
  repeat
    readln(polynom[x]);
    Inc(x);
  until polynom[x-1]=0;
  Dec(x,2);
  writeln('Zadaj hodnotu, ktoru mam dosadit');
  readln(cislo);
  hodnota:=polynom[x];
  for y:=x downto 1 do hodnota:=hodnota*cislo+polynom[y-1];
  writeln('Vysledok: ',hodnota);
  readln;
END.




