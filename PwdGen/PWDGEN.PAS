program Generovanie_vsetkych_hesiel;
var s:string;
    f:text;
    i,j:integer;
BEGIN
  Assign(f,'pwd.txt');
  Reset(f);
  ReadLn(f,s);
  i:=Length(s);
  while (s[i]='z') and (i>0) do Dec(i);       { usek "z" na konci }
  for j:=i+1 to Length(s) do s[j]:='a';       { nahrad ackami }
  if i=0 then s:=s+'a' { zvysovanie poctu znakov}
         else Inc(byte(s[i]));                { a pripocitaj jednotku }
  Close(f);
  ReWrite(f);
  WriteLn(f,s);
  Close(f);
END.
