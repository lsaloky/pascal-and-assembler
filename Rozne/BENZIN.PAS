
program Statistika_spotreby_benzinu;
uses Graph;
const maxx=1019;maxy=763;minx=5;miny=5;
      PocetVyhladeni=200;
      ciary:array[1..6,1..4] of integer=
       ((minx,maxy-13,maxx,maxy-13),(minx+25,miny,minx+25,maxy),
        (minx+20,miny+5,minx+25,miny),(minx+30,miny+5,minx+25,miny),
        (maxx-5,maxy-8,maxx,maxy-13),(maxx-5,maxy-18,maxx,maxy-13));
      CiarkaAbsX=10000;CiarkaAbsY=5;
      CiarkaRelX=10000;CiarkaRelY=1;
var data:text;     {-1 znamena cena benzinu}
    Km:longint;
    Litre,LitreSucet,CenaBenzinu,Peniaze:real;
    Datum:string;
    k1,k2,gd,gm,x,posx,posy:integer;
    xmin,xmax,ymin,ymax,xrel,yrel,datax,datay,ciarka,PoslKm,PoslLitre:real;
    Krivka,Krivka2:array[0..1024] of real;
    s:string;
BEGIN
  gd:=InstallUserDriver('svga256',nil);gm:=4;{inicializacia grafiky}
  InitGraph(gd,gm,'d:\bp\bgi');
  xmin:=0;xmax:=66000;ymin:=4;ymax:=10;   {nastavenie zobrazovaneho rozsahu}
  {---- dalsich 6 riadkov vyhod ---- }
  datax:=4.8;datay:=7.1;
  xrel:=(xmax-xmin)/(maxx-minx-25);
  yrel:=(ymax-ymin)/(maxy-miny-13);
  SetColor(30);                              {kreslenie postrannych ciarok}
  ciarka:=CiarkaAbsX;
  while ciarka<xmax do begin
    posx:=Round((ciarka-xmin)/xrel+minx+25);
    Str(ciarka:0:1,s);
    OutTextXY(posx-20,maxy-10,s);
    Line(posx,maxy-11,posx,maxy-15);
    ciarka:=ciarka+CiarkaRelX;
  end;
  ciarka:=CiarkaAbsY;
  while ciarka<ymax do begin
    posy:=Round((ymax-ciarka)/yrel+miny);
    Str(ciarka:0:1,s);
    OutTextXY(minx-1,posy-3,s);
    Line(minx+23,posy,minx+27,posy);
    ciarka:=ciarka+CiarkaRelY;
  end;
  SetColor(100);
  for x:=1 to 6 do Line(ciary[x,1],ciary[x,2],ciary[x,3],ciary[x,4]);
  Assign(data,'benzin.dat');
  Reset(data);
  Peniaze:=0;LitreSucet:=0;PoslKm:=0;PoslLitre:=1;
  SetColor(12);
  while not EOF(data) do begin
    Read(data,Km);
    if km>-1 then begin
      Read(data,Litre,Datum);
      ReadLn(data);
      LitreSucet:=LitreSucet+Litre;
      Peniaze:=Peniaze+Litre*CenaBenzinu;
{      if km=15 then MoveTo(Round((km-xmin)/xrel+minx+25),Round((ymax-PoslLitre/(km-PoslKm)*100)/yrel+miny))
       else LineTo(Round((km-xmin)/xrel+minx+25),Round((ymax-PoslLitre/(km-PoslKm)*100)/yrel+miny));}
      for k1:=Round((PoslKm-xmin)/xrel) to Round((Km-xmin)/xrel) do Krivka[k1]:=Litre*100/(Km-PoslKm);
      PoslKm:=km;PoslLitre:=Litre;
    end else Read(data,CenaBenzinu);
  end;
  SetColor(LightBlue);
  for k2:=1 to PocetVyhladeni do begin
    MoveTo(minx+25,Round(MaxY-6*(MaxY-MinY)/YMax));
    Krivka2[0]:=7;{akoze spotreba hned po zakupeni}
    Krivka2[1]:=7;
    Krivka2[2]:=7;
    Krivka2[3]:=7;
    Krivka2[MaxX-3]:=7;
    Krivka2[MaxX-2]:=7;
    Krivka2[MaxX-1]:=7;
    Krivka2[MaxX]:=7;
    for k1:=4 to MaxX-4 do Krivka2[k1]:=
      (Krivka[k1-4]
    +2*Krivka[k1-3]
    +3*Krivka[k1-2]
    +4*Krivka[k1-1]
    +5*Krivka[k1]
    +4*Krivka[k1+1]
    +3*Krivka[k1+2]
    +2*Krivka[k1+3]
    +Krivka[k1+4])/25;
    for k1:=1 to Maxx do LineTo(k1+minx+25,Round(MaxY-Krivka2[k1]*(MaxY-MinY)/YMax));
    Move(Krivka2,Krivka,SizeOf(Krivka2));
  end;
  MoveTo(minx+25,Round(MaxY-6*(MaxY-MinY)/YMax));
  SetColor(15);
  for k1:=1 to Maxx do LineTo(k1+minx+25,Round(MaxY-Krivka2[k1]*(MaxY-MinY)/YMax));
  asm
    mov ah,0
    int 16h
  end;
  CloseGraph;
  writeln('Spotrebovanych bolo ',LitreSucet:0:2,' litrov benzinu na ',Km,' kilometrov.');
  writeln('Celkove vydavky na benzin su ',Peniaze:0:2,' Kcs (Sk)');
  writeln('Priemerna spotreba je ',LitreSucet*100/Km:1:2,' litra na 100 kilometrov.');
  Close(data);
END.
