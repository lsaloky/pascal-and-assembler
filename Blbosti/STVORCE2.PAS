{priklad cislo 18}
program VypisStvorcov;
uses Crt;
var x,y,m,n:word;
    ch:char;
BEGIN
  TextMode(Co80+Font8x8);
  ClrScr;
  writeln('Zadaj uhlopriecku prveho stvorca (neparne cislo)');
  readln(n);
  writeln('Zadaj stranu druheho stvorca (prirodzene cislo)');
  readln(m);
{ ----- prvy stvorec ----- }
  for y:=1 to m do begin
    write('XX');
    if (y>2) and (y<m-1) then ch:='0' else ch:='X';
    for x:=1 to m-4 do write(ch);
    writeln('XX');
  end;
{ ----- druhy stvorec ----- }
  writeln;
  for x:=1 to n div 2+1 do begin
    for y:=n div 2+1 downto x do write(' ');
    for y:=1 to x*2-1 do write('X');
    writeln;
  end;
  for x:=n div 2-1 downto 0 do begin
    for y:=x to n div 2 do write(' ');
    for y:=1 to x*2+1 do write('X');
    writeln;
  end;
  readln;
END.