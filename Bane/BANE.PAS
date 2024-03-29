program Kozmicke_bane;
uses Crt,BaneTPU;   {zmen riadok 633}
{riadok 204 - dokedy sa hra }
var f,fsav:file;
    a:array[0..3999] of byte absolute $B800:$0000;
    PomObr,ExtraPomObr:array[0..3999] of byte;
    b:array[1..80,1..25] of word;
    x,y,z,PocetBani,PocetLudi,Peniaze,Tazba,Zasoby,CenaBane,CenaRudy,
      Koniec,CenaSkladu,PocetSkladov,CenaDomu,PocetDomov,CenaBloku,
      PocetBlokov,CenaCesty,Rok,DoRoku,StareZasoby:longint;
    Spokojnost,PomSpok:real;
    sx,sy,akcia,pomkurzor:word;
    tlacidlo:byte;
    ch:char;
    s:string;
procedure NahrajPoziciu(poradie:word);
begin
  if poradie=100 then Assign(fsav,'banesav.bak')
  else begin
    if poradie>9 then poradie:=OknoSuborov(2);
    Assign(fsav,'save'+Chr(poradie+48)+'.dat');
  end;
  Reset(fsav,1);
  Seek(fsav,0);
  BlockRead(fsav,Peniaze,4);
  BlockRead(fsav,PocetLudi,4);
  BlockRead(fsav,CenaBane,4);
  BlockRead(fsav,CenaSkladu,4);
  BlockRead(fsav,CenaDomu,4);
  BlockRead(fsav,CenaBloku,4);
  BlockRead(fsav,CenaCesty,4);
  BlockRead(fsav,CenaRudy,4);
  BlockRead(fsav,Zasoby,4);
  BlockRead(fsav,Spokojnost,6);
  BlockRead(fsav,PocetBani,4);
  BlockRead(fsav,PocetSkladov,4);
  BlockRead(fsav,PocetDomov,4);
  BlockRead(fsav,PocetBlokov,4);
  for x:=2 to 22 do
    for y:=2 to 34 do
      BlockRead(fsav,b[y,x],2);
  VypniKurzor;
  Move(PomObr,a,SizeOf(a));
  for x:=1 to 21 do BlockRead(fsav,a[2+160*x],66);
  Tazba:=Random(60)+80;
  Move(a,PomObr,SizeOf(a));
  BlockRead(fsav,Rok,4);
  BlockRead(fsav,DoRoku,4);
  ZapniKurzor;
  Close(fsav);
end;
procedure UlozPoziciu(poradie:word);
begin
  if poradie>9 then poradie:=OknoSuborov(1);
  VypniKurzor;
  Move(PomObr,a,SizeOf(a));
  Assign(fsav,'save'+Chr(poradie+48)+'.dat');
  Rewrite(fsav,1);
  Seek(fsav,0);
  BlockWrite(fsav,Peniaze,4);
  BlockWrite(fsav,PocetLudi,4);
  BlockWrite(fsav,CenaBane,4);
  BlockWrite(fsav,CenaSkladu,4);
  BlockWrite(fsav,CenaDomu,4);
  BlockWrite(fsav,CenaBloku,4);
  BlockWrite(fsav,CenaCesty,4);
  BlockWrite(fsav,CenaRudy,4);
  BlockWrite(fsav,Zasoby,4);
  BlockWrite(fsav,Spokojnost,6);
  BlockWrite(fsav,PocetBani,4);
  BlockWrite(fsav,PocetSkladov,4);
  BlockWrite(fsav,PocetDomov,4);
  BlockWrite(fsav,PocetBlokov,4);
  for x:=2 to 22 do
    for y:=2 to 34 do
      BlockWrite(fsav,b[y,x],2);
  for x:=1 to 21 do BlockWrite(fsav,a[2+160*x],66);
  BlockWrite(fsav,Rok,4);
  BlockWrite(fsav,DoRoku,4);
    
  ZapniKurzor;
  Close(fsav);
end;
procedure Vypis;
begin
  TextColor(15);TextBackGround(0);
  GotoXY(59,17);write('       ');GotoXY(59,17);write(Peniaze);
  GotoXY(65,15);write('   ');GotoXY(65,15);write(PocetLudi);
  GotoXY(39,16);write('    ');GotoXY(39,16);write(Zasoby);
  GotoXY(50,2);write('     ');GotoXY(50,2);write(CenaBane);
  GotoXY(52,4);write('     ');GotoXY(52,4);write(CenaSkladu);
  GotoXY(50,6);write('     ');GotoXY(50,6);write(CenaDomu);
  GotoXY(51,8);write('     ');GotoXY(51,8);write(CenaBloku);
  GotoXY(51,10);write('     ');GotoXY(51,10);write(CenaCesty);
  GotoXY(50,12);write('     ');GotoXY(50,12);write(CenaRudy);
  GotoXY(64,20);write('    ');GotoXY(64,20);write(PocetLudi*100);
  TextColor(7);
  GotoXY(39,18);write('   ');GotoXY(39,18);write(200*PocetSkladov);
  if PocetSkladov>0 then z:=Zasoby div (5*PocetSkladov)
  else z:=0;
  for x:=43 to 50 do
    for y:=18 to 22 do begin
      a[(x-1)*2+(y-1)*160]:=177;
      a[(x-1)*2+(y-1)*160+1]:=7;
    end;
  x:=43;y:=22;
  while z>0 do begin
    a[(x-1)*2+(y-1)*160]:=219;
    a[(x-1)*2+(y-1)*160+1]:=6;
    Inc(x);
    Dec(z);
    if x=51 then begin
      x:=43;Dec(y);
    end;
  end;
  if Spokojnost<1 then y:=64
    else y:=16;
  z:=25-round(Spokojnost*11.5);
  for x:=2 to z-1 do begin
    a[156+(x-1)*160]:=177;
    a[157+(x-1)*160]:=7;
  end;
  if z<24 then begin
    for x:=z to 24 do begin
      a[156+(x-1)*160]:=255;
      a[157+(x-1)*160]:=y+15;
    end;
  end;
end;

procedure Zlikviduj(px,py,typ:word);{px,py - suradnice na obrazovke podla GotoXY}
var pom:word;
begin
  if a[(px-1)*2+(py-1)*160+2]=25 then Dec(py);{dolny riadok bane}
  pom:=px;
  while (b[pom,py] and $0700)=(b[pom+1,py] and $0700) do Dec(pom);
  case typ of
    $0100:begin
      VypniKurzor;
      pom:=pom+((px-pom) div 3)*3;
      for x:=pom*2+(py-1)*160 to pom*2+(py-1)*160+5 do a[x]:=0;
      for x:=pom+1 to pom+3 do b[x,py]:=$0000;
      Dec(PocetDomov);
      ZapniKurzor;
    end;
    $0200:begin
      VypniKurzor;
      pom:=pom+((px-pom) div 4)*4;
      for x:=pom*2+(py-1)*160 to pom*2+(py-1)*160+7 do a[x]:=0;
      for x:=pom*2+py*160 to pom*2+py*160+7 do a[x]:=0;
      for x:=pom+1 to pom+4 do b[x,py]:=$0000;
      for x:=pom+1 to pom+4 do b[x,py+1]:=$0000;
      Dec(PocetBani);
      Peniaze:=Peniaze+CenaBane;
      ZapniKurzor;
    end;
    $0300:begin
      VypniKurzor;
      pom:=pom+((px-pom) div 5)*5;
      for x:=pom*2+(py-1)*160 to pom*2+(py-1)*160+9 do a[x]:=0;
      for x:=pom+1 to pom+5 do b[x,py]:=$0000;
      Dec(PocetSkladov);
      Peniaze:=Peniaze+CenaSkladu;
      ZapniKurzor;
    end;
    $0400:begin
      VypniKurzor;
      pom:=pom+((px-pom) div 4)*4;
      for x:=pom*2+(py-1)*160 to pom*2+(py-1)*160+7 do a[x]:=0;
      for x:=pom+1 to pom+4 do b[x,py]:=$0000;
      Dec(PocetBlokov);
      ZapniKurzor;
    end;
    $0F00:begin
      VypniKurzor;
      GotoXY(px+1,py);
      write(' ');
      b[px+1,py]:=$0000;
      ZapniKurzor;
    end;
  end;
end;
procedure Pomoc;
begin
  VypniKurzor;
  Move(a,ExtraPomObr,SizeOf(a));
  ZapniKurzor;
  VypisInfo;
  VypniKurzor;
  Move(ExtraPomObr,a,4000);
  ZapniKurzor;
  ch:=' ';
end;

label 100;
BEGIN
  VypniTextovyKurzor;
  Assign(f,'bane.scr');
  Reset(f,4000);
  BlockRead(f,a[0],1);
  BlockRead(f,b[1,1],1);
  Close(f);
  Randomize;
  Rok:=2250;DoRoku:=2350;Koniec:=0;
  Move(a,PomObr,SizeOf(a));
  ZapniKurzor;
  NahrajPoziciu(100);
  Vypis;
  TextColor(7);TextBackGround(0);
  Umiestni(18,3, '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�');
  Umiestni(18,4, '�           H l a v n �   m e n u       �');
  Umiestni(18,5, '쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�');
  Umiestni(18,6, '� 1 - nov� hra                          �');
  Umiestni(18,7, '� 2 - nahra� z disku                    �');
  Umiestni(18,8, '� 3 - inform쟠ie a n쟶od                �');
  Umiestni(18,9, '� 4 - koniec hry                        �');
  Umiestni(18,10,'읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�');
  ch:=' ';
  repeat
    StavMysi(sx,sy,tlacidlo);
    if keypressed then ch:=ReadKey;
    if (ch='3') or ((tlacidlo=1) and (sx>=144) and (sx<=448) and (sy=56)) then Pomoc;
  until (ch='1') or (ch='2') or (ch='4') or
    ((tlacidlo=1) and (sx>=144) and (sx<=448) and (sy>=40) and (sy<=64) and (sy<>56));
  if ch=' ' then ch:=Chr((sy div 8)+44);
  case ch of
    '1':NahrajPoziciu(100);
    '2':NahrajPoziciu(11);
    '4':begin
      Koniec:=1;
      goto 100;
    end;
  end;
  Vypis;
  Informuj('');
  repeat
    repeat
      akcia:=0;
      repeat
        StavMysi(sx,sy,tlacidlo);
        if (tlacidlo=1) and (b[sx div 8+1,sy div 8+1]>0) then akcia:=b[sx div 8+1,sy div 8+1];
        tlacidlo:=0;
      until (keypressed) or (akcia>0);
      if keypressed then ch:=ReadKey;
      case akcia of
        1:begin
          Informuj('Ukladaj bane 뻕v�m tla웙dlom, ukon웙 prav�m.');
          OknoKurzora(8,240,8,160);
          repeat
            StavMysi(sx,sy,tlacidlo);
          until tlacidlo=0;
          repeat
            StavMysi(sx,sy,tlacidlo);
            sx:=sx div 8;sy:=sy div 8;
            if (tlacidlo=1) and (b[sx+1,sy+1]=0) and (b[sx+2,sy+1]=0) and
            (b[sx+3,sy+1]=0) and (b[sx+4,sy+1]=0) and (b[sx+1,sy+2]=0) and
            (b[sx+2,sy+2]=0) and (b[sx+3,sy+2]=0) and (b[sx+4,sy+2]=0) and (Peniaze>CenaBane) then begin
              VypniKurzor;
              GotoXY(sx+1,sy+1);
              write('BA�A');
              GotoXY(sx+1,sy+2);
              write('');
              a[sx*2+sy*160+1]:=32+15;
              a[sx*2+sy*160+3]:=32+15;
              a[sx*2+sy*160+5]:=32+15;
              a[sx*2+sy*160+7]:=32+15;
              a[sx*2+sy*160+161]:=32+15;
              a[sx*2+sy*160+163]:=32+15;
              a[sx*2+sy*160+165]:=32+15;
              a[sx*2+sy*160+167]:=32+15;
              ZapniKurzor;
              for x:=1 to 4 do b[sx+x,sy+1]:=$0200;
              for x:=1 to 4 do b[sx+x,sy+2]:=$0200;
              Peniaze:=Peniaze-CenaBane;
              Inc(PocetBani);
              Vypis;
            end;
          until tlacidlo=3;
          OknoKurzora(0,632,0,192);
          Informuj('');
        end;
        2:begin
          Informuj('Klikni na ba�u, ktor� chce� preda�, prav�m ukon웙.');
          OknoKurzora(8,264,8,168);
          repeat
            StavMysi(sx,sy,tlacidlo);
          until tlacidlo=0;
          repeat
            StavMysi(sx,sy,tlacidlo);
            sx:=sx div 8;sy:=sy div 8;
            if (tlacidlo=1) and (b[sx+1,sy+1] and $0700=$0200) then Zlikviduj(sx,sy+1,$0200);
          until Tlacidlo=3;
          OknoKurzora(0,632,0,192);
          Informuj('');
        end;
        3:begin
          Informuj('Ukladaj sklady 뻕v�m tla웙dlom, ukon웙 prav�m.');
          OknoKurzora(8,232,8,168);
          repeat
            StavMysi(sx,sy,tlacidlo);
          until tlacidlo=0;
          repeat
            StavMysi(sx,sy,tlacidlo);
            sx:=sx div 8;sy:=sy div 8;
            if (tlacidlo=1) and (b[sx+1,sy+1]=0) and (b[sx+2,sy+1]=0) and
            (b[sx+3,sy+1]=0) and (b[sx+4,sy+1]=0) and (b[sx+5,sy+1]=0) and (Peniaze>CenaSkladu) then begin
              VypniKurzor;
              GotoXY(sx+1,sy+1);
              write('SKLAD');
              a[sx*2+sy*160+1]:=96+15;
              a[sx*2+sy*160+3]:=96+15;
              a[sx*2+sy*160+5]:=96+15;
              a[sx*2+sy*160+7]:=96+15;
              a[sx*2+sy*160+9]:=96+15;
              ZapniKurzor;
              for x:=1 to 5 do b[sx+x,sy+1]:=$0300;
              Peniaze:=Peniaze-CenaSkladu;
              Inc(PocetSkladov);
              Vypis;
            end;
          until tlacidlo=3;
          OknoKurzora(0,632,0,192);
          Informuj('');
        end;
        4:begin
          Informuj('Klikni na sklad, ktor� chce� preda�, prav�m ukon웙.');
          OknoKurzora(8,232,8,168);
          repeat
            StavMysi(sx,sy,tlacidlo);
          until tlacidlo=0;
          repeat
            StavMysi(sx,sy,tlacidlo);
            sx:=sx div 8;sy:=sy div 8;
            if (tlacidlo=1) and (b[sx+1,sy+1] and $0700=$0300) then Zlikviduj(sx,sy+1,$0300);
          until Tlacidlo=3;
          OknoKurzora(0,632,0,192);
          Informuj('');
        end;
        5:begin
          Informuj('Ukladaj domy 뻕v�m tla웙dlom, ukon웙 prav�m.');
          OknoKurzora(8,248,8,168);
          repeat
            StavMysi(sx,sy,tlacidlo);
          until tlacidlo=0;
          repeat
            StavMysi(sx,sy,tlacidlo);
            sx:=sx div 8;sy:=sy div 8;
            if (tlacidlo=1) and (b[sx+1,sy+1]=0) and (b[sx+2,sy+1]=0) and
            (b[sx+3,sy+1]=0) and (Peniaze>CenaDomu) then begin
              VypniKurzor;
              GotoXY(sx+1,sy+1);
              write(' 4 ');
              a[sx*2+sy*160+1]:=95;
              a[sx*2+sy*160+3]:=95;
              a[sx*2+sy*160+5]:=95;
              ZapniKurzor;
              for x:=1 to 3 do b[sx+x,sy+1]:=$0100;
              Peniaze:=Peniaze-CenaDomu;
              Inc(PocetDomov);
              Vypis;
            end;
          until tlacidlo=3;
          OknoKurzora(0,632,0,192);
          Informuj('');
        end;
        6:begin
          Informuj('Klikni na dom, ktor� chce� zb즦a�, prav�m ukon웙.');
          OknoKurzora(8,264,8,168);
          repeat
            StavMysi(sx,sy,tlacidlo);
          until tlacidlo=0;
          repeat
            StavMysi(sx,sy,tlacidlo);
            sx:=sx div 8;sy:=sy div 8;
            if (tlacidlo=1) and (b[sx+1,sy+1] and $0700=$0100) then Zlikviduj(sx,sy+1,$0100);
          until Tlacidlo=3;
          OknoKurzora(0,632,0,192);
          Informuj('');
        end;
        7:begin
          Informuj('Ukladaj bloky 뻕v�m tla웙dlom, ukon웙 prav�m.');
          OknoKurzora(8,240,8,168);
          repeat
            StavMysi(sx,sy,tlacidlo);
          until tlacidlo=0;
          repeat
            StavMysi(sx,sy,tlacidlo);
            sx:=sx div 8;sy:=sy div 8;
            if (tlacidlo=1) and (b[sx+1,sy+1]=0) and (b[sx+2,sy+1]=0) and
            (b[sx+3,sy+1]=0) and (b[sx+4,sy+1]=0) and (Peniaze>CenaBloku) then begin
              VypniKurzor;
              GotoXY(sx+1,sy+1);
              write(' 20 ');
              a[sx*2+sy*160+1]:=31;
              a[sx*2+sy*160+3]:=31;
              a[sx*2+sy*160+5]:=31;
              a[sx*2+sy*160+7]:=31;
              ZapniKurzor;
              for x:=1 to 4 do b[sx+x,sy+1]:=$0400;
              Peniaze:=Peniaze-CenaBloku;
              Inc(PocetBlokov);
              Vypis;
            end;
          until tlacidlo=3;
          OknoKurzora(0,632,0,192);
          Informuj('');
        end;
        8:begin
          Informuj('Klikni na blok, ktor� chce� zb즦a�, prav�m ukon웙.');
          OknoKurzora(8,240,8,168);
          repeat
            StavMysi(sx,sy,tlacidlo);
          until tlacidlo=0;
          repeat
            StavMysi(sx,sy,tlacidlo);
            sx:=sx div 8;sy:=sy div 8;
            if (tlacidlo=1) and (b[sx+1,sy+1] and $0700=$0400) then Zlikviduj(sx,sy+1,$0400);
          until Tlacidlo=3;
          OknoKurzora(0,632,0,192);
          Informuj('');
        end;
        9:begin
          Informuj('Ukladaj cesty 뻕v�m tla웙dlom, ukon웙 prav�m.');
          OknoKurzora(8,264,8,168);
          repeat
            StavMysi(sx,sy,tlacidlo);
          until tlacidlo=0;
          repeat
            StavMysi(sx,sy,tlacidlo);
            sx:=sx div 8;sy:=sy div 8;
            if (tlacidlo=1) and (b[sx+1,sy+1]=0) and (Peniaze>CenaCesty) then begin
              b[sx+1,sy+1]:=$0F00;
              if b[sx+1,sy]>0 then begin
                b[sx+1,sy+1]:=b[sx+1,sy+1] or $1000;
                b[sx+1,sy]:=b[sx+1,sy] or $4000;
              end;
              if b[sx+2,sy+1]>0 then begin
                b[sx+1,sy+1]:=b[sx+1,sy+1] or $2000;
                b[sx+2,sy+1]:=b[sx+2,sy+1] or $8000;
              end;
              if b[sx+1,sy+2]>0 then begin
                b[sx+1,sy+1]:=b[sx+1,sy+1] or $4000;
                b[sx+1,sy+2]:=b[sx+1,sy+2] or $1000;
              end;
              if b[sx,sy+1]>0 then begin
                b[sx+1,sy+1]:=b[sx+1,sy+1] or $8000;
                b[sx,sy+1]:=b[sx,sy+1] or $2000;
              end;
              VypniKurzor;
              NakresliCestu(sx+1,sy+1,b[sx+1,sy+1]);
              if b[sx+1,sy]>0 then NakresliCestu(sx+1,sy,b[sx+1,sy]);
              if b[sx+2,sy+1]>0 then NakresliCestu(sx+2,sy+1,b[sx+2,sy+1]);
              if b[sx+1,sy+2]>0 then NakresliCestu(sx+1,sy+2,b[sx+1,sy+2]);
              if b[sx,sy+1]>0 then NakresliCestu(sx,sy+1,b[sx,sy+1]);
              ZapniKurzor;
              Peniaze:=Peniaze-CenaCesty;
              Vypis;
            end;
          until tlacidlo=3;
          OknoKurzora(0,632,0,192);
          Informuj('');
        end;
        10:begin
          Informuj('Likviduj cesty 뻕v�m tla웙dlom, ukon웙 prav�m.');
          OknoKurzora(8,264,8,168);
          repeat
            StavMysi(sx,sy,tlacidlo);
          until tlacidlo=0;
          repeat
            StavMysi(sx,sy,tlacidlo);
            sx:=sx div 8;sy:=sy div 8;
            if (tlacidlo=1) and (b[sx+1,sy+1] and $0F00=$0F00) then Zlikviduj(sx,sy+1,$0F00);
          until Tlacidlo=3;
          OknoKurzora(0,632,0,192);
          Informuj('');
        end;
        11:begin
          SpytajSa('Ko뻢o rudy pred좂?',Zasoby,x);
          Peniaze:=Peniaze+x*CenaRudy;
          Zasoby:=Zasoby-x;
          Vypis;
        end;
        12:begin
          SpytajSa('Ko뻢o minie� na platy?',Peniaze,x);
          if (x<PocetLudi*100) and (Peniaze>=PocetLudi*100) then begin
            Informuj('Rozmysli si to!!! Skuto웢e im chce� da� len to뻢o? A/N');
            ch:=ReadKey;
            if (ch='n') or (ch='N') then akcia:=0;
            Informuj('');
          end;
        end;
        13:begin
          VypniKurzor;
          Move(a,PomObr,SizeOf(a));
          ZapniKurzor;
          UlozPoziciu(11);
        end;
        14:begin
          NahrajPoziciu(11);
          Vypis;
        end;
        15:Pomoc;
        16:begin
          Koniec:=1;
          goto 100;
        end;
        $0100:begin
          repeat
            StavMysi(sx,sy,tlacidlo);
          until tlacidlo=0;
          Informuj('V jednom dome 쬲j� �tyria obyvatelia.');
          PrepisInformacnyRiadok;
        end;
        $0200:begin
          repeat
            StavMysi(sx,sy,tlacidlo);
          until tlacidlo=0;
          Str(Tazba,s);
          Insert('Z jednej bane sa vy쏿㎕ ',s,1);
          s:=s+' ton rudy.';
          Informuj(s);
          PrepisInformacnyRiadok;
        end;
        $0300:begin
          repeat
            StavMysi(sx,sy,tlacidlo);
          until tlacidlo=0;
          Informuj('Kapacita jedn괿o skladu je 200 ton rudy.');
          PrepisInformacnyRiadok;
        end;
        $0400:begin
          repeat
            StavMysi(sx,sy,tlacidlo);
          until tlacidlo=0;
          Informuj('V jednom bloku 쬲je 20 obyvate뻩v.');
          PrepisInformacnyRiadok;
        end;
      end;
    until (akcia=12) or (koniec>0);
    Peniaze:=Peniaze-x;
    Spokojnost:=x/PocetLudi/100;
    if Spokojnost<0.1 then Koniec:=1;
    if Spokojnost>2 then Spokojnost:=2;

    {alternativa k vyradenemu textu (pozri dalej)}
    Zasoby:=Zasoby+Tazba*PocetBani;
    if Spokojnost>1.1 then PocetLudi:=PocetLudi+Random(10)+round(10*Spokojnost-10);
    if Spokojnost<0.9 then PocetLudi:=PocetLudi-Random(10);
    if Zasoby>PocetSkladov*200 then Zasoby:=PocetSkladov*200;
    if PocetDomov*4+PocetBlokov*20<PocetLudi then PocetLudi:=PocetDomov*4+PocetBlokov*20;
    CenaBane:=(Random(40)+40)*50;
    CenaSkladu:=(Random(10)+10)*50;
    CenaBloku:=(Random(20)+20)*50;
    CenaDomu:=(Random(6)+7)*50;
    CenaCesty:=(Random(6)+2)*10;
    CenaRudy:=Random(10)+12;
    Tazba:=Random(80)+80;

  {  Umiestni(18,3, '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커');
    Umiestni(18,4, '�         V roku ',Rok,'                    �');
    Umiestni(18,5, '쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑');
    Umiestni(18,6, '퀂a z jednej bane vy쏿쬲lo       ton.    �');
    Umiestni(18,7, '� * po웕t ban�                           �');
    Umiestni(18,8, '�                          ------        �');
    Umiestni(18,9, '쿏o skladov pribudlo             ton.    �');
    Umiestni(18,10,'� + star� z쟳oby                 ton.    �');
    Umiestni(18,11,'�                          ------        �');
    Umiestni(18,12,'쿙a sklade je teraz              ton.    �');
    Umiestni(18,13,'쿞kladov� kapacita               ton.    �');
    StareZasoby:=Zasoby;
    Zasoby:=Zasoby+Tazba*PocetBani;
    Umiestni(18,14,'쿖oeficient spokojnosti sa ');
    if PomSpok<Spokojnost then Write('zv鱗il')
      else Write('zn¨il');
    WriteLn(' na ',Spokojnost:1:2,'�');
    pomkurzor:=15;
    if Spokojnost>1.1 then begin
      PocetLudi:=PocetLudi+Random(10)+round(10*Spokojnost-10);
      Umiestni(18,pomkurzor,'쿏o osady pri�li �al簾 obyvatelia.       �');
      Inc(pomkurzor);
    end;
    if Spokojnost<0.9 then begin
      PocetLudi:=PocetLudi-Random(10);
      Umiestni(18,pomkurzor,'쿩 osady odi�li niektor� nespokojenci.   �');
      Inc(pomkurzor);
    end;
    if Zasoby>PocetSkladov*200 then begin
      Zasoby:=PocetSkladov*200;
      Umiestni(18,pomkurzor,'쿞klady nesta웙li.Str쟠a� 웏s� z쟳ob rudy�');
      Inc(pomkurzor);
    end;
    if PocetDomov*4+PocetBlokov*20<PocetLudi then begin
      PocetLudi:=PocetDomov*4+PocetBlokov*20;
      Umiestni(18,pomkurzor,'쿚bydlia nesta웙a. Niektor� 뻰dia odi�li.�');
      Inc(pomkurzor);
    end;
    Umiestni(18,pomkurzor,'�                                        �');
    Umiestni(18,pomkurzor+1,'�                   ');
    TextBackGround(6);TextColor(15);
    Write(' OK ');
    TextBackGround(0);TextColor(7);
    WriteLn('                 �');
    Umiestni(18,pomkurzor+2,'읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸');
    GotoXY(46,6);Write(Tazba);
    GotoXY(46,7);Write(PocetBani);
    GotoXY(46,9);Write(Tazba*PocetBani);
    GotoXY(46,10);Write(StareZasoby);
    GotoXY(46,12);Write(Zasoby);
    GotoXY(46,13);Write(200*PocetSkladov);
    CenaBane:=(Random(40)+40)*50;
    CenaSkladu:=(Random(10)+10)*50;
    CenaBloku:=(Random(20)+20)*50;
    CenaDomu:=(Random(6)+7)*50;
    CenaCesty:=(Random(6)+2)*10;
    CenaRudy:=Random(10)+12;
    Tazba:=Random(80)+80;
    Informuj('Stla� 뻰bovo뻨� kl쟶esu alebo klikni na OK.');
    repeat
      StavMysi(sx,sy,tlacidlo);
    until (keypressed) or ((tlacidlo=1) and (sy=pomkurzor*8) and (sx>=296) and (sx<=320));
    if keypressed then ch:=ReadKey;
    case ch of
      'k':Koniec:=1;
      else begin
        VypniKurzor;
        Move(PomObr,a,SizeOf(a));
        ZapniKurzor;
      end;
    end;   }
    Inc(rok);
    Informuj('');
    GotoXY(26,1);TextColor(LightCyan);write(Rok);
    Vypis;
  until (Rok>=DoRoku) or (Koniec>0);;
  UlozSkore(PocetLudi);
  ZapniKurzor;
  100:
  ZapniTextovyKurzor;
END.