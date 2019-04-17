program Zisti_cas_hrania_vsetkych_suborov_MOD;
var s:string;
    f:text;
    cas:longint;
BEGIN
  cas:=0;
  Assign(f,'d:\modules.txt');
  Reset(f);
  repeat
    readln(f,s);
    cas:=cas+600*(Ord(s[66])-48)+60*(Ord(s[67])-48)+10*(Ord(s[69])-48)+Ord(s[70])-48;
  until EOF(f);
  writeln(cas);
  writeln(cas div 3600,':',(cas mod 3600) div 60,':',cas mod 60);
  readln;
  Close(f);
END.
