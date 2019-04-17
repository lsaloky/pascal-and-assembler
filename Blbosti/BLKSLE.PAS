program BlokEstos_editor_terenu;
uses MukoGr,Myska,KeyBoard;
const BitMapPath='d:\lubo\pascal\editory\blokesto.mb';
      FontPath='d:\lubo\pascal\units\Classic.mf';
      OkrajeLock:array[0..3] of byte=(NumOn,NumOn+CapsOn,CapsOn+ScrollOn,ScrollOn);
      {lavy, lavy stredny, pravy stredny, pravy}
      DlzkaLevelu=2000;
var x,y,StaryX,StaryY,PomW,AktRiadok,AktOkraj:word;
    PomB,Tlacidla:byte;
    Okraje:array[0..4*DlzkaLevelu-1] of byte;{1 level}
    BMP:array[0..1023] of byte;
    f:file;
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
procedure VykresliObrazovku;
begin
  VypniKurzorMysi;
  VykresliPozadie(32-AktRiadok mod 32);
  for PomW:=0 to 199 do begin
    PomB:=Okraje[AktRiadok+200-PomW];
    if PomB>0 then PolozBod(PomB,PomW,15);
    PomB:=Okraje[DlzkaLevelu+AktRiadok+200-PomW];
    if PomB>0 then PolozBod(PomB,PomW,15);
    PomB:=Okraje[2*DlzkaLevelu+AktRiadok+200-PomW];
    if PomB>0 then PolozBod(64+PomB,PomW,15);
    PomB:=Okraje[3*DlzkaLevelu+AktRiadok+200-PomW];
    if PomB>0 then PolozBod(64+PomB,PomW,15);
  end;
  ZapniKurzorMysi;
end;
BEGIN
  AktRiadok:=0;AktOkraj:=0;
  Assign(f,BitmapPath);
  Reset(f,1);
  Seek(f,770);
  BlockRead(f,BMP[x*1024],1024);
  Seek(f,FilePos(f)+2);
  Close(f);
  InicializujGrafiku;
  NacitajFontAPaletu(FontPath);
  VykresliPozadie(0);
  ZapniKurzorMysi;
  NastavKurzor(0,179);
  Assign(f,'teren.dat');
  Reset(f,DlzkaLevelu*4);
  BlockRead(f,Okraje,1);
  Close(f);
  repeat
    repeat
      ZistiPoziciu(x,y,Tlacidla);
      x:=x div 2;
    until ((StaryX<>x) or (StaryY<>y) or (Tlacidla>0)) or (y=0) or (y=199);
    StaryX:=x;StaryY:=y;
    if (Tlacidla=Lave) and (x+y>0) then begin
      VypniKurzorMysi;
      PolozBod(x,y,15);
      PomW:=AktOkraj*DlzkaLevelu+AktRiadok+200-y;
      if (Okraje[PomW]<>x) and (Okraje[PomW]<>0) then{mazanie}
        if AktOkraj<2 then PolozBod(Okraje[PomW],y,0)
                      else PolozBod(Okraje[PomW]+64,y,0);
      ZapniKurzorMysi;
      if AktOkraj<2 then Okraje[PomW]:=x
                    else Okraje[PomW]:=x-64;
    end;
    if Tlacidla=Prave then begin
      Inc(AktOkraj);
      if AktOkraj=4 then AktOkraj:=0;
      NastavLock(OkrajeLock[AktOkraj]);
      CakajNaPustenie;
    end;
    if (y=0) and (x>5) and (AktRiadok<DlzkaLevelu-200) then begin
      AktRiadok:=AktRiadok+1;
      VykresliObrazovku;
    end;
    if (y>198) and (AktRiadok>1) then begin
      AktRiadok:=AktRiadok-1;
      VykresliObrazovku;
    end;
  until (Tlacidla=Lave) and (x+y=0);
  ZavriGrafiku;
  VypniKurzorMysi;
  Assign(f,'teren.dat');
  Reset(f,DlzkaLevelu*4);
  BlockWrite(f,Okraje,1);
  Close(f);
  NastavLock(NumOn);
END.