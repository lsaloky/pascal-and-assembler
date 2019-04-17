program Cakanie;
uses Dos,Crt;
var hod,min,sec,s100:word;
    SHod,SMin,Err:word;
BEGIN
  clrscr;
  Val(ParamStr(1),SHod,Err);
  Val(ParamStr(2),SMin,Err);
  repeat
    GetTime(Hod,Min,Sec,S100);
  until Hod*60+Min>=Shod*60+SMin;
  writeln(Hod,',',Min);
  readln;
END.