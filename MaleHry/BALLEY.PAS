program Videohra;
uses MainGr,Mys,BMPUtil,Crt;
{sucastou tejto hry su subory:

  Hlavny8.MSF        font
  Prechody.MP        paleta
  Balley.MB          bitmapy
  Balley.MGP         graficke procesy
  Najlepsi.DAT       10 najlepsich
  }

const PocetBMP=20;PocetMGP=6;PocetPozadi=1;VodorOkr=PocetBMP+1;PocetFNT=2;
      InfoY=50;
      Aktiv:array[1..9,1..4] of word=({v hlavnom menu}
        (101,83,201,101)  {Start}   ,(101,115,201,133) {Pravidla}  ,
        (101,137,201,155) {10 naj}  ,(101,159,201,177) {Koniec}    ,
        (24,146,90,155)   {mini}    ,(24,156,90,165)   {standard}  ,
        (24,166,90,175)  {maxi}     ,(24,176,90,185)   {slovensky} ,
        (400,0,0,0));
      ZacKot:array[1..4] of byte=(7,7,7,12);   {pociatocny kotuc pre jednotlive hry}
      Trenie:array[1..4] of byte=(1,1,1,1);    {o kolko sa spomaluje kotuc}
      MaxRychlost:array[1..4] of byte=(55,57,49,59);{maximalne rychlosti kotuca}
      PocetKot:array[1..4] of byte=(3,4,4,4);  {pocty kotucov pre jednotlive hry}
      PozKot:array[1..4,1..4] of word=(        {x-ova suradnica kotuca}
        (30,125,220,0),(12,92,172,252),(12,92,172,252),(12,92,172,252));
      Klav:array[1..9] of char=('s','p','n','k','i','t','a','l',#255);
      Text:array[1..4] of string[15]=('~Start','Pravidl`a','10 najlep~s`ich','Koniec hry');
var i,j,Udalost,TypHry,Col,Vklad,AktMaxRychlost:integer;
    Konto,StKonto:longint;
    x,y:word;
    Tlacidla:byte;
    ch:char;
    f:file;
    FP:array[1..PocetFNT] of pointer;
    pal,podkl:pointer;
    Poz:array[1..PocetPozadi] of pointer;
    BMP:array[1..PocetBMP+1] of pointer;
    MaleBMP:array[7..16] of pointer;
    MGP:array[1..PocetMGP] of pointer;
    AktSymbol,Rychlost,PozYKot,PozZalKot:array[1..4] of byte;
    Koniec:boolean;
    PocetSymb:array[7..16] of byte;{pocet symbolov jednotlivych typov}
label 1;
procedure InicializujHlavneMenu;
begin
  PrilepBMP(0,0,Poz[1]);
  Color:=0;
  CiaraVodorovna(0,0,320);
  CiaraVodorovna(0,199,320);
  VyplnPlochu(20,140,60,40);
  VykresliMGP(MGP[1],@BMP,@FP);
  StiahniBMP(22,136+10*TypHry,8,8,podkl);
  PrilepBMP(22,136+10*TypHry,BMP[1]);
end;
{ ----- zabezpecuje otacanie kotucov ----- }
procedure RychloPrilepBMP;assembler;
asm
             mov bx,56                 {pocet riadkov}
@DalsiRiadok:cmp dx,100
             jb @Nekresli
             cmp dx,189
             ja @Nekresli
             mov cx,28
         rep movsw
             jmp @Pokracuj
@Nekresli:   add di,56
             add si,56
@Pokracuj:   add di,320-56
             inc dx
             dec bx
             jnz @DalsiRiadok
end;
procedure VykresliKotuce;
var Minus1,Plus1,c1:byte;
    Ofset1,Ofset2,Ofset3,y:word;
    BMP1,BMP2,BMP3:pointer;
begin
  for c1:=1 to PocetKot[TypHry] do begin
    if AktSymbol[c1]=ZacKot[TypHry] then Minus1:=ZacKot[TypHry]+4 else Minus1:=AktSymbol[c1]-1;
    if AktSymbol[c1]=ZacKot[TypHry]+4 then Plus1:=ZacKot[TypHry] else Plus1:=AktSymbol[c1]+1;
    y:=PozYKot[c1];
    Ofset1:=(y-64)*320+PozKot[TypHry,c1];
    Ofset2:=y*320+PozKot[TypHry,c1];
    if y<140 then Ofset3:=(y+64)*320+PozKot[TypHry,c1]
             else Ofset3:=0;
    BMP1:=BMP[Minus1];
    BMP2:=BMP[AktSymbol[c1]];
    BMP3:=BMP[Plus1];
    asm
             push ds
             cld
             mov es,VSeg
             mov di,Ofset1
             mov ds,word ptr BMP1+2
             mov si,word ptr BMP1
             add si,4
             mov dx,y                  {y-ova sur.}
             sub dx,64
             call RychloPrilepBMP
             mov di,Ofset2
             mov ds,word ptr BMP2+2
             mov si,word ptr BMP2
             add si,4
             mov dx,y
             call RychloPrilepBMP
             mov di,Ofset3
             mov ds,word ptr BMP3+2
             mov si,word ptr BMP3
             add si,4
             mov dx,y
             add dx,64
             call RychloPrilepBMP
             pop ds
    end;
  end;
end;
{ ----- uprav financnu hotovost hraca ----- }
procedure PrepisSumy;
var KonS,VkladS:string;
begin
  Str(Konto,KonS);
  Str(Vklad,VkladS);
  Color:=15;
  Ramcek(96,3,50,16,6);
  Ramcek(96,22,50,16,6);
  VypisPO(100,7,FP[1],KonS,SvetloModra);
  VypisPO(100,26,FP[1],VkladS,SvetloModra);
end;
{ ----- spracovanie klavesnice pri toceni kotucmi ----- }
function SpracujKlavesnicu:boolean;
begin
  SpracujKlavesnicu:=False;
  while KeyPressed do ch:=ReadKey;
  case ch of
    #27:Koniec:=True;
    ' ':SpracujKlavesnicu:=True;
  end;
end;
{ ----- spracovanie mysi aj klavesnice ----- }
function Odozva:boolean;
begin
  Odozva:=False;
  ZistiPoziciu(x,y,Tlacidla);
  if Tlacidla>0 then Odozva:=True;
  if KeyPressed then Odozva:=SpracujKlavesnicu
  else if Tlacidla=0 then Delay(200);   {ked je klavesnica pomala, byvali problemy}
  if KeyPressed then Odozva:=SpracujKlavesnicu;{teraz je to komplikovane ale je to OK}
end;
{ ----- vypis pravidla, na zaklade ktoreho hrac vyhral a uprava sumy ----- }
procedure Vyhra(NasVklad:real);
var s:string;
begin
  Str(NasVklad:0:1,s);
  Konto:=Konto+Round(NasVklad*Vklad);
  PrepisSumy;
  if TypHry=1 then begin
    Vypis(0,InfoY+10,FP[1],'     +     +     = '+s+' x vklad.',Hneda);
    PrilepBMP(0,InfoY,MaleBMP[AktSymbol[1]]);
    PrilepBMP(44,InfoY,MaleBMP[AktSymbol[2]]);
    PrilepBMP(88,InfoY,MaleBMP[AktSymbol[3]]);
  end else begin
    Vypis(0,InfoY+10,FP[1],'     +     +     +     = '+s+' x vklad.',Hneda);
    PrilepBMP(0,InfoY,MaleBMP[AktSymbol[1]]);
    PrilepBMP(44,InfoY,MaleBMP[AktSymbol[2]]);
    PrilepBMP(88,InfoY,MaleBMP[AktSymbol[3]]);
    PrilepBMP(132,InfoY,MaleBMP[AktSymbol[4]]);
  end;
end;
function SucetRych:integer;
var c1,c2:integer;
begin
  c2:=0;
  for c1:=1 to PocetKot[TypHry] do Inc(c2,Rychlost[c1]);
  SucetRych:=c2;
end;
procedure NastavPocetnostSymbolov;
var ii:integer;
begin
  for ii:=7 to 16 do PocetSymb[ii]:=0;
  for ii:=1 to PocetKot[Typhry] do Inc(PocetSymb[AktSymbol[ii]]);
end;

BEGIN
{ ----- inicializacia, nacitanie datovych suborov ----- }
  TypHry:=1;
  Writeln('Cakaj');
  NahodnaBMP(320,200,Cierna,Poz[1]);
  PriemerujBMP(Poz[1]);
  for i:=1 to 400 do Mem[Seg(Poz[1]^):Ofs(Poz[1]^)+4+Random(64000)]:=Random(40);
  PriemerujBMP(Poz[1]);
  PriemerujBMP(Poz[1]);
  UpravJasBMP(Poz[1],2,3);
  write('.');
  NacitajFont('Hlavny8.MSF',FP[1]);
{  NacitajFont('Hlavny11.MSF',FP[2]);}
  NacitajPaletu('Prechody.MP',pal);
  Assign(f,'Balley.MB');
  Reset(f,1);
  Seek(f,769);
  for i:=1 to PocetBMP do NacitajBMP(f,BMP[i]);
  Close(f);
  GetMem(BMP[VodorOkr],104);
  KopirujBMP(BMP[17],BMP[VodorOkr],0,0,10,10);
  PreklopBMP(BMP[VodorOkr],'/');
  for i:=7 to 16 do begin
    GetMem(MaleBMP[i],28*28+4);
    ZmenMierkuBMP(BMP[i],MaleBMP[i],1,2,1,2);
  end;
  Assign(f,'Balley.MGP');
  Reset(f,1);
  Seek(f,16);
  for i:=1 to PocetMGP do NacitajMGP(f,MGP[i]);
  Close(f);
  write('.');
  InicializujGrafiku;
  NastavPaletu(pal);
  GetMem(podkl,68);
  InicializujHlavneMenu;
  ZM;
  VypinajMys:=True;
  Randomize;
{ ----- hlavne menu ----- }
  repeat
    Udalost:=ObsluzUdalost(@Aktiv,@Klav);
    if Udalost in [1..4] then begin
      if Udalost=1 then Col:=1 else Col:=6;
      Tlacidlo3D(Aktiv[Udalost,1],Aktiv[Udalost,2],100,18,FP[1],Text[Udalost],9,Col,True);
      CakajNaPustenie;
      while KeyPressed do ReadKey;
    end;
    case Udalost of
{ ----- samotna hra, inicializacia ----- }
      1:begin
        VM;
        ZmazObrazovku;
        VykresliMGP(MGP[2],@BMP,@FP);
        Konto:=100;Vklad:=5;
        PrepisSumy;
        PrilepBMP(270,5,BMP[19]);
        PrilepBMPPO(272,7,BMP[20]);
        ZM;
        for i:=1 to PocetKot[TypHry] do begin
          AktSymbol[i]:=Random(5)+ZacKot[TypHry];
          Rychlost[i]:=0;
          PozYKot[i]:=117;
        end;
        for i:=1 to 30 do PrilepBMP(i*10,90,BMP[VodorOkr]);
        for i:=1 to 30 do PrilepBMP(i*10,190,BMP[VodorOkr]);
        for i:=1 to 9 do PrilepBMP(0,90+i*10,BMP[17]);
        for i:=1 to 9 do PrilepBMP(310,90+i*10,BMP[17]);
        VykresliKotuce;
        Koniec:=False;
{ ----- tu sa zacina hlavny cyklus pre otacanie kotucmi ----- }
        repeat
{!!!!!}   Color:=0;VyplnPlochu(0,InfoY,240,30);
          repeat
            repeat
              ch:=#0;
              ZistiPoziciu(x,y,Tlacidla);
              if KeyPressed then ch:=ReadKey;
            until (Tlacidla>0) or (ch in [' ','+','-',#27]);
            case ch of
              #27:goto 1;
              '+':if Vklad<Konto then begin
                Inc(Vklad);
                PrepisSumy;
              end;
              '-':if Vklad>1 then begin
                Dec(Vklad);
                PrepisSumy;
              end;
            end;
          until Odozva;
{ ----- posuvanie paky ----- }
          repeat
            for i:=1 to PocetKot[TypHry] do
            if Rychlost[i]<MaxRychlost[i] then Inc(Rychlost[i],Random(5)+1);
            PrilepBMP(270,5,BMP[19]);
            PrilepBMPPO(272,7+SucetRych div PocetKot[TypHry],BMP[20]);
            Delay(100);
          until (not Odozva) or (Koniec);
          AktMaxRychlost:=SucetRych;
          if Koniec then goto 1;
          PrilepBMP(270,5,BMP[19]);
          PrilepBMPPO(272,7,BMP[20]);
{ ----- kotuce sa otacaju a spomaluju, riadiaci cyklus ----- }
          repeat
            for i:=1 to PocetKot[TypHry] do begin
              Inc(PozYKot[i],Rychlost[i]+Random(3));
              if PozYKot[i]>117+64 then begin{ak prejde na dalsi symbol}
                Dec(PozyKot[i],64);
                Dec(AktSymbol[i]);
                if AktSymbol[i]=ZacKot[TypHry]-1 then AktSymbol[i]:=ZacKot[TypHry]+4;
              end;
              if Rychlost[i]>10 then Dec(Rychlost[i],Trenie[i]+Random(2))
                                else Dec(Rychlost[i],Random(2));
              if Rychlost[i]>100 then Rychlost[i]:=0;
            end;
            Color:=0;VyplnPlochu(10,100,300,90);
            VykresliKotuce;
            CakajNaVOI;
          until SucetRych=0;
{ ----- kotuce sa zastavili, uprav ich poziciu ----- }
          Delay(300);
          for i:=1 to PocetKot[TypHry] do PozZalKot[i]:=PozYKot[i];
          for i:=20 downto 0 do begin
            for j:=1 to PocetKot[TypHry] do PozYKot[j]:=117+((PozZalKot[j]-117)*i) div 20;
            Color:=0;VyplnPlochu(10,100,300,90);
            VykresliKotuce;
            CakajNaVOI;
          end;
{ ----- vyhodnot vysledok ----- }
          if AktMaxRychlost>60 then begin
            StKonto:=Konto;
            case TypHry of
              1:begin  { Mini Balley }
                if (AktSymbol[1]=8) and                  {3 x Balley}
                   (AktSymbol[2]=8) and
                   (AktSymbol[3]=8) then Vyhra(20);
                if (AktSymbol[1]=AktSymbol[2]) and       {3 rovnake}
                   (AktSymbol[2]=AktSymbol[3]) and
                   (AktSymbol[1]<>8) then Vyhra(5);
                if (AktSymbol[1]=7) and                  {Flasa+Minca}
                   (AktSymbol[2]=10) then Vyhra(4);
                if (AktSymbol[1]<>AktSymbol[2]) and      {3 rozne}
                   (AktSymbol[2]<>AktSymbol[3]) and
                   (AktSymbol[1]<>AktSymbol[3]) then Vyhra(0.5);
                if (Konto=StKonto) and                   {1. hviezda}
                   (AktSymbol[1]=9) then Vyhra(2);
                if (AktSymbol[1]=7) and                  {3 rumy}
                   (AktSymbol[2]=7) and
                   (AktSymbol[3]=7) then Koniec:=True;
              end; {case 1}
              2:begin
                NastavPocetnostSymbolov;
                if PocetSymb[8]=4 then Vyhra(60);        {4 balley}
                if (AktSymbol[1]=AktSymbol[2]) and
                   (AktSymbol[2]=AktSymbol[3]) and
                   (AktSymbol[3]=AktSymbol[4]) and
                   (AktSymbol[1]<>8) then Vyhra(15);     {4 rovnake}
                if PocetSymb[10]=3 then Vyhra(8);        {3 mince}
                if (AktSymbol[1]=9) and                  {Hviezda,List}
                   (AktSymbol[2]=11) then Vyhra(5);
                if (Konto=STKonto) and
                   (AktSymbol[1]=11) then Vyhra(1.5);    {1. List}
                if (Konto=STKonto) and
                   (PocetSymb[7]=2) then Vyhra(1);       {2 x rum}
                if (Konto=STKonto) and
                   (PocetSymb[7]<2) and
                   (PocetSymb[8]<2) and
                   (PocetSymb[9]<2) and
                   (PocetSymb[10]<2) and
                   (PocetSymb[11]<2) then Vyhra(0.5);    {4 r“zne}
              end;
            end; {case}
            if Konto=StKonto then begin
              Konto:=Konto-Vklad;                        {nevyhral}
              VypisPO(0,InfoY+3,FP[1],'Prehral si vlo~zen`u sumu.',SvetloModra);
            end;
            if Konto<Vklad then Vklad:=Konto;            {uz nemozes vlozit viac}
          end else begin
            VypisPO(0,InfoY+3,FP[1],'Slabo si rozto~cil kot`u~ce.',SvetloModra);
          end;
          PrepisSumy;
          CakajNaPustenie;
          ch:=#0;
          repeat
            ZistiPoziciu(x,y,Tlacidla);
            if KeyPressed then ch:=ReadKey;
          until (Tlacidla>0) or (ch>#0);
          case ch of
            #27:Koniec:=True;
            '+':if Vklad<Konto then begin
              Inc(Vklad);
              PrepisSumy;
            end;
            '-':if Vklad>1 then begin
              Dec(Vklad);
              PrepisSumy;
            end;
          end;
          if Konto=0 then Koniec:=True;              {totalna prehra}
        until Koniec;
1:      InicializujHlavneMenu;
        ZM;
      end; {case 1}
{ ----- prepinanie medzi Mini, ... , Slovensky ----- }
      2:begin
        ZmazObrazovku;
        VykresliMGP(MGP[2+TypHry],@BMP,@FP);
        readln;
        InicializujHlavneMenu;
      end;
{ ----- nastavovanie typu hry ----- }
      5..8:if Udalost-4<>TypHry then begin
        PrilepBMP(22,136+10*TypHry,podkl);
        PrilepBMPPO(22,136+10*(Udalost-4),BMP[1]);
        TypHry:=Udalost-4;
      end;
    end;
  until Udalost=4;
  ZavriGrafiku;
END.