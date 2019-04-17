uses MukoGr,Myska;
const FontPath='d:\lubo\pascal\units\Classic.mf';
var sx,sy,AktualnyIndex:word;
    Tlacidla:byte;
    Koniec,BoloNaOvladacomPrvku:boolean;
procedure InicializujProgram;
begin
  InicializujGrafiku;
  NacitajFontAPaletu(FontPath);
  ZapniKurzorMysi;
  Koniec:=False;
  AktualnyIndex:=0;
end;
procedure UkonciProgram;
begin
  VypniKurzorMysi;
  ZavriGrafiku;
end;