{priklad cislo 22}
program Vlastne_scitanie;
const n=21;
var x,y,znamienko,prvacislica:integer;
    s:string;
    a,b:array[1..n] of shortint;
procedure NastavZnamienko;
begin
  if s[1]='-' then begin
    znamienko:=-1;
    prvacislica:=2;
  end else begin
    znamienko:=1;
    prvacislica:=1;
  end;
end;
BEGIN
  writeln('Zadaj prveho scitanca');
  readln(s);
  NastavZnamienko;
  for x:=prvacislica to Length(s) do a[n+x-Length(s)]:=(Ord(s[x])-48)*znamienko;
  writeln('Zadaj druheho scitanca');
  readln(s);
  NastavZnamienko;
  for x:=prvacislica to Length(s) do b[n+x-Length(s)]:=(Ord(s[x])-48)*znamienko;
{ ---- scitanie ----- }
  for x:=n downto 1 do begin
    a[x]:=a[x]+b[x];
    if a[x]>9 then begin
      a[x]:=a[x]-10;
      a[x-1]:=a[x-1]+1;
    end;
  end;
{ ----- vypis ----- }
  y:=1;
  write('Vysledok je: ');
  while (a[y]=0) and (y<n) do Inc(y);
  for x:=y to n do write(a[x]);
  readln;
END.