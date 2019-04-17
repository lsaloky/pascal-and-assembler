program Sluzby_DOSu_a_BIOSu_pre_pracu_so_sektormi;
var buffer:array[1..512] of byte;
{BIOS - cislovanie povrchov od 0, stop od 0, sektorov od 1
 DOS  - logicke cislo: 0 = 0. povrch, 0. stopa, 1. sektor
        stupa v priorite sektor -> povrch -> stopa
 DOS sektor 0=BIOS sektor 1
 Priklad: disketa s 2 povrchmi, 9 sektormi, 40 stopami
        Logicke cislo sektoru 8, stopa 1, povrch 1 je 18+9+8-1=34
        (pocet sektorov na 0.stope+pocet sektorov na 1. stope a 0. povrchu+
        +cislo sektora-1

 Chybove hlasenie sa vracia v AL - DOS, AH - BIOS
 Chybove kody BIOSu:
 00h bez chyby                        05h chyba pri resetovani radica
 01h zly prikaz                       08h chyba DMA
 02h zla znacka zaciatku sektora      09h zapis cez 64KB (DMA)
 03h disketa chranena proti zapisu    10h zly CRC
 04h sektor nenajdeny                 40h stopa nenajdena
                                      80h jednotka nie je pripravena
 Chybove kody DOSu:NG  -> Interrupts & Ports -> Tables -> DOS Error Codes}
procedure Chyba;
begin
  writeln('Chyba!!!');
end;
BEGIN
  {Citanie sektora cez DOS - funguje len pre DISKETU}
  asm
     mov al,0             {Zariadenie: 0=A, 1=B, ...}
     mov cx,1             {pocet sektorov}
     mov dx,0             {logicke cislo 1. sektora}
     mov bx, offset buffer{DS:BX adresa buffra}
     int 25h
     jnc @OK
     call Chyba
@OK: popf                  {povodne FLAGS vyber zo zasobnika}
  {Zapis sektora cez DOS - funguje len pre DISKETU}
     mov al,0
     mov cx,1
     mov dx,1
     mov bx,offset buffer
     int 26h
     jnc @OK2
     call Chyba
@OK2:popf
  {Informacie o disku cez BIOS}
     mov ah,08h
     mov dl,0   {0 pre disketu, 80h pre pevny disk}
     int 13h
    {teraz je stav registrov: CF=1 - chyba, DL - pocet zariadeni na radici,
     DH - pocet povrchov-1, CX - dolnych 6 bitov pocet stop, hornych 10 pocet
     valcov-1, BL typ disk. j.: 1=360KB,2=1.2MB,3=720KB,4=1.44MB}
  {Citanie sektora cez BIOS. Nefunguje pre CD.
    Ak nastane chyba, zopakuj to az 3-krat
    Pri cisle valca nad 255 pouzi 2 najvyssie bity CL}
     mov ah,02h
     mov dl,0   {cislo jednotky:0=disketa, 80h=1. disk,81h=2. disk}
     mov dh,0   {cislo povrchu}
     mov ch,0   {cislo stopy}
     mov cl,1   {cislo sektora}
     mov al,1   {pocet sektorov - nesmie byt vacsi ako pocet sektorov na stopu}
     push ds
     pop es
     mov bx,offset buffer {ES:BX adresa buffra}
     int 13h
     jnc @OK3
     call Chyba
@OK3:{Zapis sektora cez BIOS - nefunguje pre CD}
     mov ax,0301h
     mov dx,0000h
     mov cx,0002h
     push ds
     pop es
     mov bx,offset buffer
     int 13h
     jnc @OK4
     call Chyba
@OK4:
  end;
END.