program Zapis_struktury_CD_na_disketu;
uses Dos;
var f:file;
procedure Adresar(Zdroj,Ciel:string);
var z:SearchRec;
begin
  FindFirst(Zdroj+'*.*',0,z);
  while DosError=0 do begin
    Assign(f,Ciel+z.Name);
    ReWrite(f,1);
    BlockWrite(f,z,1);
    Close(f);
    FindNext(z);
  end;
  FindFirst(Zdroj+'*.*',$10,z);
  while DosError=0 do begin
    if (z.Attr and Directory<>0) and (z.Name<>'.') and (z.Name<>'..') then begin
      Write(z.Name,' ');
      MkDir(Ciel+z.Name);
      Adresar(Zdroj+z.Name+'\',Ciel+z.Name+'\');
    end;
    FindNext(z);
  end;
end;
BEGIN
  adresar(ParamStr(1),ParamStr(2));
END.

