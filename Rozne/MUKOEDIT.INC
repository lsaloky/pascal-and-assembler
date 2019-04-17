
{ ----- ZMAZANIE OBRAZOVKY ----- }
procedure ZmazObrazovku;assembler;
asm
             mov es,VSeg
             xor di,di
             mov cx,2000
             mov ax,0F00h
         rep stosw
end;

{ ----- VYPIS TEXTU NA DANU POZICIU ----- }
procedure VypisRetazca;assembler; {SI - adresa struktury}
asm
             mov es,VSeg
             mov al,160
             mul byte ptr[si+1]
             add al,[si]
             adc ah,0
             mov di,ax            {ES:DI -> cielovy offset}
             mov cl,byte ptr[si+2]
             xor ch,ch            {CX - pocet znakov}
             add si,3             {SI -> 1. znak retazca}
             mov ah,12            {AH - aktualny atribut textu}
@Dalsi:      lodsb
             stosw
             loop @Dalsi
end;

{ ----- NASTAVENIE KURZORA ----- }
procedure NastavKurzor;assembler; {DX - pozicia}
asm
             mov ah,02h
             mov bh,0
             mov TempBP,bp
             int 10h
             mov bp,TempBP
end;

{ ----- VYPIS 25 RIADKOV SUBORU ----- }
procedure VypisSubor;assembler;   {pozor pri prekroceni 80 znakov na riadok!}
var Volnych:word;                 {volnych znakov do konca riadka}
    PocetCrLf:byte;               {pocet Enterov, ktore sa este zobrazia}
asm
             lea si,Data
             add si,AktPos
             mov byte ptr PocetCrLf,0
             mov cx,Dlzka
             sub cx,AktPos
             mov Volnych,79       {BX - pocet volnych miest v riadku}
@DalsiZnak:  mov ah,02h
             mov dl,byte ptr [si] {nacitaj znak}
             inc si
             cmp dl,13            {osetri Enter}
             jne @NieNovy
             inc PocetCrLf
             mov Volnych,81       {vratane #10}
@NieNovy:    cmp Volnych,0        {osetri prilis vela znakov v riadku}
             je @Nepis
             dec Volnych
             int 21h
@Nepis:      cmp PocetCrLF,25     {osetri uz zapisanu obrazovku}
             jae @OK
             loop @DalsiZnak
@OK:         mov dx,PosKurz
             call NastavKurzor
end;
{ ----- NASTAVENIE POZICII ZACIATKU A KONCA AKTUALNEHO RIADKA V POLI DATA ----- }
procedure NastavIndexy;assembler;
asm
             cld                  {nastavenie IndexKon}
             mov ax,ds
             mov es,ax
             mov cx,60000
             lea di,Data
             add di,AktPos
             add di,ObrPos
             mov al,13
       repne scasb
             sub di,offset Data   {odcitaj offset zaciatku dat}
             dec di
             mov IndexKon,di

             mov IndexZac,0
             cmp byte ptr PosKurz+1,0
             je @Prvy
             std
             mov cx,60000
             lea di,Data
             add di,AktPos
             add di,ObrPos
             mov al,10
       repne scasb
             sub di,offset Data   {odcitaj offset zaciatku dat}
             add di,2
             mov IndexZac,di
@Prvy:
end;
