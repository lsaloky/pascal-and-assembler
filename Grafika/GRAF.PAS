program Kreslenie_grafu;
uses Graph;
const maxx=315;maxy=195;minx=5;miny=5;
      ciary:array[1..6,1..4] of integer=
       ((minx,maxy-13,maxx,maxy-13),(minx+25,miny,minx+25,maxy),
        (minx+20,miny+5,minx+25,miny),(minx+30,miny+5,minx+25,miny),
        (maxx-5,maxy-8,maxx,maxy-13),(maxx-5,maxy-18,maxx,maxy-13));
      CiarkaAbsX=0.5;CiarkaAbsY=4.5;
      CiarkaRelX=0.5;CiarkaRelY=0.5;
var gd,gm,x,posx,posy:integer;
    xmin,xmax,ymin,ymax,xrel,yrel,datax,datay,ciarka:real;
    s:string;
BEGIN
  gd:=InstallUserDriver('svga256',nil);gm:=0;{inicializacia grafiky}
  InitGraph(gd,gm,'d:\bp\bgi');
  xmin:=0.2;xmax:=4.8;ymin:=4.3;ymax:=7.1;   {nastavenie zobrazovaneho rozsahu}
  {---- dalsich 6 riadkov vyhod ---- }
  datax:=4.8;datay:=7.1;
  SetColor(12);
  Line(0,0,maxx+4,0);                        {kreslenie ramceka okolo}
  Line(maxx+4,0,maxx+4,maxy+4);
  Line(maxx+4,maxy+4,0,maxy+4);
  Line(0,maxy+4,0,0);
  xrel:=(xmax-xmin)/(maxx-minx-25);
  yrel:=(ymax-ymin)/(maxy-miny-13);
  SetColor(30);                              {kreslenie postrannych ciarok}
  ciarka:=CiarkaAbsX;
  while ciarka<xmax do begin
    posx:=Round((ciarka-xmin)/xrel+minx+25);
    Str(ciarka:0:1,s);
    OutTextXY(posx-12,maxy-10,s);
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
  PutPixel(Round((datax-xmin)/xrel+minx+25),Round((ymax-datay)/yrel+miny),100);
  asm
    mov ah,0
    int 16h
  end;
END.