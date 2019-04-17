constructor THra.Init;
begin
  gd:=9;
  gm:=2;
  CakajChvilu; { inicializacia countera }
  SCas:=Cas;
  InitGraph(gd,gm,'.'); { EGAVGA.BGI v aktualnom adresari }
  CPartie:=1;
end;
procedure THra.Partia;
begin
  if not CPartie=1 then ClearDevice;
  Line(0     ,0     ,ObrX  ,0     );
  Line(ObrX  ,0     ,ObrX  ,ObrY  );
  Line(ObrX  ,ObrY  ,0     ,ObrY  );
  Line(0     ,ObrY  ,0     ,0     );
  Line(1     ,1     ,ObrX-1,1     );
  Line(ObrX-1,1     ,ObrX-1,ObrY-1);
  Line(ObrX-1,ObrY-1,1     ,ObrY-1);
  Line(1     ,ObrY-1,1     ,1     );
{  SetLineStyle(0,0,3);}
  repeat
    Hmyz.ZapisPozicie;
    Hmyz.CitajPozicie;
  until ((Lokalny) and (Cerv[5].PozX+Cerv[5].PozY>1)) or
    ((not Lokalny) and (Cerv[1].PozX+Cerv[1].PozY>1)); { cakaj na realne data }
  for i:=1 to 3 do CakajChvilu;
  SCas:=Cas;
  repeat { hlavny cyklus hry }
    CakajChvilu;
    Hmyz.ZapisPozicie;
    Hmyz.CitajPozicie;
    Hmyz.PosunPozicie(1); { aj nakresli lokalne }
    Hmyz.KresliPozicie;{ tu len vzdialene }
    Hmyz.SpracujPouzivatelov;
    SCas:=Cas;
  until (Zoznam^[1]>0) or (Hmyz.VsetciHavarovali);
{  SetLineStyle(0,0,1);}
end;
procedure THra.CakajChvilu;
begin
  asm
@Cakaj:      xor ax,ax
             int 1Ah     { BIOS counter }
             cmp dx, word ptr Cas
             je @Cakaj
             mov word ptr Cas, dx
             mov word ptr Cas+2, cx
  end;
end;
destructor THra.Done;
begin
  CloseGraph;
end;