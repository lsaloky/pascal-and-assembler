program OOP;
{$I Global.Inc}
{$I TOvlPrv.Inc}
{$I TTlacid.Inc}
{$I TMenu.Inc}
var Aktivuj,Skryty:TTlacidlo;
    TheEnd:TTheEnd;
    Hlavne:TMenu;
BEGIN
  InicializujProgram;
  TheEnd.Init(True,10,10,1,'Koniec programu','KONIEC');
  Aktivuj.Init(True,100,10,3,'???','Subor');
  Skryty.Init(False,100,30,4,'qqq','aaa');
  Hlavne.Init(True,100,100,2,'Hlavne menu.','Subor;Posun;Domov','Nadpis');
  repeat
    ZistiPoziciu(sx,sy,Tlacidla);
    sx:=sx div 2;
    BoloNaOvladacomPrvku:=False;
    TheEnd.VypisHelp;
    Aktivuj.VypisHelp;
    Skryty.VypisHelp;
    if (not BoloNaOvladacomPrvku) and (AktualnyIndex>0) then begin
      VypniKurzorMysi;
      Nastav(0,192,0);
      VyplnPlochu(320,8);
      ZapniKurzorMysi;
      AktualnyIndex:=0;
    end;
  until Koniec;
  UkonciProgram;
END.