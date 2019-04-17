uses sblaster;
type TPole=array[1..64000] of byte;
var f:file;
    p,r:^TPole;
    i:word;
BEGIN
  GetMem(p,64000);
  GetMem(r,64000);
  InicializujSB($220);
  Assign(f,'e:\zvuk\wav\alarm1.wav');{38508 bajtov}
  Reset(f,1);
  BlockRead(f,p^,FileSize(f));
  Close(f);
  Assign(f,'e:\zvuk\wav\affair.wav');{25652 bajtov}
  Reset(f,1);
  BlockRead(f,r^,FileSize(f));
  Close(f);
  PustWAV(p);
  readln;
  PustWav(r);
  readln;
  for i:=38308 to 48308 do p^[i]:=0;
  for i:=10001 to 35652 do p^[i]:=p^[i] shr 1 + r^[i-10000] shr 1;
  PustWAV(p);
  FreeMem(r,64000);
  FreeMem(p,64000);
END.