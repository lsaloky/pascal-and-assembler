program Editor_terenu;{zatial usposobeny pre hru CeMan}
uses MainGr,Mys;
const PocetMB=1;PocetMGP=1;
      PocetOP=7;
      DlzkaStrany=15;
      Aktiv:array[1..PocetOP+1,1..4] of word=(
            (0,0,215,199),(220,0,319,160),(220,164,268,180),(270,164,318,180),
            (220,184,268,199),(270,184,318,199),(321,0,322,1),(400,0,0,0));
      Klav:array[1..PocetOP+1] of char=(#0,#0,',','.','u',#27,'m',#255);
var MBP:array[1..PocetMB] of pointer;
    MGPP:array[1..PocetMGP] of pointer;
    MPP,MSFP:pointer;
    i,j,Udalost:integer;
    f:file;
BEGIN
  InicializujGrafiku;
  NacitajPaletu('Prechody.MP',MPP);
  NacitajFont('Hlavny8.MSF',MSFP);
  NastavPaletu(MPP);
  Assign(f,'Bitmapy.MB');
  Reset(f,1);
  Seek(f,769);
  for i:=1 to PocetMB do NacitajBMP(f,MBP[i]);
  Close(f);
  Assign(f,'Procesy.MGP');
  Reset(f,1);
  Seek(f,16);
  for i:=1 to PocetMGP do NacitajMGP(f,MGPP[i]);
  Close(f);
  VykresliMGP(MGPP[1],@MBP,@MSFp);
  for i:=0 to 5 do
    for j:=0 to 8 do
      PrilepBMPPO(i*38,j*20,MBP[1]);
  for i:=0 to 4 do
    for j:=0 to 8 do
      PrilepBMPPO(19+i*38,10+j*20,MBP[1]);
  ZM;
  VypinajMys:=True;
  repeat
    Udalost:=ObsluzUdalost(@Aktiv,@Klav);
  until Udalost=6;
  ZavriGrafiku;
  WriteLn('MukoSoft editor ter‚nu'#13#10'Lubos Saloky, janu r 1998');
END.

