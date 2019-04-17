program Slova_danej_dlzky;{priklad cislo 34}
var f:text;
    s:string;
    dlz,x,y:word;
BEGIN
  writeln('Zvol si dlzku slova');readln(dlz);
  Assign(f,'c:\subory\texty\bonjovi.txt');Reset(f);
  repeat
    readln(f,s);
    repeat
      x:=Pos(' ',s);
      if x=dlz+1 then for y:=1 to x do write(s[y]);
      if x=0 then x:=Ord(s[0]);
      Delete(s,1,x);
    until s[0]=#0;
  until EOF(f);
END.