program setric_obrazovky;
uses Dos,Crt,Graph;
               { -------- nastavovanie hardwarovych n rokov -------- }
const pocet=220;       {Hypno - pocet stvorcov}
      mazanie=10;      {rychlost mazania v Snieziku}
      dlzka=20;        {dlzka ciar v Snieziku}
      hustotahmly=700; {Hmla - mnozstvo bieleho}
      ekonomika=1000;  {Rychlost rot cie farbovych registrov v ekonom. prosp. Slov.}
      Amater1=15;      {Tiez pre Amat‚rsky efekt c. 1}
      Dezko=19;        {Len nep rne c¡sla pre Jezka Dezka}
      Dezkofarby=500;  {Rychlost striedania farieb pri Dezkovi}
      Strana=100;      {Strana stvorca v Hmle, max. 100}
      Cierne=40;       {Velkost ciernych ploch v Hmle a v Snieziku}
      Hustotaciar=2;   {Hustota ciar v Smej£cich sa farb ch}
      Zmensovanie=4;
               {v ostatnych efektoch zv„csa niet co nastavovat}

type obraz=array[0..5258] of byte;
var gd,gm,x,y,z,cislo,x1,y1,x2,y2,barx,bary,dezkopol:integer;
    xz,yz:real;
    pom1,pom2:shortint;
    hviezda:array[1..pocet,1..2] of integer;
    palette:palettetype;
    p:^obraz;
    t:longint;
    s:string;
    ch:char;
BEGIN
  ClrScr;
  repeat                                 {celoprogramovy Repeat}
    closegraph;
    writeln('Efekt cislo:');
    writeln('1 - Amat‚rsky efekt');
    writeln('2 - "Sniezik sa n m chumel¡"');
    writeln('3 - "Cesta za ekonomickou prosperitou Slovenska"');
    writeln('4 - "Hypno"');
    writeln('5 - Amat‚rsky efekt #2');
    writeln('6 - "Carbanice jezka Dezka"');
    writeln('7 - "Hmla"');
    writeln('8 - "Smej£ce sa farby"');
    writeln('0 - Koniec programu');
    readln(cislo);
    gd:=9;gm:=2;
    if cislo>0 then initgraph(gd,gm,'d:\bp\bgi');
    case cislo of
    1:begin
        GetPalette(palette);
        pom1:=SizeOf(palette.colors);
        repeat
        for y:=1 to amater1 do
        begin
          x:=random(32);
          if x>16 then x:=0;
          SetFillStyle(random(12),x);
          pieslice(random(639),random(479),random(180),random(360),random(100));
        end;                             {of for y}
        pom2:=palette.colors[pom1-1];
        move(palette.colors[1],palette.colors[2],pom1-1);
        palette.colors[1]:=pom2;
        for x:=1 to pom1-1 do
          SetPalette(x,palette.colors[x]);
        until keypressed;
      end;                               {of case 1}
    2:begin
        SetfillStyle(0,0);
        repeat
          Setcolor(random(16));
          x:=random(639);y:=random(479);
          line(x,y,x+random(dlzka)-dlzka div 2,y+random(dlzka)-dlzka div 2);
          if random(mazanie)=0 then begin
            barx:=random(640);
            bary:=random(480);
            bar(barx,bary,barx+random(cierne),bary+random(cierne));
          end;
        until keypressed;
      end;                               {of case 2}
    3:begin
        MoveTo(320,240);
        x:=320;y:=200;t:=0;
        GetPalette(palette);
        pom1:=SizeOf(palette.colors);
        repeat
          Setcolor(random(16));
          x:=x+random(5)-2;y:=y+random(5)-2;
          if x>639 then x:=639;
          if x<0 then x:=0;
          if y>479 then y:=479;
          if y<0 then y:=0;
          LineTo(x,y);
          Inc(t);
          if t mod ekonomika=0 then
          begin
            pom2:=palette.colors[pom1-1];
            move(palette.colors[1],palette.colors[2],pom1-1);
            palette.colors[1]:=pom2;
            for z:=1 to pom1-1 do
              SetPalette(z,palette.colors[z]);
          end;                           {of if}
          if t mod 200000=0 then
          begin
            cleardevice;
            MoveTo(320,240);
            t:=0;x:=320;y:=240;
          end;                           {of if}
        until keypressed;
      end;                               {of case 3}
    4:begin
        for x:=1 to pocet do begin
          hviezda[x,1]:=random(580)+10;
          hviezda[x,2]:=random(420)+10;
        end;                           {of for x}
        repeat
          for z:=1 to 8 do
          begin
            for y:=0 to pocet do begin
              SetColor(y mod 15+1);
              if y=0 then SetColor(0);
              x:=(y+z) mod 8;
              MoveTo(hviezda[y,1]+15-2*x,15+hviezda[y,2]);
              Lineto(hviezda[y,1]+15,15-2*x+hviezda[y,2]);
              LineTo(hviezda[y,1]+15+2*x,15+hviezda[y,2]);
              LineTo(hviezda[y,1]+15,15+2*x+hviezda[y,2]);
              LineTo(hviezda[y,1]+15-2*x,15+hviezda[y,2]);
              SetColor(0);
              MoveTo(hviezda[y+1,1]+15-2*x,15+hviezda[y+1,2]);
              Lineto(hviezda[y+1,1]+15,15-2*x+hviezda[y+1,2]);
              LineTo(hviezda[y+1,1]+15+2*x,15+hviezda[y+1,2]);
              LineTo(hviezda[y+1,1]+15,15+2*x+hviezda[y+1,2]);
              LineTo(hviezda[y+1,1]+15-2*x,15+hviezda[y+1,2]);
            end;                       {of for y}
          end;                         {of for z}
        until keypressed;
      end;                             {of case 4}
    5:begin
        repeat
          SetFillStyle(random(13),random(16));
          x:=random(640);
          y:=random(480);
          Bar(x,y,x+random(100),y+random(100))
        until keypressed;
      end;                             {of case 5}
    6:begin
        dezkopol:=(dezko-1) div 2;
        x1:=random(200)+100;
        y1:=random(200)+10;
        x2:=random(240)+300;
        y2:=random(200)+200;
        repeat
          Line(x1,y1,x2,y2);
          if random(dezkofarby)=0 then SetColor(random(15)+1);
          x1:=x1+random(dezko)-dezkopol;
          y1:=y1+random(dezko)-dezkopol;
          x2:=x2+random(dezko)-dezkopol;
          y2:=y2+random(dezko)-dezkopol;
          if x1<0 then x1:=0;
          if x1>640 then x1:=640;
          if y1<0 then y1:=0;
          if y1>480 then y1:=480;
          if x2>640 then x2:=640;
          if x2<0 then x2:=0;
          if y2>480 then y2:=480;
          if y2<0 then y2:=0;
        until keypressed;
      end;                             {of case 6}
    7:begin
        GetMem(p,ImageSize(50,0,50+strana,strana));
        for x:=1 to hustotahmly do PutPixel(random(strana)+70,random(strana),random(15)+1);
        GetImage(70,0,70+strana,strana,p^);
        x:=70;y:=0;xz:=3;yz:=3;
        repeat
          x:=round(x+xz);
          y:=round(y+yz);
          if yz<0 then yz:=yz*0.98;
          if yz>0 then yz:=yz*1.020408;
          if x>630-strana then begin
            x:=631-strana;
            xz:=-xz;
          end;
          if x<0 then begin
            x:=1;
            xz:=-xz;
          end;
          if y<0 then begin
            y:=1;
            yz:=-yz;
          end;
          if y>489-strana then begin
            y:=488-strana;
            yz:=-yz;
          end;
          PutImage(x,y,p^,ORPut);
          SetfillStyle(0,black);
          barx:=random(640-cierne);bary:=random(480-cierne);
          Bar(barx,bary,barx+random(cierne),bary+random(cierne));
        until keypressed;
      end;                             {of case 7}
    8:begin
        repeat
          MoveTo(0,0);
          x:=0;
          while x<640 do begin
            for y:=1 to 2 do begin
              MoveTo(x,0);
              LineTo(639,(x*3)div 4);
              LineTo(639-x,479);
              LineTo(0,479-(x*3)div 4);
              LineTo(x,0);
              Inc(x,hustotaciar);
            end;
            MoveTo(320,(x*3) div 8);
            LineTo(320+x div 2,240);
            LineTo(320,479-(x*3) div 8);
            LineTo(320-x div 2,240);
            LineTo(320,(x*3) div 8);
          end;
          SetColor(GetColor+1);
        until keypressed;
      end;                             {of case 8}
    9:begin
        s:='Vesel‚ Vianoce';
        SetTextJustify(CenterText,CenterText);
        SetTextStyle(TriplexFont,HorizDir,1);
        z:=40*zmensovanie+3;
        repeat
          for x:=1 to 14 do begin
            while z>zmensovanie do begin
              SetUserCharSize(z,1,z,1);
              SetColor(black);
              OutTextXY(x*40,240,s[x]);
              SetUserCharSize(z-zmensovanie,1,z-zmensovanie,1);
              SetColor(blue);
              OutTextXY(x*40,240,s[x]);
              delay(10);
              Dec(z,zmensovanie);
            end;
            z:=40*zmensovanie+3;
          end;
        until keypressed;
      end;                             {of case 9}
    end;                               {of case total}
  until cislo=0;
end.