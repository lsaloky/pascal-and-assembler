unit PomGr;
                                INTERFACE
uses MainGr,Dos,Mys;
var AttrCitaj:record
                  Blik:word;
                  FarbaTextu,FarbaKurzora:byte;
                  Font:pointer;
                end;
Procedure Citaj(PosX,PosY:word;Max:byte;var s:string);
Procedure SuboroveOkno(Font:pointer;Titul,Filter:string;var Nazov:string);
procedure NahrajAPustFLI(Nazov:string);

                              IMPLEMENTATION
Procedure Citaj(PosX,PosY:word;Max:byte;var s:string);
var StaryCas,BiosSeg,PosXKurz,AktOfs:word;
    AktZnak:char;
    Vyska:byte;{fontu}
    Viditelny:byte;
    p:pointer;
begin
  s:='';PosXKurz:=PosX;
  asm {urcenie vysky fontu}
             call AkTrebaVypniMys
             mov es,word ptr AttrCitaj.Font+2
             mov si,word ptr AttrCitaj.Font
             mov al,[es:si+513]
             mov Vyska,al
  end;
  GetMem(p,Vyska*320+320);
  StiahniBMP(0,PosY-1,320,Vyska+1,p);
  repeat
    asm
             cld
             mov BiosSeg,0040h
             mov es,BiosSeg
             mov ax,word[es:6Ch]
             mov StaryCas,ax
             mov ax,320
             mul PosY
             add ax,PosXKurz
             mov AktOfs,ax
             mov Viditelny,0
{ ----- cakaci cyklus ----- }
@Cakanie:    mov ah,1
             int 16h
             jnz @Klaves
             mov es,BiosSeg
             mov ax,word[es:6Ch]
             sub ax,AttrCitaj.Blik
             cmp ax,StaryCas
             jb @Cakanie
{ ----- spracovanie blikania kurzora ----- }
             add ax,AttrCitaj.Blik
             mov StaryCas,ax
             not Viditelny
             mov es,VSeg
             mov di,AktOfs
             mov al,0
             cmp Viditelny,0
             jne @Spoj1
             mov al,AttrCitaj.FarbaKurzora
@Spoj1:      mov ah,al
             xor ch,ch
             mov cl,Vyska
@DalsiBod:   stosw
             add di,318
             loop @DalsiBod
             jmp @Cakanie
{ ----- bol stlaceny klaves ----- }
@Klaves:     mov ah,0
             int 16h
             mov AktZnak,al
    end;
    if (AktZnak=#8) and (Length(s)>0) then begin
      Delete(s,Length(s),1);
      while s[Length(s)] in ['~','`','^','|'] do Delete(s,Length(s),1);
      PosXKurz:=PosX+LengthPixel(AttrCitaj.Font,s);
    end;
    if (not(AktZnak in [#13,#8])) and (LengthDiak(s)<Max) then begin
      s:=s+AktZnak;
      PosXKurz:=PosXKurz+LengthPixel(AttrCitaj.Font,AktZnak);
    end;
    PrilepBMP(0,PosY-1,p);
    VypisPO(PosX,PosY,AttrCitaj.Font,s,AttrCitaj.FarbaTextu);
  until AktZnak=#13;
  AkTrebaZapniMys;
  FreeMem(p,Vyska*320+320);
end;  { Citaj }
Procedure SuboroveOkno(Font:pointer;Titul,Filter:string;var Nazov:string);
const PosX=50;PosY=40;
      RozX=194;RozY=120;
      PocetOP=11;
      MaxPocetSub=800;
      SipkaHore:array[1..68] of byte=(8 ,0 ,8 ,0 ,   {rozmery bitmapy}
                                      0 ,0 ,0 ,55,55,0 ,0 ,0 ,
                                      0 ,0 ,0 ,55,55,0 ,0 ,0 ,
                                      0 ,0 ,55,59,59,55,0, 0 ,
                                      0 ,0 ,55,59,59,55,0, 0 ,
                                      0 ,55,59,63,63,59,55,0 ,
                                      55,59,63,28,28,63,59,55,
                                      55,59,63,28,28,63,59,55,
                                      0 ,55,59,59,59,59,55,0 );
      SipkaDole:array[1..68] of byte=(8 ,0 ,8 ,0 ,    {rozmery bitmapy}
                                      0 ,55,59,59,59,59,55,0,
                                      55,59,63,28,28,63,59,55,
                                      55,59,63,28,28,63,59,55,
                                      0 ,55,59,63,63,59,55,0 ,
                                      0 ,0 ,55,59,59,55,0, 0 ,
                                      0 ,0 ,55,59,59,55,0, 0 ,
                                      0 ,0 ,0 ,55,55,0 ,0 ,0 ,
                                      0 ,0 ,0 ,55,55,0 ,0 ,0 );
      SipkaVpravo:array[1..84] of byte=(10 ,0 ,8 ,0 ,    {rozmery bitmapy}
                                      0 ,55,55,55,55,0 ,0 ,0 ,0 ,0 ,
                                      55,59,59,59,59,55,0 ,0 ,0 ,0 ,
                                      59,59,59,63,63,59,55,55,0 ,0 ,
                                      59,28,28,28,28,63,59,59,55,55,
                                      59,28,28,28,28,63,59,59,55,55,
                                      59,59,59,63,63,59,55,55,0 ,0 ,
                                      55,59,59,59,59,55,0 ,0 ,0 ,0 ,
                                      0 ,55,55,55,55,0 ,0 ,0 ,0 ,0 );
      SipkaVlavo:array[1..84] of byte=(10 ,0 ,8 ,0 ,    {rozmery bitmapy}
                                      0 ,0 ,0 ,0 ,0 ,55,55,55,55,0 ,
                                      0 ,0 ,0 ,0 ,55,59,59,59,59,55,
                                      0 ,0 ,55,55,59,63,63,59,59,59,
                                      55,55,59,59,63,28,28,28,28,59,
                                      55,55,59,59,63,28,28,28,28,59,
                                      0 ,0 ,55,55,59,63,63,59,59,59,
                                      0 ,0 ,0 ,0 ,55,59,59,59,59,55,
                                      0 ,0 ,0 ,0 ,0 ,55,55,55,55,0 );
      Aktiv:array[1..PocetOP+1,1..4] of word=(
              (PosX+6,PosY+20,PosX+106,PosY+34),     {citanie nazvu suboru}
              (PosX+6,PosY+42,PosX+106,PosY+96),     {okno s nazvami suborov}
              (PosX+6,PosY+102,PosX+186,PosY+116),   {okno pre aktualny adresar}
              (PosX+124,PosY+20,PosX+184,PosY+36),   {OK}
              (PosX+124,PosY+40,PosX+184,PosY+56),   {Zavri}
              (PosX+106,PosY+39,PosX+116,PosY+49),   {sipka hore}
              (PosX+106,PosY+89,PosX+116,PosY+99),   {sipka dole}
              (PosX+131,PosY+80,PosX+141,PosY+90),   {sipka vlavo}
              (PosX+158,PosY+80,PosX+169,PosY+90),   {sipka vpravo}
              (PosX+106,PosY+50,PosX+116,PosY+86),   {posuvanie sa po pruhu}
              (PosX+142,PosY+78,PosX+157,PosY+92),   {zadavanie pismena disku}
              (400,0,0,0));
      Klav:array[1..PocetOP+1] of char=('n','s','a','o','z','8','2','4','6',#0,'d',#255);
      Help:array[0..PocetOP] of string[40]=('','Zad`avanie n`azvu s`uboru',
        'V`yber s`uboru','Aktu`alny adres`ar','Potvrdenie','Zru~senie',
        'Posun hore','Posun dole','Predo~sl`y disk','~Dal~s`i disk','Posun po s`uboroch','P`ismeno disku');
type TZoznam=array[1..MaxPocetSub] of string[12];
     TFarbaSub=array[1..MaxPocetSub] of byte;
var Udalost:word;
    poz:pointer;
    Zn:string[1];
    Subor,Adresar,Cesta:string;
    Zoznam:^TZoznam;
    FarbaSub:^TFarbaSub;
    i,j,Pocet,Horny:integer;
  procedure VypisVselico(Horny:integer);
  var j:integer;
  begin
    GetDir(0,Adresar);
    Zn:=Copy(Adresar,1,1);
    Zn[1]:=UpCase(Zn[1]);
    Color:=169;
    CakajNaVOI;
    Ramcek(PosX+6,PosY+20,100,14,4);
    VypisPO(59,63,Font,Nazov,Zlta);
    Ramcek(PosX+6,PosY+102,180,14,4);
    VypisPO(59,146,Font,Adresar,Zlta);
    Ramcek(PosX+142,PosY+77,16,16,4);
    VypisPO(196,121,Font,Zn,Zlta);
    for j:=0 to 4 do begin
      Color:=4;
      VyplnPlochu(59,81+10*j,96,10);
      if Horny+j<Pocet then VypisPO(59,83+10*j,Font,Zoznam^[Horny+j],FarbaSub^[Horny+j]);
    end;
    Color:=0;
    CiaraZvisla(PosX+107,PosY+48,40);
    CiaraZvisla(PosX+108,PosY+48,40);
    CiaraZvisla(PosX+113,PosY+48,40);
    CiaraZvisla(PosX+114,PosY+48,40);
    Color:=55;
    CiaraZvisla(PosX+109,PosY+48,40);
    CiaraZvisla(PosX+112,PosY+48,40);
    Color:=59;
    CiaraZvisla(PosX+110,PosY+48,40);
    CiaraZvisla(PosX+111,PosY+48,40);
    Color:=15;
    if Pocet>5 then CiaraVodorovna(PosX+107,Round(PosY+50+(Horny-1)*38/(Pocet-5)),8)
  end;
  procedure NacitajSubory(var Pocet:integer);
  var AktPol:SearchRec;
  begin
    Horny:=1;
    FindFirst('*.*',Directory,AktPol); {prva polozka v adresari je akt. adresar, preskocime}
    i:=1;
    while DosError=0 do begin
      if ((AktPol.Attr and Directory)>0) and (AktPol.Name<>'.') then begin
        Zoznam^[i]:=AktPol.Name;
        FarbaSub^[i]:=Oranzova;
        Inc(i);
      end;
      FindNext(AktPol);
    end;
    FindFirst(Filter,$21,AktPol); {prva polozka v adresari je akt. adresar, preskocime}
    while DosError=0 do begin
      Zoznam^[i]:=AktPol.Name;
      FarbaSub^[i]:=Zlta;
      Inc(i);
      FindNext(AktPol);
    end;
    Pocet:=i;
  end;
begin
  GetMem(Poz,RozX*RozY+4);
  GetMem(Zoznam,MaxPocetSub*13);
  GetMem(FarbaSub,MaxPocetSub);
  VM;
  StiahniBMP(PosX,PosY,RozX,RozY,Poz);
  NacitajSubory(Pocet);
  Horny:=1;
{ ----- uvodne vypisy ----- }
  Color:=15;Ramcek(PosX,PosY,RozX,RozY,3);
  CiaraVodorovna(PosX,PosY+14,RozX);
  VypisPO(PosX+(RozX-LengthPixel(Font,Titul)) div 2,PosY+4,Font,Titul,Zlta);
  Tlacidlo3D(PosX+124,PosY+20,60,16,Font,'OK',Hneda,Modra,False);
  Tlacidlo3D(PosX+124,PosY+40,60,16,Font,'Zavri',Hneda,Modra,False);
  PrilepBMPPO(PosX+107,PosY+40,@SipkaHore);
  PrilepBMPPO(PosX+107,PosY+88,@SipkaDole);
  PrilepBMPPO(PosX+132,PosY+81,@SipkaVlavo);
  PrilepBMPPO(PosX+158,PosY+81,@SipkaVpravo);
  VypisPO(PosX+130,PosY+66,Font,'Disk:',Hneda);
  AttrCitaj.Font:=Font;
  Nazov:=Filter;
  Color:=169;
  Ramcek(PosX+6,PosY+40,100,56,4);
  VypisVselico(1);  {od zaciatku}
  ZM;
  VypinajMys:=True;
  repeat
    Udalost:=ObsluzUdalostSHelpom(@Aktiv,@Klav,Font,@Help);
    if Udalost in [2,8,9] then CakajNaPustenie;
  { ----- spracovanie udalosti ----- }
    case Udalost of
      1:begin
        Color:=169;Ramcek(PosX+6,PosY+20,100,14,4);
        Citaj(PosX+9,PosY+23,12,Nazov);
        if Pos('*',Nazov)>0 then begin
          Filter:=Nazov;
          NacitajSubory(pocet);
          Horny:=1;
          VypisVselico(Horny);
        end;
      end; { case 1 - zadanie nazvu suboru}
      2:begin
        j:=Horny+(MysY-82) div 10;  {zvoleny bol j-ty prvok z pola Zoznam^}
        if j<=Pocet then begin
          if FarbaSub^[j]=Zlta then Nazov:=Zoznam^[j]
          else begin
            Cesta:=Adresar;
            if Length(Adresar)>3 then Cesta:=Cesta+'\';{ak nie je v hlavnom adresari}
            if Zoznam^[j]<>'..' then Cesta:=Cesta+Zoznam^[j]
            else Cesta:='..';
            ChDir(Cesta);
            NacitajSubory(Pocet);
            Horny:=1;
          end;
          VypisVselico(Horny);
        end;
      end; { case 2 - vyber suboru zo zoznamu}
      3:begin
        Color:=169;Ramcek(PosX+6,PosY+102,180,14,4);
        Citaj(PosX+9,PosY+106,23,Adresar);
        ChDir(Adresar);
        NacitajSubory(Pocet);
        VypisVselico(Horny);
      end; { case 3 - zadanie adresara}
      6:begin
        if Horny>1 then begin
          Dec(Horny);
          VypisVselico(Horny);
        end;
        for j:=1 to 6 do CakajNaVOI;
      end;
      7:begin
        if Horny<Pocet-5 then begin
          Inc(Horny);
          VypisVselico(Horny);
        end;
        for j:=1 to 6 do CakajNaVOI;
      end;
      8:if Zn[1]>'A' then begin
        Dec(byte(Zn[1]));
        ChDir(Zn+':');
        NacitajSubory(Pocet);
        VypisVselico(Horny);
      end; { case 8 - posun na predosly disk }
      9:begin
        Inc(byte(Zn[1]));
        ChDir(Zn+':');
        NacitajSubory(Pocet);
        VypisVselico(Horny);
      end; {case 9 - posun na dalsi disk}
      10:if Pocet>5 then begin
        Horny:=Round((MysY-50-PosY)*(Pocet-5)/38)+1;
        VypisVselico(Horny);
      end;
      11:begin
        Color:=0;VyplnPlochu(0,191,320,9);
        VypisPO(0,192,Font,'Zvo~l si p`ismeno disku:',SvetloModra);
        Color:=169;
        Ramcek(PosX+142,PosY+77,16,16,4);
        asm      {ch:=ReadKey}
               mov ah,0
               int 16h
               mov byte ptr Zn+1,al
        end;
        Zn[0]:=#1;
        Zn[1]:=UpCase(Zn[1]);
        ChDir(Zn+':');
        NacitajSubory(Pocet);
        VypisVselico(Horny);
      end; { case 11 - volba pismena disku }
    end; { case }
  until (Udalost=5) or ((Udalost=4) and (Pos('*',Nazov)=0));
  if Udalost=4 then Tlacidlo3D(PosX+124,PosY+20,60,16,Font,'OK',Hneda,Modra,True)
  else Tlacidlo3D(PosX+124,PosY+40,60,16,Font,'Zavri',Hneda,Modra,True);
  CakajNaPustenie;
  PrilepBMP(PosX,PosY,Poz);
  FreeMem(Zoznam,MaxPocetSub*13);
  FreeMem(FarbaSub,MaxPocetSub);
  FreeMem(Poz,RozX*RozY+4);
  if Udalost=5 then Nazov:='';
end;  { SuboroveOkno }
procedure TestujVOI;assembler;
asm
             mov dx,03DAh
@VOI:        in al,dx
             test al,8
             jz @VOI
end;
procedure ChunkDeltaFLI;assembler;
asm
             call TestujVOI
             mov ax,0A000h
             mov es,ax
             mov ax,320
             mul word ptr [si]    {offset zaciatku meneneho riadka}
             mov di,ax
             mov bx,word ptr[si+2]{pocet menenych riadkov}
             add si,4             {sme na zaciatku 1. komprimovaneho riadku}
@DalsiRiadok:push di
             mov bh,byte[si]      {pocet elementov}
             cmp bh,0
             je @KoniecRiadka
             inc si
@DalsiElem:  xor ah,ah
             lodsb
             add di,ax            {x-ova suradnica}
             mov cl,byte[si]      {nacitame riadiaci bajt RLE kompresie}
             inc si
             cmp cl,0
             je @KoniecRiadka
             jg @Kopiruj
             neg cl               {nacitany bajt sa prilepi CX-krat}
             lodsb
         rep stosb
             dec bh
             jz @KoniecRiadka
             jmp @DalsiElem
@Kopiruj:rep movsb
             dec bh
             jz @KoniecRiadka
             jmp @DalsiElem
@KoniecRiadka:pop di
             add di,320
             dec bl
             jnz @DalsiRiadok
end;
procedure ChunkPaleta;assembler;
asm
             call TestujVOI
             mov bx,word[si]      {pocet menenych usekov palety}
             add si,2
             xor ah,ah
@DalsiUsek:  add ah,byte[si]      {Skip Count = kolko preskocit}
             mov cl,byte[si+1]    {Color Count = kolko zapisat}
             add si,2
@DalsiaFarba:mov dx,03C8h
             mov al,ah
             out dx,al
             mov dx,03C9h
             lodsb
             out dx,al
             lodsb
             out dx,al
             lodsb
             out dx,al
             inc ah
             dec cl
             jnz @DalsiaFarba
             dec bl
             jnz @DalsiUsek
end;
procedure ChunkByteRun;assembler;
asm
             call TestujVOI
             mov ax,0A000h
             mov es,ax
             xor di,di
             mov ah,200           {pocet riadkov}
@DalsiRiadok:mov bl,byte[si]      {pocet elementov}
             inc si
@Dalsi:      xor ch,ch
             mov cl,byte[si]      {riadiaci bajt}
             inc si
             cmp cl,0
             jl @Kopiruj
             lodsb
         rep stosb                {roztiahni dany bajt}
             jmp @OK
@Kopiruj:    neg cl
         rep movsb                {skopiruj ho}
@OK:         dec bl
             jnz @Dalsi
             dec ah
             jnz @DalsiRiadok
end;
procedure NahrajAPustFLI(Nazov:string);
var FLIHlavicka:record
      Dlzka:longint;    {vsetko je nanic, pouziva sa len Rychlost a PocetSnimkov }
      ID,PocetSnimkov,Sirka,Vyska,Hlbka,Priznaky,Rychlost:word;
    end;
    p:pointer;
    c1,PocetSubChunks,FHandle:word;
begin
  GetMem(p,65500);
  Nazov:=Nazov+#0;
  asm
             push ds
{ ----- Assign(f,Nazov);Reset(f,1); ----- }
             mov ax,ss
             mov ds,ax
             mov ax,3D00h         {Otvor subor, len citanie}
             lea dx,Nazov
             inc dx               {DS:DX ukazuje na nazov suboru}
             int 21h
             mov FHandle,ax
{ ----- BlockRead(f,FLIHlavicka,18); ----- }
             mov bx,ax            {DS:DS cielove miesto nacitania}
             mov ax,ss
             mov ds,ax
             lea dx,FLIHlavicka
             mov cx,18
             mov ah,3Fh           {citanie}
             int 21h
{ ----- Seek(f,128); ----- }
             mov ax,4200h
             mov bx,FHandle
             mov cx,0
             mov dx,128
             int 21h
             pop ds
{ ----- For c1:=1 to FLIHlavicka.PocetSnimkov do begin ----- }
             mov c1,1
@Cyklus:     mov ax,c1
             cmp ax,FLIHlavicka.PocetSnimkov
             jge @Koniec
{ ----- nacitaj z disku do p^ 4 bajty (Dlzka snimku) ----- }
             push ds
             mov dx,word ptr p
             mov ds,word ptr p+2
             mov ah,3Fh
             mov bx,FHandle
             mov cx,4
             int 21h
{ ----- nacitaj Dlzka-4 bajtov do p^ - aktualny snimok ----- }
             mov ah,3Fh
             mov si,dx
             mov cx,word[si]
             sub cx,4
             add dx,4
             int 21h
{ ----- zacina zobrazovaci algoritmus snimku ----- }
             cld
             mov si,word ptr p
             mov ds,word ptr p+2  {DS:SI ukazuje na hlavny chunk snimky}
             mov cx,[si+6]        {pocet subchunk}
{!!!!!}   {   xor ch,ch    }        {??? zeby ??? }
             mov PocetSubChunks,cx
             jcxz @BezZmeny       {snimka je identicka}
             add si,16            {ideme na prvy subchunk}
{ ----- v AX bude identifikator subchunku, nasleduje prikaz CASE ----- }
@DalsiChunk: mov ax,[si+4]        {co sa bude diat}
             add si,6
             cmp ax,0Ch           {DeltaFLI kompresia}
             jne @Case2
             call ChunkDeltaFLI
             jmp @CaseEnd
@Case2:      cmp ax,0Bh           {zmena palety}
             jne @Case3
             call ChunkPaleta
             jmp @CaseEnd
@Case3:      cmp ax,0Fh           {ByteRun kompresna schema}
             jne @Case4
             call ChunkByteRun
             jmp @CaseEnd
@Case4:      cmp ax,10h           {snimok bez kompresie}
             jne @Case5
             mov ax,0A000h
             mov es,ax
             xor di,di
             mov cx,32000
         rep movsw
             jmp @CaseEnd
@Case5:      cmp ax,0Dh           {cierna snimka}
             jne @Case6
             mov ax,0A000h
             mov es,ax
             xor di,di
             mov ax,0A0Ah
             mov cx,32000
         rep stosw
             jmp @CaseEnd
@Case6:
@CaseEnd:    dec PocetSubChunks
             jnz @DalsiChunk
{ ----- obrazok je hotovy, este spracuj rychlost animacie a VOI ----- }
@BezZmeny:   pop ds
             mov cx,FLIHlavicka.Rychlost
             dec cx
             mov dx,03DAh         {cakanie na vertikalny obnovovaci impulz}
@VOI1:       in al,dx
             test al,8
             jz @VOI1
@VOI2:       in al,dx
             test al,8
             jnz @VOI2
             loop @VOI1
             mov ah,1
             int 16h
             jz @NieJeKlaves
             jmp @Koniec
@NieJeKlaves:inc c1
             jmp @Cyklus
@Koniec:
{ ----- Close(f); ----- }
             mov ah,3Eh
             mov bx,FHandle
             int 21h
  end;
  FreeMem(p,65500);
end;

BEGIN
  AttrCitaj.Blik:=2;          {dost rychlo}
  AttrCitaj.FarbaTextu:=Zlta;
  AttrCitaj.FarbaKurzora:=15; {biela}
END.