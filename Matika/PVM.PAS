program Prieskumy_verejnej_mienky;
uses Crt;
{       Aka je pravdepodobnost, ze prieskumy verejnej mienky maju interval
  spolahlivosti ñ2% ? Riesenie simulaciou.
        Alokuje sa 8 * 50000 byte (= 3.200.000 volicov), nahodne vypln
  jednickami, aby ich bolo 25% (to je skumany jav), potom vyberaj vzorky
  po 1.000 kusoch a skumaj, ci vzorka obsahuje jednicky v intervale 23 - 27 %.
  Zaznamenaj pocet takychto vzoriek. }
const PResp=1000; {pocet respondentov prieskumu}
type TPole=array[0..49999] of byte;
var p:array[0..7] of ^TPole;
    ch:char;
    i,j:integer;
    l,m,n:longint;
    Segment,Offset,Bit:word;
    Suma,Vedla:real;
    f:file;
    Trefa:boolean;
BEGIN
  ClrScr;
  for i:=0 to 7 do GetMem(p[i],50000);
  repeat
    WriteLn(#13#10'Program PVM'#13#10'Hlavne menu:'#13#10'------------'#13#10#13#10+
            '1 - generovanie nazorov obyvatelstva (3.200.000 volicov)'#13#10+
            '2 - vypocet pravdepodobnosti, ze prieskum ma odchylku 2%'#13#10+
            '0 - koniec programu');
    repeat
      ch:=ReadKey;
    until ch in ['1','2','0'];
    case ch of
      '1':begin
{ ----- inicializacia generovania vzorky ----- }
        Randomize;
        Write('Inicializujem (9)  : ');
        for Segment:=0 to 7 do begin
          Write('°');
          for Offset:=0 to 49999 do p[Segment]^[Offset]:=0; {mazanie}
        end;
{ ----- nahodne generovanie ----- }
        Write('°'#13#10'Generujem nazory (8): ');
        for Segment:=0 to 7 do begin
          for Offset:=0 to 49999 do
            for Bit:=0 to 7 do
              if Random(4)=0 then Inc(p[Segment]^[Offset],1 shl Bit);
          Write('²');
        end;
{ ----- kontrola ----- }
        Write(#13#10'Kontrola nazorov (8): ');
        l:=0;
        for Segment:=0 to 7 do begin
          for Offset:=0 to 49999 do
            for Bit:=0 to 7 do
              if p[Segment]^[Offset] and (1 shl Bit)>0 then Inc(l);
          Write('±');
        end;
        WriteLn(' ',l,' z 3200000 su za (1), ost. proti (0)');
{ ----- dopracovanie vzorky ----- }
        Write('Dopracuvam nazory...');
        if l<800000 then { pridanie jednotiek }
          for m:=1 to 800000-l do
            repeat
              Trefa:=False;
              Segment:=Random(8);
              Offset:=Random(50000);
              Bit:=Random(8);
              if p[Segment]^[Offset] and (1 shl Bit)=0 then begin
                Inc(p[Segment]^[Offset],1 shl Bit);
                Trefa:=True;
              end;
            until Trefa;
        if l>800000 then { odobratie jednotiek }
          for m:=1 to l-800000 do
            repeat
              Trefa:=False;
              Segment:=Random(8);
              Offset:=Random(50000);
              Bit:=Random(8);
              if p[Segment]^[Offset] and (1 shl Bit)>0 then begin
                Dec(p[Segment]^[Offset],1 shl Bit);
                Trefa:=True;
              end;
            until Trefa;
{ ----- 2. kontrola ----- }
        Write(#13#10'Kontrola nazorov (8): ');
        l:=0;
        for Segment:=0 to 7 do begin
          for Offset:=0 to 49999 do
            for Bit:=0 to 7 do
              if p[Segment]^[Offset] and (1 shl Bit)>0 then Inc(l);
          Write('±');
        end;
        WriteLn(' ',l,' z 3200000 su jednotky');
{ ----- zapis vzorky ----- }
        Writeln('Zapisujem nazory ... ');
        Assign(f,'vzorka.dat');
        Reset(f,50000);
        for i:=0 to 7 do BlockWrite(f,p[i]^,1);
        Close(f);
        WriteLn('Nazory boli uspesne vygenerovane.');
      end; {case 1}
{ ----- prieskumy ----- }
      '2':begin
        Assign(f,'vzorka.dat'); { citanie vzorky }
        Reset(f,50000);
        for i:=0 to 7 do BlockRead(f,p[i]^,1);
        Close(f);
        Randomize;
        WriteLn('Kolko prieskumov vykonat?');
        ReadLn(n);
        Write('Prebieha vypocet (10): ');
        Vedla:=0;
        for l:=1 to n do begin
          Suma:=0;
          for i:=1 to PResp do begin
            Segment:=Random(8);
            Offset:=Random(50000);
            Bit:=Random(8);
            if p[Segment]^[Offset] and (1 shl Bit)>0 then Suma:=Suma+1;
          end;
          if (Suma<PResp*0.23) or (Suma>PResp*0.27) then Vedla:=Vedla+1;
          if l mod (n div 10)=0 then Write('°');
        end;
        WriteLn(#13#10'Dobrych prieskumov bolo ',100-100*Vedla/n:0:2,' percent.');
      end;
    end; {case}
  until ch='0';
{ ----- ukoncenie programu ----- }
  WriteLn(#13#10'  MukoSoft zaklad programu pre zistenie pravdepodobnosti, ze prieskum'+
          #13#10'na vzorke 0.03 % pri rozlozeni nazorov 25 % / 75 % dosiahne interval'+
          #13#10'spolahlivosti 2 %.');
  for i:=0 to 7 do FreeMem(p[i],50000);
END.