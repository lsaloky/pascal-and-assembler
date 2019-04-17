program Blok_Estos;
uses MukoGr,Crt;
const FontPath='d:\lubo\pascal\units\Classic.mf';
      AnimPath='d:\lubo\pascal\editory\blokesto.ma';
      BitMapPath='d:\lubo\pascal\editory\blokesto.mb';
      DlzOkrBuf=130;{dlzka buffra pre okraje}
      Rychlost=2;{pocet riadkov generovanych za 1 snimku}
      PocetPriser=4;
      PocetBitmap=1;
      Vynechat=4;{spomalenie animacie priser vzhladom na pozadie}
var p:pointer;
    PomW,ShVRam:word;{segment tienovej RAM}
    x,y:integer;
    Pouzite,AktRiadok:integer;
    Lavy,Pravy:array[1..DlzOkrBuf] of integer;{okraje - predvypoc¡tan‚}
    Anim:array[0..16*16*16*PocetPriser-1]of byte;       {priserky}
    BMP:array[0..32*32*PocetBitmap-1]of byte;
    f:file;
    ATab:array[0..255] of record{tabulka animacii}
      PosX,PosY,Index,PosunX,PosunY,AktSnim,PocVynechSnim:integer;
      Bezi:boolean;
    end;
    OL,OP:array[0..199] of word;{okraje - skutocn‚}
{ ----- generovanie okrajov ----- }
procedure NaplnOkrajovyBuffer;
var z,zLast,zAktual:word;
begin
  Lavy[1]:=Lavy[DlzOkrBuf];
  Pravy[1]:=Pravy[DlzOkrBuf];
  zLast:=1;
  repeat
    zAktual:=Random(20)+zLast+3;
    if zAktual>DlzOkrBuf then zAktual:=DlzOkrBuf;
    Lavy[zAktual]:=Random(140)+2;
    for z:=zLast+1 to zAktual-1 do
      Lavy[z]:=Lavy[zLast]-((Lavy[zLast]-Lavy[zAktual])*(z-zLast)) div (zAktual-zLast);
    zLast:=zAktual;
  until zAktual>=DlzOkrBuf;
  zLast:=1;
  repeat
    zAktual:=Random(10)+zLast+3;
    if zAktual>DlzOkrBuf then zAktual:=DlzOkrBuf;
    Pravy[zAktual]:=Random(140)+175;
    for z:=zLast+1 to zAktual-1 do
      Pravy[z]:=Pravy[zLast]-((Pravy[zLast]-Pravy[zAktual])*(z-zLast)) div (zAktual-zLast);
    zLast:=zAktual;
  until zAktual>=DlzOkrBuf;
  for z:=4 to DlzOkrBuf-3 do begin
    Lavy[z]:=(Lavy[z-3]+Lavy[z-2]+Lavy[z-1]+Lavy[z]+Lavy[z+1]+Lavy[z+2]+Lavy[z+3]) div 7;
    Pravy[z]:=(Pravy[z-3]+Pravy[z-2]+Pravy[z-1]+Pravy[z]+Pravy[z+1]+Pravy[z+2]+Pravy[z+3]) div 7;
  end;
end;
procedure VykresliPozadie(OdRiadku:integer);assembler;
asm
             cld
             mov ax,VSeg
             mov es,ax
             mov PomW,200
             mov bx,OdRiadku
             add PomW,bx
             sub PomW,32
             shl bx,5
             xor di,di
             mov ax,OdRiadku
             sub ax,32

@DalsiRiadok:mov dx,10{pocitadlo v riadku}
@DalsiaDavka:lea si,BMP
             add si,bx
             mov cx,16
         rep movsw
             dec dx
             jnz @DalsiaDavka
             add bx,32
             inc ax
             cmp ax,PomW
             je @Koniec
             cmp bx,32*32
             jb @DalsiRiadok
             xor bx,bx
             jmp @DalsiRiadok
@Koniec:
end;

BEGIN
{ ----- inicializacia ----- }
  Randomize;
  InicializujGrafiku;
  NacitajFontAPaletu(FontPath);
  Assign(f,AnimPath);
  Reset(f,1);
  Seek(f,772);
  for x:=0 to PocetPriser-1 do begin
    BlockRead(f,Anim[x*4096],4096);
    Seek(f,FilePos(f)+3);
  end;
  Close(f);
  Assign(f,BitmapPath);
  Reset(f,1);
  Seek(f,770);
  for x:=0 to PocetBitmap-1 do begin
    BlockRead(f,BMP[x*1024],1024);
    Seek(f,FilePos(f)+2);
  end;
  Close(f);
  for x:=0 to 255 do ATab[x].Bezi:=False;
{ !!!!! }
  for x:=0 to 45 do
    with ATab[x] do begin
      PosX:=Random(320);PosY:=Random(200);
      PosunX:=Random(7);PosunY:=Random(5);
      PosunX:=PosunX-3;PosunY:=PosunY-4;
      AktSnim:=Random(16);Bezi:=True;
      Index:=Random(PocetPriser);PocVynechSnim:=3;
    end;
{ !!!!! koniec }
  GetMem(p,64016);
  ShVRam:=Seg(p^)+1;
  Pouzite:=1;Lavy[DlzOkrBuf]:=30;Pravy[DlzOkrBuf]:=290;
  NaplnOkrajovyBuffer;
  VykresliPozadie(0);
  for y:=199 downto 0 do begin
    if Pouzite=DlzOkrBuf+1 then begin
      Pouzite:=1;
      NaplnOkrajovyBuffer;
    end;
    OL[y]:=Lavy[Pouzite];
    OP[y]:=Pravy[Pouzite];
    Nastav(OL[y],y,103);
    CiaraVodorovna(OP[y]-OL[y]);
    Inc(Pouzite);
  end;
{ ----- HLAVNY CYKLUS ----- }
  VSeg:=ShVRam;
  AktRiadok:=0;
  repeat
{ ----- kreslenie okrajov, bude sa dat zrychlit ----- }
    VykresliPozadie(AktRiadok);
    if AktRiadok<=0 then AktRiadok:=32;
    AktRiadok:=AktRiadok-Rychlost;
{ ----- spracovanie okrajov ----- }
    for y:=199 downto Rychlost do begin
      OL[y]:=OL[y-Rychlost];
      OP[y]:=OP[y-Rychlost];
    end;
    for y:=Rychlost-1 downto 0 do begin
      OL[y]:=Lavy[Pouzite];
      OP[y]:=Pravy[Pouzite];
      Inc(Pouzite);
      if Pouzite=DlzOkrBuf+1 then begin
        Pouzite:=1;
        NaplnOkrajovyBuffer;
      end;
    end;
    for y:=0 to 199 do begin
      Nastav(OL[y],y,103);
      CiaraVodorovna(OP[y]-OL[y]);
    end;
{ ----- kreslenie priser ----- }
    for x:=0 to 255 do
      with ATab[x] do
        if Bezi then begin
           Inc(PocVynechSnim);
            Nastav(PosX,PosY,0);
            PrilepPriehladnuBitmapu(16,16,Ofs(Anim)+Index*4096+AktSnim*256);
            if PocVynechSnim>=Vynechat then begin
              Inc(AktSnim);
              if AktSnim=16 then AktSnim:=0;
              PosX:=PosX+PosunX;
              PosY:=PosY+PosunY+Rychlost;
              PocVynechSnim:=0;
            end;
            if PosX<0 then PosunX:=Random(6);
            if PosX>320 then PosunX:=-Random(6);
            if PosY<0 then PosunY:=Random(6);
            if PosY>200 then PosunY:=-Rychlost-Random(4);
          end;
    CakajNaVOI;
    KopirujObrazovku(ShVRam,$A000);
  until keypressed;
{ ----- KONIEC PROGRAMU ----- }
  FreeMem(p,64016);
  ZavriGrafiku;
END.