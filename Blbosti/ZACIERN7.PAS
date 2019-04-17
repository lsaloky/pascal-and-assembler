program De_Bruigne2;
{ Program pre prevod asi 440 KB dlheho suboru s postupnostou do 8 KB struktury. }
var f:text;
    fout:file;
    i,Pocet:word;
    Pak:array[0..8193] of byte;
BEGIN
  for i:=0 to 8193 do Pak[i]:=0;
  Assign(f,'DeBruig.txt');
  Reset(f);
  ReadLn(f,i);
  Assign(fout,'DeBruig.dat');
  ReWrite(fout,8194);
  for Pocet:=0 to 65535 do begin
    ReadLn(f,i);
    if i and $0001>0 then
      Pak[Pocet shr 3]:=Pak[Pocet shr 3] + ($01 shl (7-Pocet and $0007));
  end;
  BlockWrite(fout,Pak,1);
  Close(f);
  Close(fout);
END.


