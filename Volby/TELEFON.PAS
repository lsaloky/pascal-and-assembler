{ ----- KANCELARIA / TELEFON / KAUZA ----- }

const AktivKauza:array[1..7,1..4] of word=(
        (0,84,319,110),(0,112,319,126),(0,128,319,154),(0,156,319,182),
        (0,184,230,199),(240,184,319,199),(400,0,0,0));
      KlavKauza:array[1..7] of char=('1','2','3','4','5','n',#255);

procedure TelefonKauza;
begin
  if PoslKauza=0 then begin
    VykresliMGP(MGPPomP[14],@MBP,@MSFP);
    CakajNaUdalost;
  end else begin
    VykresliMGP(MGPPomP[7],@MBP,@MSFP);
    VypisFormatovany(10,28,MSFP[1],
      VsunNazovStrany(Kauza[ZoznamKauz[1].Index].Znenie,ZoznamKauz[1].Obet),
      SvetloModra,310);
    repeat
      Udalost:=ObsluzUdalost(@AktivKauza,@KlavKauza);
      Case Udalost of
        0,6:StlacNaspat;
        1..5:PrilepBMP(0,AktivKauza[Udalost,2],MBP[1]);
      end;
      CakajNaPustenie;
      case Udalost of
        0,6:PustNaspat;
        1:begin {obvinenia su pravdive -
                 - vzajomne znizenie chuti ist do koalicie o 1, (1,2)
                 - ak je to priznanie, strata preferencii       (3) }
          if Koal[HracovaStrana,ZoznamKauz[1].Obet]>1 then begin
            Dec(Koal[HracovaStrana,ZoznamKauz[1].Obet]);
            if DebugMode then Oznam(1,'Odmietol si ich: Koal tvoji -1');
          end;
          if Koal[ZoznamKauz[1].Obet,HracovaStrana]>1 then begin
            Dec(Koal[ZoznamKauz[1].Obet,HracovaStrana]);
            if DebugMode then Oznam(2,'Urazili sa: Koal obet -1');
          end;
          if HracovaStrana=ZoznamKauz[1].Obet then begin
            UpravGlobalnePref(HracovaStrana,-0.2);
            if DebugMode then Oznam(3,'Priznanie: Pref Glob -0.2');
          end;
          OdstranKauzu(1);
        end;
        2:begin {moze to byt pravda
                 - znizuje sa len tvoja chut ist do koalicie o 1, (1)
                 - ak je to priznanie, strata preferencii          (2) }
          if Koal[HracovaStrana,ZoznamKauz[1].Obet]>1 then begin
            Dec(Koal[HracovaStrana,ZoznamKauz[1].Obet]);
            if DebugMode then Oznam(1,'Odmietol si ich: Koal tvoji -1');
          end;
          if HracovaStrana=ZoznamKauz[1].Obet then begin
            UpravGlobalnePref(HracovaStrana,-0.2);
            if DebugMode then Oznam(2,'Priznanie: Pref Glob -0.2');
          end;
          OdstranKauzu(1);
        end;
        3:begin {asi to nie je pravda
                 - zvysuje sa len tvoja chut ist do koalicie o 1, (1) }
          if Koal[HracovaStrana,ZoznamKauz[1].Obet] in [1..9] then begin
            Inc(Koal[HracovaStrana,ZoznamKauz[1].Obet]);
            if DebugMode then Oznam(1,'Zastal si sa ich: Koal tvoji +1');
          end;
          OdstranKauzu(1);
        end;
        4:begin {urcite to nie je pravda -
                 - zvysuje sa vzajomne chut ist do koalicie o 1, (1,2) }
          if Koal[HracovaStrana,ZoznamKauz[1].Obet] in [1..9] then begin
            Inc(Koal[HracovaStrana,ZoznamKauz[1].Obet]);
            if DebugMode then Oznam(1,'Zastal si sa ich: Koal tvoji +1');
          end;
          if Koal[ZoznamKauz[1].Obet,HracovaStrana] in [1..9] then begin
            Inc(Koal[ZoznamKauz[1].Obet,HracovaStrana]);
            if DebugMode then Oznam(2,'Potesili sa: Koal obet +1');
          end;
          OdstranKauzu(1);
        end;
        5:begin {nevyjadrujeme sa k tomu - nic sa nedeje}
          OdstranKauzu(1);
        end;
      end;
    until (Udalost=6) or (Udalost=0);
  end;
  CakajNaPustenie;
end;

{ ----- KANCELARIA / TELEFON / OHOVARANIE ----- }

const AktivOhovaranie:array[1..6,1..4] of word=(
        (0,84,319,108),(0,110,319,134),(0,136,319,160),(0,162,319,176),
        (240,184,319,199),(400,0,0,0));
      KlavOhovaranie:array[1..6] of char=('1','2','3','4','n',#255);

procedure TelefonOhovaranie;
var AktUrazka:word;
begin
  if PoslOhovaranie=0 then begin
    VykresliMGP(MGPPomP[15],@MBP,@MSFP);
    CakajNaUdalost;
  end else begin
    VykresliMGP(MGPPomP[8],@MBP,@MSFP);
    AktUrazka:=ZoznamOhovarani[1].Index;
    VypisFormatovany(10,28,MSFP[1],
      VsunNazovStrany(Urazka[AktUrazka].Znenie,ZoznamOhovarani[1].Obet),
      SvetloModra,310);
    repeat
      Udalost:=ObsluzUdalost(@AktivOhovaranie,@KlavOhovaranie);
      Case Udalost of
        0,5:StlacNaspat;
        1..4:PrilepBMP(0,AktivOhovaranie[Udalost,2],MBP[1]);
      end;
      CakajNaPustenie;
      case Udalost of
        0,5:PustNaspat;
        1:begin {tvrde odmietnutie -
                 - ak ide o stranu s Koal>5, zvys Koal ich o 1 }
          if Koal[ZoznamOhovarani[1].Obet,HracovaStrana] in [5..8] then begin
            Inc(Koal[ZoznamOhovarani[1].Obet,HracovaStrana]);
            if DebugMode then Oznam(1,'Koal in 5..8; Podrzal si ich: Koal obet +1');
          end;
          OdstranOhovaranie(1);
        end;
        2:begin {jemne odmietnutie - za slusnost ziskas pref. +0.01}
          UpravGlobalnePref(HracovaStrana,0.01);
            if DebugMode then Oznam(1,'Slusnost: Pref Glob +0.01');
          OdstranOhovaranie(1);
        end;
        3:begin {suhlas s vyrokom -
                 - ak ide o priznanie, strata pref.
                 - ak ide o stranu s Koal>5 zniz Koal ich o 1 }
          if HracovaStrana=ZoznamOhovarani[1].Obet then begin
            UpravGlobalnePref(HracovaStrana,-0.1);
            if DebugMode then Oznam(1,'Priznanie: Pref Glob -0.1');
          end;
          if Koal[ZoznamOhovarani[1].Obet,HracovaStrana] in [5..8] then begin
            Dec(Koal[ZoznamOhovarani[1].Obet,HracovaStrana]);
            if DebugMode then Oznam(2,'Koal in 5..8; Nepodrzal si ich: Koal obet -1');
          end;
          OdstranOhovaranie(1);
        end;
        4:begin {nevyjadrujeme sa k tomu - nic sa nedeje}
          OdstranOhovaranie(1);
        end;
      end;
    until (Udalost=5) or (Udalost=0);
  end;
  CakajNaPustenie;
end;

{ ----- KANCELARIA / TELEFON / INA STRANA ----- }

const AktivInaStrana:array[1..9,1..4] of word=(
        (0,60,319,84),(0,86,319,110),(0,112,319,126),(0,128,319,152),
        (0,154,319,168),(240,184,319,199),(110,18,126,34),(191,18,207,34),
        (400,0,0,0));
      KlavInaStrana:array[1..9] of char=('1','2','3','4','5','n','<','>',#255);

procedure PrekresliInaStrana;
begin
  Color:=171;
  Ramcek(132,18,55,16,165);
  VypisPO(136,22,MSFP[1],NazovStrany[AktStrana],Zlta);
end;

procedure TelefonInaStrana;
begin
  AktStrana:=1;
  if DostVyhlaseni then begin
    ZmazObrazovku;
    CakajNaUdalost;
  end else begin
    VykresliMGP(MGPPomP[9],@MBP,@MSFP);
    PrekresliInaStrana;
    repeat
      Udalost:=ObsluzUdalost(@AktivInaStrana,@KlavInaStrana);
      case Udalost of
        0,6:StlacNaspat;
        7:Tlacidlo3D(110,18,16,16,MSFP[1],'<',10,3,True);
        8:Tlacidlo3D(191,18,16,16,MSFP[1],'>',10,3,True);
      end;
      CakajNaPustenie;
      PrilepBMP(AktivInaStrana[Udalost,2],0,MBP[1]);
      case Udalost of
        0,6:PustNaspat;
        1:begin {maju schopnych ludi}
          if Koal[HracovaStrana,AktStrana] in [1..5] then begin
            UpravGlobalnePref(HracovaStrana,-0.2);
            if DebugMode then Oznam(1,'Koal in 1..5; Nedrzis liniu strany. Pref Glob -0.2');
          end;
          if Koal[HracovaStrana,AktStrana] in [1..8] then begin
            Inc(Koal[HracovaStrana,AktStrana]);
            if DebugMode then Oznam(2,'Podporil si ich: Koal tvoji +1');
          end;
          DostVyhlaseni:=True;
        end;
        2:begin {su blizki}
          if Koal[HracovaStrana,AktStrana] in [1..8] then begin
            Inc(Koal[HracovaStrana,AktStrana]);
            if DebugMode then Oznam(1,'Pozitivne vyjadrenie: Koal tvoji +1');
          end;
          DostVyhlaseni:=True;
        end;
        3:begin {su vzdialeni}
          if Koal[HracovaStrana,AktStrana] in [2..9] then begin
            Dec(Koal[HracovaStrana,AktStrana]);
            if DebugMode then Oznam(1,'Negativne vyjadrenie: Koal tvoji -1');
          end;
          DostVyhlaseni:=True;
        end;
        4:begin {ohen a voda}
          if Koal[HracovaStrana,AktStrana] in [5..9] then begin
            UpravGlobalnePref(HracovaStrana,-0.2);
            if DebugMode then Oznam(1,'Koal in 5..9; Nedrzis liniu strany. Pref Glob -0.2');
          end;
          if Koal[HracovaStrana,AktStrana] in [2..9] then begin
            Dec(Koal[HracovaStrana,AktStrana]);
            if DebugMode then Oznam(2,'Ale si im dal!!! : Koal tvoji -1');
          end;
          DostVyhlaseni:=True;
        end;
        5:begin
          DostVyhlaseni:=True;
        end;
        7:begin
          Tlacidlo3D(110,18,16,16,MSFP[1],'<',10,3,False);
          if AktStrana>1 then begin
            Dec(AktStrana);
            PrekresliInaStrana;
          end;
        end;
        8:begin
          Tlacidlo3D(191,18,16,16,MSFP[1],'>',10,3,False);
          if AktStrana<PocetStran then begin
            Inc(AktStrana);
            PrekresliInaStrana;
          end;
        end;
      end;
    until (Udalost<>7) or (Udalost<>8);
    CakajNaUdalost;
  end;
end;

{ ----- KANCELARIA / TELEFON / POZVANIE ----- }

const AktivPozvanie:array[1..4,1..4] of word=(
        (0,126,319,140),(0,142,319,156),(240,184,319,199),(400,0,0,0));
      KlavPozvanie:array[1..4] of char=('1','2','n',#255);

procedure TelefonPozvanie;
begin
  VykresliMGP(MGPPomP[10],@MBP,@MSFP);
  CakajNaUdalost;
end;

{ ----- KANCELARIA / TELEFON ----- }

const AktivTel:array[1..6,1..4] of word=(
        (45,27,145,52),(85,54,185,84),(250,14,319,114),(54,103,234,133),
        (240,184,319,199),(400,0,0,0));
      KlavTel:array[1..6] of char=('k','o','i','p','n',#255);

procedure Telefon;
begin
  repeat
    VykresliMGP(MGPPomP[6],@MBP,@MSFP);
    Udalost:=ObsluzUdalost(@AktivTel,@KlavTel);
    if (Udalost=5) or (Udalost=0) then StlacNaspat;
    CakajNaPustenie;
    case Udalost of
      0,5:PustNaspat;
      1:TelefonKauza;
      2:TelefonOhovaranie;
      3:TelefonInaStrana;
      4:TelefonPozvanie;
    end;
  until (Udalost=5) or (Udalost=0);
end;
