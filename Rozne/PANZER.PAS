program Finta_na_Panzer_Generala;
var f1,f2:file;      {Caucasus 27 -> index 31300}
    x,y:byte;        {Balkan 20 -> index 33588}
    l:word;          {Norsko 20 -> index 27820}
BEGIN
  Assign(f1,'d:\games\traxdata\panzer\saves\game.sv0');
  Reset(f1,1);
{  Assign(f2,'d:\games\traxdata\panzer\saves\game.sv1');
  Reset(f2,1);}
  l:=0;
  x:=20;
  writeln;
  Seek(f1,33588);
  BlockWrite(f1,x,1);
  writeln(x);
{  while not EOF(f1) do begin
    Inc(l);
    BlockRead(f1,x,1);
    BlockRead(f2,y,1);
    if (x=1) and (y=25) then writeln(l);
  end;                                  }
  Close(f1);
{  Close(f2);}
END.