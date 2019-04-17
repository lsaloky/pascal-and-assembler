type TSpracuj=object
     public
       constructor Init;
       procedure Dokument;
       destructor Koniec;
     private
       f:file;
       s:string;
       Pozicia:integer;
       PoziciaBuffra:word;
       Buffer:array[0..1023] of char;
       VelkostBuffera:word;
       function Blbost(ch:char):boolean;
       procedure VypisB;
       procedure Parameter;
       procedure Dekoduj;
       procedure PridajRiadok;
     end;

