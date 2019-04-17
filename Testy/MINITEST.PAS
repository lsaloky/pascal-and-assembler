program Testy;{minitesty z matematiky}
uses MainGr;
{$DEFINE NEPRIDAJTEST}
{$DEFINE DEMO}

{$IFDEF PRIDAJTEST}
const Odpovede:array[1..24,1..6] of byte=(
       (2,4,3,0,0,0),(0,0,0,0,0,1),(0,0,0,0,0,1),(5,7,6,0,0,0),
       (0,0,0,0,0,4),(0,0,0,0,0,4),(8,9,9,10,0,0),(0,0,0,0,0,7),
       (0,0,0,0,0,7),(11,14,13,12,0,0),(0,0,0,0,0,10),(0,0,0,0,0,14),
       (0,0,0,0,0,10),(15,17,16,0,0,0),(0,0,0,0,0,14),(0,0,0,0,0,14),
       (21,18,19,20,0,0),(0,0,0,0,0,17),(0,0,0,0,0,17),(0,0,0,0,0,17),
       (22,23,24,0,0,0),(0,0,0,0,0,21),(0,0,0,0,0,21),(0,0,0,0,0,255));
const Penale:array[1..24] of byte=(0,2,0,0,2,3,0,3,2,0,1,1,1,0,2,3,0,1,2,2,0,2,3,0);
{$ENDIF}
const MaxOdstavcov=40;MaxTestov=15;
{ ----- systemove premenne, pre uzivatelsky interface ----- }
var FP:array[1..2] of pointer;                     {font}
    MGPP:array[1..MaxOdstavcov]of pointer;         {MGP-cka}
    Hlavicka:array[1..16] of byte;                 {hlavicka MGP}
    PalP,MBP:pointer;                              {paleta, bitmapy}
{ ----- premenne programu ----- }
var f:file;                                        {*.MGP}
    FZoz:text;                                     {Zoznam.TXT}
    Udalost,AktOtazka,StaraOtazka,Body,PocetTestov:integer;
    NazovSub,Titul:array[1..15] of string[25];     {uvodne menu - nazvy testov a ich subory}
{$IFNDEF PRIDAJTEST}
    Odpovede:array[1..MaxOdstavcov,1..6] of byte;  {vetvenie programu podla danej odpovede}
    Penale:array[1..MaxOdstavcov] of byte;         {trestne body za danu otazku}
{$ENDIF}
{ ----- pomocne premenne ----- }
var i,j:integer;
    ch:char;
    s:string;
function CitajKlaves:char;assembler;
asm
             mov ah,0
             int 16h
end;
label Koniec;
BEGIN
{ ----- inicializacia ----- }
  NacitajFont('Matem8.MSF',FP[1]);
  NacitajFont('Hlavny5.MSF',FP[2]);
  NacitajPaletu('Prechody.MP',PalP);
{$IFDEF DEMO}
  WriteLn(#13#10#13#10'Toto je len DEMOVERZIA programu MINITEST. Obsahuje len jeden'#13#10+
          'test. Cely program ziskate jeho objednanim na adrese:');
  WriteLn(#13#10'Lubos Saloky'#13#10'Slovenskeho 26'#13#10'04001 Kosice'#13#10+
          #13#10'alebo E-mailom na adrese SALOKY@DURO.UPJS.SK'#13#10#13#10);
  WriteLn('Cena je 20 Sk pri posielani programu E-mailom, inak +20 Sk postovne'+
          ' a balne.'#13#10#13#10'Stlacte lubovolny klaves');
  CitajZnak;
  Assign(FZoz,'Zoznamdm.TXT');
{$ELSE}
  Assign(FZoz,'Zoznam.TXT');
{$ENDIF}
  Reset(FZoz);
  i:=1;
  while not EOF(FZoz) do begin
    ReadLn(FZoz,NazovSub[i]);
    ReadLn(FZoz,Titul[i]);
    Inc(i);
  end;
  PocetTestov:=i-1;
  InicializujGrafiku;
  NastavPaletu(PalP);
  repeat
    ZmazObrazovku;
    Vypis(90,5,FP[1],'Vyber si test:',Zlta);
    Vypis(230,190,FP[1],'Esc = koniec',Zlta);
    for i:=1 to PocetTestov do begin
      Vypis(0,10+10*i,FP[1],Chr(i+96)+':',Cervena);
      VypisPO(160-LengthPixel(FP[1],Titul[i]) shr 1,10+10*i,FP[1],Titul[i],Oranzova);
    end;
    repeat
      ch:=CitajKlaves;
    until ch in [#27,'a'..Chr(PocetTestov+96)];
    if ch=#27 then goto Koniec;
    Assign(f,NazovSub[Ord(ch)-96]);
    Reset(f,1);
    BlockRead(f,Hlavicka,16);
    for i:=1 to Hlavicka[2] do NacitajMGP(f,MGPP[i]);
{$IFNDEF PRIDAJTEST}
    BlockRead(f,Odpovede,6*Hlavicka[2]);
    BlockRead(f,Penale,Hlavicka[2]);
{$ELSE}
    BlockWrite(f,Odpovede,6*Hlavicka[2]);
    BlockWrite(f,Penale,Hlavicka[2]);
{$ENDIF}
    Close(f);
{ ----- hlavny program ----- }
    AktOtazka:=1;Body:=0;
    repeat
      ZmazObrazovku;
      VykresliMGP(MGPP[AktOtazka],@MBP,@FP);
      Inc(Body,Penale[AktOtazka]);
      If Odpovede[AktOtazka,6]=255 then begin {vypis skore, je koniec testu}
        Str(Body,s);
        VypisPO(105,101,FP[1],s,Oranzova);
      end;
      StaraOtazka:=AktOtazka;
      repeat {nedovol stlacit nemoznu odpoved 1..5}
        ch:=CitajKlaves;
        if (ch in ['1'..'5']) and (Odpovede[AktOtazka,byte(ch)-48]>0) then AktOtazka:=Odpovede[AktOtazka,byte(ch)-48];
        if not (ch in ['1'..'5']) and (Odpovede[AktOtazka,6]>0) then AktOtazka:=Odpovede[AktOtazka,6];
        if ch=#27 then AktOtazka:=255;
      until AktOtazka<>StaraOtazka;
    until AktOtazka=255;
  until false;
  Koniec:ZavriGrafiku;
  WriteLn('MukoSoft minitesty'#13#10'Lubos Saloky, 1997');
END.