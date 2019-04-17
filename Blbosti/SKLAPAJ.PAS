program Sklapanie_stvorca;
uses Graph,Crt;
var gd,gm,i:integer;
    ch:char;
begin
  InitGraph(gd,gm,'d:\bp\bgi');
  Line(200,260,430,260);
  for i:=1 to 70 do begin
    Delay(20);
    SetColor(black);
    Line(200,260,199+(i+1) div 2,149+i);
    Line(200,149+i,430,149+i);
    Line(430,260,431-(i+1) div 2,149+i);
    SetColor(white);
    Line(200,260,200+i div 2,150+i);
    Line(200+i div 2,150+i,430-i div 2,150+i);
    Line(430,260,430-i div 2,150+i);
  end;
  readln;
end.
