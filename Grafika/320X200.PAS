program Rychly_pristup_k_obrazovke_v_320x200;
uses FastGr;
var a:word;
    BitMapa1,BitMapa2:array[1..128*32] of byte;
BEGIN
  InicializujGrafiku;
  NacitajFontAPaletu;
  Adresa:=125*320+43;
  Color:=2;           {to iste ako Nastav(125,43,2)
{ PolozBod: ----- nahodne vybodkovanie ----- }
  for a:=1 to 3000 do begin
    Nastav(Random(320),Random(200),Random(255));
    PolozBod;
  end;
{ CiaraVodorovna,CiaraZvisla: ----- pocarbanie ----- }
  for a:=1 to 50 do begin
    Nastav(a*3,a*3,a);
    CiaraVodorovna(Random(50)+1);
    CiaraZvisla(Random(50)+1);
  end;
{ VyplnPlochu: ----- ako Bar v Graph.TPU ----- }
  Nastav(220,10,24);
  VyplnPlochu(80,24);
{ VyplnPlochu,Ramcek: ----- ramcek s 3D efektom ----- }
  Nastav(210,50,26);   {26 - tien - siva}
  VyplnPlochu(80,50);
  Nastav(205,45,14);   {14 - farba obruby - zlta}
  Ramcek(80,50,0);     {0  - farba vnutra - cierna}
{ VypisPriehladne: ----- da sa pouzivat Enter, treba KONVERZNU TABULKU!!!!! ----- }
  Nastav(209,50,0);    {farba nerozhoduje}
  VypisPriehladne('demo'#13'tvoril:'#13#13'lubo'#13'saloky');
  Nastav(209,71,0);
  VypisPriehladne('=');
  Nastav(190,120,31);
{ StiahniBitmapu: ----- animacia ----- }
  StiahniBitmapu(128,32,Ofs(BitMapa1));{podklad}
  Ramcek(128,32,3);
  Nastav(194,124,0);
  VypisPriehladne('[`````````````\'#13#13'@VLAVO@@VPRAVO@');
  Adresa:=120*320+190;{to iste ako Nastav(190,120,0)}
  StiahniBitmapu(128,32,Ofs(BitMapa2));{ramcek}
  for a:=190 downto 1 do begin
    PrilepBitmapu(128,32,Ofs(BitMapa1));
    Dec(Adresa);{to iste ako Nastav(x-1,y,Color)}
    StiahniBitmapu(128,32,Ofs(BitMapa1));
    PrilepBitmapu(128,32,Ofs(BitMapa2));
    CakajNaVOI;
  end;
  for a:=120 downto 1 do begin
    PrilepBitmapu(128,32,Ofs(BitMapa1));
    Adresa:=Adresa-320;{to iste ako Nastav(x,y-1,Color)}
    StiahniBitmapu(128,32,Ofs(BitMapa1));
    PrilepBitmapu(128,32,Ofs(BitMapa2));
    CakajNaVOI;
  end;
{ CiaraVodorovna: ----- mazacia animacia ----- }
  for a:=0 to 100 do begin
    Nastav(0,a,0);
    CiaraVodorovna(320);
    Nastav(0,199-a,0);
    CiaraVodorovna(320);
    CakajNaVOI;
  end;
  ZavriGrafiku;
  writeln('FastGraph 320x200, verzia 1.0'#13#10'Lubo Saloky, 1997');
END.