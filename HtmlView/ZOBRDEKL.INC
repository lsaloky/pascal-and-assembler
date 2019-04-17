{ ----- deklaracia objektu Zobraz ----- }
type TZobraz=object
     public
       constructor Init;
       procedure Dokument;
       destructor Koniec;
       procedure Chyba(Kod:byte);
     private
       LHRX,LHRY:word;   { suradnice laveho horneho rohu obrazovky v dokumente }
       VSeg,TempCX:word;
       KurzX,KurzY:byte; { pozicia textoveho kurzora }
       MysX,MysY:word;   { pozicia kurzora mysi }
       Tlacidla:byte;    { mysi }
       i,j:integer;
       Mena:string[33];
       Titul1:string[9];
       Titul2:array[1..2] of string[6];
       Titul3:array[1..2] of string[6];
       EndInfo:array[1..2] of string[48];
       ChybHlas:array[1..2] of string[13];
       DMenu:array[1..2,1..10] of string[6];
       ChybPopis:array[1..2,1..3] of string[40];
       procedure ZmazObrazovku;
       procedure PrepisObrazovku;
       procedure PrepisPoziciuKurzora;
       procedure UmiestniText(x,y:word;Adresa:pointer);
       procedure Ramcek(PosX,PosY,Sirka,Vyska:word;Atribut:byte); {min. 5 x 3!}
{ ----- systemove procedury ----- }
       procedure ZapniTextovyKurzor;
       procedure VypniTextovyKurzor;
       procedure UmiestniTextovyKurzor;
       function CitajZnak:char;
       function JeZnak:boolean;
       procedure CakajNaVOI;
{ caka na odstranenie }
       procedure EmulujPridajRiadok;
     end;

