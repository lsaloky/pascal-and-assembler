program MukoSoft_utility;{verzia 1.0}
uses MainGr,Mys,BMPUtil;
{ ----- deklaracia statickych premennych ----- }
var f:file;
    i,j:integer;
    x,y:word;          {hlavne pre mys}
    Tlacidla:byte;     {aj toto}
    ch:char;
    s:string;
{ ----- deklaracia tried objektov ----- }
type TPracovnaPlocha=object
         public
       MSFP:array[0..2] of pointer;
       MPP:pointer;
         private
       MBP:array[0..1] of pointer;
       MGPP,Podklad:pointer;
       Udalost:word;
       constructor Init;
       procedure ObsluzUdalost;
       destructor Done;
     end;

     TKalkulacka=object
         public

         private
       constructor Init;
       procedure ObsluzUdalost;
       destructor Done;
     end;
{ ----- procedury triedy TKalkulacka ----- }
constructor TKalkulacka.Init;
begin
end;
procedure TKalkulacka.ObsluzUdalost;
begin
end;
destructor TKalkulacka.Done;
begin
end;
var Kalkulacka:TKalkulacka;
{ ----- procedury triedy TPracovnaPlocha ----- }
constructor TPracovnaPlocha.Init;
begin
  GetMem(Podklad,320*192+4);
  NahodnaBMP(320,192,0,Podklad);
  PriemerujBMP(Podklad);
  PriemerujBMP(Podklad);
  UpravJasBMP(Podklad,1,2);
  NacitajFont('Hlavny5.MSF',MSFP[0]);
  NacitajFont('Hlavny8.MSF',MSFP[1]);
  NacitajFont('Hlavny11.MSF',MSFP[2]);
  NacitajPaletu('Prechody.MP',MPP);
  Assign(f,'mu1.mgp');
  Reset(f,1);
  Seek(f,16);
  NacitajMGP(f,MGPP);
  Close(f);
  Assign(f,'mu1.mb');
  Reset(f,1);
  Seek(f,769);
  NacitajBMP(f,MBP[0]);
  Close(f);
  InicializujGrafiku;
  NastavPaletu(MPP);
  PrilepBMP(0,0,Podklad);
  VykresliMGP(MGPP,@MBP,@MSFP);
  ZM;
  VypinajMys:=True;
end;
procedure TPracovnaPlocha.ObsluzUdalost;
begin
  repeat
{    Udalost:=ObsluzUdalostSHelpom(@Aktiv,MSFP,@Klav,@Pomoc);}
    case Udalost of
      2:begin
        Kalkulacka.Init;
        Kalkulacka.ObsluzUdalost;
        Kalkulacka.Done;
      end;
    end;
  until Udalost=1;
end;
destructor TPracovnaPlocha.Done;
begin
  FreeMem(Podklad,320*192+4);
  FreeMem(MPP,768);
  ZavriGrafiku;
  WriteLn('Koniec nedokonceneho programu'#13#10'Lubos Saloky, 1997');
end;
{ ----- deklaracia objektov ----- }
var PracovnaPlocha:TPracovnaPlocha;
{ ----- hlavny program ----- }
BEGIN
  PracovnaPlocha.Init;
  PracovnaPlocha.ObsluzUdalost;
  PracovnaPlocha.Done;
END.