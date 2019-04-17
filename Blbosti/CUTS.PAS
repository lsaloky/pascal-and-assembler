program Rezanie_obdlznika;{rekurzivne}
var x,y,z,c1,c2,max,aktual:word;
    fin,fout:text;
procedure ZPS(dlz,sir,pocet:word);{zisti pocet stvorcov}
var pom,dlhsia,kratsia:word;
begin
  if dlz=sir then Inc(pocet)
  else begin
    if dlz>sir then begin
      dlhsia:=dlz;
      kratsia:=sir;
    end else begin
      dlhsia:=sir;
      kratsia:=dlz;
    end;
    for pom:=kratsia downto 1 do begin
      ZPS(dlhsia,kratsia-pom,pocet);
      ZPS(dlhsia-pom,kratsia-pom,pocet);
      ZPS(pom,pom,pocet);
    end;
  end;
end;
BEGIN
  Assign(fin,'cuts.in');
  Reset(fin);
  Assign(fout,'cuts.out');
  Rewrite(fout);
  max:=0;
  Read(fin,x,y);
  x:=42;y:=13;
  if x<y then begin
    z:=x;
    x:=y;
    y:=z;
  end;
  ZPS(x,y,z);
  writeln(z);
  writeln(fout,z);
  Close(fin);
  Close(fout);
END.
