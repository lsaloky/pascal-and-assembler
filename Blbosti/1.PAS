program vyries_sustavu_n_rovnic_o_n_neznamych;
uses Crt;
var matica2:array[1..10,1..9]of real;
    pom1,pom2:real;
    x,y,z:integer;
begin
  TextBackGround(0);ClrScr;
  for x:=1 to 3 do begin
    writeLn(x,'.      * x +     * y +     * z =');
    for y:=1 to 4 do begin
      GotoXY(10*y-6,x);
      read(pom1);
      matica2[y,x]:=pom1;
    end;
  end;
  for z:=1 to 3 do begin
    for x:=3 downto z+1 do begin
      pom1:=matica2[z,z];
      pom2:=matica2[z,x];
      for y:=z to 4 do
        matica2[y,x]:=matica2[y,z]*pom2-matica2[y,x]*pom1;
    end;
  end;
  for x:=3 downto 1 do begin
    pom1:=matica2[4,x]/matica2[x,x];
    writeln(Chr(119+x),'=',pom1:5:3);
    for y:=1 to 3 do begin
      matica2[4,y]:=matica2[4,y]-pom1*matica2[x,y];
    end;
  end;
  repeat until keypressed;
end.
