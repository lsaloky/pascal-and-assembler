program GIF0;{prvy pokus - "otukavanie" grafickeho formatu GIF}
const Obet:string='D:\3DSTUDIO\IMAGES\POKUS.GIF';
var f:file;
    i:integer;
    Hlavicka:record
      Oznacenie:array[1..6] of char;             {GIF87a alebo GIF89a}
      Sirka,Vyska:word;
      Popis,FarbaPozadia,PomerStran:byte;
    end;
    LPO:record
      ID:char;                                   {vzdy 2Ch = ","}
      PosX,PosY,Sirka,Vyska:word;
      Popis:byte;
    end;
    Buffer:array[0..255] of byte;
    Slovnik:array[0..9999] of word;
    Kluc:array[0..1023] of word;                 {adresa i-teho slova v Slovnik-u}
BEGIN
  if ParamCount>0 then Obet:=ParamStr(1);
  Assign(f,Obet);
  Reset(f,1);
  BlockRead(f,Hlavicka,SizeOf(Hlavicka));
  Write(#13#10#13#10#13#10'Bol nacitany obrazok ',Obet,
        #13#10#13#10'Revizia: ');
{ ----- spracovanie informacii v hlavicke ----- }
  with Hlavicka do begin
    for i:=1 to 6 do write(Oznacenie[i]);
    Write(#13#10'Sirka: ',Sirka,
          #13#10'Vyska: ',Vyska,
          #13#10'Farba pozadia: ',FarbaPozadia,
          #13#10'Farbova hlbka globalnej palety: ',(Popis and $07)+1,             { bity 0-2 }
          #13#10'Usporiadanie palety podla dolezitosti: ',boolean(Popis and $08), {      3   }
          #13#10'Pocet vyznamnych bitov palety (glob. aj lok.) : ',(Popis and $70) shr 4+1,                {      4-6 }
          #13#10'Existencia globalnej palety: ',boolean(Popis and $80),           {      7   }
          #13#10'Pomer stran obrazu: ');
    if PomerStran=0 then Write('nedefinovany')
                    else Write((PomerStran+15)/64:0:2);
  end;
{ ----- lokalny popisovac obrazu ----- }
  Write(#13#10#13#10'Lokalny popisovac obrazu c. 1:');
  i:=2 shl (Hlavicka.Popis and $07);             {mocnina 2}
  if not(boolean(Hlavicka.Popis and $80)) then i:=0;
  Seek(f,FilePos(f)+3*i);                        {posun sa o 3*2^hlbka palety}
  BlockRead(f,LPO,SizeOf(LPO));
  with LPO do begin
    if ID<>#$2C then Writeln('Chyba !!! Nenajdeny lokalny popisovac obrazu.')
    else begin
      Write(#13#10'Pozicia X: ',PosX,
            #13#10'Pozicia Y: ',PosY,
            #13#10'Sirka:     ',Sirka,
            #13#10'Vyska:     ',Vyska,
            #13#10'Existencia lokalnej palety: ',boolean(Popis and $01),
            #13#10'Prekladany GIF: ',boolean(Popis and $02),
            #13#10'Usporiadanie lokalnej palety podla dolezitosti: ',boolean(Popis and $04),
            #13#10'Farbova hlbka lokalnej palety: ',(Popis and $E0) shr 5+1);
    end;
  end;
  WriteLn;
{ ----- inicializacia slovnika ----- }
  for i:=0 to 257 do begin {256 je IC - plny slovnik, 257 je EC - koniec}
    Slovnik[i]:=i;
    Kluc[i]:=i;
  end;
  Writeln(FilePos(f),',',FileSize(f));
  BlockRead(f,Buffer,256);
{  repeat
    BlockRead(f,Buffer,1);
    Write(Buffer[0],',');
    BlockRead(f,Buffer,Buffer[0]);
  until Buffer[0]=$3B;
  Writeln(#13#10,FilePos(f),',',FileSize(f));}
  Close(f);
END.