uses MukoGr,Myska;
const FontPath='d:\lubo\pascal\units\Classic.mf';
      DataPath='d:\lubo\pascal\editory\';
      BojCenturii=1;DoGuti=2;Mlyncek=3;Mlyn=4;GoBang=5;MuTorere=6;Pyramida=7;ObranaPevnosti=8;
      Jarmo=9;Tablut=10;Pentomino=11;Pavucina=12;HasamiSogi=13;Putnici=14;Reverz=15;Dostihy=16;Sidza=17;
      AntilopyASakaly=18;KravyALeopardy=19;Astar=20;Samotar=21;LiskaAHusi=22;Alkerk=23;VelkaDama=24;
      RohovaDama=25;JednosmernaDama=26;Parasutisti=27;PanoramatickaDama=28;VlkAPsi=29;ChrtyALisky=30;
      GotickaDama=31;Princezne=32;MedovaDama=33;TureckaDama=34;SkupinovaDama=35;TrojuholnikovaDama=36;
      Halma=37;Salta=38;Zabka=39;Focus=40;MakarenkovSach=41;Lasker=42;Vari=43;MaharadzaASpahiovia=44;
      Dzungla=45;NaCvicisku=46;Had=47;Pocitac=48;TankovyBoj=49;Go=50;
      Pocet16x16=1;Pocet24x24=1;
      Farba:array[1..4] of byte=(16,144,32,48);

var NazovHry:array[1..50] of string[30];
    NaTahu1,NaTahu2:string[8];
    TlacStr:array[1..5] of string[8];
    Figurky16x16:array[1..Pocet16x16,0..255] of byte;
    Figurky24x24:array[1..Pocet24x24,0..575] of byte;
    Policka24x24:array[1..2,0..575] of byte;
    Sachovnica:array[1..20,1..10] of byte;
    Pohyb:array[0..1,-9..9,-9..9] of byte;
    Buffer:array[0..575] of byte;
    x,y,NovyX,NovyY:word;
    Hra,sx,sy,RozX,RozY,StaryX,StaryY,AktHrac,PocHrac,Udalost:integer;
    SmerX,SmerY:array[1..4] of shortint;
    PocetFigur:array[1..4] of word;
    Ofs24,OfsP24:word;
    Koniec,BolTah:boolean;
    Tlacidla,AktFarba,PomB:byte;

procedure Inicializuj;
var f:text;
    f2:file;
    px:word;
begin
  Assign(f,'Trum-sum.Txt');
  Reset(f);
  for px:=1 to 50 do Readln(f,NazovHry[px]);
  ReadLn(f,NaTahu1);
  ReadLn(f,NaTahu2);
  for px:=1 to 5 do Readln(f,TlacStr[px]);
  Close(f);
  Ofs24:=Ofs(Figurky24x24);OfsP24:=Ofs(Policka24x24);
  Assign(f2,DataPath+'Trum-sum.mb');
  Reset(f2,1);
  Seek(f2,771);
  BlockRead(f2,Figurky24x24,576);
  Seek(f2,FilePos(f2)+2);
  BlockRead(f2,Policka24x24,576);
  Seek(f2,FilePos(f2)+2);
  BlockRead(f2,Policka24x24[2,0],576);
  Close(f2);
  InicializujGrafiku;
  NacitajFontAPaletu(FontPath);
  Koniec:=False;
end;
procedure PrilepFigurku(Zdroj,Ciel:word;Farba:byte);assembler;
asm
             cld
             mov ax,0A000h
             mov es,ax
             mov si,Zdroj
             mov di,Ciel
             mov bx,RozY
@DalsiRiadok:mov cx,RozX
@DalsiBod:   lodsb
             cmp al,0
             je @Nekresli
             and al,0Fh
             add al,Farba
             mov byte[es:di],al
@Nekresli:   inc di
             loop @DalsiBod
             add di,320
             sub di,RozY
             dec bl
             jnz @DalsiRiadok
end;
