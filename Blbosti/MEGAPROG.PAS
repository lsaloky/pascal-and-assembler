program Integracia_s_Turbo_Vision;
uses Objects,Drivers,Views,Menus,App,MsgBox;
const dio=1;
      e=2;
      prvocis=3;
      faktorial=4;
      pi=5;
      prasata=6;
      sito=7;
      AltX=1;

type TMojaApp=object(TApplication)
                procedure InitMenuBar;virtual;
                procedure HandleEvent(var Event:TEvent);virtual;
                procedure InitStatusLine;virtual;
              end;

procedure TMojaApp.HandleEvent(var Event:TEvent);
var r:TRect;

procedure Prvocisla;
var x,y,pom1:longint;
    a,b,c:integer;
    s,t:string;
begin
  s:='7';pom1:=0;
  a:=InputBox('Zadaj cislo:','',s,25);
  t:=Copy(s,5,5);
  for c:=5 to 9 do s[c]:=' ';
  Val(s,a,c);
  Val(t,b,c);
  if (a<>0) or (b<>7) then MessageBox(#3'Chyba.',nil,$0002 or $0400);
  x:=a*10000+b;
  for y:=2 to trunc(sqrt(x)) do if x mod y=0 then pom1:=1;
  if pom1=0 then MessageBox(#3'Cislo je prvocislo.',nil,$0002 or $0400)
    else MessageBox(#3'Cislo nie je prvocislo',nil,$0002 or $0400);
end;

begin
  inherited HandleEvent(Event);
  case Event.Command of
    prvocis:Prvocisla;
  end;
end;

procedure TMojaApp.InitMenuBar;
var r:TRect;
begin
  GetExtent(r);
  r.b.y:=r.a.y+1;
  MenuBar:=New(PMenuBar,Init(r,NewMenu(
    NewSubMenu('~M~atematika',AltX,NewMenu(
      NewItem('~D~iofantovske rovnice','',kbNoKey,dio,AltX,
      NewItem('Vypocet cisla ~e~','',kbnoKey,e,AltX,
      NewItem('Test na ~p~rvocislo','',kbNoKey,prvocis,AltX,
      NewItem('Vypocet ~f~aktorialu','',kbNoKey,faktorial,AltX,
      NewItem('Vypocet cisla pi','',kbNoKey,pi,AltX,
      NewItem('Riesenie ulohy s prasatami','',kbNoKey,prasata,AltX,
      NewItem('~E~rastotenovo sito','',kbNoKey,sito,AltX,
    nil)))))))),
  nil))));
end;

procedure TMojaApp.InitStatusLine;
var r:TRect;
begin
  GetExtent(r);
  r.a.y:=r.b.y-1;
  StatusLine:=New(PStatusLine,Init(r,
    NewStatusDef(1,$ffff,
      NewStatusKey('~F10~ ponuka',kbF10,cmMenu,
      NewStatusKey('~Alt-X~ koniec',kbAltX,cmQuit,nil)),
    nil)));
end;

var MojaApp:TMojaApp;
begin
  MojaApp.Init;
  MojaApp.Run;
  MojaApp.Done;
end.