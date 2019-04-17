program jaaty;{Objem a plocha kocky}
var a,n,b,u:real; {a - objem, b - plocha}
begin
  writeln('Zadaj, pros¡m hranu kocky');
  readln(n);
  b:=6*n*n;
  a:=n*n*n;
  u:=n*sqrt(3);
  writeln('Plocha je ',b:0:3);
  writeln('Objem je ',a:0:3);
  writeln('Telesova uhlopriecka je ',u:0:3);
  readln;
end.