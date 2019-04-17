program Rychla_nasobiaca_rutina_v_assembleri;
const presnost:word=4;
      op1:array[1..4] of byte=(1,0,2,4);
      op2:array[1..4] of byte=(0,0,2,4);
var vysl:array[1..8] of byte;
BEGIN
  asm
    cld
    mov cx,8
    mov al,0
    mov di,offset vysl
    rep stosb
    mov si,offset op2    {SI ukazuje na op1[presnost]}
    add si,[presnost]
    dec si
    mov bx,offset op1    {DI ukazuje na op2[presnost]}
    add bx,[presnost]
    dec bx
    mov di,offset vysl   {BX ukazuje na vysl[2*presnost]}
    add di,[presnost]
    add di,[presnost]
    dec di
    std
  @Cyklus:
    lodsb                {nacitaj do AL a zniz SI}
    mul byte[bx]         {vynasob}
    add al,byte[di]      {a pripocitaj k povodnemu cislu}
    aam                  {uprav na tvar ASCII (cislica=bajt)}
    stosb                {uloz ciastocny sucet a zniz DI}
    add byte[di],ah      {a pripocitaj pretecenie}
    cmp si,offset op2
    jge @Cyklus
    mov si,offset op2
    add si,[presnost]
    dec si
    add di,[presnost]
    dec di
    dec bx
    cmp bx,offset op1
    jge @Cyklus
  end;
END.