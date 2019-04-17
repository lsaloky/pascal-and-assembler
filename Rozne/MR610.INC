uses Graph,Crt,Myska,Dos;
{ ----- deklaracie ----- }
procedure PriebehFunkcie;forward;
type TTlacidlo=record
       x,y:word;
       Text:string[10];
       Color:byte;
       HotKey:string[5];
       Help:string[50];
     end;
     Token=(SINFUNC,COSFUNC,EXPFUNC,LNFUNC,SQRTFUNC,PLUS,MINUS,TIMES,
            DIVIDE,NUMBER,UNKNOWN,VARIABLE,ABSFUNC,ARCTANFUNC);
     ObsahObrazovky=(OKALKUL,OGRAFY,OVSADE);
     TOOP=record               {Ostatne Ovladacie Prvky}
       x,y,dx,dy:word;         {lavy horny roh a rozmery}
       Aktivny:ObsahObrazovky;
       Help:string[50];
     end;
     NodePtr=^Node;
     Node=record
       Op:Token;
       Value:Single;
       Left,Right:NodePtr;
     end;
const gd:integer=9;
      gm:integer=2;
      NumX=360;      {suradnice bloku cislic a 4 zakl. operacii}
      NumY=140;
      FuncX=30;      {blok funkcii}
      FuncY=160;
      MemX=370;      {pamat a mazanie}
      MemY=340;
      DisplayX=10;   {displej}
      DisplayY=40;
      WinDispX1=40;  {okno v displeji}
      WinDispY1=40;
      WinDispX2=600;
      WinDispY2=100;
      GrafSX=330;     {blok funkcii grafov}
      GrafSY=50;
      DGrafX=50;      {dole pri funkciach grafov}
      DGrafY=260+DisplayY;
      PocetTlacidiel=47;
      PocetOOP=14;
      Klavesnica:string[PocetTlacidiel]='1234567890.'#13'+-*/'#0#0'e'#0#0#0'sctSCTr%!'#0#0#0'ng()'#0#0'm'#0#0#27#0#8'Q';
      GKlavesnica:string[PocetOOP]=#0#0#0#0#0#0#0'+-f8426';
      Obrazovka:array[1..PocetTlacidiel] of TTlacidlo=(
        (x:NumX;     y:NumY;      Text:'1';     Color:11;HotKey:'1'    ;Help:''),
        (x:NumX+50;  y:NumY;      Text:'2';     Color:11;HotKey:'2'    ;Help:''),
        (x:NumX+100; y:NumY;      Text:'3';     Color:11;HotKey:'3'    ;Help:''),
        (x:NumX;     y:NumY+40;   Text:'4';     Color:11;HotKey:'4'    ;Help:''),
        (x:NumX+50;  y:NumY+40;   Text:'5';     Color:11;HotKey:'5'    ;Help:''),
        (x:NumX+100; y:NumY+40;   Text:'6';     Color:11;HotKey:'6'    ;Help:''),
        (x:NumX;     y:NumY+80;   Text:'7';     Color:11;HotKey:'7'    ;Help:''),
        (x:NumX+50;  y:NumY+80;   Text:'8';     Color:11;HotKey:'8'    ;Help:''),
        (x:NumX+100; y:NumY+80;   Text:'9';     Color:11;HotKey:'9'    ;Help:''),
        (x:NumX;     y:NumY+120;  Text:'0';     Color:11;HotKey:'0'    ;Help:''),
        (x:NumX+50;  y:NumY+120;  Text:'.';     Color:1; HotKey:'.'    ;Help:'Desatinna ciarka'),
        (x:NumX+100; y:NumY+120;  Text:'=';     Color:15;HotKey:'Enter';Help:'Vysledok vypoctu'),
        (x:NumX+170; y:NumY;      Text:'+';     Color:1; HotKey:'+'    ;Help:'Scitanie'),
        (x:NumX+170; y:NumY+40;   Text:'-';     Color:1; HotKey:'-'    ;Help:'Odcitanie'),
        (x:NumX+170; y:NumY+80;   Text:'*';     Color:1; HotKey:'*'    ;Help:'Nasobenie'),
        (x:NumX+170; y:NumY+120;  Text:'/';     Color:1; HotKey:'/'    ;Help:'Delenie'),
        (x:FuncX;    y:FuncY;     Text:'y|x';   Color:1; HotKey:''     ;Help:'Mocnina: zadaj Y, Y^X, X'),
        (x:FuncX;    y:FuncY+35;  Text:'10|x';  Color:11;HotKey:''     ;Help:'10 na dane cislo'),
        (x:FuncX;    y:FuncY+70;  Text:'e|x';   Color:11;HotKey:'e'    ;Help:'e na dane cislo'),
        (x:FuncX;    y:FuncY+105; Text:'x|2';   Color:1; HotKey:''     ;Help:'Druha mocnina'),
        (x:FuncX;    y:FuncY+140; Text:'';      Color:1; HotKey:''     ;Help:'Druha odmocnina'),
        (x:FuncX;    y:FuncY+175; Text:'';      Color:11;HotKey:''     ;Help:'Odmocnina: zadaj Y, stlac tlacidlo, zadaj X'),
        (x:FuncX+70; y:FuncY;     Text:'sin';   Color:1; HotKey:'s'    ;Help:'Sinus'),
        (x:FuncX+70; y:FuncY+35;  Text:'cos';   Color:1; HotKey:'c'    ;Help:'Kosinus'),
        (x:FuncX+70; y:FuncY+70;  Text:'tan';   Color:1; HotKey:'t'    ;Help:'Tangens'),
        (x:FuncX+70; y:FuncY+105; Text:'sin|-1';Color:11;HotKey:'S'    ;Help:'Arcus sinus'),
        (x:FuncX+70; y:FuncY+140; Text:'cos|-1';Color:11;HotKey:'C'    ;Help:'Arcus cosinus'),
        (x:FuncX+70; y:FuncY+175; Text:'tan|-1';Color:11;HotKey:'T'    ;Help:'Arcus tangens'),
        (x:FuncX+140;y:FuncY;     Text:'1/x';   Color:11;HotKey:'r'    ;Help:'Prevratena hodnota'),
        (x:FuncX+140;y:FuncY+35;  Text:'x%';    Color:11;HotKey:'%'    ;Help:'Pocet percent'),
        (x:FuncX+140;y:FuncY+70;  Text:'x!';    Color:11;HotKey:'!'    ;Help:'Faktorial'),
        (x:FuncX+140;y:FuncY+105; Text:#227;    Color:11;HotKey:''     ;Help:'Pi'),
        (x:FuncX+140;y:FuncY+140; Text:'+/-';   Color:1; HotKey:''     ;Help:'Prepinac kladne / zaporne'),
        (x:FuncX+140;y:FuncY+175; Text:'EEX';   Color:1; HotKey:''     ;Help:'Zadavanie exponentu'),
        (x:FuncX+210;y:FuncY;     Text:'ln';    Color:1; HotKey:'n'    ;Help:'Prirodzeny logaritmus'),
        (x:FuncX+210;y:FuncY+35;  Text:'log';   Color:1; HotKey:'g'    ;Help:'Desiatkovy logaritmus'),
        (x:FuncX+210;y:FuncY+70;  Text:'[(';    Color:11;HotKey:'('    ;Help:'Otvarajuca zatvorka'),
        (x:FuncX+210;y:FuncY+105; Text:')]';    Color:11;HotKey:')'    ;Help:'Zatvarajuca zatvorka'),
        (x:MemX;     y:MemY;      Text:'X'#26'M';Color:11;HotKey:''    ;Help:'Vloz cislo do pamate'),
        (x:MemX+50;  y:MemY;      Text:'MC';    Color:11;HotKey:''     ;Help:'Zmaz pamat'),
        (x:MemX+100; y:MemY;      Text:'MR';    Color:11;HotKey:'m'    ;Help:'Zobraz pamat'),
        (x:MemX+150; y:MemY;      Text:'X'#29'M';Color:11;HotKey:''    ;Help:'Vymen cislo s pamatou'),
        (x:MemX+200; y:MemY;      Text:'M+';    Color:11;HotKey:''     ;Help:'Pripocitaj cislo k pamati'),
        (x:MemX;     y:MemY+40;   Text:'C';     Color:15;HotKey:'Esc'  ;Help:'Zmaz vsetko'),
        (x:MemX+50;  y:MemY+40;   Text:'CE';    Color:15;HotKey:''     ;Help:'Zmaz aktualne cislo'),
        (x:MemX+100; y:MemY+40;   Text:#27;     Color:15;HotKey:'BkSp' ;Help:'Zmaz aktualnu cislicu'),
        (x:MemX;     y:MemY+80;  Text:'Quit';  Color:14;Hotkey:'Q'    ;Help:'Koniec programu'));
      OOP:array[1..PocetOOP] of TOOP=(
        (x:0;         y:0;            dx:130;dy:30; Aktivny:OVSADE;   Help:'Kalkulacka'),
        (x:131;       y:0;            dx:80; dy:30; Aktivny:OVSADE;   Help:'Rozne vypocty'),
        (x:211;       y:0;            dx:80; dy:30; Aktivny:OVSADE;   Help:'Analyza priebehu funkcie'),
        (x:GrafSX;    y:GrafSY;       dx:300;dy:20; Aktivny:OGRAFY;   Help:'Zmena XMin'),
        (x:GrafSX;    y:GrafSY+30;    dx:300;dy:20; Aktivny:OGRAFY;   Help:'Zmena XMax'),
        (x:GrafSX;    y:GrafSY+60;    dx:300;dy:20; Aktivny:OGRAFY;   Help:'Zmena YMin'),
        (x:GrafSX;    y:GrafSY+90;    dx:300;dy:20; Aktivny:OGRAFY;   Help:'Zmena YMax'),
        (x:DGrafX;    y:DGrafY;       dx:42; dy:20; Aktivny:OGRAFY;   Help:'Priblizenie grafu'),
        (x:DGrafX+50; y:DGrafY;       dx:42; dy:20; Aktivny:OGRAFY;   Help:'Oddialenie grafu'),
        (x:DisplayX;  y:DisplayY+220; dx:600;dy:16; Aktivny:OGRAFY;   Help:'Zadavanie funkcie'),
        (x:GrafSX+100;y:GrafSY+120;   dx:42; dy:20; Aktivny:OGRAFY;   Help:'Posun hore'),
        (x:GrafSX+50; y:GrafSY+160;   dx:42; dy:20; Aktivny:OGRAFY;   Help:'Posun vlavo'),
        (x:GrafSX+100;y:GrafSY+160;   dx:42; dy:20; Aktivny:OGRAFY;   Help:'Posun dole'),
        (x:GrafSX+150;y:GrafSY+160;   dx:42; dy:20; Aktivny:OGRAFY;   Help:'Posun vpravo'));

var x,sx,sy,c1,Err,PomW,OsX,OsY:word;
    ch:char;                 {klavesnica}
    PPlocha:ObsahObrazovky;
    SPomCislo,PomExpo:string;
    Aktual,OOPAktual,KlavAktual,Stary,OOPStary:word;
    Tlacidla:byte;
    Cislo:array[1..3] of extended;{spracuvane cisla,3. je Memo}
    SCislo:array[1..3] of string;{aj v retazcovej podobe}
    Expo:array[1..3] of string[3];{exponenty}
    ZaCiarku:boolean;        {ci zadavame cislicu za alebo pred des. ciarku}
    Stlacene:boolean;        {ci ma byt zobrazovane tlacidlo stlacene}
    Ktore:word;              {ci pracujeme s prvym alebo druhym operandom}
    Operacia:word;           {ktora operacia sa bude vykonavat s cislami}
    Chyba:boolean;           {ci nastala chyba vypoctu}
    PomCislo:extended;
    Cas:real;                {stary cas}
    Zapnuty:boolean;         {stav kurzora pri zadavani dat}
    XMin,XMax,YMin,YMax,XRel,YRel:Single;{pre grafy}
    Func:string;             {funkcia}
    FuncPtr:NodePtr;         {funkcia v dynamickej premennej}
    JeDefinovana:boolean;    {ci je funkcia v danom bode definovana}
    Hodnoty:array[1..299] of single;{hodnoty funkcie v danych bodoch}
    VGrafe:array[1..299] of word;   {suradnice funkcie priamo v grafe}
    LValue:Single;
    PomX:single;             {docasne skladiste pre premennu funkcie}
{ ----- vypis ----- }
procedure VypisCislo(PSCislo:string);
var Posun:integer;
begin
  Posun:=10;
  if PSCislo='' then PSCislo:='0';           {nie je tam nic}
  PomW:=Pos('.',PSCislo);                    {ak tam nie je des. ciarka,}
  if PomW=0 then PSCislo:=PSCislo+'.';       {daj ju na koniec}
  SetFillStyle(SolidFill,0);                 {vycisti fleka}
  Bar(WinDispX1+1,WinDispY1+1,WinDispX2-1,WinDispY2-11);
  SetColor(LightRed);
  SetTextStyle(SansSerifFont,HorizDir,4);
  OutTextXY(WinDispX2+Posun-22*Length(PSCislo),WinDispY1+10,PSCislo);
  SetTextStyle(DefaultFont,HorizDir,1);      {vypis a vrat styl pisma}
end;
{ ----- totalny vymaz kalkulacky ----- }
procedure VymazKalkulacku;
begin
  Cislo[1]:=0;Cislo[2]:=0;
  SCislo[1]:='';SCislo[2]:='';
  Expo[1]:='';Expo[2]:='';
  ZaCiarku:=False;Chyba:=False;
  Operacia:=0;Ktore:=1;
  VypisCislo(SCislo[1]);
end;
{ ----- kreslenie odmocniny ----- }
procedure VykresliOdmocninu(e,mantisa:char;PX,PY:word);
begin
  if Stlacene then begin
    PX:=PX+3;
    PY:=PY+3;
  end;
  SetColor(LightRed);
  if e<>'2' then begin
    OutTextXY(PX-1,PY-3,e);
    Line(PX,PY+6,PX+6,PY+6);
    Line(PX+6,PY+6,PX+8,PY+10);
    Line(PX+8,PY+10,PX+11,PY);
  end else begin
    Line(PX+4,PY+2,PX+8,PY+10);
    Line(PX+8,PY+10,PX+11,PY);
  end;
  OutTextXY(PX+13,PY+2,mantisa);
  Line(PX+11,PY,PX+20,PY);
end;
{ ----- kreslenie tlacidla ----- }
procedure VykresliTlacidlo(PX,PY:word;Ps:string;Color:byte);
var PPom,Predel:word;
    PPs:string;
begin
  SetFillStyle(SolidFill,0);
  Bar(PX-2,PY,PX+43,PY+22);
  if Stlacene then begin
    SetFillStyle(SolidFill,Color);
    Bar(PX+1,PY+3,PX+43,PY+22);
  end else begin
    SetFillStyle(SolidFill,7);
    Bar(PX+1,PY+3,PX+43,PY+22);
    SetFillStyle(SolidFill,Color);
    Bar(PX-2,PY,PX+40,PY+19);
  end;
  SetColor(12);
  PPs:='';
  Predel:=Pos('|',Ps);
  if Predel>0 then begin
    PPs:=Copy(Ps,Predel+1,3);
    Delete(Ps,Predel,3);
  end;
  PPom:=PX+20-4*Length(Ps)-4*Length(PPs);
  if Stlacene then begin
    PY:=PY+3;
    PPom:=PPom+3;
  end;
  OutTextXY(PPom,PY+8,Ps);
  if Predel<>0 then OutTextXY(PPom+8*Length(Ps),PY+4,PPs);
  if Aktual=21 then VykresliOdmocninu('2','x',FuncX+10,FuncY+145);
  if Aktual=22 then VykresliOdmocninu('y','x',FuncX+10,FuncY+180);

end;
{ ----- chybove hlasenie ----- }
procedure Error;
begin
  Chyba:=true;
  VypisCislo('Error');
end;
{ ----- inicializacia ----- }
procedure Inicializuj;
begin
{ ----- pociatocne hodnoty premennych ----- }
  Cislo[1]:=0;Cislo[2]:=0;Cislo[3]:=0;
  ZaCiarku:=False;Stlacene:=False;Chyba:=False;
  SCislo[1]:='';SCislo[2]:='';SCislo[3]:='';
  Ktore:=1;Operacia:=0;PPlocha:=OKALKUL;
{ ----- obrazovka ----- }
  VypniKurzorMysi;
  ClearDevice;
  SetColor(7);
  Line(0,467,639,467);
  for c1:=1 to PocetTlacidiel do VykresliTlacidlo(Obrazovka[c1].x,Obrazovka[c1].y,Obrazovka[c1].Text,Obrazovka[c1].Color);
  VykresliOdmocninu('2','x',FuncX+10,FuncY+145);
  VykresliOdmocninu('y','x',FuncX+10,FuncY+180);
  SetColor(15);
  SetColor(LightBlue);
  Rectangle(WinDispX1,WinDispY1,WinDispX2,WinDispY2);
  SetColor(LightRed);
  SetTextStyle(TriplexFont,HorizDir,2);
  SetColor(10);
  OutTextXY(0,0,' Kalkulacka  Vzorce  Grafy');
  SetColor(white);
  Rectangle(0,0,130,30);
  SetTextStyle(DefaultFont,HorizDir,1);
  SetColor(7);
  VypisCislo(SCislo[1]);
  ZapniKurzorMysi;
end;
{ ----- vypocet ----- }
procedure Vypocitaj;
begin
  case Operacia of
    13:Cislo[1]:=Cislo[1]+Cislo[2];          {plus}
    14:Cislo[1]:=Cislo[1]-Cislo[2];          {minus}
    15:Cislo[1]:=Cislo[1]*Cislo[2];          {krat}
    16:if Cislo[2]=0 then Error              {deleno}
       else Cislo[1]:=Cislo[1]/Cislo[2];
    17:if Cislo[1]<=0 then Error             {y na xtu}
       else Cislo[1]:=Exp(Cislo[2]*Ln(Cislo[1]));
    18:Cislo[1]:=Exp(Cislo[1]*Ln(10));       {10 na x}
    19:Cislo[1]:=Exp(Cislo[1]);              {e na x}
    20:Cislo[1]:=Cislo[1]*Cislo[1];          {x na druhu}
    21:if Cislo[1]<0 then Error              {odmocnina}
       else Cislo[1]:=Sqrt(Cislo[1]);
    22:if (Cislo[1]=0) or (Cislo[2]<=0) then Error{y-ta odmocnina}
       else Cislo[1]:=Exp(Ln(Cislo[2])/Cislo[1]);
    23:Cislo[1]:=Sin(Cislo[1]);              {sin}
    24:Cislo[1]:=Cos(Cislo[1]);              {cos}
    25:if Cos(Cislo[1])=0 then Error         {tan}
       else Cislo[1]:=Sin(Cislo[1])/Cos(Cislo[1]);
    26:if Abs(Cislo[1])>1 then Error         {arcsin}
       else begin
         if Cislo[1]=1 then Cislo[1]:=1.5707963;
         if Cislo[1]=-1 then Cislo[1]:=-1.5707963;
         if Abs(Cislo[1])<1 then Cislo[1]:=ArcTan(Cislo[1]/Sqrt(1-Sqr(Cislo[1])));
       end;
    27:if Abs(Cislo[1])>1 then Error         {arccos}
       else begin
         if Cislo[1]=0 then Cislo[1]:=1.5707963
         else Cislo[1]:=ArcTan(Sqrt(1-Sqr(Cislo[1]))/Cislo[1]);
       end;
    28:Cislo[1]:=ArcTan(Cislo[1]);           {arctan}
    29:if Cislo[1]=0 then Error              {1/x}
       else Cislo[1]:=1/Cislo[1];
    31:if ZaCiarku or (Cislo[1]<0) or (Cislo[1]>33) then Error
       else begin                            {x!}
         PomW:=Trunc(Cislo[1]);
         Cislo[1]:=1;
         for x:=1 to PomW do Cislo[1]:=Cislo[1]*x;
       end;
    35:if Cislo[1]<=0 then Error             {ln}
       else Cislo[1]:=Ln(Cislo[1]);
    36:if Cislo[1]<=0 then Error             {log}
       else Cislo[1]:=Ln(Cislo[1])/Ln(10);
    39:begin                                 {x do M}
      Cislo[3]:=Cislo[1];
      SCislo[3]:=SCislo[1];
      Expo[3]:=Expo[1];
    end;
    41:begin                                 {MR}
      Cislo[1]:=Cislo[3];
      SCislo[1]:=SCislo[3];
      Expo[1]:=Expo[3];
    end;
    42:begin                                 {x vymen s M}
      SPomCislo:=SCislo[1];
      SCislo[1]:=SCislo[3];
      SCislo[3]:=SPomCislo;
      PomCislo:=Cislo[1];
      Cislo[1]:=Cislo[3];
      Cislo[3]:=PomCislo;
      PomExpo:=Expo[1];
      Expo[1]:=Expo[3];
      Expo[3]:=PomExpo;
    end;
    43:begin                                 {M+}
      Cislo[3]:=Cislo[3]+Cislo[1];
      Str(Cislo[3]:10:8,SCislo[3]);
    end;
  end;
  if not Chyba then begin
    Operacia:=0;
    Ktore:=1;
    Str(Cislo[1],SCislo[1]);
    ZaCiarku:=False;
    PomW:=Pos('.',SCislo[1]);                {zisti, ci vysledok je des. cislo}
    for x:=PomW+1 to Length(SCislo[1]) do
      if SCislo[1,x]<>'0' then ZaCiarku:=True;
    if not ZaCiarku then Delete(SCislo[1],PomW,Length(SCislo[1])-PomW+1);
    VypisCislo(SCislo[1]);
    SCislo[2]:='';
    if Cislo[3]=0 then begin
      SetColor(0);
      OutTextXY(WinDispX1+30,WinDispY2-10,'Memo');
      SetColor(LightRed);
    end else begin
      SetColor(LightGreen);
      OutTextXY(WinDispX1+30,WinDispY2-10,'Memo');
      SetColor(LightRed);
    end;
  end;
end;
{ ----- obsluha klavesnice a mysi ----- }
procedure ObsluzUdalost;
begin
  Stary:=0;OOPStary:=0;
  repeat
{ ----- mys ----- }
    ZistiPoziciu(sx,sy,Tlacidla);
    Aktual:=0;OOPAktual:=0;
    for c1:=1 to PocetTlacidiel do        {ci bolo kliknute na niektore tlacidlo}
      with Obrazovka[c1] do
        if (sx>x) and (sx<x+40) and (sy>y) and (sy<y+19) then Aktual:=c1;
    for c1:=1 to PocetOOP do              {ci bolo kliknute na iny ovladaci prvok}
      with OOP[c1] do
        if (sx>x) and (sy>y) and (sx<x+dx) and (sy<y+dy)
        and ((PPlocha=Aktivny) or (Aktivny=OVSADE)) then OOPAktual:=c1;
    if (Aktual<>Stary) or (OOPAktual<>OOPStary) then begin
      SetFillStyle(SolidFill,0);          {vypis help, ak sa mys presunula}
      Bar(0,471,639,479);                 {nad nove tlacidlo}
      SetColor(15);
      if aktual<>0 then
        with Obrazovka[Aktual] do begin
          OutTextXY(0,471,Help);
          if HotKey<>'' then OutTextXY(320,471,'Kl vesnica: '+HotKey);
          OOPStary:=0;OOPAktual:=0;
        end;
      if OOPAktual<>0 then begin
        OutTextXY(0,471,OOP[OOPAktual].Help);
        Aktual:=0;Stary:=0;
      end;
    end;
    Stary:=Aktual;
    OOPStary:=OOPAktual;
{ ----- klavesnica ----- }
    ch:=#0;KlavAktual:=0;
    if keypressed then ch:=ReadKey;       {nacitaj}
    if ch<>#0 then KlavAktual:=Pos(ch,Klavesnica); {vyhladaj v zozname klaves}
    if KlavAktual<>0 then Aktual:=KlavAktual;
  until (((Tlacidla>0) or (KlavAktual>0)) and (Aktual>0)) or
        ((OOPAktual>0) and (Tlacidla>0));
  if OOPAktual=0 then begin                    {bolo pouzite tlacidlo}
    Stlacene:=True;                         {nastav priznak, ze je stlacene}
    with Obrazovka[Aktual] do begin
      VypniKurzorMysi;
      VykresliTlacidlo(x,y,Text,Color);     {vykresli stlacene tlacidlo}
      ZapniKurzorMysi;
      Sound(1000);                          {pip}
      repeat ZistiPoziciu(sx,sy,Tlacidla); until Tlacidla=0;{cakaj na pustenie}
      if KlavAktual<>0 then Delay(50);      {alebo chvilku cakaj}
      NoSound;
      Stlacene:=false;
      VypniKurzorMysi;
      VykresliTlacidlo(x,y,Text,Color);      {vykresli obycajne tlacidlo}
      ZapniKurzorMysi;
    end;
  end else begin                             {bol pouzity iny ovladaci prvok}
    case OOPAktual of
      1:begin
        PPlocha:=OKALKUL;
        Inicializuj;
      end;
      3:begin
        PPlocha:=OGRAFY;
        PriebehFunkcie;
      end;
    end;
  end;
  if not Chyba then
    case Aktual of
      1..10:begin                         {cislice}
        if Length(SCislo[Ktore])<22 then SCislo[Ktore]:=SCislo[Ktore]+Chr(48+Aktual mod 10);
        VypisCislo(SCislo[Ktore]);
      end;
      11:if not ZaCiarku then begin       {des. ciarka}
        ZaCiarku:=True;
        SCislo[Ktore]:=SCislo[Ktore]+'.';
      end;
      12:begin                            {rovna sa}
        Val(SCislo[1],Cislo[1],Err);
        if SCislo[1]='' then Cislo[1]:=0;
        Val(SCislo[2],Cislo[2],Err);
        if SCislo[2]='' then Cislo[2]:=0;
        Vypocitaj;
      end;
      13..17,22:begin                     {+,-,*,/,y na x,y-ta odm.}
        if Operacia>0 then begin
          Val(SCislo[1],Cislo[1],Err);
          if SCislo[1]='' then Cislo[1]:=0;
          Val(SCislo[2],Cislo[2],Err);
          if SCislo[2]='' then Cislo[2]:=0;
          Vypocitaj;
        end;
        Operacia:=Aktual;
        Ktore:=2;
        ZaCiarku:=false;
      end;
      18..21,23..29,31,35,36,39,41,42,43:begin{unarne operacie}
        Operacia:=Aktual;
        Val(SCislo[1],Cislo[1],Err);
        if SCislo[1]='' then Cislo[1]:=0;
        Vypocitaj;
      end;
      32:begin
        Cislo[Ktore]:=Pi;                      {pi}
        Str(Pi,SCislo[Ktore]);
        Expo[Ktore]:='';
        ZaCiarku:=True;
        VypisCislo(SCislo[Ktore]);
      end;
      33:begin
        Cislo[Ktore]:=-Cislo[Ktore];          {+/-}
        if SCislo[Ktore,1]='-' then Delete(SCislo[Ktore],1,1)
        else Insert('-',SCislo[Ktore],1);
        VypisCislo(SCislo[Ktore]);
      end;
      40:begin                                 {MC}
        Cislo[3]:=0;
        SCislo[3]:='';
        Expo[3]:='';
        SetColor(0);
        OutTextXY(WinDispX1+30,WinDispY2-10,'Memo');
        SetColor(LightRed);
      end;
      44:VymazKalkulacku;                      {C}
      45:begin                                 {CE}
        Cislo[Ktore]:=0;
        SCislo[Ktore]:='';
        Expo[Ktore]:='';
        ZaCiarku:=False;
        VypisCislo(SCislo[Ktore]);
      end;
      46:if SCislo[Ktore]<>'' then begin       {zmaz cislicu}
        PomW:=Length(SCislo[Ktore]);
        if SCislo[Ktore,PomW-1]='.' then begin
          ZaCiarku:=False;
          Delete(SCislo[Ktore],PomW,1);
          Dec(PomW);
        end;
        Delete(SCislo[Ktore],PomW,1);
        VypisCislo(SCislo[Ktore]);
      end;
    end
  else if Aktual=44 then VymazKalkulacku;   {ak je chyba, povol iba C}
end;



{ ----- funkcie a procedury pre GRAFY ----- }


{ ----- prevedie cislo na retazec a upravi ho ----- }
function SpracujCislo(Vstup:real):string;
var Ps:string;
    PW,PW2:word;
begin
  Str(Vstup:10:8,Ps);
  if Pos('.',Ps)>0 then begin
    PW2:=Length(Ps);
    while Ps[PW2]='0' do begin
      Delete(Ps,PW2,1);
      Dec(PW2);
    end;
    if PS[Length(Ps)]='.' then Delete(PS,Length(Ps),1);
  end;
  SpracujCislo:=Ps;
end;
{ ----- blikanie kurzora ----- }
procedure Kurzor(PKx,PKy,PDy:word);
var hod,min,sec,stot:word;
    CasN:real;
begin
  GetTime(hod,min,sec,stot);
  CasN:=hod*3600.0+min*60.0+sec+stot/100;
  if Abs(Cas-CasN) > 0.2 then begin
    Cas:=CasN;
    Zapnuty:=not Zapnuty;
    if Zapnuty then SetColor(LightRed)
    else SetColor(Black);
    Line(PKx,PKy,PKx,PKy+PDy);
    Line(PKx+1,PKy,PKx+1,PKy+PDy);
  end;
end;
{ ----- nacitanie retazca v grafickom rezime ----- }
procedure NacitajRiadok(Px,Py,Dx,Dy,Color,Posun:word;var Ps:string);
var Kx:word;
begin
  VypniKurzorMysi;
  SetFillStyle(SolidFill,0);
  Bar(Px,Py+1,Px+Dx-3,Py+Dy-1);
  ZapniKurzorMysi;
  Kx:=PX+2;
  Ps:='';
  repeat
    repeat
      Kurzor(Kx,PY+2,DY-1);
    until Keypressed;
    ch:=ReadKey;
    if (Kx<Px+Dx-10) and (ch<>#8) then begin
      if ch<>#13 then Ps:=Ps+ch;
      VypniKurzorMysi;
      Cas:=0;Zapnuty:=True;
      Kurzor(Kx,PY+2,DY-1);
      SetColor(Color);
      OutTextXY(Kx,Py+3,ch);
      ZapniKurzorMysi;
      Kx:=Kx+Posun;
    end;
    if ch=#8 then begin
      VypniKurzorMysi;
      Cas:=0;Zapnuty:=True;
      Kurzor(Kx,PY+2,DY-1);
      Delete(Ps,Length(Ps),1);
      SetFillStyle(SolidFill,Black);
      Bar(Px,Py+1,Px+Dx-3,Py+Dy-1);
      SetColor(Color);
      for x:=1 to Length(Ps) do OutTextXY(Px+2-Posun+Posun*x,Py+3,Ps[x]);
      ZapniKurzorMysi;
      Kx:=Kx-Posun;
    end;
  until ch=#13;
  Cas:=0;Zapnuty:=True;
  Kurzor(Kx,PY+1,DY-2);
end;
{ ----- vytvorenie aritmetickeho vyrazu z retazca ----- }
function VytvorVyraz(Vyraz:string):NodePtr;
var Zatvorky    : Integer;
    i           : Integer;
    TatoBunka   : NodePtr;
begin
 Tatobunka:=NIL;
 Zatvorky:=0;
 for i:=1 to Length(Vyraz) do begin     { hlada + musi mat prednost pred - }
  if Vyraz[i]='(' then Inc(Zatvorky);
  if Vyraz[i]=')' then Dec(Zatvorky);
  if ((Zatvorky=0) and (Vyraz[i]='+')) then begin
   New(TatoBunka);
   TatoBunka^.Op:=PLUS;
   TatoBunka^.Value:=0;
   TatoBunka^.Left:=VytvorVyraz(copy(Vyraz,1,i-1));
   TatoBunka^.Right:=VytvorVyraz(copy(Vyraz,i+1,Length(Vyraz)-i));
   Break;
  end;
 end;
 if (TatoBunka=NIL) then begin
  for i:=1 to Length(Vyraz) do begin     { hlada - }
   if Vyraz[i]='(' then Inc(Zatvorky);
   if Vyraz[i]=')' then Dec(Zatvorky);
   if ((Zatvorky=0) and (Vyraz[i]='-')) then begin
    New(TatoBunka);
    TatoBunka^.Op:=MINUS;
    if (i-1)=0 then begin
     New(TatoBunka^.Left);
     TatoBunka^.Left^.Op:=NUMBER;
     TatoBunka^.Left^.Value:=0;
     TatoBunka^.Left^.Left:=NIL;
     TatoBunka^.Left^.Right:=NIL;
    end else begin
     TatoBunka^.Left:=VytvorVyraz(copy(Vyraz,1,i-1));
    end;
    TatoBunka^.Right:=VytvorVyraz(copy(Vyraz,i+1,Length(Vyraz)-i));
    Break;
   end;
  end;
 end;
 if (TatoBunka=NIL) then begin
  for i:=1 to Length(Vyraz) do begin     { hlada * alebo / }
   if Vyraz[i]='(' then Inc(Zatvorky);
   if Vyraz[i]=')' then Dec(Zatvorky);
   if (Zatvorky=0) then begin
    if (Vyraz[i]='*') or (Vyraz[i]='/') then begin
     New(TatoBunka);
     if (Vyraz[i]='*') then TatoBunka^.Op:=TIMES
                       else TatoBunka^.Op:=DIVIDE;
     TatoBunka^.Value:=0;
     TatoBunka^.Left:=VytvorVyraz(copy(Vyraz,1,i-1));
     TatoBunka^.Right:=VytvorVyraz(copy(Vyraz,i+1,Length(Vyraz)-i));
     Break;
    end;
   end;
  end;
 end;
 if (TatoBunka=NIL) then begin   { pozera, ci nebola velka zatvorka }
  if (Vyraz[1]='(') and (Vyraz[Length(Vyraz)]=')') then
   TatoBunka:=VytvorVyraz(copy(Vyraz,2,Length(Vyraz)-2));
 end;
 if (TatoBunka=NIL) then begin   { nemoze to byt operacia }
  { moze byt funkcia alebo cislo }
  if ((Vyraz[1]>='0') and (Vyraz[1]<='9')) or (Vyraz[1]='.') then begin { ma cislo }
   New(TatoBunka);
   Tatobunka^.Op:=NUMBER;
   Val(Vyraz,TatoBunka^.Value,i);
   TatoBunka^.Left:=NIL;
   TatoBunka^.Right:=NIL;
  end else begin      { ma funckiu alebo premennu}
    New(TatoBunka);
    TatoBunka^.Left:=NIL;
    case Vyraz[1] of
     'S':begin { 'SIN'  alebo 'SQRT' }
        TatoBunka^.Value:=0;
        if Vyraz[2]='I' then begin { SIN }
           Tatobunka^.Op:=SINFUNC;
           TatoBunka^.Right:=VytvorVyraz(copy(Vyraz,5,Length(Vyraz)-5));
          end else begin  { SQRT }
           Tatobunka^.Op:=SQRTFUNC;
           TatoBunka^.Right:=VytvorVyraz(copy(Vyraz,6,Length(Vyraz)-6));
          end;
         end;
     'C':begin { 'COS' }
          TatoBunka^.Value:=0;
          Tatobunka^.Op:=COSFUNC;
          TatoBunka^.Right:=VytvorVyraz(copy(Vyraz,5,Length(Vyraz)-5));
         end;
     'E':begin { 'EXP' }
          TatoBunka^.Value:=0;
          Tatobunka^.Op:=EXPFUNC;
          TatoBunka^.Right:=VytvorVyraz(copy(Vyraz,5,Length(Vyraz)-5));
         end;
     'L':begin { 'LN' }
          TatoBunka^.Value:=0;
          Tatobunka^.Op:=LNFUNC;
          TatoBunka^.Right:=VytvorVyraz(copy(Vyraz,4,Length(Vyraz)-4));
         end;
     'A':begin { 'ABS' alebo 'ARCTAN'}
          TatoBunka^.Value:=0;
          if Vyraz[2]='B' then begin
           Tatobunka^.Op:=ABSFUNC;
           TatoBunka^.Right:=VytvorVyraz(copy(Vyraz,5,Length(Vyraz)-5));
          end else begin
           Tatobunka^.Op:=ARCTANFUNC;
           TatoBunka^.Right:=VytvorVyraz(copy(Vyraz,8,Length(Vyraz)-8));
          end;
         end;
     'X':begin { premenna}
          TatoBunka^.Value:=0;
          TatoBunka^.Op:=VARIABLE;
          TatoBunka^.Right:=nil;
         end;
    else begin
     Tatobunka^.Op:=UNKNOWN;
     TatoBunka^.Value:=0;
     TatoBunka^.Right:=NIL;
    end;
   end;
  end;
 end;
 VytvorVyraz:=TatoBunka;
end;
{ ----- vypocet hodnoty aritmetickeho vyrazu ----- }
function LuboRataj(LPZac:NodePtr):single;
begin
  with LPZac^ do begin
    case Op of
      NUMBER:LuboRataj:=Value;
      VARIABLE:LuboRataj:=PomX;
      PLUS:LuboRataj:=LuboRataj(Left)+LuboRataj(Right);
      MINUS:LuboRataj:=LuboRataj(Left)-LuboRataj(Right);
      TIMES:LuboRataj:=LuboRataj(Left)*LuboRataj(Right);
      DIVIDE:begin
        LValue:=LuboRataj(Right);
        if LValue<>0 then LuboRataj:=LuboRataj(Left)/LuboRataj(Right)
        else JeDefinovana:=False;
      end;
      SINFUNC:LuboRataj:=Sin(LuboRataj(Right));
      COSFUNC:LuboRataj:=Cos(LuboRataj(Right));
      EXPFUNC:LuboRataj:=Exp(LuboRataj(Right));
      ARCTANFUNC:LuboRataj:=ArcTan(LuboRataj(Right));
      LNFUNC:begin
        LValue:=LuboRataj(Right);
        if LValue>0 then LuboRataj:=Ln(LValue)
        else JeDefinovana:=False;
      end;
      SQRTFUNC:begin
        LValue:=LuboRataj(Right);
        if LValue>=0 then LuboRataj:=Sqrt(LValue)
        else JeDefinovana:=False;
      end;
      ABSFUNC:LuboRataj:=Abs(LuboRataj(Right));
    end;
  end;
end;
