program MukoSoft_upravy_Panzer_Generala;
{$DEFINE aFINAL}
uses Crt;
{$IFNDEF FINAL}  const Cesta='D:\GAMES\TRAXDATA\PANZER\';
{$ELSE}          const Cesta='';
{$ENDIF}
var f:file;
    Heslo:boolean;
    i,j,Err,ZacArmad:integer;
    ch:char;
    b:byte;
    s:string;
    Zbran:record    {NU = neznamy udaj}
      Nazov:array[1..20] of char;
      NU1,SoftA,HardA,AirA,NavA,GrD,AirD,ClD,Typ,NU2,NU3,Ini,Range,Spot,NU4,
      NU5,Mov,MaxFuel,MaxAmmo:byte;
      NU:array[1..11] of byte;
    end;
    Divizia:record
      Nazov:array[1..20] of char;
      Stat:byte;
      Typ:word;
      NU2,NU3,NU4,NU5,PosX,NU6,PosY,NU7,Strn,NU8,NU9,NU10,NU11,Ammo,Ent,NU12,
      Exper,Hviezd,NU13,NU14,NU15,Velenie,NU17,Kills,NU18,NU19:byte;
    end;{NU9, NU10 - ci ich je vidno (0 = nie, 1 = ano)}
BEGIN
  repeat
    ClrScr;
    writeln('1 - zmena technickych £dajov zbran¡'#13#10'2 - zmena poctu tahov do konca'#13#10+
            '3 - edit cia £dajov bojovych jednotiek'#13#10'4 - zmena poctu hr cov na dvoch'#13#10+
            '0 - koniec programu');
    ch:=ReadKey;
    case ch of
      '1':begin
        Heslo:=False;
        writeln('Zadaj heslo:');
        Readln(s);
        if byte(s[1])+byte(s[2])=96 then Heslo:=True;
        ChDir(Cesta+'DAT');
        Assign(f,'PanzEqup.EQP');
        Reset(f,1);
        Seek(f,2);
        repeat
          BlockRead(f,Zbran,50);
          Seek(f,FilePos(f)-50);
          ClrScr;
          with Zbran do
          writeln('Nazov:'#13#10'Soft Attack: ',SoftA,#13#10'Hard Attack: ',HardA,#13#10'Air Attack:  ',AirA,#13#10+
          'Naval Attack:',NavA,#13#10'Gnd Defense: ',GrD,#13#10'Air Defense: ',AirD,#13#10'Cl. Defense: ',ClD,#13#10'Typ:'+
          #13#10'Initiative:  ',Ini,#13#10'Range:       ',Range,#13#10'Spotting:    ',Spot,#13#10'Movement:    ',Mov,#13#10+
         'Max Fuel:    ',MaxFuel,#13#10'Max Ammo:    ',MaxAmmo,#13#10#13#10,(FilePos(f)-2) div 50,#13#10'ZXC VBN Enter Esc');
          GotoXY(14,1);
          for j:=1 to 20 do write(Zbran.Nazov[j]);
          GotoXY(14,9);
          case Zbran.Typ of
            0:writeln('Soft');
            1:writeln('Hard');
            2:writeln('Air');
          end;
          ch:=ReadKey;
          case ch of
            'z','Z':if FilePos(f)>2+100*50 then Seek(f,FilePos(f)-100*50);
            'x','X':if FilePos(f)>2+10*50 then Seek(f,FilePos(f)-10*50);
            'c','C':if FilePos(f)>2 then Seek(f,FilePos(f)-1*50);
            'v','V':if FilePos(f)<FileSize(f)-1*50 then Seek(f,FilePos(f)+1*50);
            'b','B':if FilePos(f)<FileSize(f)-10*50 then Seek(f,FilePos(f)+10*50);
            'n','N':if FilePos(f)<FileSize(f)-100*50 then Seek(f,FilePos(f)+100*50);
            #13:begin
              for i:=2 to 15 do begin
                GotoXY(14,i);
                Readln(s);
                if s<>'' then with Zbran do case i of
                  2:Val(s,SoftA,Err);
                  3:Val(s,HardA,Err);
                  4:Val(s,AirA,Err);
                  5:Val(s,NavA,Err);
                  6:Val(s,GrD,Err);
                  7:Val(s,AirD,Err);
                  8:Val(s,ClD,Err);
                  10:Val(s,Ini,Err);
                  11:Val(s,Range,Err);
                  12:Val(s,Spot,Err);
                  13:Val(s,Mov,Err);
                  14:Val(s,MaxFuel,Err);
                  15:Val(s,MaxAmmo,Err);
                end;
              end;
              write('Je to O.K.? a/n');
              ch:=ReadKey;
              if (ch in ['a','A']) and (HESLO) then begin
                BlockWrite(f,Zbran,50);
                Seek(f,FilePos(f)-50);
              end;
            end;
          end;
        until ch=#27;
        Close(f);
        ChDir('..');
      end; { case 1 }
      '2':begin
        writeln('Zadaj nazov suboru GAME.SV?');
        readln(s);
        writeln('Kolko tahov chces do konca?');
        readln(b);
        ChDir(Cesta+'SAVES');
        Assign(f,s);
        Reset(f,1);
        Seek(f,FileSize(f)-4134);
        BlockWrite(f,b,1);
        ChDir('..');
      end;
      '3':begin
        writeln('Zadaj nazov suboru GAME.SV?');
        ChDir(Cesta+'SAVES');
{$IFDEF FINAL}
        readln(s);
        Assign(f,s);
{$ELSE}
        Assign(f,'game.sv1');
{$ENDIF}
        Reset(f,1);
        ZacArmad:=FileSize(f)-24005;
        Seek(f,ZacArmad);
        repeat
          BlockRead(f,Divizia,49);
          Seek(f,FilePos(f)-49);
          ClrScr;
          with Divizia do writeln('Typ:       ',Typ,#13#10'Pozicia X: ',PosX,#13#10'Pozicia Y: ',PosY,#13#10+
          'Sila:      ',Strn,#13#10'Ammo:      ',Ammo,#13#10'Entrench:  ',Ent,#13#10'Exper.:    ',Exper,#13#10+
          'Hviezdy:   ',Hviezd,#13#10'Kills:     ',Kills,#13#10'Vlajka:    ',Stat,#13#10'Core/Aux.: ',Velenie,#13#10+
          'Meno:      ',#13#10,(FilePos(f)-(FileSize(f)-24005)) div 49,#13#10+
          'ZXC VBN Enter Esc');
          GotoXY(12,12);
          for i:=1 to 20 do write(Divizia.Nazov[i]);
          GotoXY(1,1);
          ch:=ReadKey;
          case ch of
            'z','Z':if FilePos(f)>ZacArmad+100*49 then Seek(f,FilePos(f)-100*49);
            'x','X':if FilePos(f)>ZacArmad+10*49 then Seek(f,FilePos(f)-10*49);
            'c','C':if FilePos(f)>ZacArmad then Seek(f,FilePos(f)-1*49);
            'v','V':if FilePos(f)<FileSize(f)-1*49 then Seek(f,FilePos(f)+1*49);
            'b','B':if FilePos(f)<FileSize(f)-10*49 then Seek(f,FilePos(f)+10*49);
            'n','N':if FilePos(f)<FileSize(f)-100*49 then Seek(f,FilePos(f)+100*49);
            #13:begin
              for i:=1 to 12 do begin
                GotoXY(12,i);
                Readln(s);
                if s<>'' then with Divizia do case i of
                  1:Val(s,Typ,Err);
                  2:Val(s,PosX,Err);
                  3:Val(s,PosY,Err);
                  4:Val(s,Strn,Err);
                  5:Val(s,Ammo,Err);
                  6:Val(s,Ent,Err);
                  7:Val(s,Exper,Err);
                  8:Val(s,Hviezd,Err);
                  9:Val(s,Kills,Err);
                  10:Val(s,Stat,Err);
                  11:Val(s,Velenie,Err);
                  12:begin
                    for j:=1 to Length(s) do Nazov[j]:=s[j];
                    for j:=Length(s)+1 to 20 do Nazov[j]:=#0;
                  end;
                end;
              end;
              write('Je to O.K.? a/n');
              ch:=ReadKey;
              if ch in ['a','A'] then begin
                BlockWrite(f,Divizia,49);
                Seek(f,FilePos(f)-49);
              end;
            end;
          end;
        until ch=#27;
        Close(f);
        ChDir('..');
      end; { case 3 }
      '4':begin
        writeln('Zadaj nazov suboru GAME.SV?');
        readln(s);
        ChDir(Cesta+'SAVES');
        Assign(f,s);
        Reset(f,1);
        Seek(f,FileSize(f)-4120);
        b:=0;
        BlockWrite(f,b,1);
        Close(f);
        ChDir('..');
      end; { case 4 }
    end; { case }
  until ch='0';
END.