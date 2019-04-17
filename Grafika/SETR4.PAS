program WizardOfWor;
uses Graph,Crt;
const pocet=80;
var Gd,Gm:Integer;
    hviezda:array[1..pocet,1..2] of integer;
    x,y:Word;
    ch:char;
begin
  Gd:=9;gm:=2;
  InitGraph(Gd,Gm,'d:\bp\bgi');
  ClearDevice;
  for x:=1 to pocet do begin
    hviezda[x,1]:=random(640);
    hviezda[x,2]:=random(480);
  end;
  repeat
    for x:=1 to 8 do begin
      for y:=1 to pocet do begin
        SetColor(y mod 16);
        MoveTo(hviezda[y,1]+15-2*x,15+hviezda[y,2]);
        Lineto(hviezda[y,1]+15,15-2*x+hviezda[y,2]);
        LineTo(hviezda[y,1]+15+2*x,15+hviezda[y,2]);
        LineTo(hviezda[y,1]+15,15+2*x+hviezda[y,2]);
        LineTo(hviezda[y,1]+15-2*x,15+hviezda[y,2]);
      end;
      delay(30);
      for y:=1 to pocet do begin
        SetColor(0);
        MoveTo(hviezda[y,1]+15-2*x,15+hviezda[y,2]);
        Lineto(hviezda[y,1]+15,15-2*x+hviezda[y,2]);
        LineTo(hviezda[y,1]+15+2*x,15+hviezda[y,2]);
        LineTo(hviezda[y,1]+15,15+2*x+hviezda[y,2]);
        LineTo(hviezda[y,1]+15-2*x,15+hviezda[y,2]);
      end;
      for y:=1 to pocet do begin
        hviezda[y,1]:=hviezda[y,1]+random(7)-3;
        hviezda[y,2]:=hviezda[y,2]+random(7)-3;
      end;
    end;
  until keypressed;
  Readln;
  CloseGraph;
end.