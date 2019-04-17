program Priklad_3;
uses Graph;
const Cesta='d:\bp\bgi';       {!!! pozor !!!}
var s,t:string;
    gd,gm,x,y,nas,p,poc:integer;
    a:array[1..50] of word;

procedure Vyber;
var pom,pom2:integer;
begin
  Delete(s,1,1);
  pom:=1;
  while ('0'<=s[pom]) and ('9' >=s[pom]) do Inc(pom);
  t:=copy(s,1,pom-1);
  Val(t,p,pom2);
  if pom2<>0 then writeln('Postupnost nie je zadana korektne !!!');
  Delete(s,1,pom-1);
end;

begin
  writeln('Zaciatok');
  nas:=1;poc:=1;s:='[2[7[100 90]]]';
{  writeln('Zadaj prikaz:');
  readln(s);
  DetectGraph(gd,gm);
  InitGraph(gd,gm,cesta);}
  while poc>0 do begin
    Vyber;
    if s[1]=' ' then begin
      x:=p;
      Vyber;
      y:=p;
      writeln(x,';',y,';',s);

    end;
    if s[1]='[' then begin
      a[poc]:=p;
      Inc(poc);
      writeln(a[poc],'*',s);
    end;
    if s[1]=']' then begin
      Delete(s,1,1);
      Dec(poc);
    end;
  end;
  readln;
end.