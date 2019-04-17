program Editor_kurzora;
uses Myska,MukoGr,Crt,MukoUtil;
const FontPath='d:\lubo\pascal\units\Classic.mf';
      Rozmer=8;                                          {zvacsenie kurzora}
      PrikX=0;PrikY=160;                                 {blok prikazov}
      PocetOP=7;
      Aktiv:array[1..PocetOP,1..4] of word=(
        (2,10,16*Rozmer-1,7+16*Rozmer),                  {screen mask}
        (162,10,159+16*Rozmer,7+16*Rozmer),              {cursor mask}
        (PrikX+60,PrikY+4,PrikX+60+24,PrikY+11),         {hotspot zac}
        (PrikX+60+48,PrikY+4,PrikX+60+48+24,PrikY+11),   {hotspot kon}
        (PrikX+160,PrikY,PrikX+200,PrikY+16),            {uloz}
        (PrikX+208,PrikY,PrikX+264,PrikY+16),            {koniec}
        (PrikX+272,PrikY,PrikY+272+40,PrikY+16));        {ukaz}
      OLH:array[0..PocetOP] of string[40]=(
        '','priehladnost','kurzor','cielnik x-ova sur.,-16..16','cielnik y-ova sur.,-16..16',
        'uloz do suboru','koniec programu','zobraz kurzor');
type TData=array[0..31] of word;
var x,y,z,Udalost,UStara,PomX,PomY,StaryX,StaryY,Err:word;
    ccX,ccY:integer;
    ch:char;
    s,Nazov,Cesta:string;
    Tlacidla:byte;
    PomPrieh,PomVidit:array[0..15,0..15] of byte;
    Kurzor:TData;
    f:file of TData;
    fOrig,fKopia:text;
function DvaNa(px:word):word;
var ppom,ppom2:word;
begin
  ppom2:=1;
  for ppom:=1 to px do ppom2:=ppom2*2;
  DvaNa:=ppom2;
end;
BEGIN
{ ----- inicializacia ----- }
  InicializujGrafiku;
  for x:=0 to 15 do
    for y:=0 to 15 do begin
      PomPrieh[x,y]:=0;
      PomVidit[x,y]:=0;
    end;
  NacitajFontAPaletu(FontPath);
  Nastav(0,0,0);
  VypisPriehladne('MAPA PRIEHLADNOSTI  MAPA VIDITELNOSTI',Hneda);
  Nastav(0,8,15);
  Ramcek(16*Rozmer+3,16*Rozmer+3,0);
  Nastav(160,8,15);
  Ramcek(16*Rozmer+3,16*Rozmer+3,0);
  for x:=0 to 16 do
    for y:=0 to 16 do begin
      PolozBod(x*8+1,y*8+9,15);
      PolozBod(x*8+161,y*8+9,15);
    end;
  Nastav(PrikX,PrikY,14);
  Ramcek(144,16,0);
  Nastav(PrikX+4,PrikY+4,0);
  VypisPriehladne('Klik x:    y:',Svetlomodra);
  Nastav(PrikX+4+7*8,PrikY+4,0);
  VypisPriehladne('0     0',Oranzova);
  Nastav(Aktiv[5,1],Aktiv[5,2],14);
  Ramcek(Aktiv[5,3]-Aktiv[5,1],Aktiv[5,4]-Aktiv[5,2],0);
  Nastav(Aktiv[5,1]+4,Aktiv[5,2]+4,0);
  VypisPriehladne('ULOZ',Svetlomodra);
  Nastav(Aktiv[6,1],Aktiv[6,2],14);
  Ramcek(Aktiv[6,3]-Aktiv[6,1],Aktiv[6,4]-Aktiv[6,2],0);
  Nastav(Aktiv[6,1]+4,Aktiv[6,2]+4,0);
  VypisPriehladne('KONIEC',Svetlomodra);
  Nastav(Aktiv[7,1],Aktiv[7,2],14);
  Ramcek(40,16,0);
  Nastav(Aktiv[7,1]+4,Aktiv[7,2]+4,0);
  VypisPriehladne('UKAZ',Svetlomodra);
  ZapniKurzorMysi;
  StaryX:=0;StaryY:=0;
{ ----- cakanie na udalost ----- }
  UStara:=0;
  repeat
    repeat
      ZistiPoziciu(x,y,Tlacidla);
      x:=x div 2;
      Udalost:=0;
      for z:=1 to PocetOP do
        if (x>=Aktiv[z,1]) and (x<=Aktiv[z,3]) and (y>=Aktiv[z,2]) and (y<=Aktiv[z,4]) then Udalost:=z;
      if Udalost<>UStara then begin
        VypniKurzorMysi;
        Nastav(0,192,0);
        VyplnPlochu(320,8);
        VypisPriehladne(OLH[Udalost],Bordova);
        UStara:=Udalost;
        ZapniKurzorMysi;
      end;
    until Tlacidla=1;
    if Udalost>2 then begin
      CakajNaPustenie;
      VypniKurzorMysi;
    end;
{ ----- spracovanie udalosti ----- }
    case Udalost of
      1:begin                                        {mapa priehladnosti}
        PomX:=(x-2) div Rozmer;
        PomY:=(y-10) div Rozmer;
        if (PomX<>StaryX) or (PomY<>StaryY) then begin
          VypniKurzorMysi;
          if PomPrieh[PomX,PomY]=0 then begin
            PomPrieh[PomX,PomY]:=1;
            Color:=45+64;
          end else begin
            PomPrieh[PomX,PomY]:=0;
            Color:=0;
          end;
          Nastav(2+PomX*Rozmer,10+PomY*Rozmer,Color);
          VyplnPlochu(Rozmer-1,Rozmer-1);
          ZapniKurzorMysi;
        end;
        StaryX:=PomX;StaryY:=PomY;
      end;
      2:begin                                        {mapa viditelnosti}
        PomX:=(x-162) div Rozmer;
        PomY:=(y-10) div Rozmer;
        if (PomX<>StaryX) or (PomY<>StaryY) then begin
          VypniKurzorMysi;
          if PomVidit[PomX,PomY]=0 then begin
            PomVidit[PomX,PomY]:=1;
            Color:=42+32;
          end else begin
            PomVidit[PomX,PomY]:=0;
            Color:=0;
          end;
          Nastav(162+PomX*Rozmer,10+PomY*Rozmer,Color);
          VyplnPlochu(Rozmer-1,Rozmer-1);
          ZapniKurzorMysi;
        end;
        StaryX:=PomX;StaryY:=PomY;
      end;
      3:begin
        Nastav(Aktiv[Udalost,1],Aktiv[Udalost,2],0);
        VyplnPlochu(24,8);
        Citaj(3,Zlta);Val(Ret,ccX,Err);
      end;
      4:begin
        Nastav(Aktiv[Udalost,1],Aktiv[Udalost,2],0);
        VyplnPlochu(24,8);
        Citaj(3,Zlta);Val(Ret,ccY,Err);
      end;
      5:begin
        for y:=0 to 15 do begin
          Kurzor[y]:=0;
          for x:=0 to 15 do if PomPrieh[x,y]=1 then Kurzor[y]:=Kurzor[y]+DvaNa(15-x);
          Kurzor[y+16]:=0;
          for x:=0 to 15 do if pomVidit[x,y]=1 then Kurzor[y+16]:=Kurzor[y+16]+DvaNa(15-x);
        end;
        Assign(f,'Kurzor.mk');
        ReWrite(f);
        Write(f,Kurzor);
        Close(f);
      end;
      7:begin
        for y:=0 to 15 do begin
          Kurzor[y]:=0;
          for x:=0 to 15 do if PomPrieh[x,y]=1 then Kurzor[y]:=Kurzor[y]+DvaNa(15-x);
          Kurzor[y+16]:=0;
          for x:=0 to 15 do if pomVidit[x,y]=1 then Kurzor[y+16]:=Kurzor[y+16]+DvaNa(15-x);
        end;
{ ----- nastavenie grafickeho kurzora ----- }
        asm
             mov ax,ds
             mov es,ax
             lea dx,Kurzor
             mov ax,9
             mov bx,ccx
             mov cx,ccy
             int 33h
        end;
      end;
    end;
    if Udalost>2 then ZapniKurzorMysi;
  until Udalost=6;
{ ----- ukoncenie programu ----- }
  VypniKurzorMysi;
  ZavriGrafiku;
  WriteLn('Kurzor (ak bol ulozeny) je v subore KURZOR.DAT - 32 slov, najprv'#13#10'priehladnost, potom viditelnost.'#13#10);
  WriteLn('Chces novovytvoreny kurzor pridat do unit-u MukoGr.PAS? a/n');
  ch:=Readkey;
{ ----- ulozenie kurzora do MukoGr.PAS ----- }
  if UpCase(ch)='A' then begin
    Write('Zadaj cestu k suboru MukoGr.PAS: ');
    ReadLn(s);
    if s='' then s:=FontPath;
    if s[Length(s)]<>'\' then s:=s+'\';
    Assign(fOrig,s+'MukoGr.PAS');
    Reset(fOrig);
    if IOResult>0 then begin
      s:=FontPath+'\';
      Assign(fOrig,s+'MukoGr.PAS');
      Reset(fOrig);
    end;
    Cesta:=s;
    Assign(fKopia,s+'Temp.PAS');
    ReWrite(fKopia);
    Write('Nazov kurzora: ');
    ReadLn(Nazov);
    if Nazov='' then Nazov:='MojKurzor';
    while Pos('Hnedocervena',s)=0 do begin{prekopiruj vsetko, co sa nemeni}
      ReadLn(fOrig,s);
      WriteLn(fKopia,s);
    end;                                     {pridaj konstantu}
    Write(fKopia,'      ',Nazov,':TKurzor=(');
    Write(fKopia,ccX,',',ccY,',');
    for x:=0 to 12 do Write(fKopia,Kurzor[x],',');
    Write(fKopia,#13#10'        ');
    for x:=13 to 30 do Write(fKopia,Kurzor[x],',');
    WriteLn(fKopia,Kurzor[31],');');
    while not EOF(fOrig) do begin             {dokopiruj zvysok do konca}
      ReadLn(fOrig,s);
      WriteLn(fKopia,s);
    end;
    Close(fOrig);
    Close(fKopia);
    Erase(fOrig);
    Rename(fKopia,Cesta+'MukoGr.PAS');
  end;
  ZavriGrafiku;
  WriteLn('Editor kurzora MukoSoft KurzEdit, verzia 1.0'#13#10'Programoval: Lubos Saloky, 1997');
END.