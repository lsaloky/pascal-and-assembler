program Aproximacia_Coonsovou_kubikou; { kubicky B-spline }
uses MainGr;
type TBody=array[1..255,1..2] of word;
     PBody=^TBody;
const PocetB=9;
      RB:array[1..9,1..2] of word=({ riadiace body, uniformna parametrizacia }
        (20,20),(50,80),(160,30),(290,90),(200,110),(160,190),(80,160),(60,120),(100,110));
var t,SumaX,SumaY:real;
    i,j,AktBod:integer;
    ch:char;
    PalP,MSFP:pointer;
    Krivka:TBody;
procedure ACK(Pocet,Multi:byte;Body:PBody;var Krivka:TBody);
begin
  t:=0;i:=1;j:=1;
  repeat
    SumaX:=(RB[i  ,1]*(1 -3*t +3*t*t -1*t*t*t)+
            RB[i+1,1]*(4      -6*t*t +3*t*t*t)+
            RB[i+2,1]*(1 +3*t +3*t*t -3*t*t*t)+
            RB[i+3,1]*(              +1*t*t*t))/6;
    SumaY:=(RB[i  ,2]*(1 -3*t +3*t*t -1*t*t*t)+
            RB[i+1,2]*(4      -6*t*t +3*t*t*t)+
            RB[i+2,2]*(1 +3*t +3*t*t -3*t*t*t)+
            RB[i+3,2]*(              +1*t*t*t))/6;
    Krivka[j,1]:=Round(SumaX);
    Krivka[j,2]:=Round(SumaY);
    Inc(j);
    t:=t+1/Multi;
    if t>=1 then begin
      t:=0;
      Inc(i);
    end;
  until i>=PocetB-2;
end;
BEGIN
  InicializujGrafiku;
  NacitajPaletu('Prechody.MP',PalP);
  NacitajFont('Hlavny8.MSF',MSFP);
  NastavPaletu(PalP);
  AktBod:=1;
  repeat
    Color:=0;
    for i:=1 to PocetB do VyplnPlochu(RB[i,1]-4,RB[i,2]-4,9,9);
    Color:=29;
    for i:=1 to PocetB do
      if i=AktBod then VyplnPlochu(RB[i,1]-3,RB[i,2]-3,7,7)
                  else PolozBod(RB[i,1],RB[i,2],29);
    Ack(9,20,PBody(@RB),Krivka);
    Vypis(0,192,MSFP,'13 8426 0',Zelena);
    for i:=1 to 200 do PolozBod(Krivka[i,1],Krivka[i,2],15);
    ch:=CitajZnak;
    case ch of
      '1':if AktBod>1 then Dec(AktBod);
      '3':if AktBod<PocetB then Inc(AktBod);
      '8':Dec(RB[AktBod,2]);
      '2':Inc(RB[AktBod,2]);
      '4':Dec(RB[AktBod,1]);
      '6':Inc(RB[AktBod,1]);
    end;
    for i:=1 to 200 do PolozBod(Krivka[i,1],Krivka[i,2],0);
  until ch='0';
  ZavriGrafiku;
END.

