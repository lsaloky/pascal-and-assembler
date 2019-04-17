program Hanojske_veze;
var n,cnt:word;
procedure Tah(f,t:byte);
begin
  Inc(cnt);
  writeln(cnt:3,'. tah z ',f,' na ',t);
end;
procedure Hanoj(a,b,c,n:byte);
begin
  if n=1 then Tah(a,c)
  else begin
    Hanoj(a,c,b,n-1);
    Tah(a,c);
    Hanoj(b,a,c,n-1);
  end;
end;
BEGIN
  write('Kolko diskov? ');
  readln(n);
  writeln('Zaciatok: ',n,' diskov na vezi 1.');
  cnt:=0;
  Hanoj(1,2,3,n);
  writeln('Koniec:   ',n,' diskov na vezi 3.');
END.

