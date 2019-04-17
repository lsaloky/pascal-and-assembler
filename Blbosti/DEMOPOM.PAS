program Demo_pomocny_pre_skusanie_a_odladovanie_jednotlivych_efektov;
const kruh:array[0..41] of word=(0,5,8,11,13,15,17,19,21,23,24,25,26,27,28,29,30,31,32,32,33,33,34,34,35,35,36,36,37,37,38,38,
                                 38,39,39,39,40,40,40,40,40,0);

var a:array[0..63999] of byte;
BEGIN
asm
             cld
             mov ax,0A000h
             mov es,ax
             mov ax,0013h
             int 10h
{ ----- kreslenie kruznice ----- }
             lea si,kruh
             mov di,3EF8h
             mov ax,150*256+150
             add si,2
@D2E4C1:     mov cx,[si]
         rep stosw
             add di,320
             sub di,[si]
             sub di,[si+2]
             add si,2
             cmp word[si],0
             jnz @D2E4C1
             sub si,2
             sub di,40
@D2E4C2:     mov cx,[si]
         rep stosw
             add di,320
             sub di,[si]
             sub di,[si-2]
             sub si,2
             cmp word[si],0
             jnz @D2E4C2
             mov ah,0
             int 16h
end;
END.