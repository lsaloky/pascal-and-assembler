program Uloha_5;
const max=100;
var m:array[1..max,1..max] of integer;
    x,y,z,pocet,k,pocciest,pozrci:integer;
    fin,fout:text;
procedure ZrusCesty;
begin
  for y:=1 to pocet do
    if m[x,y]>0 then begin
      m[y,x]:=0;
      m[x,y]:=0;
    end;
end;
BEGIN
  FillChar(m,sizeof(m),0);
  Assign(fin,'cesty.in');
  Reset(fin);
  Assign(fout,'cesty.out');
  Rewrite(fout);
  repeat
    read(fin,pocet);
    read(fin,k);
    if (pocet<>0) or (k<>0) then begin
      for z:=1 to pocet do begin
        read(fin,x);
        repeat
          read(fin,y);
          Inc(m[x,y]);
        until eoln(fin);
      end;
      repeat
        PoZrCi:=0;
        for x:=1 to pocet do begin
          pocciest:=0;
          for y:=1 to pocet do pocciest:=pocciest+m[x,y];
          if (pocciest<k) and (pocciest>0) then begin
            ZrusCesty;
            Inc(PoZrCi);
          end;
        end;
      until pozrci=0;
      for x:=1 to pocet do begin
        pocciest:=0;
        for y:=1 to pocet do pocciest:=pocciest+m[x,y];
        if pocciest>=k then write(fout,x,' ');
      end;
      writeln(fout);
    end;
  until (pocet=0) and (k=0);
  Close(fin);
  Close(fout);
END.