program Uhadnutie_cisla;
uses Crt;
const n=4;
      a:array[1..n] of word=({53,11,13,23}3,5,7,11);
var zvysok,k:array[1..7] of longint;
    x,y,sucin:longint;
    error:integer;
    ch:char;
    s:string;
    dobre:boolean;
procedure TestInej;
begin
  if (ch<>'a') and (ch<>'n') then writeln('Nestl caj in£ kl vesu, dobre?');
end;
BEGIN
  ClrScr;
{ ----- pocitanie celkoveho sucinu ----- }
  sucin:=1;
  for x:=1 to n do sucin:=sucin*a[x];
{ ----- pocitanie K[i] ----- }
  for x:=1 to n do begin
    k[x]:=sucin div a[x];
    y:=k[x];
    while k[x] mod a[x]<>1 do k[x]:=k[x]+y;
  end;
{ ----- uvod -----}
  writeln('Ahoj, uh dnem tvoje c¡slo od 0 do ',sucin-1,', ktor‚ si pr ve mysl¡s.');
  repeat
  writeln('Chces? a/n');
    ch:=ReadKey;
    writeln(ch);
    TestInej;
    if ch='n' then writeln('Chciet je pekn  vlastnost, takze podme na to.');
  until (ch='a') or (ch='n');
  repeat
{ ----- interview ----- }
    for x:=1 to n do begin
      repeat
        writeln('Mus¡s povedat zvysok po delen¡ ',a[x]);
        readln(s);
        Val(s,zvysok[x],Error);
        if (zvysok[x]<0) or (zvysok[x]>=a[x]) then writeln('To nie je zvysok po delen¡ ',a[x]);
        if error>0 then begin
          writeln('Nezadavaj mi tu pismena, inak sa nahnevam!!!');
          zvysok[x]:=-1;
        end;
      until (zvysok[x]>=0) and (zvysok[x]<a[x]);
    end;
{ ----- pocitanie cisla ----- }
    x:=0;
    for y:=1 to n do x:=x+k[y]*zvysok[y];
    x:=x mod sucin;
{ ----- kontroly ----- }
    if x<sucin then writeln('Mysl¡s si c¡slo ',x)
               else writeln('Podv dzal si !!!');
    writeln('M m pravdu? a/n');
    ch:=ReadKey;
    TestInej;
    if ch='n' then begin
      writeln('Skontrolujeme si to. Povedz c¡slo, ktore si si myslel.');
      readln(x);
      write('Pomylil si sa pri zad van¡ zvysku pri delen¡ ');
      for y:=1 to n do if zvysok[y]<>x mod a[y] then write(a[y],',');
      writeln;
      writeln('Sk£sime to znova.');
    end;
  until ch='a';
  writeln('Ahoj.');
END.