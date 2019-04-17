program Urob_prazdny_subor_pre_MorfEdit;
uses Dos;
var f:text;
    x:word;
BEGIN
  assign(f,'prazdny.dat');
  rewrite(f);
  for x:=1 to 257 do write(f,#0);
  CLose(f);
END.