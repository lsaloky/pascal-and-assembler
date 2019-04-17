program LISTKY;
var f,g:boolean;
    vstup,vystup:text;

procedure Listok(var f,g:boolean);
var i,j,k:byte;
    postup:string[6];
    v:array[1..9] of boolean;
    w:array[1..15] of boolean;
    r:array[1..6] of string[3];
    m:array[1..6,1..9] of boolean;

function VytvorPodmnoziny(postup:string;k:integer):boolean;
var f:boolean;

function Dieruj(postup:string):boolean;
var f:boolean;
    i,j:integer;
    l:array[1..9] of boolean;
begin
  for i:=1 to 9 do l[i]:=false;
  for i:=1 to Length(postup) do
    for j:=1 to 9 do l[j]:=l[j] or m[Ord(postup[i])-Ord('0'),j];
  f:=true;
  for i:=1 to 9 do
    if v[i]<>l[i] then f:=false;
  Dieruj:=f;
  end;

begin
  f:=Dieruj(postup);
  if not f and (k<6) then repeat
    Inc(k);
    postup:=postup+Chr(k+Ord('0'));
    f:=VytvorPodmnoziny(postup,k);
    Dec(byte(postup[0]));
    until f or (k=6);
  VytvorPodmnoziny:=f;
  end;

begin
  g:=false;
  ReadLn(vstup,r[1]);
  if r[1]='' then begin
    g:=true;
    Exit;
    end;
  ReadLn(vstup,r[2]);
  ReadLn(vstup,r[3]);
  for i:=1 to 6 do w[i]:=false;
  for i:=2 to 5 do
    for j:=1 to 3 do
      if r[i-1,j]='O' then w[3*i+j]:=true
                      else w[3*i+j]:=false;
  for i:=0 to 2 do
    for j:=3*i+1 to 3*i+9 do m[i+1,j-3*i]:=w[j];
  for i:=2 to 5 do
    for j:=1 to 3 do
  if r[i-1,4-j]='O' then w[3*i+j]:=true
                    else w[3*i+j]:=false;
  for i:=0 to 2 do
    for j:=3*i+1 to 3*i+9 do m[i+4,j-3*i]:=w[j];
  ReadLn(vstup,r[4]);
  ReadLn(vstup,r[5]);
  ReadLn(vstup,r[6]);
  for i:=0 to 2 do
    for j:=1 to 3 do
      if r[i+4,j]='O' then v[3*i+j]:=true
                      else v[3*i+J]:=false;

  postup:='';
  k:=0;
  f:=VytvorPodmnoziny(postup,k);
  end;

begin
  Assign(vstup,'C:\TP\OCTAVA\LISTKY.IN');
  Reset(vstup);
  Assign(vystup,'C:\TP\OCTAVA\LISTKY.OUT');
  Rewrite(vystup);
  repeat
    Listok(f,g);
    if not g then
      if f then WriteLn(vystup,'DA SA')
           else WriteLn(vystup,'NEDA SA');
  until g;
  Close(vstup);
  Close(vystup);
end.
