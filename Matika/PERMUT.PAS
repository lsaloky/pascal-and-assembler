program Vypis_vsetky_permutacie_pre_dane_n;
var a:array[1..16] of byte;
    n,x:byte;
{ do permutacie a(1),a(2), ... ,a(n-1) postupne vloz na vsetky miesta a(n)}
procedure Vymen(i,j:integer);
var temp:byte;
begin
  temp:=a[i];
  a[i]:=a[j];
  a[j]:=temp;
end;
procedure Permutuj(k:byte);
var j:byte;
begin
  for j:=1 to k+1 do begin
    Vymen(j,k+1);
    if k+1<n then Permutuj(k+1)
    else begin
      for x:=1 to n do write(a[x],' ');
      write('° ');
    end;
    Vymen(k+1,j); { obnov stav - ost. prvky sa obnovia v predch. volaniach }
  end;
end;
BEGIN
  n:=3;
  writeln;
  for x:=1 to n do a[x]:=x;
  Permutuj(1);
END.