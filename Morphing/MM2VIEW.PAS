program PrezerajMorphing;
uses Dos,Graph,Crt;
const maxciar=1000;
      kroky=50;
      maxciarTurbo=80; {kroky * maxciarTurbo *16 musi byt mensie ako 65520}
      gd:integer=1;
      gm:integer=2;
      cesta='d:\bp\bgi';
      pomer=2;      {koeficient zmensenia}
type ciara=record
             x1z,y1z,x2z,y2z,x1k,y1k,x2k,y2k:integer;
           end;
     dynpam=array[1..16*maxciar+256] of byte;
     TAnim=array[1..80,1..kroky] of ciara;
var akta:byte;
    pciar:array[1..255] of byte;
    c,d:array[1..maxciar] of ciara;
    PAnim:^Tanim;
    f:file;
    p:^dynpam;
    x,y,z,celk:word;
    s:string;
    ch:char;
    DirInfo:SearchRec;

procedure Morphing;
begin
  setcolor(0);
  for y:=z to z+pciar[akta]-1 do line(d[y].x1k,d[y].y1k,d[y].x2k,d[y].y2k);
  setcolor(white);
  for y:=z to z+pciar[akta]-1 do line(d[y].x1z,d[y].y1z,d[y].x2z,d[y].y2z);
  delay(20);
  for y:=z to z+pciar[akta]-1 do begin
    d[y].x1k:=d[y].x1z;
    d[y].y1k:=d[y].y1z;
    d[y].x2k:=d[y].x2z;
    d[y].y2k:=d[y].y2z;
  end;
  for y:=z to z+pciar[akta]-1 do begin
    d[y].x1z:=(c[y].x1z+((c[y].x1k-c[y].x1z)*x) div kroky)div pomer;
    d[y].y1z:=(c[y].y1z+((c[y].y1k-c[y].y1z)*x) div kroky)div pomer;
    d[y].x2z:=(c[y].x2z+((c[y].x2k-c[y].x2z)*x) div kroky)div pomer;
    d[y].y2z:=(c[y].y2z+((c[y].y2k-c[y].y2z)*x) div kroky)div pomer;
  end;
end;

{procedure TurboMorphing;
begin
  for x:=1 to kroky do
    for y:=z to z+pciar[akta]-1 do begin
      PAnim^[y,x].x1z:=c[y].x1z+((c[y].x1k-c[y].x1z)*x) div kroky;
      PAnim^[y,x].y1z:=c[y].y1z+((c[y].y1k-c[y].y1z)*x) div kroky;
      PAnim^[y,x].x2z:=c[y].x2z+((c[y].x2k-c[y].x2z)*x) div kroky;
      PAnim^[y,x].y2z:=c[y].y2z+((c[y].y2k-c[y].y2z)*x) div kroky;
    end;
  for x:=2 to kroky do begin
    setcolor(0);
    for y:=z to z+pciar[akta]-1 do line(PAnim^[y,x-1].x1k,PAnim^[y,x-1].y1k,PAnim^[y,x-1].x2k,PAnim^[y,x-1].y2k);
    setcolor(white);
    for y:=z to z+pciar[akta]-1 do line(d[y].x1z,d[y].y1z,d[y].x2z,d[y].y2z);
    delay(20);
  end;
end; }


BEGIN
 akta:=1;
  writeln('Mas tieto moznosti:');
  writeln('1 - pozeranie animacii s hodinkami');
  writeln('2 - ina animacia');
  ch:=ReadKey;
  if ch='2' then begin
    writeln('Mas tieto datove subory:');
    FindFirst('*.dat',AnyFile,DirInfo);
    Writeln(DirInfo.Name,' dlzka: ',Dirinfo.Size);
    while DosError=0 do begin
      FindNext(DirInfo);
      Writeln(DirInfo.Name,' dlzka: ',Dirinfo.Size);
    end;
    write('Zadaj nazov suboru:');
    readln(s);
  end
  else s:='hodiny.dat';
  Assign(f,s);
  celk:=0;
  GetMem(p,16*maxciar+256);
  FillChar(pciar,SizeOf(pciar),#0);
  FillChar(c,SizeOf(c),#0);
  reset(f,1);
  BlockRead(f,p^,256);
  for x:=2 to 256 do celk:=celk+p^[x];
  BlockRead(f,p^[257],celk*16);
  Move(p^[2],pciar,255);
  Move(p^[257],c,16*celk);
  BlockRead(f,p^[257+16*celk],1);
  if p^[257+16*celk]>0 then begin
    Writeln('Datovy subor je poskodeny alebo je z inej verzie programu!!!');
    Halt(1);
  end;
  if ch='2' then begin
    writeln('V subore su animacie oznacene tymito cislami: ');
    for x:=1 to 255 do if pciar[x]>0 then write(x,', ');
    writeln('Ktoru chces?');
    readln(akta);
  end;
  InitGraph(gd,gm,cesta);
  case ch of
  '1':begin
        repeat
          for x:=1 to maxciar do begin
            d[x].x1z:=c[x].x1z div pomer;
            d[x].y1z:=c[x].y1z div pomer;
            d[x].x2z:=c[x].x2z div pomer;
            d[x].y2z:=c[x].y2z div pomer;
            d[x].x1k:=c[x].x1k div pomer;
            d[x].y1k:=c[x].y1k div pomer;
            d[x].x2k:=c[x].x2k div pomer;
            d[x].y2k:=c[x].y2k div pomer;
          end;
          for celk:=1 to 10 do begin
            akta:=celk;
            z:=1;x:=1;
            while x<akta do begin
              z:=z+pciar[x];
              Inc(x);
            end;
            for x:=1 to kroky+1 do begin
            Morphing;
{            repeat until keypressed;
            readkey;}
            end;
            SetColor(0);
            for y:=z to z+pciar[akta]-1 do line(d[y].x1k,d[y].y1k,d[y].x2k,d[y].y2k);
          end;
        until KeyPressed;
      end;
  '2':begin
        z:=1;x:=1;
        while x<akta do begin
          z:=z+pciar[x];
          Inc(x);
        end;
        repeat
          for x:=1 to kroky+1 do Morphing;
          Delay(200);
          for x:=kroky+1 downto 1 do Morphing;
          Delay(200);
        until KeyPressed;
      end;
  end;
END.