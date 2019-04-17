program Diofantos;
var a,b,c,x:longint;
begin
  writeln('Riesenie diofantovskych rovn¡c');
  writeln('Z pis: ax+by=c');
  writeln('Zadaj a,b,c');
  readln(a,b,c);
  for x:=1 to c div a do if (c-a*x) mod b=0 then writeln(a,'*',x,'+',b,'*',(c-a*x) div b,'=',c);
  readln;
end.
