program Najvacsie_prvocislo;	{vypise 2^44497-1 do suboru (za 1 a pol hod.)}
const presnost=14000;
var op:array[1..presnost] of shortint;
    x,y,mocnina,poccif:word;
    f:text;
BEGIN
  Assign(f,'maxprvoc.txt');
  Rewrite(f);
  mocnina:=2000;poccif:=1;
  for x:=1 to presnost do op[x]:=0;
  op[presnost]:=1;
  for y:=1 to mocnina do begin
    for x:=presnost-poccif to presnost do begin
      op[x]:=op[x] shl 1;
      if op[x]>9 then begin
        op[x]:=op[x]-10;
        op[x-1]:=op[x-1]+1;
        if x=presnost-poccif+1 then Inc(poccif);
      end;
    end;
  end;
  op[presnost]:=op[presnost]-1;
  y:=1;
  while op[y]=0 do Inc(y);
  for x:=y to presnost do write(f,op[x]);
  Close(f);
END.
