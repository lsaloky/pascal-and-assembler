program Tri_prasiatka_a_exaktna_matematika;
var priemer,ntyclen:real;
    x:word;
    s:string;
BEGIN
  x:=5;priemer:=6/27;ntyclen:=42/243;
  repeat
    priemer:=priemer+ntyclen*x;
    ntyclen:=ntyclen*7/9;
    x:=x+2;
  until ntyclen*x<0.0000001;
  Str(x,s);
  writeln('Teoreticky by priemerny cas mal byt: ',priemer:1:8);
END.