program Zbierka_efektov;
            {zbierka grafickych efektov vhodnych ako pozadie}
                       {pri praci s unitom MainGr}
uses MainGr,BMPUtil;
var FontP,PalP,PozP:pointer;
    ch:char;
{ ----- jednotlive graficke efekty ----- }
procedure Sierpinskeho_koberec(MinX,MaxX,MinY,MaxY:word);
var StredX,StredY,StvrtX,TristvrtX:word;
    V1,V2,V3:byte;
begin
  if MinX<MaxX-1 then begin
    StredX:=(MinX+MaxX) shr 1;
    StredY:=(MinY+MaxY) shr 1;
    StvrtX:=(MinX+StredX) shr 1;
    TristvrtX:=(StredX+MaxX) shr 1;
    V1:=ZistiBod(StredX,MinY);
    V2:=ZistiBod(MinX,MaxY);
    V3:=ZistiBod(MaxX,MaxY);
    PolozBod(StvrtX,StredY,(V1+V2) shr 1);
    PolozBod(TristvrtX,StredY,(V1+V3) shr 1);
    PolozBod(StredX,MaxY,(V3+V2) shr 1);
    Sierpinskeho_koberec(StvrtX,TristvrtX,MinY,StredY);
    Sierpinskeho_koberec(MinX,StredX,StredY,MaxY);
    Sierpinskeho_koberec(StredX,MaxX,StredY,MaxY);
  end;
end;
procedure MojEfekt_1(xz,xk:word;yz,yk:byte);
var xp:integer;
    yp:byte;
    v:array[0..199,0..319] of byte absolute $A000:$0000;{video RAM 320x200}
begin
  xp:=(xz+xk) div 2;
  yp:=(yz+yk) div 2;
  v[yz,xp]:=(v[yz,xz]+v[yz,xk]) div 2;
  v[yk,xp]:=(v[yk,xz]+v[yk,xk]) div 2;
  v[yp,xk]:=(v[yz,xk]+v[yk,xk]) div 2;
  v[yp,xz]:=(v[yz,xz]+v[yk,xz]) div 2;
  v[yp,xp]:=(v[yz,xz]+v[yk,xz]+v[yz,xk]+v[yz,xz]) div 4;
  if yk-yz>1 then begin
    MojEfekt_1(xz,xp,yz,yp);
    MojEfekt_1(xp,xk,yz,yp);
    MojEfekt_1(xz,xp,yp,yk);
    MojEfekt_1(xp,xk,yp,yk);
  end;
end;
procedure MojEfekt_2;
var x,y:word;
begin
  repeat
    x:=0;
    while x<320 do begin
      CakajNaVOI;
      if (Random(5)=0) then
        if Color<176 then Inc(Color) else Color:=0;
      for y:=1 to 2 do begin
        Ciara(x,0,319,(x*3) div 5);
        Ciara(319,(x*3) div 5,319-x,199);
        Ciara(319-x,199,0,199-(x*3) div 5);
        Ciara(0,199-(x*3) div 5,x,0);
        Inc(x,2);
      end;
      Ciara(160,(x*3) div 10,160+x div 2,100);
      Ciara(160+x div 2,100,160,200-(x*3) div 10);
      Ciara(160,200-(x*3) div 10,160-x div 2,100);
      Ciara(160-x div 2,100,160,(x*3) div 10);
    end;
  until JeZnak;
end;
procedure Klasicke_pozadie;
begin
  NahodnaBMP(320,200,9,PozP);
  PriemerujBMP(PozP);
  PriemerujBMP(PozP);
  PrilepBMP(0,0,PozP);
  Color:=0;
  CiaraVodorovna(0,0,320);
  CiaraVodorovna(0,199,320);
  FreeMem(PozP,64004);
end;
procedure Neklasicke_pozadie;assembler;
asm
             cld
             push ds
             mov es,VSeg
             mov ds,VSeg
             mov bx,63424         {XLAT konverzna tabulka cerpa poslednych 256 bajtov predposl. riadka}
             mov si,320           {od 2. riadka}
             mov di,si
             mov cx,63360         {po predposledny}
@Dalsi:      lodsb
             xlat
             stosb
             loop @Dalsi
             pop ds
end;
{ ----- hlavny program ----- }
BEGIN
  NacitajPaletu('Prechody.MP',PalP);
  NacitajFont('Matem8.MSF',FontP);
  InicializujGrafiku;
  NastavPaletu(PalP);
  repeat
    if ch<>' ' then begin
      Color:=15;
      Ramcek(60,90,200,20,0);
      Vypis(66,96,FontP,'Vyber si: 12345',Zlta);
      ch:=CitajZnak;
      ZmazObrazovku;
    end;
    case ch of
      '1':begin
        PolozBod(161,0,15);
        PolozBod(61,199,169);
        PolozBod(261,199,91);
        Sierpinskeho_koberec(61,261,0,199);
      end;
      '2':begin
        PolozBod(0,0,111);
        PolozBod(319,0,131);
        PolozBod(0,199,152);
        PolozBod(319,199,125);
        PolozBod(0,99,27);
        PolozBod(159,0,31);
        PolozBod(319,99,43);
        PolozBod(159,199,12);
        PolozBod(159,99,251);
        MojEfekt_1(0,159,0,99);
        MojEfekt_1(159,319,0,99);
        MojEfekt_1(0,159,99,199);
        MojEfekt_1(159,319,99,199);
        MemW[$A000:$013C]:=320;
        MemW[$A000:$013E]:=200;
        PriemerujBMP(pointer($A000013C));
        Color:=0;
        CiaraVodorovna(0,0,320);
        CiaraVodorovna(0,199,320);
        CiaraZvisla(0,0,200);
        CiaraZvisla(319,0,200);
      end;
      '3':MojEfekt_2;
      '4':Klasicke_pozadie;
      '5':begin
        Klasicke_pozadie;
        Neklasicke_pozadie;
      end;
      ' ':Neklasicke_pozadie;
    end;
    if ch<>#27 then ch:=CitajZnak;
  until ch=#27;
  ZavriGrafiku;
  writeln('MukoSoft zbierka efektov'#13#10'Lubos Saloky, 1997');
END.