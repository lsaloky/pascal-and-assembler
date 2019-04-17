unit SBlaster;
                                interface
{ ----- konstanty pouzivane pri nastavovani hlasitosti ----- }
const SBMaster=$22;
      SBFM=$26;
      SBLine=$2E;
      SBCD=$28;
      SBVoice=$04;

procedure InicializujSB(CisloPortu:word);           {toto musis zavolat}
procedure NastavHlasitost(Co,Lavy,Pravy:byte);
procedure PustWav(p:pointer);                       {asi cez DMA kanal 1}

                               implementation
var CP:word; { Cislo portu }
procedure InicializujSB(CisloPortu:word);assembler;
var StaryCas:word;
asm
             mov ax,0040h         {Bios Segment - na pocitanie casoveho intervalu}
             mov es,ax
             mov dx,CisloPortu
             mov CP,dx            {uloz CisloPortu}
             add dx,4
             xor al,al
{!!!!!}        {     out dx,al    }        {0 -> port 204}
             inc dx
{!!!!!}        {     out dx,al    }        {0 -> port 205}
             inc dx
             inc al
             out dx,al            {1 -> port 206}
             mov ax,word[es:6Ch]
             mov StaryCas,ax
             add StaryCas,3
@Cakaj:      mov ax,word[es:6Ch]
             cmp StaryCas,ax
             jne @Cakaj           {chvilu pockaj}
             xor al,al
             out dx,al            {0 -> port 206}
             mov ax,word[es:6Ch]
             mov StaryCas,ax
             add StaryCas,3
@Cakaj2:     mov ax,word[es:6Ch]
             cmp StaryCas,ax
             jne @Cakaj2
end;
procedure NastavHlasitost(Co,Lavy,Pravy:byte);assembler;
asm
             mov al,Co
             mov dx,CP
             add dx,4
             out dx,al            {riadiaci bajt -> port 204}
             mov al,Lavy
             shl al,4
             add al,Pravy
             inc dx
             out dx,al            {Lavy*16+Pravy -> port 205}
end;
procedure ZapisNaDSP(Hodnota:byte);assembler;
asm
             mov dx,CP
             add dx,12
@Cakaj:      in al,dx
             test al,$80
             jnz @Cakaj
             mov al,Hodnota
             out dx,al
end;
procedure PustWav(p:pointer);assembler;
asm
             mov es,word ptr p+2  {ES:DI je p}
             mov di,word ptr p
             push $00D1
             call ZapisNaDSP
             mov bx,word ptr p+2  {BX - akysi offset}
             shl bx,4
             add bx,word ptr p

             mov cx,word ptr p    {CX - akasi stranka}
             shr cx,4
             add cx,word ptr p+2
             shr cx,12

             mov al,5                     {na porty treba poslat plno}
             out $0A,al {DMA 1 Mask Port} {kadejakych pochybnych}
             mov al,0                     {skaderuka-skadenoha udajov}
             out $0C,al {DMA 1 ClrPtr Port}
             mov al,$49
             out $0B,al {DMA 1 Mode Port}
             mov al,bl
             out $02,al {DMA 1 Base Addr Port}
             mov al,bh
             out $02,al
             mov al,cl
             out $83,al {DMA 1 Page Port}

             mov al,byte[es:di+40]
             dec al
             out $03,al {DMA 1 Count Port}
             mov al,byte[es:di+41]{dlzka WAVu}
             out $03,al
             mov al,1
             out $0A,al
             push $0040
             call ZapisNaDSP

             mov dx,15            {vypocet casovej konstanty: 256-1000000 div Frekvencia}
             mov ax,16960         {DX:AX = 1000000}
             mov cx,word ptr [es:di+24]{frekvencia WAVu}
             div cx
             neg ax
             add ax,256

             push ax              {zapisujes na DSP kadeco}
             call ZapisNaDSP
             push $0014
             call ZapisNaDSP
             xor ah,ah
             mov al,byte ptr [es:di+40]
             push ax
             call ZapisNaDSP
             mov al,byte ptr [es:di+41]
             push ax
             call ZapisNaDSP
end;
BEGIN
END.