program Specialne_priemerovanie;
uses MukoGr,MukoUtil;
const FontPath='d:\lubo\pascal\units\Classic.mf';
var x,y:word;
    Pozadie:array[1..9] of pointer;
BEGIN
  InicializujGrafiku;
  NacitajFontAPaletu(FontPath);
  for x:=1 to 9 do PripravPozadie(100,60,x,Pozadie[x]);
  for y:=1 to 4 do begin
    for x:=0 to 8 do begin
      Nastav(105*(x mod 3),65*(x div 3),0);
      PrilepDynamickuBitmapu(100,59,Pozadie[x+1]);
      CiaraVodorovna(100);
      PriemerujBitmapu(Pozadie[x+1]);
    end;
    Nastav(212,138,0);
    VypisPriehladne('Priemero-'#13'vanie'#13'farieb'#13#13'Lubos Saloky',Zlta);
    readln;
  end;
  for x:=1 to 9 do ZlikvidujPozadie(Pozadie[x]);
  ZavriGrafiku;
  Writeln('MukoSoft demonstracna verzia priemerovania.'#13#10'Lubos Saloky,1997');
END.