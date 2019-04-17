program Diskove_operacie;
uses Dos;
var x:longint;

function Vypis(a:longint):string;
var pom:string;
    l:integer;
begin
  Str(a,pom);
  l:=length(pom)-2;
  while l>1 do begin
    Insert('.',pom,l);
    l:=l-3;
  end;
  Vypis:=pom;
end;

begin
  x:=DiskFree(3);
  writeln;
  writeln('Disk C: volnych   ',vypis(x),' B = ',vypis(x div 1024),' KB = ',vypis(x div 1048576),' MB');
  x:=Disksize(3)-Diskfree(3);
  writeln('        pouzitych ',vypis(x),' B = ',vypis(x div 1024),' KB = ',vypis(x div 1048576),' MB');
  writeln('---------------------------------------------------');
  x:=DiskSize(3);
  writeln('        Spolu     ',Vypis(x),' B = ',Vypis(x div 1024),' KB = ',Vypis(x div 1048576),' MB');
  x:=DiskFree(4);
  writeln;
  writeln('Disk D: volnych   ',Vypis(x),' B = ',Vypis(x div 1024),' KB = ',Vypis(x div 1048576),' MB');
  x:=Disksize(4)-diskfree(4);
  writeln('        pouzitych ',Vypis(x),' B = ',Vypis(x div 1024),' KB = ',Vypis(x div 1048576),' MB');
  writeln('---------------------------------------------------');
  x:=DiskSize(4);
  writeln('        Spolu     ',Vypis(x),' B = ',Vypis(x div 1024),' KB = ',Vypis(x div 1048576),' MB');
  writeln;
  writeln('Verzia DOSu: ',Lo(DosVersion),'.',Hi(DosVersion));
  readln;
end.