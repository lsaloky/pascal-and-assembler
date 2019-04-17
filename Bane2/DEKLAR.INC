const
f:string[12]='bitmapy.dat'#0;
f2:string[9]='font.dat'#0;
{ ----- rozmery stavieb ----- }
Polozka:array[1..12,1..2] of string[20]=(('bana@','@@=@@'),('sklad',''),('@dom@',''),('cesta',''),
        ('blok@',''),('@kino',''),('@kniznica@','@@@@=@@@@'),('@oceliaren','@@@@@@@@@='),('elektraren','@@@@@@;@@='),
        ('@zbrojovka',''),('r<@centrum',''),('@@@bonus@@',''));
roz:array[1..12,1..2] of byte=((4,4),(4,3),(3,3),(1,1),(3,4),(3,3),(4,3),(5,4),(5,4),(5,5),(5,2),(5,5));
     { ----- oblasti citlive pre mys v suborovom okne (x1,y1,x2,y2) ----- }
oblsub:array[1..6,1..4]of word=((78,77,406,91),(78,92,406,106),
                                (78,107,406,121),(78,122,406,136),
                                 (78,137,406,151),(166,155,302,169));
     { ----- oblast Cennik, Hra, Pomoc, posuny okna (!!! pozzzzor:x1,x2,y1,y2 !!!) ----- }
obl:array[1..12,1..4] of word=((8,135,4,19),(144,235,4,19),(244,371,4,19), {cennik, hra, pomoc}
                               (0,24,24,31),(424,448,24,31),               {vodorovny posun}
                               (448,464,32,44),(448,464,172,183),          {zvisly posun}
                               (449,464,24,31),                            {mapka}
                               (472,552,20,36),(552,602,20,36),            {ludia, ruda}
                               (608,624,103,111),(608,624,111,119));       {+,- vyplata}
     { ----- oblasti v cenniku  (x1,y1,x2,y2) ----- }
oblc:array[1..15,1..4] of word=((88,57,176,71),(88,72,176,86),(88,87,176,101),
                               (88,102,176,116),(88,117,176,131),(88,132,176,146),
                               (288,57,452,71),(288,72,452,86),(288,87,452,101),
                               (288,102,452,116),(288,117,452,131),(288,132,452,146),
                               (92,155,220,171),(236,155,364,171),(384,155,512,171));
     { ----- oblasti v "hra" ----- }
oblh:array[1..5,1..4] of word=((182,51,346,63),(182,66,346,78),(182,81,346,93),
                               (182,96,346,108),(182,111,346,123));
      { ----- informacne vypisy ----- }
infoc:array[0..17]of string[40]=
      ('zvol@si@zelanu@polozku','tazba?rudy','skladovanie?rudy',
       'obydlie?pre?4?obyvatelov','vsetko?musis?pospajat?cestami',
       'obydlie?pre?20?obyvatelov','trochu@zabavy@pre@obyvatelov',
       'trochu@vzdelania@nezaskodi','spracovanie@rudy',
       'energia@pre@tovarne','spracovanie@rudy@a@ocele',
       'navrat@odpadu@do@vyroby','@bonus',
       'zakupenie?polozky','predaj?polozky','koniec?prace?s?cennikom',
       'stlac@KUPIT@alebo@PREDAT','na@tuto@stavbu@nemas@peniaze');
infoh:array[0..5] of string[40]=('','ulozenie@pozicie@na@disk',
       'nahratie@pozicie@z@disku','kutik@pre@zvedavcov','ukoncenie@programu',
       'navrat@do@hry');
{----- dyn. struktura pre ramceky ----- }
type PObr=^TObr;
     TObr=record
            BitMap:pointer;
            x1,y1,x2,y2:word;       {rozsah ramceka}
            mx1,my1,mx2,my2:word;   {rozsah pre mys}
            Dalsia:PObr;
          end;
{ ----- subor pre save hry ----- }
     TSubor=record
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
var fsav:file of TSubor;                 {ukladanie pozicii}
    sav,pomsav:TSubor;                   {vsetko o stave hry}
    p,Obr:PObr;                          {VykresliRamcek, ZrusRamcek - dyn. struktura ramcekov}
    stav:boolean;                        {ci sa v ramcku zobrazuju inf. o ludoch alebo rude, true=ludia}
    pom:array[0..1279] of byte;          {cennik,hra,pomoc - bitmapy}
    font:array[0..4928] of byte;         {font}
    bana:array[0..1023] of byte;         {bana - bitmapa}
    sklad:array[0..767] of byte;         {sklad - bitmapa}
    dom:array[0..575] of byte;           {dom - bitmapa}
    blok:array[0..767] of byte;          {blok - bitmapa}
    kino:array[0..575] of byte;          {kino - bitmapa}
    kniznica:array[0..767] of byte;      {kniznica - bitmapa}
    oceliaren:array[0..1279] of byte;    {oceliaren - bitmapa}
    elektraren:array[0..1279] of byte;   {elektraren - bitmapa}
    zbrojovka:array[0..1599] of byte;    {zbrojovka - bitmapa}
    rcentrum:array[0..639] of byte;      {recyklacne centrum - bitmapa}
    bonus:array[0..1599] of byte;        {??? - bitmapa}
    podklad:array[0..1599] of byte;      {podklad pri kupovani objektu}
    ludia,ruda:array[0..1279] of byte;   {bitmapy Ludia, Ruda. offset 0 - aktivna, 640 pasivna}
    BocnyPodklad:array[0..1599] of byte;  {bitmapa pod Ludia, Ruda}
    lhx,lhy:word;                        {suradnice PP laveho horneho rohu}
    s:string;                            {nalepovany text}
    pomw,pomw2,pomw3,pomw4,xst,yst,c1:word;
    pomb,pomb2:byte;
    sx,sy,kolko:word;                    {proc. Ciaraxxx,NalepText - suradnice,NakresliObjekt}
    x,y,tlacidlo:word;                   {mys - suradnice a tlacidlo}
    udalost,udalostl,udalost2,udalost2l,udalost3:word;{pozicie vo vnorenom menu}
    FHandle:word;                        {handle pre subor v asm}
    ch:char;
    mozne:set of char;                   {povolene klavesy pri mene suboru}
    color:byte;                          {farba ciar}
    sx1,sx2,sy1,sy2:word;                {NakresliObjekt}
    oznac:byte;                          {ci je polozka v cenniku zvolena(a ktora)}
    vod,zvis:array[0..23] of byte;       {podklad pod posuvnou listou}
    OK:boolean;                          {skumanie,ci je mozne polozit stavbu}
    Zobraz:boolean;                      {ci treba prekreslit hraci plan}
    hod,min,sec,stot:word;               {na zistenie casu}
    time:real;                           {prevedene na stotiny sekundy od zaciatku dna}
    TZ:array[0..15,0..176]of byte;      {zvisly pruh travy}
    TV:array[0..239,0..15] of byte;      {vodorovny pruh travy}
procedure InitAsm;assembler;
asm
             mov ax,0A000h
             mov es,ax
             cld
end;