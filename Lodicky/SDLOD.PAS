USES mukogr,mukoutil,myska,crt;

CONST    FontPath = 'd:\lubo\pascal\units\Prechod.mf';
              Pol : array [1..9,1..4] of word=(
                    (20,60,50,90),(170,60,200,90),(170,160,200,230),
                    (20,110,50,140),(20,160,50,190),(170,110,200,140),
                    (215,14,200,40),(62,76,156,88),(62,126,156,138));

VAR             f : file;
        ObrazUkaz : pointer;
       ObrazUkaz2 : pointer;
               ch : char;
  pom,x,RozX,RozY : word;
              i,j : integer;
   meno1,meno2,s1 : string;
             stri : string;
            xm,ym : word;
 obt,yps,tlacidlo : byte;
      hrac1,hrac2 : boolean;   { 0 ... pocitac, 1 ... clovek }
           Koniec : boolean;
          Pismeno : array [1..7,0..599] of byte;
          Kocka   : array [1..6,0..63] of byte;
          Pocitac : array [0..899] of byte;
          Stupne  : array [0..899] of byte;
          Stop    : array [0..899] of byte;
          Clovek  : array [0..899] of byte;
          Cinka   : array [0..899] of byte;
          Kniha   : array [0..899] of byte;
          Start   : array [0..899] of byte;
          Vypln   : array [0..143] of byte;

                          PROCEDURE Intro;
Begin
  s1:='predstavuje';
  for i:=1 to 80 do begin
  nastav (i-10,109-i,0);
  ramcek (75,10,0);
  nastav (i,110-i,0);
  vypispriehladne ('MUKOSOFT',2);
  nastav (248-(i),109-i,0);
  ramcek (75,10,0);
  nastav (248-i,110-i,0);
  vypispriehladne ('ASTROSOFT',2);
  cakajnavoi;
  end;
 for i:=1 to 11 do begin
      randomize;
      for j:=1 to 4 do begin
      nastav (107+8*i,60,0);
      prilepbitmapu (8,8,ofs(Kocka[random(6)+1]));
      cakajnavoi;
      end;
      ramcek (8,8,0);
      vypispriehladne (s1[i],1);
 end;
 for i:=1 to 7 do begin
  for j:=300 downto (60+22*i) do begin
      if (j mod 3)=0 then begin
        Nastav (j-3,100,0);
        ramcek (30,30,0);
        Nastav (j,100,0);
        Prilepbitmapu (20,30,ofs(pismeno[i]));
        cakajnavoi;
      end;
  end;
 end;
 for i:=1 to 170 do begin
  posunvramdole (1);
  CakajNaVoi;
 end;
End;
                        PROCEDURE Ramcek1;
Begin
  Vypnikurzormysi;   Nastav (62,76,0);  Ramcek (94,12,0);
  Nastav (58,72,98); Ramcek (94,12,98); Zapnikurzormysi;
End;
                        PROCEDURE Ramcek2;
Begin
  Vypnikurzormysi;    Nastav (62,126,0); Ramcek (94,12,0);
  Nastav (58,122,98); Ramcek (94,12,98); Zapnikurzormysi;
End;
                        PROCEDURE VypisMeno (men:string;kubik:boolean);
Begin
  nastav (62,yps,0);
  VypisPriehladne (men,5);
  If kubik then begin Nastav (62+length(men)*8,yps,0);
                             PrilepPriehladnuBitmapu (8,8,ofs(Kocka[Random(6)+1]));
                       end;
End;
                        PROCEDURE Ikonka (x1,y1:word);
Begin
  Nastav (x1,y1,0);
  Ramcek (30,30,0);
  Nastav (x1-4,y1-4,0);
  PrilepBitmapu (30,30,pom);
End;
                        PROCEDURE Obtiaznost (prip:boolean);
Begin
CakajNaPustenie;
  if prip then If obt<3 then obt:=obt+1
                        else obt:=1;
  Vypnikurzormysi;
  Nastav (62,176,0); Ramcek (94,12,0);
  Nastav (58,172,98); Ramcek (94,12,98);
  Nastav (60,173,68); Ramcek (30,10,68);
  if obt>=2 then begin Nastav (90,173,52); Ramcek (30,10,52);end;
  if obt=3 then begin Nastav (120,173,20); Ramcek (30,10,20);end;
  Zapnikurzormysi;
End;
                        PROCEDURE HlavnyPanel;
Begin
  Nastav(0,0,0);
  PrilepDynamickuBitmapu(320,200,ObrazUkaz);
  CiaraVodorovna (320);
  Nastav (0,199,0);
  Ciaravodorovna (320);
  if not hrac1 then Pom:=ofs(Pocitac) else  Pom:=ofs(Clovek);
                     Ikonka (Pol[1,1],Pol[1,2]);
  Pom:=ofs(Stupne);  Ikonka (Pol[2,1],Pol[2,2]);
  Pom:=ofs(Stop);    Ikonka (Pol[3,1],Pol[3,2]);
  if not hrac2 then Pom:=ofs(Pocitac) else  Pom:=ofs(Clovek);
                     Ikonka (Pol[4,1],Pol[4,2]);
  Pom:=ofs(Cinka);   Ikonka (Pol[5,1],Pol[5,2]);
  Pom:=ofs(Kniha);   Ikonka (Pol[6,1],Pol[6,2]);
  Pom:=ofs(Start);   Ikonka (Pol[7,1],Pol[7,2]);
  Nastav (19,11,0); Ramcek (170,35,0);
  Nastav (15,7,98); Ramcek (170,35,98);
  for i:=1 to 7 do begin
    Nastav (22*i,10,0);
    PrilepPriehladnuBitmapu (20,30,ofs(Pismeno[i]));
  end;
  Nastav (60,60,0);   VypisPriehladne ('PRVY HRAC',11);
  Nastav (60,110,0);  VypisPriehladne ('DRUHY HRAC',11);
  Nastav (60,160,0);  VypisPriehladne ('OBTIAZNOST',11);
  Nastav (210,60,0);  VypisPriehladne ('NAJLEPSI',11);
  Nastav (210,73,0);  VypisPriehladne ('HRACI',11);
  Nastav (210,110,0); VypisPriehladne ('INFORMACIE',11);
  Nastav (210,123,0); VypisPriehladne ('O HRE',11);
  Nastav (210,160,0); VypisPriehladne ('KONIEC',11);
  Nastav (210,173,0); VypisPriehladne ('HRY',11);
  Nastav (255,20,0);  VypisPriehladne ('START',3);
  Obtiaznost (false);
  Zapnikurzormysi;Ramcek1; Ramcek2;Vypnikurzormysi;
  yps:=74;if hrac1 then VypisMeno (meno1,false)
                   else VypisMeno ('Pocitac',false);
  yps:=124;if hrac2 then VypisMeno (meno2,false)
                    else VypisMeno ('Pocitac',false);
  Zapnikurzormysi;
End;
                        PROCEDURE EditujMeno (cislo:byte);
var menoX:string;
Begin
  CakajNaPustenie;
  VypniKurzorMysi;
  if cislo=1 then Begin MenoX:=meno1;yps:=74;Ramcek1;end
             else Begin MenoX:=meno2;yps:=124;Ramcek2;end;
  VypisMeno (MenoX,true);
  repeat
  ch:=readkey;
  if (ord(ch)>30) and (length(menoX)<10) then begin
                  Nastav (62+(length(menoX))*8,yps,98);
                  Ramcek (8,8,98);
                  MenoX:=MenoX+ch;
                  VypisMeno (MenoX,true);
                  end;
  if (ord(ch)=8) and (length(menoX)>0) then begin
                  Nastav (62+(length(menoX)-1)*8,yps,98);
                  Ramcek (16,8,98);
                  MenoX:=copy (MenoX,1,length(menoX)-1);
                  VypisMeno (MenoX,true);
                  end;
  until ord(ch)=13;

  Nastav (62+(length(menoX))*8,yps,98);
                  Ramcek (8,8,98);
  if cislo=1 then Meno1:=menoX
             else Meno2:=menoX;
  Zapnikurzormysi;
End;
                        PROCEDURE Hraci;
Begin
  VypniKurzorMysi;
  if i=1 then begin case hrac1 of
                    false : begin Hrac1:=true;Pom:=ofs(Clovek);yps:=74;
                           Ikonka (Pol[1,1],Pol[1,2]);Ramcek1;VypisMeno (meno1,false);end;
                    true  : begin Hrac1:=false;Pom:=ofs(Pocitac);yps:=74;
                           Ikonka (Pol[1,1],Pol[1,2]);Ramcek1;VypisMeno ('Pocitac',false);end;
                    end;
              end
         else begin case hrac2 of
                    false : begin Hrac2:=true;Pom:=ofs(Clovek);yps:=124;
                           Ikonka (Pol[4,1],Pol[4,2]);Ramcek2;VypisMeno (meno2,false);end;
                    true  : begin Hrac2:=false;Pom:=ofs(Pocitac);yps:=124;
                           Ikonka (Pol[4,1],Pol[4,2]);Ramcek2;VypisMeno ('Pocitac',false);end;
                    end;
              end;
   Zapnikurzormysi;
   CakajNaPustenie;
End;
                        PROCEDURE Tabulka;
Begin
  VypniKurzorMysi;
  Nastav(60,20,0);
  PrilepDynamickuBitmapu(200,150,ObrazUkaz2);
  Nastav (60,20,15);
  Obdlznik (200,150);
  Nastav (100,35,0); VypisPriehladne ('TABULKA',17);
  Nastav (90,48,0); VypisPriehladne ('NAJLEPSICH',17);
  Nastav (200,30,0);PrilepBitmapu (30,30,ofs(Stupne));
  Nastav (199,29,15);Obdlznik (32,32);
  for i:=1 to 5 do begin
   Nastav (75,60+15*i,0);
   str (i,stri);
   VypisPriehladne (stri,5);
   Nastav (90,60+15*i,0);
   VypisPriehladne ('.....',5);
  end;
  ZapniKurzorMysi;
  CakajNaPustenie;
  repeat
  ZistiPoziciu (xm,ym,tlacidlo);
  until tlacidlo=lave;
  VypniKurzorMysi;
  HlavnyPanel;
  CakajNaPustenie;
End;
                        PROCEDURE Info;
Begin
VypniKurzorMysi;
  Nastav(60,20,0);
  PrilepDynamickuBitmapu(200,150,ObrazUkaz2);
  Nastav (60,20,15);
  Obdlznik (200,150);
  ZapniKurzorMysi;
  CakajNaPustenie;
  repeat
  ZistiPoziciu (xm,ym,tlacidlo);
  until tlacidlo=lave;
  VypniKurzorMysi;
  HlavnyPanel;
  CakajNaPustenie;
End;
                                BEGIN
InicializujGrafiku;
  NacitajFontAPaletu(fontPath);
  Hrac1:=true;Hrac2:=false;Koniec:=false;meno1:='Bez mena';meno2:='Bez mena';obt:=1;
  PripravPozadie(320,200,0,ObrazUkaz);
  for x:=1 to 2 do PriemerujBitmapu(ObrazUkaz);
  PripravPozadie(200,150,2,ObrazUkaz2);
  for x:=1 to 2 do PriemerujBitmapu(ObrazUkaz2);
  Assign(f,'lod2.mb');
  Reset(f,1);
  Seek(f,769);
  for i:=1 to 7 do begin
  Seek(f,FilePos(f)+2);
  BlockRead (f,Pismeno[i],600);
  end;
  for i:=1 to 6 do begin
  Seek(f,FilePos(f)+2);
  BlockRead (f,Kocka[i],64);
  end;
  for i:=1 to 8 do begin
  Seek(f,FilePos(f)+2);
  case i of
       1 : BlockRead (f,Pocitac,900);
       2 : Blockread (f,Stupne,900);
       3 : Blockread (f,Stop,900);
       4 : Blockread (f,Clovek,900);
       5 : Blockread (f,Cinka,900);
       6 : Blockread (f,Kniha,900);
       7 : Blockread (f,Start,900);
       8 : Blockread (f,Vypln,144);
  end;
  end;
  NastavTvarKurzora (ofs(Terc));
  {If SB then play ('sound','UVOD');}
  {Intro;}
  HlavnyPanel;
  {If SB then wait;}

  repeat
  ZistiPoziciu (xm,ym,tlacidlo);
  xm:=xm div 2;
  for i:=1 to 9 do begin
  if (xm>pol[i,1]-8) and (xm<pol[i,3]-8) and (ym<pol[i,4]-4) and (ym>pol[i,2]-4)
                   and (tlacidlo=lave) then
                       begin
                        case i of
                        1 : Hraci;
                        4 : Hraci;
                        2 : Tabulka;
                        3 : Koniec:=true;
                        5 : Obtiaznost (true);
                        6 : Info;
                        8 : if hrac1 then EditujMeno (1);
                        9 : if hrac2 then EditujMeno (2);
                        end;

                        i:=9;
                       end;
  end;
  until koniec;
  Vypnikurzormysi;
  Zavrigrafiku;
END.