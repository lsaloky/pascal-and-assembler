program Lampy;
var pocetuloh,pocetlamp,x,y,z,t,suc:word;
    s:string;
    a,pova:array[1..3,1..3] of byte;
    fin,fout:text;
    zmensilo:boolean;
procedure Neguj(r:byte);
begin
  for z:=1 to 3 do a[r,z]:=1-a[r,z];
end;
label 1;
BEGIN
  Assign(fin,'lampy.in');
  Reset(fin);
  Assign(fout,'lampy.out');
  Rewrite(fout);
  readln(fin,pocetuloh);
  for t:=1 to pocetuloh do begin
    readln(fin,pocetlamp);
    for x:=1 to 3 do
      for y:=1 to 3 do
        a[x,y]:=0;
    for x:=1 to pocetlamp do begin
      readln(fin,s);
      a[Ord(s[1])-48,Ord(s[2])-64]:=1;
    end;
    move(a,pova,9);
    repeat
      x:=0;
      zmensilo:=false;
      while x<8 do begin
        if x>3 then Neguj(3);
        case x of
          1,5:Neguj(1);
          2,6:Neguj(2);
          3,7:begin
            Neguj(1);
            Neguj(2);
          end;
        end;
        for y:=1 to 3 do
          if a[1,y]+a[2,y]+a[3,y]=3 then begin
            a[1,y]:=0;
            a[2,y]:=0;
            a[3,y]:=0;
          end;
        suc:=0;
        for z:=1 to 3 do
          for y:=1 to 3 do
            suc:=suc+a[z,y];
        if suc=0 then writeln(fout,'Da sa');
        if (suc=1) or (suc=2) then writeln(fout,'Neda sa');
        if suc<3 then goto 1;
        move(pova,a,9);
        inc(x);
      end;
    until suc>2;
 1:
    readln(fin);
  end;
  Close(fin);
  Close(fout);
END.
