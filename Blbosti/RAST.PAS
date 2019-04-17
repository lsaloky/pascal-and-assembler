{priklad cislo 15}
program Hladanie_najdlhsieho_rastuceho_useku;
const n=10;
      a:array[1..n] of word=(1,2,3,4,7,9,11,7,5,2);
var x,index,pocet,maxindex,maxpocet:word;
BEGIN
  index:=2;pocet:=1;maxpocet:=0;maxindex:=1;
  for x:=index to n do
    if a[x-1]<a[x] then Inc(pocet)
                   else begin
                     if pocet>maxpocet then begin
                       maxpocet:=pocet;
                       maxindex:=index;
                     end;
                     index:=x;
                     pocet:=1;
                   end;
  if (maxindex=2) and (a[1]<a[2]) then maxindex:=1;
  writeln('Najdlhsi rastuci usek je na indexe ',maxindex,' a jeho dlzka je ',maxpocet);
  readln;
END.