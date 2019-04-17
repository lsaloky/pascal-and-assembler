program Funny_Turbo_Vision;     { skutocne? }
uses Objects,App,Menus,Dialogs,Drivers,Views,MsgBox;
type TMojaApp=object(TApplication)
                procedure InitMenuBar;virtual;
                procedure HandleEvent(var event:TEvent);virtual;
                procedure InitStatusLine;virtual;
              end;

procedure TMojaApp.InitMenuBar;
var r:TRect;
begin
  r.Assign(0,0,80,1);
  MenuBar:=New(PMenuBar,Init(r,NewMenu(
    NewSubMenu('~P~ocasie',0,NewMenu(
      NewItem('~D~nes','',0,10,1,
      NewItem('~Z~ajtra','',0,11,2,nil))),
    NewSubMenu('~V~ietor',1,NewMenu(
      NewItem('~S~ila vetra','',0,20,3,
      NewItem('s~M~er','',0,21,4,nil))),
    NewSubMenu('v~S~elico',0,NewMenu(
      NewItem('~Q~uit','Alt-X',kbAltX,cmQuit,5,
      NewItem('~Z~adanie mena','',0,32,6,
      NewItem('~V~lastnik licencie','',0,33,7,
      nil)))),
    nil))))));
end;

procedure TMojaApp.InitStatusLine;
var r:TRect;
begin
  r.Assign(0,24,80,25);
  StatusLine:=New(PStatusLine,Init(r,
    NewStatusDef(1,1,NewStatusKey('Vypise dnesne pocasie',0,0,nil),
    NewStatusDef(2,2,NewStatusKey('Vypise pocasie na zajtra',0,0,nil),
    NewStatusDef(3,3,NewStatusKey('Vypise silu vetra',0,0,nil),
    NewStatusDef(4,4,NewStatusKey('Vypise smer vetra',0,0,nil),
    NewStatusDef(5,5,NewStatusKey('Ukonci program',0,0,nil),
    NewStatusDef(6,6,NewStatusKey('Zadanie mena vlastnika programu',0,0,nil),
    NewStatusDef(7,7,NewStatusKey('Informacia o vlastnikovi produktu',0,0,nil),
  nil)))))))));
end;

procedure TMojaApp.HandleEvent;
var s:string;

procedure Meno;
var x:word;
begin
  s:='Lubo';
  x:=InputBox('Zadaj svoje meno:','',s,25);
end;                           {of Meno}

begin                          {zacina HandleEvent}
  inherited HandleEvent(Event);
  if Event.What=evCommand then begin
    case Event.Command of                          {mfXXXX}
      10:MessageBox(#3'Dnes je pekne pocasie.',nil,$0002 or $0400);
      11:MessageBox(#3'Zajtra bude prsat.'#13#3'Priprav si dazdnik',nil,$0002 or $0400);
      20:MessageBox(#3'Sila vetra je 12 km/h.',nil,$0002 or $0400);
      21:MessageBox(#3'Smer vetra: Zapadny',nil,$0002 or $0400);
      32:Meno;
      33:MessageBox(#3'Vlastnik licencie:'#13#3+s,nil,$0002 or $0400);
    end;
  ClearEvent(Event);
  end;
end;

var MojaApp:TMojaApp;
begin
  MojaApp.Init;
  MojaApp.Run;
  MojaApp.Done;
end.
