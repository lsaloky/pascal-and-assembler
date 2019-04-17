program Nalet;      { teoria hier a nalet bombarderov }
                 { na n mety knihy "Matematika kolem n s" }
uses Crt;
const Pocet=100;
      Vysledok:array[0..1,0..1] of byte=((40,100),(70,10));{1.typ,0=bom.; 2.vyska,0=nizko}
var i,bom,sti:integer;
    Priemer:real;
    ch:char;
    Typ:string;
BEGIN
  Randomize;
  ClrScr;
  write(  'Predstavte si, ze velitel bombarderov pripravuje nalety na dolezite zeleznicne'#13#10+
          'a cestne krizovatky, ktore su chranene stihackami protivnika. Predpokladajme'#13#10+
          'zjednodusenu situaciu, ze bombardery mozu utocit z velkej a malej vysky,stihacky');
  writeln('mozu ocakavat protivnika vo velkej i malej vyske. Za tychto predpokladov mozu'#13#10+
          'nastat styri pripady, pri ktorych uspesnost naletov je ohodnotena udajmi'#13#10+
	  'v tabulke:'#13#10#13#10#13#10'bombardery letia   stihacky letia   uspesnost naletu'#13#10);
  writeln('vysoko             vysoko           10 %'#13#10'vysoko             nizko            70 %'+
          #13#10'nizko              vysoko           100 %'#13#10'nizko              nizko            40 %'+
          #13#10#13#10'Bude ',Pocet,' naletov.'#13#10'Chces hrat za bombardery, alebo sa stihacky? (b alebo s)');
  repeat
    ch:=ReadKey;
  until ch in ['s','b'];
  if ch='b' then Typ:='bombardery' else Typ:='stihacky';
  Priemer:=0;
  ClrScr;
  for i:=1 to Pocet do begin
    writeln(#13#10,i,'. nalet !!! '#13#10'Tvoje '+Typ+' budu letiet vysoko alebo nizko? (v alebo n)');
    repeat
      ch:=ReadKey;
    until ch in ['n','v'];
{ ----- spracovanie vstupu z klavesnice a rozmyslaci algoritmus pre optimalnu strategiu pocitaca ----- }
    if (ch='v') and (Typ='bombardery') then begin
      bom:=1;sti:=Random(4);
    end;
    if (ch='n') and (Typ='bombardery') then begin
      bom:=0;sti:=Random(4);
    end;
    if (ch='v') and (Typ='stihacky') then begin
      bom:=Random(2);sti:=1;
    end;
    if (ch='n') and (Typ='stihacky') then begin
      bom:=Random(2);sti:=0;
    end;
    if Sti>1 then Sti:=0;
    write('Bombardery letia ');
    if bom=0 then writeln('nizko.') else writeln('vysoko.');
    write('Stihacky letia ');
    if sti=0 then writeln('nizko.') else writeln('vysoko.');
    Priemer:=Priemer+Vysledok[bom,sti];
    writeln('Uspesnost naletu je ',Vysledok[bom,sti],' %.'#13#10+
            'Priemerna uspesnost naletov je ',Priemer/i:3:2,' %.');
  end;
  ClrScr;
  Priemer:=Priemer/i;
  writeln('Zaverecne vyhodnotenie:'#13#10'-----------------------------'#13#10+
          'Celkovy priemer uspesnosti naletov: ',Priemer:3:2,' %. '#13#10'Komentar:');
  if ((Typ='bombardery') and (Priemer>60)) or
     ((Typ='stihacky')   and (Priemer<50)) then writeln('Gratulujem, si dobry strateg!!! (alebo je to stastie)');
  if ((Typ='bombardery') and (Priemer<50)) or
     ((Typ='stihacky')   and (Priemer>60)) then writeln('Je to biedne, musis lepsie porozmyslat o optimalnej strategii !!!');
  if (Priemer>50) and (Priemer<60) then writeln('Je to celkom slusne, este trochu popracuj a budes dobry.');
  writeln('Stlac Enter.');
  readln;
END.
