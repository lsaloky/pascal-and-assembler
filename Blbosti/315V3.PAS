program O_ekvivalenciach_verzia_3;
{simulacia frontu - najdenie najkratsej cesty}
const MaxVrch=10;MaxHran=7;
      V:array[1..MaxVrch] of 1..MaxHran+1=(1,2,5,5,5,7,7,7,8,8);
      E:array[1..MaxHran] of 0..MaxVrch+1=(2,1,3,5,2,7,8);
      Dnu:byte=1;Von:byte=7;
var Front:array[1..20] of byte;
    Zac,Kon,x,Aktual,Uroven:byte;      {zaciatok frontu}
    Pouzity:array[1..MaxVrch] of boolean;
    Cesta:array[1..MaxVrch] of byte;
BEGIN
  for x:=1 to MaxVrch do Pouzity[x]:=False;
  Front[1]:=Dnu;
  Zac:=1;Kon:=2;Uroven:=1;
  while (Front[Zac]<>Von) and (Zac<Kon) do begin
    Aktual:=Front[Zac];
    Inc(Zac);
    if not Pouzity[Aktual] then begin
      Pouzity[Aktual]:=True;
      Cesta[Uroven]:=Aktual;
      Inc(Uroven);
      if V[Aktual+1]>V[Aktual] then
        for x:=V[Aktual] to V[Aktual+1]-1 do begin
          Front[Kon]:=E[x];
          Inc(Kon);
        end;{for}
      {if}
    end else begin{if else}
      Zac:=Zac+1;
    end;
  end;{while}
  x:=1;
  while Cesta[x]>0 do begin
    Write(Cesta[x],' ');
    x:=x+1;
  end;
  WriteLn(Von);
END.