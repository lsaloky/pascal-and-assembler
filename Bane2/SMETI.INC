procedure NakresliCesty;forward;
procedure SpracujLudiaRuda;forward;
{ZOZNAM PROCEDUR:
  PVykresliBMPTlacidlo;
  VypisKonto;
  VpisCislo(cis,poz:word);  do retazca s
  NacitajDvaBajty;
  VypisInfo(l:string);
  VykresliTlacidlo(x1,y1,x2:word;text,diak:string); !!!! modifikuje sx,sy,s !!!!
  VykresliRamcek(x1,y1,x2,y2);
  ZrusRamcek;
  ZlikvidujCennik;
  ZlikvidujHra;
  ZobrazSubory(titul,tituldiak:string);
  SpracujUlozenieSuboru;
  UmiestnovanieStavby;
  PosunVlavo;
  PosunVpravo;
  PosunHore;
  PosunDole;
  TestCiJeNovonahrate;
  NakresliMapu;}
procedure PVykresliBMPTlacidlo(px,py,posun:word;text,diak:string);
begin
  pomw:=px+py*320;
  asm
             call InitAsm
             lea si,pom
             call VykresliBMPTlacidlo
  end;
  sx:=px+posun;sy:=py+5;s:=text;NalepText;
  sx:=px+posun;sy:=py+1;s:=diak;NalepText;
end;
procedure VpisCislo(cis,poz:longint);
var t:string;
    err:word;
begin
  Str(cis,t);
  for err:=1 to length(t) do s[poz+err-1]:=t[err];
end;
procedure VpisCisloVpravo(cis,poz:longint);
var t:string;
    err:word;
begin
  Str(cis,t);
  for err:=1 to Length(t) do s[err+poz-Length(t)]:=t[err];
end;
procedure VypisKonto;
begin
  asm
             call InitAsm
             mov di,252+172*320
             mov ax,0
             mov dx,48
             mov bx,8
             call ZacierniPlochu
  end;
  sx:=252;sy:=172;s:='@@@@@@';VpisCisloVpravo(sav.Peniaze,6);
  NalepText;

end;
procedure NacitajDvaBajty;assembler;
asm
             mov ah,3Fh
             mov cx,2
             lea dx,pomw
             int 21h
end;
procedure VypisInfo(l,diak:string);
begin
  asm
             call InitAsm
             mov di,188*320
             mov ax,0
             mov dx,320
             mov bx,12
             call ZacierniPlochu
  end;
  sx:=0;sy:=191;s:=l;NalepText;
  sx:=0;sy:=188;s:=diak;NalepText;
end;
procedure VykresliTlacidlo(x1,y1,x2:word;text,diak:string;farba:byte);
var o,len:word;
begin
  sx:=x1;sy:=y1;kolko:=x2-x1;color:=33;CiaraVodorovna;
         sy:=y1+12;                    CiaraVodorovna;
  sx:=x1;sy:=y1;kolko:=13;             CiaraZvisla;
  sx:=x2;                              CiaraZvisla;

  o:=y1*320+x1+321;
  len:=Length(text)*8+1;
  asm
             call InitAsm
             mov di,o
             mov al,farba
             mov ah,farba
             mov dx,len
             mov bx,11
             call ZacierniPlochu
  end;
  sx:=x1+1;sy:=y1+4;s:=text;NalepText;
  sx:=x1+1;sy:=y1+1;s:=diak;NalepText;
end;
procedure VykresliRamcek(x1,y1,x2,y2:word);
var size,o,driadka:word;
begin
  size:=(x2-x1)*(y2-y1);
  o:=y1*320+x1;
  driadka:=320-x2+x1;
{ ----- pripojenie v strukture na zaciatok ----- }
  New(p);
  p^.Dalsia:=Obr;
  Obr:=p;
  Obr^.x1:=x1;
  Obr^.y1:=y1;
  Obr^.x2:=x2;
  Obr^.y2:=y2;
  GetMem(Obr^.BitMap,size);
  p:=Obr^.Bitmap;
  VypniKurzorMysi;
  asm
             les di,p
             push ds
             cld
             mov ax,0A000h
             mov ds,ax
             call VypniKurzorMysi
             mov si,o
             mov bx,y2
             sub bx,y1
@DalsiRiadok:mov cx,x2
             sub cx,x1
         rep movsb
             add si,driadka
             dec bx
             jnz @DalsiRiadok
             call ZapniKurzorMysi
             pop ds
             mov ax,0A000h
             mov es,ax
             mov ax,0
             mov di,o
             mov dx,x2
             sub dx,x1
             mov bx,y2
             sub bx,y1
             call ZacierniPlochu
{ ----- nastavenie rozsahu pre mys ----- }
             mov cx,x1
             add cx,cx
             sub cx,4
             mov dx,x2
             add dx,dx
             sub dx,4
             mov ax,7
             int 33h
             mov cx,y1
             sub cx,2
             mov dx,y2
             sub dx,2
             mov ax,8
             int 33h
  end;
  sx:=x1+2;sy:=y1+2;kolko:=y2-y1-4;color:=5;CiaraZvisla;
  sx:=x1+3;                                 CiaraZvisla;
  sx:=x2-3;                                 CiaraZvisla;
  sx:=x2-4;                                 CiaraZvisla;
  sx:=x1+2;sy:=y1+2;kolko:=x2-x1-4;         CiaraVodorovna;
           sy:=y1+3;                        CiaraVodorovna;
           sy:=y2-3;                        CiaraVodorovna;
           sy:=y2-4;                        CiaraVodorovna;
  for x:=1 to size div 30 do Bod(random(Obr^.x2-Obr^.x1-8)+Obr^.x1+4,random(Obr^.y2-Obr^.y1-8)+Obr^.y1+4,random(16)+16);
  ZapniKurzorMysi;
end;
procedure ZrusRamcek;
var size,o,driadka,x1,y1,x2,y2:word;
begin
  x1:=Obr^.x1;y1:=Obr^.y1;x2:=Obr^.x2;y2:=Obr^.y2;
  size:=(x2-x1)*(y2-y1);{velkost bitmapy}
  o:=y1*320+x1;                   {offset}
  driadka:=320-x2+x1;             {posunutie na obrazovke pri prechode na novy riadok}
{ ----- pripojenie v strukture na zaciatok ----- }
                {Obr ukazuje na zaciatok struktury}
  p:=Obr^.Bitmap;
  VypniKurzorMysi;
  asm
             cld
             les si,p
             mov dx,driadka
             push ds
             mov di,o
             mov ax,y2
             sub ax,y1
             mov bl,al
             mov ax,x2
             sub ax,x1
             mov bh,al
             mov ax,es
             mov ds,ax
             mov ax,0A000h
             mov es,ax
             mov cx,0
@DalsiRiadok:mov cl,bh
         rep movsb
             add di,dx
             dec bl
             cmp bl,0
             jne @DalsiRiadok
             pop ds
             call ZapniKurzorMysi
             mov cx,2
             mov dx,638
             mov ax,7
             int 33h
             mov cx,1
             mov dx,199
             mov ax,8
             int 33h
  end;
  ZapniKurzorMysi;
  FreeMem(Obr^.BitMap,size);
  p:=Obr;
  Obr:=Obr^.Dalsia;
  Dispose(p);
  if obr<>nil then begin
    x1:=Obr^.x1;y1:=Obr^.y1;x2:=Obr^.x2;y2:=Obr^.y2;
  end else begin
    x1:=3;y1:=3;x2:=321;y2:=201;
  end;
  asm
             call InitAsm
             mov cx,x1
             add cx,cx
             sub cx,4
             mov dx,x2
             add dx,dx
             sub dx,4
             mov ax,7
             int 33h
             mov cx,y1
             sub cx,2
             mov dx,y2
             sub dx,2
             mov ax,8
             int 33h
  end;
end;
procedure ZlikvidujCennik;
begin
  asm
     call InitAsm
     lea si,pom                {nalepenie do VRAM}
     call VykresliCennik
     call ZrusRamcek
  end;
  udalost:=0;
  VypisInfo('','');
end;
procedure ZlikvidujHra;
begin
  asm
     call InitAsm
     lea si,pom                {nalepenie do VRAM}
     call VykresliHra
     call ZrusRamcek
  end;
  if udalost2<>4 then udalost:=0;
  VypisInfo('','');
end;
procedure ZobrazSubory(titul,tituldiak:string);
begin
  VykresliRamcek(30,55,220,175);
  with obr^ do begin
    VypniKurzorMysi;
    sx:=x1+29;sy:=y1+12;s:=titul+'@poziciu';NalepText;
              sy:=y1+8;s:=tituldiak+'@@@@;@@@';NalepText;
    sx:=x1+4;sy:=y1+20;kolko:=x2-x1-8;color:=5;CiaraVodorovna;
             sy:=y1+21;                        CiaraVodorovna;
    Seek(fsav,0);
    for x:=0 to 4 do begin
      read(fsav,pomsav);
      if pomsav.NazovSAVu='' then pomsav.NazovSAVu:='@@volna@pozicia@@@@@';
      VykresliTlacidlo(x1+11,y1+x*15+24,x1+173,pomsav.NazovSAVu,'',$AE);
    end;
    VykresliTlacidlo(x1+55,y1+102,x1+121,'@navrat@','@@;@@@@@',$AE);
  end;
  ZapniKurzorMysi;
  CakajNaPustenie;
  repeat
    ZistiPoziciu;
    udalost3:=0;
    for c1:=1 to 6 do if (x>oblsub[c1,1]) and (y>oblsub[c1,2]) and (x<oblsub[c1,3]) and (y<oblsub[c1,4]) then udalost3:=c1;
  until tlacidlo=1;
end;
procedure SpracujUlozenieSuboru;
begin
  if udalost3<6 then begin
    sav.NazovSAVu:='';
    VypniKurzorMysi;
    with Obr^ do begin
      VykresliTlacidlo(x1+11,y1+udalost3*15+9,x1+173,'@@@@@@@@@@@@@@@@@@@@','',$AE);
      sx:=x1+13;sy:=y1+udalost3*15+12;
      kolko:=8;Color:=30;CiaraZvisla;
      repeat
        repeat
          asm
             mov ax,0
             int 16h
             mov pomb,al
          end;
          ch:=Chr(pomb);
        until ch in mozne;
        if (ch=#8) and (sav.NazovSAVu>'') then begin
          Dec(sav.NazovSAVu[0]);
          pomw:=sx;pomw2:=sy;
          VykresliTlacidlo(x1+11,y1+udalost3*15+9,x1+173,'@@@@@@@@@@@@@@@@@@@@','',$AE);
          sx:=x1+13;sy:=pomw2;s:=sav.NazovSAVu;NalepText;
          color:=$AE;kolko:=8;CiaraZvisla;
          sx:=pomw-8;
          color:=30;CiaraZvisla;
        end;
        if ch=' ' then pomb:=Ord('@');
        if (ch<>#13) and (ch<>#8) then begin
          color:=$AE;CiaraZvisla;
          s:=Chr(pomb);NalepText;sx:=sx+8;
          color:=30;CiaraZvisla;
          sav.NazovSAVu:=sav.NazovSAVu+s;
        end;
      until ch=#13;
    end;
    ZapniKurzorMysi;
    for x:=Length(sav.NazovSAVu) to 19 do sav.NazovSAVu:=sav.NazovSAVu+'@';
    Seek(fsav,udalost3-1);
    write(fsav,sav);
  end;
  CakajNaPustenie;
  ZrusRamcek;
end;
procedure UmiestnovanieStavby;
label SkocDnu;
begin
  pomw3:=sx;pomw4:=sy;
  sx:=12;sy:=8;s:='CENNIK';NalepText;
  VypisInfo('lavym@tlacidlom@poloz@stavbu','');
  sx:=pomw3;sy:=pomw4;
  asm
             call InitAsm
             call CakajNaPustenie
             call VypniKurzorMysi
             mov sx1,0
             mov sx2,432
             mov sy1,32
             mov sy2,180
             call NastavRozsahSuradnic
{ ----- prvotne ulozenie podkladu ----- }
             lea di,podklad
             mov cx,sx
             mov dx,sy
             mov si,pomw
             call UlozPodklad
{ ----- obnovenie podkladu ----- }
SkocDnu:     call InitAsm
@Cakaj:      call CakajNaVOI
             mov ax,x
             and ax,$FFF0
             mov x,ax
             mov ax,y
             and ax,$FFF8
             mov y,ax
             mov ax,yst
             mov cx,320
             mul cx
             mov bx,xst
             shr bx,1
             add ax,bx
             mov di,ax
             mov cx,sx
             mov dx,sy
             lea si,podklad
             call ObnovPodklad
{ ----- ulozenie noveho podkladu ----- }
             mov ax,y
             mov cx,320
             mul cx
             mov bx,x
             shr bx,1
             add ax,bx
             mov si,ax
             mov cx,sx
             mov dx,sy
             lea di,podklad
             call UlozPodklad
{ ----- kreslenie objektu ----- }
             mov dx,x
             shr dx,1
             mov cx,y
             cmp oznac,1
             jne @Case2
             call NakresliBanu
@Case2:      cmp oznac,2
             jne @Case3
             call NakresliSklad
@Case3:      cmp oznac,3
             jne @Case5
             call NakresliDom
@Case5:      cmp oznac,5
             jne @Case6
             call NakresliBlok
@Case6:      cmp oznac,6
             jne @Case7
             call NakresliKino
@Case7:      cmp oznac,7
             jne @Case8
             call NakresliKniznicu
@Case8:      cmp oznac,8
             jne @Case9
             call NakresliOceliaren
@Case9:      cmp oznac,9
             jne @Case10
             call NakresliElektraren
@Case10:     cmp oznac,10
             jne @Case11
             call NakresliZbrojovku
@Case11:     cmp oznac,11
             jne @Case12
             call NakresliRCentrum
@Case12:     cmp oznac,12
             jne @CaseEnd
             call NakresliBonus
@CaseEnd:    mov ax,x            {posun suradnic}
             mov xst,ax
             mov ax,y
             mov yst,ax
@Pozicia:    call ZistiPoziciu
             cmp tlacidlo,0
             jne @BolKlik
             cmp xst,cx
             jne @TestTlacidla
             cmp yst,dx
             jne @TestTlacidla
             jmp @Pozicia
@TestTlacidla:cmp tlacidlo,0
             je @Cakaj
{ ----- kontrola, ci je mozne tu umiestnit objekt ----- }
@BolKlik:
  end;
  if tlacidlo=1 then begin
    pomw:=0;OK:=true;
    if lhy+(yst-32) div 8+roz[oznac,2]>51 then OK:=false;
    while sav.stavba[pomw,1]>0 do begin
      pomb:=lhx+xst div 16;        {x-ova lavy horny okraj novej}
      pomb2:=lhy+(yst-32) div 8;   {y-ova }
      if (pomb>=sav.stavba[pomw,2]) and
         (pomb<=sav.stavba[pomw,2]+roz[sav.stavba[pomw,1],1]) and
         (pomb2>=sav.stavba[pomw,3]) and
         (pomb2<=sav.stavba[pomw,3]+roz[sav.stavba[pomw,1],2]) then OK:=false;
      pomb:=lhx+xst div 16+roz[oznac,1];{x-ova pravy horny,y-ova ost.}
      if (pomb>=sav.stavba[pomw,2]) and
         (pomb<=sav.stavba[pomw,2]+roz[sav.stavba[pomw,1],1]) and
         (pomb2>=sav.stavba[pomw,3]) and
         (pomb2<=sav.stavba[pomw,3]+roz[sav.stavba[pomw,1],2]) then OK:=false;
      pomb2:=lhy+(yst-32) div 8+roz[oznac,2];{y-ova pravy dolny,x-ova ost.}
      if (pomb>=sav.stavba[pomw,2]) and
         (pomb<=sav.stavba[pomw,2]+roz[sav.stavba[pomw,1],1]) and
         (pomb2>=sav.stavba[pomw,3]) and
         (pomb2<=sav.stavba[pomw,3]+roz[sav.stavba[pomw,1],2]) then OK:=false;
      pomb:=lhx+xst div 16;{x-ova lavy dolny, y-ova ostava}
      if (pomb>=sav.stavba[pomw,2]) and
         (pomb<=sav.stavba[pomw,2]+roz[sav.stavba[pomw,1],1]) and
         (pomb2>=sav.stavba[pomw,3]) and
         (pomb2<=sav.stavba[pomw,3]+roz[sav.stavba[pomw,1],2]) then OK:=false;
      Inc(pomw);
    end;
    if OK=false then goto SkocDnu;
    VypisInfo('','');
    pomw:=0;
    while sav.stavba[pomw,1]>0 do Inc(pomw);
    sav.stavba[pomw,1]:=oznac;
    sav.stavba[pomw,2]:=lhx+x div 16;
    sav.stavba[pomw,3]:=lhy+(y-32) div 8;
    sav.Peniaze:=sav.Peniaze-sav.Cennik[oznac];
    VypisKonto;
    for pomb:=0 to roz[oznac,1]-1 do
      for pomb2:=0 to roz[oznac,2]-1 do
         sav.PPlocha[lhx+x div 16+pomb,lhy+(y-32) div 8+pomb2]:=oznac;
    if oznac<>4 then Inc(sav.Pocet[oznac])
    else begin
      asm
             call InitAsm
             mov ax,yst
             mov cx,320
             mul cx
             mov bx,xst
             shr bx,1
             add ax,bx
             mov di,ax
             mov cx,sx
             mov dx,sy
             lea si,podklad
             call ObnovPodklad
      end;
      VypisInfo('','');
    end;
    if stav then begin
      asm
             call InitAsm
             lea si,ludia
             mov di,20*320+236
             call VykresliLudiaRuda
             lea si,ruda
             add si,640
             mov di,20*320+276
             call VykresliLudiaRuda
      end;
    end else begin
      asm
             call InitAsm
             lea si,ludia
             add si,640
             mov di,20*320+236
             call VykresliLudiaRuda
             lea si,ruda
             mov di,20*320+276
             call VykresliLudiaRuda
      end;
    end;
    SpracujLudiaRuda;
  end;
  if tlacidlo=2 then begin
    asm
             call InitAsm
             mov ax,x
             and ax,$FFF0
             mov x,ax
             mov ax,y
             and ax,$FFF8
             mov y,ax
             mov ax,yst
             mov cx,320
             mul cx
             mov bx,xst
             shr bx,1
             add ax,bx
             mov di,ax
             mov cx,sx
             mov dx,sy
             lea si,podklad
             call ObnovPodklad
    end;
  end;
  sx1:=2;sx2:=638;sy1:=1;sy2:=199;
  NastavRozsahSuradnic;
  ZapniKurzorMysi;
end;
procedure PosunVlavo;
begin
  if lhx>0 then begin
    CakajNaVOI;
    ObnovPodkladPodVodListou;
    ObnovPodkladPodZvisListou;
    Dec(lhx);
    PosunVRAMVpravo;
    NakresliObjekty;
    NakresliCesty;
  end;
end;

procedure PosunVpravo;
begin
  if lhx<34 then begin
    CakajNaVOI;
    ObnovPodkladPodVodListou;
    ObnovPodkladPodZvisListou;
    Inc(lhx);  {rozmer mapy je 62}
    PosunVRAMVlavo;
    NakresliObjekty;
    NakresliCesty;
  end;
end;
procedure PosunHore;
begin
  if lhy>0 then begin
    CakajNaVOI;
    ObnovPodkladPodVodListou;
    ObnovPodkladPodZvisListou;
    Dec(lhy);
    PosunVRAMDole;
    NakresliObjekty;
    NakresliCesty;
  end;
end;
procedure PosunDole;
begin
  if lhy<33 then begin
    CakajNaVOI;
    ObnovPodkladPodVodListou;
    ObnovPodkladPodZvisListou;
    Inc(lhy);
    PosunVRAMHore;
    NakresliObjekty;
    NakresliCesty;
  end;
end;
procedure TestCiJeNovonahrate;
begin
  if Zobraz then begin
    sx:=0;sy:=24;s:='[``````````````````````````\{';NalepText;
    sx:=224;sy:=32;s:=']';NalepText;
    sx:=224;s:='_';
    for x:=5 to 21 do begin
      sy:=x*8;
      NalepText;
    end;
    sx:=224;sy:=176;s:='^';NalepText;
    sx1:=0;sx2:=223;sy1:=32*320;sy2:=183*320;
    NakresliAktivnuOblast;
    NakresliObjekty;
    NakresliCesty;
    VypisKonto;
    asm
             call InitAsm
             call VypniKurzorMysi
             lea si,ludia
             mov di,20*320+236
             call VykresliLudiaRuda
             lea si,ruda
             add si,640
             mov di,20*320+276
             call VykresliLudiaRuda
             call ZapniKurzorMysi
    end;
    stav:=true;
    SpracujLudiaRuda;
    Zobraz:=false;
  end;
end;
procedure NakresliMapu;
begin
  asm
     call InitAsm
     mov di,32*320
     mov dx,224
     mov bx,152
     xor ax,ax
     call ZacierniPlochu
  end;
  for x:=0 to 69 do
    for y:=0 to 52 do begin
      pomw:=sav.PPlocha[x,y];
      if pomw=5 then pomw:=13;
      Bod(42+x*2,55+y*2,pomw);
      Bod(43+x*2,55+y*2,pomw);
      Bod(42+x*2,56+y*2,pomw);
      Bod(43+x*2,56+y*2,pomw);
    end;
  sx:=41;sy:=160;kolko:=143;Color:=29;CiaraVodorovna;
         sy:=54;                      CiaraVodorovna;
                 kolko:=106;          CiaraZvisla;
  sx:=184;                            CiaraZvisla;

  CakajNaPustenie;
  repeat ZistiPoziciu until tlacidlo>0;
  ObnovPodkladPodVodListou;
  ObnovPodkladPodZvisListou;
{ ----- vypocitanie lhx,lhy po kliknuti na zvolene miesto ----- }
  if (x>84) and (x<368) and (y>55) and (y<161) then begin
    if x<140 then x:=140;
    if x>276 then x:=276;
    if y<73 then y:=73;
    if y>140 then y:=140;
    lhx:=(x-84) div 4-14;
    lhy:=(y-55) div 2-9;
  end;
  sx1:=0;sx2:=223;sy1:=32*320;sy2:=183*320;
  VypniKurzorMysi;
  NakresliAktivnuOblast;
  NakresliObjekty;
  NakresliCesty;
  ZapniKurzorMysi;
end;
