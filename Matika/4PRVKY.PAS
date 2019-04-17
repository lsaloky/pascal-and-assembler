program Usporiadaj; {Uspor. 4-prvkovej postupnosti na 5 porovnani zostupne.}
var a:array[1..4] of integer;
    x:integer;
procedure Posun(x1,x2:integer);
var pom:integer;
begin
  pom:=a[x2];
  for x:=x2-1 downto x1 do a[x+1]:=a[x];
  a[x1]:=pom;
end;
BEGIN
  repeat
    writeln('Zadaj postupnost styroch cisel.');
    readln(a[1],a[2],a[3],a[4]);
    if a[2]>a[1] then Posun(1,2);    {Tieto tri riadky}
    if a[3]>a[1] then Posun(1,3);    {usporiadaju prve tri}
    if a[3]>a[2] then Posun(2,3);    {cleny postupnosti.}

    {Dalej sa porovna 4. clen s 2. a ak je vacsi, tak sa porovna s prvym a
     zacleni sa na 1. alebo 2. miesto. Ak nie je vacsi, tak sa porovna s
     tretim a zacleni sa na 3. alebo 4. miesto}

    if a[4]>a[2] then begin
      if a[4]>a[1] then Posun(1,4)
      else Posun(2,4);
    end
    else
      if a[4]>a[3] then Posun(3,4);
    for x:=1 to 4 do write(a[x],' ');
    writeln;
  until a[1]=0;
END.

