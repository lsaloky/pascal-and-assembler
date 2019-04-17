program FibFaktorNasobScitHanoj; { jednoduche rekurzivne programy }
function Fib(n:word):longint;
begin
  if n<2 then Fib:=1 else Fib:=Fib(n-1)+Fib(n-2);
end;
function Faktor(n:word):longint;
begin
  if n=0 then Faktor:=1 else Faktor:=n*Faktor(n-1);
end;
function Nasob(x,y:word):longint;
begin
  if x=0 then Nasob:=0 else Nasob:=y+Nasob(x-1,y);
end;
function Scit(x,y:word):longint;
begin
  if x=0 then Scit:=y else Scit:=1+Scit(x-1,y);
end;
procedure Hanoj(n:byte;Zdroj,Ciel,Pom:char);
begin
  if n>0 then begin
    Hanoj(n-1,Zdroj,Pom,Ciel);
    WriteLn(Zdroj,' -> ',Ciel);
    Hanoj(n-1,Pom,Ciel,Zdroj);
  end;
end;
BEGIN
  WriteLn('-----'#13#10,Fib(5),#13#10,Faktor(6),#13#10,Scit(14,8),#13#10,Nasob(3,4));
  Hanoj(3,'a','b','c');
  ReadLn;
END.