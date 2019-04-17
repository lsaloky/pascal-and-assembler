procedure SpocitajVolne;{ak je 5 vedla seba, nastav Udalost na 3}
var Zac1,Zac2:integer;
begin
  FillChar(Volne,SizeOf(Volne),#0);
  for i:=1 to 2 do begin
{ ----- pocitanie volnych po riadkoch ----- }
    for j:=1 to VelkostPlanu do begin
      for k:=1 to VelkostPlanu-3 do
        if (Plan[k,j]=0) and (Plan[k+1,j]=i) and
           (Plan[k+2,j]=i) and (Plan[k+3,j]=0) then Dec(Volne[2],2*i-3);
      for k:=1 to VelkostPlanu-4 do
        if (Plan[k,j]=0) and (Plan[k+1,j]=i) and
           (Plan[k+2,j]=i) and (Plan[k+3,j]=i) and (Plan[k+4,j]=0) then Dec(Volne[3],2*i-3);
    end;
{ ----- pocitanie volnych po stlpcoch ----- }
    for j:=1 to VelkostPlanu do begin
      for k:=1 to VelkostPlanu-3 do
        if (Plan[j,k]=0) and (Plan[j,k+1]=i) and
           (Plan[j,k+2]=i) and (Plan[j,k+3]=0) then Dec(Volne[2],2*i-3);
      for k:=1 to VelkostPlanu-4 do
        if (Plan[j,k]=0) and (Plan[j,k+1]=i) and
           (Plan[j,k+2]=i) and (Plan[j,k+3]=i) and (Plan[j,k+4]=0) then Dec(Volne[3],2*i-3);
    end;
{ ----- pocitanie volnych po hlavnej uhlopriecke ----- }
    for j:=-VelkostPlanu to VelkostPlanu do begin
      if j<1 then Zac1:=1 else Zac2:=1;
      for k:=1 to VelkostPlanu-Abs(j) do
        if (Plan[Zac1,k]=0) and (Plan[j+1,k+1]=i) and
           (Plan[j+2,k+2]=i) and (Plan[j+3,k+3]=0) then Dec(Volne[2],2*i-3);
{      for k:=1 to VelkostPlanu-4 do
        if (Plan[j,k]=0) and (Plan[j,k+1]=i) and
           (Plan[j,k+2]=i) and (Plan[j,k+3]=i) and (Plan[j,k+4]=0) then Dec(Volne[3],2*i-3);}
    end;
  end;
  Color:=6;VyplnPlochu(210,84,98,23);
  VypisPo(214,85,MSFP,StrI(Volne[2]),Hneda);
  VypisPo(244,85,MSFP,StrI(Volne[3]),Hneda);
  VypisPo(214,97,MSFP,StrI(Zablok[2]),Hneda);
  VypisPo(244,97,MSFP,StrI(Zablok[3]),Hneda);
  VypisPo(274,97,MSFP,StrI(Zablok[4]),Hneda);
end;
