program Informacie_o_mojich_programoch;
uses Dos;
const HlavnaCesta='D:\LUBO';
      PocetPripon=8;
      Pripony:array[1..PocetPripon] of string[3]=('3DS','SAM','FLI','PAS','INC','ASM','MOD','XM');
var Dlzka:array[0..PocetPripon] of longint;
    PocetSub:array[0..PocetPripon] of word;
    RokyPocet:array[1990..2000] of word;
    RokyDlzka:array[1990..2000] of longint;
    Sucet,SucetPoctu:longint;
    DT:DateTime;
    x:word;
    Pouzity:boolean;
{ ----- rekurzivne prehladavanie stromovej struktury ----- }
procedure AdrStrom(Adresar:string);
var DirInfo:SearchRec;
    Ext:string[3];
begin
  ChDir(Adresar);
  FindFirst('*.*',AnyFile,DirInfo);
  while DosError=0 do begin
    if (DirInfo.Name[1]<>'.') and (DirInfo.Attr=$10) then AdrStrom(Adresar+'\'+DirInfo.Name);
    if (DirInfo.Attr and Directory)=0 then begin
      Ext:=Copy(DirInfo.Name,Pos('.',DirInfo.Name)+1,3);
      for x:=1 to 3 do Ext[x]:=UpCase(Ext[x]);
      Pouzity:=False;
      for x:=1 to PocetPripon do
        if Ext=Pripony[x] then begin
          Dlzka[x]:=Dlzka[x]+DirInfo.Size;
          Inc(PocetSub[x]);
          Pouzity:=True;
        end;
      if not Pouzity then begin
        Dlzka[0]:=Dlzka[0]+DirInfo.Size;
        Inc(PocetSub[0]);
      end;
      if (Ext='PAS') or (Ext='INC') then begin
        UnpackTime(DirInfo.Time,DT);
        if DT.Year<1991 then DT.Year:=1990;
        Inc(RokyPocet[DT.Year]);
        RokyDlzka[DT.Year]:=RokyDlzka[DT.Year]+DirInfo.Size;
      end;
    end;
    FindNext(DirInfo);
  end;
end;
{ ----- hlavny program ----- }
BEGIN
  FillChar(Dlzka,0,SizeOf(Dlzka));
  FillChar(PocetSub,0,SizeOf(PocetSub));
  FillChar(RokyPocet,0,SizeOf(RokyPocet));
  FillChar(RokyDlzka,0,SizeOf(RokyDlzka));
  AdrStrom(HlavnaCesta);
  Writeln('Prehlad tvorby:');
  Writeln('------------------------------------------');
  for x:=1 to PocetPripon do writeln(Pripony[x],': '#9#9,PocetSub[x],' s£borov, '#9,Dlzka[x],' bajtov.');
  Writeln('Ostatne: '#9,PocetSub[0],' s£borov, '#9,Dlzka[0],' bajtov.');
  Writeln('------------------------------------------');
  Sucet:=0;SucetPoctu:=0;
  for x:=0 to PocetPripon do Sucet:=Sucet+Dlzka[x];
  for x:=0 to PocetPripon do SucetPoctu:=SucetPoctu+PocetSub[x];
  Writeln('Spolu: '#9#9,SucetPoctu,' s£borov, '#9,Sucet,' bajtov.');
  Writeln('------------------------------------------');
  Writeln('Tvorba s£borov PAS a INC podla rokov:');
  for x:=1991 to 2000 do
    if RokyDlzka[x]>0 then Writeln('Rok ',x,':   ',RokyPocet[x],' s£borov, '#9,RokyDlzka[x],' bajtov.');
  ChDir('D:\LUBO\PASCAL\ROZNE');
END.