program Kufor;
uses Crt,Graph;
const gd:integer=9;
      gm:integer=2;
      level=900;
var a:array[1..3] of word;
    skore,x,y:word;
    skoreS:string;
    ch:char;

procedure Kresli(b:integer);
begin
  if a[b]=1 then circle(120+(b-1)*200,200,10);
  if a[b]=2 then begin
    circle(190+(b-1)*200,130,10);
    circle(50+(b-1)*200,270,10);
  end;
  if a[b]=3 then begin
    circle(190+(b-1)*200,130,10);
    circle(50+(b-1)*200,270,10);
    circle(120+(b-1)*200,200,10);
  end;
  if a[b]=4 then begin
    circle(190+(b-1)*200,130,10);
    circle(50+(b-1)*200,270,10);
    circle(190+(b-1)*200,270,10);
    circle(50+(b-1)*200,130,10);
  end;
  if a[b]=5 then begin
    circle(190+(b-1)*200,130,10);
    circle(50+(b-1)*200,270,10);
    circle(190+(b-1)*200,270,10);
    circle(50+(b-1)*200,130,10);
    circle(120+(b-1)*200,200,10);
  end;
  if a[b]=6 then begin
    circle(190+(b-1)*200,130,10);
    circle(50+(b-1)*200,270,10);
    circle(190+(b-1)*200,270,10);
    circle(50+(b-1)*200,130,10);
    circle(190+(b-1)*200,200,10);
    circle(50+(b-1)*200,200,10);
  end;
end;

begin
  Randomize;
  Skore:=7;
  InitGraph(gd,gm,'d:\bp\bgi');
  SetTextStyle(3,HorizDir,0);
  OutTextXY(10,10,'Skore:');
  OutTextXY(110,10,'7');
  MoveTo(20,100);
  LineTo(620,100);
  LineTo(620,300);
  LineTo(20,300);
  LineTo(20,100);
  Line(220,100,220,300);
  Line(420,100,420,300);
  SetFillStyle(1,0);
  for x:=1 to 8 do begin
    repeat
      a[1]:=random(6)+1;a[2]:=random(6)+1;a[3]:=random(6)+1;
      SetColor(15);
      for y:=1 to 3 do Kresli(y);
      Sound(1000);
      Delay(100);
      NoSound;
      Delay(level);
      SetColor(0);
      for y:=1 to 3 do Kresli(y);
    until keypressed;
    ch:=ReadKey;
    if (a[1]=a[2]) or (a[2]=a[3]) or (a[1]=a[3]) then skore:=skore*2
      else Skore:=skore div 2;
    Bar(110,10,210,60);
    Str(skore,skoreS);
    SetColor(15);
    OutTextXY(110,10,skoreS);
  end;
  readln;
  CloseGraph;
end.
