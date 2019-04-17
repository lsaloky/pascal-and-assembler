program Minimum_a_maximum;
var a:array[1..1000] of word;
    n,x,max,min,posmax,posmin:word;
BEGIN
  Randomize;
  writeln('Kolko je cisel?');
  readln(n);
  for x:=1 to n do begin
    a[x]:=random(256);
    write(a[x],',');
  end;
  writeln;
  max:=0;min:=65535;
  for x:=1 to n do begin
    if a[x]<min then begin
      min:=a[x];
      posmin:=x;
    end;
    if a[x]>max then begin
      max:=a[x];
      posmax:=x;
    end;
  end;
  writeln('Najvacsie cislo: ',max,' na pozicii ',posmax);
  writeln('Najmensie cislo: ',min,' na pozicii ',posmin);
  readln;
END.