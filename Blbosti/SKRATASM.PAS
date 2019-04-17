program Vsun_tabelatory;
Const Nazov:string='FliPlay.ASM';
var f,f2:text;
    s:string;
    i:integer;
begin
  Assign(f,Nazov);
  Reset(f);
  Assign(f2,'Temp.TMP');
  ReWrite(f2);
  while not EOF(f) do begin
    ReadLn(f,s);
    if (s>'') and ((s[1]=' ') or (s[1]=#9)) then begin
      while (s>'') and ((s[1]=' ') or (s[1]=#9)) do Delete(s,1,1);
      Insert(#9,s,1);                   { pociatocne medzery }
      Insert(#9,s,1);
    end;
    i:=Pos(': ',s);                      { labely }
    if i>0 then begin
      while ((s[i+1]=' ') or (s[i+1]=#9)) and (Byte(s[0])>i+1) do Delete(s,i+1,1);
      Insert(#9,s,i+1);
      Insert(#9,s,i+1);
    end;
    i:=Pos('        ',s);               { osem medzier }
    if i>0 then begin
      Delete(s,i,8);
      Insert(#9,s,i);
    end;
    WriteLn(f2,s);
  end;
  Close(f);
  Rename(f2,Nazov);
  WriteLn(IOResult);
  Close(f2);
END.
