{ ----- uvodny konstruktor ----- }
constructor TZobraz.Init;
var IniFile:text;
begin
  Mena:='Lubos Saloky & Ludovit Hvizdos';
  Assign(IniFile,'HtmlView.INI');
  Reset(IniFile);
  ReadLn(IniFile);
  ReadLn(IniFile,Titul2[1]);
  ReadLn(IniFile,Titul2[2]);
  ReadLn(IniFile,Titul3[1]);
  ReadLn(IniFile,Titul3[2]);
  ReadLn(IniFile);
  for Zobraz.i:=1 to 10 do begin
    ReadLn(IniFile,DMenu[1,i]);
    ReadLn(IniFile,DMenu[2,i]);
  end;
  ReadLn(IniFile);
  ReadLn(IniFile,EndInfo[1]);
  ReadLn(IniFile,EndInfo[2]);
  ReadLn(IniFile);
  ReadLn(IniFile,ChybHlas[1]);
  ReadLn(IniFile,ChybHlas[2]);
  for Zobraz.i:=1 to 3 do begin
    ReadLn(IniFile,ChybPopis[1,i]);
    ReadLn(IniFile,ChybPopis[2,i]);
  end;
  Close(IniFile);
  VSeg:=$B800;
  LHRX:=0;LHRY:=0;
  KurzX:=0;KurzY:=1;
  Titul1:='HTMLView:';
  ZmazObrazovku;
  ZapniKurzorMysi;
  asm
             mov ah,3
             mov bh,0
             int 10h
             mov Zobraz.TempCX,cx { priprava na vypnutie textoveho kurzora }
  end;
  InicializujZoznam;
end;
procedure TZobraz.PrepisObrazovku;
var Pom:string;
    PoslZnak,PosX:integer;
begin
  AktRiadok:=HornyRiadok;
  i:=1;
  repeat
    with AktRiadok^ do begin
      Move(Text^,Pom,DlzkaRiadka+1);
      PoslZnak:=PrvyZnak+DlzkaRiadka;
      PosX:=integer(PrvyZnak)-LHRX;
      if PrvyZnak>=LHRX+80 then begin
        Pom:='';
        PosX:=0;
      end;
      if PoslZnak<=LHRX then begin
        Pom:='';
        PosX:=0;
      end;
      if (PrvyZnak<LHRX+80) and (PoslZnak>LHRX+80) then
        Pom[0]:=Char(LHRX+80-PrvyZnak);
      if (PrvyZnak<LHRX)    and (PoslZnak>LHRX)    then begin
        Delete(Pom,1,LHRX-PrvyZnak);
        PosX:=0;
      end;
      UmiestniText(PosX,i,@Pom);
    end;
    Inc(i);
    AktRiadok:=AktRiadok^.Dalsi;
  until (AktRiadok^.Dalsi=nil) or (i=24);
end;
{ ----- HLAVNA PROCEDURA pre zobrazovanie .HTML dokumentu ----- }
procedure TZobraz.Dokument;
var PoslZnak:word;
begin
  UmiestniTextovyKurzor;
  PrepisObrazovku;
  repeat
    CakajNaVOI;
    if (Zoznam^[$4D]>0) and (LHRX<PocetStlpcov-80) then begin { vpravo }
{      VypniKurzorMysi;}
      if KurzX<79 then begin
        Inc(KurzX);
        UmiestniTextovyKurzor;
        PrepisPoziciuKurzora;
      end else begin
        Inc(LHRX);
        ZmazObrazovku;
        PrepisObrazovku;
      end;
{      ZapniKurzorMysi;}
    end;
    if (Zoznam^[$4B]>0) and (LHRX+KurzX>0) then begin { vlavo }
{      VypniKurzorMysi;}
      if KurzX>0 then begin
        Dec(KurzX);
        UmiestniTextovyKurzor;
        PrepisPoziciuKurzora;
      end else begin
        Dec(LHRX);
        ZmazObrazovku;
        PrepisObrazovku;
      end;
{      ZapniKurzorMysi;}
    end;
    if (Zoznam^[$50]>0) and (PocetRiadkov+22>LHRY+KurzY) then begin { dole }
      CakajNaVOI;
      CakajNaVOI;
      CakajNaVOI;
      if KurzY<23 then begin
        Inc(KurzY);
        UmiestniTextovyKurzor;
        PrepisPoziciuKurzora;
      end else begin
        HornyRiadok:=HornyRiadok^.Dalsi;
        Inc(LHRY);
        ZmazObrazovku;
        PrepisObrazovku;
      end;
    end;
    if (Zoznam^[$48]>0) and (LHRY+KurzY>1) then begin { hore }
      CakajNaVOI;
      CakajNaVOI;
      CakajNaVOI;
      if KurzY>1 then begin
        Dec(KurzY);
        UmiestniTextovyKurzor;
        PrepisPoziciuKurzora;
      end else begin
        HornyRiadok:=HornyRiadok^.Predosly;
        Dec(LHRY);
        ZmazObrazovku;
        PrepisObrazovku;
      end;
    end;
    if (Zoznam^[$47]>0) then begin { Home }
      KurzX:=0;
      LHRX:=0;
      UmiestniTextovyKurzor;
      PrepisPoziciuKurzora;
      ZmazObrazovku;
      PrepisObrazovku;
    end;
    if (Zoznam^[$4F]>0) then begin { End }
      AktRiadok:=HornyRiadok;
      for Zobraz.i:=1 to KurzY-1 do AktRiadok:=AktRiadok^.Dalsi; { najdi aktualny riadok }
      with AktRiadok^ do begin
        PoslZnak:=PrvyZnak+DlzkaRiadka;
        if PoslZnak>LHRX+79 then begin
          KurzX:=79;
          LHRX:=PoslZnak-79;
        end else begin
          KurzX:=PoslZnak-LHRX;
        end;
      end;
      UmiestniTextovyKurzor;
      PrepisPoziciuKurzora;
      ZmazObrazovku;
      PrepisObrazovku;
    end;
  Until Zoznam^[1]>0; { Esc }
end;
{ ----- vypis chyboveho hlasenia ----- }
procedure TZobraz.Chyba(Kod:byte);
begin
  VypniKurzorMysi;
  VypniTextovyKurzor;
  case Kod of
    1,2:begin
      Ramcek(20,10,40,6,$4F);
      UmiestniText(33,11,@ChybHlas[Jazyk]);
      UmiestniText(24,13,@ChybPopis[Jazyk,Kod]);
      ZapniKurzorMysi;
      repeat
        ZistiPoziciu(MysX,MysY,Tlacidla);
      until (Tlacidla>0) or (JeZnak);
      if JeZnak then CitajZnak;
    end;
  end;
  ZapniTextovyKurzor;
  if Kod in [1,2] then Koniec;
end;
procedure TZobraz.PrepisPoziciuKurzora;
var PomS,PomS2,PomS3:string[8];
begin
  PomS:='             '; { 13 medzier }
  UmiestniText(34,0,@PomS);
  Str(LHRX+KurzX,PomS2);
  Str(LHRY+KurzY,PomS3);
  PomS:='['+PomS2+':'+PomS3+']';
  UmiestniText(34,0,@PomS);
  PomS:='   ';
  UmiestniText(74,0,@PomS);
  if PocetRiadkov>0 then Str((100*LHRY) div PocetRiadkov,PomS);
  UmiestniText(77-Length(PomS),0,@PomS);
end;

{ ----- ukoncovacia procedura ----- }
destructor TZobraz.Koniec;
begin
  VypniKurzorMysi;
  asm
             cld
             mov es,Zobraz.VSeg
             mov ax,0700h
             mov cx,2000
             xor di,di
         rep stosw                { zmaz obrazovku }
             mov ah,2h
             mov dx,0300h
             mov bh,0
             int 10h              { nastav textovy kurzor }
  end;
  UmiestniText(24,0,@EndInfo[Jazyk]);
  UmiestniText(24,1,@Mena);
  ZavriZoznam;
end;
{ ----- pomocne procedury ----- }
procedure TZobraz.EmulujPridajRiadok;
var f2:text;
    s:string;
begin
  PocetRiadkov:=0;
  PocetStlpcov:=0;
  Assign(f2,'Emul.TXT');
  Reset(f2);
  while not EOF(f2) do begin
    with AktRiadok^ do begin
      ReadLn(f2,AktRiadok^.PrvyZnak,s);
      Inc(PocetRiadkov);
      if PocetStlpcov<PrvyZnak+Length(s) then PocetStlpcov:=PrvyZnak+Length(s); { maximum }
    end;
    Delete(s,1,1);
    AktRiadok^.DlzkaRiadka:=Length(s);
    GetMem(AktRiadok^.Text,Length(s)+1);
    Move(s,AktRiadok^.Text^,Length(s)+1);
    New(AktRiadok^.Dalsi);
    AktRiadok^.Dalsi^.Predosly:=AktRiadok;
    AktRiadok^.Dalsi^.Dalsi:=nil;
    AktRiadok:=AktRiadok^.Dalsi;
  end;
  Close(f2);
end;
{ ----- textovy kurzor ----- }
procedure TZobraz.ZapniTextovyKurzor;assembler;
asm
             mov cx,Zobraz.TempCX
             mov ah,1
             int 10h
end;
procedure TZobraz.VypniTextovyKurzor;assembler;
asm
             mov cx,100h
             mov ah,1
             int 10h
end;
procedure TZobraz.UmiestniTextovyKurzor;assembler;
asm
             mov ah,02h
             mov dl,Zobraz.KurzX
             mov dh,Zobraz.KurzY
             mov bh,0
             int 10h              { nastav textovy kurzor }
end;

{ ----- vlastny ReadKey a KeyPressed ----- }
Function TZobraz.CitajZnak:char;assembler;
asm
             mov ah,10h
             int 16h
end;
Function TZobraz.JeZnak:boolean;assembler;
asm
             mov ah,11h
             int 16h
             mov al,1
             jnz @Koniec
             xor al,al
@Koniec:
end;
procedure TZobraz.CakajNaVOI;assembler;
asm
             mov dx,03DAh
@vz1:        in al,dx
             and al,08h
             jnz @vz1
@vz2:        in al,dx
             and al,08h
             jz @vz2
end; { CakajNaVOI }
{ ----- nakresli vyplneny ramcek so zadanym atributom ----- }
procedure TZobraz.Ramcek(PosX,PosY,Sirka,Vyska:word;Atribut:byte);assembler;
asm
             cld
             mov es,Zobraz.VSeg
             mov ax,160
             mul PosY
             shl PosX,1           { PosX vynasobeny dvoma! }
             sub Sirka,4          { Sirka znizena o 4! }
             sub Vyska,2          { Vyska znizena o 2! }
             add ax,PosX
             mov di,ax            { nastavene ES:DI na LHR ramceka }
             mov ah,Atribut
             mov al,32
             stosw
             mov al,218
             stosw                { nakresleny LHR - 1 pixel len s pozadim }
             mov al,196
             mov cx,Sirka
         rep stosw                { nakresleny HRd }
             mov al,191
             stosw
             mov al,32
             stosw                { nakresleny PHR - 1 pixel len s pozadim }

@DalsiRiadok:add di,152
             sub di,Sirka
             sub di,Sirka         { uprav DI }
             mov al,32
             stosw
             mov al,179
             stosw                { nakresleny LStl riadka }
             mov al,32
             mov cx,Sirka
         rep stosw                { riadok, vnutro }
             mov al,179
             stosw
             mov al,32
             stosw                { nakresleny PStl riadka }
             dec Vyska
             cmp Vyska,0
             ja @DalsiRiadok      { koniec cyklu pre riadok }

             add di,152
             sub di,Sirka
             sub di,Sirka         { uprav DI }
             mov al,32
             stosw
             mov al,192
             stosw                { nakresleny LDR - 1 pixel len s pozadim }
             mov al,196
             mov cx,Sirka
         rep stosw                { nakresleny DRd }
             mov al,217
             stosw
             mov al,32
             stosw                { nakresleny PDR - 1 pixel len s pozadim }
end;
{ ----- vypise text na obrazovku priamym zapisom do VideoRAM ----- }
procedure TZobraz.UmiestniText(x,y:word;Adresa:pointer);assembler;
asm
             mov es,Zobraz.VSeg
             push ds
             cld
             mov ax,word ptr Adresa+2
             mov ds,ax
             mov si,word ptr Adresa     { pripravena zdrojova adresa }
             mov ax,160
             mul word ptr y
             add ax,x
             add ax,x
             mov di,ax                  { pripravena cielova adresa vo VRam }
             xor ch,ch
             mov cl,byte ptr [si]       { pripravena dlzka }
             jcxz @Koniec
             inc si
@DalsiZnak:  movsb
             inc di
             loop @DalsiZnak
@Koniec:     pop ds
end;
{ ----- zmaze obrazovku, nastavi atributy znakov, vypise horny a dolny riadok ----- }
procedure TZobraz.ZmazObrazovku;
var pom:integer;
    PomS:string[9];
begin
  asm
             cld
             mov es,Zobraz.VSeg
             mov ax,1F20h
             mov cx,2000
             xor di,di
         rep stosw                      { vymazana obrazovka }

             mov ax,3020h
             mov cx,80
             xor di,di
         rep stosw                      { nakresleny horny riadok }

             mov dx,0731h
             mov di,3840
@DalsiePole: mov word ptr [es:di],dx
             add di,2
             mov ax,3020h
             mov cx,6
         rep stosw
             mov word ptr [es:di],0
             add di,2
             inc dx
             cmp dx,073Bh
             jb @DalsiePole             { nakresleny spodny riadok }

             mov word ptr [es:3984],0731h
             mov word ptr [es:3986],0730h
             mov word ptr [es:3998],3020h
             mov byte ptr [es:156],'%'  { blbosticky }
{             mov byte ptr [es:68],'['
             mov byte ptr [es:80],':'
             mov byte ptr [es:92],']'}
  end;
  UmiestniText(1,0,@Titul1);
  UmiestniText(11,0,@NazovSub);
  UmiestniText(27,0,@Titul2[Jazyk]);
  PrepisPoziciuKurzora;
  Str(PocetBajtov,PomS);
  UmiestniText(64-Length(PomS),0,@PomS);
  UmiestniText(65,0,@Titul3[Jazyk]);
  for pom:=1 to 9 do UmiestniText(8*pom-7,24,@DMenu[Jazyk,pom]);
  UmiestniText(74,24,@DMenu[Jazyk,10]);
end;
