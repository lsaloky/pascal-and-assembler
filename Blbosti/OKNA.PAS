unit okna;
interface
type PPrijem=^TPrijem;              {dialogove okno pre prijem tovaru}
     TPrijem=object(TDialog)
       constructor Init;
       procedure HandleEvent(var Event:TEvent);virtual;
     end;

     PDialogNovy=^TDialogNovy;      {dialogove okno pre novy druh tovaru}
     TDialogNovy=object(TDialog)
       constructor Init;
       procedure HandleEvent(var Event:TEvent);virtual;
     end;

     PZmena=^TZmena;                {dialogove okno pre zmenu cenz}
     TZmena=object(TDialog)
       constructor Init;
       procedure HandleEvent(var Event:TEvent);virtual;
     end;

     PVydaj=^TVydaj;                 {dialogove okno pre vydaj tovaru}
     TVydaj=object(TDialog)
       constructor Init;
       procedure HandleEvent(var Event:TEvent);virtual;
     end;
implementation
constructor TPrijem.Init;
var R:TRect;
    Pole:PInputLine;
begin
  R.Assign(0,0,38,9);
  inherited Init(r,'Pr¡jem tovaru');
  Options:=Options or OfCentered;
  HelpCTX:=0;
  R.Assign(2,2,16,3);
  Insert(New(PLabel,Init(r,'~N~ zov tovaru:',Pole)));
  R.Assign(18,2,36,3);
  Pole:=New(PInputLine,Init(r,16));
  Insert(Pole);
  R.Assign(2,4,16,5);
  Insert(New(PLabel,Init(r,'~P~ocet kusov:',Pole)));
  r.Assign(18,4,27,5);
  Pole:=New(PInputLine,Init(r,7));
  Insert(Pole);
  R.Assign(13, 6, 23, 8);
  Insert(New(PButton,Init(R,'~O~K',cmOK,bfNormal)));
  SelectNext(False);
end;

procedure TPrijem.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
  if (Event.What = evBroadcast) and
    (Event.Command = Prijem) then
    ClearEvent(Event);
end;

constructor TVydaj.Init;
var R:TRect;
    Pole:PInputLine;
begin
  R.Assign(0,0,38,9);
  inherited Init(r,'Vydaj tovaru');
  Options:=Options or OfCentered;
  HelpCTX:=0;
  R.Assign(2,2,16,3);
  Insert(New(PLabel,Init(r,'~N~ zov tovaru:',Pole)));
  R.Assign(18,2,36,3);
  Pole:=New(PInputLine,Init(r,16));
  Insert(Pole);
  R.Assign(2,4,16,5);
  Insert(New(PLabel,Init(r,'~P~ocet kusov:',Pole)));
  r.Assign(18,4,27,5);
  Pole:=New(PInputLine,Init(r,7));
  Insert(Pole);
  R.Assign(13, 6, 23, 8);
  Insert(New(PButton,Init(R,'~O~K',cmOK,bfNormal)));
  SelectNext(False);
end;

procedure TVydaj.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
  if (Event.What = evBroadcast) and
    (Event.Command = Vydaj) then
    ClearEvent(Event);
end;

constructor TZmena.Init;
var R:TRect;
    Pole:PInputLine;
begin
  R.Assign(0,0,38,9);
  inherited Init(r,'Zmena ceny');
  Options:=Options or OfCentered;
  HelpCTX:=0;
  R.Assign(2,2,16,3);
  Insert(New(PLabel,Init(r,'~N~ zov tovaru:',Pole)));
  R.Assign(18,2,36,3);
  Pole:=New(PInputLine,Init(r,16));
  Insert(Pole);
  R.Assign(2,4,14,5);
  Insert(New(PLabel,Init(r,'Nov  ~c~ena:',Pole)));
  r.Assign(16,4,25,5);
  Pole:=New(PInputLine,Init(r,7));
  Insert(Pole);
  R.Assign(13, 6, 23, 8);
  Insert(New(PButton,Init(R,'~O~K',cmOK,bfNormal)));
  SelectNext(False);
end;

procedure TZmena.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
  if (Event.What = evBroadcast) and
    (Event.Command = Vydaj) then
    ClearEvent(Event);
end;

constructor TDialogNovy.Init;
var R:TRect;
    Pole:PInputLine;
begin
  R.Assign(0,0,40,9);
  inherited Init(r,'Novy tovar');
  Options:=options or ofCentered;
  HelpCTX:=0;
  r.Assign(20,2,38,3);
  Pole:=New(PInputLine,Init(r,16));
  Insert(pole);
  R.Assign(2,2,18,3);
  Insert(New(PLabel,Init(r,'~N~ zov tovaru:',Pole)));
  R.Assign(20,4,30,5);
  Pole:=New(PInputLine,Init(r,8));
  Insert(Pole);
  R.Assign(2,4,19,5);
  Insert(New(Plabel,Init(r,'~J~ednotkov  cena:',Pole)));
  R.Assign(13, 6, 23, 8);
  Insert(New(PButton,Init(R,'~O~K',cmOK,bfNormal)));
  SelectNext(False);
end;

procedure TDialogNovy.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
  if (Event.What = evBroadcast) and
    (Event.Command = Novy) then
    ClearEvent(Event);
end;
end.