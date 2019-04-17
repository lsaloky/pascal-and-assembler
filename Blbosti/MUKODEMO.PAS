program Reklama_na_moje_produkty;
uses MainGr,Mys;
const PocetMGP=1;
var MGPP:array[1..PocetMGP] of pointer;
    MSFP:array[1..2] of pointer;
    MPP:pointer;
    f:file;
    i,j:integer;
    s:string;
BEGIN
{ ----- inicializacia ----- }
  NacitajFont('Hlavny8.MSF',MSFP[1]);
  NacitajFont('Hlavny11.MSF',MSFP[2]);
  NacitajPaletu('Prechody.MP',MPP);
  Assign(f,'MukoDemo.MGP');
  Reset(f,1);
  Seek(f,16);
  for i:=1 to PocetMGP do NacitajMGP(f,MGPP[i]);
  Close(f);
  InicializujGrafiku;
  NastavPaletu(MPP);
  ZM;
  VypinajMys:=True;
  VykresliMGP(MGPP[1],nil,@MSFP);
  ReadLn;
{ ----- ukoncenie programu ----- }
END.
