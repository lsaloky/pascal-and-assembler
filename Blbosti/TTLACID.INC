type TTlacidlo=object(TOvlPrv)
       TextTlac:string[10];
       constructor Init(pVid:boolean;pPosX,pPosY,pIndex:word;pHelpText,pTextTlac:string);
       procedure Zobraz;virtual;
       procedure SpracujUdalost;virtual;
     end;
     TTheEnd=object(TTlacidlo)
       procedure SpracujUdalost;virtual;
     end;
     TSkryty=object(TTlacidlo)
     end;
     TAktivuj=object(TTlacidlo)
     end;
constructor TTlacidlo.Init;
begin
  RozX:=Length(pTextTlac)*8+4;
  RozY:=12;
  TOvlPrv.Init(pVid,pPosX,pPosY,RozX,RozY,pIndex,pHelpText);
  TextTlac:=pTextTlac;
  if Viditelny then begin
    VypniKurzorMysi;
    Zobraz;
    ZapniKurzorMysi;
  end;
end;
procedure TTlacidlo.Zobraz;
begin
  Viditelny:=True;
  Nastav(PosX,PosY,55);
  Ramcek(RozX,RozY,7);
  Nastav(PosX+2,PosY+2,0);
  VypisPriehladne(TextTlac,Oranzova);
end;
procedure TTlacidlo.SpracujUdalost;
begin
end;
procedure TTheEnd.SpracujUdalost;
begin
  Koniec:=True;
end;
