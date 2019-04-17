program Boxes;
uses MainGr,PomGr,Mys;
{ Pouziva: Boxes.MGP, Hlavny15.MSF, Hlavny8.MSF, Prechody.MP }
{ ----- konstanty a premenne pre MainGr ----- }
const PocetMSF=2;
      PocetMGP=6;
      HlAktiv:array[1..5,1..4] of word=( { hlavne menu }
        (164,77,284,93),(164,99,284,115),(164,121,284,137),(164,143,284,159),(400,0,0,0));
      HlKlav:array[1..5] of char=('h','n','v','k',#255);
      VelAktiv:array[1..4,1..4] of word=( { velkost planu }
        (127,97,167,109),(127,111,167,123),(161,127,221,143),(400,0,0,0));
      VelKlav:array[1..4] of char=('s','v','n',#255);
      NavAktiv:array[1..2,1..4] of word=( { navod }
        (250,175,310,191),(400,0,0,0));
      NavKlav:array[1..2] of char=('n',#255);
      VyhAktiv:array[1..2,1..4] of word=( { vyhodnotenie }
        (130,131,190,147),(400,0,0,0));
      VyhKlav:array[1..2] of char=('o',#255);
var MSFP:array[1..PocetMSF] of pointer;
    MGPP:array[1..PocetMGP] of pointer;
    PalP:pointer;
    Udalost,Udalost2:word;
    f:file;
    Tlacidla:byte;
{ ----- programove konstanty a premenne ----- }
const RozmerX:integer=6;
      RozmerY:integer=5;
      Farba:array[1..4] of byte=(109,68,111,76);
var i,j,x,y,AktHrac:integer;
    Plan:array[-2..12,-2..24] of byte;  { 10 x 10, obr. 8 x 7 }
    s:string;
    Koniec,Naspat,Vodorovna,Zvisla:boolean;
    Skore:array[1..2] of integer;
procedure SpracujPodruznosti; { Prepni hraca, zvys skore, vypis skore }
var PomSk:integer;
begin
{ ----- zvys skore, ak treba ----- }
  PomSk:=Skore[AktHrac];
  Color:=Farba[AktHrac];
  if Zvisla then begin { bola pridana zvisla ciara }
    if (Plan[x  ,y*2]>0) and (Plan[x  ,y*2+2]>0) and (Plan[x+1,y*2+1]>0) then begin
      Inc(Skore[AktHrac]);
      VM;VyplnPlochu(15+x*30,14+y*30,22,23);ZM;
    end;
    if (Plan[x-1,y*2]>0) and (Plan[x-1,y*2+2]>0) and (Plan[x-1,y*2+1]>0) then begin
      Inc(Skore[AktHrac]);
      VM;VyplnPlochu(-15+x*30,14+y*30,22,23);ZM;
    end;
  end;
  if Vodorovna then begin { bola pridana vodorovna ciara }
    if (Plan[x,y*2-2]>0) and (Plan[x,y*2-1]>0) and (Plan[x+1,y*2-1]>0) then begin
      Inc(Skore[AktHrac]);
      VM;VyplnPlochu(15+x*30,-16+y*30,22,23);ZM;
    end;
    if (Plan[x,y*2+1]>0) and (Plan[x,y*2+2]>0) and (Plan[x+1,y*2+1]>0) then begin
      Inc(Skore[AktHrac]);
      VM;VyplnPlochu(15+x*30,14+y*30,22,23);ZM;
    end;
  end;
{ ----- prepni hraca, ak treba ----- }
  Color:=0;
  Obdlznik(240,57,24,24);
  Obdlznik(276,57,24,24);
  if PomSk=Skore[AktHrac] then
    if AktHrac=1 then AktHrac:=2 else AktHrac:=1;
  Color:=15;
  Obdlznik(204+36*AktHrac,57,24,24);
{ ----- vypis skore ----- }
  Color:=0;
  VyplnPlochu(241,92,24,8);
  Vyplnplochu(277,92,24,8);
  Str(Skore[1],s);
  VypisP(241,92,MSFP[1],s,Zelena);
  Str(Skore[2],s);
  VypisP(277,92,MSFP[1],s,Zelena);
end;
BEGIN
{ ----- HLAVNY PROGRAM, inicializacia ----- }
  NacitajFont('Hlavny8.MSF',MSFP[1]);
  NacitajFont('Hlavny15.MSF',MSFP[2]);
  NacitajPaletu('Prechody.MP',PalP);
  Assign(f,'Boxes.MGP');
  Reset(f,1);
  Seek(f,16);
  for i:=1 to PocetMGP do NacitajMGP(f,MGPP[i]);
  Close(f);
  AttrCitaj.Font:=MSFP[1];
  InicializujGrafiku;
  NastavPaletu(PalP);
  ZM;
{ ----- hlavny cyklus ----- }
  repeat
    VykresliMGP(MGPP[1],nil,@MSFP);
    Udalost:=ObsluzUdalost(@HlAktiv,@HlKlav);
    CakajNaPustenie;
    case Udalost of
      1:begin { hra }
        VM;
        VykresliMGP(MGPP[4],nil,@MSFP);
        for i:=0 to RozmerX-1 do
          for j:=0 to RozmerY-1 do
            VypisP(7+i*30,7+j*30,MSFP[1],'+',Cervena);
        ZM;
        FillChar(Plan,Sizeof(Plan),#0);
        Koniec:=False;
        Naspat:=False;
        Vodorovna:=False;
        Zvisla:=False;
        AktHrac:=2;
        x:=0;y:=0;
        Skore[1]:=0;Skore[2]:=0;
        SpracujPodruznosti;
        repeat { cyklus hry }
          ZistiPoziciu(MysX,MysY,Tlacidla);
          MysX:=MysX div 2;
          for i:=0 to RozmerX-1 do
            for j:=0 to RozmerY-1 do begin
{ ----- mazanie nepolozenej vodorovnej palicky ----- }
              if Plan[i,j*2]>2 then begin
                VM;Color:=0;
                VyplnPlochu(15+30*i,9+30*j,22,3);ZM;
                Plan[i,j*2]:=0;
              end;
{ ----- mazanie nepolozenej zvislej palicky ----- }
              if Plan[i,j*2+1]>2 then begin
                VM;Color:=0;
                VyplnPlochu(9+30*i,14+30*j,4,23);ZM;
                Plan[i,j*2+1]:=0;
              end;
{ ----- kontrola, ci mys ukazuje na miesto pre vodorovnu palicku ----- }
              Vodorovna:=False;
              if (MysX>15+30*i) and (MysX<35+30*i) and
                 (MysY>5 +30*j) and (MysY<15+30*j) and
                 (i<RozmerX-1) then begin
                x:=(MysX-15) div 30;
                y:=(MysY-5) div 30;
                if (x>-1) and (x<RozmerX) and { kontrola cez nove suradnice }
                   (y>-1) and (y<RozmerY) then begin
                  if Plan[x,y*2]=0 then begin { ak je policko prazdne }
                    VM;Color:=Farba[AktHrac+2];
                    VyplnPlochu(15+30*i,9+30*j,22,3);ZM;
                    Plan[x,y*2]:=AktHrac+2;
                    if Tlacidla>0 then begin  { ak pouzivatel klikol }
                      VM;Color:=Farba[AktHrac];
                      VyplnPlochu(15+30*i,9+30*j,22,3);ZM;
                      Plan[x,y*2]:=AktHrac;
                      Vodorovna:=True;
                      SpracujPodruznosti;
                    end; { klik }
                  end; { prazdne }
                end; { test cez nove }
              end; { test }
{ ----- kontrola, ci mys ukazuje na miesto pre zvislu palicku ----- }
              Zvisla:=False;
              if (MysX>5 +30*i) and (MysX<15+30*i) and
                 (MysY>15+30*j) and (MysY<35+30*j) and
                 (j<RozmerY-1) then begin
                x:=(MysX-5) div 30;
                y:=(MysY-15) div 30;
                if (x>-1) and (x<RozmerX) and { kontrola cez nove suradnice }
                   (y>-1) and (y<RozmerY) then begin
                  if Plan[x,y*2+1]=0 then begin { ak je policko prazdne }
                    VM;Color:=Farba[AktHrac+2];
                    VyplnPlochu(9+30*i,14+30*j,4,23);ZM;
                    Plan[x,y*2+1]:=AktHrac+2;
                    if Tlacidla>0 then begin  { ak pouzivatel klikol }
                      VM;Color:=Farba[AktHrac];
                      VyplnPlochu(9+30*i,14+30*j,4,23);ZM;
                      Plan[x,y*2+1]:=AktHrac;
                      Zvisla:=True;
                      SpracujPodruznosti;
                    end; { klik }
                  end; { prazdne }
                end; { test cez nove }
              end; { test }
            end; { cyklus }
{ ----- testovanie konca partie ----- }
          CakajNaVOI;
          if (Tlacidla>0) and (MysX>250) and (MysX<310) and
                              (MysY>175) and (MysY<191) then Naspat:=True;
          if Skore[1]+Skore[2]=(RozmerX-1)*(RozmerY-1) then Koniec:=True;
        until (Koniec) or (Naspat);
{ ----- vyhodnotenie ----- }
        if Skore[1]<>Skore[2] then begin
          VykresliMGP(MGPP[5],nil,@MSFP);
          if Skore[1]>Skore[2] then Color:=Farba[1] else Color:=Farba[2];
          VyplnPlochu(150,71,20,20);
        end else begin
          VykresliMGP(MGPP[6],nil,@MSFP);
          Color:=Farba[2];
          VyplnPlochu(170,71,20,20);
          Color:=Farba[1];
          VyplnPlochu(125,71,20,20);
        end;
        Str(Skore[1],s);
        VypisP(121,115,MSFP[1],s,SvetloModra);
        Str(Skore[2],s);
        VypisP(172,115,MSFP[1],s,SvetloModra);
        Udalost2:=ObsluzUdalost(@VyhAktiv,@VyhKlav);
        CakajNaPustenie;
      end;
      2:begin { navod }
        VykresliMGP(MGPP[3],nil,@MSFP);
        Udalost2:=ObsluzUdalost(@NavAktiv,@NavKlav);
        CakajNaPustenie;
      end;
      3:begin { rozmery }
        repeat
          VM;VykresliMGP(MGPP[2],nil,@MSFP);
          Str(RozmerX,s);
          VypisP(129,99,MSFP[1],s,Zlta);
          Str(RozmerY,s);
          VypisP(129,113,MSFP[1],s,Zlta);ZM;
          Udalost2:=ObsluzUdalost(@VelAktiv,@VelKlav);
          CakajNaPustenie;
          Color:=6;
          case Udalost2 of
            1:begin { rozmer X }
              VM;VyplnPlochu(128,98,38,10);
              Citaj(129,99,3,s);ZM;
              Val(s,RozmerX,i);
              if RozmerX>8 then RozmerX:=8;
              if RozmerX<2 then RozmerX:=2;
            end;
            2:begin { rozmer Y }
              VM;VyplnPlochu(128,112,38,10);
              Citaj(129,113,3,s);ZM;
              Val(s,RozmerY,i);
              if RozmerY>7 then RozmerY:=7;
              if RozmerY<2 then RozmerY:=2;
            end;
          end;
        until Udalost2=3; { koniec nast. rozmerov }
      end;
    end;
  until Udalost=4; { koniec hry }
{ ----- ukoncenie programu ----- }
  ZavriGrafiku;
  WriteLn('MukoSoft BOXES'#13#10'Lubos Saloky, j£l 1999');
END.