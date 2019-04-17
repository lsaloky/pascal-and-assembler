program InicializujSubory;
uses Crt;
type THiScore=record
                Meno:string;
                PocetLudi:longint;
              end;
var f:file of string;
    f2:file of THiScore;
    fsav:file;
    HiScore:THiScore;
    x,main,poradie:byte;
    data:longint;
    s:string;
    spok:real;
begin
  ClrScr;
  writeln('1 - instalacia programu');
  writeln('2 - editovanie suboru pre save');
  readln(main);
  case main of
    1:begin
      Assign(f,'saves.inf');
      Rewrite(f);
      Assign(f2,'topten.dat');
      Rewrite(f2);
      s:='';
      for x:=1 to 10 do write(f,s);
      for x:=1 to 10 do begin
        HiScore.Meno:='•ubo Saloky';
        HiScore.PocetLudi:=(11-x)*10;
        write(f2,HiScore);
      end;
      Close(f);
      Close(f2);
      writeln('Si si isty, ze chces premazat strukturu suborov pre save? Ano/Nie');
      readln(s);
      if (s='ano') or (s='Ano') or (s='ANO') then begin
        s:='save .dat';
        for x:=0 to 9 do begin
          s[5]:=Chr(x+48);
          Assign(fsav,s);
          Rewrite(fsav);
          Close(fsav);
          Erase(fsav);
        end;
      end;
    end;
    2:begin
      writeln('Ktory subor chces editovat? Zadaj cislo od 0 do 9');
      readln(poradie);
      Assign(fsav,'save'+Chr(poradie+48)+'.dat');
      Reset(fsav,1);
      write('Kolko chces mat penazi?');readln(data);
      BlockWrite(fsav,data,4);
      write('Kolko chces mat ludi?');readln(data);
      BlockWrite(fsav,data,4);
      write('Cena bane:');readln(data);
      BlockWrite(fsav,data,4);
      write('Cena skladu:');readln(data);
      BlockWrite(fsav,data,4);
      write('Cena domu:');readln(data);
      BlockWrite(fsav,data,4);
      write('Cena bloku:');readln(data);
      BlockWrite(fsav,data,4);
      write('Cena cesty:');readln(data);
      BlockWrite(fsav,data,4);
      write('Cena rudy:');readln(data);
      BlockWrite(fsav,data,4);
      write('Zasoby rudy:');readln(data);
      BlockWrite(fsav,data,4);
      Seek(fsav,FileSize(Fsav)-4);
      write('Do ktoreho roku chces hrat?');readln(data);
      BlockWrite(fsav,data,4);
      Close(fsav);
    end;
  end;
end.