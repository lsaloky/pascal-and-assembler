program Okno;   {Jednoduch‚ dial¢gov‚ okno}
uses App,Dialogs,Views,Objects,Drivers,Menus;
type PMonitorDialog=^TMonitorDialog;    {okno pre zmenu typu monitora}
     TMonitorDialog=object(TDialog)
       constructor Init;
     end;

constructor TMonitorDialog.Init;        {vytvorenie okna}
var p:PView;
    r:TRect;
    Pole:PInputLine;
begin
  r.assign(0,0,38,14);
  inherited Init(r,'Objedn vka monitora');
  options:=Options or ofCentered;
  r.assign(6,2,28,5);
  p:=new(PRadioButtons,Init(r,
    NewsItem('~F~arebny',
    NewsItem('~C~iernobiely',
    NewsItem('~M~onochromaticky',nil)))));
  Insert(p);
  R.Assign(2,7,19,8);
  Insert(New(PLabel,Init(r,'~Z~nacka monitora:',Pole)));
  R.Assign(20,7,36,8);
  Pole:=New(PInputLine,Init(r,16));
  Insert(Pole);
  R.Assign(2,9,16,10);
  Insert(New(PLabel,Init(r,'~P~ocet kusov:',Pole)));
  r.Assign(16,9,25,10);
  Pole:=New(PInputLine,Init(r,7));
  Insert(Pole);
  r.assign(6,11,16,13);
  p:=new(PButton,Init(r,'~O~k',cmOK,bfDefault));
  Insert(p);
  r.assign(18,11,28,13);
  p:=new(pbutton,Init(r,'~Z~rusit',cmCancel,bfNormal));
  Insert(p);
  SelectNext(false);
end;

const cmMonitor=2000;
      TypMonitora:word=1;

type TAplikace=object(TApplication)
                 procedure HandleEvent(var Event:TEvent);virtual;
                 procedure InitMenuBar;virtual;
               end;

procedure TAplikace.InitMenuBar;
var R:TRect;
begin
  GetExtent(r);
  r.b.y:=r.a.y+1;
  MenuBar:=New(PMenuBar,Init(r,NewMenu(
    NewSubMenu('~T~ovar',0,NewMenu(
      NewItem('~M~onitor','',kbNoKey,2000,2000,nil)),nil))));
end;

procedure TAplikace.HandleEvent(var Event:TEvent);
var d:PDialog;
begin
  inherited HandleEvent(Event);
  if (Event.What=evCommand) and (Event.Command=cmMonitor) then begin
    d:=New(PMonitorDialog,Init);
    if ValidView(d) <> nil then begin
      d^.SetData(TypMonitora);
      if desktop^.ExecView(d) <>cmCancel then d^.GetData(TypMonitora);
      Dispose(d,done);
    end;
  end;
  ClearEvent(Event);
end;

var Aplikace:TAplikace;

begin
  Aplikace.Init;
  Aplikace.Run;
  Aplikace.Done;
end.