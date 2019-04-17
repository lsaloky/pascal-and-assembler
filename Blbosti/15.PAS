program Prevody;
var s:string;
    x,y:integer;

function Mocnina(ktora:word):word;
begin
  Mocnina:=Round(Exp(ktora*ln(2)));
end;

BEGIN
  writeln('Vstup je binarny alebo dekadicky? (b/d)');
  readln(s);
  if s='d' then begin
    writeln('Zadaj cislo v dekadickom tvare');
    readln(x);
    if x<0 then begin
      write('1');
      x:=-x;
    end
    else write('0');
    for y:=14 downto 0 do begin
      if x div Mocnina(y)=1 then begin
        write('1');
        x:=x mod Mocnina(y);
      end
      else write('0');
    end;
  end;
  if s='b' then begin
    writeln('Zadaj cislo v binarnom tvare (dlzka 16 bitov),1. bit znamienko');
    writeln('................');
    readln(s);
    y:=0;
    for x:=2 to 16 do if s[x]='1' then y:=y+Mocnina(16-x);
    if s[1]='1' then y:=-y;
    writeln('Vysledok: ',y);
  end;
  readln;
END.