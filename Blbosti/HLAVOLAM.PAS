program Bludiskovy_hlavolam;
uses Crt;
label 1;
const pocetdveri=9;
      dvere:array[1..pocetdveri,1..3]of byte=((6,1,0),(3,2,1),(1,4,0),(3,4,0),(4,5,1),(7,5,0),(4,9,0),(8,9,0),(9,1,0));
var x,y,z,tah,zakaz,prikaz,posx,posy:integer;  {dvere[x,3]=1 => vodorovn‚}
    ch,ch2:char;                               {dvere[x,3]=0 => zvisl‚}
    plocha:array[0..10,0..10] of integer;

procedure Koniec;
begin
  gotoxy(30,10);
  writeln('        Skoncil si, mal si prejst dvere!!!        ');
  delay(600);
end;

procedure ZlavaDole;
begin
  write('É');
  gotoxy(wherex-1,wherey+1);
  write('×');
  gotoxy(wherex-1,wherey+1);
end;

procedure ZhoraDole;
begin
  gotoxy(wherex+1,wherey);
  write('º');
  gotoxy(wherex-1,wherey+1);
  write('×');
  gotoxy(wherex-1,wherey+1);
end;

procedure SpravaDole;
begin
  write('»');
  gotoxy(wherex-1,wherey+1);
  write('×');
  gotoxy(wherex-1,wherey+1);
end;

procedure ZhoraVpravo;
begin
  gotoxy(wherex+1,wherey);
  write('ÈÍØÍÍ');
end;

procedure ZlavaVpravo;
begin
  write('ÍÍØÍÍ');
end;

procedure ZdolaVpravo;
begin
  gotoxy(wherex+1,wherey);
  write('ÉÍØÍÍ');
end;
procedure ZhoraVlavo;
begin
  gotoxy(wherex-3,wherey);
  write('ÍÍØÍ¼');
  gotoxy(wherex-4,wherey);
end;

procedure ZdolaVlavo;
begin
  gotoxy(wherex-3,wherey);
  write('ÍÍØÍ»');
  gotoxy(wherex-4,wherey);
end;

procedure SpravaVlavo;
begin
  gotoxy(wherex-3,wherey);
  write('ÍØÍÍÍ');
  gotoxy(wherex-5,wherey);
end;

procedure ZlavaHore;
begin
  write('¼');
  gotoxy(wherex-1,wherey-1);
  write('×');
  gotoxy(wherex-1,wherey-1);
end;

procedure SpravaHore;
begin
  write('È');
  gotoxy(wherex-1,wherey-1);
  write('×');
  gotoxy(wherex-1,wherey-1);
end;

procedure ZdolaHore;
begin
  gotoxy(wherex+1,wherey);
  write('º');
  gotoxy(wherex-1,wherey-1);
  write('×');
  gotoxy(wherex-1,wherey-1);
end;

begin                                     { ***** HLAVNY PROGRAM ***** }
  tah:=0;ClrScr;posx:=1;posy:=9;prikaz:=0;
  for x:=0 to 10 do
    for y:=0 to 10 do
      plocha[x,y]:=1;
  for x:=1 to 9 do
    for y:=1 to 9 do
      plocha[x,y]:=0;
  plocha[1,9]:=1;
  write(' ÚÄÄÄ');
  for x:=1 to 8 do write('ÂÄÄÄ');
  writeln('¿');
  for x:=1 to 8 do begin
    write(' ³                                   ³');
    writeln;
    write(' ÃÄ Ä');
    for y:=1 to 8 do write('ÅÄ Ä');
    writeln('´');
  end;
  write(' ³                                   ³');
  writeln;
  write(' ÀÄ×Ä');
  for x:=1 to 8 do write('ÁÄÄÄ');
  writeln('Ù');
  for x:=1 to pocetdveri do begin
    if dvere[x,3]=1 then begin
      gotoxy(4*dvere[x,1],2*dvere[x,2]+1);
      write('Û');
    end;
    if dvere[x,3]=0 then begin
      gotoxy(2+4*dvere[x,1],2*dvere[x,2]);
      write('Û');
    end;
  end;
  gotoxy(4,18);ch2:='8';
  write('');gotoxy(wherex-1,wherey);
  repeat
    repeat
      ch:=readkey;
      for z:=1 to pocetdveri do begin
        if (dvere[z,3]=0) and (posx=dvere[z,1]) and (posy=dvere[z,2]) then zakaz:=6;
        if (dvere[z,3]=0) and (posx=dvere[z,1]+1) and (posy=dvere[z,2]) then zakaz:=4;
        if (dvere[z,3]=1) and (posx=dvere[z,1]) and (posy=dvere[z,2]) then zakaz:=2;
        if (dvere[z,3]=1) and (posx=dvere[z,1]) and (posy=dvere[z,2]+1) then zakaz:=8;
      end;
      if (tah mod 9=8) and (zakaz>0) then begin
        prikaz:=zakaz;
        zakaz:=0;
      end;
      if (tah mod 9=8) and (zakaz=0) then begin
        Koniec;
        goto 1;
      end;
      x:=wherex;y:=wherey;
      gotoxy(20,20);
      write(tah,';',prikaz,';',zakaz);
      gotoxy(x,y);
    until ((ch='2') and (zakaz<>2) and (ch2<>'8') and (plocha[posx,posy+1]=0))
       or ((ch='4') and (zakaz<>4) and (ch2<>'6') and (plocha[posx-1,posy]=0))
       or ((ch='6') and (zakaz<>6) and (ch2<>'4') and (plocha[posx+1,posy]=0))
       or ((ch='8') and (zakaz<>8) and (ch2<>'2') and (plocha[posx,posy-1]=0))
       or (ch='5');
    if (prikaz>0) and (prikaz<>Ord(ch)-48) then begin
      Koniec;
      goto 1;
    end;
    gotoxy(wherex-1,wherey);
    if (ch='2') and (ch2='2') then ZhoraDole;
    if (ch='2') and (ch2='6') then SpravaDole;
    if (ch='2') and (ch2='4') then ZlavaDole;
    if (ch='6') and (ch2='2') then ZhoraVpravo;
    if (ch='6') and (ch2='6') then ZlavaVpravo;
    if (ch='6') and (ch2='8') then ZdolaVpravo;
    if (ch='4') and (ch2='2') then ZhoraVlavo;
    if (ch='4') and (ch2='8') then ZdolaVlavo;
    if (ch='4') and (ch2='4') then SpravaVlavo;
    if (ch='8') and (ch2='6') then ZlavaHore;
    if (ch='8') and (ch2='8') then ZdolaHore;
    if (ch='8') and (ch2='4') then SpravaHore;
    if ch='8' then Dec(posy);
    if ch='2' then Inc(posy);
    if ch='6' then Inc(posx);
    if ch='4' then Dec(posx);
    Inc(tah);zakaz:=0;prikaz:=0;
    plocha[posx,posy]:=1;
    ch2:=ch;
  until ch='5';
1:end.