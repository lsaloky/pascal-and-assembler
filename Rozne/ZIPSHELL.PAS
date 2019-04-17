program Spracovanie_ZIP_archivov;
{$M 16384,0,0}
uses Dos,Crt;
var time,sekundy:real;
    e,hod,min,sec,stot:word;
    d:longint;
    pom:searchrec;
    prep,ciel:string;
    ch:char;

procedure adresar(zac:string);
var z:searchrec;
begin
  FindFirst(zac+'*.*',0,z);
  while DosError=0 do begin
    Inc(e);
    if z.Name<>ParamStr(1) then d:=d+z.Size;
    FindNext(z);
  end;
  FindFirst(zac+'*.*',$10,z);
  while DosError=0 do begin
    if (z.attr and directory<>0) and (z.name<>'.') and (z.name<>'..') then adresar(zac+z.name+'\');
    FindNext(z);
  end;
end;

BEGIN            {----- hlavny program -----}
  ClrScr;
  prep:='-ex ';
  ciel:='';
  writeln('k - Kompresia: maxim lna');
  writeln('c - Cielovy adres r a disk: totozny so zdrojovym');
  writeln('in  kl vesa - zaciatok komprim cie');
  repeat
    ch:=ReadKey;
    case ch of
      'k':begin
        GotoXY(16,1);
        if prep='-ex ' then begin
          prep:='-en ';
          writeln('norm lna ');
        end
        else begin
          prep:='-ex ';
          writeln('maxim lna');
        end;
      end;
      'c':begin
        GotoXY(1,4);
        write('Zadaj cielovy adres r a cestu:');
        readln(ciel);
        GotoXY(29,2);
        if ciel='' then writeln('totozny so zdrojovym')
        else writeln(ciel+'                             ');
        GotoXY(1,4);
        DelLine;
      end;
    end;
  until (ch<>'k') and (ch<>'c');
  if ciel<>'' then ciel:=ciel+'\';
  if ciel[1]='a' then prep:=prep+'-& ';
  GetTime(hod,min,sec,stot);
  time:=60*hod+min+sec/60+stot/6000;
  Exec('c:\davky\pkzip.exe',prep+'-p -r '+ciel+ParamStr(1)+' *.*');
  GetTime(hod,min,sec,stot);
  time:=60*hod+min+sec/60+stot/6000-time;
  sekundy:=Frac(time)*60;
  case DosError of
    0:begin
      writeln('Cas komprim cie: ',time:0:0,' min£t ',sekundy:0:2,' sek£nd');
      d:=0;e:=0;
      adresar('');
      writeln('Pocet s£borov: ',e-1);
      FindFirst(ciel+ParamStr(1),$3F,pom);
      writeln('Celkov  dlzka: ',d,' skomprimovan  na ',pom.Size);
      writeln('Kompresny pomer: ',pom.Size/d*100:0:2,'%');
      writeln('Rychlost komprim cie: ',d/1048576/time:0:3,' MB za min£tu');
    end;
    2:writeln('S£bor nen jdeny.');
    3:writeln('Cesta k s£boru neplatn .');
    5:writeln('Pr¡stup k s£boru zak zany!!!');
    6:writeln('DosError #6: Invalid Handle.');
    8:writeln('Nie je dostatok pam„te.');
    10:writeln('DosError #10: Innvalid Environment.');
    11:writeln('DosError #11: Invalid Format.');
    18:writeln('Nie je mozn‚ otvorit viac s£borov!!!');
  end;
END.
