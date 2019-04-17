program Zurive_vyrazy;
var r1,s1:string;
    pomstr,pomstr2:string;
    x,y,z1,z2:integer;
begin
  r1:='-(a+b-c+d+e-f+g+h)*a-(a+b)';
{ writeln('Zadaj retazce');
  readln(r1);
  readln(s1);}
  writeln('Zadanie:',r1);
  pomstr:=r1;
  x:=Pos('(',pomstr);           {hladanie zatvorky}
  y:=Pos(')',pomstr);
{  while x>0 do begin}
    if pomstr[y+1]='*' then begin       {ak je * za zatvorkou,}
      Insert('*',pomstr,x);             {a za zatvorkou je len premenna,}
      Insert(pomstr[y+3],pomstr,x);         {hodi ju pred zatvorku}
      Delete(pomstr,y+3,2);
      x:=Pos('(',pomstr);               {posunula sa zatvorka}
      y:=Pos(')',pomstr);
    end;
    pomstr2:=pomstr;

    if pomstr2[x-1]='*' then begin       {roznasobovanie zatvorky pri * pred zatv.}
      Delete(pomstr2,x,1);
      Delete(pomstr2,y-1,1);
      z1:=x+2;z2:=x+2;             {ukazatele na index pri r1,r2}
      repeat
        Insert(pomstr[x-2]+pomstr[x-1],pomstr2,z2);
        if (pomstr[x-3]='-') and (pomstr[z1]='+') then pomstr2[z2-1]:='-';   {ak je v zatvorke plus}
        if (pomstr[x-3]='-') and (pomstr[z1]='-') then pomstr2[z2-1]:='+';   {ak je v zatvorke minus}
        z1:=z1+2;        {ideme na dalsi clen}
        z2:=z2+4;
      until z1>=y;
    end;
    x:=Pos('(',pomstr);
    y:=Pos(')',pomstr);
    writeln(pomstr2,',',x,',',y);
    if pomstr2[x-1]='-' then begin          {ak je pred zatvorkou ninus bez sucinu}
      if pomstr2[x+1]='-' then begin
        pomstr2[x+1]:='+';
        Delete(pomstr2,x-1,2);
      end
      else Delete(pomstr2,x,1);
      z1:=x-1;
      while z1<y do begin
        z1:=z1+2;
        if pomstr2[z1]='+' then pomstr2[z1]:='-';
        if pomstr2[z1]='-' then pomstr2[z1]:='+';
      end;
      Delete(pomstr2,Pos(')',pomstr2),1);
    end;
    x:=Pos('(',pomstr2);
    y:=Pos(')',pomstr2);
  writeln('Vysledok:',pomstr2);
  readln;
end.