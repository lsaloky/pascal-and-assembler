program De_Bruigne;
{ De Bruignova postupnost dlzky Ciel - pouzite pri zacierneni obrazovky}
{ Pre Ciel=65536 je nutne uvolnit MAXIMUM pamate - normalne je to }
{ nespustitelne ! }
const Ciel=65536;
{ Datova struktura Sused0 a Sused1 uklada informacie o tom, ci uz bolo }
{ pouzite cislo AktCislo*2+ (0,1). True = bolo pouzite }
type TSused=array[0..Ciel shr 1 - 1] of boolean;
     PSused=^TSused;
{ Datova struktura Zoznam uklada informacie o nasledovnikovi cisla }
{ AktCislo.}
type PZoznam=^TZoznam;
     TZoznam=record
       Cislo:word;
       Dalsi:PZoznam;
     end;

var Sused0,Sused1:PSused;
    Zac,Kon,Pom:PZoznam;         { ukazatel na prvy a posledny prvok zoznamu }
    i,AktCislo,Vyrez:word;
    DlzkaCesty:longint;
    f:text;
procedure PridajPrvok(Prvok:word);  { na koniec zoznamu }
begin
  New(Pom);
  Pom^.Cislo:=Prvok;
  Pom^.Dalsi:=nil;
  Kon^.Dalsi:=Pom;
  Kon:=Pom;
end;

BEGIN
{ ----- inicializacia datovych struktur ----- }
  GetMem(Sused0,Ciel shr 1);
  GetMem(Sused1,Ciel shr 1);
  for i:=0 to Ciel shr 1 - 1 do begin
    Sused0^[i]:=False;
    Sused1^[i]:=False;
  end;
  Sused0^[0]:=True;
  AktCislo:=0;
  DlzkaCesty:=0;
  Vyrez:=Ciel shr 1 - 1;
  New(Zac);
  Zac^.Cislo:=0;
  Zac^.Dalsi:=nil;
  Kon:=Zac;
{ ----- vypocet De Bruignovej postupnosti ----- }
  repeat
    if not Sused1^[AktCislo] then begin
      Sused1^[AktCislo]:=True;
      AktCislo:=AktCislo*2+1;
      PridajPrvok(AktCislo);
      AktCislo:=AktCislo and Vyrez;
    end else
      if not Sused0^[AktCislo] then begin
        Sused0^[AktCislo]:=True;
        AktCislo:=AktCislo*2;
        PridajPrvok(AktCislo);
        AktCislo:=AktCislo and Vyrez;
      end;
  until (DlzkaCesty=Ciel) or (AktCislo=0);
{ ----- zaverecny vypis ----- }
  Assign(f,'DeBruig.txt');
  ReWrite(f);
  Pom:=Zac;
  While Pom<>nil do begin
    WriteLn(f,Pom^.Cislo);
    Pom:=Pom^.Dalsi;
  end;
  Close(f);
END.