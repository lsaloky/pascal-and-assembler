Procedure Presun(Zdroj,Ciel:pointer;Pocet:word);assembler;
asm
             push ds
             lds si,[Zdroj]
             les di,[Ciel]
             mov cx,Pocet
             shr cx,1
             jnc @Parny
             movsb
@Parny:  rep movsw
             pop ds
end;
Procedure Vypln(Ciel:pointer;Pocet:word;Hodnota:byte);assembler;
asm
             les di,[Ciel]
             mov al,Hodnota
             mov ah,Hodnota
             mov cx,Pocet
             shr cx,1
             jnc @Parny
             stosb
@Parny:  rep stosw
end;
const a:array[1..5] of byte=(2,4,6,8,4);
var b:array[1..10] of byte;
BEGIN
  Presun(@a,@b,5);
  Vypln(@b[7],4,1);
END.

