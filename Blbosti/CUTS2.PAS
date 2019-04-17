program Rezanie_obdlznika;{2.verzia, necela sekunda}
var fin,fout:text;
    o:array[1..100,1..100] of word;
    x,y,z,sir,vys,min:word;
BEGIN
  Assign(fin,'cuts.in');
  Reset(fin);
  Assign(fout,'cuts.out');
  Rewrite(fout);
  for x:=1 to 100 do for y:=1 to 100 do o[x,y]:=0;
  Read(fin,sir,vys);
  if sir>vys then begin {vyska musi byt vzdy vacsie cislo}
    z:=sir;
    sir:=vys;
    vys:=z;
  end;
{ ----- skladanie obdlznikov ----- }
  for x:=1 to sir do begin
    o[x,x]:=1;              {prvok na uhlopriecke}
    for y:=x+1 to vys do begin
      min:=65535;
      for z:=1 to (y div 2) do  {hladanie najkratsieho rezu na x-tom riadku}
        if o[x,y-z]+o[x,z]<min then min:=o[x,y-z]+o[x,z];
      for z:=1 to (x div 2) do  {hladanie najkr. sur. na y-tom stlpci}
        if o[x-z,y]+o[z,y]<min then min:=o[x-z,y]+o[z,y];
      o[x,y]:=min;
      o[y,x]:=o[x,y];    {doplnenie do casti matice sumernej podla diag.}
    end;
  end;
  writeln(o[sir,vys]);
  writeln(fout,o[sir,vys]);
  for x:=1 to 100 do begin
    for y:=1 to 100 do write(fout,o[x,y],' ');
    writeln(fout);
  end;
  Close(fin);
  Close(fout);
END.