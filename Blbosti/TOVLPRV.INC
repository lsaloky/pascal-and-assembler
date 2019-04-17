type TOvlPrv=object
       Viditelny:boolean;
       PosX,PosY,RozX,RozY,Index:word;
       HelpText:string[40];
       constructor Init(pVid:boolean;pPosX,pPosY,pRozX,pRozY,pIndex:word;pHelpText:string);
       procedure Skry;
       procedure VypisHelp;
       procedure SpracujUdalost;virtual;
     end;
constructor TOvlPrv.Init(pVid:boolean;pPosX,pPosY,PRozX,PRozY,pIndex:word;pHelpText:string);
begin
  Viditelny:=pVid;
  PosX:=pPosX;
  PosY:=pPosY;
  RozX:=pRozX;
  RozY:=pRozY;
  Index:=pIndex;
  HelpText:=pHelpText;
end;
procedure TOvlPrv.Skry;
begin
  Viditelny:=False;
  Nastav(PosX,PosY,0);
  VyplnPlochu(RozX,RozY);
end;
procedure TOvlPrv.VypisHelp;
begin
  if Viditelny and (sx>=PosX) and (sy>=PosY) and (sx<=PosX+RozX) and (sy<=PosY+RozY) then begin
    if Index<>AktualnyIndex then begin
      VypniKurzorMysi;
      Nastav(0,192,0);
      VyplnPlochu(320,8);
      VypisPriehladne(HelpText,Hneda);
      ZapniKurzorMysi;
      AktualnyIndex:=Index;
    end;
    BoloNaOvladacomPrvku:=True;
    if Tlacidla=1 then SpracujUdalost;
  end;
end;
procedure TOvlPrv.SpracujUdalost;
begin
end;
