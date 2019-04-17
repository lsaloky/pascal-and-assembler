type TMenu=object(TOvlPrv)
       Nadpis:string[16];
       constructor Init(pVid:boolean;pPosX,pPosY,pIndex:word;pHelpText,pTlacidla,pNadpis:string);
       procedure Zobraz;virtual;
       procedure SpracujUdalost;virtual;
     end;
constructor TMenu.Init(pVid:boolean;pPosX,pPosY,pIndex:word;pHelpText,pTlacidla,pNadpis:string);
var px,py,pz,maxx:integer;
begin
  Viditelny:=pVid;
  PosX:=pPosX;
  PosY:=pPosY;
  Index:=pIndex;
  HelpText:=pHelpText;
  maxx:=0;
  for px:=1 to 16 do begin
    py:=Pos(';',pTlacidla);
    if py<>0 then begin
      if (py mod 16)>maxx then maxx:=py mod 16;
      Delete(pTlacidla,py,1);
      for pz:=1 to 16-(py mod 16) do Insert(' ',pTlacidla,py);
    end;
  end;
  RozY:=(Length(pTlacidla) div 16+1)*14;
  RozX:=maxx*8;
  Nadpis:=pNadpis;
  HelpText:=pHelpText;
end;
procedure TMenu.Zobraz;
begin

end;
procedure TMenu.SpracujUdalost;
begin
end;
