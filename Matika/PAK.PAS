program paktorial;  { n?= n + n-1 + n-2 +...+ 1  = ( n+1 ) }
uses crt ;          {                              (  2  ) }
var n,k,v,nf,p,cislo,nkf,kf,npak,t:integer;
begin
 clrscr;
 textcolor(red);
 writeln('Zadaj cislo');
 readln(cislo);
 n:=cislo+1;
 k:=2;
 nf:=1;
 for p:=1 to n-1 do
 begin
  nf:=(n-p)*nf;
 end;
 nkf:=1;
 for p:=1 to n-1 do
 begin
  nkf:=((n-k)-p)*nkf;
 end;
 kf:=1;
 for p:=1 to n-1 do
 begin
  kf:=(k-p)*kf;
 end;
 npak:=nf*t*0.1;
 readln;
end.