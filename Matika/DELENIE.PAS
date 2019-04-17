program Delenie;			{deli na zadany pocet des. miest}
uses Crt;
var op1,op2,pomocne,zvysok:longint;
    x,pocet:word;
    faktor:longint;
    ch:char;
begin
  ClrScr;
  writeln('Zadaj delenca');
  readln(op1);
  writeln('Zadaj delitela');
  readln(op2);
  writeln('Zadaj pocet des. miest');
  readln(pocet);
  write(trunc(op1/op2),',');
  pomocne:=op1;
  zvysok:=op1-trunc(op1/op2)*op2;
  for x:=1 to pocet do begin
    pomocne:=10*zvysok;
    zvysok:=pomocne mod op2;
    pomocne:=(pomocne-zvysok) div op2;
    write(pomocne);
  end;
  writeln;
  readln;
end.
