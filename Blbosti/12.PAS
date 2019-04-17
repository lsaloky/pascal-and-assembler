program Najvacsi_spolocny_delitel;
var d1,d2,x:word;
BEGIN
  writeln('Zadaj dve cisla');
  readln(d1,d2);
  x:=d1;
  while x>0 do begin
    if (d1 mod x=0) and (d2 mod x=0) then begin
      writeln(x);
      x:=1;
    end;
    Dec(x);
  end;
  readln;
END.