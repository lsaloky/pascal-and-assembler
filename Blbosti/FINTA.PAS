program Hladaj_subor_s_atributom_0F;{adresar a zaroven meno disku}
uses Dos;
var subor:SearchRec;
    f:file;
    s:string;
BEGIN
  FindFirst('*.tmp',$18,subor);
  writeln(subor.Name);
  repeat
    FindNext(subor);
    writeln(subor.Name);
  until DosError<>0;
  readln;
  s:='';
  Assign(f,'ncff~.tmp');
  Reset(f,1);
  BlockRead(f,s,255);
  s[0]:=#255;
  writeln(s);
  Close(f);
END.