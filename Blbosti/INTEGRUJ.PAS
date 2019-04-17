program Integracia;
uses App,Objects,Drivers,Menus,TutConst;
type TMojaApp=object(TApplication)
              procedure InitMenuBar;virtual;
              procedure InitStatusLine;virtual;
     end;

procedure TMojaApp.InitStatusLine;
var r:TRect;
begin
  GetExtent(r);
  r.a.y:=r.b.y-1;
  StatusLine:=New(PStatusLine,Init(r,
    NewStatusDef(1,$ffff,
      NewStatusKey('~F1~ help',kbF1,1,nil),
    NewStatusDef(2,$ffff,
      NewStatusKey('~F10~ ponuka',kbF10,1,
    nil),nil))));
end;

procedure TmojaApp.InitMenuBar;
var r:TRect;
begin
  GetExtent(r);
  r.b.y:=r.a.y+1;
  MenuBar:=New(PMenuBar, Init(r,NewMenu(
    NewSubMenu('~R~ozne',500, NewMenu(
      NewItem('~D~iofantos','',kbNoKey,2,1,
      NewItem('D~e~lenie','',kbNoKey,2,1,
      NewItem('~F~aktori ly','',kbNoKey,2,1,
      NewItem('~P~¡','',kbNoKey,2,1,
      NewItem('P~r~asat ','',kbNoKey,2,1,
      NewItem('Prvo~c~¡sla','',kbNoKey,2,1,nil))))))),nil))));
end;
    {hlavny program}
var MojaApp:TMojaApp;
begin
  MojaApp.Init;
  MojaApp.Run;
  MojaApp.done;
end.
