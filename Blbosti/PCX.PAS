program Dekodovanie_obrazoveho_formatu_PCX;
uses Graph,Dos;
const c={'c:\games\descent\screen00.pcx'}'c:\games\indycar\install\ezilogo.pcx';
      cesta='d:\bp\bgi';
      gd:integer=9;
      gm:integer=2;
var f:file;
    h:array[0..127] of byte;
    b,fill:byte;
    x,y,z:integer;
BEGIN
  writeln;
  Assign(f,c);
  Reset(f,1);
  BlockRead(f,h,128);
  write('Vyrobca PCX: ');
  if h[0]<>10 then writeln('neznamy')
   else writeln('ZSoft');
  write('Verzia: ');
  case h[1] of
   0:writeln('2.5, PC PaintBrush');
   2:writeln('2.8, w/palette information');
   3:writeln('2.8, w/o palette information');
   4:writeln('PC PaintBrush for Windows');
   5:writeln('3.0 a > of PC PainthBrush, includes 24-bit .PCX files');
  end;
  write('Kodovanie: ');
  if h[2]=1 then writeln('.PCX run length encoding')
   else writeln('nezname');
  writeln('Pocet bitov na pixel:',h[3]);
  writeln('Rozmery obrazka:');
  writeln('x: od ',shortint(h[4])*256+h[5],' do ',shortint(h[6])*256+h[7]);
  writeln('y: od ',shortint(h[8])*256+h[9],' do ',shortint(h[10])*256+h[11]);
  writeln('Pocet bajtov na jeden riadok: ',h[66]);
  readln;
  InitGraph(gd,gm,cesta);
  x:=0;y:=0;
  while (not eof(f)) or (shortint(h[72])*256+h[73]>y) do begin
    BlockRead(f,b,1);
    if b<192 then begin
      PutPixel(x,y,b);
      inc(x);
    end
    else begin
      b:=b-192;
      BlockRead(f,fill,1);
      for z:=1 to b do begin
        PutPixel(x,y,fill);
        inc(x);
      end;
    end;
    if x>h[66]*3 then begin
      x:=0;
      inc(y);
    end;
  end;
  Close(f);
  readln;
END.