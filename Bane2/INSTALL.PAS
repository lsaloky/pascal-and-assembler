program Inicializacia_KORPOR_SAV;
type TSubor=record
              NazovSAVu:string[40];
              Den,Mesiac,Rok,DoRoku:word;
              Peniaze:longint;
              Tazba,Prestiz,DennaMzda,NaSklad,NaPredaj,NaVyskum,VyskumSuma:word;
              PocetStavieb,PocetLudi:word; {stavby s indexami 1-12 okrem 5}
              Cennik:array[0..12] of word;
              Pocet:array[0..12] of word;
{ruda,bana,sklad,dom,cesta,blok,kniznica,kino,oceliaren,elektraren,zbrojovka,rec. centrum,...}
              Vyplata:array[1..31] of word;       {v ktory den ma kolko ludi vyplatu}
              PPlocha:array[0..69,0..52] of byte; {pracovna plocha,vyuzit‚ len 62*50}
              Stavba:array[0..255,1..3] of byte;  {stavby}
              UzVyskumane:word;
              Rezerva:array[1..98] of byte;
            end;
var f:file of TSubor;
    x:word;
    sav:TSubor;
begin
  Assign(f,'korpor.sav');
  Rewrite(f);
  with sav do begin
    NazovSAVu:='@@@@volna@pozicia@@@';
    den:=12;mesiac:=4;rok:=2003;DoRoku:=2007;
    peniaze:=10020;
    tazba:=8;prestiz:=61;DennaMzda:=57;nasklad:=20;napredaj:=60;navyskum:=20;
    vyskumsuma:=0;
    pocetstavieb:=0;pocetludi:=22;
    cennik[0]:=12;cennik[1]:=8000;cennik[2]:=2000;cennik[3]:=2200;
    cennik[4]:=300;cennik[5]:=10000;cennik[6]:=4200;cennik[7]:=6300;
    cennik[8]:=6500;cennik[9]:=11000;cennik[10]:=18000;
    cennik[11]:=7200;cennik[12]:=0;
    for x:=0 to 12 do pocet[x]:=0;
    for x:=1 to 22 do vyplata[x]:=1;
    for x:=23 to 31 do vyplata[x]:=0;
    UzVyskumane:=4;
  end;
  for x:=1 to 5 do write(f,sav);
  Close(f);
end.