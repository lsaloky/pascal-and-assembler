program Delitel;
var n,p,q,a,b,x,y,min:longint;
    l,l2,m,m2:word;
    buf:string[128];
    s2:string[20];
    vysl:array[1..16000] of longint;
    f:file;
    f2:text;
function Moc(man,expo:longint):longint;
var s,l:longint;
begin
  l:=man;
  if expo=0 then Man:=1;
  if expo>1 then for s:=1 to expo-1 do man:=man*l;
  Moc:=man;
end;

procedure konvert;
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
end;

begin
  Assign(f,'delitel.in');
  Reset(f,15);
  Blockread(f,buf[1],1);
  buf[0]:=#7;l:=1;l2:=0;
  konvert;p:=x;
  konvert;q:=x;
  konvert;a:=x;
  konvert;b:=x;
  n:=1;
  for x:=1 to a do n:=n*p;
  for x:=1 to b do n:=n*q;
  l:=1;
  for x:=0 to a do
    for y:=0 to b do begin
      vysl[l]:=moc(p,x)*moc(q,y);
      Inc(l);
    end;
        { ----- triedenie ----- }
  assign(f2,'delitel.out');
  Rewrite(f2);
  min:=2000000000;
  Dec(l);
  for m2:=1 to l do begin
    for m:=1 to l do begin
      if vysl[m]<min then begin
        min:=vysl[m];
        l2:=m;
      end;
    end;
    Str(vysl[l2],s2);
    write(f2,s2+' ');
    vysl[l2]:=2000000001;
    min:=2000000000;
  end;
  readln;
  Close(f2);
end.
