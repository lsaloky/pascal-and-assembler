program Uloha2;
uses Crt;
const tabulka:array[1..6,1..8] of byte=((2,1,4,3,6,5,8,7),
                                        (2,1,4,3,6,5,8,7),
                                        (4,3,2,1,8,7,6,5),
                                        (4,3,2,1,8,7,6,5),
                                        (5,6,7,8,1,2,3,4),
                                        (5,6,7,8,1,2,3,4));
var kocka:array[1..2]of integer;
    s:string;
    dl,pom1:integer;
    ch:char;
begin
  ClrScr;
  kocka[1]:=3;
  kocka[2]:=1;
writeln(kocka[1],',',kocka[2]);
repeat
  ch:=readkey;
case ch of
  'l':pom1:=1;
  'r':pom1:=2;
  'u':pom1:=3;
  'd':pom1:=4;
  'f':pom1:=5;
  'b':pom1:=6;
end;
  for dl:=1 to 2 do kocka[dl]:=tabulka[pom1,kocka[dl]];
  writeln(kocka[1],',',kocka[2]);
  until ch=#27;
end.