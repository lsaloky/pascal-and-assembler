program Procedura_a_funkcia;
var c1,c2,c3,c4:integer;

procedure Vymen(a,b:integer);
var c:integer;
begin
  writeln(a,' ',b);
  c:=a;a:=b;b:=c;
  writeln(a,' ',b);
end;

function plus2(a:integer):integer;
begin
  plus2:=a+2;
end;

BEGIN
  WRITELN;
  c1:=2;c2:=5;c3:=7;c4:=10;
  Vymen(c1,c2);
  Vymen(c3,c4);
  c4:=plus2(c4);
  writeln(c4);
  readln;
END.