program Fotograf;
var fin,fout:text;
    minvzdial:real;
    n,x,y,minvzdialindex:word;
    c,s,v,l:array[1..3] of real;    {c = casy, l = vzdialenosti}
BEGIN
  Assign(fin,'fotograf.in');
  Reset(fin);
  Assign(fout,'fotograf.out');
  Rewrite(fout);
  read(fin,n);
  for y:=1 to n do begin
    read(fin,s[1],v[1],s[2],v[2],s[3],v[3]);
    c[3]:=(s[1]-s[2])/(v[2]-v[1]);      {cas stretnutia 1. s 2. vlakom}
    c[2]:=(s[1]-s[3])/(v[3]-v[1]);      {               1. s 3.}
    c[1]:=(s[2]-s[3])/(v[3]-v[2]);      {               2. s 3.}
    for x:=1 to 3 do if c[x]<0 then c[x]:=0;
    l[3]:=Abs(s[3]+c[3]*v[3]-s[1]-c[3]*v[1]);{vzdialenost 3. a 1. v case stretnutia 1. a 2.}
    l[2]:=Abs(s[2]+c[2]*v[2]-s[1]-c[2]*v[1]);{vzdialenost 2. a 1. v case stretnutia 1. a 3.}
    l[1]:=Abs(s[1]+c[1]*v[1]-s[2]-c[1]*v[2]);{vzdialenost 1. a 2. v case stretnutia 2. a 3.}
    minvzdial:=3.8E+31;
    for x:=1 to 3 do
      if l[x]<minvzdial then begin
        minvzdialindex:=x;
        minvzdial:=l[x];
      end;
    writeln(fout,c[minvzdialindex]:0:2);
  end;
  Close(fin);
  Close(fout);
END.