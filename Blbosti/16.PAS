program Sucet_druhych_mocnin;
var s:string;
    x,y:longint;
BEGIN
  writeln('Zadaj cislo');
  readln(s);
  x:=0;y:=Length(s);
  while y>0 do begin
    x:=x+Sqr(Ord(s[y])-48);
    Dec(y,2);
  end;
  writeln(x);
  readln;
END.