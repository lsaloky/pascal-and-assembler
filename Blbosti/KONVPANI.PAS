program Konverzia;
var fin,fout:file;
    k:array[1..2] of char;
    i:longint;
BEGIN
  Assign(fin,'pani.doc');
  Reset(fin,1);
  Assign(fout,'pani2.doc');
  ReWrite(fout,1);
  BlockRead(fin,k[1],1);
  i:=0;
  while not EOF(fin) do begin
    Inc(i);
    if i mod 1000=0 then write(i,' ');
    BlockRead(fin,k[1],2);
    BlockWrite(fout,k[1],1);
  end;
  Close(fin);
  Close(fout);
END.