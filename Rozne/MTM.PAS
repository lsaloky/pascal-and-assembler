program Univerzalny_program_testujuci_hardware_Mukosoft_TestujMa;
const DiskStr:string=
'Typ disku:$Pocet bajtov v sektore:$Pocet sektorov na stope:$Pocet st“p na povrchu:$Pocet povrchov:$------------'+
'--------$Kapacita disku:';
{$I MTM.INC}
procedure DiskFyzChar;assembler;
asm
             lea si,DiskStr
             mov dx,041Fh
             mov cx,10
             call UmiestniRiadok
             mov dx,061Fh
             mov cx,23
             call UmiestniRiadok
             mov dx,071Fh
             mov cx,24
             call UmiestniRiadok
             mov dx,081Fh
             mov cx,22
             call UmiestniRiadok
             mov dx,091Fh
             mov cx,15
             call UmiestniRiadok
             mov dx,0A35h
             mov cx,20
             call UmiestniRiadok
             mov byte[es:1238],'*'
             mov byte[es:1398],'*'
             mov byte[es:1558],'*'
             mov dx,0B1Fh
             mov cx,15
             call UmiestniRiadok

end;

BEGIN
  asm
{ ----- inicializacia ----- }
             cld
             call VypniTextovyKurzor
             mov ax,0B800h {segment stranky 0}
             mov es,ax
             mov di,0      {zmazanie obrazovky}
             mov cx,2000
             mov ax,07B0h
         rep stosw
             lea si,s      {vypis horneho riadka}
             mov ax,505Fh
             xor di,di
             call VypisRiadok
             lea si,info   {vypis dolneho riadka}
             mov di,3840
             mov ax,501Eh
             call VypisRiadok
             mov ax,1      {inicializacia mysi}
             int 33h
{ ----- uvodna obrazovka,test klavesnice a mysi ----- }
@TakUzSiVyber:call VyberVHornomMenu
             cmp ah,0
             je @TakUzSiVyber
             mov volba2,5
             call KresliRamcek
             lea si,info   {vypis dolneho riadka}
             add si,81
             mov di,3840
             mov ax,501Eh
             call VypisRiadok
{ ----- vypisal sa ramcek,test klavesnice a mysi ----- }
@Hlavny:     call VyberVHornomMenu
             cmp ah,0
             je @Hlavny
             call PodmienecneZmazanieObrazovky
             call KresliRamcek
             call CakajNaUvolnenieTlacidla
@Case1:
@Case2:
@Case3:
@Case4:
@Case5:      cmp volba,3
             jne @Case9

@Case6:      cmp volba2,6
             jne @Case7
             call DiskFyzChar
@Case7:
@Case8:
@Case9:      cmp volba,4
             jne @Case13

@Case10:     cmp volba2,6
             jne @Case11
             call InfoOMysi
@Case11:     cmp volba2,7
             jne @Case12
             call InfoOKlavesnici
@Case12:
@Case13:
@Case14:
@Case15:
@Case16:
@Case17:     cmp volba,6
             jne @CaseEnd
             cmp volba2,5
             jne @Case18
             call VypisInfo
@Case18:
@Case19:     cmp volba2,7
             jne @Case20
             call SkonciToTrapenie
             call VypisInfo
@Case20:
@CaseEnd:    jmp @Hlavny
  end;
END.