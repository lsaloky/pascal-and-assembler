program Viacnasobne_stlacenie_klaves;
{$X+}
uses Dos,Crt;
const Hore1=72;Dole1=80;Vlavo1=75;Vpravo1=77;
      Hore2=17;Dole2=44;Vlavo2=30;Vpravo2=31;
      m:array[1..8]of byte=(Hore1,Dole1,Vlavo1,Vpravo1,Hore2,Dole2,Vlavo2,Vpravo2);
var k:array[0..255] of byte;
    v:array[0..199,0..319] of byte absolute $A000:$0000;{video RAM 320x200}
    kb:procedure;
    x1,y1,x2,y2,x:word;
    r:registers;

procedure Up9;interrupt;
var a:byte;
begin
  if keypressed then readkey;
  asm
    in al,60H
    mov a,al
  end;
  if a>0 then k[a]:=1;
  if a=128 then k[0]:=0;
  inline($9C);
  kb;
end;

BEGIN
  GetIntVec($9,@kb);
  SetIntVec($9,Addr(Up9));
(*  r.AX:=$0013;     {nastavenie graf. modu 320 x 200, 256 farieb}
  Intr($10,r);
  x1:=20;
  y1:=100;
  x2:=300;
  y2:=100;
  v[y1,x1]:=25;
  v[y2,x2]:=25;
  repeat
    for x:=1 to 8 do if k[m[x]]=1 then begin
      k[m[x]]:=0;
      case x of
        1:Dec(y1);
        2:Inc(y1);
        3:Dec(x1);
        4:Inc(x1);
        5:Dec(y2);
        6:Inc(y2);
        7:Dec(x2);
        8:Inc(x2);
      end;
    end;
    v[y1,x1]:=25;
    v[y2,x2]:=25;
  until k[1]=1;
  k[1]:=0;
  SetIntVec($9,@kb);
  TextMode(lastmode);*)
  repeat
    for x:=2 to 127 do if k[x]=1 then begin
      write(x,',');
      Delay(50);
    end;
    FillChar(k,SizeOf(k),#0);
  until k[13]=1;
END.
