program Editor_textov_v_sestnastkovej_sustave;
uses Crt,Myska;
var f,ftemp:file;
    s:string;
    x:word;
    ch:char;
    Ok:boolean;
    buffer:array[0..439] of byte;

procedure ObnovHornyRiadok;
begin
  VypniKurzor;
  GotoXY(1,1);
  TextBackGround(blue);
  Writeln(' Nahraj  Uloz  Hladaj  PgUp  PgDn  Koniec                                     ');
  TextBackGround(black);
  ZapniKurzor;
end;

procedure VstupNaHornomRiadku(otazka:string;var odpoved:string);
begin
  VypniKurzor;
  GotoXY(1,1);
  writeln('                                                                                ');
  GotoXY(1,1);
  write(otazka);
  readln(odpoved);
  ObnovHornyRiadok;
  ZapniKurzor;
end;

BEGIN               { ---------- Inicializacia ---------- }
  ClrScr;
  ZapniKurzor;
  ObnovHornyRiadok;
  Ok:=False;
  repeat
    ch:=Readkey;
    case ch of
      'n':begin
{        VstupNaHornomRiadku('Zadaj n zov s£boru: ',s);}
        s:='hexedit.pas';
        Assign(f,s);
        Reset(f,480);
        BlockRead(f,buffer,1);
        for x:=0 to 439 do begin

          if buffer[x] div 16<10 then write(buffer[x] div 16)
          else write(Chr(buffer[x] div 16+55));
          if buffer[x] mod 16<10 then write(buffer[x] mod 16)
          else write(Chr(buffer[x] mod 16+55));

        end;
      end;
    end;
  until ch='k';
  VypniKurzor;
END.