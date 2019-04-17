program Damy_na_sachovnici;
type TA=array[1..8] of shortint;{i-ty index oznacujeje poziciu damy v i-tom riadku}
var a:TA;
    c1,c2:byte;
    volna:boolean;
procedure NajdiPoziciu(pa:TA;x:byte);{x je cislo najmensieho prazdneho riadka}
var y,pom:byte;
begin
  for y:=1 to 8 do begin
    Volna:=true;                         {[x,y] je volna}
    for pom:=1 to x-1 do if (pa[pom]=y) or (y-pa[pom]=x-pom) or (x+y=pom+pa[pom]) then Volna:=false;
                     {test riadkov        zostupnych           vzostupnych uhlopriecok }
    if Volna then begin
      pa[x]:=y;
      NajdiPoziciu(pa,x+1);
      if x=8 then begin
        for c2:=1 to 8 do writeln(c2,',',pa[c2]);
        readln;
      end;
    end;
  end;
end;
BEGIN
  for c1:=1 to 8 do begin
    for c2:=1 to 8 do a[c2]:=0;
    a[1]:=c1;
    NajdiPoziciu(a,2);
  end;
END.