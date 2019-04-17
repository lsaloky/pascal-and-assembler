unit MukoUtil;{MukoSoft graficke utility}
                        INTERFACE
uses Dos,Myska,MukoGr,Crt;
{ ----- rozne doplnkove procedury a funkcie ----- }
procedure SuboroveOkno(APosX,APosY:word;Titul,Filter:string;var ASubor:SearchRec);
procedure Citaj(Dlzka,Odtien:byte);             {cita retazec do Ret}
{ ----- procedury pre pracu s priemrovanym pozadim ----- }
procedure PripravPozadie(RozX,RozY:word;Farba:byte;var ObrazUkaz:pointer);
procedure ZlikvidujPozadie(ObrazUkaz:pointer);
procedure PriemerujBitmapu(ObrazUkaz:pointer);
procedure StmavBitmapu(ObrazUkaz:pointer);
{ ----- pomocne procedury pre bitmapy ----- }
procedure PreklopBitmapu(RozX,RozY,Zdroj:word;Smer:shortint);
{-1=okolo hlavnej diagonaly, 1 okolo vedlajsej,2 okolo zvislej osi,-2 okolo vodorovnej}
procedure PosunVRamDole(oKolko:word);


                      IMPLEMENTATION
procedure SuboroveOkno(APosX,APosY:word;Titul,Filter:string;var ASubor:SearchRec);
const Sirka=120;Vyska=124;
      SipkaHore:array[1..64] of byte=(0 ,0 ,0 ,55,55,0 ,0 ,0 ,
                                      0 ,0 ,0 ,55,55,0 ,0 ,0 ,
                                      0 ,0 ,55,59,59,55,0, 0 ,
                                      0 ,0 ,55,59,59,55,0, 0 ,
                                      0 ,55,59,63,63,59,55,0 ,
                                      55,59,63,28,28,63,59,55,
                                      55,59,63,28,28,63,59,55,
                                      0 ,0 ,55,59,59,55,0 ,0 );
      SipkaDole:array[1..64] of byte=(0 ,0 ,55,59,59,55,0 ,0,
                                      55,59,63,28,28,63,59,55,
                                      55,59,63,28,28,63,59,55,
                                      0 ,55,59,63,63,59,55,0 ,
                                      0 ,0 ,55,59,59,55,0, 0 ,
                                      0 ,0 ,55,59,59,55,0, 0 ,
                                      0 ,0 ,0 ,55,55,0 ,0 ,0 ,
                                      0 ,0 ,0 ,55,55,0 ,0 ,0 );
{ ----- suradnice RELATIVNE KU APosX,APosY v tvare XMIN,YMIN,XMAX,YMAX ----- }
      AktivIn:array[1..6,1..4]of byte=((4,19,Sirka-4,33),        {ramcek pre meno suboru}
                                       (4,36,Sirka-4,96),        {ramcek s nazvami suborov}
                                       (Sirka-13,37,Sirka-5,45), {sipka hore}
                                       (Sirka-13,87,Sirka-5,95), {sipka dole}
                                       (18,108,42,124),          {OK}
                                       (46,108,94,124));         {ZAVRI}
var p1,p2,UdalostIn,PocetSub,HornySub,AktSub:integer;
    pomx,pomy:word;
    pomSubor:SearchRec;
    ATlacidla:byte;
    Adresar:array[1..100] of SearchRec;
{ ----- vypis adresara ----- }
  procedure ZmazCiarku;
  var p1:word;
  begin
    VypniKurzorMysi;
    p1:=APosY+45+(42 * (HornySub-1)) div (PocetSub-7);
    Nastav(APosX+Sirka-13,p1,0);
    CiaraVodorovna(8);
    PolozBod(APosX+Sirka-9,p1,59);
    PolozBod(APosX+Sirka-10,p1,59);
    ZapniKurzorMysi;
  end; {SuboroveOkno.ZmazCiarku }
  procedure VypisSubory;
  var p1:word;
  begin
    VypniKurzorMysi;
    Nastav(APosX+Sirka-13,APosY+45+(42* (HornySub-1)) div (PocetSub-7) ,69);
    CiaraVodorovna(8);
    Nastav(APosX+5,APosY+37,0);VyplnPlochu(Sirka-20,58);
    for p1:=1 to 7 do begin
      Nastav(APosX+6,APosY+30+8*p1,0);
      VypisPriehladne(Adresar[p1+HornySub-1].Name,SvetloModra);
    end;
    ZapniKurzorMysi;
  end; { SuboroveOkno.VypisSubory }
  { ----- nacitanie adresara a upravy ----- }
  procedure NacitajSubory(Filter:string);
  var p2:word;
      PomStr,FilStr:string;
  begin
    FillChar(Adresar,SizeOf(Adresar),#0);
    FindFirst('*.*',AnyFile,pomSubor);
    PocetSub:=1;
    while DosError=0 do begin
      FindNext(pomSubor);
      if pomSubor.Attr and Directory=0 then begin{DownCase}
        for p2:=1 to Length(pomSubor.Name) do
          if pomSubor.Name[p2] in ['A'..'Z'] then PomSubor.Name[p2]:=Chr(Ord(PomSubor.Name[p2])+32);
      end else                                   {UpCase}
        for p2:=1 to Length(pomSubor.Name) do PomSubor.Name[p2]:=UpCase(PomSubor.Name[p2]);
      PomStr:=Copy(PomSubor.Name,Pos('.',PomSubor.Name)+1,3);
      if (pomSubor.Attr and Directory>0) or (PomStr=Filter) then begin
        Adresar[PocetSub]:=pomSubor;
        Inc(PocetSub);
      end;
    end;
    HornySub:=1;
    Dec(PocetSub);
  end; { Suboroveokno.NacitajSubory }
begin { SuboroveOkno }
{ ----- kreslenie ----- }
  VypniKurzorMysi;
  Nastav(APosX,APosY,15);Obdlznik(Sirka,Vyska);
  Nastav(APosX+1,APosY+1,12);Obdlznik(Sirka-2,Vyska-2);
  Nastav(APosX+Sirka div 2-Length(Titul)*4,APosY+4,0);
  VypisPriehladne(Titul,Zelena);
  Nastav(APosX+1,APosY+14,12);CiaraVodorovna(Sirka-2);
  Nastav(APosX+4,APosY+18,12);Obdlznik(Sirka-8,14);
  Nastav(APosX+4,APosY+36,12);Obdlznik(Sirka-8,60);
  Nastav(APosX+14,APosY+104,12);Ramcek(24,16,99);
  Nastav(APosX+42,APosY+104,12);Ramcek(48,16,99);
  Nastav(APosX+18,APosY+108,0);VypisPriehladne('OK',Zlta);
  Nastav(APosX+46,APosY+108,0);VypisPriehladne('ZAVRI',Zlta);
  Nastav(APosX+Sirka-13,APosY+37,0);PrilepBitmapu(8,8,Ofs(SipkaHore));
  Nastav(APosX+Sirka-13,APosY+87,0);PrilepBitmapu(8,8,Ofs(SipkaDole));
  Nastav(APosX+Sirka-9,APosY+45,59);CiaraZvisla(42);
  Nastav(APosX+Sirka-10,APosY+45,59);CiaraZvisla(42);
  Nastav(APosX+7,APosY+21,0);VypisPriehladne('*.'+Filter,SvetloModra);
  ASubor.Name:='';
  NacitajSubory(Filter);
  VypisSubory;
  ZapniKurzorMysi;
{ ----- cakanie na udalost ----- }
  repeat
    repeat
      ZistiPoziciu(pomx,pomy,ATlacidla);
    until ATlacidla>0;
    pomx:=pomx div 2;
    UdalostIn:=0;
    for p1:=1 to 6 do
      if (pomx>=APosX+AktivIn[p1,1]) and (pomx<=APosX+AktivIn[p1,3]) and
         (pomy>=APosY+AktivIn[p1,2]) and (pomy<=APosY+AktivIn[p1,4]) then UdalostIn:=p1;
{ ----- spracovanie udalosti ----- }
    case UdalostIn of
      1:begin          {natukanie mena suboru}
        VypniKurzorMysi;
        Nastav(APosX+5,APosY+19,0);VyplnPlochu(Sirka-10,12);
        Nastav(APosX+7,APosY+21,0);Citaj(12,SvetloModra);
        for p2:=1 to Length(pomSubor.Name) do       {DownCase}
          if Ret[p2] in ['A'..'Z'] then Ret[p2]:=Chr(Ord(Ret[p2])+32);
        ASubor.Name:='';
        for p1:=1 to PocetSub do
          if Ret=Adresar[p1].Name then ASubor:=Adresar[p1];
        if ASubor.Name='' then begin
          Nastav(APosX+5,APosY+19,0);VyplnPlochu(Sirka-10,12);
          Nastav(APosX+7,APosY+21,0);VypisPriehladne('*.'+Filter,SvetloModra);
        end;
        ZapniKurzorMysi;
      end;
      2:begin         {priamy vyber suboru}
        AktSub:=HornySub+(pomy-APosY-36) div 8;
        ASubor:=Adresar[AktSub];
        if ASubor.Attr and Directory=0 then begin
          Nastav(APosX+5,APosY+19,0);VyplnPlochu(Sirka-10,12);
          Nastav(APosX+7,APosY+21,0);VypisPriehladne(Adresar[AktSub].Name,SvetloModra);
        end;
      end;
      3:if HornySub>1 then begin {posun dole}
        ZmazCiarku;
        Dec(HornySub);
        VypisSubory;
      end;
      4:if HornySub<PocetSub-7 then begin {posun hore}
        ZmazCiarku;
        Inc(HornySub);
        VypisSubory;
      end;
    end;
    if (UdalostIn=3) or (UdalostIn=4) then Delay(150);
    if UdalostIn=2 then CakajNaPustenie;
    if ASubor.Attr and Directory>0 then begin
      ZmazCiarku;
      ChDir(ASubor.Name);
      NacitajSubory(Filter);
      VypisSubory;
      ASubor.Name:='';
      ASubor.Attr:=0;
      Nastav(APosX+5,APosY+19,0);VyplnPlochu(Sirka-10,12);
      Nastav(APosX+7,APosY+21,0);VypisPriehladne('*.'+Filter,SvetloModra);
    end;
  until UdalostIn>=5;
  if UdalostIn=6 then ASubor.Name:='';
end;
procedure ZmazKurzor;assembler;
asm
             mov ax,0000h        {zmaz kurzor}
             mov di,Adresa
             mov bx,320*8        {BX - posun offsetu od DI}
@DalsiRiadoQ:sub bx,320
             mov word[es:di+bx],ax
             jnz @DalsiRiadoQ
end;
procedure Citaj(Dlzka,Odtien:byte);assembler;
var Stot,Sek:byte;
asm
             lea si,Ret
             mov byte[si],0
             mov ax,VSeg
             mov es,ax
             cld
             mov Stot,0
             mov Sek,0
             mov si,0
{ ----- hlavny cakaci cyklus ----- }
@Cakaj:      mov ah,1           {if keypressed}
             int 16h            {znak je v AL}
             jnz @VypisPismeno
             mov ah,2Ch         {zisti systemovy cas}
             int 21h
             cmp Sek,dh         {prechod cez zmenu sekund}
             je @Pokracuj0
             add dl,100
@Pokracuj0:  cmp Stot,dl
             ja @Cakaj   { ----- navrat do cakania, nic sa nedeje}
{ ----- blikanie kurzora ----- }
             mov Sek,dh
             add Stot,20
             cmp Stot,120
             jb @OK
             mov Stot,0
@OK:         xor si,1            {prekresli kurzor}
             test si,1           {if SI=0}
             je @Zapnuty
             mov ax,0000h        {zmaz kurzor}
             jmp @Pokracuj
@Zapnuty:    mov ax,1F1Fh        {vykresli kurzor}
@Pokracuj:   mov di,Adresa
             mov bx,320*8        {BX - posun offsetu od DI}
@DalsiRiadok:sub bx,320
             mov word[es:di+bx],ax
             jnz @DalsiRiadok
             jmp @Cakaj   { ----- navrat do cakania, bol prepisany kurzor }
{ ----- spracovanie Enter,Esc  a nepustenie dalej ----- }
@VypisPismeno:mov ah,0
             int 16h
             cmp al,1Bh  {Esc}
             je @Zmaz
             cmp al,0Dh  {Enter}
             je @Koniec
             cmp al,08h  {BkSp}
             je @SpracujBkSp
             lea si,Ret
             mov dl,byte[si]
             cmp dl,Dlzka
             jae @Cakaj    { ----- navrat do cakania, je vela znakov}
{ ----- vypisovanie pismena ----- }
             lea si,Ret
             inc byte[si]
             mov bl,byte[si]
             xor bh,bh
             mov byte[si+bx],al
             mov cl,al
             call ZmazKurzor
             mov al,cl
@SpracujPism:lea si,Font
             xor ah,ah
             shl ax,6
             add si,ax    {zdrojovy offset pre pismeno}
             mov di,Adresa{cielovy offset}
             mov cx,0
@DalsiBod:   mov al,byte[si]
             and al,$0F
             jz @Nekresli
             mov al,Odtien
             shl al,4
             add al,byte[si]
             mov [es:di],al
@Nekresli:   inc si
             inc di
             inc cx
             test cl,00000111b
             jnz @Pokracuj3
             add di,312
@Pokracuj3:  cmp cx,63
             jbe @DalsiBod
             add Adresa,8
             jmp @Cakaj   { ----- navrat do cakania, bolo vypisane pismeno}
{ ----- spracovanie BkSp ----- }
@SpracujBkSp:lea si,Ret
             cmp byte[si],0
             je @Cakaj    { ----- navrat do cakania, uz dalej nie je mozne mazat}
             call ZmazKurzor
             mov bx,8
             mov ax,0
             sub Adresa,8
             mov di,Adresa
@DalsiW:     mov cx,4
         rep stosw
             add di,312
             dec bx
             cmp bx,0
             jne @DalsiW
             lea si,Ret
             dec byte[si]
             jmp @Cakaj { ----- navrat do cakania, zmazany znak}
@Zmaz:       lea si,Ret  {zmazanie retazca}
             mov byte[si],0
@Koniec:     call ZmazKurzor
end;
procedure PripravPozadie(RozX,RozY:word;Farba:byte;var ObrazUkaz:pointer);
var ObrazSeg,p1:word;
begin
  GetMem(ObrazUkaz,RozX*RozY+16);
  ObrazSeg:=Seg(ObrazUkaz^)+1;
  MemW[ObrazSeg:0]:=RozX;
  MemW[ObrazSeg:2]:=RozY;
  for p1:=4 to RozX*RozY+4 do Mem[ObrazSeg:p1]:=Random(16)+16*Farba;
end;

procedure ZlikvidujPozadie(ObrazUkaz:pointer);
var RozX,RozY:word;
begin
  RozX:=MemW[Seg(ObrazUkaz^)+1:0];
  RozY:=MemW[Seg(ObrazUkaz^)+1:2];
  FreeMem(ObrazUkaz,RozX*RozY+16);
end;

procedure PriemerujBitmapu(ObrazUkaz:pointer);
var RozX,RozY,ObrazSeg:word;
begin
  ObrazSeg:=Seg(ObrazUkaz^)+1;
  RozX:=MemW[ObrazSeg:0];
  RozY:=MemW[ObrazSeg:2];
  asm
             cld
             push ds
             xor bx,bx          {pocitadlo v riadku}
             mov si,4           {cez SI sa citaju body}
             mov di,RozX
             add di,5           {a uklada do bodu s adresou DI }
             mov cx,RozY        {pocitadlo v stlpci}
             sub cx,2
             mov dx,RozX
             mov ax,ObrazSeg
             mov ds,ax
             mov es,ax
@DalsiRiadok:
@DalsiBod:     xor ah,ah
               mov al,byte[si]
               add al,byte[si+1]
               adc ah,0
               add al,byte[si+2]
               adc ah,0
               add si,dx         {na dalsi riadok}
               add al,byte[si]
               adc ah,0
               add al,byte[si+2]
               adc ah,0
               add si,dx         {na dalsi riadok}
               add al,byte[si]
               adc ah,0
               add al,byte[si+1]
               adc ah,0
               add al,byte[si+2]
               adc ah,0
               shr ax,3          {uz je spriemerovane}

               adc al,0
               stosb

               sub si,dx         {£prava SI a smycka DalsiBod}
               sub si,dx
               inc si
               inc bx
               cmp bx,dx
               jb @DalsiBod

             xor bx,bx            {prechod na dalsi riadok}
             loop @DalsiRiadok
             pop ds
  end;
end;
Procedure StmavBitmapu(ObrazUkaz:pointer);
var ObrazSeg,Kolko:word;
begin
  ObrazSeg:=Seg(ObrazUkaz^)+1;
  Kolko:=MemW[ObrazSeg:0]*MemW[ObrazSeg:2];
  asm
             cld
             mov es,ObrazSeg
             mov di,4
             mov cx,Kolko
@DalsiBod:   mov al,byte[es:di]
             mov ah,al
             and ah,0F0h
             and al,00Fh
             shr al,1
             add al,ah
             stosb
             loop @DalsiBod
  end;
end;  { StmavBitmapu }


procedure PreklopBitmapu(RozX,RozY,Zdroj:word;Smer:shortint);assembler;
asm
             cld            {inicializacia ES,SI,DI,CX,DX}
             mov ax,ds
             mov es,ax
             mov dx,RozY
             mov cx,RozX
             mov si,Zdroj
             mov di,Zdroj
             cmp Smer,-2
             jne @NieVodor
{----- preklapanie okolo vodorovnej osi ----- }
             mov ax,RozX
             mul dx
             sub ax,RozX      {offset ciela}
             add di,ax
             mov dx,RozY
             shr dx,1
@DalsiBod1:  mov al,byte[di]
             movsb
             mov byte[si-1],al  {vymena a posun indexovych registrov}
             loop @DalsiBod1
             sub di,RozX
             sub di,RozX
             mov cx,RozX
             dec dx
             jnz @DalsiBod1
             jmp @Hotovo
{ ----- preklapanie okolo zvislej osi ----- }
@NieVodor:   cmp Smer,2
             jne @NieZvis
             add di,RozX
             dec di
             shr cx,1    {priprava registrov}
             mov bx,cx
@DalsiBod3:  mov al,byte[di]
             movsb
             mov byte[si-1],al
             sub di,2
             loop @DalsiBod3
             add si,RozX
             add di,RozX
             sub si,bx
             add di,bx
             mov cx,bx
             dec dx
             jnz @DalsiBod3
             jmp @Hotovo
{ ----- otacanie proti smeru hodinovych ruciciek ----- }
@NieZvis:    cmp Smer,-1
             jne @ProtiSmeru
             mov bx,Zdroj
@DalsiBod2:  mov al,byte[si]
             mov ah,byte[di]
             mov byte[si],ah
             mov byte[di],al
             inc si
             add di,RozX
             loop @DalsiBod2
             add bx,RozX
             inc bx
             mov si,bx      {nova adresa}
             mov di,bx
             mov cx,dx      {presuvaj menej bajtov}
             dec cx
             dec dx
             jnz @DalsiBod2
             jmp @Hotovo
{ ----- preklapanie okolo vedlajsej diagonaly ----- }
@ProtiSmeru: cmp Smer,1
             jne @Hotovo
             add si,RozX  {priprava registrov}
             add di,RozX
             dec si
             dec di
             mov bx,di
@DalsiBod4:  mov al,byte[si]
             mov ah,byte[di]
             mov byte[si],ah
             mov byte[di],al
             dec si
             add di,RozX
             loop @DalsiBod4
             dec dx
             add si,RozX   {nova adresa SI}
             add si,dx
             mov di,si     {nova adresa DI}
             mov cx,dx     {presuvaj menej bajtov}
             cmp dx,0
             jne @DalsiBod4
@Hotovo:
end;
procedure PosunVRamDole(oKolko:word);assembler;
asm
             std
             push ds
             mov ax,VSeg
             mov es,ax
             mov ds,ax
             mov ax,oKolko
             mov cx,320
             mul cx
             mov si,63998
             sub si,ax
             mov di,63998
             mov cx,32000
             shr ax,1
             mov dx,ax    {odloz si tam pocet bajtov}
             sub cx,dx
         rep movsw
             cld
             mov di,0
             mov cx,dx
             mov ax,0
         rep stosw
             pop ds
end;

BEGIN
END.