program Life;
uses Crt;
const m=6;
      n=5;
var plan,plan2:array[1..m,1..n] of byte;
    x,y,a,b,sus:integer;          {sus - pocet susedov}
    f:file;
    f2:text;
    buf:string;

procedure Skontroluj;
begin
  if x=0 then x:=m;
  if x=m+1 then x:=1;
  if y=0 then y:=n;
  if y=n+1 then y:=1;
  if plan[x,y]=1 then Inc(sus);
end;

{procedure konvert;
var chyba:word;
begin
  repeat
    s2[l2+1]:=buf[l+l2];
    Inc(l2);
  until (buf[l+l2]=' ') or (buf[l+l2]=#$0D);
  s2[0]:=chr(l2);
  l:=l+l2;l2:=0;
  Val(s2,x,chyba);
  if chyba <>0 then writeln('Error!!!');
end;}

begin
  Assign(f,'delitel.in');
  Reset(f,1);
  a:=1;
  repeat
    Blockread(f,buf[a],1);
    Inc(a);
  until buf[a]=' ';
  buf[0]:=chr(a);
  writeln(buf);

  for x:=1 to m do for y:=1 to n do plan[x,y]:=0;
  plan[4,1]:=1;plan[5,2]:=1;plan[3,3]:=1;plan[4,3]:=1;plan[5,3]:=1;
  repeat
  writeln('---------------------------------------');
  for a:=1 to m do
    for b:=1 to n do begin
      sus:=0;
      x:=a-1;y:=b-1;Skontroluj;
      x:=a;y:=b-1;Skontroluj;
      x:=a+1;y:=b-1;Skontroluj;
      x:=a-1;y:=b;Skontroluj;
      x:=a+1;y:=b;Skontroluj;
      x:=a-1;y:=b+1;Skontroluj;
      x:=a;y:=b+1;Skontroluj;
      x:=a+1;y:=b+1;Skontroluj;
      if (sus=0) or (sus=1) or (sus>3) then plan2[a,b]:=0;
      if sus=2 then
        if plan[a,b]=1 then plan2[a,b]:=1
                       else plan2[a,b]:=0;
      if sus=3 then plan2[a,b]:=1;
    end;
  for b:=1 to n do begin
    for a:=1 to m do write(plan2[a,b],',');
    writeln;
  end;
  readln;
  move(plan2,plan,sizeof(plan));
  until keypressed;
end.

