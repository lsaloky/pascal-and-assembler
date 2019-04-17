program Slimak;
var n,x,y:word;
BEGIN
  n:=3;
  for x:=1 to 4*(n-1) do write('*');
  writeln;
  for x:=1 to n div 2 do write('* ');
  for x:=1 to n div 2 do write(' *');
  writeln;

  for x:=1 to n div 2 do write('* ');
  write('**');
  {for x:=1 to (n div 2)-1 to write(' *');}
  writeln;
  readln;
END.