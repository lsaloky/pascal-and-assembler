program Univerzalny_zavadzac_APPEND;
{$M 2000,0,0}
uses Dos;
var p:PathStr;
    d:DirStr;
    n:NameStr;
    e:ExtStr;
    f:text;
BEGIN
  writeln;
  p:=FSearch(ParamStr(1),'E:');
  p:=FExpand(p);
  FSplit(p,d,n,e);
  Assign(f,'spustma.bat');
  ReWrite(f);
  WriteLn(f,'@append /x:on ',d);
  if d='E:\UNPACKED\INTERPLY\DESCENT\' then WriteLn(f,'copy E:\unpacked\interply\descent\descent.exe c:');
  if d='E:\UNPACKED\IDSOFT\1DOOM\' then WriteLn(f,'copy E:\unpacked\idsoft\1doom\doom.exe c:');
  WriteLn(f,'@',ParamStr(1));
  Close(f);
END.