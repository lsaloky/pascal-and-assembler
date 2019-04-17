program Lubo_Vision;
uses Crt,Menu;
type TypPolozky=(Ciara,PodMenu,Polozka);
     PStruktura=^TStruktura;
     TStruktura=record
       Pomoc:string[80];
       case Typ:TypPolozky of
         PodMenu:(Dalsi:PStruktura);
         Polozka:(Udalost:word);
     end;
     PHorneMenu:^THorneMenu;
     THorneMenu=record
       Menu:string[80];
       Pomoc:array[1..8] of string[80];
       PodMenu:array[1..8] of PStruktura;
     end;
var Pos,Pozadie:byte;
    Hore:THorneMenu;
    Pod:PStruktura;
procedure HMenu(p:PStruktura);
begin

end;
BEGIN
  Hore.Menu:=' Subory Data Pomoc Fakty Opravy';
  Inicializacia;
  VypisHorneMenu;
  repeat until Keypressed;
END.