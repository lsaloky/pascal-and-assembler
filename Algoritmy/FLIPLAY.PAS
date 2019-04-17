program Prehravanie_FLI;
{$M 16384,0,1024}
const s:string[35]='Zadaj n zov s£boru:$             ';
var FliH:array[0..21] of byte;
    w1,Handle,sseg:word;
    FRMSize:longint;
procedure ZobrazDalsiuSnimku;assembler;
asm
             push di
             push si
             push es
             push ds

             cld
             mov ds,sseg
             mov si,4
             lodsw
             mov cx,ax            {pocet chunkov}
             cmp cx,0
             jnz @JJump
             jmp @eend            {snimok sa nezmenil}
@JJump:      mov si,14
@Main:       push cx
             add si,4             {preskoc dlzku chunku}
             lodsw
             cmp ax,11            {FLIColor}
             jnz @m1
             jmp @FLICol
@m1:         cmp ax,15            {FLIBrun}
             jnz @m2
             jmp @FLIBrun
@m2:         cmp ax,16            {FLICopy}
             jnz @m3
             jmp @FLICopy
@m3:         cmp ax,12            {FLILC}
             jnz @m4
             jmp @FLILC
@M4:         cmp ax,13            {FLIBlack}
             jnz @InaMoznost
             jmp @FliBlack
@InaMoznost: nop
@MainEnd:    pop cx
             loop @Main
             jmp @eend

@FLICol:     mov dx,03DAh
@s1:         in al,dx
             test al,8
             jz @s1
             lodsw                {FLI Color chunk}
             mov bx,ax
             xor ah,ah
@FC1:        lodsb                {kolko farieb sa preskakuje}
             add ah,al
             mov dx,03C8h
             mov al,ah
             out dx,al
             lodsb                {kolko farieb sa zmenilo}
             mov dl,al
             xor dh,dh
             mov cx,dx
             add cx,dx
             add cx,dx
             cmp cx,0
             jnz @fc2
             mov cx,768           {0 = 256 farieb}
@fc2:        add ah,al
             mov dx,03C9h
@Oblb:       lodsb
             out dx,al
             loop @Oblb
             dec bx
             jnz @fc1
             jmp @MainEnd

@FLIBrun:    mov dx,03DAh
@s:          in al,dx             {CakajNaVOI}
             test al,8
             jz @s
             mov ax,0A000h
             mov es,ax
             mov di,0
             mov ah,200
@FB0:        lodsb
             mov bl,al
@FB1:        lodsb
             mov cl,al
             xor ch,ch
             test cl,128
             ja @FFb1
             lodsb
         rep stosb
             jmp @ffb2
@FFb1:       neg cl
         rep movsb
@FFb2:       dec bl
             jnz @FB1
             dec ah
             jnz @fb0
             jmp @MainEnd

@FLICopy:    mov ax,0A000h
             mov es,ax
             mov di,0
             mov cx,64000
         rep movsb
             jmp @MainEnd

@FLILC:      mov dx,03DAh
@synch:      in al,dx
             test al,8
             jz @synch
             mov ax,0A000h
             mov es,ax
             lodsw
             mov bx,ax
             xor ax,ax
             mov ah,bl
             mov cl,6
             shl bx,cl
             add ax,bx
             mov di,ax
             xor ch,ch
             xor ah,ah
             lodsw
             mov bl,al
             xor ah,ah
@FLC1:       lodsb
             cmp al,0
             jz @EOL
             push di
             mov bh,al
@FLC2:       lodsb
             add di,ax
             lodsb
             mov cl,al
             test cl,128
             ja @FLC5
@FLC4:   rep movsb
             jmp @FLC6
@FLC5:       neg cl
             lodsb
         rep stosb
@FLC6:       dec bh
             jnz @FLC2
             pop di
@EOL:        add di,320
             dec bl
             jnz @FLC1
             jmp @MainEnd

@FLIBlack:   mov ax,0A000h
             mov es,ax
             mov di,0
             mov cx,64000
             xor al,al
         rep stosb
             jmp @MainEnd

@eend:       pop ds
             mov cx,[offset FLIH + 16]
             dec cx
             mov dx,03DAh
@Synch1:     in al,dx
             test al,8
             jz @Synch1
@Synch2:     in al,dx
             test al,8
             jnz @Synch2
             loop @Synch1

             pop es
             pop si
             pop di
end;
procedure LoadFLI;assembler;
asm
             mov ax,3D02h   {otvor}
             lea dx,s
             add dx,2
             int 21h

             mov Handle,ax  {nacitaj hlavicku}
             mov bx,ax
             mov cx,22
             lea dx,FLIH
             mov ah,3Fh
             int 21h

             xor cx,cx      {presun na poziciu 128}
             mov ax,4200h
             mov bx,Handle
             mov dx,128
             int 21h

             mov ah,48h     {GetMem}
             mov bx,4090
             int 21h
             mov sseg,ax
{ ----- hlavny cyklus ----- }
@OPAKUJ:     mov w1,1
@FOR:        mov ax,word ptr [FLIH+6] {cyklus}
             cmp w1,ax
             jae @Koniec
             inc w1

             mov ah,3Fh            {nacitaj FrmSize}
             mov bx,Handle
             mov cx,4
             lea dx,FrmSize
             int 21h

             push ds               {nacitaj snimku}
             mov ah,3Fh
             mov bx,Handle
             mov cx,word ptr FrmSize
             sub cx,4
             mov dx,2
             mov ds,sseg
             int 21h
             pop ds

             call ZobrazDalsiuSnimku

             mov ah,1            {klavesnica}
             int 16h
             jz @FOR
             mov ax,word ptr [FLIH+6]
             mov w1,ax
             jmp @FOR           {cyklus FOR}
@Koniec:
             xor cx,cx      {presun na poziciu 128}
             mov ax,4200h
             mov bx,Handle
             mov dx,128
             int 21h

             mov ah,1       {repeat na navestie opakuj}
             int 16h
             jz @OPAKUJ

             mov bx,Handle  {zavri subor}
             mov ah,3Eh
             int 21h

             mov ah,49h
             mov es,sseg
             int 21h
end;
BEGIN
  asm
             mov ax,3h     {zmaz obr.}
             int 10h

             mov ah,9h     {vypis text}
             lea dx,s
             inc dx
             int 21h

             mov ah,0Ah    {nacitaj nazov suboru}
             lea dx,s
             int 21h
             lea si,s
             mov bl,[si+1]
             xor bh,bh
             mov [si+bx+2],bh  {pripis za nazov #0}

             mov ax,13h    {inicializuj grafiku}
             int 10h

             call LoadFLI
             mov ax,3h    {zavri grafiku}
             int 10h
  end;
END.