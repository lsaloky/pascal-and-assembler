program Primitivny_editor_fontov;
uses Crt,MukoGr,Myska,Graph;
type TNewFont=array[0..255,0..63] of byte;
const Rozmer=5;Raster=10;                                      {rozmer palety a rastra}
      PaletaX=200;PaletaY=110;                                 {paleta}
      PismX=200;PismY=10;                                      {raster}
      PanelX=10;PanelY=130;                                    {ovl. panel}
      PocetOP=6;
      NazovFontu='d:\lubo\pascal\units\Prechod.mf';
      Aktiv:array[1..PocetOP,1..4] of word=(
        (0,0,127,127),                                         {vsetky pismena}
        (PaletaX,PaletaY,PaletaX+16*Rozmer,PaletaY+16*Rozmer), {paleta}
        (PismX,PismY,PismX+8*Raster,PismY+8*Raster),           {raster}
        (PanelX,PanelY,PanelX+40,PanelY+16),                   {uloz}
        (PanelX+48,PanelY,PanelX+104,PanelY+16),               {koniec}
        (PanelX,PanelY+24,PanelX+40,PanelY+40));               {zmaz}
      OLH:array[0..PocetOP] of string[40]=(
        '','VYBER SI PISMENO','VYBER SI FARBU','KRESLI PISMENO',
        'ULOZ FONT','KONIEC PROGRAMU','ZMAZANIE PISMENA');
var x,y,Udalost,UStara,PomX,PomY,z,Farba,Pismeno,KreslColor:word;
    gd,gm:integer;
    Tlacidla:byte;
    NewFont:TNewFont;
    f:file of TNewFont;
procedure VypisRiadokPismen;
var s:string;
    p1:byte;
begin
  Nastav(0,184,0);
  VyplnPlochu(168,8);
  s:=Chr(Pismeno);
  for p1:=0 to 10 do begin
    Nastav(8*p1,184,0);
    VypisPriehladne(s+' ',p1);
  end;
end;
BEGIN
{ ----- inicializacia a kreslenie ovladacich prvkov ----- }
  InicializujGrafiku;
  Assign(f,NazovFontu);
  Reset(f);
  Read(f,NewFont);
  Close(f);
  NacitajFontAPaletu(NazovFontu);
  Nastav(Aktiv[4,1],Aktiv[4,2],14);
  Ramcek(Aktiv[4,3]-Aktiv[4,1],Aktiv[4,4]-Aktiv[4,2],0);
  Nastav(Aktiv[4,1]+4,Aktiv[4,2]+4,0);
  Color:=15;VypisPriehladne('ULOZ',1);
  Nastav(Aktiv[5,1],Aktiv[5,2],14);
  Ramcek(Aktiv[5,3]-Aktiv[5,1],Aktiv[5,4]-Aktiv[5,2],0);
  Nastav(Aktiv[5,1]+4,Aktiv[5,2]+4,0);
  Color:=15;VypisPriehladne('KONIEC',2);
  Nastav(Aktiv[6,1],Aktiv[6,2],14);
  Ramcek(Aktiv[6,3]-Aktiv[6,1],Aktiv[6,4]-Aktiv[6,2],0);
  Nastav(Aktiv[6,1]+4,Aktiv[6,2]+4,0);
  Color:=15;VypisPriehladne('ZMAZ',3);
  Farba:=0;Pismeno:=0;KreslColor:=16;
  Nastav(Aktiv[5,3]+8,Aktiv[5,2],Farba);
  VyplnPlochu(40,40);
  for x:=0 to 15 do
    for y:=0 to 15 do begin
      Nastav(PaletaX+Rozmer*x,PaletaY+Rozmer*y,x+16*y);
      VyplnPlochu(Rozmer,Rozmer);
    end;
  for x:=0 to 7 do
    for y:=0 to 7 do PolozBod(PismX+Raster*x,PismY+Raster*y,15);
  Nastav(PismX+8*Raster+1,PismY-2,15);
  CiaraZvisla(8*Raster+3);
  Nastav(PismX-2,PismY+8*Raster,15);
  CiaraVodorovna(8*Raster+4);
  Nastav(PismX-2,PismY-2,15);
  CiaraZvisla(8*Raster+3);
  CiaraVodorovna(8*Raster+4);
  for y:=0 to 15 do
    for x:=0 to 15 do begin
      Nastav(8*x,8*y,16);
      VypisPriehladne(Chr(16*y+x)+' ',1);
    end;
  ZapniKurzorMysi;
{ ----- obsluha udalosti ----- }
  UStara:=0;
  repeat
    repeat
      ZistiPoziciu(x,y,Tlacidla);
      x:=x div 2;
      Udalost:=0;
      for z:=1 to PocetOP do
        if (x>=Aktiv[z,1]) and (x<=Aktiv[z,3]) and (y>=Aktiv[z,2]) and (y<=Aktiv[z,4]) then Udalost:=z;
      if Udalost<>UStara then begin
        VypniKurzorMysi;
        Nastav(0,192,0);
        VyplnPlochu(320,8);
        Color:=16;VypisPriehladne(OLH[Udalost],5);
        UStara:=Udalost;
        ZapniKurzorMysi;
      end;
    until Tlacidla=1;
    if Udalost<>2 then repeat ZistiPoziciu(PomX,PomY,Tlacidla); until Tlacidla=0;
{ ----- spracovanie udalosti ----- }
    case Udalost of
      1:begin{vyber pismena}
        Pismeno:=16*(y div 8)+x div 8;
        for PomX:=0 to 7 do
          for PomY:=0 to 7 do begin
            z:=NewFont[Pismeno,PomY*8+PomX];
            if z>0 then z:=z+KreslColor;
            Nastav(PismX+PomX*Raster,PismY+PomY*Raster,z);
            VyplnPlochu(Raster-1,Raster-1);
          end;
        VypisRiadokPismen;
      end;
      2:begin{farba z palety}
        Farba:=(x-PaletaX) div Rozmer+16*((y-PaletaY) div Rozmer);
        Nastav(Aktiv[5,3]+8,Aktiv[5,2],Farba);
        VyplnPlochu(40,40);
      end;
      3:begin{bodkovanie rastra}
        PomX:=(x-PismX) div Raster;
        PomY:=(y-PismY) div Raster;
        NewFont[Pismeno,PomX+8*PomY]:=Farba mod 16;
        Nastav(PismX+PomX*Raster,PismY+PomY*Raster,Farba);
        VypniKurzorMysi;
        VyplnPlochu(Raster-1,Raster-1);
        PolozBod(8*(Pismeno mod 16)+PomX,8*(Pismeno div 16)+PomY,Farba);
        VypisRiadokPismen;
        ZapniKurzorMysi;
      end;
      4:begin
        Assign(f,NazovFontu);
        ReWrite(f);
        Write(f,NewFont);
        Close(f);
      end;
      6:begin{zmazanie pismena}
        for PomX:=0 to 63 do NewFont[Pismeno,PomX]:=0;
        for PomX:=0 to 7 do
          for PomY:=0 to 7 do begin
            z:=NewFont[Pismeno,PomY*8+PomX];
            if z>0 then z:=z+KreslColor;
            Nastav(PismX+PomX*Raster,PismY+PomY*Raster,z);
            VyplnPlochu(Raster-1,Raster-1);
          end;
        Nastav(8*(Pismeno mod 16),8*(Pismeno div 16),0);
        VyplnPlochu(8,8);
      end;
    end;
  until Udalost=5;
{ ----- ukoncenie programu ----- }
  VypniKurzorMysi;
  ZavriGrafiku;
  WriteLn('Editor fontov MukoSoft FontEdit, verzia 2.0'#13#10'Programoval: Lubos Saloky, 1997');
END.