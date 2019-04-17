constructor THmyz.Init;
var Pom:word;
begin
  Randomize;
  for i:=1 to 8 do PCerv[i]:=@Cerv[i];
  Cerv[1].Init(1,7);
  Cerv[2].Init(2,9);
  Cerv[3].Init(3,10);
  Cerv[4].Init(4,11);
  Cerv[5].Init(5,12);
  Cerv[6].Init(6,13);
  Cerv[7].Init(7,14);
  Cerv[8].Init(8,6);
{ ----- inicializacia siete ----- }
  if Lokalny then begin
    Assign(FWrite,'LokZapis.DAT');
    Assign(FRead, 'LokCitaj.DAT');
  end else begin
    Assign(FRead, 'J:\MojeDo~1\Lubo\Pascal\Cervi\LokZapis.DAT');
    Assign(FWrite,'J:\MojeDo~1\Lubo\Pascal\Cervi\LokCitaj.DAT');
  end;
  FileMode:=65; { zdielanie: Deny None, pristup: Write Only }
  ReWrite(FWrite);
  Pom:=0;
  Write(FWrite,Buffer);
  ZapisPozicie;
  Write('Nadvazujem spojenie ... ');
  FileMode:=64; { zdielanie: Deny None, pristup: Read Only }
  Reset(FRead);
  while EOF(FRead) do begin
    Close(FRead);
    for i:=-30000 to 30000 do begin end; { cakaj na spojenie, daj tomu cas }
    Reset(FRead);
  end;
  WriteLn('OK');
end;
procedure THmyz.NastavOvladanie;
begin
  if Lokalny then begin
    PCerv[1]^.Vlavo :=75;
    PCerv[1]^.Vpravo:=77;
    PCerv[2]^.Vlavo :=$4E;
    PCerv[2]^.Vpravo:=$4A;
    PCerv[3]^.Vlavo :=$31;
    PCerv[3]^.Vpravo:=$32;
    PCerv[4]^.Vlavo :=$29;
    PCerv[4]^.Vpravo:=$0F;
  end else begin
    PCerv[5]^.Vlavo :=75;
    PCerv[5]^.Vpravo:=77;
    PCerv[6]^.Vlavo :=$4E;
    PCerv[6]^.Vpravo:=$4A;
    PCerv[7]^.Vlavo :=$31;
    PCerv[7]^.Vpravo:=$32;
    PCerv[8]^.Vlavo :=$29;
    PCerv[8]^.Vpravo:=$0F;
  end;
end;

procedure THmyz.SpracujPouzivatelov;
var Pom:byte;
begin { spracuva len svojich styroch }
  if Lokalny then for Pom:=1 to 4 do PCerv[Pom]^.SpracujPouzivatela
             else for Pom:=5 to 8 do PCerv[Pom]^.SpracujPouzivatela;
end;
function THmyz.VsetciHavarovali:boolean;
begin
  VsetciHavarovali:=True; { zistenie, ci vsetci havarovali }
  for i:=1 to 8 do
    if not PCerv[i]^.Havaria then VsetciHavarovali:=False;
end;
procedure THmyz.KresliPozicie;
var Pom:byte;
begin { kresli len vzdialenych, nie lok. cervov }
  if Lokalny then for Pom:=5 to 8 do PCerv[Pom]^.KresliPoziciu
             else for Pom:=1 to 4 do PCerv[Pom]^.KresliPoziciu;
end;
procedure THmyz.PosunPozicie(Koef:integer);
var Pom:byte;
begin { posuva len svojich styroch, ide o reagovanie na pouz. podnet }
  if Lokalny then for Pom:=1 to 4 do PCerv[Pom]^.PosunPoziciu(Koef)
             else for Pom:=5 to 8 do PCerv[Pom]^.PosunPoziciu(Koef);
  { dalsi styria maju dohodene pozicie zo suboru }
end;
procedure THmyz.ZapisPozicie;
var Pom:byte;
begin { zapis svojich styroch }
  if Lokalny then for Pom:=1 to 4 do PCerv[Pom]^.ZapisPoziciu
             else for Pom:=5 to 8 do PCerv[Pom]^.ZapisPoziciu;
  Seek(FWrite,0);
  Write(FWrite,Buffer);
end;
procedure THmyz.CitajPozicie;
var Pom:byte;
begin
  Seek(FRead,0); { citaj cudzich styroch }
  if EOF(FRead) then Chyba.Cislo(1);
  Read(FRead,Buffer);
  if Lokalny then for Pom:=5 to 8 do PCerv[Pom]^.CitajPoziciu
             else for Pom:=1 to 4 do PCerv[Pom]^.CitajPoziciu;
end;
destructor THmyz.Done;
begin
  Seek(FWrite,0);
  Truncate(FWrite); { skratenie dlzky suboru pre zapis na nulu }
  Close(FWrite);
  Close(FRead);
end;