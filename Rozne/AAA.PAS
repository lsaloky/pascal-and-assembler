var r:real absolute $A000:0000;
    i:integer;
BEGIN
  writeln;
  r:=1.25/1.23;
  for i:=0 to 5 do write(Mem[$A000:i],',');
END.