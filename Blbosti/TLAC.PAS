program Star_LC20;   {obsluzny program}
uses Memory,Drivers,Objects,Views,Menus,App,MsgBox,Editors,StdDlg,Dialogs,Printer;
var s:array[1..10] of String;
    x:integer;
const cmMonitor=2000;
      TypMonitora:word=0;
type TTlac=object(TApplication)
             procedure InitMenuBar;virtual;
             procedure HandleEvent(var Event: TEvent); virtual;
           end;
     PMonitorDialog=^TMonitorDialog;    {okno pre zmenu typu monitora}
     TMonitorDialog=object(TDialog)
       constructor Init;
     end;

constructor TMonitorDialog.Init;        {vytvorenie okna}
var p:PView;
    r:TRect;
begin
  r.assign(0,0,34,9);
  inherited Init(r,'Demo verzia riadkovania');
  options:=Options or ofCentered;
  r.assign(6,2,28,5);
  p:=new(PRadioButtons,Init(r,
  NewsItem('1/8 palca',
  NewsItem('7/72 palca',
  NewsItem('1/6 palca',nil)))));
  Insert(p);
  r.assign(6,6,16,8);
  p:=new(PButton,Init(r,'~O~k',cmOK,bfDefault));
  Insert(p);
  r.assign(18,6,28,8);
  p:=new(pbutton,Init(r,'~Z~rusit',cmCancel,bfNormal));
  Insert(p);
  SelectNext(false);
end;

procedure TTlac.InitMenuBar;
var r:TRect;
    s:string;
begin
  GetExtent(r);
  r.b.y:=r.a.y+1;
  MenuBar:=New(PMenubar, Init(r, NewMenu(
    NewSubMenu('~F~ont',hcnoContext,NewMenu(
      NewItem('~D~raft','',kbNoKey,21,hcNoContext,
      NewItem('~C~ourier','',kbNoKey,22,hcNoContext,
      NewItem('~S~ansserif','',kbNoKey,23,hcNoContext,
      NewItem('Orator s ~M~alymi pismenami','',kbNoKey,24,hcNoContext,
      NewItem('Orator s ~V~elkymi pismenami','',kbNoKey,25,hcNoContext,
      nil)))))),
    NewSubMenu('~T~ext',hcNoContext,NewMenu(
      NewSubMenu('~P~ocet znakov na palec',hcNoContext,NewMenu(
        NewItem('10 znakov na palec','',kbNoKey,311,hcNoContext,
        NewItem('12 znakov na palec','',kbNoKey,312,hcNoContext,
        NewItem('17 znakov na palec','',kbNoKey,313,hcNoContext,
        NewItem('20 znakov na palec','',kbNoKey,314,hcNoContext,
        nil))))),
      NewSubMenu('~P~roporcion lne p¡smo',hcNoContext,NewMenu(
        NewItem('~A~no','',kbNoKey,321,hcNoContext,
        NewItem('~N~ie','',kbNoKey,322,hcNoContext,
        nil))),
      NewItem('Dvojit  ~V~yska','',kbNoKey,100,hcNoContext,
      NewItem('Dvojit  ~S~¡rka','',kbNoKey,100,hcNoContext,
      nil))))),
    NewSubMenu('~S~tr nka',hcNoContext,NewMenu(
      NewItem('~Z~aciatok str nky','',kbNoKey,71,hcNoContext,
      NewItem('~D~lzka str nky','',kbNoKey,100,hcNoContext,
      NewItem('~R~iadkovanie','',kbNoKey,2000,hcNoContext,
      NewItem('~P~ravy okraj','',kbNoKey,74,hcNoContext,
      NewItem('~L~avy okraj','',kbNoKey,75,hcNoContext,
      NewSubMenu('~Z~arovn vanie',hcNoContext,NewMenu(
        NewItem('S~p~rava','',kbNoKEy,761,hcNoContext,
        NewItem('Z~l~ava','',kbNoKey,762,hcNoContext,
        NewItem('~C~entrovanie','',kbNoKey,763,hcNoContext,
        nil)))),
      nil))))))),
    NewSubMenu('~P~osuny',hcNoContext,NewMenu(
      NewItem('Do~p~redu o 1 riadok','',kbNoKey,41,hcNoContext,
      NewItem('Do~z~adu o 1 riadok','',kbNoKey,42,hcNoContext,
      NewItem('Mikroposun dopredu','',kbNoKey,43,hcNoContext,
      NewItem('Mikroposun dozadu','',kbNoKey,44,hcNoContext,
      NewItem('Na zaciatok strany','',kbNoKey,45,hcNoContext,
      NewItem('Vysun papier','',kbNoKey,46,hcNoContext,
      nil))))))),
    NewSubMenu('~R~“zne',hcNoContext,NewMenu(
      NewItem('O~n~ line','F7',kbF7,51,hcNoContext,
      NewItem('O~f~f line','F8',kbF8,52,hcNoContext,
      NewItem('~Z~voncek','',kbNoKey,53,hcNoContext,
      NewSubMenu('Pre~s~krtnut  nula',hcNoContext,NewMenu(
        NewItem('~A~no','',kbNoKey,541,hcNoContext,
        NewItem('~N~ie','',kbNoKey,542,hcNoContext,
        nil))),
      NewItem('~R~eset tlaciarne','',kbNoKey,55,hcNoContext,
      NewSubMenu('~T~ich  tlac',hcNoContext,NewMenu(
        NewItem('~A~no','',kbNoKey,561,hcNoContext,
        NewItem('~N~ie','',kbNoKey,562,hcNoContext,
        nil))),
      NewSubMenu('~O~bojsmern  tlac',hcNoContext,NewMenu(
        NewItem('~A~no','',kbNoKey,571,hcNoContext,
        NewItem('~N~ie','',kbNoKey,572,hcNoContext,
        nil))),
      NewItem('~D~emo text','F9',kbF9,58,hcNoContext,
      nil))))))))),
    NewSubMenu('~K~onfigur cia',hcnoContext,NewMenu(
      NewItem('~I~nfo','',kbNoKey,61,hcNoContext,
      NewItem('~Z~mena rozl¡senia','',kbNoKey,62,hcNoContext,
      NewItem('~Z~obraz z sobn¡k','',kbNoKey,100,hcNoContext,
      nil)))),
    nil)))))))));
end;

procedure TTlac.HandleEvent(var Event: TEvent);
var R:TRect;
    s:string;
    x,count,hustota:integer;

procedure OknoVstupne(hore:string);
var x:word;
begin
  x:=InputBox(hore,'',s,25);
end;

procedure Monitor;
  var d:PDialog;
  begin
    d:=New(PMonitorDialog,Init);
    if ValidView(d) <> nil then begin
      d^.SetData(TypMonitora);
      if desktop^.ExecView(d) <>cmCancel then d^.GetData(TypMonitora);
      Dispose(d,done);
    end;
  end;
begin
  inherited HandleEvent(Event);
  if Event.What = evCommand then
  begin
    case Event.Command of
      100:begin
          MessageBox(#3'Zatial tento pr¡kaz'#13#3'nefunguje.'+
          #13#3'Je to len demoverzia.',nil,MfInformation or MfOkButton);
          ClearEvent(Event);
        end;
      21:write(lst,#40#40#70#41#41#57);    {ok}
      22:write(lst,#40#40#70#41#41#48);    {ok}
      23:write(lst,#40#40#70#41#41#49);    {ok}
      24:write(lst,#40#40#70#41#41#55);    {ok}
      25:write(lst,#40#40#70#41#41#56);    {ok}
      311:begin
            write(lst,#27#80#18);            {ok}
            hustota:=1;
          end;
      312:begin
            write(lst,#27#77#18);            {ok}
            hustota:=2;
          end;
      313:begin
            write(lst,#27#80#15);            {ok}
            hustota:=3;
          end;
      314:begin
            write(lst,#27#77#15);            {ok}
            hustota:=4;
          end;
      321:write(lst,#27#112#49);           {ok}
      322:write(lst,#27#112#48);           {ok}
      41:write(lst,#10);                   {ok}
      42:write(lst,#27#10);
      43:write(lst,#27#74#1);              {ok}
      44:write(lst,#27#106#1);             {ok}
      45:write(lst,#27#12);
      46:write(lst,#12);                   {ok}
      51:write(lst,#17);
      52:write(lst,#19);
      53:write(lst,#7);                    {ok}
      541:write(lst,#27#126#49);           {ok}
      542:write(lst,#27#126#48);           {ok}
      55:write(lst,#27#64);
      561:write(lst,#27#115#49);           {ok}
      562:write(lst,#27#115#48);           {ok}
      571:write(lst,#27#85#48);            {ok}
      572:write(lst,#27#85#49);            {ok}
      58:write(lst,'Demo text - Vela stastia pri tlacen¡ praje STAR LC 20'#10);
      61:begin
           MessageBox(#3'Univerz lny program'#13#3'pre tlaciaren'#13#3'v standardnom m¢de'#13 +
           #3'Programoval: Lubos Saloky'#13,nil, mfInformation or mfOKButton);
           ClearEvent(Event);
         end;
      62:begin
          SetScreenMode(ScreenMode xor smFont8x8);
          ClearEvent(Event);
         end;
      74:begin
           case hustota of
             1:s:='80';
             2:s:='96';
             3:s:='137';
             4:s:='160';
             else s:='80';
           end;
           OknoVstupne('Pravy okraj');
           Val(s,x,count);
           write(lst,#27#81,chr(x));
         end;
      75:begin
           s:='0';
           OknoVstupne('Lavy okraj');
           Val(s,x,count);
           write(lst,#27#108,Chr(x));
         end;
      761:write(lst,#27#97#50);
      762:write(lst,#27#97#48);
      763:write(lst,#27#97#49);
      2000:begin
             Monitor;
             ClearEvent(Event);
           end;
    end;
  end;
end;

var Tlac:TTlac;
    lst:text;
begin
  Tlac.Init;
  Tlac.Run;
  Tlac.Done;
end.