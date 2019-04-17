program Kalkulacka; { 60.000 des. miest, prirodzene cisla }
{ +,- za zanedbat. cas, * 2000-cif. cisla: 38 sekund}
uses Crt;

const AttrText=14;
      AttrZvyrText=15+16;

type TCislo=array [0..59999] of ShortInt; { v kazdej polozke pola jedna cislica }

var PCislo:array[1..2] of ^TCislo;
    PomCislo:^TCislo;
    PrvNenul:array[1..2] of word; { prva nenulova cislica }
    i,j,k:word;
    l,m,n:longint;
    f:file;
    s:string;
    ch:char;
{ ----- chybove hlasenia ----- }
procedure Chyba(Cislo:word);
begin

end;
{ ----- specialny vypis textu na obrazovku ----- }
procedure Vypis(px,py:word;Retazec:string);
var pom:word;
begin
  GotoXY(px,py);
  for pom:=1 to Length(Retazec) do begin
    TextAttr:=AttrText;
    if Retazec[pom]='~' then begin
      TextAttr:=AttrZvyrText;
      Inc(Pom);
    end;
    Write(Retazec[pom]);
  end;
end;
{ ----- otazky pri Uloz / Nahraj ----- }
procedure UNDialog;
begin
  Vypis(1,6,'Ktor‚ c¡slo?  ~ ~X~  / ~ ~Y~  ');
  s[1]:=ReadKey;
  if UpCase(s[1])='X' then i:=1 else i:=2;
  Vypis(1,6,'                                 ');
  Vypis(1,6,'N zov s£boru: ');
  ReadLn(s);
  Vypis(1,6,'                                 ');
end;
{ ----- vypis (casti) cisla ----- }
procedure VypisCislo(Ktore:word);
begin
  GotoXY(1,9*Ktore-1);
  TextAttr:=AttrText;
  for i:=0 to 639 do Write(' ');
  GotoXY(1,9*Ktore-1);
  i:=PrvNenul[Ktore];
  while (i<60000) and (i<PrvNenul[Ktore]+635) do begin
    Write(Chr(PCislo[Ktore]^[i]+48));
    Inc(i);
  end;
  if i=PrvNenul[Ktore]+635 then Write(' ...');
end;
{ ----- vrati mensie z cisel PrvNenul[1/2] ----- }
function MensiaPrva:word;
begin
  if PrvNenul[1]<PrvNenul[2] then MensiaPrva:=1 else MensiaPrva:=2;
end;
{ ----- najde prvu nenulovu cislicu ----- }
procedure UrcPrvNenul(Ktore:word);
var i1:word;
begin
  i1:=0;
  while (PCislo[Ktore]^[i1]=0) and (i1<59999) do Inc(i1);
  PrvNenul[Ktore]:=i1;
end;
{ ----- prevedie cislo z formatu pola do binarneho LongInt ----- }
function PoleNaLong(Ktore:word):longint;
var l1,l2:LongInt;
    i1:word;
begin
  l1:=1;l2:=0;
  for i1:=59999 downto 59990 do begin
    Inc(l2,PCislo[Ktore]^[i1]*l1);
    if i1>59990 then l1:=l1*10;
  end;
  PoleNaLong:=l2;
end;
{ ----- HLAVNY PROGRAM ----- }

BEGIN
{ ----- inicializacia ----- }
  TextColor(15);
  TextBackGround(0);
  ClrScr;
  GetMem(PCislo[1],60000);
  GetMem(PCislo[2],60000);
  GetMem(PomCislo,60000);
  FillChar(PCislo[1]^,60000,0);
  FillChar(PCislo[2]^,60000,0);
  Vypis(1,1,'Oper cie: x ~ ~+~  y          x ~ ~!~           ~ ~U~ loz  '#13#10+
            '          x ~ ~-~  y          x ~ ~^~  y        ~ ~N~ ahraj'#13#10+
            '          x ~ ~*~  y          x ~<~=~> y        ~ ~E~ dituj'#13#10+
            '          x ~ ~/~  y                         ~ ~K~ oniec');
  Vypis(1,7, '----- X : ----------------------------------------------------------------------');
  Vypis(1,16,'----- Y : ----------------------------------------------------------------------');
  PrvNenul[1]:=59999;
  PrvNenul[2]:=59999;
  VypisCislo(1);
  VypisCislo(2);
{ ----- hlavny cyklus ----- }
  repeat
    ch:=UpCase(ReadKey);
    case ch of
      '+':begin { scitanie }
        j:=MensiaPrva;
        for i:=59999 downto j do begin
          Inc(PCislo[1]^[i],PCislo[2]^[i]);
          if PCislo[1]^[i]>9 then begin
            Dec(PCislo[1]^[i],10);
            Inc(PCislo[1]^[i-1],1);
          end;
        end;
        UrcPrvNenul(1);
        VypisCislo(1);
      end;
      '-':begin { odcitanie }
        j:=MensiaPrva;
        for i:=59999 downto j do begin
          Dec(PCislo[1]^[i],PCislo[2]^[i]);
          if PCislo[1]^[i]<0 then begin
            Inc(PCislo[1]^[i],10);
            Dec(PCislo[1]^[i-1],1);
          end;
        end;
        UrcPrvNenul(1);
        VypisCislo(1);
      end;
      '*':begin { nasobenie }
        Move(PCislo[1]^,PomCislo^,60000); { pouzije sa pomocne cislo }
        FillChar(PCislo[1]^,60000,0);
        for j:=59999 downto PrvNenul[2] do begin
          for i:=59999 downto PrvNenul[1] do begin
            l:=longint(i)+j-59999;
            Inc(PCislo[1]^[l],PomCislo^[i]*PCislo[2]^[j]);
            if PCislo[1]^[l]>9 then begin
              Inc(PCislo[1]^[l-1],PCislo[1]^[l] div 10);
              PCislo[1]^[l]:=PCislo[1]^[l] mod 10;
            end;
          end;
        end;
        UrcPrvNenul(1);
        VypisCislo(1);
      end;
      '!':begin { faktorial }
        l:=PoleNaLong(1); { do 1 mld. funguje prevod }
        FillChar(PCislo[1]^,60000,0);
        PCislo[1]^[59999]:=1;
        for m:=2 to l do begin
          for i:=59999 downto PrvNenul[1] do begin
            n:=m*PCislo[1]^[i]; { vynasob }
            k:=i;
            repeat { popripocitavaj na spravne miesta - proti pret. pri nasob.}
              Inc(PCislo[1]^[k],n mod 10);
              if PCislo[1]^[k]>9 then begin { pretecenie pri scitani }
                Dec(PCislo[1]^[k],10);
                Inc(PCislo[1]^[k-1],1);
              end;
              Dec(k);
              n:=n div 10;
            until n=0;
          end;
          UrcPrvNenul(1);
          {if PrvNenul[1]>k+1 then Halt;}
        end;
        VypisCislo(1);
      end;
      '<','=','>':begin
        Move(PCislo[1]^,PomCislo^ ,60000); { pouzije sa pomocne cislo }
        Move(PCislo[2]^,PCislo[1]^,60000);
        Move(PomCislo^, PCislo[2]^,60000);
        i:=PrvNenul[1];
        PrvNenul[1]:=PrvNenul[2];
        PrvNenul[2]:=i;
        VypisCislo(1);
        VypisCislo(2);
      end;
      'N':begin { nahratie cisla }
        UNDialog;
        FillChar(PCislo[i]^,60000,0); { najprv vymaz stare! }
        Assign(f,s);
        Reset(f,1);
        PrvNenul[i]:=60000 - FileSize(f); { nastav prvu nenulovu cislicu }
        BlockRead(f,PCislo[i]^[PrvNenul[i]],FileSize(f));
        for j:=PrvNenul[i] to 59999 do Dec(PCislo[i]^[j],48); { odcitaj 48! }
        Close(f);
        VypisCislo(i);
      end;
      'U':begin { ulozenie cisla }
        UNDialog;
        Assign(f,s);
        ReWrite(f,1);
        for j:=PrvNenul[i] to 59999 do Inc(PCislo[i]^[j],48); { pricitaj 48! }
        BlockWrite(f,PCislo[i]^[PrvNenul[i]],60000-PrvNenul[i]);
        for j:=PrvNenul[i] to 59999 do Dec(PCislo[i]^[j],48); { odcitaj 48! }
        Close(f);
        VypisCislo(i);
      end;
    end;
  until ch='K';
{ ----- ukoncenie programu ----- }
  FreeMem(PCislo[1],60000);
  FreeMem(PCislo[2],60000);
  FreeMem(PomCislo,60000);
  TextColor(15);
  TextBackGround(0);
  ClrScr;
  WriteLn('MukoSoft kalkulacka s presnostou na 60.000 des. miest, verzia 2.0'#13#10'Lubos Saloky, 1999');
END.
{ 19.5.1999, 7:45 - 9:38 }
