program Zapis_datumu_a_casu;
uses Dos;
const Dni:array[0..6]of string[9]=('Nedela  ','Pondelok','Utorok  ','Streda  ','Stvrtok ','Piatok  ','Sobota  ');
var f:text;
    Rok,Mesiac,Den,DenVTyzdni,Hod,Min,Sec,Stot:word;
function VlozNulu(p:word):string;
var s:string[5];
begin
  Str(p,s);
  if p<9 then Insert('0',s,1);
  VlozNulu:=s;
end;
BEGIN
  Assign(f,'c:\dos\praca.txt');
  Append(f);
  GetDate(Rok,Mesiac,Den,DenVTyzdni);
  Write(f,Dni[DenVTyzdni],' ',VlozNulu(Den),'.',VlozNulu(Mesiac),'.',Rok:4,' ');
  GetTime(Hod,Min,Sec,Stot);
  Writeln(f,VlozNulu(Hod),':',VlozNulu(Min),':',VlozNulu(Sec));
  Close(f);
end.

