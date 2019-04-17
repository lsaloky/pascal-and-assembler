program Ciarove_zaciernenie;
uses Graph,Crt;
const gd:integer=1;
      gm:integer=2;                    {7}
      cesta='d:\bp\bgi';
type Ta=array[1..10000,1..4] of shortint;
var x,y,col,index,z:integer;
    ch:Char;
    a:Ta;
    f:file of Ta;
    f2:text;
BEGIN
  Assign(f,'lines.dat');
  assign(f2,'lines.txt');
  rewrite(f2);
  FillChar(a,SizeOf(a),0);
  Reset(f);
  read(f,a);
  InitGraph(gd,gm,cesta);
  SetFillStyle(1,1);
  Bar(10,10,29,29);
  for z:=1 to 100 do Line(a[z,1]+10,a[z,2]+10,a[z,3]+10,a[z,4]+10);
  index:=a[10000,1];
  SetColor(2);
  x:=10;y:=10;
  repeat
    repeat
      col:=GetPixel(x,y);
      PutPixel(x,y,0);
      Delay(10);
      PutPixel(x,y,col);
      Delay(10);
    until keypressed;
    ch:=ReadKey;
    case ch of
      '2':Inc(y);
      '4':Dec(x);
      '6':Inc(x);
      '8':Dec(y);
      'z':begin
        a[index,1]:=x-10;
        a[index,2]:=y-10;
      end;
      'k':begin
        a[index,3]:=x-10;
        a[index,4]:=y-10;
        Line(a[index,1]+10,a[index,2]+10,a[index,3]+10,a[index,4]+10);
        Inc(index);
      end;
    end;
  until ch='e';
  SetColor(2);
  Bar(40,10,59,29);
  for z:=1 to index-1 do Line(a[z,1]+40,a[z,2]+10,a[z,3]+40,a[z,4]+10);
  Seek(f,0);
  a[10000,1]:=index;
  write(f,a);
  Close(f);
  write(f2,'(');
  for x:=1 to index do write(f2,'(',a[x,1],',',a[x,2],',',a[x,3],',',a[x,4],'),');
  write(f2,index);
END.