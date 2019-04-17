var f1,f2:file;
    Buffer:string;
    x,y:byte;
BEGIN
  x:=16;y:=16;
  Assign(f1,'TaBi.MA');
  Reset(f1,1);
  Assign(f2,'TaBi.MB');
  Reset(f2,1);
  Seek(f1,FileSize(f1)-256);
  BlockRead(f1,Buffer,256);
  Seek(f2,FileSize(f2));
  BlockWrite(f2,x,1);
  BlockWrite(f2,y,1);
  BlockWrite(f2,Buffer,256);
END.


