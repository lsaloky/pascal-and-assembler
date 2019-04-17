program Prevody;
var fin,fout:text;
    nsn,novy,x,y,z,vacsi,vysl,pz,PocetKolies:word;  {pz=pocet zadani}
BEGIN
  Assign(fin,'prevody.in');
  Reset(fin);
  Assign(fout,'prevody.out');
  Rewrite(fout);
  readLn(fin,pz);
  for y:=1 to pz do begin
    read(fin,pocetKolies);
    read(fin,nsn);
    for z:=1 to PocetKolies-1 do begin
      read(fin,novy);
      if novy>nsn then begin
        x:=Novy;
        novy:=nsn;
        nsn:=x;
      end;
      vysl:=1;
      for x:=2 to nsn do
        while (nsn mod x=0) and (novy mod x=0) do begin
          nsn:=nsn div x;
          novy:=novy div x;
          vysl:=vysl*x;
        end;
      nsn:=vysl*nsn*novy;
    end;
    writeln(fout,'Zadanie ',y,':');
    writeln(fout,'Cas v Kocurkove trva ',nsn,' sekund.');
    writeln(fout,'');
  end;
  CLose(fin);
  Close(fout);
END.

