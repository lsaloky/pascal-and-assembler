program Integrovanie;
var x,y:integer;
    dole,hore,obsah:real;
begin
  obsah:=0;
  writeln('Zadaj delenie');
  readln(x);
  for y:=0 to x-1 do begin
    dole:=1/(1+sqr(y/x));
    hore:=1/(1+sqr((y+1)/x));
    obsah:=obsah+(dole+hore)/x/2;
  end;
  writeln(obsah);
  readln;
end.