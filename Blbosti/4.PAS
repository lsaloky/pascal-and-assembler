program Najdi_maximum_a_vypis_pozicie;
var a:array[1..20] of byte;
    max,x:word;
BEGIN
  Randomize;
  for x:=1 to 20 do begin
    a[x]:=random(256);
    write(a[x],',');
  end;
  writeln;
  max:=0;
  for x:=1 to 20 do if a[x]>max then max:=a[x];
  for x:=1 to 20 do if a[x]=max then write('Maximum je:',max,' na pozicii ',x,',');
  readln;
END.
