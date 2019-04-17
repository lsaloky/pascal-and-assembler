program Tehlicky_pre_viacerych;
uses JoyStick,Mys,KeyBoard,MainGr;
type THrac=record
       Aktivny:boolean;                {ci sa zucastnuje}
       PocetZivotov:byte;              {kolko ma lopticiek}
       PocetPokazenych:byte;           {pocet pokazenych lopticiek pri timovej hre}
       PosX,PosY:word;                 {pozicia laveho horneho rohu na obrazovke}
       OldX,OldY:word;                 {pozicia pred posunom}
       SmerX,SmerY:integer;            {1,-1 al. 0 pre pohyb prvym smerom}
       Dlzka:byte;                     {dlzka odrazovej plochy}
       case Ovladanie:byte of          {Ovladanie:0 - joystick,1 - klavesnica, 2 - mys}
         0:(AktX,AktY:word); {pri joysticku su tu suradnice aktualnej polohy }
         1:(Pohyb1,Pohyb2,Strela:byte);{pri klavesnici pohyb 1. a 2. smerom}
     end;
const PocetMSF=2;
      TolerJoy=6;                     {menovatel tolerancie rovnovaznej polohy joysticka}
var PalP:pointer;
    Hrac:array[1..4] of THrac;
    JoyInfo:record
      MinX,RovX,MaxX:word;             {Min_ - minimalne suradnice}
      MinY,RovY,MaxY:word;             {Rov_ - suradnice rovnovaznej polohy}
                                  {Max_ - maximalne suradnice}
      TolerXL,TolerXP:word;       {TolerX_ - tolerancia okolo rovnovaznej polohy: os X, Lava / Prava cast}
      TolerYH,TolerYD:word;       {TolerY_ - tolerancia okolo rovnovaznej polohy: os Y, Horna / Dolna cast}
    end;
    AktHrac:word;
    MSFP:array[1..PocetMSF]of pointer;
{ ----- pomocne premenne ----- }
    x,y,i,j:word;
    Tlacidla:byte;

procedure Kalibrovanie_joysticka;
var ScreenSave:pointer;
const PosX=60;PosY=70;RozX=200;RozY=60;
begin
  GetMem(ScreenSave,RozX*RozY+4);
  StiahniBMP(PosX,PosY,RozX,RozY,ScreenSave);
  Color:=15;
  Ramcek(PosX,PosY,RozX,RozY,0);
  VypisPO(PosX+25,PosY+11,MSFP[2],'Presu~n p`aku joysticka',SvetloModra);
  VypisPO(PosX+18,PosY+25,MSFP[2],'do ~lavej hornej polohy',SvetloModra);
  VypisPO(PosX+40,PosY+38,MSFP[2],'a stla~c tla~cidlo.',SvetloModra);
  repeat
    JoyStick.ZistiPoziciu(JoyInfo.MinX,JoyInfo.MinY,Tlacidla);
  until Tlacidla>0;
  JoyStick.CakajNaPustenie;
  for i:=1 to 60 do CakajNaVOI;
  Ramcek(PosX,PosY,RozX,RozY,0);
  VypisPO(PosX+25,PosY+11,MSFP[2],'Presu~n p`aku joysticka',SvetloModra);
  VypisPO(PosX+18,PosY+25,MSFP[2],'do pravej dolnej polohy',SvetloModra);
  VypisPO(PosX+40,PosY+38,MSFP[2],'a stla~c tla~cidlo.',SvetloModra);
  repeat
    JoyStick.ZistiPoziciu(JoyInfo.MaxX,JoyInfo.MaxY,Tlacidla);
  until Tlacidla>0;
  JoyStick.CakajNaPustenie;
  for i:=1 to 60 do CakajNaVOI;
  Ramcek(PosX,PosY,RozX,RozY,0);
  VypisPO(PosX+30,PosY+11,MSFP[2],'Vr`a~t p`aku joysticka',SvetloModra);
  VypisPO(PosX+18,PosY+25,MSFP[2],'do rovnov`a~znej polohy',SvetloModra);
  VypisPO(PosX+40,PosY+38,MSFP[2],'a stla~c tla~cidlo.',SvetloModra);
  repeat
    JoyStick.ZistiPoziciu(JoyInfo.RovX,JoyInfo.RovY,Tlacidla);
  until Tlacidla>0;
  JoyStick.CakajNaPustenie;
  for i:=1 to 60 do CakajNaVOI;
  with JoyInfo do begin
    TolerXL:=(RovX-MinX) div TolerJoy;
    TolerXP:=(MaxX-RovX) div TolerJoy;
    TolerYH:=(RovY-MinY) div TolerJoy;
    TolerYD:=(MaxY-RovY) div TolerJoy;
  end;
  PrilepBMP(PosX,PosY,ScreenSave);
  FreeMem(ScreenSave,RozX*RozY+4);
end;
BEGIN
  InicializujZoznam;
  InicializujGrafiku;
  NacitajPaletu('Prechody.MP',PalP);
  NacitajFont('Hlavny8.MSF',MSFP[2]);
  NastavPaletu(PalP);
  for AktHrac:=1 to 4 do with Hrac[AktHrac] do begin
    Aktivny:=False;
    Dlzka:=20;
    PocetZivotov:=4;
    PocetPokazenych:=0;
    case AktHrac of
      1:begin SmerX:=3;SmerY:=0; end;
      2:begin SmerX:=0;SmerY:=-3; end;
      3:begin SmerX:=-3;SmerY:=0; end;
      4:begin SmerX:=0;SmerY:=3; end;
    end;
  end;
  asm
             mov ax,000Fh
             mov cx,32
             mov dx,32
             int 33h
  end;
{!!!!! toto tu nebude !!!!!}
  Kalibrovanie_Joysticka;
  with Hrac[1] do begin
    PosX:=150;
    PosY:=199;
    Aktivny:=True;
    Ovladanie:=1;{klavesnica}
    Pohyb1:=17;{'w'}
    Pohyb2:=16;{'q'}
    Strela:=18;{'e'}
  end;
  with Hrac[2] do begin
    PosX:=310;
    PosY:=90;
    Aktivny:=True;
    Ovladanie:=1;{klavesnica}
    Pohyb1:=31;{'s'}
    Pohyb2:=30;{'a'}
    Strela:=32;{'d'}
  end;
  with Hrac[3] do begin
    PosX:=150;
    PosY:=0;
    Aktivny:=True;
    Ovladanie:=2;{mys}
    x:=150;y:=0;
    NastavKurzor(x,y);
  end;
  with Hrac[4] do begin
    PosX:=0;
    PosY:=90;
    Aktivny:=True;
    Ovladanie:=0;{joystick}
  end;
  Color:=15;
  CiaraVodorovna(150,0,20);
  CiaraVodorovna(150,199,20);
  CiaraZvisla(310,90,20);
  CiaraZvisla(0,90,20);
{!!!!! az potial !!!!!}
  for i:=1 to 4 do with Hrac[i] do begin
    OldX:=PosX;
    OldY:=PosY;
  end;
  repeat
    for AktHrac:=1 to 4 do with Hrac[AktHrac] do if Aktivny then begin
      case Ovladanie of
      0:begin
          JoyStick.ZistiPoziciu(word(AktX),word(AktY),Tlacidla);
          if AktX<=JoyInfo.RovX then {nemoze tu byt "and", lebo 2. podmienka moze byt zaporne cislo pri type WORD}
            if JoyInfo.RovX-AktX>JoyInfo.TolerXL then PosX:=OldX-SmerX
          else
            if AktX-JoyInfo.RovX>JoyInfo.TolerXP then PosX:=OldX+SmerX;
          if (AktY<=JoyInfo.RovY) and (JoyInfo.RovY-AktY>JoyInfo.TolerYH) then PosY:=OldY-SmerY;
          if (AktY>JoyInfo.RovY) and (AktY-JoyInfo.RovY>JoyInfo.TolerYD) then PosY:=OldY+SmerY;
          if PosX<3 then PosX:=3;
          if PosY<3 then PosY:=3;
          if AktHrac mod 2=1 then PosY:=OldY else PosX:=OldX;
          if PosX>317-Dlzka then PosX:=317-Dlzka;
          if PosY>196-Dlzka then PosY:=196-Dlzka;
        end;
        1:begin
          if Zoznam^[Pohyb1]=1 then begin
            if (OldX+SmerX>2) and (OldX+SmerX<317-Dlzka) then PosX:=OldX+SmerX;
            if (OldY+SmerY>2) and (OldY+SmerY<196-Dlzka) then PosY:=OldY+SmerY;
          end;
          if Zoznam^[Pohyb2]=1 then begin
            if (OldX-SmerX>2) and (OldX-SmerX<317-Dlzka) then PosX:=OldX-SmerX;
            if (OldY-SmerY>2) and (OldY-SmerY<196-Dlzka) then PosY:=OldY-SmerY;
          end; { if }
        end; { case 1 }
      2:begin
          Mys.ZistiPoziciu(PosX,PosY,Tlacidla);
          if AktHrac mod 2=1 then PosY:=OldY else PosX:=OldX;
          if PosX>317-Dlzka then PosX:=317-Dlzka;
          if PosY>196-Dlzka then PosY:=196-Dlzka;
        end; { case 2 }
      end; { case }
      if (PosX<>OldX) or (PosY<>OldY) then begin
        Color:=0;
        if AktHrac mod 2=1 then CiaraVodorovna(OldX,OldY,20)
                           else CiaraZvisla(OldX,OldY,20);
        Color:=15;
        if AktHrac mod 2=1 then CiaraVodorovna(PosX,PosY,20)
                           else CiaraZvisla(PosX,PosY,20);
        OldX:=PosX;
        OldY:=PosY;
      end; { if }
      CakajNaVOI;
    end; { if }
  until (Zoznam^[28]=1) or (Tlacidla>0);
{ ----- ukoncenie programu ----- }
  ZavriGrafiku;
  ZavriZoznam;
  asm
             mov ax,000Fh  {nastav citlivost mysi}
             mov cx,8
             mov dx,16
             int 33h
  end;
END.