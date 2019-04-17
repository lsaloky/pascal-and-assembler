program Emulacia_styroch_kurzorov;
uses MukoGr,Myska;
const DatovySub='d:\lubo\pascal\editory\dama.mb';
      FontSub='d:\lubo\pascal\units\Prechod.mf';
      PocetKurz=8;
      Farby:array[1..PocetKurz] of byte=(0,1,2,3,4,5,6,7{,8,9,5,1,2,3,4});
var f:file;
    Ruka:array[0..255] of byte;
    Podklad:array[1..PocetKurz,0..255] of byte;
    Pozicia:array[1..PocetKurz,1..2] of integer;
    i,j,x,y:integer;
    Tlacidla:byte;
procedure VykresliKurzor(pPosX,pPosY:integer;pOdtien:byte);assembler;
asm
             cld
             mov es,VSeg
             mov cx,320
             mov ax,pPosY
             mul cx
             add ax,pPosX
             mov di,ax
             lea si,Ruka
             mov dl,pOdtien
             shl dl,4
             mov bx,16
@DalsiRiadok:mov cx,16
@DalsiBod:   lodsb
             cmp al,0
             je @Nekresli
             add al,dl
             mov byte[es:di],al
@Nekresli:   inc di
             loop @DalsiBod
             add di,304
             dec bx
             jnz @DalsiRiadok
end; {VykresliKurzor}
BEGIN
  Assign(f,DatovySub);
  Reset(f,1);
  Seek(f,771);
  BlockRead(f,Ruka,256);
  Close(f);
  InicializujGrafiku;
  NacitajFontAPaletu(FontSub);
  Nastav(20,20,39);VyplnPlochu(100,100);
  for i:=1 to PocetKurz do begin
    Pozicia[i,1]:=20*i;
    Pozicia[i,2]:=140;
    VykresliKurzor(Pozicia[i,1],Pozicia[i,2],Farby[i]);
  end; {for}
  i:=1;
  OknoKurzora(2,608,2,184);
  repeat
    NastavKurzor(Pozicia[i,1]*2,Pozicia[i,2]);
    repeat
      ZistiPoziciu(word(x),word(y),Tlacidla);
      x:=x div 2;
    until (x<>Pozicia[i,1]) or (y<>Pozicia[i,2]) or (Tlacidla>0);
    if Tlacidla>0 then CakajNaPustenie;
    CakajNaVOI;
{ ----- posun kurzora ----- }
    Nastav(Pozicia[i,1],Pozicia[i,2],0);
    PrilepBitmapu(16,16,Ofs(Podklad[i]));
    for j:=1 to PocetKurz do begin {zrus vsetky kurzory pred kopirovanim podkladu}
      Nastav(Pozicia[j,1],Pozicia[j,2],0);
      if j<>i then PrilepBitmapu(16,16,Ofs(Podklad[j]));
    end; {for}
    Nastav(x,y,0);
    StiahniBitmapu(16,16,Ofs(Podklad[i]));
    Pozicia[i,1]:=x;
    Pozicia[i,2]:=y;
    for j:=1 to PocetKurz do {obnov kurzory po kopirovani podkladu}
      VykresliKurzor(Pozicia[j,1],Pozicia[j,2],Farby[j]);
    VykresliKurzor(Pozicia[i,1],Pozicia[i,2],Farby[i]);
    if Tlacidla=Lave then begin{prepni na dalsi kurzor}
      Inc(i);
      if i=PocetKurz+1 then i:=1;
    end; {if}
  until Tlacidla=Prave;
END.


