unit Menu;
INTERFACE
  uses Myska;
  procedure InitES;
  procedure VypisRiadok;
  procedure VypisHorneMenu;
  procedure Inicializacia;
IMPLEMENTATION
type TypPolozky=(Ciara,PodMenu,Polozka);
     PStruktura=^TStruktura;
     TStruktura=record
       Typ:TypPolozky;
       Pomoc:string[80];
       case TypPolozky of
         PodMenu:(Dalsi:PStruktura);
         Polozka:(Udalost:word);
     end;
     THorneMenu=record
       Menu:string[80];
       Pomoc:array[1..10] of string[80];
       PodMenu:PStruktura;
     end;
var s:string;
    Pos,Pozadie:byte;
    Hore:THorneMenu;
procedure InitES;assembler;
asm mov ax,0B800h;mov es,ax;end;
procedure VypisRiadok;assembler;
asm
             call InitES
             call VypniKurzorMysi
             mov cx,80
             xor ah,ah
             mov al,pos
             mul cl
             mov di,ax
             lea si,s
             inc si
             mov dl,Pozadie
@DalsiZnak:  movsb
             mov byte[es:di],dl
             inc di
             loop @DalsiZnak
             call ZapniKurzorMysi
end;
procedure VypisHorneMenu;assembler;
asm
             mov ax,ds
             mov es,ax
             lea di,s
             lea si,Hore.Menu
             mov cx,40
         rep movsw
             mov Pozadie,15+1*16
             mov Pos,0
             call VypisRiadok
             call ZapniKurzorMysi
end;
procedure Inicializacia;assembler;
asm
             mov ax,0B800h
             mov es,ax
             mov cx,2000
             xor di,di
             xor ax,ax
         rep stosw
end;
BEGIN
END.