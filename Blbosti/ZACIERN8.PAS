program De_Bruigne3;
{ zaciernovanie prebieha rychlostou 1.800.000 pixelov / s pri max. rychlosti}
uses MainGr;
const Rychlost=100;
var f:file;
    DeBruigne:array[0..8193] of byte;
    Mask,i:word;
BEGIN
  Assign(f,'DeBruig.DAT');
  Reset(f,8194);
  BlockRead(f,DeBruigne,1);
  Close(f);
  InicializujGrafiku;
  for i:=1 to 10 do begin
    Color:=31;
    VyplnPlochu(0,0,320,200);
    asm
             push es
             mov es,VSeg
             lea si,DeBruigne
             mov di,word[si]
             mov cx,di
             add si,2
             mov Mask,128
             mov bx,Rychlost
{ ----- hlavny cyklus ----- }
@DalsiBod:   mov byte[es:di],0
             mov ax,Mask
             test word[si],ax     {skontroluj prislusny bit}
             lahf
             shr ah,6             {presun Zero do Carry v AH}
             sahf
             cmc                  {komplement}
             rcl cx,1             {a vrotuj ho do CX - offset}
             mov di,cx            {daj ho do DI; v DI nefunguje RCL}
{ ----- spracovanie premennej Mask ----- }
             shr Mask,1           {posun aktualny bit}
             jnz @MaskOK
             mov Mask,128         {osetri pretecenie}
             inc si               {ide dalsi bajt}
{ ----- spomalenie ----- }
@MaskOK:     dec bx               {pockaj, ak treba}
             cmp bx,0
             jne @CakanieOK
             mov bx,Rychlost
             call CakajNaVOI      {meni obsah DX a AL}
{ ----- skok na zaciatok cyklu ----- }
@CakanieOK:  cmp di,$FFFF         {dalsi bod}
             jne @DalsiBod
             pop es
    end;
  end;
END.