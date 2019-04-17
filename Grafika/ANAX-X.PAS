program grafmaster;
uses graph,crt,dos;
const HorizRes=320;
      VertRes=200;
var x,y,xmin,xmax,ymin,ymax,xrel,yrel,a,aposun,newx:real;
    gd,gm,osX,osY,posun,z,store:integer;
    s:string;
    ch:char;                              {pre ReadKey}
    mensie:boolean;
procedure Vypocitaj;           {vypocita funkcnu hodnotu pre zadanu horizontalnu suradnicu}
begin
  asm
             mov ax,0A000h
             mov es,ax
             xor ax,ax
             xor di,di
             mov cx,32000
         rep stosw
  end;
  if ch<>'' then begin
    str(ymin:3:2,s);
    outtextxy(0,0,'ymin=');
    outtextxy(48,0,s);
    str(ymax:3:2,s);
    outtextxy(0,10,'ymax=');
    outtextxy(48,10,s);
    str(xmin:3:2,s);
    outtextxy(0,20,'xmin=');
    outtextxy(48,20,s);
    str(xmax:3:2,s);
    outtextxy(0,30,'xmax=');
    outtextxy(48,30,s);
    str(a:1:10,s);
    outtextxy(0,40,s);
    str(newx:1:10,s);
    outtextxy(0,50,s);
  end;
  osY:=trunc(-xmin/xrel);
  line(osY,0,osY,VertRes-1);
  osX:=round(VertRes*ymax/(ymax-ymin));
  line(0,osX,HorizRes-1,osX);
  for z:=0 to 319 do begin
    x:=xmax-xrel*(HorizRes-z);
{ ----- tu je zadana funkcia ----- }
    if x*ln(a)<3 then y:=Exp(x*ln(a))-x;
    if y<0 then begin
      mensie:=true;
      newx:=x;
    end;
    PutPixel(z,round((VertRes*(ymax-y))/(ymax-ymin)),2);
  end;
end;
BEGIN
  gd:=InstallUserDriver('svga256',nil);gm:=0;
  initgraph(gd,gm,'d:\bp\bgi');
  xmin:=-2;xmax:=2;ymin:=-0.1;ymax:=2;x:=xmin;posun:=5;
  xrel:=(xmax-xmin)/HorizRes;
  yrel:=(ymax-ymin)/VertRes;
  a:=2;aposun:=0.05;mensie:=false;
  SetColor(31);Vypocitaj;
  repeat
    ch:=readkey;
    case ch of
      'a':begin
        xmin:=xmin-xrel*posun;
        xmax:=xmax-xrel*posun;
      end;
      's':begin
        xmin:=xmin+xrel*posun;
        xmax:=xmax+xrel*posun;
      end;
      'w':begin
        ymin:=ymin+yrel*posun;
        ymax:=ymax+yrel*posun;
      end;
      'z':begin
        ymin:=ymin-yrel*posun;
        ymax:=ymax-yrel*posun;
      end;
      '+':begin
        xmin:=xmin-xrel*2;
        xmax:=xmax+xrel*2;
        ymin:=ymin-yrel*2;
        ymax:=ymax+yrel*2;
        xrel:=(xmax-xmin)/HorizRes;
        yrel:=(ymax-ymin)/VertRes;
      end;
      '-':begin
        xmin:=xmin+xrel*2;
        xmax:=xmax-xrel*2;
        ymin:=ymin+yrel*2;
        ymax:=ymax-yrel*2;
        xrel:=(xmax-xmin)/HorizRes;
        yrel:=(ymax-ymin)/VertRes;
      end;
      '/':a:=a+aposun;
      '*':a:=a-aposun;
    end;
    Vypocitaj;
    if mensie=true then begin
      a:=a+aposun;
      aposun:=aposun/10;
      mensie:=false;
    end;
    if ch<>'c'then ch:=' ';
  until ch='c';
END.

