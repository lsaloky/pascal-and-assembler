program ovladaniemysi;
uses dos,crt;
var reg:registers;                       {registre procesora 286 typu record}
    x,y:word;
    tlacidlo:string;
begin
clrscr;
reg.AX:=0;                               {zisti stav ovladaca mysi}
intr($33,reg);
if reg.AX=$FFFF then writeln('Ovladac mysi je nainstalovany')
                else writeln('Ovladac mysi nie je nainstalovany');
reg.AX:=1;                               {zapnutie kurzora}
intr($33,reg);
repeat
reg.AX:=3;                               {vypis polohu kurzora mysi}
intr($33,reg);
x:=reg.CX;                               {horizontalna poloha}
y:=reg.DX;                               {vertikalna poloha}
                                         {stlacenie tlacidla mysi}
if not(reg.BX and 1=0) then tlacidlo:='lave';
if not(reg.BX and 2=0) then tlacidlo:='prave';
if not(reg.BX and 4=0) then tlacidlo:='prostredne';
if tlacidlo<>'' then
begin
  writeln(tlacidlo);
  tlacidlo:='';
  delay(200);
end;
until keypressed;
reg.AX:=2;                               {vypnutie kurzora}
intr($33,reg);
{prehlad funkcii mysi pod prerusenim $33}
{---------------------------------------}
{00H - inicializacia mysi}
{01H - zapnutie kurzora}
{02H - vypnutie kurzora}
{03H - informacie o pozicii mysi a stave tlacidiel}
{04H - nastavenie polohy mysi}
{05H - informacie o stlaceni tlacidiel}
{06H - informacie o uvolneni tlacidiel}
{07H - nastavenie horizontalneho rozsahu suradnic}
{08H - nastavenie vertikalneho rozsahu suradnic}
{09H - nastavenie grafickeho kurzora}
{0aH - nastavenie textoveho kurzora}
{0bH - informacie o relativnej zmene polohy mysi}
{0cH - nastavenie adresy programu pre udalost}
{0dH - povolenie emulacie svetelneho pera}
{0eH - zakaz emulacie svetelneho pera}
{0fH - nastavenie polohy mysi}
{10H - nastavenie oblasti pre vypnutie kurzora}
{12H - nastavenie velkeho grafickeho kurzora}
{13H - nastavenie prahu rychlosti}
end.