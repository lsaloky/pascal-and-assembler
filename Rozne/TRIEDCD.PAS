program Zatriedovac_cedeciek;
uses Dos;
const PocetPripon=17;
      Pripony:array[1..PocetPripon]of string[3]=('AVI','BMP','CMF','FLI','FLC',
       'GIF','ICO','JPG','MID','MOD','MPG','PCX','PIC','TGA','TIF','VOC','WAV');
type PDalsi=^TDalsi;
     TDalsi=record
              Nazov:string[80];
              Dlzka:longint;
              Dalsi:PDalsi;
            end;
var x:word;
    ZaciatokLZ,KoniecLZ:array[1..PocetPripon] of PDalsi;
    pom:PDalsi;
    f:text;
    NazovCD:string[40];
procedure Adresar(zac:string);
var z:searchrec;
    Prip:string[3];
    Prvy:boolean;
begin
{ ----- spracovanie suborov ----- }
  Prvy:=True;
  FindFirst(zac+'*.*',$27,z);
  while DosError=0 do begin
    Prip:=Copy(Z.Name,Length(Z.Name)-2,3);
    for x:=1 to 3 do Prip[x]:=UpCase(Prip[x]);
    for x:=1 to PocetPripon do
      if Prip=Pripony[x] then begin
        if Prvy then KoniecLZ[x]^.Nazov:=zac+Z.Name
                else KoniecLZ[x]^.Nazov:=Z.Name;
        KoniecLZ[x]^.Dlzka:=Z.Size;
        New(KoniecLZ[x]^.Dalsi);
        with KoniecLZ[x]^.Dalsi^ do begin
          Dlzka:=0;Nazov:='';Dalsi:=nil;
        end;
        Prvy:=False;
      end;
    FindNext(z);
  end;
{ ----- Spracovanie podadresarov ----- }
  FindFirst(zac+'*.*',$10,z);
  while DosError=0 do begin
    if (z.attr and directory<>0) and (z.name<>'.') and (z.name<>'..') then adresar(zac+z.name+'\');
    FindNext(z);
  end;
end;

BEGIN
  ChDir('d:\popis_cd');
  for x:=1 to PocetPripon do begin
    Assign(f,Pripony[x]+'.txt');
    ReWrite(f);
    WriteLn(f,'Zoznam s£borov s pr¡ponou .',Pripony[x],' na zadanych CD-ckach');
    WriteLn(f,'---------------------------------------------------');
    WriteLn(f);
    Close(f);
  end;

  Writeln('--------------');
  Writeln('Zadaj n zov CD');
  Readln(NazovCD);
  for x:=1 to PocetPripon do
    with ZaciatokLZ[x]^ do begin
      New(ZaciatokLZ[x]);
      Nazov:='';Dlzka:=0;Dalsi:=nil;
      KoniecLZ[x]:=ZaciatokLZ[x];
    end;
  for x:=1 to PocetPripon do KoniecLZ[x]:=nil;
  Adresar('d:\');
  for x:=1 to PocetPripon do if ZaciatokLZ[x]<>nil then begin
    Assign(f,Pripony[x]+'.txt');
    Append(f);
    pom:=ZaciatokLZ[x];
    while (pom<>nil) and (pom^.Dlzka<>0) do begin
      Writeln(f,pom^.Nazov,'   ',pom^.Dlzka,' bajtov.');
      pom:=Pom^.Dalsi;
    end;
    Close(f);
  end;
  ChDir('D:\LUBO\PASCAL\ROZNE');
END.