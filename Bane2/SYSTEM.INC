{ZOZNAM PROCEDUR:
  NakresliCesty;
  Inicializacia;
  ZobrazCennik;
  SpracujCennik;
  ZobrazHra;
  Pomoc;
  Demo;
  }
procedure NakresliCesty;
begin
  VypniKurzorMysi;
  kolko:=6;color:=$1D;
  for pomw3:=lhx to lhx+27 do
    for pomw4:=lhy to lhy+18 do begin
      if sav.PPlocha[pomw3,pomw4]=4 then begin
        pomw:=(pomw3-lhx)*8+((pomw4-lhy)*8+32)*320;
        asm
             call InitAsm
             mov di,pomw
             mov ax,7A7Ah
             mov dx,8
             mov bx,8
             call ZacierniPlochu
             mov di,pomw
             add di,321
             mov ax,1D1Dh
             mov dx,6
             mov bx,6
             call ZacierniPlochu
        end;
        if sav.PPlocha[pomw3+1,pomw4]>0 then begin
          sx:=(pomw3-lhx)*8+7;sy:=(pomw4-lhy)*8+33;CiaraZvisla;
        end;
        if sav.PPlocha[pomw3-1,pomw4]>0 then begin
          sx:=(pomw3-lhx)*8;sy:=(pomw4-lhy)*8+33;CiaraZvisla;
        end;
        if sav.PPlocha[pomw3,pomw4+1]>0 then begin
          sx:=(pomw3-lhx)*8+1;sy:=(pomw4-lhy)*8+39;CiaraVodorovna;
        end;
        if sav.PPlocha[pomw3,pomw4-1]>0 then begin
          sx:=(pomw3-lhx)*8+1;sy:=(pomw4-lhy)*8+32;CiaraVodorovna;
        end;
      end;
    end;
  ZapniKurzorMysi;
end;
procedure Inicializacia;
begin
  Assign(fsav,'korpor.sav');
  Reset(fsav);
  Obr:=nil;
  stav:=true;
  mozne:=['a'..'z','A'..'Z','0'..'9',#13,' ',#8];
  asm
             mov ax,0013h
             int 10h
  end;
  for x:=1 to 500 do Bod(random(320),random(24),random(16)+16);
  for x:=1 to 700 do Bod(random(88)+232,random(161)+24,random(16)+16);
  asm
             call InitAsm
{ ----- citanie fontu ----- }
             mov ax,3D00h
             lea dx,f2
             inc dx
             int 21h
             mov FHandle,ax
             mov ah,3Fh
             mov bx,FHandle
             lea dx,font
             mov cx,4928
             int 21h
             mov ah,3Eh
             mov bx,FHandle
             int 21h
{ ----- inicializacia diskoveho suboru - bitmapy ----- }
             mov ax,3D00h              {otvorenie suboru pre citanie}
             lea dx,f
             inc dx
             int 21h
             mov FHandle,ax
             mov ah,3Fh                {citanie zo suboru}
             mov bx,FHandle
             lea dx,pom
             mov cx,768
             int 21h
{ ----- inicializacia palety ----- }
             mov cx,0
             lea si,pom
@DalsiaFarba:mov al,cl
             mov dx,03C8h
             out dx,al
             inc dx
             mov al,byte[si]
             out dx,al
             mov al,byte[si+1]
             out dx,al
             mov al,byte[si+2]
             out dx,al
             dec dx
             add si,3
             inc cx
             cmp cx,255
             jbe @DalsiaFarba
{ ----- vykreslenie "CENNIK","HRA","POMOC" ----- }
             mov ah,3Fh                {nacitanie z harddisku}
             mov bx,FHandle
             mov cx,1
             lea dx,pomw2
             int 21h
             mov pomw,0
@Davka:mov ah,3Fh
             mov cx,2
             lea dx,pomw2
             int 21h
             mov ah,3Fh
             mov cx,256
             lea dx,pom
             add dx,pomw
             int 21h
             add pomw,256
             cmp pomw,1280
             jb @Davka
{ ----- nacitanie bane ----- }
             call NacitajDvaBajty
             mov ah,3Fh
             mov cx,1024
             lea dx,bana
             int 21h
{ ----- nacitanie skladu ----- }
             call NacitajDvaBajty
             mov ah,3Fh
             mov cx,768
             lea dx,sklad
             int 21h
{ ----- nacitanie domu ----- }
             call NacitajDvaBajty
             mov ah,3Fh
             mov cx,576
             lea dx,dom
             int 21h
{ ----- nacitanie bloku ----- }
             call NacitajDvaBajty
             mov ah,3Fh
             mov cx,768
             lea dx,blok
             int 21h
{ ----- nacitanie bitmap Ludia, Ruda ----- }
             call NacitajDvaBajty {ludia aktivna cast}
             mov ah,3Fh
             mov cx,640
             lea dx,ludia
             int 21h
             call NacitajDvaBajty  {ruda aktivna cast}
             mov ah,3Fh
             mov cx,640
             lea dx,ruda
             int 21h
             call NacitajDvaBajty   {ludia pasivna cast}
             mov ah,3Fh
             mov cx,640
             lea dx,ludia
             add dx,640
             int 21h
             call NacitajDvaBajty    {ruda pasivna cast}
             mov ah,3Fh
             mov cx,640
             lea dx,ruda
             add dx,640
             int 21h
{ ----- nacitanie bitmapy pre podklad pod bocne menu ----- }
             call NacitajDvaBajty
             mov ah,3Fh
             mov cx,1600
             lea dx,BocnyPodklad
             int 21h
{ ----- nacitanie kina ----- }
             call NacitajDvaBajty
             mov ah,3Fh
             mov cx,576
             lea dx,kino
             int 21h
{ ----- nacitanie kniznice ----- }
             call NacitajDvaBajty
             mov ah,3Fh
             mov cx,768
             lea dx,kniznica
             int 21h
{ ----- nacitanie oceliarne ----- }
             call NacitajDvaBajty
             mov ah,3Fh
             mov cx,1280
             lea dx,oceliaren
             int 21h
{ ----- nacitanie elektrarne ----- }
             call NacitajDvaBajty
             mov ah,3Fh
             mov cx,1280
             lea dx,elektraren
             int 21h
{ ----- nacitanie zbrojovky ----- }
             call NacitajDvaBajty
             mov ah,3Fh
             mov cx,1600
             lea dx,zbrojovka
             int 21h
{ ----- nacitanie recyklacneho centra ----- }
             call NacitajDvaBajty
             mov ah,3Fh
             mov cx,640
             lea dx,rcentrum
             int 21h
{ ----- nacitanie bonusu ----- }
             call NacitajDvaBajty
             mov ah,3Fh
             mov cx,1600
             lea dx,bonus
             int 21h
{ ----- vykreslenie cennik,hra,pomoc,ludia,ruda ----- }
             lea si,pom
             call VykresliCennik
             lea si,pom
             call VykresliHra
             lea si,pom
             call VykresliPomoc
             lea si,ludia
             mov di,20*320+236
             call VykresliLudiaRuda
             lea si,ruda
             add si,640
             mov di,20*320+276
             call VykresliLudiaRuda
{ ----- ukoncovacie rutiny ----- }
             mov ah,3Eh
             mov bx,FHandle
             int 21h
             mov sx1,0
             mov sx2,224
             mov sy1,32*320
             mov sy2,183*320
             call NakresliAktivnuOblast
{ ----- naplnanie pomocnych poli TZ,TV ----- }
             lea si,pom
             add si,512
             lea di,TZ
             mov ax,ds
             mov es,ax
             mov bx,11
@DalsiaTr:   mov cx,128
         rep movsw
             sub si,256
             dec bx
             jnz @DalsiaTR
             lea di,TV
             mov dx,16
             mov bx,15
@DalsiRiadok:mov cx,8
         rep movsw
             sub si,16
             dec bx
             jnz @DalsiRiadok
             add si,16
             mov bx,15
             dec dx
             jnz @DalsiRiadok
  end;
  SpracujLudiaRuda;
  oznac:=0;udalost:=0;
  Zobraz:=false;
  sx:=12;sy:=8;s:='CENNIK';NalepText;
  sx:=44;sy:=4;s:=';';NalepText;
  sx:=84;sy:=8;s:='HRA';NalepText;
  sx:=136;sy:=8;s:='POMOC';NalepText;
  sx:=192;sy:=8;s:='DATUM:22<11<1996';NalepText;
  sx:=200;sy:=4;s:=';';NalepText;
  sx:=0;sy:=24;s:='[``````````````````````````\{';NalepText;
  sx:=224;sy:=32;s:=']';NalepText;
  sx:=224;s:='_';
  for x:=5 to 21 do begin
    sy:=x*8;
    NalepText;
  end;
  sx:=224;sy:=176;s:='^';NalepText;
  sx:=240;sy:=160;s:='peniaze:';NalepText;
  VypisKonto;
  sx:=0;sy:=184;kolko:=319;color:=31;CiaraVodorovna;
  VypisInfo('','');
  ZapniKurzorMysi;
  lhx:=20;lhy:=20;
  sx1:=0;sx2:=223;sy1:=32*320;sy2:=183*320;
  NakresliAktivnuOblast;
  NakresliObjekty;
  sx1:=2;sy1:=1;sx2:=638;sy2:=199;
  NastavRozsahSuradnic;
  x:=100;y:=100;UmiestniKurzor;
end;
procedure ZobrazCennik;
begin
  asm
             call InitAsm
             call VypniKurzorMysi
             lea si,pom                {nalepenie do VRAM}
             add si,768
             call VykresliCennik
  end;
  VykresliRamcek(40,35,285,179);
{ ----- prvych 6 stavieb ----- }
  pomw2:=sav.UzVyskumane;
  if sav.UzVyskumane>6 then pomw2:=6;
  for pomw:=1 to pomw2 do VykresliTlacidlo(Obr^.x1+6,Obr^.y1+9+15*pomw,Obr^.x1+48,Polozka[pomw,1],Polozka[pomw,2],0);
  for pomw:=1 to pomw2 do begin
    sx:=Obr^.x1+42;
    sy:=Obr^.y1+13+15*pomw;
    s:='@@@@@@@';
    VpisCislo(sav.Cennik[pomw],3);
    NalepText;
  end;
{ ----- dalsich 6 stavieb ----- }
  if sav.UzVyskumane>6 then begin
    for pomw:=1 to sav.UzVyskumane-6 do
      VykresliTlacidlo(Obr^.x1+104,Obr^.y1+9+15*pomw,Obr^.x1+186,Polozka[pomw+6,1],Polozka[pomw+6,2],0);
    for pomw:=1 to sav.UzVyskumane-6 do begin
      sx:=Obr^.x1+180;
      sy:=Obr^.y1+13+15*pomw;
      s:='@@@@@@@';
      VpisCislo(sav.Cennik[pomw+6],3);
      NalepText;
    end;
  end;
{ ----- ostatne ----- }
  sx:=12;sy:=8;s:='CENNIK';NalepText;
  sx:=44;sy:=4;s:=';';NalepText;
  sx:=Obr^.x1+2;sy:=Obr^.y1+20;kolko:=Obr^.x2-Obr^.x1-4;color:=5;CiaraVodorovna;
                sy:=Obr^.y1+21;                                  CiaraVodorovna;
  sx:=Obr^.x1+48;sy:=Obr^.y1+10;s:='CENNIK';NalepText;
  sx:=Obr^.x1+80;sy:=Obr^.y1+6;s:=';';NalepText;
  PVykresliBMPTlacidlo(Obr^.x1+6,Obr^.y1+120,12,'KUPIT','@;@@=');
  PVykresliBMPTlacidlo(Obr^.x1+78,Obr^.y1+120,8,'PREDAT','@@@@@=');
  PVykresliBMPTlacidlo(Obr^.x1+152,Obr^.y1+120,8,'HOTOVO','');
  asm
             call ZapniKurzorMysi
  end;
end;
procedure SpracujCennik;
begin
  oznac:=0;
  udalost2l:=0;
  VypisInfo(infoc[0],'');
  repeat
    ZistiPoziciu;
    udalost2:=0;
    for c1:=1 to 15 do if (x>oblc[c1,1]) and (y>oblc[c1,2]) and (x<oblc[c1,3]) and (y<oblc[c1,4]) then udalost2:=c1;
    if (udalost2<>udalost2l) or (tlacidlo>0) then begin
      if ((udalost2>12) or (udalost2=0)) and (oznac=0) then VypisInfo(infoc[udalost2],'');
      if (udalost2<13) and (oznac=0) then begin
        if sav.Peniaze<sav.Cennik[udalost2] then VypisInfo(infoc[17],'');
        if (sav.Peniaze>=sav.Cennik[udalost2]) and (udalost2<=sav.UzVyskumane) then VypisInfo(infoc[udalost2],'')
      end;
      if oznac>0 then VypisInfo(infoc[16],'');
      if (udalost2>0) and (udalost2<13) and (tlacidlo=1) and (sav.Peniaze>=sav.Cennik[udalost2]) then begin
        if oznac=0 then begin
          oznac:=udalost2;
          color:=14;
        end else begin
          if oznac<7 then VykresliTlacidlo(Obr^.x1+6,Obr^.y1+oznac*15+9,Obr^.x1+48,Polozka[oznac,1],Polozka[oznac,2],0);
          if (oznac>6) and (oznac<13) then
             VykresliTlacidlo(Obr^.x1+104,Obr^.y1+(oznac-6)*15+9,Obr^.x1+180,Polozka[oznac,1],Polozka[oznac,2],0);
          oznac:=0;
          color:=0;
        end;
        CakajNaPustenie;
        VypniKurzorMysi;
        if Udalost2<7 then
           VykresliTlacidlo(Obr^.x1+6,Obr^.y1+udalost2*15+9,Obr^.x1+48,Polozka[udalost2,1],Polozka[udalost2,2],color);
        if (udalost2>6) and (udalost2<13) then
           VykresliTlacidlo(Obr^.x1+104,Obr^.y1+(udalost2-6)*15+9,Obr^.x1+186,Polozka[udalost2,1],Polozka[udalost2,2],color);
        ZapniKurzorMysi;
      end;
      udalost2l:=udalost2;
    end;
  until ((tlacidlo=1) and (udalost2=13) and (oznac>0))
     or ((tlacidlo=1) and (udalost2=15));
  ZlikvidujCennik;
  case oznac of
    1:begin sx:=32;sy:=32;end;
    2:begin sx:=32;sy:=24;end;
    3:begin sx:=24;sy:=24;end;
    5:begin sx:=24;sy:=32;end;
    6:begin sx:=24;sy:=24;end;
    7:begin sx:=32;sy:=24;end;
    8:begin sx:=40;sy:=32;end;
    9:begin sx:=40;sy:=32;end;
    10:begin sx:=40;sy:=40;end;
    11:begin sx:=40;sy:=16;end;
    12:begin sx:=40;sy:=40;end;
  end;
  ZistiPoziciu;
  xst:=x;yst:=y;
  pomw:=x div 2+y*320;      {v pomw je offset!!!}
  if udalost2=13 then begin
    asm
     call InitAsm
     lea si,pom                {nalepenie do VRAM}
     add si,768
     call VykresliCennik
    end;
    if (oznac<4) or ((Oznac>4) and (oznac<13)) then UmiestnovanieStavby;
    if oznac=4 then begin
      sx:=12;sy:=8;s:='CENNIK';NalepText;
      sx1:=2;sx2:=432;sy1:=32;sy2:=183;
      NastavRozsahSuradnic;
      repeat
        CakajNaPustenie;
        VypisInfo('ukladanie@cesty@ukonci@pravym@tlacidlom','');
        repeat ZistiPoziciu; until tlacidlo>0;
        if tlacidlo=1 then begin
          x:=(x div 16)*16+2;
          y:=(y div 8)*8+1;
          pomb:=sav.PPlocha[lhx+x div 16,lhy+(y-32) div 8];
          if pomb=0 then begin
            sav.PPlocha[lhx+x div 16,lhy+(y-32) div 8]:=4;
            sav.Peniaze:=sav.Peniaze-sav.Cennik[4];
            VypisKonto;
            NakresliCesty;
          end;
        end;
      until (tlacidlo=2) or (sav.Cennik[4]>sav.Peniaze);
      sx1:=2;sx2:=638;sy1:=1;sy2:=199;
      NastavRozsahSuradnic;
    end;
    asm
     call InitAsm
     lea si,pom                {nalepenie do VRAM}
     call VykresliCennik
    end;
  end;
end;
procedure ZobrazHra;
begin
  asm
     call InitAsm
     call VypniKurzorMysi
     lea si,pom                {nalepenie do VRAM}
     add si,768
     call VykresliHra
  end;
  sx:=84;sy:=8;s:='HRA';NalepText;
  VykresliRamcek(80,40,185,135);
  VykresliTlacidlo(Obr^.x1+11,Obr^.y1+11,Obr^.x1+93,'@@ulozit@@','@@@@@=@=@@',$AE);
  VykresliTlacidlo(Obr^.x1+11,Obr^.y1+26,Obr^.x1+93,'@@nahrat@@','@@@@@@@=@@',$AE);
  VykresliTlacidlo(Obr^.x1+11,Obr^.y1+41,Obr^.x1+93,'pozri@sem@','@@@@@@@@@>',$AE);
  VykresliTlacidlo(Obr^.x1+11,Obr^.y1+56,Obr^.x1+93,'@@koniec@@','@@@@@@@@@@',$AE);
  VykresliTlacidlo(Obr^.x1+11,Obr^.y1+71,Obr^.x1+93,'@@navrat@@','@@@;@@@@@@',$AE);
  VypisInfo(infoh[0],'');
  ZapniKurzorMysi;
end;
procedure Pomoc;
begin
  asm
     call InitAsm
     call VypniKurzorMysi
     lea si,pom                {nalepenie do VRAM}
     add si,768
     call VykresliPomoc
  end;
  sx:=136;sy:=8;s:='POMOC';NalepText;
  VykresliRamcek(80,50,160,150);
  asm
     call InitAsm
     mov ax,0
     int 16h
     lea si,pom                {nalepenie do VRAM}
     call VykresliPomoc
     call ZrusRamcek
     call ZapniKurzorMysi
  end;
  udalost:=0;
end;
procedure Demo;
begin
  VykresliRamcek(30,62,168,150);
  with obr^ do begin
    VypniKurzorMysi;
    sx:=x1+7;sy:=y1+10;s:='STRATEGICKA@HRA';NalepText;
             sy:=y1+5; s:='@@@@@@@@@@;@@@@';NalepText;
    sx:=x1+12;sy:=y1+24;s:='korporacia';NalepText;
              sy:=y1+20;s:='@@@@@@;@@@';NalepText;
    sx:=x1+5;sy:=y1+43;s:='programoval:';NalepText;
             sy:=y1+55;s:='LUBOS@SALOKY';NalepText;
             sy:=y1+51;s:='=@@@=@@@@@@@';NalepText;
  end;
  ZapniKurzorMysi;
  CakajNaPustenie;
  repeat ZistiPoziciu; until tlacidlo>0;
  ZrusRamcek;
end;
