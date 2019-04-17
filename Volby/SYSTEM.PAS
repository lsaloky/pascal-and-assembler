procedure StlacNaspat;
begin
  Tlacidlo3D(240,184,80,16,MSFP[1],'Nasp|a~t',6,3,True);
  VypisPO(259,189,MSFP[1],'N',7);
end;

procedure PustNaspat;
begin
  Tlacidlo3D(240,184,80,16,MSFP[1],'Nasp|a~t',6,3,False);
  VypisPO(259,189,MSFP[1],'N',7);
end;

Procedure UpravGlobalnePref(Stra:word;Zisk:real);
begin
  for i:=1 to 8 do KrajPref[Stra,i]:=KrajPref[Stra,i]+Zisk;
end;

function VsunNazovStrany(Zdroj:string;PorCislo:word):string;
var Pozicia:word;
begin
  Pozicia:=Pos('#',Zdroj);
  Delete(Zdroj,Pozicia,1);
  Insert(NazovStrany[PorCislo],Zdroj,Pozicia);
  VsunNazovStrany:=Zdroj;
end;
{ ----- naplni udajovu strukturu Pref podla KrajPref ----- }
procedure SpocitajPreferencie;
var p1,p2:integer;
begin
  for p1:=1 to PocetStran do begin
    Pref[p1]:=0;
    for p2:=1 to 8 do Pref[p1]:=Pref[p1]+KrajPref[p1,p2];
    Pref[p1]:=Pref[p1]/8;
  end;
end;

procedure CakajNaUdalost;
begin
  CakajNaPustenie;
  repeat
    ZistiPoziciu(x,y,b);
  until (b>0) or JeZnak;                    {cakaj na udalost}
  if JeZnak then ch:=CitajZnak;
  CakajNaPustenie;
end;

{ ----- systemova tajna procedura pre Debug rezim ----- }
procedure Oznam(Identifikator:word;spom:string);
begin
  Color:=0;
  VyplnPlochu(0,Identifikator*10,319,10);
  Vypis(2,Identifikator*10+1,MSFP[1],spom,0);
end;

procedure VypisFormatovany(PosX,PosY:word;Font:pointer;Textik:string;Odtien:byte;MaxX:word);
var AktX,AktY,Index:word;
    pom:string;
begin
  AktX:=PosX;
  AktY:=PosY;
  repeat
    Index:=Pos(' ',Textik);
    if Index=0 then Index:=Length(Textik);           {koniec textu}
    pom:=Copy(Textik,1,Index);
    if MaxX<AktX+LengthPixel(MSFP[1],pom) then begin {dalsi riadok}
      AktX:=PosX;
      Inc(AktY,12);
    end;
    VypisPO(AktX,AktY,Font,pom,Odtien);
    Inc(AktX,LengthPixel(MSFP[1],pom));
    Delete(Textik,1,Index);
  until Textik='';
end;

procedure ZobrazInformacie;
begin
  SpocitajPreferencie;
  for i:=1 to 8 do begin
    Str(Pref[i]:0:2,s);
    Vypis(i*40-38,10,MSFP[1],s,0);
  end;
  for i:=1 to 8 do
    for j:=1 to 8 do begin
      Str(Koal[i,j],s);
      Vypis(i*20+60,j*12+40,MSFP[1],s,0);
  end;
end;