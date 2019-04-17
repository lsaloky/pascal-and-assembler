program Loteria_KENO;
uses Crt,Printer;
var zc:array[0..12] of integer;  {zoznam cisel}
    nc,pzc,pz,c1,c2,c3,pom:integer; {pocet zrebovanych cisel, pocet zrebovani}
    ch:char;
    s:string;
    f:text;
label znova;
BEGIN
  Assign(f,'cisla.txt');
  Rewrite(f);
  Randomize;
  writeln('Kolko zrebovani chces?');
  readln(pz);
  writeln('Kolko cisel tipujes v jednom zrebovani?');
  readln(pzc);
  writeln('Ake najvacsie cislo ma byt?');
  readln(nc);
  writeln('Chces vystup do suboru? a/n');
  repeat
    ch:=ReadKey;
  until (ch='a') or (ch='A') or (ch='n') or (ch='N');
  for c1:=1 to pz do begin
    zc[0]:=0;
    for c2:=1 to pzc do begin
      znova:zc[c2]:=random(nc)+1;
      for c3:=1 to c2-1 do if zc[c3]=zc[c2] then goto znova;
      c3:=c2-1;
      while (zc[c2]<zc[c3]) and (c3>0) do Dec(c3);
      if c3<>c2-1 then begin
        pom:=zc[c2];
        Move(zc[c3+1],zc[c3+2],(c2-c3)*2);
        zc[c3+1]:=pom;
      end;
    end;
    for c2:=1 to pzc do begin
      write(zc[c2],',');
      if (ch='a') or (ch='A') then begin
        Str(zc[c2],s);
        write(f,s,',');
        write(lst,zc[c2],',');
      end;
    end;
    writeln;
    if (ch='a') or (ch='A') then begin
      writeln(f);
      writeln(lst);
    end;
  end;
  Close(f);
END.