uses MainGr;
var i:longint;
    Font:pointer;
    PalP:pointer;
BEGIN
  InicializujGrafiku;
  NacitajPaletu('Prechody.MP',PalP);
  NacitajFont('Hlavny8.MSF',Font);
  NastavPaletu(PalP);
  VypisP(0,5,Font,'Pokusn`y text sna~ziaci sa o dlh`u slovensk`u vetu.',2);{317 pixelov je dlzka}
  ReadLn;


END.