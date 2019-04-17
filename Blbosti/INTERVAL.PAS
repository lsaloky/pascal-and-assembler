program Uloha_1;
var m:array[0..1439]of byte;
    x,y,pocet,zac,kon,odpoved:integer;
    s:string;
    fin,fout:text;
BEGIN
  FillChar(m,SizeOf(m),0);
  Assign(fin,'interval.in');
  Reset(fin);
  Assign(fout,'interval.out');
  Rewrite(fout);
  repeat
    readln(fin,pocet);
    if pocet>0 then begin
      for x:=1 to pocet do begin
        readln(fin,s);
        zac:=(Ord(s[1])-48)*600+(Ord(s[2])-48)*60+(Ord(s[3])-48)*10+Ord(s[4])-48;
        kon:=(Ord(s[6])-48)*600+(Ord(s[7])-48)*60+(Ord(s[8])-48)*10+Ord(s[9])-48;
        FillChar(m[zac],kon-zac,1);
      end;
      x:=0;
      while m[x]=0 do Inc(x);
      while m[x]=1 do Inc(x);
      odpoved:=1;
      for y:=x to 1439 do if m[y]=1 then odpoved:=0;
      if odpoved=0 then writeln(fout,'Nepodari')
      else writeln(fout,'Podari');
    end;
  until pocet=0;
  Close(fin);
  Close(fout);
END.
