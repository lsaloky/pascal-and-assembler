program trojkova;
var  a:array[1..20] of integer;
   n,i,j:longint;
begin
writeln('Zadaj lubovolne cislo.');
readln(n);
i:=1;
while n>0 do begin
a[i]:=n mod 3;
n:=n div 3;
i:=i+1;
end;
j:=20;
write('Zadane cislo v trojkovej sustave je:');
while a[j]=0 do j:=j-1;
for i:=j  downto 1 do write( a[i]);
readln;
end.
