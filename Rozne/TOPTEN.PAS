program Najdi_10_najdlhsich_suborov;
uses Dos;
type TTopTen=record
              Meno:string[12];
              dlzka:longint;
            end;
var TopTen:array[1..11] of TTopTen;
    x,y:integer;
procedure HladajSubor(s:string);
var DirInfo:SearchRec;
begin
  writeln(s);
  FindFirst(s+'*.*',0,DirInfo);
  while DosError=0 do begin
    x:=1;
    while (DirInfo.Size<TopTen[x].dlzka) and (x<11) do Inc(x);
    if x<11 then begin
      for y:=11 downto x+1 do begin
        TopTen[y].Meno:=TopTen[y-1].Meno;
        TopTen[y].dlzka:=TopTen[y-1].dlzka;
      end;
      TopTen[x].Meno:=DirInfo.Name;
      TopTen[x].dlzka:=DirInfo.Size;
    end;
    FindNext(DirInfo);
  end;
  FindFirst(s+'*.*',Directory,DirInfo);
  while DosError=0 do begin
    if (DirInfo.attr and Directory<>0) and (DirInfo.Name<>'.') and (DirInfo.Name<>'..')
      then HladajSubor(s+DirInfo.Name+'\');
    FindNext(DirInfo);
  end;
end;
BEGIN
  for x:=1 to 10 do TopTen[x].dlzka:=0;
  HladajSubor('c:\');
  for x:=1 to 10 do writeln(TopTen[x].Meno,#9' : ',TopTen[x].dlzka);
END.