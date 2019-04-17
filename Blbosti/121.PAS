program Uloha_121;
var a:array[1..6] of byte;
    x,y,z,t,pokus:byte;
    suc:word;
BEGIN
  randomize;
  writeln;
  suc:=0;
  for pokus:=1 to 60 do begin
    a[5]:=0;
    x:=1;
    repeat
      z:=random(5)+1;
      y:=1;
      while (a[y]<>z) and (y<6) do Inc(y);
      if y=6 then begin
        a[x]:=z;
        inc(x);
      end;
    until a[5]>0;
    y:=0;
    z:=random(5)+1;
    for x:=1 to 5 do begin
      if a[z]=z then begin
        Inc(y);
        a[z]:=0;
        for t:=1 to 5 do if a[t]<>0 then z:=t;
      end
      else begin
        t:=a[z];
        a[z]:=0;
        if a[t]>0 then z:=t
        else for t:=1 to 5 do if a[t]<>0 then z:=t;

      end;
    end;
    for x:=1 to 5 do if a[x]<>0 then inc(y);
    write(y,',');
    suc:=suc+y;
  end;
  writeln;
  writeln('Spolu:',suc);
END.