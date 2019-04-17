program Bezierove_krivky;
uses Graph,Crt;
type s=array[0..79,0..479]of byte;
const gd:integer=9;
      gm:integer=2;
      pocet=4;
      a:array[1..pocet,1..2]of integer=((300,100),(200,420),(20,220),(620,435));
      mazanie=10;      {rychlost mazania v Snieziku}
      dlzka=20;        {dlzka ciar v Snieziku}
      Cierne=40;       {Velkost ciernych ploch v Hmle a v Snieziku}
      Hustotaciar=2;   {Hustota ciar v Smej£cich sa farb ch}
      pocethviezd=280; {pocet hviezd}
var x,y,z,barx,bary,col,count:integer;
    t:real;
    pom,pom2:array[1..200,1..2]of integer;
    smery:array[1..pocet,1..2]of integer;
    l:s;
    f:file of s;
    pokus:array[1..400,1..4]of integer;
    hviezda:array[0..pocethviezd,1..2] of integer;

procedure vypocet;
begin
  for z:=1 to 20 do begin
    pom[z,1]:=round((1-t)*(1-t)*(1-t)*a[1,1]+3*(1-t)*(1-t)*t*a[2,1]+3*(1-t)*t*t*a[3,1]+t*t*t*a[4,1]);
    pom[z,2]:=round((1-t)*(1-t)*(1-t)*a[1,2]+3*(1-t)*(1-t)*t*a[2,2]+3*(1-t)*t*t*a[3,2]+t*t*t*a[4,2]);
    t:=t+0.05;
  end;
end;

procedure Nakresli(pom1,pom2:word);
begin
  if l[x div 8,y]>=pom1 then begin
    PutPixel(x+pom2,y,4);
    l[x div 8,y]:=l[x div 8,y]-pom1;
  end;
end;

BEGIN
  initgraph(gd,gm,'d:\bp\bgi');
  assign(f,'vision16.dat');
  reset(f);
  read(f,l);
  randomize;
  for y:=0 to 479 do begin
    for x:=0 to 639 do begin
      Nakresli(128,7);
      Nakresli(64,6);
      Nakresli(32,5);
      Nakresli(16,4);
      Nakresli(8,3);
      Nakresli(4,2);
      Nakresli(2,1);
      Nakresli(1,0);
    end;
  end;
  Delay(500);
  col:=1300;
  for x:=1 to pocet do begin
    smery[x,1]:=random(6)+5;
    smery[x,2]:=random(6)+5;
    if random(2)=1 then smery[x,1]:=-smery[x,1];
    if random(2)=1 then smery[x,2]:=-smery[x,2];
  end;
  vypocet;
  repeat
    t:=0;
    move(pom,pom2,sizeof(pom));
    vypocet;
    for x:=1 to pocet do begin
      a[x,1]:=a[x,1]+smery[x,1]+random(5)-2;
      a[x,2]:=a[x,2]+smery[x,2]+random(5)-2;
      smery[x,1]:=smery[x,1]+random(3)-1;
      smery[x,2]:=smery[x,2]+random(3)-1;
      if smery[x,1]>9 then smery[x,1]:=7;
      if smery[x,1]<-9 then smery[x,1]:=-7;
      if smery[x,2]>9 then smery[x,2]:=7;
      if smery[x,2]<-9 then smery[x,2]:=-7;
      if (a[x,1]<0) or (a[x,1]>639) then smery[x,1]:=-smery[x,1];
      if (a[x,2]<0) or (a[x,2]>479) then smery[x,2]:=-smery[x,2];
    end;
    SetColor(col div 100);
    for x:=1 to 19 do begin
      Line(pom[x,1],pom[x,2],pom[x+1,1],pom[x+1,2]);
    end;
    Inc(col);
  until col>3200;
  for z:=1 to 400 do begin
    x:=random(639);y:=random(479);
    pokus[z,1]:=x;
    pokus[z,2]:=y;
    pokus[z,3]:=x+random(dlzka)-dlzka div 2;
    pokus[z,4]:=y+random(dlzka)-dlzka div 2;
    Setcolor(random(15)+1);
    line(pokus[z,1],pokus[z,2],pokus[z,3],pokus[z,4]);
  end;
  count:=0;
  repeat
    SetColor(0);
    Line(pokus[1,1],pokus[1,2],pokus[1,3],pokus[1,4]);
    move(pokus[2,1],pokus[1,1],sizeof(pokus));
    x:=random(639);y:=random(479);
    pokus[400,1]:=x;
    pokus[400,2]:=y;
    pokus[400,3]:=x+random(dlzka)-dlzka div 2;
    pokus[400,4]:=y+random(dlzka)-dlzka div 2;
    SetColor(random(15)+1);
    line(pokus[400,1],pokus[400,2],pokus[400,3],pokus[400,4]);
    Inc(count);
  until count>30000;
  for x:=1 to pocethviezd do begin
    hviezda[x,1]:=random(580)+10;
    hviezda[x,2]:=random(420)+10;
  end;
  SetColor(0);
  for x:=0 to 320 do begin
    Line(x,x mod 240,640-x,x mod 240);
    Line(640-x,x mod 240,640-x,480-x mod 240);
    Line(640-x,480-x mod 240,x,480-x mod 240);
    Line(x,480-x mod 240,x,x mod 240);
  end;
  count:=0;
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
    Inc(count);
  until count=10;
  count:=0;
  ClearDevice;
  repeat
    for z:=1 to 8 do
    begin
      for y:=0 to pocethviezd-1 do begin
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
      end;
    end;
    Inc(count);
  until count=10;
  CloseGraph;
  WriteLn('MukoSoft demo'#13#10'Lubos Saloky, 1996');
end.