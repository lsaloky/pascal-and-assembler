program Prvocislo;{vyuziva 4-bitovy BCD form t z pisu c¡sla}
uses Dos;          {62 sekund na DX2/66}
const presnost=8;{polovica poctu cislic, prvocislo je teda 8ciferne, odporucam nasobky 2 pre presnost}
type TStruktura=record
       op:array[1..presnost] of byte;
       mocnina:word;
     end;
var p:^TStruktura;
    x,y:word;
BEGIN
  GetMem(p,65528);
  p^.mocnina:=12;
  asm
    push ds
    mov ax,word ptr p+2
    mov ds,ax
    mov bx,presnost
    dec bx
    mov di,bx
    dec bx
    mov byte [di],$01
  @vyplnuj:
    mov byte [di-1],$00{instrukcia sa vykonava 13500 krat}
    dec di             {13.500}
    jnz @vyplnuj       {13.500}
    mov cx,1
  @cyklus1:
    mov di,bx
  @cyklus2:
    mov dx,[di]
    mov al,dl
    and al,$f0   {1. cislica z DX ide do AL}
    mov ah,dl    {2. cislica z DX ide do AH}
    and ah,$0f
    shr al,3
    cmp al,9
    jbe @DruhaCislica
    sub al,10
    inc byte[di-1]  {pretecenie a zvysenie poctu cislic}
    cmp di,bx
    jne @DruhaCislica
    sub bx,2
  @DruhaCislica:
    shl ah,1
    cmp ah,9
    jbe @TretiaCislica
    sub ah,10
    inc al
  @TretiaCislica:
    shl al,4    {ulozenie prvych dvoch cislic do DX}
    add al,ah
    mov dl,al
    mov al,dh
    and al,$f0   {3. cislica z DX ide do AL}
    mov ah,dh    {4. cislica z DX ide do AH}
    and ah,$0f
    shr al,3
    cmp al,9
    jbe @StvrtaCislica
    sub al,10
    inc dl
  @StvrtaCislica:
    shl ah,1
    cmp ah,9
    jbe @UlozenieVysledku
    sub ah,10
    inc al
  @UlozenieVysledku:
    shl al,4    {ulozenie dalsich dvoch cislic do DX}
    add al,ah
    mov dh,al
    mov [di],dx
    add di,2
    cmp di,presnost
    jb @Cyklus2
    inc cx
    cmp cx,[presnost]
    jbe @Cyklus1
    dec byte[presnost-1]

    mov cx,0
    mov ah,02h
    int 21h
    pop ds
  end;
  FreeMem(p,65528);
END.