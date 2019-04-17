program Kontrola;
var fin,fout:text;
    n,x,y,poc:integer;
    PC:array[1..10000] of word;{pocetnosti jednotlivych cisel}

BEGIN
  Assign(fin,'kontrola.in');
  Reset(fin);
  Assign(fout,'kontrola.out');
  Rewrite(fout);
  read(fin,n);
  while n>0 do begin
    for x:=1 to 10000 do PC[x]:=0;
    for x:=1 to n do begin
      read(fin,y);
      inc(PC[y]);
    end;
    poc:=0;
    x:=1;
    while (PC[x]<n div 2) and (poc<n div 2) do begin
      inc(x);
      poc:=poc+PC[x];
    end;
    if PC[x]>n div 2 then writeln(fout,x)
    else writeln(fout,'NEEXISTUJE');
    read(fin,n);
  end;
  Close(fin);
  Close(fout);
END.