program Determinant;
uses Crt;
var a:array[1..4,1..3]of integer;
    x,y,ds,d1,d2,d3:longint;
BEGIN
  TextBackGround(0);ClrScr;
  for x:=1 to 3 do begin
    writeLn(x,'.      * x +     * y +     * z =');
    for y:=1 to 4 do begin
      GotoXY(10*y-6,x);
      readLn(a[y,x]);
    end;
  end;
  ds:=a[1,1]*a[2,2]*a[3,3] + a[2,1]*a[3,2]*a[1,3] + a[3,1]*a[1,2]*a[2,3]
    - a[3,1]*a[2,2]*a[1,3] - a[1,1]*a[3,2]*a[2,3] - a[2,1]*a[1,2]*a[3,3];
  d1:=a[4,1]*a[2,2]*a[3,3] + a[2,1]*a[3,2]*a[4,3] + a[3,1]*a[4,2]*a[2,3]
    - a[3,1]*a[2,2]*a[4,3] - a[4,1]*a[3,2]*a[2,3] - a[2,1]*a[4,2]*a[3,3];
  d2:=a[1,1]*a[4,2]*a[3,3] + a[4,1]*a[3,2]*a[1,3] + a[3,1]*a[1,2]*a[4,3]
    - a[3,1]*a[4,2]*a[1,3] - a[1,1]*a[3,2]*a[4,3] - a[4,1]*a[1,2]*a[3,3];
  d3:=a[1,1]*a[2,2]*a[4,3] + a[2,1]*a[4,2]*a[1,3] + a[4,1]*a[1,2]*a[2,3]
    - a[4,1]*a[2,2]*a[1,3] - a[1,1]*a[4,2]*a[2,3] - a[2,1]*a[1,2]*a[4,3];
  writeln('x= ',d1/ds:1:5);
  writeln('y= ',d2/ds:1:5);
  writeln('z= ',d3/ds:1:5);
  readln;
END.