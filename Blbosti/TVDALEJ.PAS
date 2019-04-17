program TurboVision1;
uses App,Objects,Menus,Drivers,Views,MsgBox,Dialogs;
const Novy=1000;Prijem=1001;Vydaj=1002;Zmena=1003;
      Stav=1100;Obrat=1101;UCisla=1102;UNazvy=1103;LezPis=1104;LezCena=1105;
      PosPred=1106;PosNak=1107;
      Zapis=1200;Citaj=1201;Info=1202;Koniec=2000;

type PPolozka=^TPolozka;
     TPolozka=record
                n:string[15];
                j:real;
                m:real;
                d:longint;
              end;
     POkenneInfo=^TOkenneInfo;
     TOkenneInfo=record
                   t:string[16];
                   c:string[7];
                 end;
     PPrijem=^TPrijem;              {dialogove okno pre prijem tovaru}
     TPrijem=object(TDialog)
       constructor Init;
     end;
     PNovy=^TNovy;      {dialogove okno pre novy druh tovaru}
     TNovy=object(TDialog)
       constructor Init;
     end;
     PZmena=^TZmena;                {dialogove okno pre zmenu ceny}
     TZmena=object(TDialog)
       constructor Init;
     end;
     PVydaj=^TVydaj;                 {dialogove okno pre vydaj tovaru}
     TVydaj=object(TDialog)
       constructor Init;
     end;
     TMojaApp=object(TApplication)   {samotna aplikacia}
       APolozka:array[1..500] of TPolozka;
       AOkenneInfo:TOkenneInfo;
       ANovy:PNovy;
       APrijem:PPrijem;
       AVydaj:PVydaj;
       AZmena:PZmena;
       procedure InitStatusLine;virtual;
       procedure InitMenuBar;virtual;
       procedure HandleEvent(var Event:Tevent);virtual;
    end;

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

constructor TNovy.Init;
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
  R.Assign(20,4,29,5);
  Pole:=New(PInputLine,Init(r,7));
  Insert(Pole);
  R.Assign(2,4,19,5);
  Insert(New(Plabel,Init(r,'~J~ednotkov  cena:',Pole)));
  R.Assign(13, 6, 23, 8);
  Insert(New(PButton,Init(R,'~O~K',cmOK,bfNormal)));
  SelectNext(False);
end;

procedure TMojaApp.InitStatusLine;
var R:TRect;
begin
  GetExtent(r);
  r.a.y:=r.b.y-1;
  New(StatusLine,Init(r,
    NewStatusDef(Novy,Novy,NewStatusKey('Zadefinovanie noveho druhu tovaru a jednotkovej ceny',0,0,nil),
    NewStatusDef(Prijem,Prijem,NewStatusKey('Pr¡jem tovaru na sklad',0,0,nil),
    NewStatusDef(Vydaj,Vydaj,NewStatusKey('Vydanie tovaru zo skladu',0,0,nil),
    NewStatusDef(Zmena,Zmena,NewStatusKey('Zmena ceny tovaru',0,0,nil),
    NewStatusDef(Stav,Stav,NewStatusKey('Vypis mnozstva, jednotkovej ceny a hodnoty',0,0,nil),
    NewStatusDef(Obrat,Obrat,NewStatusKey('S£cet pr¡jmov, s£cet vydajov, sucet str t z precenenia leziakov',0,0,nil),
    NewStatusDef(UCisla,UCisla,NewStatusKey('Usporiadanie tovaru podla cisel',0,0,nil),
    NewStatusDef(UNazvy,UNazvy,NewStatusKey('Usporiadanie tovaru podla n zvov',0,0,nil),
    NewStatusDef(LezPis,LezPis,NewStatusKey('Vypis leziakov - tovarov, ktor‚ s£ viac ako dany pocet dni na sklade',0,0,nil),
    NewStatusDef(LezCena,LezCena,NewStatusKey('Znizenie ceny leziakov o dan‚ percento a vypis str t',0,0,nil),
    NewStatusDef(PosPred,PosPred,NewStatusKey('Pocet dn¡ od posledneho predaja u dan‚ho tovaru',0,0,nil),
    NewStatusDef(PosNak,PosNak,NewStatusKey('Pocet dn¡ od posledn‚ho n kupu u dan‚ho tovaru',0,0,nil),
    NewStatusDef(Zapis,Zapis,NewStatusKey('Uloz¡ na disk s£casny stav tovarov',0,0,nil),
    NewStatusDef(Citaj,Citaj,NewStatusKey('Precita z disku s£casny stav tovarov',0,0,nil),
    NewStatusDef(Koniec,Koniec,NewStatusKey('Koniec pr ce s programom',0,0,nil),
    NewStatusDef(Info,Info,NewStatusKey('Inform cia o programe',0,0,nil),
      nil))))))))))))))))));
end;

procedure TMojaApp.InitMenuBar;
var R:TRect;
begin
  GetExtent(r);
  r.b.y:=r.a.y+1;
  MenuBar:=New(PMenuBar,Init(r,NewMenu(
    NewSubMenu('~T~ovar',0,NewMenu(
      NewItem('~N~ovy tovar','',kbNoKey,Novy,Novy,
      NewItem('~P~r¡jem na sklad','',kbNoKey,Prijem,Prijem,
      NewItem('~V~ydaj','',kbNoKey,Vydaj,Vydaj,
      NewItem('~Z~mena ceny','',kbNoKey,Zmena,Zmena,
      nil))))),
    NewSubMenu('~I~nfo',0,NewMenu(
      NewItem('~S~tav zasob','',kbNoKey,Stav,Stav,
      NewItem('~O~brat zasob','',kbNoKey,Obrat,Obrat,
      NewItem('Zoradenie podla ~c~isel','',kbNoKey,UCisla,UCisla,
      NewItem('Zoradenie podla ~n~ zvov','',kbNoKey,UNazvy,UNazvy,
      NewItem('~V~ypis leziakov','',kbNoKey,LezPis,LezPis,
      NewItem('~P~recenenie leziakov','',kbNoKey,LezCena,LezCena,
      NewItem('Posledny predaj','',kbNoKey,PosPred,PosPred,
      NewItem('Posledny n kup','',kbNoKey,PosNak,PosNak,
      nil))))))))),
    NewSubMenu('~R~“zne',0,NewMenu(
      NewItem('~Z~ pis d t na disk','',kbNoKey,Zapis,Zapis,
      NewItem('~P~recitanie d t z disku','',kbNoKey,Citaj,Citaj,
      NewItem('~I~nform cia o programe','',kbNoKey,Info,Info,
      NewItem('~K~oniec','Alt+X',kbAltX,cmQuit,Koniec,
      nil))))),
    nil))))));
end;

procedure TMojaApp.HandleEvent(var Event:TEvent);
var r:TRect;
    Navrat:word;
    err:integer;
begin
  inherited HandleEvent(Event);
  if Event.What=evCommand then begin
    case Event.Command of
      Novy:begin
             Navrat:=ExecuteDialog(New(PNovy,Init),POkenneInfo(1));
             InsertWindow(ANovy);
             ANovy^.GetData(AOkenneInfo);
             APolozka[1].n:=AOkenneInfo.t;
             Val(AOkenneInfo.c,APolozka[1].j,err);
           end;
      Prijem:begin
               Navrat:=ExecuteDialog(New(PPrijem,Init),nil);
               InsertWindow(APrijem);
             end;
      Vydaj:begin
              Navrat:=ExecuteDialog(New(PVydaj,Init),nil);
              InsertWindow(AVydaj);
            end;
      Zmena:begin
              Navrat:=ExecuteDialog(New(PZmena,Init),nil);
              InsertWindow(AZmena);
            end;
      Stav:MessageBox(#3'T to funkcia zatial nefunguje.'#13#3'Vyp¡se stav z sob:'#13#3'mnozstvo, jednotkov£ '+
           'cenu'#13#3'a hodnotu v Sk.',nil,1026);
      Obrat:MessageBox(#3'T to funkcia zatial nefunguje.'#13#3'Vyp¡se pociatocny a konecny stav, s£cet'+
            'pr¡jmov a vydajov,'#13#3's£cet str t z precenenia leziakov.',nil,1026);
      UCisla:MessageBox(#3'T to funkcia zatial nefunguje.'#13#3'Vyp¡se vsetok tovar'+
             #13#3'usporiadany podla c¡sel.',nil,1026);
      UNazvy:MessageBox(#3'T to funkcia zatial nefunguje.'#13#3'Vyp¡se vsetok tovar'+
             #13#3'usporiadany podla n zvov.',nil,1026);
      LezPis:MessageBox(#3'T to funkcia zatial nefunguje.'#13#3'Vyp¡se leziaky na sklade.',nil,1026);
      LezCena:MessageBox(#3'T to funkcia zatial nefunguje.'#13#3'Zn¡zi ceny leziakov o dan‚ percento.',nil,1026);
      PosPred:MessageBox(#3'T to funkcia zatial nefunguje.'#13#3'Vyp¡se pocet dn¡ od posledn‚ho predaja.',nil,1026);
      PosNak:MessageBox(#3'T to funkcia zatial nefunguje.'#13#3'Vyp¡se pocet dn¡ od posledn‚ho n kupu.',nil,1026);
      Zapis:MessageBox(#3'T to funkcia zatial nefunguje.'#13#3'Zap¡se vsetky inform cie na disk.',nil,1026);
      Citaj:MessageBox(#3'T to funkcia zatial nefunguje.'#13#3'Prec¡ta vsetky inform cie z disku.',nil,1026);
      Info:MessageBox(#3'Program pre skladov‚ hospod rstvo.'#13#3'Verzia 1.0'#13#3'Autor: Lubos Saloky',
           nil,1026);
    end;
  ClearEvent(Event);
  end;
end;

var MojaApp:TMojaApp;

begin
  MojaApp.init;
  MojaApp.run;
  MojaApp.done;
end.
