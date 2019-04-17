program Vypisanie_zoznamu_suborov_a_vselico_o_mojich_programoch;
uses Dos;
const mesiac:array[1..12] of word=(0,31,59,90,120,151,181,212,243,273,304,334);
type TSubor=record
              Meno:string[12];
              Cas:longint;
            end;

var Dirinfo,InDirInfo:SearchRec;
    dt:DateTime;
    s,s2,riadok:string;
    f,fout:text;
    dlzka,dlzkainc,dlzkadat,aktsub,time,pocet:longint;    {aktsub=aktualny subor,time=cas od 1.1.1992 v dnoch}
    x,y:word;
    Subory:array[1..2000] of TSubor;
    Dni:array[1..7] of word;
BEGIN
  Assign(fout,'d:\lubo\pascal\mojeprog.txt');
  Rewrite(fout);
  writeln('Vytvaram prehlad tvojich programov a zapisujem ho do MOJEPROG.TXT');
  s:='d:\lubo\pascal';
  Chdir(s);
  aktsub:=1;
  dlzka:=0;dlzkainc:=0;dlzkadat:=0;
  for x:=1 to 7 do Dni[x]:=0;
  subory[1].Meno:='';
  for x:=1 to 2000 do Subory[x].Cas:=0;
  FindFirst('*.*',Directory,DirInfo);
  while (DosError=0) do begin
    if DirInfo.Attr=$10 then begin
      Write('.');
      s2:=s+'\'+DirInfo.Name;
      Chdir(s2);
      FindFirst('*.pas',AnyFile,InDirInfo);
      if DosError=0 then begin
        writeln(fout,'Adresar: ',DirInfo.Name);
        writeln(fout,'');
      end;
      while DosError=0 do begin
        Assign(f,InDirInfo.Name);
        Reset(f);
        Readln(f,riadok);
        UnpackTime(InDirInfo.Time,dt);
        time:=trunc((dt.Year-1990)*365.25)+Mesiac[dt.Month]+dt.Day;
        x:=1;
        while (time>Subory[x].Cas) and (x<aktsub) do Inc(x);
        if x<aktsub then begin
          for y:=aktsub downto x do begin
            Subory[y+1].Meno:=Subory[y].Meno;
            Subory[y+1].Cas:=Subory[y].Cas;
          end;
        end;
        Subory[x].Meno:=InDirInfo.Name;
        Subory[x].Cas:=time;
        Close(f);
        writeln(fout,InDirInfo.Name,' : ',riadok);
        dlzka:=dlzka+InDirInfo.Size;
        FindNext(InDirInfo);
        Inc(aktsub);
      end;
      writeln(fout,'');
    end;
    FindNext(DirInfo);
  end;
  Close(fout);
  writeln;
  writeln('Dlzka vsetkych suborov PAS: ',dlzka);
  writeln('Pocet suborov PAS: ',aktsub-1);
  writeln('Pocet suborov vytvorenych po jednotlive dni:');
  for x:=1 to aktsub-1 do Inc(Dni[(Subory[x].Cas+2) mod 7+1]);
  writeln(' Pondelok: ',Dni[1]);
  writeln(' Utorok:   ',Dni[2]);
  writeln(' Streda:   ',Dni[3]);
  writeln(' Stvrtok:  ',Dni[4]);
  writeln(' Piatok:   ',Dni[5]);
  writeln(' Sobota:   ',Dni[6]);
  writeln(' Nedela:   ',Dni[7]);
  writeln;
  writeln('Stlac Enter');
  readln;
END.