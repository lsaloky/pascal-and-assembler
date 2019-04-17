program Ahoj_Svet;
uses App,Dialogs,Drivers,Menus,Objects,Views;
const HiWorld=100;
type
  TMyApplication=object(TApplication)
    procedure Pozdrav;
    procedure HandleEvent(var Event:TEvent);virtual;
    procedure InitStatusLine;virtual;
    procedure InitMenuBar;virtual;
  end;
{ -------------------- Metody z TMyApplication --------------------}
procedure TMyApplication.Pozdrav;
var Dialog:PDialog;
    R:TRect;
    Control:word;{vysledok ziskany z ExecView}
begin
  R.Assign(20,8,60,15);
    {nastavenie velkosti vyrezu pre dialogove okno}
  Dialog:=New(PDialog,Init(r,'Hallo world'));
    {inicializacia objektu PDialog,2. parameter constructora je titulok okna}
  R.Assign(8,3,33,5);
    {nastavenie velkosti vyrezu pre tlacidlo Ahoj}
  Dialog^.Insert(New(PButton,Init(R,'Ahoj',cmOk,bfNormal)));
    {volanie metody Insert zdedenej po TGroup. Vsuva sa tlacidlo (PButton)}
  Control:=Desktop^.ExecView(Dialog);
    {vykonanie dialogu}
end;
procedure TMyApplication.InitStatusLine;
var r:TRect;
begin
  r.Assign(0,24,80,25);
    {nastavenie velkosti vyrezu pre stavovy riadok}
  StatusLine:=New(PStatusLine,Init(r,NewStatusDef(0,$ffff,
    NewStatusKey('~Alt-x~ Exit',kbAltX,cmQuit,
    NewStatusKey('~F2~ Pozdrav',kbF2,HiWorld,nil)), {NewStatusKey}
  nil))); {2. nil k NewStatusDef}
end;
procedure TMyApplication.HandleEvent;
begin
  inherited HandleEvent(Event);
  if Event.What=evCommand then begin
    if Event.Command=HiWorld then Pozdrav
    else Exit;
    ClearEvent(Event);     {odstran udalost z radu udalosti}
  end;
end;
procedure TMyApplication.InitMenuBar;
var r:TRect;
begin
  r.Assign(0,0,80,1);
  MenuBar:=New(PMenuBar,Init(r,NewMenu(
    NewSubMenu('~V~itaj',hcNoContext,NewMenu(
      NewItem('~P~ozdrav','F2',kbF2,HiWorld,hcNoContext,
      NewItem('~E~xit','Alt-X',kbAltX,cmQuit,hcNoContext,
    nil))),
  nil))));
end;
var MyApp:TMyApplication;
{ -------------------- Hlavny program --------------------}
BEGIN
  MyApp.Init;
  MyApp.Run;
  MyApp.Done;
END.

