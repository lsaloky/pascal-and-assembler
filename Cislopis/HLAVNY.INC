{ ----- THlavnyProgram ----- }
constructor THlavnyProgram.Init;
begin
{ ----- palety a fonty ----- }
  WriteLn('Inicializacia ... ');
  NacitajPaletu('Prechody.MP',MPP);
  NacitajPaletu('3DKlav.MP',ExtraP);
  NacitajFont('Hlavny8.MSF',pointer(MSFP[1]));
  NacitajFont('Hlavny15.MSF',pointer(MSFP[2]));
  NacitajFont('Hlavny11.MSF',pointer(MSFP[3]));
{ ----- bitmapy ----- }
  Assign(f,'Cislopis.MB');
  Reset(f,1);
  Seek(f,769);
  for i:=1 to PocetMB do NacitajBMP(f,pointer(MBP[i]));
  Close(f);
{ ----- procesy ----- }
  Assign(f,'Cislopis.MGP');
  Reset(f,1);
  Seek(f,16);
  for i:=1 to PocetMGP do NacitajMGP(f,MGPP[i]);
  Close(f);
{ ----- texty ----- }
{$IFDEF OSTRA}
  Assign(ftxt,'Cisla.TXT');
  Reset(ftxt);
  Uvodna.Init(ftxt,71,0);
  Prva.Init(ftxt,107,1);
  Druha.Init(ftxt,160,2);
  Tretia.Init(ftxt,179,3);
  Stvrta.Init(ftxt,179,4);
  Piata.Init(ftxt,146,5);
  Siesta.Init(ftxt,98,6);
  Rozcvicka.Init(ftxt,16,100);
  Rozcvicka.AktualnyMGP:=20;
  Test.Init(ftxt,100,100);
  Test.AktualnyMGP:=21;
  Zaverecna.Init(ftxt,81,100);
  Zaverecna.MusiBytBezChyby:=True;
  Close(ftxt);
{$ENDIF}
{$IFDEF DEMO}
  WriteLn(#13#10#13#10'Toto je len DEMOVERZIA programu CISLOPIS. Obsahuje len uvodnu'#13#10+
          'lekciu. Celu verziu ziskate jej objednanim na adrese:');
  WriteLn(#13#10'Lubos Saloky'#13#10'Slovenskeho 26'#13#10'04001 Kosice'#13#10+
          #13#10'alebo E-mailom na adrese SALOKY@DURO.UPJS.SK'#13#10#13#10);
  WriteLn('Cena je 50 Sk pri posielani programu E-mailom, inak +20 Sk postovne'+
          ' a balne.'#13#10#13#10'Stlacte lubovolny klaves');
  CitajZnak;
  Assign(ftxt,'CislaDem.TXT');
  Reset(ftxt);
  Uvodna.Init(ftxt,71,0);
  Prva.Init(ftxt,1,1);
  Druha.Init(ftxt,1,2);
  Tretia.Init(ftxt,1,3);
  Stvrta.Init(ftxt,1,4);
  Piata.Init(ftxt,1,5);
  Siesta.Init(ftxt,1,6);
  Rozcvicka.Init(ftxt,1,100);
  Rozcvicka.AktualnyMGP:=20;
  Test.Init(ftxt,1,100);
  Test.AktualnyMGP:=21;
  Zaverecna.Init(ftxt,1,100);
  Zaverecna.MusiBytBezChyby:=True;
  Close(ftxt);
{$ENDIF}
{ ----- inicializacia obrazovky ----- }
  InicializujGrafiku;
  NastavPaletu(MPP);
end;
procedure THlavnyProgram.Run;
begin
  repeat
    ZmazObrazovku;
    VykresliMGP(MGPP[1],@MBP,@MSFP);
    ch:=CitajZnak;
    case UpCase(ch) of
      'O':begin
        VykresliMGP(MGPP[19],@MBP,@MSFP);
        repeat
          ch:=CitajZnak;
        until ch in [#13,#27];
        ch:=#0;
        ZmazObrazovku;                     {uprac za sebou}
        VykresliMGP(MGPP[1],@MBP,@MSFP);
      end;
      'R':begin
        Rozcvicka.Cvicenie;
        ZmazObrazovku;                     {uprac za sebou}
        VykresliMGP(MGPP[1],@MBP,@MSFP);
      end;
      'V':begin
        VykresliMGP(MGPP[2],@MBP,@MSFP);
        repeat
          ch:=CitajZnak;
          case UpCase(ch) of
            'U':Uvodna.Cvicenie;
            '1':Prva.Cvicenie;
            '2':Druha.Cvicenie;
            '3':Tretia.Cvicenie;
            '4':Stvrta.Cvicenie;
            '5':Piata.Cvicenie;
            '6':Siesta.Cvicenie;
            'Z':Zaverecna.Cvicenie;
          end;
          ZmazObrazovku;
          VykresliMGP(MGPP[1],@MBP,@MSFP);
          VykresliMGP(MGPP[2],@MBP,@MSFP);
        until UpCase(ch) in ['U','Z','1'..'7',#27];
        ch:=#0;
      end;
      'T':begin
        Test.Cvicenie;
        ZmazObrazovku;                     {uprac za sebou}
        VykresliMGP(MGPP[1],@MBP,@MSFP);
      end;
    end;
  until (ch=#27) or (UpCase(ch)='K');
end;
destructor THlavnyProgram.Done;
begin
  ZavriGrafiku;
  WriteLn('MukoSoft vyukovy program pre p¡sanie c¡sel, verzia 1.0 beta.'#13#10'Lubos Saloky, december 1997 - janu r 1998');
end;