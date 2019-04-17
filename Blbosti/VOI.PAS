program Demo_s_rutinou_pre_cakanie_na_vertikalny_obnovovaci_impulz;
BEGIN
  asm
       cld
       mov ax,0013h
       int 10h       {nastavenie gr. modu 320 x 200 x 256}
       mov ax,$A000
       mov es,ax
       mov di,0      {ES:DI ukazuje na zaciatok VIDEORAM}
@skok: mov ax,0000h
       mov cx,160
   rep stosw         {zmazanie predosleho riadka}
       mov ax,9999h
       mov cx,160
   rep stosw         {nakreslenie riadka}
       sub di,320
       mov dx,03DAh  {tu zacina cakanie na VOI}
@vz1:  in al,dx
       and al,08h
       jnz @vz1
@vz2:  in al,dx
       and al,08h
       jz @vz2       {koniec cakania}
       cmp di,64000
       jb @skok      {dalsia ciara}
       mov di,0
       mov ah,1
       int 16h
       jz @skok
       mov ax,0003h
       int 10h       {nastav textovy mod}
  end;
END.