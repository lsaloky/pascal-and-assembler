program Kopia_suboru;{priklad cislo 33}
var fin,fout:text;
    s:string;
    x,n:word;
BEGIN
  writeln('Zadaj pocet medzier');
  readln(n);
  Assign(fin,'c:\subory\texty\bonjovi.txt');Reset(fin);
  Assign(fout,'bonjovi.ods');Rewrite(fout);
  repeat
    readln(fin,s);
    for x:=1 to n do write(fout,' ');
    writeln(fout,s);
  until EOF(fin);
  Close(fin);
  Close(fout);
END.
