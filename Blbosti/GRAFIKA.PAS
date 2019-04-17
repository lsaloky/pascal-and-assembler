uses Graph;
const gd:integer=9;
      gm:integer=2;
var i:integer;
BEGIN
  InitGraph(gd,gm,'d:\bp\bgi');
  SetColor(15);
  Line(0,0,639,479);
  Circle(100,100,100);
  for i:=1 to 15 do Bar(0,10*i,639,10*i+9);
  ReadLn;
  CloseGraph;
END.