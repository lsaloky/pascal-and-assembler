program Editor_palety;
uses MukoGr,Myska,Crt,MukoUtil;
const PaletaPath='d:\lubo\pascal\units\prechody.mp';
      FontPath='d:\lubo\pascal\units\Prechod.mf';
      Rozmer=10;
      VypisX=170;VypisY=10;                               {rgb,od,do}
      PanelX=170;PanelY=100;                              {ovl. panel}
      PocetOP=9;
      Aktiv:array[1..PocetOP,1..4] of word=(
        (0,0,16*Rozmer,16*Rozmer),                        {farby}
        (VypisX+48,VypisY,VypisX+80,VypisY+8),            {red}
        (VypisX+48,VypisY+16,VypisX+80,VypisY+24),        {green}
        (VypisX+48,VypisY+32,VypisX+80,VypisY+40),        {blue}
        (VypisX+28,VypisY+60,VypisX+28+24,VypisY+68),     {od}
        (VypisX+84,VypisY+60,VypisX+84+24,VypisY+68),     {do}
        (PanelX,PanelY,PanelX+40,PanelY+16),              {uloz}
        (PanelX+48,PanelY,PanelX+48+56,PanelY+16),        {koniec}
        (PanelX,PanelY+24,PanelX+64,PanelY+40));          {pocitaj}
      OLH:array[0..PocetOP] of string[40]=(
        '','VYBER SI FARBU','NASTAVOVANIE CERVENEJ ZLOZKY',
        'NASTAVOVANIE ZELENEJ ZLOZKY','NASTAVOVANIE MODREJ ZLOZKY',
        'POCIATOK KALKULOVANEHO INTERVALU','KONIEC KALKULOVANEHO INTERVALU',
        'ULOZ PALETU','KONIEC PROGRAMU','ROVNOMERNY PREPOCET FARIEB OD DO');
type TPaleta=array[0..767] of byte;
var z,Udalost,UStara,Err:integer;
    PomX,PomY,x,y,Red,Green,Blue,Odkial,Pokial,Farba:word;
    Paleta:TPaleta;
    f:file of TPaleta;
    Tlacidla:byte;
procedure ZobrazFarbu;
var s:string;
begin
  Red:=Paleta[Farba*3];
  Green:=Paleta[Farba*3+1];
  Blue:=Paleta[Farba*3+2];
  Nastav(VypisX+80,VypisY,Farba);
  VyplnPlochu(40,40);
  Nastav(Aktiv[2,1],Aktiv[2,2],0);
  VyplnPlochu(32,40);
  Str(Red,s);
  VypisPriehladne(s,Zlta);
  Nastav(Aktiv[3,1],Aktiv[3,2],0);
  Str(Green,s);
  VypisPriehladne(s,Zlta);
  Nastav(Aktiv[4,1],Aktiv[4,2],0);
  Str(Blue,s);
  VypisPriehladne(s,Zelena);
end;
BEGIN
{ ----- inicializacia a vykreslenie ovladacich prvkov ----- }
  InicializujGrafiku;
  Assign(f,PaletaPath);
  Reset(f);
  Read(f,Paleta);
  Close(f);
  NacitajFontAPaletu(FontPath);
  Assign(f,PaletaPath);
  Reset(f);
  Read(f,Paleta);
  Close(f);
  for x:=0 to 255 do NastavFarbu(x,Paleta[x*3],Paleta[x*3+1],Paleta[x*3+2]);
  for x:=0 to 15 do
    for y:=0 to 15 do begin
      Nastav(x*Rozmer,y*Rozmer,x+16*y);
      VyplnPlochu(Rozmer,Rozmer);
    end;
  Nastav(VypisX,VypisY,0);
  VypisPriehladne(' red'#13#13'green'#13#13' blue',Cervena);
  Nastav(VypisX,VypisY+48,14);
  Ramcek(88+32,24,0);
  Nastav(VypisX+4,VypisY+52,14);
  VypisPriehladne('  prepocitaj'#13'od     do    ',Bordova);
  Nastav(PanelX,PanelY,14);
  Ramcek(40,16,0);
  Nastav(Aktiv[7,1],Aktiv[7,2],14);
  Ramcek(Aktiv[7,3]-Aktiv[7,1],Aktiv[7,4]-Aktiv[7,2],0);
  Nastav(Aktiv[7,1]+4,Aktiv[7,2]+4,0);
  VypisPriehladne('ULOZ',Bordova);
  Nastav(Aktiv[8,1],Aktiv[8,2],14);
  Ramcek(Aktiv[8,3]-Aktiv[8,1],Aktiv[8,4]-Aktiv[8,2],0);
  Nastav(Aktiv[8,1]+4,Aktiv[8,2]+4,0);
  VypisPriehladne('KONIEC',Bordova);
  Nastav(Aktiv[9,1],Aktiv[9,2],14);
  Ramcek(Aktiv[9,3]-Aktiv[9,1],Aktiv[9,4]-Aktiv[9,2],0);
  Nastav(Aktiv[9,1]+4,Aktiv[9,2]+4,0);
  VypisPriehladne('POCITAJ',Bordova);
  Nastav(8*Rozmer,0,0);
  CiaraZvisla(16*Rozmer);
  Farba:=0;
  ZobrazFarbu;
  ZapniKurzorMysi;
{ ----- cakanie na udalost ----- }
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
        VypisPriehladne(OLH[Udalost],Svetlomodra);
        UStara:=Udalost;
        ZapniKurzorMysi;
      end;
    until Tlacidla=1;
    repeat ZistiPoziciu(PomX,PomY,Tlacidla); until Tlacidla=0;
{ ----- spracovanie udalosti ----- }
    VypniKurzorMysi;
    if (Udalost>1) and (Udalost<7) then begin
      Nastav(Aktiv[Udalost,1],Aktiv[Udalost,2],0);
      VyplnPlochu(32,8);
    end;
    case Udalost of
      1:begin
        Farba:=x div Rozmer+16*(y div Rozmer);
        ZobrazFarbu;
      end;
      2:begin
        Citaj(3,Zlta);Val(Ret,Red,Err);
        Paleta[Farba*3]:=Red div 4;
        NastavFarbu(Farba,Red div 4,Green,Blue);
        ZobrazFarbu;
      end;
      3:begin
        Citaj(3,Zlta);Val(Ret,Green,Err);
        Paleta[Farba*3+1]:=Green div 4;
        NastavFarbu(Farba,Red,Green div 4,Blue);
        ZobrazFarbu;
      end;
      4:begin
        Citaj(3,Zlta);Val(Ret,Blue,Err);
        Paleta[Farba*3+2]:=Blue div 4;
        NastavFarbu(Farba,Red,Green,Blue div 4);
        ZobrazFarbu;
      end;
      5:begin
        Citaj(3,Zlta);
        Val(Ret,Odkial,Err);
      end;
      6:begin
        Citaj(3,Zlta);
        Val(Ret,Pokial,Err);
      end;
      7:begin
        Assign(f,PaletaPath);
        ReWrite(f);
        Write(f,Paleta);
        Close(f);
      end;
      9:begin
        if Odkial<Pokial then begin
          for z:=0 to Pokial-Odkial do begin
            Paleta[(Odkial+z)*3]:=Round(Paleta[Odkial*3]+
              (Paleta[Pokial*3]-Paleta[Odkial*3])*z/(Pokial-Odkial));
            Paleta[(Odkial+z)*3+1]:=Round(Paleta[Odkial*3+1]+
              (Paleta[Pokial*3+1]-Paleta[Odkial*3+1])*z/(Pokial-Odkial));
            Paleta[(Odkial+z)*3+2]:=Round(Paleta[Odkial*3+2]+
              (Paleta[Pokial*3+2]-Paleta[Odkial*3+2])*z/(Pokial-Odkial));
            NastavFarbu(z+Odkial,Paleta[(Odkial+z)*3],Paleta[(Odkial+z)*3+1],Paleta[(Odkial+z)*3+2]);
          end;
        end;
      end;
    end;
    ZapniKurzorMysi;
  until Udalost=8;
  VypniKurzorMysi;
  ZavriGrafiku;
  writeln('Editor palety MukoSoft PalEdit verzia 1.0'#13#10'Lubos Saloky, 1997');
END.