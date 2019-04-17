program Vypis_nazvy_vsetkych_textov_na_CD_Computerworldu;
var f,fout:text;
    s:string;
    pr:longint;{pocet riadkov}
BEGIN
  pr:=0;
  assign(f,'e:\rocenka\cw\txt\94.txt');
  Reset(f);
  assign(fout,'cd.txt');
  Rewrite(fout);
  repeat
    readLn(f,s);
    Inc(pr);
    if s='$Text:' then begin
      readln(f,s);
      Inc(pr);
      writeln(fout,s);
    end;
  until EOF(f);
  writeln('Celkovo riadkov: ',pr);
  readln;
  Close(f);
  Close(fout);
END.