program stvorce;
var i,j,n,m:integer;
begin
writeln('Zadaj neparne cislo.');
repeat
readln(n);
if (n mod 2)=0 then writeln('Nerob sa sprosty a zadaj neparne cislo.');
until n mod 2=1;
writeln('Zadaj prirodzen‚ c¡slo v„csie ako 4.');
repeat
readln(m);
if m<4 then writeln('Mal si zadat v„csie ako 4.');
until m>=4;
for j:=1 to (n+1) div 2 do begin
 for i:=1 to (n-1) div 2-j+1 do write(' ');
 for i:=1 to 2*j-1 do write('X');
 writeln;
end;
for j:=1 to (n-1) div 2 do begin
 for i:=1 to j  do write(' ');
 for i:=1 to n-2*j  do write('X');
 writeln;
 end;
 writeln;
for i:=1 to 2 do begin
for j:=1 to m do write('X');
writeln;
end;
for j:=1 to m-4 do begin
write('XX');
for i:=1 to m-4 do write('O');
write('XX');
writeln;
end;
for i:=1 to 2 do begin
for j:=1 to m do write('X');
 writeln;
 end;
 readln;
end.
