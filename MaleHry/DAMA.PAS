program PreManiakovDamy;
uses MukoGr,Myska,MukoUtil,Crt;
const FontStr='d:\lubo\pascal\units\Prechod.mf';
      PocPoz=1;
      RozPoz:array[1..PocPoz,1..3] of word=((320,201,Hneda));
var f:file;
    Retazce:text;
    i,j,x,y:integer;
    ch:char;
    PocetBMP,Tlacidla:byte;
    BRuka:array[0..255] of byte;
    Figurka16:array[0..255] of byte;
    Figurka24:array[0..575] of byte;
    Policko24:array[0..1,0..575] of byte;
    Dama:array[0..1279] of byte;
    PismenoD,PismenoA,PismenoM:array[0..7,0..255] of byte;
    Dlzen:array[0..7,0..63] of byte;
    Pozadie:array[1..PocPoz] of pointer;
    Buf:array[0..1679] of byte;            {odkladanie podkladu pri kresleni}
    IntroStr:array[1..10] of string[25];
    MenuStr:array[1..11] of string[25];
    PomS:string;
BEGIN
{ ----- inicializacia suborov, priemerovanie a inic. grafiky ----- }
  Assign(f,'Dama.mb');{subor s bitmapami}
  Reset(f,1);
  Seek(f,768);
  BlockRead(f,PocetBMP,1);
  for i:=1 to PocetBMP do begin
    Seek(f,FilePos(f)+2);
    case i of
      1:BlockRead(f,BRuka,256);
      2:BlockRead(f,Figurka24,576);
      3:BlockRead(f,Figurka16,256);
      4:BlockRead(f,Policko24[0],576);
      5:BlockRead(f,Policko24[1],576);
      6:BlockRead(f,Dama,1280);
    end; {case}
  end; {for}
  Close(f);
  Assign(f,'Dama.ma');{subor s animaciami}
  Reset(f,1);
  Seek(f,768);
  BlockRead(f,PocetBMP,1);
  for i:=1 to PocetBMP do begin
    Seek(f,FilePos(f)+3);
    case i of
      1:BlockRead(f,PismenoD,8*256);
      2:BlockRead(f,PismenoA,8*256);
      3:BlockRead(f,PismenoM,8*256);
      4:BlockRead(f,Dlzen,8*64);
    end; {case}
  end; {for}
  Assign(Retazce,'Strs.Txt');{subor s retazcami}
  Reset(Retazce);
  for i:=1 to 10 do Readln(Retazce,IntroStr[i]);
  for i:=1 to 11 do Readln(Retazce,MenuStr[i]);
  Close(Retazce);
  InicializujGrafiku;
  NacitajFontAPaletu(FontStr);
  for i:=1 to PocPoz do begin
    PripravPozadie(RozPoz[i,1],RozPoz[i,2],byte(RozPoz[i,3]),Pozadie[i]);
    PriemerujBitmapu(Pozadie[i]);
    for j:=1 to 400 do Mem[Seg(Pozadie[i]^):Ofs(Pozadie[i]^)+Random(RozPoz[i,1]*RozPoz[i,2])]:=Random(255);
    PriemerujBitmapu(Pozadie[i]);
    PriemerujBitmapu(Pozadie[i]);
  end; {for}
{ ----- uvodne vypisy intra ----- }
  Nastav(0,0,0);PrilepDynamickuBitmapu(320,199,Pozadie[1]);
  CiaraVodorovna(320);
  Nastav(66,36,0);VyplnPlochu(188,16);
  for i:=0 to 15 do begin
    Nastav(66-i,36-i,i);
    CiaraVodorovna(188+2*i);
    CiaraZvisla(16+2*i);
    Nastav(66-i,52+i,i);
    CiaraVodorovna(188+2*i);
    Nastav(254+i,36-i,i);
    CiaraZvisla(17+2*i);
  end;
  Nastav(55,24,0);PrilepPriehladnuBitmapu(32,40,Ofs(Dama));
  Nastav(233,24,0);PrilepPriehladnuBitmapu(32,40,Ofs(Dama));
  Nastav(128,36,0);PrilepBitmapu(16,16,Ofs(PismenoD));
  Nastav(148,36,0);PrilepBitmapu(16,16,Ofs(PismenoA));
  Nastav(168,36,0);PrilepBitmapu(16,16,Ofs(PismenoM));
  Nastav(188,36,0);PrilepBitmapu(16,16,Ofs(PismenoA));
  Nastav(152,28,0);PrilepPriehladnuBitmapu(8,8,Ofs(Dlzen));
  ZapniKurzorMysi;
  NastavKurzor(320,100);
  j:=0;i:=1; {i je pismeno,j snimok}
{ ----- demo s napisom DAMA ----- }
  repeat
    CakajNaVOI;
    Inc(j);
    if j mod 12=0 then begin
      VypniKurzorMysi;
      case i of
        1:begin
          Nastav(128,36,0);
          PrilepBitmapu(16,16,Ofs(PismenoD[j div 12]));
        end;
        2:begin
          Nastav(148,36,0);
          PrilepBitmapu(16,16,Ofs(PismenoA[j div 12]));
          Nastav(152,28,0);
          PrilepPriehladnuBitmapu(8,8,Ofs(Dlzen[j div 12]));
        end;
        3:begin
          Nastav(168,36,0);
          PrilepBitmapu(16,16,Ofs(PismenoM[j div 12]));
        end;
        4:begin
          Nastav(188,36,0);
          PrilepBitmapu(16,16,Ofs(PismenoA[j div 12]));
        end;
      end; {case}
      ZapniKurzorMysi;
    end; {if}
    if j=12*8-1 then begin
      j:=0;
      Inc(i);
    end;
    ZistiPoziciu(word(x),word(y),Tlacidla);
  until (KeyPressed) or (Tlacidla>0) or (i=5);
  Nastav(128,36,0);              {ukoncenie pri stlaceni niecoho}
  PrilepBitmapu(16,16,Ofs(PismenoD[7]));
  Nastav(148,36,0);
  PrilepBitmapu(16,16,Ofs(PismenoA[7]));
  Nastav(152,28,0);
  PrilepPriehladnuBitmapu(8,8,Ofs(Dlzen[7]));
  Nastav(168,36,0);
  PrilepBitmapu(16,16,Ofs(PismenoM[7]));
  Nastav(188,36,0);
  PrilepBitmapu(16,16,Ofs(PismenoA[7]));
  j:=75;
{ ----- demo - "priesvitny" podklad pod texty ----- }
  while (not KeyPressed) and (Tlacidla=0) and (j<185) do begin
    VypniKurzorMysi;
    Nastav(80,74,15);CiaraVodorovna(160);
    PolozBod(80,j,15);
    for i:=81 to 238 do PolozBod(i,j,(ZistiBod(i,j) mod 16)+48);
    PolozBod(239,j,15);
    ZapniKurzorMysi;
    CakajNaVOI;
    Inc(j);
    ZistiPoziciu(word(x),word(y),Tlacidla);
  end; {while}
  VypniKurzorMysi;
  Nastav(80,185,15);CiaraVodorovna(160);
  j:=1;
{ ----- demo - vypis textov (scrolling) ----- }
  while (not KeyPressed) and (Tlacidla=0) and (j<11) do begin
    Nastav(239,70+10*j,0);StiahniBitmapu(8,10,Ofs(Buf[1600]));
    i:=240;
    PomS:='';
    while (i>86) and (not KeyPressed) and (Tlacidla=0) do begin
      if i mod 8=0 then begin
        PomS:=PomS+IntroStr[j,Length(PomS)+1];
        if PomS[Length(PomS)] in ['`','~'] then PomS:=PomS+IntroStr[j,Length(PomS)+1];
      end; {if}
      Nastav(80,70+10*j,0);StiahniBitmapu(160,10,Ofs(Buf));
      Nastav(i,72+10*j,0);VypisPriehladne(PomS,Cervena);
      Nastav(239,70+10*j,0);PrilepBitmapu(8,10,Ofs(Buf[1600]));
      ZapniKurzorMysi;
      CakajNaVOI;
      VypniKurzorMysi;
      Nastav(80,70+10*j,0);
      if i>87 then PrilepBitmapu(160,10,Ofs(Buf));
      Dec(i);
      ZistiPoziciu(word(x),word(y),Tlacidla);
    end; {while}
    Inc(j);
  end; {while}
{ ----- koniec dema ----- }
  ZapniKurzorMysi;
  if (not KeyPressed) and (Tlacidla=0) then begin
    repeat
      ZistiPoziciu(word(x),word(y),Tlacidla);
    until (KeyPressed) or (Tlacidla>0);
  end;
  if KeyPressed then ReadKey;
  VypniKurzorMysi;
  for i:=0 to 15 do begin
    Nastav(95-i,89-i,i);
    CiaraVodorovna(130+2*i);
    CiaraZvisla(82+2*i);
    Nastav(95-i,170+i,i);
    CiaraVodorovna(130+2*i);
    Nastav(224+i,89-i,i);
    CiaraZvisla(82+2*i);
  end;
  Nastav(96,87,0);VyplnPlochu(128,83);
  Nastav(90,60,0);VypisPriehladne(MenuStr[1],Cervena);
  for i:=2 to 11 do begin
    Nastav(98,62+10*i,0);
    VypisPriehladne(MenuStr[i],Oranzova);
  end;
  ZapniKurzorMysi;
  readln;
  ZavriGrafiku;
END.