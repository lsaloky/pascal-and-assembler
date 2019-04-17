program Graficky_efekt;
uses MainGr,Mys;
const Subor='Nove.MB';
var Obr:array[0..199,0..319] of byte absolute $A000:$0000;
    i,k,FNova,AktPal,x1,y1,x2,y2:integer;
    Tlacidla:byte;
    ch:char;
    PalP:array[1..5] of pointer;
    f:file;
procedure Semienko(x,y,Farba:integer);
var j:integer;
begin
  PolozBod(x,y,Farba);
  if (x>0) and (x<319) and (y>0) and (y<199) then begin
    for j:=1 to 2 do begin
      i:=Random(4);
      FNova:=Abs((Farba+Random(3)-1) mod 256);
      case i of
        0:if ZistiBod(x,y+1)=0 then Semienko(x,y+1,FNova);
        1:if ZistiBod(x-1,y)=0 then Semienko(x-1,y,FNova);
        2:if ZistiBod(x+1,y)=0 then Semienko(x+1,y,FNova);
        3:if ZistiBod(x,y-1)=0 then Semienko(x,y-1,FNova);
      end;
    end;
  end;
end;
BEGIN
  Randomize;
  NacitajPaletu('Prechody.MP',PalP[1]);
  NacitajPaletu('Cista.MP',PalP[2]);
  NacitajPaletu('3-3-2.MP',PalP[3]);
  NacitajPaletu('CB.MP',PalP[4]);
  InicializujGrafiku;
  AktPal:=0;
  NastavPaletu(PalP[1]);
  Semienko(160,100,100);
  ZM;
  repeat
    if JeZnak then ch:=CitajZnak;
    ZistiPoziciu(MysX,MysY,Tlacidla);
    if Tlacidla=Lave then begin
      x1:=MysX div 2;
      y1:=MysY;
      Color:=15;
      CiaraVodorovna(x1-1,y1-1,20);
      CiaraZvisla(x1-1,y1-1,20);
    end;
    if Tlacidla=Prave then begin
      x2:=MysX div 2;
      y2:=MysY;
      Color:=15;
      CiaraVodorovna(x2-19,y2+1,20);
      CiaraZvisla(x2+1,y2-19,20);
    end;
    CakajNaPustenie;
    case ch of
      #13:begin
        AktPal:=(AktPal+1) mod 4;
        NastavPaletu(PalP[AktPal+1]);
        ch:=#255;
      end;
      'u':begin
        Assign(f,Subor);
        Reset(f,1);
        Seek(f,768);
        BlockRead(f,Tlacidla,1);
        Inc(Tlacidla);
        Seek(f,768);
        BlockWrite(f,Tlacidla,1);
        Seek(f,FileSize(f));
        MysX:=x2-x1;
        MysY:=y2-y1;
        BlockWrite(f,MysX,1);
        BlockWrite(f,MysY,1);
        for k:=0 to MysY-1 do BlockWrite(f,Obr[y1+k,x1],MysX);
        Close(f);
        ch:=#255;
      end;
      #27,#255:begin end;
      else begin
        VM;
        ZmazObrazovku;
        for k:=1 to 8 do
          Semienko(20+Random(280),20+Random(160),Random(256));
        ZM;
        ch:=#255;
      end;
    end;
  until ch=#27;
  ZavriGrafiku;
  WriteLn('MukoSoft efekt'#13#10'Lubos Saloky, jul 1999');
END.
