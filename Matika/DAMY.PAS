program Damy_na_sachovnici;
const n=4; { rozmer sachovnice }
var i,k:integer;
    Kolizia:boolean;
    S:array[1..n] of integer;
procedure Dama(PrvNenul:integer);
var j:integer;
begin
  for j:=1 to n do begin
   Kolizia:=False;
    for k:=1 to PrvNenul-1 do begin { kontrola kolizii }
      if k-S[k]=PrvNenul-j then Kolizia:=True;     { sikmo dole }
      if k+S[k]=PrvNenul+j then Kolizia:=True;     { sikmo hore }
      if   S[k]=j          then Kolizia:=True;     { vodorovne }
    end; { zvisle netreba, pridavame len po jednej dame do stlpca }
    if not Kolizia then begin
      S[PrvNenul]:=j;
      if PrvNenul<n then Dama(PrvNenul+1)
      else begin { vypis }
        for i:=1 to n do Write(S[i]);
        Write(' ± ');
      end;
    end;
{    Sachovnica[PrvNenul]:=0;}  { netreba obnovu predch. stavu }
  end;
end;
BEGIN
  WriteLn(#13#10'-----------------------------------');
  for i:=1 to n do S[i]:=0;
  Dama(1);
END.