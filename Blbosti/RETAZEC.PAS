program Retazec;{uloha c. 31}
var s:string;
    x:byte;
BEGIN
  writeln('Zadaj retazec');
  readln(s);
  for x:=Ord(s[0]) downto 1 do write(s[x]);
  readln;
END.