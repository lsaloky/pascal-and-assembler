procedure TCerv.Init(Ktory:word;FarbaP:byte);
begin
  Cislo:=Ktory;
  Farba:=FarbaP;
  Rychlost:=0.8;
  PozX:=Random(ObrX-200)+100;
  PozY:=Random(ObrY-200)+100;
  Uhol:=Random(31416*2)/10000;
  Havaria:=False;
end;
procedure TCerv.SpracujPouzivatela; { pohyb vlavo / vpravo }
begin
  if Zoznam^[Vlavo]>0  then Uhol:=Uhol+pi/10;
  if Zoznam^[Vpravo]>0 then Uhol:=Uhol-pi/10;
end;
procedure TCerv.KresliPoziciu;
var Pom:byte;
begin
  Pom:=GetPixel(Round(PozX),Round(PozY));
  if ((Cislo < 5) and (Lokalny)) or ((Cislo > 4) and (not Lokalny)) then
    { u vzdialeneho netestuj koliziu }
    if (Pom>0) and (not ( { je tam nejaka farba }
      (Pom=Farba) and     { ale nie je to vlastna farba, ktora vznikla}
      (Round(SPozX)=Round(PozX)) and { dvojnasobnym prekrytim }
      (Round(SPozY)=Round(PozY)))) then Havaria:=True;
  SetColor(Farba);
  Line(Round(SPozX),Round(SPozY),Round(PozX),Round(PozY));
  {PutPixel(Round(PozX),Round(PozY),Farba);}
end;
procedure TCerv.PosunPoziciu;
var Pom:byte;
begin
  if not Havaria then begin
    for Pom:=1 to 3*Koef do begin { posuva sa pri jednom tiku o 3 pixely }
      SPozX:=PozX; { pamataju sa stare suradnice kvoli dvojnasobnym prekrytiam }
      SPozY:=PozY;
      PozX:=PozX+cos(Uhol)*Rychlost;
      PozY:=PozY-sin(Uhol)*Rychlost;
      KresliPoziciu; { kresli lokalne tri body }
    end;
  end;
end;
procedure TCerv.ZapisPoziciu;
var PomX,PomY,PomH:word;
begin
 { PomX:=Round(PozX);
  PomY:=Round(PozY);}
  with Hmyz.Buffer[(Cislo - 1) mod 4 +1] do begin
    BPozX:=Round(PozX);
    BPozY:=Round(PozY);
    BHavaria:=Havaria;
  end;
{  if Havaria then PomH:=0 else PomH:=1;
  Seek(Hmyz.FWrite,Cislo*3);
  Write(Hmyz.FWrite,PomX);
  Write(Hmyz.FWrite,PomY);
  Write(Hmyz.FWrite,PomH);}
end;
procedure TCerv.CitajPoziciu;
var PomX,PomY,PomH:word;
begin
  if SPozX+SPozY>=1 then begin { je pocas hry }
    SPozX:=PozX;
    SPozY:=PozY;
  end;
{  Seek(Hmyz.FRead,Cislo*3);
  Read(Hmyz.FRead,PomX);
  Read(Hmyz.FRead,PomY);
  Read(Hmyz.FRead,PomH);
  PozX:=PomX;
  PozY:=PomY;
  if PomH=0 then Havaria:=True else Havaria:=False;}
  with Hmyz.Buffer[(Cislo - 1 ) mod 4 + 1] do begin
    PozX:=BPozX;
    PozY:=BPozY;
    Havaria:=BHavaria;
  end;

  if SPozX+SPozY<1 then begin { je na zaciatku hry }
    SPozX:=PozX; { zapis SPozXY ako bez pohybu }
    SPozY:=PozY;
  end;
end;