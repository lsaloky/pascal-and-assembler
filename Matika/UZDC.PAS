program Univerzalny_znak_delitelnosti_cisel;  {testovaaci program}
const d2:longint=7;
      s:string='43895';
var k,d1:longint;
    x,y,zvysok:integer;
BEGIN
  writeln('Zaciname...');
  for y:=1 to 20000 do begin
    d2:=random(12)+1;
    for x:=1 to 5 do s[x]:=Chr(random(10)+48);
    k:=10-d2;
    val(s,d1,x);
    zvysok:=((Ord(s[1])-48)*k+Ord(s[2])-48) mod d2;
    for x:=3 to Length(s) do zvysok:=(k*zvysok+Ord(s[x])-48) mod d2;
    if (zvysok=0) and (d1 mod d2<>0) then writeln('Chyba!!!',d1,':',d2,' zv. ',zvysok);
  end;
END.


