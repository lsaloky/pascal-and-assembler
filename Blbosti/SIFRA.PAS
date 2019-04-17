program Uloha_2;
var m:array[1..128,1..128] of shortint;
    x,y,pocet,odpoved:integer;
    s:string;         {0  - plny stvorcek}
    fin,fout:text;    {1  - vystrihnuty stvorcek}
BEGIN                 {-1 - plny stvorcek, ale po pootoceni bude vystrihnuty}
  Assign(fin,'sifra.in');
  Reset(fin);
  Assign(fout,'sifra.out');
  Rewrite(fout);
  repeat
    FillChar(m,SizeOf(m),0);
    readln(fin,pocet);
    if pocet>0 then begin
      pocet:=pocet*2;
      for x:=1 to pocet do begin
        readln(fin,s);
        for y:=1 to pocet do if s[y]='.' then m[x,y]:=1;
      end;
      odpoved:=1;
      for x:=1 to pocet do
        for y:=1 to pocet do
          if m[x,y]=1 then begin
            m[x,y]:=-1;
            if m[pocet+1-y,x]<=0 then m[pocet+1-y,x]:=-1
            else odpoved:=0;
            if m[pocet+1-x,pocet+1-y]<=0 then m[pocet+1-x,pocet+1-y]:=-1
            else odpoved:=0;
            if m[y,pocet+1-x]<=0 then m[y,pocet+1-x]:=-1
            else odpoved:=0;
          end;
      for x:=1 to pocet do
        for y:=1 to pocet do
          if m[x,y]<>-1 then odpoved:=0;
      if odpoved=0 then writeln(fout,'Nie')
      else writeln(fout,'Ano');
    end;
  until pocet=0;
  Close(fin);
  Close(fout);
END.
