program Fibonnaciho_postupnost;
var c1,c2,c3,n,x:word;
begin
  c1:=1;
  c2:=1;
  writeln('Kolko clenov chces vypisat?');
  readln(n);
  write(c1,',',c2);
  if n>2 then begin
    for x:=3 to n do begin
      c3:=c1+c2;
      write(',',c3);
      c1:=c2;
      c2:=c3;
    end;
  end;
  readln;
end.



