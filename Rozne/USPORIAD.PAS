program Usporiadaj;
uses Dos;
type pom=array[1..65520]of char;
var f,f2:file;
    s,s2:string;
    x,y,err,poz:integer;
    p:^pom;
begin
  GetMem(p,65520);poz:=1;
  FillChar(p,65520,' ');
  Exec('d:\dos\dir','d:\ /s /a /o:-c >subory.txt');
  Assign(f,'subory.txt');
  Reset(f,1);
  Assign(f2,'subory2.txt');
  Rewrite(f2,1);
  BlockRead(f,s[1],255);
  s[0]:=#255;
  repeat
    x:=Pos(#13#10,s);
    y:=Pos('to 1.0'#13#10,s);
    if y=0 then y:=32000;
    if y<x then begin
      s2:=Copy(s,1,x+1);
      Delete(s2,13,31);
      Delete(s2,20,6);
      writeln(s2);
      readln;
      Move(s2[1],p^[poz],length(s2)-2);
      poz:=poz+length(s2)-1;
      BlockWrite(f2,s2[1],length(s2));
    end;
    Delete(s,1,x+1);
    s[0]:=#255;
    BlockRead(f,s[254-x],x+1,err);
  until err=0;
  Close(f2);
  Close(f);
  writeln('aaa');
  for x:=1 to poz do write(p^[x]);
  writeln(poz);
end.