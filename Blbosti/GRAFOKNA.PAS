unit GrafOkna;

interface
  uses Graph,Crt;
  type TStruktura=record
                    hm:array[1..10] of string[15];  {horne menu}
                    rm:array[1..10,1..20] of string[15]; {rozvinute roletove menu}
                  end;
   {10 menu po 20 poloziek s dlzkou 15 pismen}
  function NastavMenu(q:pointer):word;
    {vystup typu word = 100*pozicia v hornom menu+pozicia v roletovom menu}

implementation
function NastavMenu(q:pointer):word;
var s:string;
    x,y,pos,posr:integer;
    a,b:array[0..10] of word;
    ch:char;
    PS:^TStruktura;
    p:pointer;

  procedure Ramcek(c,farba:integer);
  begin
    SetColor(farba);
    Line(3+a[c-1],3,a[c]-2,3);
    Line(a[c]-2,3,a[c]-2,15);
    Line(a[c]-2,15,3+a[c-1],15);
    Line(3+a[c-1],15,3+a[c-1],3);
  end;
  procedure RRam(c,farba:integer);
  var z:integer;
  begin
    if farba>0 then begin
      SetFillStyle(1,0);
      GetImage(3+a[c-1],20,128+a[c-1],17+b[c]*13,p^);
      Bar(3+a[c-1],20,128+a[c-1],17+b[c]*13);
      SetColor(farba);
      Line(3+a[c-1],20,128+a[c-1],20);
      Line(128+a[c-1],20,128+a[c-1],17+b[c]*13);
      Line(128+a[c-1],17+b[c]*13,3+a[c-1],17+b[c]*13);
      Line(3+a[c-1],17+b[c]*13,3+a[c-1],20);
      for z:=1 to b[c] do OuttextXY(8+a[c-1],25+13*(z-1),PS^.rm[c,z]);
    end
    else PutImage(3+a[c-1],20,p^,NormalPut);
  end;
  procedure RRamcek(c,d,farba:integer);    {c-pozicia v hornom menu}
  begin
    SetColor(farba);
    Line(5+a[c-1],10+13*d,126+a[c-1],10+13*d);
    Line(126+a[c-1],10+13*d,126+a[c-1],21+13*d);
    Line(126+a[c-1],21+13*d,5+a[c-1],21+13*d);
    Line(5+a[c-1],21+13*d,5+a[c-1],10+13*d);
  end;

begin
  PS:=q;
  GetMem(p,ImageSize(0,0,125,257));
  a[0]:=0;
  for x:=1 to 10 do begin
    a[x]:=a[x-1]+Length(PS^.hm[x])*8+8;{a je pozicia x-tej polozky horn.menu}
    y:=1;
    while PS^.rm[x,y]<>'' do Inc(y);{pocet poloziek v x-tej polozke horn.menu}
    b[x]:=y;
  end;
  s:='';pos:=1;posr:=1;
  SetFillStyle(1,0);
  Bar(1,1,638,17);
  SetColor(7);
  Line(639,0,0,0);
  Line(0,0,0,18);
  Line(0,18,639,18);
  Line(639,18,639,0);
  for x:=1 to 10 do s:=s+PS^.hm[x]+' ';
  OutTextXY(5,5,s);
  Ramcek(1,12);
  repeat
    ch:=ReadKey;
    case ch of
    '6':begin
          Ramcek(pos,0);
          Inc(pos);
          Ramcek(pos,12);
        end;
    '4':begin
          Ramcek(pos,0);
          Dec(pos);
          Ramcek(pos,12);
        end;
    end;
  until ch='5';
  RRam(pos,7);
  RRamcek(pos,1,12);
  repeat
    ch:=ReadKey;
    case ch of
    '2':begin
          if posr<b[pos]-1 then begin
            RRamcek(pos,posr,0);
            Inc(posr);
            RRamcek(pos,posr,12);
          end;
        end;
    '8':begin
          if posr>1 then begin
            RRamcek(pos,posr,0);
            Dec(posr);
            RRamcek(pos,posr,12);
          end;
        end;
    '6':begin
          RRam(pos,0);
          Ramcek(pos,0);
          Inc(pos);
          if posr>=b[pos] then posr:=b[pos]-1;
          RRam(pos,7);
          Ramcek(pos,12);
          RRamcek(pos,posr,12);
        end;
    '4':begin
          RRam(pos,0);
          Ramcek(pos,0);
          Dec(pos);
          if posr>=b[pos] then posr:=b[pos]-1;
          RRam(pos,7);
          Ramcek(pos,12);
          RRamcek(pos,posr,12);
        end;
    end;
    until ch='5';
  NastavMenu:=pos*100+posr;
end;
end.

