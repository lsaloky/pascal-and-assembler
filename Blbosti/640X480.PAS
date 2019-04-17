program mod_640x480x16_farieb;
{$I 640x480.inc}
var x:word;     {zmaz}
procedure CiaraVodorovna(zx,zy,Dlzka:word);assembler;
{ ----- nekresli ciary kratsie ako 8 ----- }
asm
             call InitAsm
             mov ah,Color
             call NastavRovinu
             mov cx,80
             mov ax,zy    {y-ova * 80}
             mul cx       {v AX je offset zaciatku aktualneho riadka}
             mov cx,zx
             mov di,cx
             shr di,3     {x-ova / 8}
             add di,ax    {v DI je offset 1. bajtu, na ktory sa zapisuje}
             mov bx,0
             and cx,0007h
             jz @Preskoc
             mov bx,8
             sub bx,cx    {v BX je pocet zapisanych bodov}
             mov al,0FFh
             shr al,cl    {priprav jednotky v AL}
             or byte[es:di],al{neprepis nulami zvysok bajtu, kde nie je ciara}
             inc di
@Preskoc:    mov cx,Dlzka
             sub cx,bx
             and cx,0FFF8h{vynuluj posledne 3 bity-zapisuje sa po bajtoch}
             add bx,cx    {pripocitaj k poctu zapisanych bodov}
             shr cx,3     {pocet bajtov}
             mov al,0FFh
         rep stosb        {ukladaj bajty}
             mov cx,8
             sub cx,Dlzka
             add cx,bx
             and cx,0007h
             mov al,0FFh
             cmp cx,0
             je @Preskoc2
             shl al,cl
             or byte[es:di],al
@Preskoc2:
end;
BEGIN
  InicializujGrafiku;
  Color:=14;
  CiaraVodorovna(0,0,66);
{  CiaraVodorovna(67,0,112);
  CiaraVodorovna(79,0,16);}
  CiaraVodorovna(10,0,26);
  ReadLn;
  ZavriGrafiku;
END.
