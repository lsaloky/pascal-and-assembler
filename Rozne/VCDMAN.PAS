program Manazer_virtualneho_CD;
uses Dos;
const Nula:byte=0;
var f:file;
    i:integer;
{ ----- procedura prejde strukturu adresarov a zapise ju do suboru vo vlastnom formate ----- }
procedure Adresar(s:string);
var sr:SearchRec;
begin
  FindFirst(s+'\*.*',AnyFile,sr);
  repeat
    if sr.Name[1]<>'.' then begin
      for i:=Length(sr.Name)+1 to 12 do sr.Name[i]:=#0;
      BlockWrite(f,sr.Attr,1); { tu je struktura toho suboru }
      BlockWrite(f,sr.Time,4);
      BlockWrite(f,sr.Size,4);
      BlockWrite(f,sr.Name[1],12);
      BlockWrite(f,Nula,1);
{      if (sr.Attr and Directory) >0 then Adresar(s+'\'+sr.Name);}
    end;
    FindNext(sr);
  until DosError>0;
end;
{ ----- HLAVNY PROGRAM ----- }
BEGIN
  Assign(f,'DiskC.VCD');
  ReWrite(f,1);
  Adresar('C:');
  Close(f);
END.
