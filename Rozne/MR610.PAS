program Mr_sesttodesiatka;
{$I MR610.INC}
{ ----- zobrazenie funkcie ----- }
procedure ZobrazFunkciu;
var Py:word;
begin
  for x:=1 to 299 do PutPixel(x+DisplayX,VGrafe[x],0);
  SetColor(Black);
  Line(DisplayX+1,OsX,DisplayX+299,OsX);
  Line(OsY,DisplayY+1,OsY,DisplayY+199);
  SetColor(LightCyan);
  if (YMax>0) and (YMin<0) then begin      {os X}
    OsX:=Trunc(DisplayY+200+YMin/YRel);
    Line(DisplayX+1,OsX,DisplayX+299,OsX);
  end;
  if (XMax>0) and (XMin<0) then begin       {os Y}
    OSY:=Trunc(DisplayX-XMin/XRel);
    Line(OsY,DisplayY+1,OsY,DisplayY+199);
  end;
  if Func<>'' then
    for x:=DisplayX+1 to DisplayX+299 do begin
      PomW:=x-DisplayX;
      PomX:=XMin+PomW*XRel;
      Hodnoty[PomW]:=LuboRataj(FuncPtr);
      if (Hodnoty[PomW]>YMin+YRel) and (Hodnoty[PomW]<YMax-YRel) then begin
        VGrafe[PomW]:=Trunc(DisplayY+200-200*(Hodnoty[PomW]-YMin)/(YMax-YMin));
        PutPixel(x,VGrafe[PomW],14);
      end;
    end;
end;
{ ----- spracovanie mysi a klavesnice na obrazovke s grafmi ----- }
procedure SpracujUdalost;
var Gs:string;
begin
  OOPStary:=0;OOPAktual:=0;
  repeat
    ZistiPoziciu(sx,sy,Tlacidla);
    OOPAktual:=0;
    for c1:=1 to PocetOOP do              {ci bolo nastavene na iny ovladaci prvok}
      with OOP[c1] do
        if (sx>x) and (sy>y) and (sx<x+dx) and (sy<y+dy)
        and ((PPlocha=Aktivny) or (Aktivny=OVSADE)) then OOPAktual:=c1;
    if OOPAktual<>OOPStary then begin
      SetFillStyle(SolidFill,0);          {vypis help, ak sa mys presunula}
      Bar(0,471,639,479);                 {nad nove tlacidlo}
      SetColor(15);
      if OOPAktual>0 then OutTextXY(0,471,OOP[OOPAktual].Help);
    end;
    OOPStary:=OOPAktual;
    if Keypressed then begin
      ch:=Readkey;
      PomW:=Pos(ch,GKlavesnica);
      if PomW<>0 then begin
        OOPAktual:=PomW;
        Tlacidla:=1;
      end;
    end;
  until (Tlacidla>0) and (OOPAktual>0);
  repeat ZistiPoziciu(sx,sy,Tlacidla); until Tlacidla=0;
  case OOPAktual of
    4:begin                 {XMin}
      SetTextStyle(TriplexFont,HorizDir,2);
      NacitajRiadok(GrafSX+140,GrafSY,150,24,LightCyan,16,Gs);
      SetTextStyle(DefaultFont,HorizDir,1);
      Val(Gs,XMin,Err);
      XRel:=(XMax-XMin)/300;
    end;
    5:begin                  {XMax}
      SetTextStyle(TriplexFont,HorizDir,2);
      NacitajRiadok(GrafSX+140,GrafSY+30,150,24,LightCyan,16,Gs);
      SetTextStyle(DefaultFont,HorizDir,1);
      Val(Gs,XMax,Err);
      XRel:=(XMax-XMin)/300;
    end;
    6:begin                   {YMin}
      SetTextStyle(TriplexFont,HorizDir,2);
      NacitajRiadok(GrafSX+140,GrafSY+60,150,24,LightCyan,16,Gs);
      SetTextStyle(DefaultFont,HorizDir,1);
      Val(Gs,YMin,Err);
      YRel:=(YMax-YMin)/200;
    end;
    7:begin                    {YMax}
      SetTextStyle(TriplexFont,HorizDir,2);
      NacitajRiadok(GrafSX+140,GrafSY+90,150,24,LightCyan,16,Gs);
      SetTextStyle(DefaultFont,HorizDir,1);
      Val(Gs,YMax,Err);
      YRel:=(YMax-YMin)/200;
    end;
    10:begin                    {zadavanie funkcie}
      NacitajRiadok(DisplayX+2,DisplayY+220,600,10,15,8,Func);
      for x:=1 to Length(Func) do Func[x]:=UpCase(Func[x]);
      FuncPtr:=VytvorVyraz(Func);
    end;
    11:begin                     {posun hore}
      YMin:=YMin+10*YRel;
      YMax:=YMax+10*YRel;
    end;
    12:begin                     {posun vlavo}
      XMin:=XMin+10*YRel;
      XMax:=XMax+10*YRel;
    end;
    13:begin                     {posun dole}
      YMin:=YMin-10*YRel;
      YMax:=YMax-10*YRel;
    end;
    14:begin                     {posun vpravo}
      XMin:=XMin-10*YRel;
      XMax:=XMax-10*YRel;
    end;
  end;
  ZobrazFunkciu;
end;
{ ----- inicializacia obrazovky s grafmi ----- }
procedure PriebehFunkcie;
begin
  VypniKurzorMysi;
  ClearDevice;
  SetColor(7);
  Line(0,467,639,467);
  XMin:=-5;XMax:=5;YMin:=-5;YMax:=5;
  XRel:=(XMax-XMin)/300;YRel:=(YMax-YMin)/200;
  SetTextStyle(TriplexFont,HorizDir,2);
  SetColor(10);
  OutTextXY(0,0,' Kalkulacka  Vzorce  Grafy');
  SetTextStyle(DefaultFont,HorizDir,1);
  SetColor(white);
  Rectangle(210,0,290,30);
  SetColor(15);
  Rectangle(DisplayX,DisplayY,DisplayX+300,DisplayY+200);
  Rectangle(DisplayX,DisplayY+220,DisplayX+600,DisplayY+236);
  SetColor(LightRed);
  OutTextXY(DisplayX,DisplayY+210,'Funkcia:');
  SetColor(LightBlue);
  SetTextStyle(TriplexFont,HorizDir,2);
  OutTextXY(GrafSX,GrafSY   ,'XMinimum :');
  OutTextXY(GrafSX,GrafSY+30,'XMaximum :');
  OutTextXY(GrafSX,GrafSY+60,'YMinimum :');
  OutTextXY(GrafSX,GrafSY+90,'YMaximum :');
  SetColor(LightCyan);
  OutTextXY(GrafSX+140,GrafSY   ,SpracujCislo(XMin));
  OutTextXY(GrafSX+140,GrafSY+30,SpracujCislo(XMax));
  OutTextXY(GrafSX+140,GrafSY+60,SpracujCislo(YMin));
  OutTextXY(GrafSX+140,GrafSY+90,SpracujCislo(YMax));
  SetTextStyle(DefaultFont,HorizDir,1);
  VykresliTlacidlo(DGrafX,    DGrafY,    'Lupa+',1);
  VykresliTlacidlo(DGrafX+50, DGrafY,    'Lupa-',1);
  VykresliTlacidlo(GrafSX+100,GrafSY+120,'Hore',11);
  VykresliTlacidlo(GrafSX+50, GrafSY+160,'<-',11);
  VykresliTlacidlo(GrafSX+100,GrafSY+160,'Dole',11);
  VykresliTlacidlo(GrafSX+150,GrafSY+160,'->',11);
  ZapniKurzorMysi;
  for x:=1 to 299 do begin
    Hodnoty[x]:=0;
    VGrafe[x]:=0;
  end;
  repeat
    SpracujUdalost;
  until false;
end;
{ ----- HLAVNY PROGRAM ----- }
BEGIN
  InitGraph(gd,gm,'d:\bp\bgi');
  ZapniKurzorMysi;
  Inicializuj;
  repeat ObsluzUdalost; until Aktual=47;
END.