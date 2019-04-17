program Editor_map;
uses MainGr,Mys;
const Aktiv:array[1..3,1..4] of word=(
        (0,0,239,200),(240,0,319,170),(400,0,0,0));
      Klav:array[1..10] of char=(#0,#0,'h','d','l','p','u','n','k',#255);
var PalP,MSFP:pointer;
    MBP:array[0..255] of pointer;
    f:file;
    i,j:integer;
    x,y:word;
    Nazov,SuborMapy:string;
    PocetMB:byte;
    HlavickaMAP:array[0..7] of word;
    RozX,RozY,Udalost:word;
    Mapa:array[0..9999] of byte;
    StareX,StareY:word; { pre male bitmapy }
    PocX,PocY:word;     { pre mapu }
procedure PrekresliMapu;
var Start:word;
begin
  Start:=PocX+RozX*PocY;
  for i:=0 to 11 do
    for j:=0 to 14 do
      PrilepBMP(16*j,16*i,MBP[Mapa[Start+j+RozX*i]]);
end;
procedure NahrajMapu(SuborMapy:string);
begin
  Assign(f,SuborMapy);
  Reset(f,1);
  BlockRead(f,HlavickaMAP,16);
  RozX:=HlavickaMAP[1];
  RozY:=HlavickaMAP[2];
  BlockRead(f,Mapa,RozX*RozY);
  Close(f);
end;
BEGIN
{ ----- inicializacia ----- }
  Write('N zov .MB s£boru: ');
{  ReadLn(Nazov);}
  Nazov:='PoloPust.MB';
  Assign(f,Nazov);
  Reset(f,1);
  Seek(f,768);
  BlockRead(f,PocetMB,1);
  for i:=0 to PocetMB-1 do NacitajBMP(f,MBP[i]);
  Close(f);
  Write('N zov .MAP s£boru (Enter / Novy): ');
{  ReadLn(SuborMapy);}
  SuborMapy:='PoloPust.MAP';
  if SuborMapy<>'' then begin
    NahrajMapu(SuborMapy)
  end else begin
    Write('Rozmer X: ');
    ReadLn(RozX);
    HlavickaMAP[1]:=RozX;
    Write('Rozmer Y: ');
    ReadLn(RozY);
    HlavickaMAP[2]:=RozY;
  end;
  NacitajPaletu('Prechody.MP',PalP);
  NacitajFont('Hlavny8.MSF',MSFP);
  InicializujGrafiku;
  NastavPaletu(PalP);
  Color:=15;
  CiaraZvisla(240,0,200);
  CiaraVodorovna(240,170,80);
  Obdlznik(241,3,18,18);
  VypisP(245,174,MSFP,'H D L P',Zlta);
  VypisP(245,188,MSFP,'U N K',Zlta);
  i:=0;
  while MBP[i]<>nil do begin
    PrilepBMP(242+20*(i mod 4),4+20*(i div 4),MBP[i]);
    Inc(i);
  end;
  PrekresliMapu;
  VypinajMys:=True;
  ZM;
{ ----- hlavny cyklus ----- }
  repeat
    Udalost:=ObsluzUdalost(@Aktiv,@Klav);
    case Udalost of
      1:begin
        x:=MysX div 16;
        y:=MysY div 16;
        PrilepBMP(x*16,y*16,MBP[StareX+4*StareY]);
        Mapa[(PocX+x)+RozX*(y+PocY)]:=StareX+4*StareY;
      end;
      2:begin
        Color:=0;
        Obdlznik(StareX*20+241,StareY*20+3,18,18);
        x:=(MysX-242) div 20;
        y:=(MysY-4) div 20;
        StareX:=x;
        StareY:=y;
        Color:=15;
        Obdlznik(StareX*20+241,StareY*20+3,18,18);
      end;
      3:if PocY>0 then begin
        Dec(PocY);
        PrekresliMapu;
      end;
      4:if PocY<RozY-12 then begin
        Inc(PocY);
        PrekresliMapu;
      end;
      5:if PocX<RozX-15 then begin
        Inc(PocX);
        PrekresliMapu;
      end;
      6:if PocX>0 then begin
        Dec(PocX);
        PrekresliMapu;
      end;
      7:begin
        if SuborMapy='' then SuborMapy:='Novy.MAP';
        Assign(f,SuborMapy);
        ReWrite(f,1);
        BlockWrite(f,HlavickaMAP,16);
        BlockWrite(f,Mapa,RozX*RozY);
        Close(f);
      end;
      8:begin
        NahrajMapu(SuborMapy);
        PrekresliMapu;
      end;
    end;
    CakajNaPustenie;
  until Udalost=9;
{ ----- ukoncenie programu ----- }
  ZavriGrafiku;
  WriteLn('MukoSoft editor map'#13#10'Lubos Saloky, marec 1999');
END.