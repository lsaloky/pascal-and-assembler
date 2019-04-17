program Skus_to_s_diskom;
type vpamati=record
             meno,adresa:string;
             end;
var ucastnik:vpamati;
    polozka:file of vpamati;
begin
  ucastnik.meno:='Lubo Saloky';
  ucastnik.adresa:='Slovensk‚ho 26';
  assign(polozka,'c:\subory\vyuka\pokus.dat');
  reset(polozka);   {rewrite pri prvom pouziti}
  write(polozka,ucastnik);
  writeln('OK');
  readln;
end.