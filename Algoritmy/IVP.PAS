program Interpolacia_vektorovym_polynomom;
uses MainGr;
const P:array[1..4,1..2] of word=((20,20),(120,70),(190,90),(100,140));
      Par:array[1..4] of real=(0,0.33,0.66,1);
      Udalost:string[40]='2qaw 4edr 6tgy 8uji zx cv 0';
var i,j,k:integer;
    t,Koef,SumaX,SumaY:real;
    PalP,MSFP:pointer;
    ch:char;
    Krivka:array[1..100,1..2] of word;

procedure Kreslenie;
begin
  k:=1;
  repeat { kreslenie }
    SumaX:=0;SumaY:=0;
    for i:=1 to 4 do begin
      Koef:=1;
      for j:=1 to 4 do { koeficient }
        if i<>j then Koef:=Koef*(t-Par[j])/(Par[i]-Par[j]);
      SumaX:=SumaX+P[i,1]*Koef;
      SumaY:=SumaY+P[i,2]*Koef;
    end;
    if (SumaX>0) and (SumaY>0) and (SumaX<320) and (SumaY<192) then begin
      PolozBod(Round(SumaX),Round(SumaY),15);
      Krivka[k,1]:=Round(SumaX);
      Krivka[k,2]:=Round(SumaY);
    end else begin
      Krivka[k,1]:=0;Krivka[k,2]:=0;
    end;
    Inc(k);
    t:=t+0.02;
  until t>=1;
  for i:=1 to 4 do PolozBod(P[i,1],P[i,2],28); { riadiace body }
end;

BEGIN
  InicializujGrafiku;
  NacitajPaletu('Prechody.MP',PalP);
  NacitajFont('Hlavny8.MSF',pointer(MSFP));
  NastavPaletu(PalP);
  repeat { ovladanie }
    t:=0;
    Vypis(0,192,MSFP,Udalost,Zelena);
    Kreslenie;
    ch:=CitajZnak;
    for k:=1 to 100 do PolozBod(Krivka[k,1],Krivka[k,2],0); { mazanie }
    for i:=1 to 4 do PolozBod(P[i,1],P[i,2],0); { riadiace body }
    case ch of
      '2':Dec(P[1,2]);
      'q':Dec(P[1,1]);
      'a':Inc(P[1,2]);
      'w':Inc(P[1,1]);
      '4':Dec(P[2,2]);
      'e':Dec(P[2,1]);
      'd':Inc(P[2,2]);
      'r':Inc(P[2,1]);
      '6':Dec(P[3,2]);
      't':Dec(P[3,1]);
      'g':Inc(P[3,2]);
      'y':Inc(P[3,1]);
      '8':Dec(P[4,2]);
      'u':Dec(P[4,1]);
      'j':Inc(P[4,2]);
      'i':Inc(P[4,1]);
      'z':if Par[2]>0.02 then Par[2]:=Par[2]-0.02;
      'x':if Par[2]<Par[3]-0.02 then Par[2]:=Par[2]+0.02;
      'c':if Par[3]>Par[2]+0.02 then Par[3]:=Par[3]-0.02;
      'v':if Par[3]<0.98 then Par[3]:=Par[3]+0.02;
    end;
  until ch='0';
  ZavriGrafiku;
END.