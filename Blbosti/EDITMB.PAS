{$I editory.inc}
BEGIN
  GetMem(Podkl,64000);
  NacitajFont('Hlavny8.MSF',EFP);       { nacitavanie suborov }
  AttrCitaj.Font:=EFP;
  NacitajPaletu('Prechody.MP',EPalP);
  Assign(f,Adresar+'Mgp12.MB');
  Reset(f,1);
  Seek(f,769);
  for i:=1 to PocetEMB do NacitajBMP(f,EMBP[i]);
  Close(f);
  Assign(f,Adresar+'Mgp12.MGP');
  Reset(f,1);
  Seek(f,16);
  for i:=1 to PocetEMGP do NacitajMGP(f,EMGPP[i]);
  Close(f);
  InicializujGrafiku;                   { uz bezi program }
  NastavPaletu(EPalP);
  VypinajMys:=True;
  AktMB:=1;
  NazovBMPSub[1]:='Mgp12.MB';CisloBMPSub[1]:=1;
  Editor:=1;
  ZM;
  EditorMB(NazovBMPSub[AktMB],CisloBMPSub[AktMB]); { editor bitmap }

END.