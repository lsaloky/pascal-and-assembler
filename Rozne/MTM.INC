const IMS:string='Ovl dac mysi$nie je nainstalovany.$Typ mysi:$dvojtlacidlova$trojtlacidlova$Mouse Systems  $'+
'';

const{skrat retazce na potrebnu dlzku!!!}
s:string=' Syst‚m Disky Vstupy/vystupy Pr¡davn‚ÿzariadenia R“zne';
VypisInfoS1:string='Testovac¡ program$Firma: MukoSoft$Program tor: Lubos Saloky$Ak‚kolvek pripomienky$adresuj na '+
                   'tel.c¡slo$(095)63 381 34$alebo na E-mail adresu:$saloky@duro.upjs.sk';
TextKoniec:string='Chces naozaj skoncit?$ÚÄÄÄÄÄÄÄÄÄ¿     ÚÄÄÄÄÄÄÄÄÄ¿$³   Ano   ³     ³   Nie   ³$ÀÄÄÄÄÄÄÄÄÄÙ     ÀÄÄÄÄÄÄÄÄÄÙ$';
Klavesnica:string='Stav pr¡znakovych kl ves a preradovacov:$Scroll Lock$Num Lock$Caps Lock$Pravy Shift$Lavy Shift$Ctrl'+
'$Alt$Skus stl cat preradovace a pr¡znakov‚ kl vesy.$svieti $vypnuty$stlaceny$pusteny ';
BocneTexty:array[1..20] of string[31]=('Z kladn  doska$','Pam„t$','Grafika$','CMOS$',
                                       'Logick  charakteristika$','Fyzick  charakteristika$','Dodatocn‚ inform cie$','$',
                                       'Porty$','Mys$','Kl vesnica$','Multim‚dia$',
                                       'Tlaciaren a modem$','Monitor$','$','$',
                                       'Inform cie o programe$','Z verecn  spr va$','Koniec programu$','$');
info:array[1..3]of string[80]=(' Polozku v hornom menu zvol mysou alebo kl vesou s pr¡slusnym velkym pismenom',
                               ' Polozku v bocnom menu zvol mysou alebo kl vesami 1,2,3,4,5.',
                               ' Klikni na Ano alebo Nie, alebo stlac a/n');

klav:array[1..6]of char=('s','d','v','p','r',#255);
roz:array[1..5,1..10] of byte=((3,54,3,17,18,4,8,12,255,255),
                               (3,46,3,17,26,5,11,255,255,255),
                               (5,51,4,15,17,3,7,11,255,255),
                               (5,47,3,15,21,4,8,12,255,255),
                               (4,32,4,11,24,3,7,255,255,255));
var volba{od 2},klavesa,zmena,pomb1:byte;
    volba2{od 5},tlacidlo,KlavOfs,__CX__,pom1,pom2,pom3:word;
procedure UmiestniRiadok;assembler;{pouziva AX,CX,SI,DI}
{SI offset retazca, DX suradnice, CL dlzka retazca}
asm
             inc si
             mov al,dh
             mov ch,160
             mul ch
             xor ch,ch
             xor dh,dh
             shl dl,1
             add ax,dx
             mov di,ax
             cmp di,4000
             ja @Nepis
             xor ah,ah
@DalsiZnak:  movsb
             inc di
             loop @DalsiZnak
@Nepis:
end;
procedure ZapniTextovyKurzor;assembler;
asm
             mov cx,__cx__;
             mov ah,1;
             int $10;
end;
procedure VypniTextovyKurzor;assembler;
asm
             mov ah,3;
             mov bh,0;
             int $10;
             mov __cx__,cx;
             mov ch,1;
             mov cl,0;
             mov ah,1;
             int $10;
end;
procedure ObsluzKlavesnicu;assembler;
asm
             mov zmena,0
             mov ah,1       {keypressed}
             int 16h
             jz @Nestlacena
             mov ah,0       {readkey}
             int 16h
             lea si,klav
             dec si
             mov cx,6
@DalsiAdept: inc si         {test klaves v hornom menu}
             cmp al,byte[si]
             loopne @DalsiAdept
             cmp cx,0
             je @BocneMenu
             mov ah,7
             sub ah,cl
             mov volba,ah
             mov volba2,5
             mov zmena,1
             jmp @Koniec
@BocneMenu:  sub al,44
             cmp al,5
             jb @Nestlacena {rozsah cislic 1-5}
             cmp al,9
             ja @Nestlacena
             xor ah,ah
             mov bx,ax
             cmp byte[si+bx-1],255
             je @Nestlacena
             mov volba2,bx
             mov ah,1
             jmp @Koniec
@Nestlacena: mov ah,0
@Koniec:
end;
procedure ObsluzMys;assembler;
asm
             mov zmena,0
             mov ax,3      {zistenie suradnic mysi}
             int 33h
             test bx,0FFF7h{test stlacenia tladidla}
             jz @Nekliknute
             cmp dx,0
             jne @BocneMenuM
             shr cx,2      {test, ci klikol na napis}
             mov di,cx
             cmp byte[es:di],20h
             je @Nekliknute
             mov bx,di     {ktora polozka bola zvolena?}
             xor di,di
             mov cx,160
             mov ax,0020h  {hladany bajt,AH pocitadlo}
@Index:repne scasb
             inc ah
             cmp bx,di
             ja @Index
             mov volba,ah
             mov volba2,5
             mov zmena,1
             mov ah,1
             jmp @KoniecM
@BocneMenuM: shr cx,3           {uprav suradnice}
             shr dx,3
             mov si,KlavOfs
             mov al,byte[si]
             add al,byte[si+4]
             dec al
             cmp cl,al
             ja @KoniecM        {pravy okraj aktivnej oblasti}
             cmp cl,byte[si]
             jb @KoniecM        {lavy okraj}
             mov al,byte[si+2]
             add al,byte[si+3]
             inc al
             cmp dl,al
             ja @KoniecM        {dolny okraj}
             cmp dl,byte[si+2]
             jb @KoniecM        {horny okraj}
             sub dl,byte[si+2]
             mov bx,4
@DalsiIndex: inc bx             {ktory ramcek si zvolil?}
             cmp dl,byte[si+bx]
             ja @DalsiIndex
             mov volba2,bx
             mov ah,1
             jmp @KoniecM
@Nekliknute: mov ah,0
@KoniecM:
end;
procedure VyberVHornomMenu;assembler;
asm
             call ObsluzKlavesnicu{test, ci je stlacena klavesa}
             cmp ah,0
             jne @KoniecVyberu
             call ObsluzMys       {test, ci je kliknute}
{ ----- uz je zistena uzivatelova odozva v AH-1}
@KoniecVyberu:
end;
procedure CakajNaUvolnenieTlacidla;assembler;
asm
@Cakanie:    mov ax,3      {cakanie na uvolnenie tlacidla}
             int 33h
             test bx,0FFF7h{test stlacenia tladidla}
             jnz @Cakanie
end;
procedure PodmienecneZmazanieObrazovky;assembler;
asm
             cmp zmena,0
             je @Nezmaz
             mov di,160           {zmazanie obrazovky}
             mov cx,1680
             mov ax,07B0h
         rep stosw
@Nezmaz:
end;
procedure VypniKurzorMysi;assembler;
asm
             mov ax,2
             int 33h
end;
procedure ZapniKurzorMysi;assembler;
asm
             mov ax,1
             int 33h
end;
procedure DvojitaCiara;assembler;
asm
             mov cl,byte[si+4]
             dec cl
             mov ax,3FCDh
         rep stosw
             mov ax,3FBAh
             stosw
end;
procedure JednoduchaCiara;assembler;
asm
             mov cl,byte[si+4]
             dec cl
             mov ax,7FC4h
         rep stosw
             mov ax,3FBAh
             stosw
end;
procedure VypisRiadok;assembler;{pouziva AX,CX}
{SI adresa retazca(nulty znak),DI offset ciela,AL atribut,AH dlzka ramceka}
asm
             cmp di,4000
             ja @Nepis
             mov cl,byte[si]{pocet znakov retazca}
             inc si
             xor ch,ch
             sub ah,cl
@DalsiZnak:  movsb          {vypis retazca}
             stosb
             loop @DalsiZnak
             mov cl,ah      {vypis medzier za nim}
             xor ch,ch
             mov ah,al
             mov al,20h
         rep stosw
@Nepis:
end;
procedure KresliRamcek;assembler;{pouziva AX,BX,CX,DX,SI,DI}
asm
             call VypniKurzorMysi
             mov cl,10             {vypocet offsetu dat}
             mov al,volba
             mul cl
             sub ax,20
             lea si,roz
             add si,ax
             mov KlavOfs,si
             mov al,byte[si+2]    {vypocet offsetu ramceka}
             mov dl,160
             mul dl
             add al,byte[si]
             add al,byte[si]
{ ----- horny okraj ----- }
             mov di,ax              {lavy horny roh jednoducha}
             mov bx,ax
             xor ch,ch
             cmp volba2,5
             je @HoreDvojita
             mov ax,7FDAh
             stosw
             call JednoduchaCiara
             sub di,2
             mov ax,3FC9h
             stosw
             jmp @HorePokr
@HoreDvojita:mov ax,3FC9h           {hore dvojita}
             stosw
             mov cl,byte[si+4]
             mov ax,3FCDh
         rep stosw
@HorePokr:   mov cl,byte[si+1]      {horny okraj 2}
             mov ax,3FCDh
         rep stosw
             mov ax,3FBBh           {pravy horny roh}
             stosw
{ ----- stredna cast ----- }
             mov dh,0
@DalsiRiadok:add bx,160             {vnutro obdlznika}
             mov di,bx
             mov cl,byte[si+4]
             mov ax,si
             add si,volba2
{ ----- rozhodovanie medzi jednotlivymi typmi ciar ----- }
             cmp dh,byte[si]        {kontrola tvaru ÈÍ}
             je @JeDvojitaH
             cmp dh,byte[si-1]      {kontrola tvaru ÉÍ}
             je @JeDvojitaD
             cmp dh,byte[si]        {kontrola tvaru º}
             jb @DruhaPodm
             jmp @NastavSI
@DruhaPodm:  cmp dh,byte[si-1]
             ja @JeDvojVn
             cmp volba2,5           {kontrola tvaru º pre prvy riadok}
             jne @NastavSI
             mov si,ax
             cmp dh,byte[si+5]
             jb @JeDvojVn
@NastavSI:   mov si,ax
             cmp dh,byte[si+5]      {kontrola tvaru ÃÄ}
             je @JeCiara
             cmp dh,byte[si+6]
             je @JeCiara
             cmp dh,byte[si+7]
             je @JeCiara
             cmp dh,byte[si+8]
             je @JeCiara
             cmp dh,byte[si+9]
             je @JeCiara
{ ----- uz je rozhodnute ----- }
             mov si,ax
             mov ax,7FB3h           {lavy okraj, ak nie je ciara}
             stosw
             mov cl,byte[si+4]
             dec cl
             mov ax,7F20h
         rep stosw
             mov ax,3FBAh
             stosw
             jmp @Pokracuj
@JeDvojitaD: mov si,ax
             mov ax,3FC9h            {dvojita ohnuta dole}
             stosw
             mov cl,byte[si+4]      {vnutro dvojita ciara, ohni hore}
             dec cl
             mov ax,3FCDh
         rep stosw
             mov ax,3FBCh
             stosw
             jmp @Pokracuj
@JeDvojitaH: mov si,ax
             mov ax,3FC8h            {dvojita ohnuta hore}
             stosw
             mov cl,byte[si+4]      {vnutro dvojita ciara, ohni dole}
             dec cl
             mov ax,3FCDh
         rep stosw
             mov ax,3FBBh
             stosw
             jmp @Pokracuj
@JeDvojVn:   mov si,ax
             mov ax,3FBAh            {dvojita na zaciatku, zelene vnutro}
             stosw
             mov cl,byte[si+4]
             mov ax,3F20h
         rep stosw
             jmp @Pokracuj
@JeCiara:    mov si,ax
             mov ax,7FC3h           {lavy okraj, ak je ciara}
             stosw
             call JednoduchaCiara   {vnutorna ciara}
             jmp @Pokracuj
@Pokracuj:   mov ax,3F20h
             mov cl,byte[si+1]     {pokracovanie vnutra bez ciary}
         rep stosw
             mov ax,3FBAh           {pravy okraj}
             stosw
             inc dh
             cmp dh,byte[si+3]
             jb @DalsiRiadok
{ ----- dolny okraj ----- }
             add bx,160
             mov di,bx
             mov ax,si
             add si,volba2
             cmp byte[si],255   {test, ci tam ma byt dvojita ciara}
             je @DvojitaDole
             mov si,ax
             mov ax,7FC0h           {dolny lavy roh}
             stosw
             call JednoduchaCiara   {dolny okraj 1}
             sub di,2
             mov ax,3FC8h
             stosw
             jmp @DalejDole
@DvojitaDole:mov si,ax
             mov ax,3FC8h
             stosw
             call DvojitaCiara
             sub di,2
             mov ax,3FCDh
             stosw
@DalejDole:  mov cl,byte[si+1]     {dolny okraj 2}
             mov ax,3FCDh
         rep stosw
             mov ax,3FBCh           {dolny pravy roh}
             stosw
             lea bx,BocneTexty
{ ----- vypis textov ----- }
             xor ah,ah
             mov al,volba
             sub al,2
             shl al,2
             shl ax,5
             lea si,BocneTexty
             add si,ax
             mov pom1,si           {do pom1 aktualna adresa v poli BocneTexty}
             lea si,roz
             xor ah,ah
             mov al,volba
             sub al,2
             mov cl,10
             mul cl
             add si,ax
             mov pom2,si            {do pom2 aktualna adresa v poli roz}
             mov pom3,0             {pom3 pocitadlo}
@DalsiNapis: mov ah,02              {nastav kurzor}
             mov si,pom2
             mov dl,[si]
             add dl,2
             mov dh,[si+2]
             mov bx,pom3
             mov ch,[si+bx+5]
             cmp ch,255
             jne @Povodne
             mov ch,[si+2]
             add ch,[si+3]
             sub ch,4
@Povodne:    add dh,ch
             dec dh
             mov bh,0
             int 10h
             mov ah,9               {vypis retazca}
             mov dx,pom1
             mov cx,pom3
             shl cx,5
             add dx,cx
             inc dx
             int 21h
             inc pom3
             cmp pom3,4
             jb @DalsiNapis
             call ZapniKurzorMysi
end;
procedure VypisInfo;assembler;
asm
             lea si,VypisInfoS1
             mov dx,0524h         {suradnice}
             mov cx,17            {pocet znakov}
             call UmiestniRiadok
             mov dx,0726h
             mov cx,15
             call UmiestniRiadok
             mov dx,0820h
             mov cx,25
             call UmiestniRiadok
             mov dx,0A1Eh
             mov cx,21
             call UmiestniRiadok
             mov dx,0B1Eh
             mov cx,20
             call UmiestniRiadok
             mov dx,0C27h
             mov cx,14
             call UmiestniRiadok
             mov dx,0E1Eh
             mov cx,23
             call UmiestniRiadok
             mov dx,0F23h
             mov cx,19
             call UmiestniRiadok
             mov ah,02h   {umiestni kurzor}
             mov dx,091Eh
             mov bh,0
             int 10h
             mov ah,0Ah   {vypis pomlcky}
             mov al,'-'
             mov bx,0037h
             mov cx,30
             int 10h
end;
procedure SkonciToTrapenie;assembler;
asm
             lea si,TextKoniec
             mov dx,0721h
             mov cx,21
             call UmiestniRiadok
             mov dx,0A1Fh
             mov cx,27
             call UmiestniRiadok
             mov dx,0B1Fh
             mov cx,27
             call UmiestniRiadok
             mov dx,0C1Fh
             mov cx,27
             call UmiestniRiadok
             lea si,info
             add si,162
             mov di,3840
             mov ax,501Eh
             call VypisRiadok
@Test:       mov ah,1
             int 16h
             jz @TestMysi
             mov ah,0
             int 16h
             cmp al,'a'
             je @Koniec
             cmp al,'n'
             je @Neskonci
             jmp @Test
@TestMysi:   mov ax,3
             int 33h
             test bx,0FFF7h
             jz @Test
             cmp dx,80
             jb @Test
             cmp dx,96
             ja @Test
             cmp cx,248
             jb @Test
             cmp cx,456
             ja @Test
             cmp cx,328
             ja @Podm2
{ ----- ukoncenie programu ----- }
@Koniec:     call VypniKurzorMysi
             mov ax,0700h
             mov cx,2000
             xor di,di
         rep stosw
             call ZapniKurzorMysi
             mov ax,4C00h
             int 21h
@Podm2:      cmp cx,376
             jb @Test
@Neskonci:   mov volba2,5
             lea si,info   {vypis dolneho riadka}
             add si,81
             mov di,3840
             mov ax,501Eh
             call VypisRiadok
             call VypniKurzorMysi
             call KresliRamcek
             call ZapniKurzorMysi
end;
procedure InfoOKlavesnici;assembler;
asm
             lea si,Klavesnica          {vypis uvodnych textov}
             mov dx,0518h
             mov cx,40
             call UmiestniRiadok
             mov dx,0719h
             mov cx,11
             call UmiestniRiadok
             mov dx,0819h
             mov cx,8
             call UmiestniRiadok
             mov dx,0919h
             mov cx,9
             call UmiestniRiadok
             mov dx,0A19h
             mov cx,11
             call UmiestniRiadok
             mov dx,0B19h
             mov cx,10
             call UmiestniRiadok
             mov dx,0C19h
             mov cx,4
             call UmiestniRiadok
             mov dx,0D19h
             mov cx,3
             call UmiestniRiadok
             mov dx,0F18h
             mov cx,46
             call UmiestniRiadok
             lea si,Klavesnica
@ZnovaTest:  call VyberVHornomMenu
             cmp volba,4
             jne @Koniec
             cmp volba2,7
             jne @Koniec
             mov pomb1,0FFh
@Testuj:     mov ah,02h
             int 16h
             cmp pomb1,al
             je @ZnovaTest
             lea si,Klavesnica
             mov pomb1,al
             test pomb1,10h         {test ScrollLock}
             jnz @Vypnuty1
             add si,8
@Vypnuty1:   add si,151
             mov dx,0729h
             mov cx,7
             call UmiestniRiadok
             lea si,Klavesnica
             test pomb1,20h          {test NumLock}
             jnz @Vypnuty2
             add si,8
@Vypnuty2:   add si,151
             mov dx,0829h
             mov cx,7
             call UmiestniRiadok
             lea si,Klavesnica
             test pomb1,40h          {test CapsLock}
             jnz @Vypnuty3
             add si,8
@Vypnuty3:   add si,151
             mov dx,0929h
             mov cx,7
             call UmiestniRiadok
             lea si,Klavesnica
             test pomb1,01h          {test praveho Shiftu}
             jnz @Uvolneny1
             add si,9
@Uvolneny1:  add si,167
             mov dx,0A29h
             mov cx,8
             call UmiestniRiadok
             lea si,Klavesnica
             test pomb1,02h          {test laveho Shiftu}
             jnz @Uvolneny2
             add si,9
@Uvolneny2:  add si,167
             mov dx,0B29h
             mov cx,8
             call UmiestniRiadok
             lea si,Klavesnica
             test pomb1,04h          {test Ctrl}
             jnz @Uvolneny3
             add si,9
@Uvolneny3:  add si,167
             mov dx,0C29h
             mov cx,8
             call UmiestniRiadok
             lea si,Klavesnica
             test pomb1,08h          {test Alt}
             jnz @Uvolneny4
             add si,9
@Uvolneny4:  add si,167
             mov dx,0D29h
             mov cx,8
             call UmiestniRiadok
             jmp @ZnovaTest
@Koniec:
end;
procedure InfoOMysi;assembler;
asm
             mov ax,0
             int 33h
             mov ax,1
             int 33h
             mov pom1,ax
             mov pom2,bx
             lea si,IMS   {vypis uvodnych textov}
             mov dx,0518h
             mov cx,12
             call UmiestniRiadok
             mov dx,0529h
             cmp pom1,0
             jne @JeMys
             mov dx,0525h
             mov cx,3
             call UmiestniRiadok
             mov dx,052Dh
             sub si,4
@JeMys:      add si,4
             sub dx,4
             mov cx,17
             call UmiestniRiadok
             cmp pom1,0
             je @KoniecM
             mov dx,0618h
             mov cx,9
             call UmiestniRiadok
             cmp pom2,0h
             jne @TestDalsi1
             add si,15
@TestDalsi1: cmp pom2,3
             jne @TestDalsi2
             add si,30
@TestDalsi2: mov dx,0622h
             mov cx,14
             call UmiestniRiadok
@KoniecM:
end;
