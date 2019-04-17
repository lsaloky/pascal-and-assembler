program Porovnavanie; { adresara SYSTEM s CAB-mi }
{ ide o vypis CABov cez program EXTRACT a adr. SYSTEM cez windowsacky DIR }
uses Dos;
const DOff:string='msoffice.txt';
      DWin:string='win95.txt';
      DOut:string='syscisti.bat';
var f:text;
    s,t:string;
    Sub:array[1..1000] of string[12]; { nazvy suborov v adresari }
    i,j,Poz:word;
    SInfo:SearchRec;
BEGIN
  Poz:=1; { prva volna pozicia v poli Sub }
  WriteLn('Cakaj, pracujem ......... ');
{ ----- nacitanie adresara SYSTEM ----- }
  ChDir('C:\WINDOWS\SYSTEM');
  FindFirst('*.*',$2F,SInfo);
  while DosError=0 do begin
    if SInfo.Name[1]<>'.' then begin
      Sub[Poz]:=SInfo.Name;
      Inc(Poz);
    end;
    FindNext(SInfo);
  end;
  ChDir('D:');
{ ----- spracovanie CABu z Windows ----- }
  Assign(f,DWin);
  Reset(f);
  while not EOF(f) do begin
    ReadLn(f,s);
    t:=Copy(s,1,10);
    if t='10-02-1995' then begin
      s:=Copy(s,41,12);
      for i:=1 to Length(s) do s[i]:=UpCase(s[i]);
      for i:=1 to Poz-1 do
        if Sub[i]=s then Sub[i]:='';
    end;
  end;
  Close(f);
{ ----- spracovanie CABu z MSOffice ----- }
  Assign(f,DOff);
  Reset(f);
  while not EOF(f) do begin
    ReadLn(f,s);
    t:=Copy(s,1,10);
    if t='11-13-1995' then begin
      s:=Copy(s,41,100);
      for i:=1 to Length(s) do s[i]:=UpCase(s[i]);
      while Pos('\',s)>0 do s:=Copy(s,Pos('\',s)+1,100);
      for i:=1 to Poz-1 do
        if Sub[i]=s then Sub[i]:='';
    end;
  end;
  Close(f);
{ ----- zapis vystupneho suboru ----- }
  Assign(f,DOut);
  ReWrite(f);
  WriteLn(f,'@echo OFF');
  for i:=1 to Poz-1 do
    if Sub[i]<>'' then WriteLn(f,'del ',Sub[i]);
  Close(f);
END.