unit MM3TPU;

INTERFACE
  function TestujCtrl(x,y:word):longint;
  procedure Informuj(s:string);
  procedure HorneMenu;
  procedure VypisPoziciuKurzora(kx,ky:word);
  function SpytajSa(s:string;min,max:integer):integer;
  procedure Pockaj;
  function KresliCiaru(farba,pocx,pocy:word):longint;{farba a pociatocne suradnice}

IMPLEMENTATION
  uses Graph,Crt,Myska;
  var kx,ky:word;
      tlacidlo:byte;

  function TestujCtrl(x,y:word):longint;  {pozri ROZNE\KEYBOARD.PAS}
  var pom1,pom2:word;
      putAL:byte;
  begin
    asm
      mov ah,02h
      int 21h
      mov putAL,al
    end;
    if putAL and $04>0 then begin
      if (x-5) mod 20<10 then pom1:=((x-5) div 20*20+5)
      else pom1:=((x+15) div 20*20+5);
      if (y-5) mod 20<10 then pom2:=(y-5) div 20*20+5
      else pom2:=(y+15) div 20*20+5;
      TestujCtrl:=pom1*65536+pom2;
    end
    else TestujCtrl:=0;
  end;

  procedure Informuj(s:string);
  begin
    VypniKurzorMysi;
    Bar(1,1,638,17);
    if s='' then OutTextXY(5,5,'c[xxx]:prepni  Zmaz  Morphing  Uloz  Nahraj  Info  Vselico  Koniec')
      else OutTextXY(5,5,s);
    ZapniKurzorMysi;
  end;

  procedure HorneMenu;          { -------- nakresli horne menu ---------}
  begin
    VypniKurzorMysi;
    SetColor(7);
    Line(639,0,0,0);
    Line(0,0,0,18);
    Line(0,18,639,18);
    Line(639,18,639,0);
    Informuj('');
    ZapniKurzorMysi;
  end;

  procedure VypisPoziciuKurzora(kx,ky:word);
  var s,t:string;
      skx,sky:word;
  begin
    if (skx<>kx) or (sky<>ky) then begin
      VypniKurzorMysi;
      Str(kx,s);
      Str(ky,t);
      s:=s+' '+t;
      Bar(582,5,638,13);
      OutTextXY(582,5,s);
      skx:=kx;
      sky:=ky;
      ZapniKurzorMysi;
    end;
  end;

  function SpytajSa(s:string;min,max:integer):integer;
  var t:string;
      ch:char;
      value,poccif:integer;
  begin
    VypniKurzorMysi;
    if max<>min then begin
      Str(min,t);
      s:=s+' (od '+t;
      Str(max,t);
      s:=s+' do '+t+')';
    end;
    Informuj(s);
    repeat
      value:=0;poccif:=1;
      repeat
        ch:=ReadKey;
        if (Ord(ch)>47) and (Ord(ch)<58) then begin
          value:=10*value+Ord(ch)-48;
          OutTextXY(5+8*(Length(s)+poccif),5,ch);
          Inc(poccif);
        end;
      until Ord(ch)=13;
      Bar(13+8*Length(s),1,53+8*Length(s),17);
    until (value>=min) and (value<=max);
    ZapniKurzorMysi;
    SpytajSa:=value;
  end;

  procedure Pockaj;
  begin
    repeat
      ZistiPoziciu(kx,ky,tlacidlo);
    until tlacidlo=0;
  end;

  function KresliCiaru(farba,pocx,pocy:word):longint;{farba a pociatocne suradnice}
  var oldx,oldy,Ctrl:word;
      l:longint;
  begin
    oldx:=pocx;oldy:=pocy;
    Pockaj;
    repeat
      VypniKurzorMysi;
      SetColor(7);
      VypisPoziciuKurzora(kx,ky);
      SetColor(0);
      Line(pocx,pocy,oldx,oldy);
      SetColor(farba);
      Line(pocx,pocy,kx,ky);
      oldx:=kx;oldy:=ky;
      ZapniKurzorMysi;
      repeat
        ZistiPoziciu(kx,ky,tlacidlo);
      until (kx<>oldx) or (ky<>oldy) or (tlacidlo=1);
    until tlacidlo=1;
    l:=TestujCtrl(oldx,oldy);
    if l>0 then begin
      VypniKurzorMysi;
      SetColor(0);
      Line(pocx,pocy,oldx,oldy);
      SetColor(farba);
      oldx:=l div 65536;
      oldy:=l mod 65536;
      Line(pocx,pocy,oldx,oldy);
      ZapniKurzorMysi;
    end;
    Pockaj;
    SetColor(7);
    KresliCiaru:=oldx*65536+oldy;
  end;
END.