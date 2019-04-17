program Pasca;
var f:file;
    buf:array[1..32768] of char;
    x:longint;
    y:word;
begin
  writeln;
  write('Kontrolujem disk ');
  assign(f,'c:\davky\trap.txt');
  reset(f,1);
  for x:=1 to 128 do begin
    BlockRead(f,buf,SizeOf(buf));
    if x mod 12=0 then write('.');
    for y:=1 to 32768 do if buf[y]<>'a' then writeln('Error!!!');
  end;
end.