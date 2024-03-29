program Ordinacia;
uses Crt,Dos;
type TPacient=record
                meno:string[20];
                poistovna:string[5];
                adresa:string[40];
                zamestnavatel:string[40];
                rodnecislo:string[11];
              end;
var Pacient:TPacient;
    Nadisku:file of TPacient;
    s:string;
    ch:char;
    x,err:integer;

procedure Hlavnemenu;
begin
  TextBackGround(black);Window(1,1,80,25);ClrScr;
  Window(15,5,65,23);
  writeln('旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�');
  writeln('�            Hlavn� menu            �');
  writeln('� 1 - Vyh뻕daj pacienta             �');
  writeln('� 2 - Vyp← zoznam pacientov        �');
  writeln('� 3 - Pridaj pacienta               �');
  writeln('� 4 - Vyma� pacienta                �');
  writeln('� 5 - Koniec pr쟠e                  �');
  writeln('읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�');
end;

BEGIN
  Assign(Nadisku,'ordinuj.dat');
  s:=FSearch('ordinuj.dat','c:');
  if s='' then Rewrite(Nadisku)
    else Reset(Nadisku);
  ClrScr;
  repeat
    Hlavnemenu;
    ch:=readkey;
    case ch of
      '1':begin

      end;
      '2':begin
        textbackground(blue);
        window(22,1,62,23);ClrScr;
        writeln;
        writeln(' Zoznam pacientov');
        writeln(' 컴컴컴컴컴컴컴컴');
        x:=1;
        seek(nadisku,0);
        repeat
          read(nadisku,pacient);
          writeln(' ',x,' - ',pacient.meno);
          inc(x);
        until (x=18) or (x=filesize(nadisku)+1);
        writeln(' Nap← 윞slo pacienta alebo stla� Enter');
        readln(s);
        if s<>'' then begin
          Textbackground(brown);
          window(27,3,77,9);clrscr;
          writeln(' Inform쟠ie o pacientovi');
          writeln(' 컴컴컴컴컴컴컴컴컴컴컴�');
          val(s,x,err);
          seek(nadisku,x-1);
          read(nadisku,pacient);
          writeln(' Meno a priezvisko: ',pacient.meno);
          writeln(' Adresa:',pacient.adresa);
          writeln(' Pois쐎v�a:',pacient.poistovna);
          writeln(' Zamestn쟶ate�:',pacient.zamestnavatel);
          writeln(' Rodn� 윞slo:',pacient.rodnecislo);
          writeln(' Stla� 뻰bovo뻨� kl쟶esu');
          ch:=readkey;
        end;
      end;
      '3':begin
        TextBackGround(blue);
        window(22,8,62,16);ClrScr;
        writeln;
        writeln('   Prid쟶anie nov괿o pacienta');
        writeln('   컴컴컴컴컴컴컴컴컴컴컴컴컴');
        write(' Meno a priezvisko: ');readln(pacient.meno);
        write(' Adresa:');readln(pacient.adresa);
        write(' Pois쐎v�a:');readln(pacient.poistovna);
        write(' Zamestn쟶ate�:');readln(pacient.zamestnavatel);
        write(' Rodn� 윞slo:');readln(pacient.rodnecislo);
        Seek(nadisku,filesize(nadisku));
        write(nadisku,pacient);
      end;
      '4':begin
        TextBackGround(blue);
        window(22,8,59,14);ClrScr;
        writeln('   Vymazanie pacienta zo zoznamu');
        writeln('   컴컴컴컴컴컴컴컴컴컴컴컴컴컴�');
        writeln(' Nap← meno a priezvisko pacienta');
        readln(s);
        seek(nadisku,0);
        x:=0;
        repeat
          read(nadisku,pacient);
          Inc(x);
        until (s=pacient.meno) or (x=filesize(nadisku));
        if x<>filesize(nadisku) then begin
          x:=Filepos(nadisku)-1;
          seek(nadisku,filesize(nadisku)-1);
          read(nadisku,pacient);
          seek(nadisku,x);
          write(nadisku,pacient);
          seek(nadisku,filesize(nadisku)-1);
          truncate(nadisku);
          writeln(' Pacient zru�en�');
        end
        else writeln(' Pacient nen쟩den�!!!');
        writeln(' Stla� 뻰bovo뻨� kl쟶esu');
        ch:=readkey;
      end;
    end;
  until ch='5';
  Close(Nadisku);
END.