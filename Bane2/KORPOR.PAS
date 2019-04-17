program Korporacia_bez_OOP;
uses Dos;
{$I deklar.inc}
{$I mys.inc}
{$I grafika.inc}
{$I smeti.inc}
{$I system.inc}
procedure SpracujLudiaRuda;
begin
  VypniKurzorMysi;
  if stav then begin
    sx:=272;sy:=37;s:=';=';NalepText;
    sx:=264;sy:=40;s:='mas';NalepText;
    sx:=280;sy:=48;s:='=@@;';NalepText;
    sx:=240;sy:=51;s:='@@@@@ludi';VpisCislo(sav.PocetLudi,2);NalepText;
    sx:=240;sy:=70;s:='byty@pre';NalepText;
    sx:=280;sy:=77;s:='=@@;';NalepText;
    pomw:=sav.Pocet[3]*4+sav.Pocet[5]*20;
    sx:=240;sy:=80;s:='@@@@@ludi';VpisCislo(pomw,2);NalepText;
    sx:=272;sy:=96;s:=';';NalepText;
    sx:=240;sy:=99;s:='denna';NalepText;
    sx:=240;sy:=107;s:='mzda:@@@';VpisCislo(sav.DennaMzda,7);NalepText;
    sx:=304;sy:=103;s:=']';NalepText;
    sx:=304;sy:=111;s:='^';NalepText;
    sx:=280;sy:=123;s:=';=';NalepText;
    sx:=240;sy:=126;s:='prestiz:';NalepText;
    sx:=248;sy:=136;s:='@@@|';VpisCislo(sav.Prestiz,1);NalepText;
  end else begin
    sx:=240;sy:=40;s:='cena';NalepText;
    sx:=240;sy:=48;s:='rudy:@@@';VpisCislo(sav.Cennik[0],7);NalepText;
    sx:=264;sy:=59;s:='=';NalepText;
    sx:=240;sy:=62;s:='pouzitie';NalepText;
    sx:=240;sy:=70;s:='rudy@v@|:';NalepText;
    sx:=240;sy:=83;s:='Sklad@@@@';VpisCislo(sav.NaSklad,8);NalepText;
    sx:=240;sy:=93;s:='Predaj@@@';VpisCislo(sav.NaPredaj,8);NalepText;
    sx:=240;sy:=103;s:='Vyskum@@@';VpisCislo(sav.NaVyskum,8);NalepText;
    sx:=240;sy:=115;color:=32;kolko:=70;CiaraVodorovna;
    sx:=248;sy:=132;s:=';';NalepText;
    sx:=240;sy:=135;s:='zasoby';NalepText;
    sx:=240;sy:=144;s:='@@@@@ton';VpisCislo(sav.Pocet[0],1);NalepText;
  end;
  ZapniKurzorMysi;
end;
BEGIN
  Inicializacia;
  NakresliCesty;
{ ----- hlavny cyklus ----- }
  repeat
    udalost:=0;
    time:=hod*360000.0+min*6000.0+sec*100.0+stot;
    repeat
      ZistiPoziciu;
      GetTime(hod,min,sec,stot);
      udalost:=0;
      for c1:=1 to 12 do
        if (x>obl[c1,1]) and (x<obl[c1,2]) and (y>obl[c1,3]) and (y<obl[c1,4]) then udalost:=c1;
      if udalost<>udalostl then
        case udalost of
          0:VypisInfo('','');
          1:VypisInfo('nakup@stavieb','@;');
          2:VypisInfo('nahratie@a@ulozenie@pozicie','@@@@@@@@@@@@@@=@@@@@@@@;');
          3:VypisInfo('nielen@pomoc@ale@aj@statistiky','@@@@@@@@@@@@@@@@@@@@=');
          4:VypisInfo('posun@vlavo','@@@@@@@=');
          5:VypisInfo('posun@vpravo','');
          6:VypisInfo('posun@hore','');
          7:VypisInfo('posun@dole','');
          8:VypisInfo('mapa@celeho@arealu','@@@@@@@@;@@@@@@;');
          9:VypisInfo('charakteristika@tvojich@obyvatelov','@@@@@@@@@@@@@@@@@@@@;@@@@@@@@@@=');
          10:VypisInfo('vyuzivanie@rudy','@@@=;');
          11:if stav then VypisInfo('zvysovanie@platov','@@@=');
          12:if stav then VypisInfo('znizovanie@platov','@@@=');
        end;
      udalostl:=udalost;
    until (tlacidlo>0) or ((hod*360000.0+min*6000.0+sec*100.0+stot-30>time) and ((x=2) or (x=638) or (y=1) or (y=199)));
    if x=2 then udalost:=4;
    if x=638 then udalost:=5;
    if y=1 then udalost:=6;
    if y=199 then udalost:=7;
    sav.Peniaze:=100000;
    for c1:=1 to 12 do
      if (x>obl[c1,1]) and (x<obl[c1,2]) and (y>obl[c1,3]) and (y<obl[c1,4]) then udalost:=c1;
    sav.uzvyskumane:=12;
    case udalost of
{ ----- CENNIK ----- }
      1:begin
          ZobrazCennik;
          SpracujCennik;
        end;
{ ----- HRA ----- }
      2:begin
          ZobrazHra;
          udalost2l:=0;
          repeat
            ZistiPoziciu;
            udalost2:=0;
            for c1:=1 to 5 do if (x>oblh[c1,1]) and (y>oblh[c1,2]) and (x<oblh[c1,3]) and (y<oblh[c1,4]) then udalost2:=c1;
            if udalost2<>udalost2l then begin
              VypisInfo(infoh[udalost2],'');
              udalost2l:=udalost2;
            end;
            if tlacidlo=1 then
              case udalost2 of
{ ----- HRA, ULOZIT ----- }
                1:begin
                    ZobrazSubory('ulozit','@@@=@=');
                    SpracujUlozenieSuboru;
                  end;
{ ----- HRA, NAHRAT ----- }
                2:begin
                    ZobrazSubory('nahrat','@@@@@=');
                    if udalost3<6 then begin
                      Seek(fsav,udalost3-1);
                      read(fsav,sav);
                      Zobraz:=true;
                    end;
                    CakajNaPustenie;
                    ZrusRamcek;
                  end;
                3:Demo;
              end;
          until ((udalost2=5) or (udalost2=4)) and (tlacidlo=1);
          ZlikvidujHra;
        end;
      3:Pomoc;
{ ----- posuny hracieho planu ----- }
      4:PosunVlavo;
      5:PosunVpravo;
      6:PosunHore;
      7:PosunDole;
      8:NakresliMapu;
      9:begin
          asm
             call InitAsm
             call VypniKurzorMysi
             lea si,ludia
             mov di,20*320+236
             call VykresliLudiaRuda
             lea si, ruda
             add si,640
             mov di,20*320+276
             call VykresliLudiaRuda
             call ZapniKurzorMysi
          end;
          stav:=true;
          SpracujLudiaRuda;
        end;
      10:begin
          asm
             call InitAsm
             call VypniKurzorMysi
             lea si,ludia
             add si,640
             mov di,20*320+236
             call VykresliLudiaRuda
             lea si, ruda
             mov di,20*320+276
             call VykresliLudiaRuda
             call ZapniKurzorMysi
          end;
          stav:=false;
          SpracujLudiaRuda;
        end;
      11:if stav and (sav.DennaMzda<98) then begin
           Inc(sav.DennaMzda);
           sx:=288;sy:=107;kolko:=16;ZmazOblastVBocnomMenu;
           sx:=240;sy:=107;s:='mzda:@@@';VpisCislo(sav.DennaMzda,7);NalepText;
         end;
      12:if stav and (sav.DennaMzda>1) then begin
           Dec(sav.DennaMzda);
           sx:=288;sy:=107;kolko:=16;ZmazOblastVBocnomMenu;
           sx:=240;sy:=107;s:='mzda:@@@';VpisCislo(sav.DennaMzda,7);NalepText;
         end;
    end;
    TestCiJeNovonahrate;
    VypniKurzorMysi;
    sx:=12;sy:=8;s:='CENNIK';NalepText;
    sx:=44;sy:=4;s:=';';NalepText;
    sx:=84;sy:=8;s:='HRA';NalepText;
    sx:=136;sy:=8;s:='POMOC';NalepText;
    ZapniKurzorMysi;
    if not((x=2) or (x=638) or (y=1) or (y=199)) then CakajNaPustenie;
  until (udalost=2) and (udalost2=4);
{ ----- ukoncovacie rutiny ----- }
  VypniKurzorMysi;
  asm
             mov ax,3
             int 10h
  end;
  Close(fsav);
  writeln('Korpor cia verzia 1.0'#13#10'Lubos Saloky,1997');
END.