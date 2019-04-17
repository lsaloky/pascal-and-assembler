program O_ekvivalenciach_verzia_2;
{simulacia zazobnika}
const MaxVrch=10;MaxHran=7;
      V:array[1..MaxVrch] of 1..MaxHran=(1,2,4,4,4,5,5,5,6,6);
      E:array[1..MaxHran] of 0..MaxVrch=(2,3,5,7,8,0,0);
      Dnu:byte=1;Von:byte=7;
var Zas:array[1..MaxVrch] of byte;
    Vrch,Aktual,x,Uroven:byte;
    Pouzity:array[1..MaxVrch] of boolean;
    Cesta:array[1..MaxVrch] of byte;
BEGIN
  Vrch:=1;Uroven:=1;
  Zas[1]:=Dnu;
  for x:=1 to MaxVrch do Pouzity[x]:=False;
  while (Aktual<>Von) and (Vrch>0) do begin
    Aktual:=Zas[Vrch];
    Pouzity[Aktual]:=True;
    Dec(Vrch);
    if V[Aktual+1]>V[Aktual] then begin
      Cesta[Uroven]:=Aktual;
      Inc(Uroven);
      for x:=V[Aktual] to V[Aktual+1]-1 do begin
        Inc(Vrch);
        Zas[Vrch]:=E[x];
      end;{for}
    end;{if}
  end;{while}
  x:=1;
  while Cesta[x]>0 do begin
    Write(Cesta[x],' ');
    Inc(x);
  end;
  WriteLn(Von);
END.