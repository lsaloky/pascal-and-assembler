program Kresli_v_640x400;
uses MainGr,PomGr,Mys,Graph;
const gd:integer=9;
      gm:integer=2;
{$I D:\LUBO\PASCAL\EDITORY\MTF\MTFEDIT.PAS}

BEGIN
{  InitGraph(gd,gm,'d:\bp\bgi');}
  Font.Init;
{  Menu.Init;}
  Font.NahrajFont;
  Menu.VypisText(100,100,5,'lubossaloky');
  SetColor(15);
  Line(100,100,200,200);
  ReadLn;
  ReadLn;
{  CloseGraph;}
END.

