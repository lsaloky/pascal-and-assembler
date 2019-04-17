program Vypis_druhe_mocniny_po_n;
var a,b:array[1..100]of word;
    n,x:integer;
BEGIN
  writeln('Zadaj N');
  readln(n);
  a[1]:=1;
  b[1]:=1;
  for x:=2 to n-1 do begin
    b[x]:=b[x-1]+2;
    a[x]:=a[x-1]+b[x];
  end;
  for x:=1 to n-1 do write(a[x],' ');
  readln;
END.