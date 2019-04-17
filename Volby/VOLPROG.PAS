{ ----- konstanty pre obsluhu mysi a klavesnice ----- }
const AktivVP:array[1..16,1..4] of word=(
        (19,23,190,33),(19,36,190,46),(19,49,190,59),(19,62,190,72),
        (19,75,190,85),(19,88,190,98),(19,101,190,111),(19,114,190,124),
        (19,127,190,137),(19,140,190,150),(19,153,190,163),(19,166,190,196),
        (200,23,280,33),(200,36,280,46),(200,49,280,59),(400,0,0,0));
      KlavVP:array[1..16] of char=('r','n','h','d','o','b','a','v','s','z','p','m','i','e','k',#255);
      AktivPolozkaVP:array[1..6,1..4] of word=(
        (80,69,251,80),(80,83,251,94),(80,97,251,108),(80,111,251,122),
        (80,125,251,136),(400,0,0,0));
      KlavPolozkaVP:array[1..6] of char=('1','2','3','4','5',#255);
{ ----- konstanty suvisiace s hrou ----- }
      PrazdnyVP:array[1..15] of byte=(4,5,5,5,4,5,4,4,4,4,4,4,4,4,5);
var AktualnyVP:array[1..15] of byte;
    Udalost,Udalost2:word;
    Tlacidla:byte;
{ ----- Inicializacia LS ----- }
procedure InitLS;
begin
       {!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
                          DebugMode:=True;
       {!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
  Assign(f,'VolProg.MGP');
  Reset(f,1);
  Seek(f,16);
  for i:=1 to PocetMGPVP do NacitajMGP(f,MGPVPP[i]);
  Close(f);
  Assign(f,'LSPom.MGP');
  Reset(f,1);
  Seek(f,16);
  for i:=1 to PocetMGPPom do NacitajMGP(f,MGPPomP[i]);
  Close(f);
  Assign(f,'Symboly.MB');
  Reset(f,1);
  Seek(f,769);
  for i:=1 to PocetMB do NacitajBMP(f,MBP[i]);
  Close(f);
  for i:=1 to 15 do AktualnyVP[i]:=PrazdnyVP[i];
end;

{ ----- zadavanie volebneho programu ----- }
procedure VolebnyProgram;
begin
  repeat
    VykresliMGP(MGPVPP[1],@MBP,@MSFP);
    Udalost:=ObsluzUdalost(@AktivVP,@KlavVP); {volba kategorie}
    Udalost:=Udalost mod 256;
    CakajNaPustenie;
    if Udalost>0 then begin
      VykresliMGP(MGPVPP[Udalost+1],@MBP,@MSFP);
      PrilepBMPPO(69,55+14*AktualnyVP[Udalost],MBP[1]); {fajka}
      Udalost2:=ObsluzUdalost(@AktivPolozkaVP,@KlavPolozkaVP); {volba moznosti v danej kategorii}
      if Udalost2>0 then begin
        if Udalost2>PrazdnyVP[Udalost] then Udalost2:=PrazdnyVP[Udalost]; {osetrenie neexistujucej polozky}
        Color:=7;
        VyplnPlochu(69,55+14*AktualnyVP[Udalost],10,10); {zmaz fajku}
        PrilepBMPPO(69,55+14*Udalost2,MBP[1]);           {nova fajka}
        AktualnyVP[Udalost]:=Udalost2;                   {zapis vybratu moznost}
        CakajNaPustenie;
        CakajNaUdalost;
      end;
      CakajNaPustenie;
    end;
  until Udalost=0;
end;

{ ----- vypocet, kolko ma poslancov kazda strana ----- }
procedure SpocitajPPosl;
var PPH:real;   {percento prepadnutych hlasov}
begin
  PPH:=100;
  for i:=1 to PocetStran do
    if Pref[i]>=5 then PPH:=PPH-Pref[i];
  for i:=1 to PocetStran do
    if Pref[i]<5 then PPosl[i]:=0
                 else PPosl[i]:=Round(Pref[i]*150/(100-PPH));
end;

{ ----- vypisanie vysledkov volieb ----- }
procedure VysledkyVolieb;
var Maximum:real;
begin
{ ----- zobrazovanie grafu preferencii ----- }
  VM;
  ZmazObrazovku;
  Color:=15;
  SpocitajPreferencie;
  VykresliMGP(MGPPomP[1],@MBP,@MSFP);
  Maximum:=0;
  for i:=1 to PocetStran do              {vypocitaj meritko osi Y}
    if Pref[i]>Maximum then Maximum:=Pref[i];
  j:=Trunc(Maximum/5)+1;
  for i:=1 to j-1 do begin               {urob 5% ciarky na osi Y}
    CiaraVodorovna(17,175-i*(155 div j),6);
    Str(i*5,s);
    VypisPO(0,171-i*(155 div j),MSFP[1],s,SvetloModra); {vypis percenta na Y}
  end;
  for i:=1 to PocetStran do begin
    CiaraZvisla(20+(i-1)*(295 div PocetStran),170,10); {urob ciarky na osi X}
    VypisPO(20+(i-1)*(295 div PocetStran)+2,178,MSFP[1],NazovStrany[i],Hneda);
    Str(Pref[i]:0:1,s); {vypis nazov strany a % na osi X}
    VypisPO(20+(i-1)*(295 div PocetStran)+2,188,MSFP[1],s,SvetloModra);
  end;
  Color:=27;
  for i:=1 to PocetStran do begin                 {vykresli stlpce vysledku}
    VyplnPlochu(20+(i-1)*(295 div PocetStran)+4,
                175-Round(Pref[i]*(155 div j)/5),
                295 div PocetStran-7,
                Round(Pref[i]*(155 div j)/5));
  end;
  ZM;
  CakajNaUdalost;
  VM;
{ ----- vypis poctu poslancov jednotlivych stran ----- }
  VykresliMGP(MGPPomP[2],@MBP,@MSFP);
  SpocitajPPosl;
  for i:=1 to PocetStran do begin
    VypisPO(20,i*15+20,MSFP[2],NazovStrany[i],i); {vypis nazov strany}
    Str(PPosl[i],s);
    VypisPO(100,i*15+20,MSFP[2],s,10);      {vypis pocet poslancov strany}
  end;
  ZM;
  CakajNaUdalost;
  VM;
{ ----- kreslenie parlamentu ----- }
  VykresliMGP(MGPPomP[3],@MBP,@MSFP);
  x:=80;
  for i:=1 to PocetStran do        {vypis legendy}
    if PPosl[i]>0 then begin
      VypisPO(x,192,MSFP[1],NazovStrany[i],i);
      Inc(x,LengthPixel(MSFP[1],NazovStrany[i])+8);
    end;
  x:=0;y:=16;
  for i:=1 to PocetStran do begin  {kreslenie poslancov }
    if PPosl[i]>0 then
      for j:=1 to PPosl[i] do begin
        PrilepBMPPF(x,y,MBP[3],i);
        Inc(y,17);
        Inc(x,4);
        if y>=16+10*17 then begin
          y:=16;
          Dec(x,22);
        end;
      end;
  end;
  ZM;
  CakajNaUdalost;
end;

{ ----- hlavne menu hry ----- }
procedure HlavneMenu;
begin
  ZmazObrazovku;
  PrilepBMP(0,0,Mapa);
  CakajNaUdalost;
end;
