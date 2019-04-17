program TurboVision_1;
uses Objects,Drivers,Views,Menus,App;
type nieco=object(TApplication)
           WinCount: Integer;

           procedure InitMenuBar;virtual;
           procedure InitStatusLine;virtual;
           procedure HandleEvent(var Event: TEvent); virtual;

     end;

procedure nieco.HandleEvent(var Event: TEvent);
var r: TRect;
begin
      inherited HandleEvent(Event);
  if Event.What=evCommand then
  begin
    if Event.Command=2000 then begin
      Inc(WinCount);
      Desktop^.GetExtent(R);
      InsertWindow(New(PWindow, Init(R, 'Test window', WinCount)));
    end;
  end;
end;

procedure nieco.InitMenuBar;
var r:TRect;
begin
  GetExtent(r);
  r.b.y:=r.a.y+1;
  MenuBar:=New(PMenuBar, Init(r,NewMenu(
    NewSubMenu('~S~£bor',500,NewMenu(StdFileMenuItems(nil)),
    NewSubMenu('~E~dit cia',500,NewMenu(StdEditMenuItems(nil)),
    NewSubMenu('~O~kno',500,NewMenu(StdWindowMenuItems(nil)),
    NewSubMenu('~P~r¡kazy',500,NewMenu(
      NewItem('~N~ov‚ okno','',kbNoKey,2000,hcNoContext,
      NewItem('~D~elenie na X des. miest','',kbNoKey,2,0,
      NewItem('~E~rastothenovo sito','',kbNoKey,2,0,nil)))),nil)))))));
end;

procedure nieco.InitStatusLine;
var r:TRect;
begin
  GetExtent(r);
  r.a.y:=r.b.y-1;
  StatusLine:=New(PStatusLine,Init(r,
    NewStatusDef(10000,$ffff,
      NewStatusKey('~F1~ help',kbF1,cmHelp,nil),
    NewStatusDef(0,$ffff,
      NewStatusKey('~F10~ ponuka',kbF10,cmMenu,
      NewStatusKey('~Alt-X~ koniec',kbAltX,cmQuit,nil)),
    nil))));
end;

var cosi:nieco;
begin
  cosi.Init;
  cosi.Run;
  cosi.done;
end.

